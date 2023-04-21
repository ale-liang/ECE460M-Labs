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

/*
module fp_adder(
    input [7:0] a,
    input [7:0] b,
    output [7:0] out
    );
    
    reg sOut;
    reg comp;
    reg [3:0] eOut;
    reg [9:0] fOut, fA, fB;
    integer i;
    
    initial begin
        sOut = 1'b0;
        eOut = 4'b0;
        fOut = 10'b0;
    end
    
    
    always @(*) begin
        fA = {1'b0, a[3:0], 5'b0};
        fB = {1'b0, b[3:0], 5'b0};
        
        //Compare Exponents
        if (a[6:4] > b[6:4]) begin //shift a until expA == expB
            fB = fB >> (a[6:4]-b[6:4]);
            eOut = a[6:4];
        end else if (b[6:4] > a[6:4]) begin //shift b until expA == expB
            fA = fA >> (b[6:4]-a[6:4]);
            eOut = b[6:4];
        end //else expA == expB so do nothing
        
        //Add Fractions
        if (a[7] ~^ b[7]) begin //signs are the same- add fractA + fractB
            fOut = fA + fB;
            sOut = a[7];
        end else if (a[7] == 1) begin //subtract -fractA + fractB
            fOut = fB + (-fA);
            sOut = (fA > fB) ? 1 : 0;
        end else begin //subtract fractA - fractB
            fOut = fA + (-fB);
            sOut = (fB > fA) ? 1 : 0;
        end
        
        if (fOut == 10'b0) begin //If Result is 0, Set Excponent to 0
            eOut = 4'b0;
            sOut = 1'b0;
        end 
        
        //Check for fraction overflow and Normalize Fraction
        if(fOut[9] == 1'b1) begin
            fOut = fOut >> 1;
            eOut = eOut + 1;
        end else begin
            for(i = 0; i < 10; i = i + 1) begin
                if (fOut[8] != 1'b1 && eOut > 4'b0) begin
                    fOut = fOut << 1;
                    eOut = eOut - 1;
                end
            end    
        end
    end
    
    assign out = {sOut, eOut[2:0], fOut[8:5]};
    
endmodule
*/

module fp_adder(
    input [7:0] A,
    input [7:0] B,
    output [7:0] Sum
    );
    
    reg sign;
    reg [2:0] exponent;
    reg [9:0] fraction; // twos complement addition (ignore the carry bit)
    reg [9:0] fractionA; // implied 1, fraction, and four zeros for shifts
    reg [9:0] fractionB;
    
    always @(*) begin
        fractionA = {1'b0, 1'b1, A[3:0], 4'b0}; //zero for overflow plus implied 1
        fractionB = {1'b0, 1'b1, B[3:0], 4'b0}; //+ fraction + four zeros
        
        if((A == 8'b10000000 &&  B == 8'b10000000) || (A == 0 && B == 0) || ((A[7] ^ B[7] == 1) && (A[6:0] == B[6:0]))) begin //sum will = 0
            exponent = 0;
            fraction = 0;
            sign = 0;
        end
        else if(A == 0 || A == 8'b10000000) begin //adding zero cases
            exponent = B[6:4];
            fraction[7:4] = B[3:0];
            sign = B[7];
        end
        else if(B == 0 || B == 8'b10000000) begin
            exponent = A[6:4];
            fraction[7:4] = A[3:0];
            sign = A[7];
        end
        else begin
            if(A[6:4] < B[6:4]) begin //find smaller exponent to right shift
                exponent = B[6:4];
                fractionA = fractionA >> (B[6:4] - A[6:4]);
            end
            else begin
                exponent = A[6:4];
                fractionB = fractionB >> (A[6:4] - B[6:4]);
            end
            
            if(A[7] == B[7]) begin //check sign bits if they are the same no change
                sign = A[7];
            end
            else begin //if they are different subtract smaller number from bigger number
                if(fractionA > fractionB) begin
                    sign = A[7];
                end
                else begin
                    sign = B[7];
                end
            end
            if(A[7] == 1) begin
                fractionA = ~fractionA + 1;
            end
            if(B[7] == 1) begin
                fractionB = ~fractionB + 1;
            end
            
            fraction = fractionA + fractionB;
             
            //checking for fraction overflow
            if(sign != fraction[9]) begin
                fraction = fraction >> 1;
                exponent = exponent + 1;
                if(sign == 1) begin //if the result is in twos compliemnt flip it back to unsigned
                    fraction = ~fraction + 1;
                end
            end
            else begin
                if(sign == 1) begin //if the result is in twos compliemnt flip it back to unsigned
                    fraction = ~fraction + 1;
                end
                //shifting 8 times will guarantee normalization
                if(fraction[8] != 1'b1 ) begin  
                    fraction = fraction << 1;
                    exponent = exponent - 1;
                end
                if(fraction[8] != 1'b1) begin  
                    fraction = fraction << 1;
                    exponent = exponent - 1;
                end
                if(fraction[8] != 1'b1) begin  
                    fraction = fraction << 1;
                    exponent = exponent - 1;
                end
                if(fraction[8] != 1'b1) begin  
                    fraction = fraction << 1;
                    exponent = exponent - 1;
                end
                if(fraction[8] != 1'b1) begin  
                    fraction = fraction << 1;
                    exponent = exponent - 1;
                end
                if(fraction[8] != 1'b1) begin  
                    fraction = fraction << 1;
                    exponent = exponent - 1;
                end
                if(fraction[8] != 1'b1) begin  
                    fraction = fraction << 1;
                    exponent = exponent - 1;
                end
                if(fraction[8] != 1'b1) begin  
                    fraction = fraction << 1;
                    exponent = exponent - 1;
                end
            end
            
        end
    end
    
    assign Sum = {sign, exponent[2:0], fraction[7:4]};
endmodule
