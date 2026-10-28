`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2026 11:39:42 AM
// Design Name: 
// Module Name: clk_divider
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


module clk_divider(
    input wire clk,
    input wire rst,
    input wire sync,
    output reg baud_tick = 0
);

    // Clock cycles per half bit = 100 MHz / (9600 * 2)
    localparam divisor = 5208;
    reg [12:0] cnt = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 0;
            baud_tick <= 0;
        end
        else if (sync) begin
            // Restart timing when a start bit is detected
            cnt <= 0;
            baud_tick <= 0;
        end
        else if (cnt == divisor - 1) begin
            baud_tick <= 1;
            cnt <= 0;
        end
        else begin
            cnt <= cnt + 1;
            baud_tick <= 0;
        end
    end

endmodule
