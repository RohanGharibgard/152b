`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2026 10:18:51 AM
// Design Name: 
// Module Name: bitwise_and
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


module bitwise_and(
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [15:0] s

    );
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            and(s[i], a[i], b[i]);
        end
    endgenerate
endmodule
