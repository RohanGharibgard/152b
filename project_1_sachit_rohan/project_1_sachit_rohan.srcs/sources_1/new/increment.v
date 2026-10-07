`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2026 10:47:37 AM
// Design Name: 
// Module Name: increment
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


module increment(
    input wire [15:0] a,
    output wire [15:0] s

    );
    
    wire c_out;
    
    sixteen_bit_adder inc(a, 16'b0, 1'b1, c_out, s);
endmodule
