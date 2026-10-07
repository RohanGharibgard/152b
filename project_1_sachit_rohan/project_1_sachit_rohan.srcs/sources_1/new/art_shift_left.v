`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2026 11:21:19 AM
// Design Name: 
// Module Name: art_shift_left
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


module art_shift_left(
    input wire [15:0] a,
    output wire [15:0] out
    );
    
    genvar i;
    generate
        for (i = 1; i < 16; i = i +1) begin
            buf(out[i], a[i-1]);
        end
    endgenerate
    
    buf(out[0], 1'b0);
endmodule
