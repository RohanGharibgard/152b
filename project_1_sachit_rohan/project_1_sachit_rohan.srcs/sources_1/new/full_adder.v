`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 10:30:28 AM
// Design Name: 
// Module Name: full_adder
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


module full_adder(
    input wire a,
    input wire b,
    input wire c_i,
    output wire c_o,
    output wire s
    );
    
    wire a_xor_b;
    wire ci_and_ab;
    wire a_and_b;
    wire c_i_and_a_xor_b;
    
    xor (a_xor_b, a, b);
    xor (s, a_xor_b, c_i);
    and (a_and_b, a, b);
    and (c_i_and_a_xor_b, c_i, a_xor_b);
    or (c_o, c_i_and_a_xor_b, a_and_b);
    
endmodule
