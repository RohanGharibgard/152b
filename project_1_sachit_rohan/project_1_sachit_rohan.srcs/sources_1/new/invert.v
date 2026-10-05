`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 11:25:15 AM
// Design Name: 
// Module Name: invert
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


module invert(
    input wire [15:0] b,
    output wire [15:0] inverted_b
    
    );
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
           assign inverted_b[i] = ~b[i];
        end
    endgenerate
endmodule
