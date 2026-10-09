`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2026 10:36:50 AM
// Design Name: 
// Module Name: sixteen_bit_subtractor
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


module sixteen_bit_subtractor(
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [15:0] s,
    output wire overflow    
    );
    wire [15:0] neg_b;
    wire invert_c_out;
    wire c_out;

    
    invert two_comp(b, neg_b);
   
    sixteen_bit_adder add(a, neg_b, 1'b0, c_out, s);
    
    wire sign_diff;
    wire result_diff;
    xor(sign_diff, a[15], b[15]);
    xor(result_diff, a[15], s[15]);
    and(overflow, sign_diff, result_diff);
endmodule
