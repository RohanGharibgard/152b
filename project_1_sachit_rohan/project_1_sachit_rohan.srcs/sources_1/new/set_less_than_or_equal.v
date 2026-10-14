`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2026 11:39:30 AM
// Design Name: 
// Module Name: set_less_than_or_equal
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


module set_less_than_or_equal(
    input wire [15:0] sub_result,
    input wire sub_overflow,
    output wire [15:0] s
    );
    wire less_than;
    wire result_is_zero;

    xor(less_than, sub_result[15], sub_overflow);

    zero equal(sub_result, result_is_zero);

    or(s[0], less_than, result_is_zero);
    assign s[15:1] = 15'b0;

endmodule
