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
    output debounced_signal
    );
    
    reg [32:0] history = 0;
    reg debounced;
    
    assign debounced_signal = history == 32'hFFFF;
    
    always @ (posedge clk) begin
        history <= {history[1:0], input_signal};
    end
    
    
endmodule
