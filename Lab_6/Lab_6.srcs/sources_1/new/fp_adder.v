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
    output [7:0] out
    );
    
    reg sOut;
    reg comp;
    reg [3:0] eOut;
    reg [9:0] mOut, mA, mB;
    
    initial begin
        sOut = 1'b0;
        eOut = 4'b0;
        mOut = 10'b0;
        
        mA = {1'b0, 1'b1, a[3:0], 4'b0};
        mB = {1'b0, 1'b1, b[3:0], 4'b0};
    end
    
    
    always @(*) begin
    
        if(a == 8'b0) begin
            eOut <= {1'b0, b[6:4]};
            sOut <= b[7];
            mOut[7:4] <= b[3:0];
        end else if (b == 8'b0) begin
            eOut <= {1'b0, a[6:4]};
            sOut <= a[7];
            mOut[7:4] <= a[3:0];
        end else if ((a[6:0] == b[6:0]) && (a[7] ^ b[7] == 1'b1)) begin
            eOut <= 4'b0;
            sOut <= 1'b0;
            mOut <= 10'b0;
        end
        
    end
    
    assign out = {sOut, eOut[2:0], mOut[7:4]};
    
    
    
endmodule
