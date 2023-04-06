`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2023 10:11:35 PM
// Design Name: 
// Module Name: fp_adder
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


module fp_adder(
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out
    );
    
    reg [2:0] exp_diff;
    
    always @(*) begin
    
        if(a == 7'b0) begin
            
        end
    end
    
    
    
endmodule
