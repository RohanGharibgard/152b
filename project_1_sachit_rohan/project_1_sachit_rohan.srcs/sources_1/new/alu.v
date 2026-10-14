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

    wire add_c_out;
    wire add_overflow;
    wire sub_overflow;
    wire dec_overflow;
    wire inc_overflow;
    wire invert_overflow;
    wire arith_left_overflow;
    wire [15:0] add_result;
    wire [15:0] subtract_result;
    wire [15:0] dec_result;
    wire [15:0] inc_result;
    wire [15:0] or_result;
    wire [15:0] and_result;
    wire [15:0] invert_result;
    wire [15:0] arith_left_result;
    wire [15:0] arith_right_result;
    wire [15:0] log_left_result;
    wire [15:0] log_right_result;
    wire [15:0] leq_result;

    wire same_sign;
    wire add_result_diff;
    wire not_a15;

    // ctrl[3:2] picks the group, ctrl[1:0] picks the op within the group
    wire [15:0] group0;
    wire [15:0] group1;
    wire [15:0] group2;
    wire [15:0] group3;
    wire [3:0] overflow_group;

    genvar i;

    sixteen_bit_adder adder(a, b, 1'b0, add_c_out, add_result);
    sixteen_bit_subtractor subtractor(a, b, subtract_result, sub_overflow);

    bitwise_or bitwise_or(a, b, or_result);
    bitwise_and bitwise_and(a, b, and_result);

    decrement dec(a, dec_result, dec_overflow);
    increment inc(a, inc_result);

    invert invert(a, invert_result);

    art_shift_left art_shift_left(a, b, arith_left_result);
    art_shift_right art_shift_right(a, b, arith_right_result);

    logical_shift_left logical_shift_left(a, b, log_left_result);
    logical_shift_right logical_shift_right(a, b, log_right_result);

    set_less_than_or_equal leq(a, b, leq_result);

    // Add overflows when a and b have the same sign but the result doesn't
    xnor(same_sign, a[15], b[15]);
    xor(add_result_diff, a[15], add_result[15]);
    and(add_overflow, same_sign, add_result_diff);

    // Increment overflows going from positive to negative
    not(not_a15, a[15]);
    and(inc_overflow, not_a15, inc_result[15]);

    // Inverting INT_MIN gives back INT_MIN
    and(invert_overflow, a[15], invert_result[15]);

    // Arithmetic shift left overflows when the sign changes
    xor(arith_left_overflow, a[15], arith_left_result[15]);

    // 00xx: sub, add, or, and
    // 01xx: dec, inc, invert, -
    // 10xx: logical shift left, leq, logical shift right, -
    // 11xx: arith shift left, -, arith shift right, -
    generate
        for (i = 0; i < 16; i = i + 1) begin
            mux4 m0(subtract_result[i], add_result[i], or_result[i], and_result[i], ctrl[1:0], group0[i]);
            mux4 m1(dec_result[i], inc_result[i], invert_result[i], 1'b0, ctrl[1:0], group1[i]);
            mux4 m2(log_left_result[i], leq_result[i], log_right_result[i], 1'b0, ctrl[1:0], group2[i]);
            mux4 m3(arith_left_result[i], 1'b0, arith_right_result[i], 1'b0, ctrl[1:0], group3[i]);
            mux4 mout(group0[i], group1[i], group2[i], group3[i], ctrl[3:2], s[i]);
        end
    endgenerate

    // Logical ops, leq, and arithmetic shift right never overflow
    mux4 of0(sub_overflow, add_overflow, 1'b0, 1'b0, ctrl[1:0], overflow_group[0]);
    mux4 of1(dec_overflow, inc_overflow, invert_overflow, 1'b0, ctrl[1:0], overflow_group[1]);
    buf(overflow_group[2], 1'b0);
    mux4 of3(arith_left_overflow, 1'b0, 1'b0, 1'b0, ctrl[1:0], overflow_group[3]);
    mux4 ofout(overflow_group[0], overflow_group[1], overflow_group[2], overflow_group[3], ctrl[3:2], overflow);

    zero zero_flag(s, zero);

endmodule
