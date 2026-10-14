`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2026 11:16:17 AM
// Design Name: 
// Module Name: output_select
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


module output_select(
    input wire [3:0] ctrl,
    input wire [15:0] adder_result,
    input wire [15:0] or_result,
    input wire [15:0] and_result,
    input wire [15:0] leq_result,
    input wire [15:0] shift_left_result,
    input wire [15:0] shift_right_result,
    input wire adder_overflow,
    input wire shift_left_overflow,
    output wire [15:0] s,
    output wire overflow,
    output wire zero
    );

    wire [15:0] group0;
    wire [15:0] group1;
    wire [15:0] group2;
    wire [15:0] group3;
    wire [3:0] overflow_group;

    genvar i;

    generate
        for (i = 0; i < 16; i = i + 1) begin
            mux4 m0(adder_result[i], adder_result[i], or_result[i], and_result[i], ctrl[1:0], group0[i]);
            mux4 m1(adder_result[i], adder_result[i], adder_result[i], 1'b0, ctrl[1:0], group1[i]);
            mux4 m2(shift_left_result[i], leq_result[i], shift_right_result[i], 1'b0, ctrl[1:0], group2[i]);
            mux4 m3(shift_left_result[i], 1'b0, shift_right_result[i], 1'b0, ctrl[1:0], group3[i]);
            mux4 mout(group0[i], group1[i], group2[i], group3[i], ctrl[3:2], s[i]);
        end
    endgenerate

    mux4 of0(adder_overflow, adder_overflow, 1'b0, 1'b0, ctrl[1:0], overflow_group[0]);
    mux4 of1(adder_overflow, adder_overflow, adder_overflow, 1'b0, ctrl[1:0], overflow_group[1]);
    buf(overflow_group[2], 1'b0);
    mux4 of3(shift_left_overflow, 1'b0, 1'b0, 1'b0, ctrl[1:0], overflow_group[3]);
    mux4 ofout(overflow_group[0], overflow_group[1], overflow_group[2], overflow_group[3], ctrl[3:2], overflow);

    zero zero_flag(s, zero);

endmodule
