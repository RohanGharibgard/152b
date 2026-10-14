`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2026 11:16:17 AM
// Design Name: 
// Module Name: input_select
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


module input_select(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [3:0] ctrl,
    output wire [15:0] adder_a,
    output wire [15:0] adder_b,
    output wire subtract,
    output wire shift_fill
    );

    wire not_ctrl0;
    wire [15:0] one;
    wire [15:0] adder_b_select;

    genvar i;

    assign one = 16'b1;

    not(not_ctrl0, ctrl[0]);
    or(subtract, not_ctrl0, ctrl[3]);

    generate
        for (i = 0; i < 16; i = i + 1) begin
            mux4 ma(a[i], a[i], a[i], 1'b0, ctrl[2:1], adder_a[i]);
            mux4 mb(b[i], b[i], one[i], a[i], ctrl[2:1], adder_b_select[i]);
            xor(adder_b[i], adder_b_select[i], subtract);
        end
    endgenerate

    and(shift_fill, a[15], ctrl[2]);

endmodule
