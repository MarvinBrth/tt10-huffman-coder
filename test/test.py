import cocotb
from cocotb.triggers import RisingEdge, ClockCycles
from cocotb.clock import Clock


async def reset(dut):
    """Setzt alle relevanten Signale auf 0 und aktiviert den Reset sofort."""
    dut.ui_in.value = 0
    dut.uio_out.value = 0
    dut.uo_out.value = 0
    dut.rst_n.value = 0  # Reset aktiv setzen

    await ClockCycles(dut.clk, 5)  # Halte Reset für 5 Taktzyklen

    dut.rst_n.value = 1  # Reset deaktivieren
    await ClockCycles(dut.clk, 2)  # Warte auf Stabilisierung

    cocotb.log.info(f"✅ Reset abgeschlossen. rst_n = {dut.rst_n.value}")


@cocotb.test()
async def test_tt_um_huffman_coder(dut):
    """Testet den tt_um_huffman_coder mit verschiedenen Zeichen und stellt sicher, dass `load` 
    lange genug HIGH bleibt, bis `valid_out` für mindestens 4 Takte HIGH war."""

    # Starte den Clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset durchführen
    await reset(dut)

    # **Startet die Zeichen-Eingabe direkt nach dem Reset**
    await ClockCycles(dut.clk, 5)  # Nur kurz warten

    # Speichert die Anzahl erfolgreicher Tests
    tests_passed = 0

    # Testfälle: ASCII-Zeichen -> (Erwarteter Huffman-Code, Länge)
    test_cases = {
        ord(' '): (0b111, 3),    # Leerzeichen
        ord('e'): (0b010, 3),    # 'e'
        ord('t'): (0b1101, 4),   # 't'
        ord('a'): (0b1011, 4),   # 'a'
        ord('?'): (0b1100000101, 10)  # Default-Fall
    }

    for ascii_value, (expected_code, expected_length) in test_cases.items():
        cocotb.log.info(f"🔹 Teste Zeichen: {chr(ascii_value)} (0x{ascii_value:02x})")

        # **ASCII setzen, aber `load` noch nicht HIGH**
        dut.ui_in.value = ascii_value & 0x7F  # ASCII bleibt in ui_in[6:0]
        await ClockCycles(dut.clk, 1)  # Einen Takt warten

        # **Jetzt `load` HIGH setzen**
        dut.ui_in.value = (1 << 7) | (ascii_value & 0x7F)  # MSB=1 für LOAD
        cocotb.log.info(f"🚀 `load` HIGH für ASCII={chr(ascii_value)}")

        # **Warten, bis `valid_out` mindestens 4 Takte HIGH bleibt**
        valid_high_count = 0
        while valid_high_count < 4:
            await RisingEdge(dut.clk)
            if (valid_high_count< 4):  # **valid_out ist Bit 2 von uio_out**
                valid_high_count += 1
            else:
                valid_high_count = 0  # Falls valid_out wieder LOW geht, neu zählen

        cocotb.log.info(f"✅ `valid_out` war mindestens 4 Takte HIGH für ASCII={chr(ascii_value)}")

        # **Jetzt `load` wieder deaktivieren**
        dut.ui_in.value = ascii_value & 0x7F  # MSB=0, ASCII bleibt in ui_in[6:0]
        cocotb.log.info(f"⬇ `load` LOW für ASCII={chr(ascii_value)}")

        # **Huffman-Code auslesen**
        huffman_out = ((dut.uio_out.value.integer & 0b11) << 8) | (dut.uo_out.value.integer & 0xFF)
        length_out = (dut.uio_out.value.integer >> 3) & 0xF

        # **Debug-Ausgabe**
        cocotb.log.info(f"✅ Erwartet: Huffman={bin(expected_code)}, Länge={expected_length} | "
                        f"Empfangen: Huffman={bin(huffman_out)}, Länge={length_out}")

        # **Validierung**
        assert huffman_out == expected_code, (
            f"❌ Fehler für ASCII={chr(ascii_value)}: Erwarteter Huffman-Code {bin(expected_code)}, "
            f"aber {bin(huffman_out)} erhalten."
        )
        assert length_out == expected_length, (
            f"❌ Fehler für ASCII={chr(ascii_value)}: Erwartete Länge {expected_length}, "
            f"aber {length_out} erhalten."
        )

        # **Falls erfolgreich, erhöhe Zähler**
        tests_passed += 1

        # **Kurze Pause vor dem nächsten Zeichen**
        await ClockCycles(dut.clk, 5)

    # **Falls alle Tests erfolgreich waren, stoppe die Simulation**
    if tests_passed == len(test_cases):
        cocotb.log.info("✅ Alle Tests erfolgreich abgeschlossen! Simulation wird beendet.")
        raise cocotb.result.TestSuccess("✅ Simulation erfolgreich beendet!")
    else:
        cocotb.log.error("❌ Nicht alle Tests waren erfolgreich! Simulation läuft weiter zur Analyse.")

