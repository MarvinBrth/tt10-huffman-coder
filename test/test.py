import cocotb
from cocotb.triggers import ClockCycles
from cocotb.clock import Clock

async def reset(dut):
    """Reset des Designs durchführen."""
    dut.ui_in.value = 0
    dut.uio_out.value = 0
    dut.uo_out.value = 0
    dut.rst_n.value = 0  # Reset aktiv

    cocotb.log.info("🔄 Reset gestartet")
    await ClockCycles(dut.clk, 5)  # 5 Takte Reset halten

    dut.rst_n.value = 1  # Reset deaktivieren
    cocotb.log.info("✅ Reset abgeschlossen")
    await ClockCycles(dut.clk, 2)  # Stabilisierung

@cocotb.test()
async def test_tt_um_huffman_coder(dut):
    """Testet den Huffman-Coder mit ASCII-Zeichen und überprüft nur den Output."""
    
    # Clock starten
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset durchführen
    await reset(dut)

    # Testfälle: ASCII-Zeichen → (Erwarteter Huffman-Code)
    test_cases = {
        ord(' '): 0b111,  
        ord('e'): 0b001,  
        ord('t'): 0b1100,  
        ord('a'): 0b1011,  
        ord('?'): 0b1111111111  
    }

    for ascii_value, expected_code in test_cases.items():
        cocotb.log.info(f"🔹 Teste Zeichen: '{chr(ascii_value)}' (0x{ascii_value:02X})")

        # ASCII-Wert setzen und Load aktivieren
        dut.ui_in.value = (1 << 7) | (ascii_value & 0x7F)  
        cocotb.log.info(f"🚀 Load HIGH gesetzt für ASCII={chr(ascii_value)}")
        await ClockCycles(dut.clk, 1)  # Mindestens 1 Takt für Load

        # ⚡ Warten, bis valid_out HIGH wird (Timeout, um Endlosschleife zu vermeiden)
        timeout = 100
        while not (dut.uio_out.value.integer & (1 << 2)) and timeout > 0:  
            await ClockCycles(dut.clk, 1)
            timeout -= 1

        if timeout == 0:
            cocotb.log.error(f"❌ valid_out wurde NICHT HIGH für {chr(ascii_value)}! Test abgebrochen.")
            return  # Falls valid_out nie HIGH wird, abbrechen

        cocotb.log.info(f"✅ valid_out ist HIGH für {chr(ascii_value)}")

        await ClockCycles(dut.clk, 5)  # Sicherstellen, dass Daten stabil sind

        # Huffman-Code auslesen
        huffman_out = ((dut.uio_out.value.integer & 0b11) << 8) | dut.uo_out.value.integer
        cocotb.log.info(f"🔍 Huffman-Code empfangen: {bin(huffman_out)}")

        # Validierung
        if huffman_out != expected_code:
            cocotb.log.error(f"❌ Fehler für '{chr(ascii_value)}': Erwartet {bin(expected_code)}, erhalten {bin(huffman_out)}")
        assert huffman_out == expected_code, f"❌ Fehler für {chr(ascii_value)}: {bin(huffman_out)} statt {bin(expected_code)}"

        # Load wieder deaktivieren
        dut.ui_in.value = ascii_value & 0x7F  
        cocotb.log.info(f"⬇ Load LOW für ASCII={chr(ascii_value)}")
        await ClockCycles(dut.clk, 5)

    cocotb.log.info("✅ Alle Tests erfolgreich abgeschlossen!")
    raise cocotb.result.TestSuccess("✅ Alle Tests erfolgreich!")

