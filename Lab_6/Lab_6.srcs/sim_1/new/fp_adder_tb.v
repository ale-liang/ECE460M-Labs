`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2023 05:49:07 PM
// Design Name: 
// Module Name: fp_adder_tb
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


module fp_adder_tb();

reg [7:0] a;
reg [7:0] b;
wire [7:0] sum;

// instantiate the module you want to test
fp_adder adder(.a(a), .b(b), .out(sum));

initial begin
    #10;
    // test case 1
    a = {1'b0, 3'b101, 4'b1110};
    b = {1'b0, 3'b011, 4'b1010};
    #10;
    if (sum != {1'b0, 3'b110, 4'b1000}) $display("Error in test case 1: %b", sum);

    // test case 2
//    a = {1'b0, 3'b100, 4'b0101};
//    b = {1'b0, 3'b011, 4'b0011};
//    #10;
//    if (sum != {1'b0, 3'b100, 4'b0000}) $display("Error in test case 2");

//    // test case 3
//    a = {1'b0, 3'b011, 4'b0101};
//    b = {1'b0, 3'b100, 4'b0011};
//    #10;
//    if (sum != {1'b0, 3'b100, 4'b0000}) $display("Error in test case 3");

//    // test case 4
//    a = {1'b0, 3'b100, 4'b0101};
//    b = {1'b0, 3'b100, 4'b0011};
//    #10;
//    if (sum != {1'b0, 3'b101, 4'b0000}) $display("Error in test case 4");

//    // test case 5
//    a = {8'h00};
//    b = {8'h00};
//    #10;
//    if (sum != {8'h00}) $display("Error in test case 5");

end

endmodule
