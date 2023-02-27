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
    input St,
    input Clk,
    input Pulse,
    input Rst,
    output [15:0] DspVals,
    output SI,
    output DspMiles //when Mode 2 is outputted
    );
    
    //Output Registers
    reg [15:0] DspValsReg = 0;
    reg SIReg = 0;
    reg DspMilesReg = 0;
    
    assign DspVals = DspValsReg;
    assign SI = SIReg;
    assign DspMiles = DspMilesReg;
    
    //Display registers
    reg [1:0] mode = 0;
    
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
    
    //Registers used to determine seconds according to system clk)
    reg twoSec = 0;
    reg [31:0] twoSecCnt = 0;
    parameter twoSecPeriod = 100000000;
    
    // Mode 3 registers (number of seconds over 32 steps/second (for the first 9 seconds))
    reg [15:0] numSecsOver32 = 0;
    reg [15:0] nineSecCnt = 0;
    
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
    
    //defines a pulse with period of two seconds (twoSec)
    always@ (posedge Clk) begin
        if (twoSecCnt == twoSecPeriod) begin
            twoSec = ~twoSec;
            twoSecCnt = 1;
        end
        else
            twoSecCnt = twoSecCnt + 1;
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
            distCovered = (stepCnt >> 11)*10;
            if (((stepCnt >> 10) % 2) == 1) begin
                distCovered = distCovered + 5;
            end
        end
    end
    
    // Mode 3 - Number of over 32 steps per second (for the first 9 seconds)
    always@ (posedge sec, posedge Rst) begin
        if (Rst) begin
            numSecsOver32 = 0;
            nineSecCnt = 0;
        end
        else begin
            if (nineSecCnt < 9) begin
                if ((stepsPerSec > 32) && St) begin
                    numSecsOver32 = numSecsOver32 + 1;
                end
                nineSecCnt = nineSecCnt + 1;
            end
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
            if((stepsPerSec > 63) && St) begin
                timeAbove64Cnt = timeAbove64Cnt + 1;
            end    
            else begin
                timeAbove64Cnt = 0;
            end    
        end            
        else begin
            if((stepsPerSec > 63) && St) begin
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

    //Cycles through the display modes of the Fitbit every two seconds
    always@(posedge twoSec) begin
        if(mode == 2'b11) begin
            mode <= 2'b00;
        end
        else begin
            mode <= mode + 1;
        end
    end

    //Updates DspVals, SI, and DspMiles according to each mode of the fitbit
    always@(*) begin
        case(mode)
        2'b00: begin //Mode 1
            if(stepCnt > 9999) begin
                DspValsReg = 9999;
                SIReg = 1;
            end
            else begin
                DspValsReg = stepCnt;
                SIReg = 0;
            end
            DspMilesReg = 0;        
        end
        2'b01: begin //Mode 2
            DspValsReg = distCovered;
            DspMilesReg = 1; //Miles Mode on
            SIReg = 0;
        end
        2'b10: begin //Mode 3
            DspValsReg = numSecsOver32;
            DspMilesReg = 0;
            SIReg = 0;
        end
        2'b11: begin //Mode 4
            DspValsReg = timeAbove64Dsp;
            DspMilesReg = 0;
            SIReg = 0;
        end
        default: begin
            DspValsReg = 16'h0000;
        end 
    endcase       
    end
    
endmodule