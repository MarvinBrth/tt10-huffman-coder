`default_nettype none
`timescale 1ns/1ns

module huffman_table (
    input wire [6:0] ascii,         
    output reg [9:0] huffman_code,  
    output reg [3:0] bit_length     
);

    always @(*) begin
        case (ascii)
            7'd32: begin huffman_code = 3'b111;        bit_length = 3; end // [space] → 111
            7'd101: begin huffman_code = 3'b010;       bit_length = 3; end // e → 010
            7'd116: begin huffman_code = 4'b1101;      bit_length = 4; end // t → 1101
            7'd97: begin huffman_code = 4'b1011;       bit_length = 4; end // a → 1011
            7'd111: begin huffman_code = 4'b1001;      bit_length = 4; end // o → 1001
            7'd105: begin huffman_code = 4'b1000;      bit_length = 4; end // i → 1000
            7'd110: begin huffman_code = 4'b0111;      bit_length = 4; end // n → 0111
            7'd115: begin huffman_code = 4'b0011;      bit_length = 4; end // s → 0011
            7'd104: begin huffman_code = 4'b0010;      bit_length = 4; end // h → 0010
            7'd114: begin huffman_code = 4'b0001;      bit_length = 4; end // r → 0001
            7'd108: begin huffman_code = 5'b10101;     bit_length = 5; end // l → 10101
            7'd100: begin huffman_code = 5'b01101;     bit_length = 5; end // d → 01101
            7'd117: begin huffman_code = 5'b00000;     bit_length = 5; end // u → 00000
            7'd102: begin huffman_code = 6'b110011;    bit_length = 6; end // f → 110011
            7'd109: begin huffman_code = 6'b110010;    bit_length = 6; end // m → 110010
            7'd119: begin huffman_code = 6'b110001;    bit_length = 6; end // w → 110001
            7'd121: begin huffman_code = 6'b101001;    bit_length = 6; end // y → 101001
            7'd112: begin huffman_code = 6'b101000;    bit_length = 6; end // p → 101000
            7'd103: begin huffman_code = 6'b011001;    bit_length = 6; end // g → 011001
            7'd98: begin huffman_code = 6'b011000;     bit_length = 6; end // b → 011000
            7'd118: begin huffman_code = 6'b111111;    bit_length = 6; end // v → 111111
            7'd107: begin huffman_code = 6'b111110;    bit_length = 6; end // k → 111110
            7'd120: begin huffman_code = 8'b11000011;  bit_length = 8; end // x → 11000011
            7'd106: begin huffman_code = 8'b11000010;  bit_length = 8; end // j → 11000010
            7'd113: begin huffman_code = 8'b11000001;  bit_length = 8; end // q → 11000001
            7'd122: begin huffman_code = 9'b110000010; bit_length = 9; end // z → 110000010
            default: begin
                huffman_code = 10'b1100000101;         // error
                bit_length = 10;                      
            end
        endcase
    end
endmodule

