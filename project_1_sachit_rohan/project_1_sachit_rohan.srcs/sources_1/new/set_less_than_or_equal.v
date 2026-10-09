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
    wire [15:0] subtract_result;
    wire sub_overflow;
    wire less_than;
    sixteen_bit_subtractor subtractor(a, b, subtract_result, sub_overflow);
     
endmodule
