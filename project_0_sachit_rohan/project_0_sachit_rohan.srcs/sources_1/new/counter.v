`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2026 10:38:57 AM
// Design Name: 
// Module Name: counter
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


module counter_4bit(
    input wire clk,
    input wire btnU,
    
    output wire [3:0] led
    
    );
    wire output_clk;
    reg [3:0] count = 0;
    
    clk_divider divider(
        clk,
        output_clk
     );
    
    assign led = count;
    always @(posedge output_clk or posedge btnU) begin 
        if (btnU) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end 
    end
endmodule
