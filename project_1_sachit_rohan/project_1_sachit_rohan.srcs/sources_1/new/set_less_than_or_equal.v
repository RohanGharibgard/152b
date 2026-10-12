`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2026 11:39:30 AM
// Design Name: 
// Module Name: set_less_than_or_equal
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


module set_less_than_or_equal(
    input wire [15:0] a,
    input wire [15:0] b,
    output wire s
    );
    wire [15:0] sub_result;
    wire sub_overflow;
    wire less_than;
    wire result_is_zero;

    sixteen_bit_subtractor subtractor(a, b, subtract_result, sub_overflow);
    
    nor (result_is_zero, sub_result[0], sub_result[1], sub_result[2], 
                         sub_result[3], sub_result[4], sub_result[5], 
                         sub_result[6], sub_result[7], sub_result[8],
                         sub_result[9],sub_result[10], sub_result[11], 
                         sub_result[12], sub_result[13], sub_result[14], 
                         sub_result[15]);        

    
    or(s, sub_overflow, result_is_zero);
     
endmodule
