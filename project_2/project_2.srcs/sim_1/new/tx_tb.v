`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 10:29:16 AM
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


module tx_tb;

    reg clk = 0;
    reg rst = 0;
    reg send = 0;
    reg [7:0] data = 0;

    wire baud_tick;
    wire sync;
    wire tx_line;

    integer i;
    integer errors = 0;

    localparam BIT_TIME = 104160;

    // 100 MHz clock
    always #5 clk = ~clk;

    clk_divider divider (
        .clk(clk),
        .rst(rst),
        .sync(sync),
        .baud_tick(baud_tick)
    );

    tx uut (
        .clk(clk),
        .rst(rst),
        .send(send),
        .data(data),
        .baud_tick(baud_tick),
        .sync(sync),
        .tx_line(tx_line)
    );

    // Compare the actual TX bit with the expected bit
    task check_bit;
        input expected;
        begin
            if (tx_line !== expected) begin
                $display("FAIL at %0t: expected %b, got %b",
                         $time, expected, tx_line);
                errors = errors + 1;
            end
        end
    endtask

    // Send a byte and verify the complete 8N1 frame
    task test_frame;
        input [7:0] value;
        input change_input;
        begin
            @(negedge clk);
            data = value;
            send = 1;

            @(negedge clk);
            send = 0;

            // Sample start bit at its midpoint
            #(BIT_TIME / 2);
            check_bit(0);

            // EDGE CASE: Change switches during transmission
            // TX should continue sending the original byte.
            if (change_input)
                data = ~value;

            // Check all 8 data bits, LSB first
            for (i = 0; i < 8; i = i + 1) begin
                #BIT_TIME;
                check_bit(value[i]);
            end

            // Check stop bit
            #BIT_TIME;
            check_bit(1);

            // Wait until transmission is finished
            #BIT_TIME;
            check_bit(1);
        end
    endtask

    initial begin
        $display("Starting TX testbench");

        rst = 1;
        #100;
        rst = 0;

        // TEST 1: Normal UART transmission
        // Verify start, 8 data bits, and stop.
        $display("TEST 1: Normal transmission");
        test_frame(8'b10100101, 0);

        // TEST 2: Input changes during transmission
        // Transmitted byte should not change.
        $display("TEST 2: Input changes");
        test_frame(8'b11001010, 1);

        // TEST 3: Reset during transmission
        // TX should immediately return to idle HIGH.
        $display("TEST 3: Reset mid-transmission");

        @(negedge clk);
        data = 8'b00000000;
        send = 1;

        @(negedge clk);
        send = 0;

        #(BIT_TIME * 2);

        rst = 1;
        #20;
        check_bit(1);

        rst = 0;
        #BIT_TIME;
        check_bit(1);

        if (errors == 0)
            $display("All TX tests PASSED");
        else
            $display("TX tests FAILED: %0d errors", errors);

        $finish;
    end
endmodule
