`default_nettype none
`timescale 1ns/1ns

module huffman_coder (
    input wire clk,                  // System clock
    input wire reset,                // Reset signal
    input wire [6:0] ascii,           // Jetzt als Eingang aus tt_um_huffman_coder
    input wire valid,                 
    input wire load,
    output reg [9:0] huffman_out,    // Huffman code output
    output reg [3:0] bit_length,     // Huffman code length
    output reg valid_out             // Valid output signal
);


    wire [9:0] code;        // Huffman code from table
    wire [3:0] length;      // Length of the Huffman code from table
    reg load_prev = 0;      
    

   

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'b00,       // Waiting for valid input
        ENCODE = 2'b01,     // Encoding ASCII character
        OUTPUT = 2'b10      // Outputting Huffman code
    } state_t;

    state_t current_state, next_state;   
    
    
    // Huffman table instantiation
    huffman_table huffman_table_inst (
        .ascii(ascii),  
        .huffman_code(code),
        .bit_length(length)
    );

     
     

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= IDLE;
        load_prev <= 0; // Reset load_prev
    end else begin
        load_prev <= load; 
        case (current_state)
            IDLE: begin
                if (valid) 
                    current_state <= ENCODE;
            end
            ENCODE: begin
                current_state <= OUTPUT;
            end
            OUTPUT: begin
                
                if (load && !load_prev) 
                    current_state <= IDLE; 
            end
        endcase
    end
end


always @(posedge clk or posedge reset) begin
    if (reset) begin
        huffman_out <= 10'b0;
        bit_length <= 4'b0;
        valid_out <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                valid_out <= 0;
            end
            ENCODE: begin
                huffman_out <= code;
                bit_length <= length;
            end
            OUTPUT: begin
                valid_out <= 1; 
            end
        endcase
        end
    end

endmodule
