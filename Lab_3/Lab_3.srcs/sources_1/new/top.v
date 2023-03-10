`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2023 04:05:39 PM
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
    input START,
    input CLK,
    input RESET,
    input [1:0] MODE,
    output SI,
    output [3:0] ANODE,
    output [7:0] SEVSEG
    );
    
    wire POUT; 
    wire [15:0] DOUT;
    wire DMILES;
    
    PulseGen PG (START, MODE, CLK, POUT);
    FitbitTracker FT (START, CLK, POUT, RESET, DOUT, SI, DMILES);
    Display DM (DOUT, CLK, RESET, DMILES, ANODE, SEVSEG);
    
    
endmodule
