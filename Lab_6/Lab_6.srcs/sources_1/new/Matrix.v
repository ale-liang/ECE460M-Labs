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
    output [7:0] M1_out,
    output [7:0] M2_out,
    output [7:0] M3_out,
    output [7:0] M4_out,
    output [7:0] M5_out,
    output [7:0] M6_out,
    output [7:0] M7_out,
    output [7:0] M8_out,
    output [7:0] M9_out,
    output reg done
    );
      
    reg [8:0] startMAC;
    reg [2:0] cs; //state
    reg [7:0] row0Input; //top left
    reg [7:0] col0Input;
    reg [7:0] row1Input; //middle left/top
    reg [7:0] col1Input;
    reg [7:0] row2Input; //bot left/top right
    reg [7:0] col2Input;
    
    reg [1:0] wait3Cycles;
    
    reg [5:0] clkCnt;
    reg slowClk;
    
    always@(posedge clk) begin
        if(clkCnt == 20) begin
            slowClk = ~slowClk;
            clkCnt = 0;
        end else begin
            clkCnt = clkCnt + 1;
        end    
    end
    // MAPPING OUT THE Matrix
    //        c0 c1 c2
    //     r0 00 01 02
    //     r1 10 11 12
    //     r2 20 21 22
    
    wire [7:0] r00to01, r01to02, r10to11, r11to12, r20to21, r21to22; //connections between rows
    wire [7:0] c00to10, c10to20, c01to11, c11to21, c02to12, c12to22; //connections between oolumns    
    
    //doesn't need all outputs for passing to be filled out at the end of rows and columns
    MAC m_c00(clk, row0Input, col0Input, startMAC[0], M1_out, r00to01, c00to10);
    MAC m_c01(clk, r00to01, col1Input, startMAC[1], M2_out, r01to02, c01to11);
    MAC m_c02(clk, r01to02, col2Input, startMAC[2], M3_out, ,c02to12); //doesn't need to pass A
    MAC m_c10(clk, row1Input, c00to10, startMAC[3], M4_out, r10to11, c10to20);
    MAC m_c11(clk, r10to11, c01to11, startMAC[4], M5_out, r11to12, c11to21); 
    MAC m_c12(clk, r11to12, c02to12, startMAC[5], M6_out, , c12to22); //doesn't need to pass A
    MAC m_c20(clk, row2Input, c10to20, startMAC[6], M7_out, r20to21, ); //doesn't need to pass B 
    MAC m_c21(clk, r20to21, c11to21, startMAC[7], M8_out, r21to22, ); //doesn't need to pass B
    MAC m_c22(clk, r21to22, c12to22, startMAC[8], M9_out, ,); //doesn't need to pass A and B
    
    
    initial begin
        startMAC = 0;
        row0Input = 0;
        row1Input = 0;
        row2Input = 0;
        col0Input = 0;
        col1Input = 0;
        col2Input = 0;
        cs = 0;
        slowClk = 0;
        clkCnt = 0;
        wait3Cycles = 0;
        done = 0;
    end
    
    always@(posedge clk) begin
        case(cs)
        0: begin // reset/initial state
            startMAC <= 0;
            row0Input <= 0;
            row1Input <= 0;
            row2Input <= 0;
            col0Input <= 0;
            col1Input <= 0;
            col2Input <= 0;
            wait3Cycles = 0;
            done <= 0;
            if(start) begin
                cs <= 1;
            end else begin
                cs <= 0;
            end    
        end
        1: begin // begin feeding values into MAC
            row0Input <= a00;
            row1Input <= 0;
            row2Input <= 0;
            col0Input <= b00;
            col1Input <= 0;
            col2Input <= 0;
            startMAC[0] <= 1;
            cs <= 2;
        end
        2: begin
            row0Input <= a01;
            row1Input <= a10;
            row2Input <= 0;
            col0Input <= b10;
            col1Input <= b01;
            col2Input <= 0;
            startMAC[1] <= 1;
            startMAC[3] <= 1;
            cs <= 3;
        end
        3: begin
            row0Input <= a02;
            row1Input <= a11;
            row2Input <= a20;
            col0Input <= b20;
            col1Input <= b11;
            col2Input <= b02;
            startMAC[2] <= 1;
            startMAC[4] <= 1;
            startMAC[6] <= 1;
            cs <= 4;
        end
        4: begin
            row0Input <= 0;
            row1Input <= a12;
            row2Input <= a21;
            col0Input <= 0;
            col1Input <= b21;
            col2Input <= b12;
            startMAC[5] <= 1;
            startMAC[7] <= 1;
            cs <= 5;
        end
        5: begin
            row0Input <= 0;
            row1Input <= 0;
            row2Input <= a22;
            col0Input <= 0;
            col1Input <= 0;
            col2Input <= b22;
            startMAC[8] <= 1;
            cs <= 6;
        end
        6: begin
            row0Input <= 0;
            row1Input <= 0;
            row2Input <= 0;
            col0Input <= 0;
            col1Input <= 0;
            col2Input <= 0;
            startMAC <= 9'b111111111;
            cs <= 6;
            if (wait3Cycles == 3) begin
                cs <= 7;
            end else begin
                wait3Cycles <= wait3Cycles + 1;
                cs <= 6;
            end
        end
        7: begin
            done <= 1'b1;
            wait3Cycles <= 0;
            startMAC <= 0;
            if(start) begin
                cs <= 0;
            end else begin
                cs <= 7;
            end
            
        end
        default: begin
            cs <= 0;
        end
    endcase    
    end
    
endmodule
