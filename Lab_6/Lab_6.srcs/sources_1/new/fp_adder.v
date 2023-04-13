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
    reg [9:0] fOut, fA, fB;
    integer i;
    
    initial begin
        sOut = 1'b0;
        eOut = 4'b0;
        fOut = 10'b0;
    end
    
    
    always @(*) begin
        eOut = {1'b0, a[6:4]};
        if(a[6:0] == 7'b0 || b[6:0] == 7'b0) begin 
            sOut = (a[6:0] == 7'b0) ? b[7] : a[7];
            eOut = (a[6:0] == 7'b0) ? b[6:4] : a[6:4];
            fOut = (a[6:0] == 7'b0) ? {1'b0, 1'b1, b[3:0], 4'b0} : {1'b0, 1'b1, a[3:0], 4'b0};
            
        end else begin
            fA = {1'b0, 1'b1, a[3:0], 4'b0};
            fB = {1'b0, 1'b1, b[3:0], 4'b0};
            
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
            end else begin //subtract biggerfract - smallerfract
                fOut = (fA > fB) ? fA + ((-fB)&10'b0111111111): fB + ((-fA)&10'b0111111111);
                sOut = (fA > fB) ? ((a[7] == 1) ? 1 : 0) : ((b[7] == 1) ? 1 : 0);
            end 
            
            if (fOut[7:0] == 8'b0) begin //If Result is 0, Set Exponent Representation
                //if (a[6:4] == b[6:4]) begin
                    if (a[7] ~^ b[7]) begin
                        /*if (a[6:4] == b[6:4]) begin
                            eOut = eOut << 1;
                        end else begin*/
                            eOut = eOut + 1;
                       // end
                    end else if (a[6:4] == b[6:4]) begin
                        eOut = 4'b0;
                        sOut = 1'b0;
                    end
                //end
            end else begin
                //Check for fraction overflow and Normalize Fraction
                if(fOut[9] == 1'b1) begin
                    fOut = (a[7] ~^ b[7]) ? fOut >> 1 : fOut << 1;
                    eOut = (a[7] ~^ b[7]) ? eOut + 1 : eOut - 1;
                    if (a[7] ^ b[7] && sOut == 1'b1) begin
                        for(i = 0; i < 10; i = i + 1) begin
                            if (fOut[9] != 1'b1 && eOut > 4'b0) begin
                                fOut = (a[7] ~^ b[7]) ? fOut >> 1 : fOut << 1;
                                eOut = (a[7] ~^ b[7]) ? eOut + 1 : eOut - 1;
                            end
                        end 
                    end
                end /*else begin
                    fOut = (a[7] ~^ b[7]) ? fOut >> 1 : fOut << 1;
                    eOut = (a[7] ~^ b[7]) ? eOut + 1 : eOut - 1;
                    for(i = 0; i < 10; i = i + 1) begin
                        if (fOut[9] != 1'b1 && eOut > 4'b0) begin
                            fOut = (a[7] ~^ b[7]) ? fOut >> 1 : fOut << 1;
                            eOut = (a[7] ~^ b[7]) ? eOut + 1 : eOut - 1;
                        end
                    end    
                end*/
            end
            
        end
        if (eOut[2:0] == 3'b0 && fOut[7:4] == 4'b0) begin
            sOut = 0'b0;
        end
        $display("%b + %b = %b", a, b, {sOut, eOut[2:0], fOut[7:4]});
    end
    
    
    assign out = {sOut, eOut[2:0], fOut[7:4]};
    
endmodule
