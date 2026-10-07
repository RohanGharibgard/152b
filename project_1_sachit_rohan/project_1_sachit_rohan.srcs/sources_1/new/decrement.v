`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2026 11:12:22 AM
// Design Name: 
// Module Name: decrement
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


module decrement(
    input wire [15:0] a,
    output wire [15:0] s

    );
    
    wire c_out;
    
    sixteen_bit_subtractor dec(a, 16'b1, s);
endmodule
