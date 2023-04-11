`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2023 01:59:38 AM
// Design Name: 
// Module Name: MAC
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


module MAC(
    input clk,
    input [7:0] in_a,
    input [7:0] in_b,
    input startMAC,
    output [7:0] outMAC, // c
    output [7:0] pass_a, //passing A over to the right
    output [7:0] pass_b //passing B downwards
    );
    
    wire [7:0] mult_out, sum_out;
    reg [7:0] accumulated_sum; //sum from previous multiply and accumulate operations
    reg [7:0] aTemp, bTemp;
    fp_mult multC(in_a, in_b, mult_out); // floating point A*B
    fp_adder addC(accumulated_sum, mult_out, sum_out); // C <- C + (A*B)
    
    initial begin
        aTemp = 0;
        bTemp = 0;
        accumulated_sum = 0;
    end
    
    always @(posedge clk) begin 
        if(startMAC) begin
            aTemp <= in_a;
            bTemp <= in_b;
            accumulated_sum <= sum_out;
        end
    end
    
    assign outMAC = accumulated_sum;
    assign pass_a = aTemp;
    assign pass_b = bTemp;
    
endmodule
