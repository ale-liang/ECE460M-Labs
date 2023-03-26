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


`define B0 Hex_reg[3:0]
`define B1 Hex_reg[7:4]
`define B2 Hex_reg[11:8]
`define B3 Hex_reg[15:12]

module BinToHex(
    input[15:0] Bin,
    output [15:0] BCD 
    );
    
    reg [15:0] BCD_reg;
    
    integer DEC;
    
    assign BCD = BCD_reg;
 
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