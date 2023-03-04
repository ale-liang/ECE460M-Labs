`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2023 01:46:42 AM
// Design Name: 
// Module Name: ButtonDebounce
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


module ButtonDebounce(
    input clk,
    input PB,
    output PB_Out
    );
    
    reg r1, r2, r3 = 0;
    wire slowClk;
    FiftyMilliSecClk s1(clk, slowClk);

    always @(posedge slowClk)
        begin
        r3 <= r2;
        end 
 
    always @(posedge clk)
        begin
        r1 <= PB;
        r2 <= r1;
        end
         
    assign PB_Out = ~r3 & r2;
    
    
endmodule

module FiftyMilliSecClk(
    input clk,
    output slowClk
    );
    
    parameter FiftyMilliSecCnt = 2500000;
    
    reg [24:0] cnt = 0;
    reg slowClkReg = 0;
    assign slowClk = slowClkReg;
    //Flips slow clk value every 25 ms, so posedge every 50 ms
    always@( posedge clk) begin
        if(cnt == FiftyMilliSecCnt) begin
            slowClkReg <= ~slowClkReg;
            cnt <= 0;
        end
        else
            cnt = cnt + 1;
    end
    
endmodule    
