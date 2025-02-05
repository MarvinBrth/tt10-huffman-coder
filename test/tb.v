`default_nettype none
`timescale 1ns / 1ps

module tb ();

  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  initial begin
    $dumpfile("tb.vcd");       // VCD-Datei für Signalanalyse
    $dumpvars(0, tb);          // Speichere alle Signale der Testbench
    #1;
  end

  // Instanziere das Design unter Test (DUT)
  tt_um_huffman_coder dut (
      .clk(clk),
      .rst_n(rst_n),
      .ena(ena),
      .ui_in(ui_in),
      .uo_out(uo_out),
      .uio_in(uio_in),
      .uio_out(uio_out),
      .uio_oe(uio_oe)
  );

endmodule

