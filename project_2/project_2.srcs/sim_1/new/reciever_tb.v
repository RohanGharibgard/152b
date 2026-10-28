`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 10:39:26 AM
// Design Name: 
// Module Name: reciever_tb
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


module reciever_tb;

    reg clk = 0;
    reg rst = 0;
    reg rx_line = 1;

    wire baud_tick;
    wire sync;
    wire [7:0] data;

    integer i;
    integer errors = 0;

    // 100 MHz clock, 9600 baud
    localparam BIT_TIME = 104160;

    always #5 clk = ~clk;

    // Clock divider
    clk_divider divider (
        .clk(clk),
        .rst(rst),
        .sync(sync),
        .baud_tick(baud_tick)
    );

    // Receiver
    reciever uut (
        .clk(clk),
        .rst(rst),
        .rx_line(rx_line),
        .baud_tick(baud_tick),
        .sync(sync),
        .data(data)
    );

    // Sends one complete UART frame
    task send_frame;
        input [7:0] value;
        input stop_bit;
        begin
            @(negedge clk);

            // Start bit
            rx_line = 0;
            #BIT_TIME;

            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx_line = value[i];
                #BIT_TIME;
            end

            // Stop bit
            rx_line = stop_bit;
            #BIT_TIME;

            rx_line = 1;
        end
    endtask

    // Verify receiver output
    task check_data;
        input [7:0] expected;
        begin
            if (data !== expected) begin
                $display("FAIL at %0t: expected %b, got %b",
                         $time, expected, data);
                errors = errors + 1;
            end
            else begin
                $display("PASS at %0t: received %b",
                         $time, data);
            end
        end
    endtask

    initial begin
        $display("Starting RX testbench");

        // Reset receiver
        rst = 1;
        #100;
        rst = 0;

        // TEST 1: Normal UART reception
        // Verify 8 serial bits are assembled correctly.
        $display("TEST 1: Normal reception");

        send_frame(8'b10100101, 1);
        check_data(8'b10100101);

        // TEST 2: Invalid start bit
        // A short LOW pulse should be ignored.
        $display("TEST 2: Invalid start bit");

        @(negedge clk);
        rx_line = 0;
        #10000;
        rx_line = 1;

        #BIT_TIME;
        check_data(8'b10100101);

        // TEST 3: Invalid stop bit
        // The receiver should reject the frame and
        // keep its previously received byte.
        $display("TEST 3: Invalid stop bit");

        send_frame(8'b01010101, 0);
        check_data(8'b10100101);

        // Allow receiver to return to IDLE
        #BIT_TIME;

        // TEST 4: Consecutive valid frames
        // Verify receiver correctly handles multiple bytes.
        $display("TEST 4: Consecutive valid frames");

        send_frame(8'b11110000, 1);
        check_data(8'b11110000);

        send_frame(8'b00001111, 1);
        check_data(8'b00001111);

        // Final results
        if (errors == 0)
            $display("All RX tests PASSED");
        else
            $display("RX tests FAILED: %0d errors", errors);

        $finish;
    end

endmodule
