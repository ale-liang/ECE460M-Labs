`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2023 04:30:19 PM
// Design Name: 
// Module Name: FitbitTracker
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


module FitbitTracker(
    input Clk,
    input Pulse,
    input Rst,
    output [15:0] DspVals,
    output SI,
    output DspMiles
    );
    
    //Output Registers
    reg [15:0] DspValsReg = 0;
    reg SIReg = 0;
    reg DspMilesReg = 0;
    
    assign DspVals = DspValsReg;
    assign SI = SIReg;
    assign DspMiles = DspMilesReg;
    
    //Mode 1 registers (step count)
    reg [31:0] stepCnt = 0;
    
    //Mode 2 registers (distance covered)
    reg [15:0] distCovered = 0;
    
    //Registers used to determine seconds according to system clk)
    reg sec = 0;
    reg [25:0] secCnt = 0;
    parameter secPeriod = 50000000;
    
    // Mode 3 registers (number of seconds over 32 steps/second (for the first 9 seconds))
    reg [3:0] numSecsOver32 = 0;
    
    // Mode 4 registers (High activity time greater than threshold ( >= 64 steps/sec) (Increments every second for continuous time period > 60 seconds))
    reg [15:0] timeAbove64Dsp = 0;
    reg [15:0] timeAbove64Cnt = 0;
    reg passed1Min = 0;
    
    //Registers to track steps/seconds passed
    reg [15:0] secsPassed = 0;
    reg [15:0] secsPassedCheck = 0;
    reg [15:0] stepsPerSec = 0;
    
    //defines a pulse with period of one second (sec)
    always@(posedge Clk) begin
        if (secCnt == secPeriod) begin
            sec = ~sec;
            secCnt = 1;
        end
        else
            secCnt = secCnt + 1;
        end
    
    //Measures how many seconds has passed since start
    always@(posedge sec) begin
        if(Rst) begin
            secsPassed = 0;
        end    
        else begin
            secsPassed = secsPassed + 1;
        end    
    end
    
    // Measures how many steps have occurred in this one second
    always@(posedge Pulse) begin
        if(secsPassed != secsPassedCheck) begin
            secsPassedCheck = secsPassed; 
            stepsPerSec = 0;
        end    
        else begin
            stepsPerSec = stepsPerSec + 1; 
        end              
    end                   
    
    //Mode 1 - Update steps taken at each pulse from the Pulse Generator module
    always@(posedge Pulse, posedge Rst) begin
        if(Rst) begin
            stepCnt <= 0;
        end    
        else begin   
            stepCnt <= stepCnt + 1;
        end    
    end        
    
    // Mode 2 - Updates total distance covered (2048 steps == 0.5 miles)
    always@(posedge Pulse, posedge Rst) begin
        if (Rst) begin
            distCovered = 0;
        end
        else begin    
            distCovered = stepCnt >> 10;
        end
    end
    
    // Mode 4 - Updates high activity time greater than threshold
    always@(posedge sec) begin
    if(Rst) begin
        passed1Min = 0;
        timeAbove64Cnt = 0;
        timeAbove64Dsp = 0;
    end
    else begin
        if(timeAbove64Cnt < 60) begin
            passed1Min = 0;
            if(stepsPerSec > 63) begin
                timeAbove64Cnt = timeAbove64Cnt + 1;
            end    
            else begin
                timeAbove64Cnt = 0;
            end    
        end            
        else begin
            if(stepsPerSec > 63) begin
                if(!passed1Min) begin
                    timeAbove64Dsp = timeAbove64Cnt + timeAbove64Dsp;
                    passed1Min = 1;
                end 
                else begin
                    timeAbove64Dsp = timeAbove64Dsp + 1;
                end       
            end
            else begin
                timeAbove64Cnt = 0;
            end
        end                                
    end
end    
endmodule



