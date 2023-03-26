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
    input [15:0] Bin,
    input CLK,
    input RESET,
    input DMILES,
    output [3:0] ANODE,
    output [7:0] SEVSEG
    );
    
    wire [15:0] BCD;
    wire [6:0] S0;
    wire [6:0] S1;
    wire [6:0] S2;
    wire [6:0] S3;
    
    reg [19:0] count;
    reg [3:0] ANODEreg;
    reg [7:0] SEVSEGreg;
    
    assign ANODE = ANODEreg;
    assign SEVSEG = SEVSEGreg;
    
    BinToBCD BO (Bin, BCD);
    BCDto7SegDsp SS (BCD, S0, S1, S2, S3);
    
    always @(posedge CLK or posedge RESET)
    begin 
        if (RESET == 1)
            count <= 0;
        else
            count <= count + 1;
    end 
    
    always @(count[19:18])
    begin
        case(count[19:18])
        2'b00: begin
                ANODEreg = 4'b0111; 
                SEVSEGreg[7:1] = ~S3;
                SEVSEGreg[0] = 1;
               end
        2'b01: begin
                ANODEreg = 4'b1011; 
                SEVSEGreg[7:1] = ~S2;
                SEVSEGreg[0] = 1;
               end
        2'b10: begin
                ANODEreg = 4'b1101; 
                SEVSEGreg[7:1] = ~S1;
                SEVSEGreg[0] = ~DMILES;
               end
        2'b11: begin
                ANODEreg = 4'b1110; 
                SEVSEGreg[7:1] = ~S0;
                SEVSEGreg[0] = 1;
               end
        endcase
    end
endmodule
