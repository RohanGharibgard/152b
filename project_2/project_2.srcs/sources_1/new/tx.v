`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2026 10:22:21 AM
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
    input wire baud_tick,
    output reg sync = 0,
    output reg tx_line = 1
);

    integer bit_count = 0;
    integer tick_count = 0;
    reg [1:0] state = 2'b00;
    reg [7:0] tx_data = 0;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam END   = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            bit_count <= 0;
            tick_count <= 0;
            tx_data <= 0;
            tx_line <= 1;
            sync <= 0;
        end
        else begin
            sync <= 0;

            case (state)

                IDLE: begin
                    tx_line <= 1;
                    bit_count <= 0;
                    tick_count <= 0;

                    if (send) begin
                        tx_data <= data;
                        tx_line <= 0;
                        sync <= 1;
                        state <= START;
                    end
                end

                START: begin
                    // Hold start bit LOW for one full bit
                    if (baud_tick) begin
                        if (tick_count == 1) begin
                            tick_count <= 0;
                            bit_count <= 0;
                            tx_line <= tx_data[0];
                            state <= DATA;
                        end
                        else begin
                            tick_count <= tick_count + 1;
                        end
                    end
                end

                DATA: begin
                    if (baud_tick) begin
                        if (tick_count == 1) begin
                            tick_count <= 0;

                            if (bit_count == 7) begin
                                tx_line <= 1;
                                state <= END;
                            end
                            else begin
                                bit_count <= bit_count + 1;
                                tx_line <= tx_data[bit_count + 1];
                            end
                        end
                        else begin
                            tick_count <= tick_count + 1;
                        end
                    end
                end

                END: begin
                    // Hold stop bit HIGH for one full bit
                    if (baud_tick) begin
                        if (tick_count == 1) begin
                            tick_count <= 0;
                            tx_line <= 1;
                            state <= IDLE;
                        end
                        else begin
                            tick_count <= tick_count + 1;
                        end
                    end
                end

                default: begin
                    state <= IDLE;
                    tx_line <= 1;
                end

            endcase
        end
    end
endmodule
