`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2023 10:11:35 PM
// Design Name: 
// Module Name: fp_mult
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


module fp_mult(
    input [7:0] a,
    input [7:0] b,
    output [7:0] out
    );
    
    reg sOut;
    reg [3:0] eOut;
    reg [9:0] mOut;
    wire [4:0] mA, mB;
    integer i;
    
    assign mA = {1'b1, a[3:0]};
    assign mB = {1'b1, b[3:0]};
    
    initial begin
        sOut = 0;
        eOut = 0;
        mOut = 0;
    end
    
    
    always @(*) begin
        if(a == 8'b0 || b == 8'b0) begin 
            sOut = 1'b0;
            eOut = 4'b0;
            mOut = 10'b0;
            
        end else begin
            sOut = a[7] ^ b[7];
            eOut = a[6:4] + b[6:4] - 3; //add the exponents together and then -3 due to bias
            mOut = mB * mA;
            if(mOut[9] == 1'b1) begin
                mOut = mOut >> 1;
                eOut = eOut + 1;
            end else begin
                for(i = 0; i < 10; i = i + 1) begin
                    if (mOut[8] != 1'b1 && eOut > 4'b0) begin
                        mOut = mOut << 1;
                        eOut = eOut - 1;
                    end
                    
                end    
            end
        end
    end
    
    
    assign out = {sOut, eOut [2:0], mOut [7:4]};
    
endmodule
