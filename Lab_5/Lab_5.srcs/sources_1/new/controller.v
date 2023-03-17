`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2023 01:17:51 PM
// Design Name: 
// Module Name: controller
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



module controller(clk, cs, we, address, data_in, data_out, btns, swtchs, leds, segs,an);
    input clk;
    output cs;
    output we;
    output[6:0] address;
    input[7:0] data_in;
    output[7:0] data_out;
    input[3:0] btns;
    input[7:0] swtchs;
    output[7:0] leds;
    output[6:0] segs;
    output[3:0] an;
    
    reg [7:0] DVR;
    reg [6:0] DAR, SPR;
    wire btn0, btn1, btn2, btn3;
    wire empty;
    
    assign empty = (SPR == 7'b1111111) ? 1 : 0;
    assign cs = we;
    
    assign leds[7] = empty;
    assign leds[6:0] = DAR;
    
    ButtonDebounce b0(clk, btns[0], btn0);
    ButtonDebounce b1(clk, btns[1], btn1);
    ButtonDebounce b2(clk, btns[2], btn2);
    ButtonDebounce b3(clk, btns[3], btn3);
    
    initial begin
        SPR <= 7'b1111111;
        DAR <= 7'b0000000;
        DVR <= 8'b00000000;
    end

endmodule
