`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 11:07:13 AM
// Design Name: 
// Module Name: debouncer
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


module debouncer(
    input clk,
    input input_signal,
    output reg debounced_signal = 0
    );

    // 100 MHz * 10 ms. The input has to stay still this long before it counts.
    reg [19:0] count = 0;
    reg last = 0;

    always @(posedge clk) begin
        if (input_signal != last) begin
            last <= input_signal;
            count <= 0;
        end else if (count < 20'd1_000_000) begin
            count <= count + 1;
        end else begin
            debounced_signal <= input_signal;
        end
    end

endmodule
