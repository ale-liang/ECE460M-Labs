`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2023 01:17:51 PM
// Design Name: 
// Module Name: memory
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


module memory(clock, cs, we, address, data_in, data_out);
input clock;
input cs;
input we;
input[6:0] address;
input[7:0] data_in;
output[7:0] data_out;
reg[7:0] data_out;
reg[7:0] RAM[0:127];
always @ (negedge clock) begin
    if((we == 1) && (cs == 1)) begin
        RAM[address] <= data_in[7:0];
    end    
    data_out <= RAM[address];    
    end
endmodule
