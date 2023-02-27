`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2023 03:53:26 PM
// Design Name: 
// Module Name: FitbitTracker_tb
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


module FitbitTracker_tb;
    reg Pulse, Clk, Rst;
    wire [15:0] DspVals;
    wire SI, DspMiles;
    
    integer i;
    
    localparam period = 32;
    
    FitbitTracker UUT (.Clk(Clk), .Pulse(Pulse), .Rst(Rst), .DspVals(DspVals), .SI(SI), .DspMiles(DspMiles));
    
    initial
    begin
        Pulse = 1;
        Rst = 0;
    end
    
    always 
    begin
        #10 Clk = 1'b1; 
    
        #10 Clk = 1'b0;
    end
    always @(posedge Clk)
    begin
        //S0
        #period;
        
        for (i = 0; i < 9999; i = i + 1) begin
            Pulse = 0;
            #period;
            Pulse = 1;
            #period;
        end
                
        $display("finished test");
    $stop;
    end
endmodule
