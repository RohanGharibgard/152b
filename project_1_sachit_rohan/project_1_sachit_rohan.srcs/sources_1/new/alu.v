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
    wire not_ctrl0;
    wire add_c_out;
    wire adder_overflow;
    wire arith_left_overflow;
    wire [15:0] one;
    wire [15:0] adder_a;
    wire [15:0] adder_b_select;
    wire [15:0] adder_b;
    wire [15:0] adder_result;
    wire [15:0] or_result;
    wire [15:0] and_result;
    wire [15:0] arith_left_result;
    wire [15:0] arith_right_result;
    wire [15:0] log_left_result;
    wire [15:0] log_right_result;
    wire [15:0] leq_result;

    wire same_sign;
    wire result_diff;

    // ctrl[3:2] picks the group, ctrl[1:0] picks the op within the group
    wire [15:0] group0;
    wire [15:0] group1;
    wire [15:0] group2;
    wire [15:0] group3;
    wire [3:0] overflow_group;

    genvar i1;
    genvar i2;

    assign one = 16'b1;

    // All arithmetic ops share one adder, computing adder_a +/- adder_b_select
    //   ctrl[2:1] = 00: a - b (sub, leq), a + b (add)
    //   ctrl[2:1] = 10: a - 1 (dec),      a + 1 (inc)
    //   ctrl[2:1] = 11: 0 - a (invert)
    // Subtract when ctrl[0] is 0, and for leq
    not(not_ctrl0, ctrl[0]);
    or(subtract, not_ctrl0, ctrl[3]);

    // Subtracting is adding the inverted value with a carry in of 1
    generate
        for (i1 = 0; i1 < 16; i1 = i1 + 1) begin
            mux4 ma(a[i1], a[i1], a[i1], 1'b0, ctrl[2:1], adder_a[i1]);
            mux4 mb(b[i1], b[i1], one[i1], a[i1], ctrl[2:1], adder_b_select[i1]);
            xor(adder_b[i1], adder_b_select[i1], subtract);
        end
    endgenerate

    sixteen_bit_adder adder(adder_a, adder_b, subtract, add_c_out, adder_result);

    // Overflows when both adder inputs have the same sign but the result doesn't
    xnor(same_sign, adder_a[15], adder_b[15]);
    xor(result_diff, adder_a[15], adder_result[15]);
    and(adder_overflow, same_sign, result_diff);

    set_less_than_or_equal leq(adder_result, adder_overflow, leq_result);

    bitwise_or bitwise_or(a, b, or_result);
    bitwise_and bitwise_and(a, b, and_result);

    art_shift_left art_shift_left(a, b, arith_left_result);
    art_shift_right art_shift_right(a, b, arith_right_result);

    logical_shift_left logical_shift_left(a, b, log_left_result);
    logical_shift_right logical_shift_right(a, b, log_right_result);

    // Arithmetic shift left overflows when the sign changes
    xor(arith_left_overflow, a[15], arith_left_result[15]);

    // 00xx: sub, add, or, and
    // 01xx: dec, inc, invert, -
    // 10xx: logical shift left, leq, logical shift right, -
    // 11xx: arith shift left, -, arith shift right, -
    generate
        for (i2 = 0; i2 < 16; i2 = i2 + 1) begin
            mux4 m0(adder_result[i2], adder_result[i2], or_result[i2], and_result[i2], ctrl[1:0], group0[i2]);
            mux4 m1(adder_result[i2], adder_result[i2], adder_result[i2], 1'b0, ctrl[1:0], group1[i2]);
            mux4 m2(log_left_result[i2], leq_result[i2], log_right_result[i2], 1'b0, ctrl[1:0], group2[i2]);
            mux4 m3(arith_left_result[i2], 1'b0, arith_right_result[i2], 1'b0, ctrl[1:0], group3[i2]);
            mux4 mout(group0[i2], group1[i2], group2[i2], group3[i2], ctrl[3:2], s[i2]);
        end
    endgenerate

    // Logical ops, leq, and arithmetic shift right never overflow
    mux4 of0(adder_overflow, adder_overflow, 1'b0, 1'b0, ctrl[1:0], overflow_group[0]);
    mux4 of1(adder_overflow, adder_overflow, adder_overflow, 1'b0, ctrl[1:0], overflow_group[1]);
    buf(overflow_group[2], 1'b0);
    mux4 of3(arith_left_overflow, 1'b0, 1'b0, 1'b0, ctrl[1:0], overflow_group[3]);
    mux4 ofout(overflow_group[0], overflow_group[1], overflow_group[2], overflow_group[3], ctrl[3:2], overflow);

    zero zero_flag(s, zero);

endmodule
