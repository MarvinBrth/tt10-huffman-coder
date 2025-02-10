`default_nettype none
`timescale 1ns/1ns

module huffman_table (
    input wire [6:0] ascii,         
    output reg [9:0] huffman_code,  
    output reg [3:0] bit_length     
);

    always @(*) begin
        case (ascii)
            7'd32: begin huffman_code = 3'b111;          bit_length = 3; end // [space] → 111
            7'd101: begin huffman_code = 3'b001;         bit_length = 3; end // e → 001
            7'd116: begin huffman_code = 4'b1100;        bit_length = 4; end // t → 1100
            7'd97: begin huffman_code = 4'b1011;         bit_length = 4; end // a → 1011
            7'd105: begin huffman_code = 4'b1001;        bit_length = 4; end // i → 1001
            7'd111: begin huffman_code = 4'b1000;        bit_length = 4; end // o → 1000
            7'd110: begin huffman_code = 4'b0111;        bit_length = 4; end // n → 0111
            7'd114: begin huffman_code = 4'b0101;        bit_length = 4; end // r → 0101
            7'd115: begin huffman_code = 4'b0100;        bit_length = 4; end // s → 0100
            7'd104: begin huffman_code = 4'b0000;        bit_length = 4; end // h → 0000
            7'd108: begin huffman_code = 5'b11010;       bit_length = 5; end // l → 11010
            7'd100: begin huffman_code = 5'b10100;       bit_length = 5; end // d → 10100
            7'd99: begin huffman_code = 5'b01100;        bit_length = 5; end // c → 01100
            7'd117: begin huffman_code = 5'b00010;       bit_length = 5; end // u → 00010
            7'd109: begin huffman_code = 6'b110111;      bit_length = 6; end // m → 110111
            7'd102: begin huffman_code = 6'b110110;      bit_length = 6; end // f → 110110
            7'd112: begin huffman_code = 6'b101010;      bit_length = 6; end // p → 101010
            7'd103: begin huffman_code = 6'b011011;      bit_length = 6; end // g → 011011
            7'd121: begin huffman_code = 6'b011010;      bit_length = 6; end // y → 011010
            7'd119: begin huffman_code = 6'b000111;      bit_length = 6; end // w → 000111                                    
            7'd98: begin huffman_code = 6'b000110;       bit_length = 6; end // b → 000110
            7'd118: begin huffman_code = 7'b1010110;     bit_length = 7; end // v → 1010110
            7'd107: begin huffman_code = 8'b10101111;    bit_length = 8; end // k → 10101111
            7'd120: begin huffman_code = 10'b1010111011; bit_length = 10; end // x → 1010111011
            7'd122: begin huffman_code = 10'b1010111010; bit_length = 10; end // z → 1010111010
            7'd106: begin huffman_code = 10'b1010111001; bit_length = 10; end // j → 1010111001
            7'd113: begin huffman_code = 10'b1010111000; bit_length = 10; end // q → 1010111000
            
            
            default: begin
                huffman_code = 10'b1111111111;         // error
                bit_length = 10;                      
            end
        endcase
    end
endmodule

