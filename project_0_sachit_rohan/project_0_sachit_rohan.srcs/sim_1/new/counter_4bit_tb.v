`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 10:07:13 AM
// Design Name: 
// Module Name: counter_4bit_tb
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


module counter_4bit_tb(

    );
    
    reg clk = 0;
    wire [3:0] led;
    reg btnU = 0;
    always #5 clk = ~clk;
    
    counter_4bit counter (
        clk,
        btnU,
        led
    );
    
    initial begin
    
        // Test #1: Normal Operation
        btnU = 0;
        #50
        
        // Test #2 Async Reset
        #2;
        btnU = 1;
        #2;
        btnU = 0;
        
        
        // Test #3: Overflow
        #170;
        
        //Test #4: Hold reset for multiple clock cycles
        btnU = 1;
        #30;
        btnU = 0;
        #50
        
        $finish;
        
    end

endmodule
    