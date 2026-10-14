`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 10:27:41 AM
// Design Name: 
// Module Name: alu
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


module alu(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [3:0] ctrl,
    output wire [15:0] s,
    output wire overflow,
    output wire zero
    );

    wire subtract;
    wire shift_fill;
    wire add_c_out;
    wire adder_overflow;
    wire shift_left_overflow;
    wire [15:0] adder_a;
    wire [15:0] adder_b;
    wire [15:0] adder_result;
    wire [15:0] or_result;
    wire [15:0] and_result;
    wire [15:0] leq_result;
    wire [15:0] shift_left_result;
    wire [15:0] shift_right_result;

    input_select input_select(a, b, ctrl, adder_a, adder_b, subtract, shift_fill);

    sixteen_bit_adder adder(adder_a, adder_b, subtract, add_c_out, adder_result);

    set_less_than_or_equal leq(adder_result, adder_overflow, leq_result);

    bitwise_or bitwise_or(a, b, or_result);
    bitwise_and bitwise_and(a, b, and_result);

    shift_left shift_left(a, b, shift_left_result);
    shift_right shift_right(a, b, shift_fill, shift_right_result);

    overflow overflow_check(a, adder_a, adder_b, adder_result, shift_left_result,
                            adder_overflow, shift_left_overflow);

    output_select output_select(ctrl, adder_result, or_result, and_result, leq_result,
                                shift_left_result, shift_right_result,
                                adder_overflow, shift_left_overflow,
                                s, overflow, zero);

endmodule
