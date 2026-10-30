`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 12:00:00 PM
// Design Name: 
// Module Name: tx
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


module tx(
    input wire clk,
    input wire rst,
    input wire send,
    input wire [7:0] data,

    output wire tx_line
    );

    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state = IDLE;
    reg [2:0] bit_index = 0;
    reg [7:0] data_reg = 0;
    reg send_prev = 1;

    // clk is one baud tick. Idle and stop are high. Start is low. Data is LSB first.
    assign tx_line = (state == START) ? 1'b0 :
                     (state == DATA)  ? data_reg[bit_index] :
                     1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            bit_index <= 0;
            data_reg <= 0;
            send_prev <= 1;
        end 
        else begin
            send_prev <= send;

            if (state == IDLE) begin
                // Rising edge of send starts one frame. data is latched here.
                if (send && !send_prev) begin
                    data_reg <= data;
                    bit_index <= 0;
                    state <= START;
                end
            end else if (state == START) begin
                state <= DATA;
            end else if (state == DATA) begin
                if (bit_index == 7) begin
                    state <= STOP;
                end else begin
                    bit_index <= bit_index + 1;
                end
            end else begin
                state <= IDLE;
            end
        end
    end

endmodule
