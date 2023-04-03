`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2023 12:09:25 AM
// Design Name: 
// Module Name: Matrix
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


module Matrix(
    input clk,
    input start,
    input reset,
    input [7:0] a00,
    input [7:0] a01,
    input [7:0] a02,
    input [7:0] a10,
    input [7:0] a11,
    input [7:0] a12,
    input [7:0] a20,
    input [7:0] a21,
    input [7:0] a22,
    input [7:0] b00,
    input [7:0] b01,
    input [7:0] b02,
    input [7:0] b10,
    input [7:0] b11,
    input [7:0] b12,
    input [7:0] b20,
    input [7:0] b21,
    input [7:0] b22,    
    output [7:0] c00,
    output [7:0] c01,
    output [7:0] c02,
    output [7:0] c10,
    output [7:0] c11,
    output [7:0] c12,
    output [7:0] c20,
    output [7:0] c21,
    output [7:0] c22,
    output reg done
    );
    
    wire [7:0] a[2:0][2:0];
    wire [7:0] b[2:0][2:0];
    
endmodule
