`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2026 10:27:53 AM
// Design Name: 
// Module Name: logical_shift_left
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


module logical_shift_left(
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [15:0] s
    );
    
    art_shift_left shifter(a, b, s);
endmodule
