`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2026 11:32:43 AM
// Design Name: 
// Module Name: uart_top_level
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


module uart_top_level(
    input wire clk,
    input wire btnU,
    input wire btnC,
    input wire [7:0] sw,
    input wire rx_line,
    output wire tx_line,
    output wire [7:0] led
);

    wire tx_baud_tick;
    wire rx_baud_tick;
    wire tx_sync;
    wire rx_sync;
    wire debouncedBtnU;
    
    reg btnU_prev = 0;
    reg send = 0;


    debouncer (clk, btnU, debouncedBtnU);
    // Generate one send pulse per button rising edge
    always @(posedge clk or posedge btnC) begin
        if (btnC) begin
            btnU_prev <= 0;
            send <= 0;
        end
        else begin
            btnU_prev <= debouncedBtnU;
            send <= debouncedBtnU && !btnU_prev;
        end
    end

    // Transmitter clock divider
    clk_divider tx_divider (
        .clk(clk),
        .rst(btnC),
        .sync(tx_sync),
        .baud_tick(tx_baud_tick)
    );

    // Receiver clock divider
    clk_divider rx_divider (
        .clk(clk),
        .rst(btnC),
        .sync(rx_sync),
        .baud_tick(rx_baud_tick)
    );

    // Transmitter
    tx transmitter (
        .clk(clk),
        .rst(btnC),
        .send(send),
        .data(sw),
        .baud_tick(tx_baud_tick),
        .sync(tx_sync),
        .tx_line(tx_line)
    );

    // Receiver
    reciever receiver (
        .clk(clk),
        .rst(btnC),
        .rx_line(rx_line),
        .baud_tick(rx_baud_tick),
        .sync(rx_sync),
        .data(led)
    );

endmodule
