`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2026 11:33:59 AM
// Design Name: 
// Module Name: art_shift_right
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


module art_shift_right(
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [15:0] out
    );
    
    genvar i;
    generate
        for (i = 15; i > 0; i = i -1) begin
            buf(out[i-1], a[i]);
        end
    endgenerate
    
    buf(out[15], a[15]);
endmodule
