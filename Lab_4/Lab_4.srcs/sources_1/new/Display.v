`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2023 02:02:33 AM
// Design Name: 
// Module Name: Display
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

module Display(
    input CLK,
    input SW0,
    input SW1,
    input [15:0] BCD,
    input LESSTHAN200,
    input ZEROTIME,
    output [3:0] ANODE,
    output [7:0] SEVSEG
    );
    
    wire [6:0] S0;
    wire [6:0] S1;
    wire [6:0] S2;
    wire [6:0] S3;
   
    reg off = 0;
    reg [10:0] smallcnt = 0;
    reg [19:0] count = 0;
    reg [20:0] secCnt = 0;
    reg [3:0] ANODEreg;
    reg [7:0] SEVSEGreg;
    
    parameter Second = 100000;
    parameter halfSecond = 50000;
    
    assign ANODE = ANODEreg;
    assign SEVSEG = SEVSEGreg;
    
    BCDto7Seg (BCD, S0, S1, S2, S3);
    
    always @(posedge CLK)
    begin 
        count = count + 1;
        if ((SW0 || SW1) == 1) begin
            secCnt <= 1;
            smallcnt <= 1;
        end
        else begin
            if((LESSTHAN200 == 0) && (ZEROTIME == 0)) begin
                off <= 0;
                secCnt <= 1;
                smallcnt <= 1;
             end else begin
                smallcnt = smallcnt + 1;
                if (smallcnt == 1000) begin
                    secCnt = secCnt + 1;
                    smallcnt <= 1;
                end
                if (ZEROTIME) begin
                    if (secCnt >= halfSecond) begin
                        off <= ~off;
                        secCnt <= 1;
                        smallcnt <= 1;
                    end
                end else begin
                    if (LESSTHAN200 && (secCnt >= Second)) begin
                        off <= ~off;
                        secCnt <= 1;
                        smallcnt <= 1;
                    end
                end
             end
        end
    end 
    
    always @(count[19:18])
    begin
        case(count[19:18])
        2'b00: begin
                ANODEreg = 4'b0111; 
                SEVSEGreg[7:1] = off ? ~0: ~S3;
                //SEVSEGreg[7:1] = 7'b1000000;
                SEVSEGreg[0] = 1;
               end
        2'b01: begin
                ANODEreg = 4'b1011; 
                SEVSEGreg[7:1] = off ? ~0: ~S2;
                //SEVSEGreg[7:1] = 7'b1000000;
                SEVSEGreg[0] = 1;
               end
        2'b10: begin
                ANODEreg = 4'b1101; 
                SEVSEGreg[7:1] = off ? ~0: ~S1;
                //SEVSEGreg[7:1] = 7'b1000000;
                SEVSEGreg[0] = 1;
               end
        2'b11: begin
                ANODEreg = 4'b1110; 
                SEVSEGreg[7:1] = off ? ~0: ~S0;
                //SEVSEGreg[7:1] = 7'b1000000;
                SEVSEGreg[0] = 1;
               end
        endcase
    end
endmodule
