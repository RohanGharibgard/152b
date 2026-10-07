`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 11:25:15 AM
// Design Name: 
// Module Name: invert
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module invert(
    input wire [15:0] b,
    output wire [15:0] inverted_b_plus_one
    );
    
    genvar i;
    wire c_out;
    wire [15:0] inverted_b;
    generate
        for (i = 0; i < 16; i = i + 1) begin
           not(inverted_b[i], b[i]);
        end
    endgenerate
    sixteen_bit_adder add(16'b0, inverted_b, 1'b1, c_out, inverted_b_plus_one);
endmodule
