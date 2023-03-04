`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2023 11:37:27 AM
// Design Name: 
// Module Name: Controller_tb
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


module Controller_tb;
    reg Clk, ButtU, ButtL, ButtR, ButtD, Sw0, Sw1;
    wire [15:0] TimeLeftCnt;
    wire LessThan200, ZeroTimeLeft;

    
    localparam period = 32;
    
    Controller UUT (.Clk(Clk), .ButtU(ButtU), .ButtL(ButtL), .ButtR(ButtR), .ButtD(ButtD), .Sw0(Sw0), .Sw1(Sw1), .TimeLeftCnt(TimeLeftCnt), .LessThan200(LessThan200), .ZeroTimeLeft(ZeroTimeLeft));

    
    
    initial begin 
        ButtU = 0;
        ButtL = 0; 
        ButtR = 0; 
        ButtD = 0; 
        Sw0 = 0; 
        Sw1 = 0;
        Clk = 0;
    end
    always begin
        #10 Clk = 1'b1;
        #10 Clk = 1'b0;
    end
    
    always @(posedge Clk) begin
        #32;
        ButtU = ~ButtU;
        #32;
        ButtU = ~ButtU;
        
        #32;
        ButtL = ~ButtL;
        #32;
        ButtL = ~ButtL;

        #32;
        ButtR = ~ButtR;
        #32;
        ButtR = ~ButtR;
        
        #32;
        ButtD = ~ButtD;
        #1000;
        ButtD = ~ButtD;
        

        
        #1000;
        
        
        $display("Finished test");
        $stop;
    end
    
endmodule
