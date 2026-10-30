`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 12:00:00 PM
// Design Name: 
// Module Name: tx_tb
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


module tx_tb(

    );

    reg clk = 0;
    reg rst = 1;
    reg send = 0;
    reg [7:0] data = 8'b10110001;
    wire tx_line;

    always #5 clk = ~clk;

    tx transmitter (
        clk,
        rst,
        send,
        data,
        tx_line
    );

    initial begin

        // Test #1: Full frame of 8'b10110001
        // Wire should be: 0, 1, 0, 0, 0, 1, 1, 0, 1, 1
        // (start, data LSB first, stop)
        #20;
        rst = 0;
        #20;
        send = 1;
        #20;
        send = 0;
        #200;

        // Test #2: Reset while transmitting
        data = 8'b11110000;
        send = 1;
        #20;
        send = 0;
        #40;
        rst = 1;
        #30;
        rst = 0;
        #40;

        // Test #3: Change data while transmitting.
        // Frame should stay 8'b00001111: 0, 1, 1, 1, 1, 0, 0, 0, 0, 1
        data = 8'b00001111;
        send = 1;
        #20;
        send = 0;
        data = 8'b11110000;
        #200;

        // Test #4: Send 0x00, then 0xFF
        data = 8'h00;
        send = 1;
        #20;
        send = 0;
        #200;

        data = 8'hFF;
        send = 1;
        #20;
        send = 0;
        #200;

        $finish;

    end

endmodule
