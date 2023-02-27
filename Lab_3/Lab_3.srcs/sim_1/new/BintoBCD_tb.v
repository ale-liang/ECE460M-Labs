`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2023 04:37:46 PM
// Design Name: 
// Module Name: BintoBCD_tb
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


module BintoBCD_tb;
    reg [15:0] Bin;
    wire [15:0] BCD;
    
    integer i;
    
    localparam period = 32;
    
    BinToBCD UUT (.Bin(Bin), .BCD(BCD));

    initial
    begin
        Bin = 9999;
    end
    
    always @(*)
    begin
        //S0
        #period;
        
                
        $display("finished test");
    $stop;
    end
endmodule
