`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2023 04:44:44 PM
// Design Name: 
// Module Name: PulseGen_tb
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


module PulseGen_tb;
    reg St, Clk;
    reg [1:0] Sel;
    wire PulseOut;
    
    integer i;
    
    localparam period = 32;
    
    PulseGen UUT (.St(St), .Sel(Sel), .Clk(Clk), .PulseOut(PulseOut));
    
    initial
    begin
        St = 1;
        Sel = 2'b00;
    end
    
    always 
    begin
        #10 Clk = 1'b1; 
    
        #10 Clk = 1'b0;
    end
    always @(posedge Clk)
    begin
        #1000000000
                
        $display("finished test");
    $stop;
    end
endmodule
