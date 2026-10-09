`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2026 10:18:24 AM
// Design Name: 
// Module Name: mux2
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


module mux2(
    input wire a,
    input wire b,
    input wire sel,
    output wire y
    
    );
    
    wire nsel;
    wire r1;
    wire r2;
    not(nsel, sel);
    
    and(r1, nsel, a);
    and(r2, sel, b);
    or(y, r1, r2);
    
    
    
endmodule
