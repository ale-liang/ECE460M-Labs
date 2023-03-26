`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2023 07:56:06 PM
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
    input [15:0] BCD,
    output [3:0] ANODE,
    output [6:0] SEVSEG
    );
    wire [6:0] S0;
    wire [6:0] S1;
    wire [6:0] S2;
    wire [6:0] S3;
    
    reg off = 1;
    reg [19:0] count = 0;
    reg [3:0] ANODEreg;
    reg [7:0] SEVSEGreg;
    
    assign ANODE = ANODEreg;
    assign SEVSEG = SEVSEGreg;
    
    BCDto7Seg (BCD, S0, S1, S2, S3);
    
    always @(posedge CLK)
    begin 
        count = count + 1;
    end
    
    always @(count[19:18])
    begin
        case(count[19:18])
        2'b00: begin
                ANODEreg = 4'b0111; 
                SEVSEGreg[6:0] = off ? ~0: ~S3;
                //SEVSEGreg[7:1] = 7'b1000000;
               end
        2'b01: begin
                ANODEreg = 4'b1011; 
                SEVSEGreg[6:0] = off ? ~0: ~S2;
                //SEVSEGreg[7:1] = 7'b1000000;
               end
        2'b10: begin
                ANODEreg = 4'b1101; 
                SEVSEGreg[6:0] = off ? ~0: ~S1;
                //SEVSEGreg[7:1] = 7'b1000000;
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
