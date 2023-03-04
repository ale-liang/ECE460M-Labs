`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2023 04:48:09 PM
// Design Name: 
// Module Name: top
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


module top(
    input CLK,
    input BUTU,
    input BUTL,
    input BUTR,
    input BUTD,
    input SW0,
    input SW1,
    output [3:0] ANODE,
    output [7:0] SEVSEG
    );
    
    wire [15:0] DISPTIME;
    wire [15:0] DOUT;
    wire TWOHUND, ZERO;
    
    Controller CTL (CLK, BUTU, BUTL, BUTR, BUTD, SW0, SW1, DISPTIME, TWOHUND, ZERO);
    BinToBCD(DISPTIME, DOUT);
    Display DSP (CLK, SW0, SW1, DOUT, TWOHUND, ZERO, ANODE, SEVSEG);
    
endmodule
