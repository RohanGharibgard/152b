`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2026 10:44:00 AM
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
    output reg out_clk
    
    );
    reg [27:0] counter = 0;
    localparam max_clk = 100_000_000;
    always @(posedge clk) begin
        if (counter >= max_clk / 2) begin
                out_clk <= !out_clk;
                counter <= 0;
            end
        else begin
        counter <= counter + 1;
        end
        
    end
endmodule
