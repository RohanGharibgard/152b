`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2026 11:21:19 AM
// Design Name: 
// Module Name: art_shift_left
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


module art_shift_left(
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [15:0] s
);

    wire [15:0] shift1;
    wire [15:0] stage1;

    wire [15:0] shift2;
    wire [15:0] stage2;

    wire [15:0] shift4;
    wire [15:0] stage4;

    wire [15:0] shift8;
    wire [15:0] stage8;

    wire shift_too_large;

    genvar i1;
    genvar i2;
    genvar i3;
    genvar i4;
    genvar i5;
    genvar i6;
    genvar i7;
    genvar i8;
    genvar i9;

    // Shift by 1
    generate
        for (i1 = 1; i1 < 16; i1 = i1 + 1) begin 
            buf(shift1[i1], a[i1-1]);
        end
    endgenerate

    buf(shift1[0], 1'b0);

    // Choose shift by 0 or 1
    generate
        for (i2 = 0; i2 < 16; i2 = i2 + 1) begin 
            mux2 m1(a[i2], shift1[i2], b[0], stage1[i2]);
        end
    endgenerate

    // Shift by 2
    generate
        for (i3 = 2; i3 < 16; i3 = i3 + 1) begin 
            buf(shift2[i3], stage1[i3-2]);
        end
    endgenerate

    buf(shift2[0], 1'b0);
    buf(shift2[1], 1'b0);

    // Choose shift by 0 or 2
    generate
        for (i4 = 0; i4 < 16; i4 = i4 + 1) begin 
            mux2 m2(stage1[i4], shift2[i4], b[1], stage2[i4]);
        end
    endgenerate

    // Shift by 4 
    generate
        for (i5 = 4; i5 < 16; i5 = i5 + 1) begin 
            buf(shift4[i5], stage2[i5-4]);
        end
    endgenerate

    buf(shift4[0], 1'b0);
    buf(shift4[1], 1'b0);
    buf(shift4[2], 1'b0);
    buf(shift4[3], 1'b0);
    generate
        for (i6 = 0; i6 < 16; i6 = i6 + 1) begin 
            mux2 m4(stage2[i6], shift4[i6], b[2], stage4[i6]);
        end
    endgenerate

    // Shift by 8
    generate
        for (i7 = 8; i7 < 16; i7 = i7 + 1) begin
            buf(shift8[i7], stage4[i7-8]);
        end
    endgenerate

    buf(shift8[0], 1'b0);
    buf(shift8[1], 1'b0);
    buf(shift8[2], 1'b0);
    buf(shift8[3], 1'b0);
    buf(shift8[4], 1'b0);
    buf(shift8[5], 1'b0);
    buf(shift8[6], 1'b0);
    buf(shift8[7], 1'b0);
    generate
        for (i8 = 0; i8 < 16; i8 = i8 + 1) begin 
            mux2 m8(stage4[i8], shift8[i8], b[3], stage8[i8]);
        end
    endgenerate

    // If b >= 16 result has to be 0
    or(shift_too_large,
       b[4], b[5], b[6], b[7],
       b[8], b[9], b[10], b[11],
       b[12], b[13], b[14], b[15]);

    generate
        for (i9 = 0; i9 < 16; i9 = i9 + 1) begin 
            mux2 mout(stage8[i9], 1'b0, shift_too_large, s[i9]);
        end
    endgenerate

endmodule
