`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2023 05:13:54 PM
// Design Name: 
// Module Name: SecGen
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

//Module generates a pulse with a period of 1 second
module SecGen(
    input Clk,
    output Seconds
    );
    
    parameter secPeriod = 50000000;
    
    reg [25:0] cnt;
    reg secPulse;
    
    assign Seconds = secPulse;
    
    initial begin
        cnt = 0;
        secPulse = 0;
    end
    
    always@(posedge Clk) begin
        if (cnt == secPeriod) begin
            secPulse = ~secPulse;
            cnt = 1;
        end
        else
            cnt = cnt + 1;
        end
    
endmodule
