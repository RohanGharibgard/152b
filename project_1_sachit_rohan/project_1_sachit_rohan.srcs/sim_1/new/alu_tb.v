`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 11:09:10 AM
// Design Name: 
// Module Name: alu_tb
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


module alu_tb();

    reg [15:0] a;
    reg [15:0] b;
    reg [3:0] ctrl;
    wire [15:0] s;
    wire overflow;
    wire zero;

    integer tests;
    integer errors;

    alu uut(a, b, ctrl, s, overflow, zero);

    // Apply one set of inputs and compare s, overflow, and zero against the expected values
    task check;
        input [3:0] t_ctrl;
        input [15:0] t_a;
        input [15:0] t_b;
        input [15:0] exp_s;
        input exp_overflow;
        begin
            ctrl = t_ctrl;
            a = t_a;
            b = t_b;
            #10;
            tests = tests + 1;
            if (s !== exp_s || overflow !== exp_overflow || zero !== (exp_s == 16'b0)) begin
                errors = errors + 1;
                $display("FAIL ctrl=%b a=%h b=%h | got s=%h overflow=%b zero=%b | expected s=%h overflow=%b zero=%b",
                         t_ctrl, t_a, t_b, s, overflow, zero, exp_s, exp_overflow, (exp_s == 16'b0));
            end
        end
    endtask

    initial begin
        tests = 0;
        errors = 0;

        // 0000 subtraction (signed)
        check(4'b0000, 16'h0005, 16'h0003, 16'h0002, 1'b0);
        check(4'b0000, 16'h0003, 16'h0005, 16'hFFFE, 1'b0);   // 3 - 5 = -2
        check(4'b0000, 16'h0007, 16'h0007, 16'h0000, 1'b0);   // zero flag
        check(4'b0000, 16'hFFFF, 16'h8000, 16'h7FFF, 1'b0);   // -1 - INT_MIN = INT_MAX
        check(4'b0000, 16'h7FFF, 16'hFFFF, 16'h8000, 1'b1);   // INT_MAX - (-1) overflows
        check(4'b0000, 16'h8000, 16'h0001, 16'h7FFF, 1'b1);   // INT_MIN - 1 underflows
        check(4'b0000, 16'h0000, 16'h8000, 16'h8000, 1'b1);   // 0 - INT_MIN overflows
        // 0001 addition (signed)
        check(4'b0001, 16'h0001, 16'h0002, 16'h0003, 1'b0);
        check(4'b0001, 16'hFFF0, 16'h0005, 16'hFFF5, 1'b0);   // -16 + 5 = -11
        check(4'b0001, 16'hFFFF, 16'h0001, 16'h0000, 1'b0);   // -1 + 1, carry out but no overflow
        check(4'b0001, 16'h7FFF, 16'h0001, 16'h8000, 1'b1);   // INT_MAX + 1 overflows
        check(4'b0001, 16'h8000, 16'hFFFF, 16'h7FFF, 1'b1);   // INT_MIN + (-1) underflows
        check(4'b0001, 16'h8000, 16'h8000, 16'h0000, 1'b1);   // INT_MIN + INT_MIN, overflow and zero

        // 0010 bitwise OR
        check(4'b0010, 16'hF0F0, 16'h0F0F, 16'hFFFF, 1'b0);
        check(4'b0010, 16'h1234, 16'h4321, 16'h5335, 1'b0);
        check(4'b0010, 16'h8000, 16'h0001, 16'h8001, 1'b0);
        check(4'b0010, 16'h0000, 16'h0000, 16'h0000, 1'b0);   // zero flag

        // 0011 bitwise AND
        check(4'b0011, 16'hFFFF, 16'h1234, 16'h1234, 1'b0);
        check(4'b0011, 16'h1234, 16'h4321, 16'h0220, 1'b0);
        check(4'b0011, 16'hF0F0, 16'h0F0F, 16'h0000, 1'b0);   // zero flag

        // 0100 decrement (b is ignored)
        check(4'b0100, 16'h0005, 16'h0000, 16'h0004, 1'b0);
        check(4'b0100, 16'h0010, 16'hFFFF, 16'h000F, 1'b0);   // b ignored
        check(4'b0100, 16'h0001, 16'h0000, 16'h0000, 1'b0);   // zero flag
        check(4'b0100, 16'h0000, 16'h0000, 16'hFFFF, 1'b0);   // 0 - 1 = -1
        check(4'b0100, 16'h8000, 16'h0000, 16'h7FFF, 1'b1);   // INT_MIN - 1 underflows

        // 0101 increment (b is ignored)
        check(4'b0101, 16'h0004, 16'h0000, 16'h0005, 1'b0);
        check(4'b0101, 16'h0000, 16'h1234, 16'h0001, 1'b0);   // b ignored
        check(4'b0101, 16'h8000, 16'h0000, 16'h8001, 1'b0);
        check(4'b0101, 16'hFFFF, 16'h0000, 16'h0000, 1'b0);   // -1 + 1, zero flag
        check(4'b0101, 16'h7FFF, 16'h0000, 16'h8000, 1'b1);   // INT_MAX + 1 overflows

        // 0110 two's complement invert (b is ignored)
        check(4'b0110, 16'h0001, 16'h0000, 16'hFFFF, 1'b0);
        check(4'b0110, 16'hFFFF, 16'h0000, 16'h0001, 1'b0);
        check(4'b0110, 16'h0005, 16'hAAAA, 16'hFFFB, 1'b0);   // b ignored
        check(4'b0110, 16'h7FFF, 16'h0000, 16'h8001, 1'b0);   // -INT_MAX
        check(4'b0110, 16'h0000, 16'h0000, 16'h0000, 1'b0);   // zero flag
        check(4'b0110, 16'h8000, 16'h0000, 16'h8000, 1'b1);   // inverting INT_MIN overflows

        // 1100 arithmetic shift left
        check(4'b1100, 16'h0001, 16'h0003, 16'h0008, 1'b0);
        check(4'b1100, 16'h1234, 16'h0000, 16'h1234, 1'b0);   // shift by 0
        check(4'b1100, 16'hFFFF, 16'h0001, 16'hFFFE, 1'b0);   // -1 << 1 = -2, sign kept
        check(4'b1100, 16'hC000, 16'h0001, 16'h8000, 1'b0);   // sign kept
        check(4'b1100, 16'h4000, 16'h0001, 16'h8000, 1'b1);   // positive to negative overflows
        check(4'b1100, 16'h8000, 16'h0001, 16'h0000, 1'b1);   // negative to zero overflows
        check(4'b1100, 16'h0003, 16'h0010, 16'h0000, 1'b0);   // shift by 16, sign kept
        check(4'b1100, 16'hFFFF, 16'h0014, 16'h0000, 1'b1);   // shift by 20, sign lost

        // 1110 arithmetic shift right
        check(4'b1110, 16'h1234, 16'h0004, 16'h0123, 1'b0);
        check(4'b1110, 16'h1234, 16'h0000, 16'h1234, 1'b0);   // shift by 0
        check(4'b1110, 16'h8000, 16'h0001, 16'hC000, 1'b0);   // sign bit fills in
        check(4'b1110, 16'hFFF0, 16'h0004, 16'hFFFF, 1'b0);
        check(4'b1110, 16'h8000, 16'h000F, 16'hFFFF, 1'b0);
        check(4'b1110, 16'h8000, 16'h0010, 16'hFFFF, 1'b0);   // shift by 16 fills with sign
        check(4'b1110, 16'h7FFF, 16'h0001, 16'h3FFF, 1'b0);
        check(4'b1110, 16'h7FFF, 16'h000F, 16'h0000, 1'b0);   // zero flag

        // 1000 logical shift left
        check(4'b1000, 16'h0001, 16'h0004, 16'h0010, 1'b0);
        check(4'b1000, 16'h1234, 16'h0000, 16'h1234, 1'b0);   // shift by 0
        check(4'b1000, 16'h1234, 16'h0008, 16'h3400, 1'b0);
        check(4'b1000, 16'h8001, 16'h0001, 16'h0002, 1'b0);   // top bit falls off
        check(4'b1000, 16'h4000, 16'h0001, 16'h8000, 1'b0);   // sign change is not overflow here
        check(4'b1000, 16'hFFFF, 16'h000F, 16'h8000, 1'b0);
        check(4'b1000, 16'hFFFF, 16'h0010, 16'h0000, 1'b0);   // shift by 16, zero flag
        check(4'b1000, 16'hFFFF, 16'h0100, 16'h0000, 1'b0);   // shift by 256

        // 1010 logical shift right
        check(4'b1010, 16'hF0F0, 16'h0004, 16'h0F0F, 1'b0);
        check(4'b1010, 16'h1234, 16'h0000, 16'h1234, 1'b0);   // shift by 0
        check(4'b1010, 16'h8000, 16'h0001, 16'h4000, 1'b0);   // zero fills in
        check(4'b1010, 16'hFFFF, 16'h0008, 16'h00FF, 1'b0);
        check(4'b1010, 16'h8000, 16'h000F, 16'h0001, 1'b0);
        check(4'b1010, 16'hFFFF, 16'h0010, 16'h0000, 1'b0);   // shift by 16, zero flag

        // 1001 set less than or equal (signed)
        check(4'b1001, 16'h0003, 16'h0005, 16'h0001, 1'b0);
        check(4'b1001, 16'h0005, 16'h0003, 16'h0000, 1'b0);   // zero flag
        check(4'b1001, 16'h0007, 16'h0007, 16'h0001, 1'b0);   // equal
        check(4'b1001, 16'hFFFF, 16'h0001, 16'h0001, 1'b0);   // -1 <= 1
        check(4'b1001, 16'h0001, 16'hFFFF, 16'h0000, 1'b0);   // 1 <= -1 is false
        check(4'b1001, 16'h8000, 16'h7FFF, 16'h0001, 1'b0);   // INT_MIN <= INT_MAX
        check(4'b1001, 16'h7FFF, 16'h8000, 16'h0000, 1'b0);   // INT_MAX <= INT_MIN is false
        check(4'b1001, 16'h8000, 16'h8000, 16'h0001, 1'b0);   // INT_MIN <= INT_MIN

        // Unused opcodes output 0
        check(4'b0111, 16'hFFFF, 16'hFFFF, 16'h0000, 1'b0);
        check(4'b1011, 16'hFFFF, 16'hFFFF, 16'h0000, 1'b0);
        check(4'b1101, 16'hFFFF, 16'hFFFF, 16'h0000, 1'b0);
        check(4'b1111, 16'hFFFF, 16'hFFFF, 16'h0000, 1'b0);

        $display("%0d tests, %0d errors", tests, errors);
        $finish;
    end

endmodule
