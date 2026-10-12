`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 11:09:10 AM
// Design Name: 
// Module Name: alu_tb
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


module alu_tb(
    output output_carry,
    output wire [15:0] output_number

    );
    wire zero_result;
    sixteen_bit_adder test_one(16'b0000000000000001, 16'b0000000000000010, 0, output_carry, output_number);


    zero zero(16'b0, zero_result);
    assert (zero_result == 1)

    zero zero2(16'b01101010101, zero_result);
    assert 

endmodule
