`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2026 10:43:30 AM
// Design Name: 
// Module Name: zero
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


module zero(
    input wire [15:0] sub_result,
    output wire zero
    );


    nor (zero, sub_result[0], sub_result[1], sub_result[2], 
                         sub_result[3], sub_result[4], sub_result[5], 
                         sub_result[6], sub_result[7], sub_result[8],
                         sub_result[9],sub_result[10], sub_result[11], 
                         sub_result[12], sub_result[13], sub_result[14], 
                         sub_result[15]);        


endmodule
