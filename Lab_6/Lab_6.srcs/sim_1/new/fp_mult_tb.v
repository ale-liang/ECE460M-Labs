`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2023 06:09:24 PM
// Design Name: 
// Module Name: fp_mult_tb
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


module fp_mult_tb;

    reg [7:0] a, b;
    reg clk;
    wire [7:0] out;
    
    initial begin
        a = 0;
        b = 0;
        clk = 0;
    end
    
    fp_mult DUT(clk, a, b, out);
    
    always begin
        #5 clk = ~clk;
    end    
    
    always @(posedge clk) begin
        #10;
        a = 8'b001110001;
        b = 8'b001110010;
        #50;
        //$display("Finished test");
        //$finish;
    end

endmodule
