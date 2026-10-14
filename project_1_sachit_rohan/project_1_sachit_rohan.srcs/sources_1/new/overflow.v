`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2026 11:37:17 AM
// Design Name: 
// Module Name: overflow
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


module overflow(
    input wire [15:0] a,
    input wire [15:0] adder_a,
    input wire [15:0] adder_b,
    input wire [15:0] adder_result,
    input wire [15:0] shift_left_result,
    output wire adder_overflow,
    output wire shift_left_overflow
    );

    wire same_sign;
    wire result_diff;

    // Adder overflows when both inputs have the same sign but the result doesn't
    xnor(same_sign, adder_a[15], adder_b[15]);
    xor(result_diff, adder_a[15], adder_result[15]);
    and(adder_overflow, same_sign, result_diff);

    // Arithmetic shift left overflows when the sign changes
    xor(shift_left_overflow, a[15], shift_left_result[15]);

endmodule
