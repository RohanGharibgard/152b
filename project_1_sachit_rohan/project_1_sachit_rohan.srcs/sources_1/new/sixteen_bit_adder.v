`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 10:47:05 AM
// Design Name: 
// Module Name: sixteen_bit_adder
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


module sixteen_bit_adder(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire c_in,
    output wire c_out,
    output wire [15:0] s
    
    );
    wire [15:0] c_int_out;
    genvar i;
    
    
    assign c_out = c_int_out[15];
    generate
    
        full_adder f_0 (a[0], b[0], c_in, c_int_out[0], s[0]);

        for (i = 1; i < 16; i = i + 1) begin
            full_adder f_i (a[i], b[i], c_int_out[i-1], c_int_out[i], s[i]);
        end
    endgenerate

   
endmodule
