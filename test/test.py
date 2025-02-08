import cocotb
from cocotb.triggers import ClockCycles
from cocotb.clock import Clock

async def reset(dut):
    """Reset des Designs durchführen."""
    dut.ui_in.value = 0
    dut.uio_out.value = 0
    dut.uo_out.value = 0
    dut.rst_n.value = 0  # Reset aktiv

    await ClockCycles(dut.clk, 5)  # 5 Takte Reset halten

    dut.rst_n.value = 1  # Reset deaktivieren
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
        ord('e'): 0b010,  
        ord('t'): 0b1101,  
        ord('a'): 0b1011,  
        ord('?'): 0b1100000101  
    }

    for ascii_value, expected_code in test_cases.items():
        # ASCII-Wert setzen und Load aktivieren
        dut.ui_in.value = (1 << 7) | (ascii_value & 0x7F)  
        await ClockCycles(dut.clk, 1)  # Mindestens 1 Takt für Load

        # ⚡ Warten, damit der Huffman-Coder das Zeichen verarbeiten kann
        
        while not (dut.uio_out.value.integer & (1 << 2)):  
             await ClockCycles(dut.clk, 1)  
        
        await ClockCycles(dut.clk, 5)
        # Huffman-Code auslesen
        huffman_out = ((dut.uio_out.value.integer & 0b11) << 8) | (dut.uo_out.value.integer & 0xFF)

        # Validierung
        assert huffman_out == expected_code, f"❌ Fehler für {chr(ascii_value)}: {bin(huffman_out)} statt {bin(expected_code)}"

        # Load wieder deaktivieren
        dut.ui_in.value = ascii_value & 0x7F  
        await ClockCycles(dut.clk, 5)

    raise cocotb.result.TestSuccess("✅ Alle Tests erfolgreich!")

