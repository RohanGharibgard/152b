`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2026 11:35:56 AM
// Design Name: 
// Module Name: reciever
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

module reciever(
    input wire clk,
    input wire rst,
    input wire rx_line,
    input wire baud_tick,
    output reg sync = 0,
    output reg [7:0] data = 0
);

    integer bit_count = 0;
    integer tick_count = 0;
    reg [1:0] state = 2'b00;
    reg [7:0] recieved_data = 0;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam END   = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            bit_count <= 0;
            tick_count <= 0;
            recieved_data <= 0;
            data <= 0;
            sync <= 0;
        end
        else begin
            // Default: sync is only HIGH for one clock cycle
            sync <= 0;

            case (state)

                IDLE: begin
                    bit_count <= 0;
                    tick_count <= 0;

                    if (rx_line == 0) begin
                        state <= START;
                        sync <= 1;
                    end
                end

                START: begin
                    // Verify the start bit at its midpoint
                    if (baud_tick) begin
                        if (rx_line == 0) begin
                            state <= DATA;
                            tick_count <= 0;
                        end
                        else begin
                            state <= IDLE;
                        end
                    end
                end

                DATA: begin
                    if (baud_tick) begin
                        if (tick_count == 1) begin
                            // Sample one data bit every two ticks
                            recieved_data[bit_count] <= rx_line;
                            tick_count <= 0;

                            if (bit_count == 7) begin
                                bit_count <= 0;
                                state <= END;
                            end
                            else begin
                                bit_count <= bit_count + 1;
                            end
                        end
                        else begin
                            tick_count <= tick_count + 1;
                        end
                    end
                end

                END: begin
                    if (baud_tick) begin
                        if (tick_count == 1) begin
                            // Only accept data if the stop bit is valid
                            if (rx_line == 1) begin
                                data <= recieved_data;
                            end

                            tick_count <= 0;
                            state <= IDLE;
                        end
                        else begin
                            tick_count <= tick_count + 1;
                        end
                    end
                end

                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule
