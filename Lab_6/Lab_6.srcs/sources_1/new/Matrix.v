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
      
    wire [7:0] startMAC;
    
    reg [7:0] row0Input; //top left
    reg [7:0] col0Input;
    reg [7:0] row1Input; //middle left/top
    reg [7:0] col1Input;
    reg [7:0] row2Input; //bot left/top right
    reg [7:0] col2Input;
    
    // MAPPING OUT THE Matrix
    //        c0 c1 c2
    //     r0 00 01 02
    //     r1 10 11 12
    //     r2 20 21 22
    
    wire [7:0] r00to01, r01to02, r10to11, r11to12, r20to21, r21to22; //connections between rows
    wire [7:0] c00to10, c10to20, c01to11, c11to21, c02to12, c12to22; //connections between oolumns    
    
    //doesn't need all outputs for passing to be filled out at the end of rows and columns
    MAC m_c00(clk, row0Input, col0Input, startMAC[0], c00, r00to01, c00to10);
    MAC m_c01(clk, r00to01, col1Input, startMAC[1], c01, r01to02, c01to11);
    MAC m_c02(clk, r01to02, col2Input, startMAC[2], c02, ,c02to12); //doesn't need to pass A
    MAC m_c10(clk, row1Input, c00to10, startMAC[3], c10, r10to11, c10to20);
    MAC m_c11(clk, r10to11, c01to11, startMAC[4], c11, r11to12, c11to21); 
    MAC m_c12(clk, r11to12, c02to12, startMAC[5], c12, , c12to22); //doesn't need to pass A
    MAC m_c20(clk, row2Input, c10to20, startMAC[6], c20, r20to21, ); //doesn't need to pass B 
    MAC m_c21(clk, r20to21, c11to21, startMAC[7], c21, r21to22, ); //doesn't need to pass B
    MAC m_c22(clk, r21to22, c12to22, startMAC[8], c22, ,); //doesn't need to pass A and B
    
    
endmodule
