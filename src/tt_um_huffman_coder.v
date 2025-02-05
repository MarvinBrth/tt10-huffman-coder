/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_huffman_coder (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire [9:0] huffman_out;    // Huffman code output
    wire [3:0] bit_length;     // Huffman code length
    wire valid_out;            // Valid signal
    wire reset = ~rst_n;       // Active-high reset

    // Assign outputs
    assign uo_out = huffman_out[7:0]; // Lower 8 bits of Huffman code
    assign uio_out[1:0] = huffman_out[9:8]; // Upper 2 bits of Huffman code
    assign uio_out[2] = valid_out;         // Valid signal
    assign uio_out[6:3] = bit_length[3:0];
    assign uio_out[7] = 1'b0;            // Unused outputs set to 0

    // IO Enable configuration
    assign uio_oe = 8'b11111111; // All outputs active
    
	// **Signale für die Verbindung zwischen input_manager & huffman_coder**
	wire [6:0] ascii_data;
	wire valid;

	// **Input Manager verarbeitet ASCII & Load**
	input_manager input_manager_inst (
    	.clk(clk),
    	.reset(~rst_n),
    	.ascii_in(ui_in[6:0]),  // ASCII-Teil von ui_in
    	.load(ui_in[7]),        // Load-Bit aus ui_in
    	.data_out(ascii_data),  // **ASCII an huffman_coder weitergeben**
    	.valid(valid)           // **Valid-Signal für huffman_coder**
	);

	// **Huffman-Coder empfängt ASCII-Daten & Valid-Signal**
	huffman_coder huffman_coder_inst (
    	.clk(clk),
    	.reset(~rst_n),
    	.ascii(ascii_data),      
    	.valid(valid),
    	.load(ui_in[7]),          
    	.huffman_out(huffman_out),
    	.bit_length(bit_length),
    	.valid_out(valid_out)
);

endmodule
