`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2023 09:47:29 PM
// Design Name: 
// Module Name: top_tb
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


module top_tb;
    reg clk;
    reg[3:0] btns;
    reg[7:0] swtchs;
    wire[7:0] leds;
    wire[6:0] segs;
    wire[3:0] an;
    
    top UUT (.clk(clk), .btns(btns), .swtchs(swtchs), .leds(leds), .segs(segs), .an(an));
    
    always begin
        #10 clk = 1'b1;
        #10 clk = 1'b0;
    end
    
    always @(posedge clk) begin
        btns = 0;
        swtchs = 0;
        #32;
        btns[3] = 1;
        btns[1] = 1;
        #10;
        btns = 0;
        #32;
        swtchs[1] = 1;
        swtchs[4] = 1;
        swtchs[7] = 1;
        #10;
        btns[0] = 1;
        #10;
        btns = 0;
        #32;
        swtchs[1] = 0;
        swtchs[4] = 0;
        swtchs[7] = 0;
        swtchs[0] = 1;
        swtchs[2] = 1;
        swtchs[5] = 1;
        #10;
        btns[0] =1;
        #10;
        btns = 0;
        swtchs = 0;
        #10;
        btns[2] = 1;
        btns[0] = 1;
        #10;
        btns = 0;
        #100;
    end
    
endmodule
