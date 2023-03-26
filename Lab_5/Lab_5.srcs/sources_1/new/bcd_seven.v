`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2023 08:35:27 PM
// Design Name: 
// Module Name: bcd_seven
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


module bcd_seven(
    input [3:0] bin,
    output [6:0] seven
    );
    
    reg [6:0] seven;
 
    always @(bin)
    begin
      case (bin)
            8'h0: seven = 7'b1000000; // 0
            8'h1: seven = 7'b1111001; // 1
            8'h2: seven = 7'b0100100; // 2
            8'h3: seven = 7'b0110000; // 3
            8'h4: seven = 7'b0011001; // 4
            8'h5: seven = 7'b0010010; // 5
            8'h6: seven = 7'b0000010; // 6
            8'h7: seven = 7'b1111000; // 7
            8'h8: seven = 7'b0000000; // 8
            8'h9: seven = 7'b0010000; // 9
            8'ha: seven = 7'b0001000; // A
            8'hb: seven = 7'b0000011; // B
            8'hc: seven = 7'b0100111; // C
            8'hd: seven = 7'b0100001; // D
            8'he: seven = 7'b0000110; // E
            8'hf: seven = 7'b0001110; // F
            default: seven = 7'b1111111; // blank
        endcase
    end
endmodule
