`default_nettype none
`timescale 1ns/1ns

module input_manager (
    input wire clk,             // System-Takt
    input wire reset,           // Reset-Signal
    input wire [6:0] ascii_in,  // Eingabe-Daten (7-Bit ASCII)
    input wire load,            // Lade-Signal, um neue Daten zu übernehmen
    output reg [6:0] data_out,  // Ausgabedaten für die Pipeline
    output reg valid            // Signalisiert, dass die Daten gültig sind
);

    reg load_prev; // Speichert vorherigen Zustand von load

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 7'b0;    // Daten zurücksetzen
            valid <= 0;          // Validierung zurücksetzen
            load_prev <= 0;      // Reset des vorherigen Load-Werts
        end else begin
            load_prev <= load;   // Speichert den aktuellen Load-Wert für den nächsten Zyklus
            if (load && !load_prev) begin
                data_out <= ascii_in; // ASCII-Zeichen übernehmen (nur bei steigender Flanke)
                valid <= 1;          // Daten sind gültig
            end else begin
                valid <= 0;          // Daten sind nicht mehr gültig
            end
        end
    end
endmodule
