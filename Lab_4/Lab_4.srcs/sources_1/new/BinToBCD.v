`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2023 04:46:38 PM
// Design Name: 
// Module Name: BinToBCD
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


`define B0 BCD[3:0]
`define B1 BCD[7:4]
`define B2 BCD[11:8]
`define B3 BCD[15:12]

module BinToBCD(
    input[15:0] Bin,
    output [15:0] BCD 
    );
    
    reg [15:0] Breg;
    reg [15:0] BCD;
    
    integer DEC;
 
    always @(Bin)
    begin
       DEC = Bin;
       `B3 = DEC/1000;
       DEC = DEC%1000;
       `B2 = DEC/100;
       DEC = DEC%100;
       `B1 = DEC/10;
       DEC = DEC%10;
       `B0 = DEC;
    end
    
endmodule