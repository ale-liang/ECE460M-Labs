`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2023 03:46:07 PM
// Design Name: 
// Module Name: Controller
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


module Controller(
    input Clk,
    input ButtU,
    input ButtL,
    input ButtR,
    input ButtD,
    input Sw0,
    input Sw1,
    output [15:0] TimeLeftCnt,
    output LessThan200,
    output ZeroTimeLeft
    );
    
    //Registers for tracking each second
    parameter secPeriod = 100000000;
    reg [25:0] cnt = 0;
    
    //Wire variables for output of debounced buttons
    wire U, L, R, D;
        
    //Create registers to hold output values
    reg [15:0] TimeLeftCntReg = 0;
    reg LessThan200Reg = 0;
    reg ZeroTimeLeftReg = 1;
    wire slowClk;
    
    //Assign output to registers
    assign TimeLeftCnt = TimeLeftCntReg;
    assign LessThan200 = LessThan200Reg;
    assign ZeroTimeLeft = ZeroTimeLeftReg; 
    
    //Instantiate input modules for debounced buttons
    //Switches don't require to be debounced
    ButtonDebounce bU(Clk, ButtU, U);
    ButtonDebounce bL(Clk, ButtL, L);
    ButtonDebounce bR(Clk, ButtR, R);
    ButtonDebounce bD(Clk, ButtD, D);
    
    FiftyMilliSecClk f1(Clk, slowClk);
    
    always@(*) begin
        if(TimeLeftCntReg < 200) begin
            LessThan200Reg <= (TimeLeftCntReg == 0) ? 0:1;
            ZeroTimeLeftReg <= (TimeLeftCntReg == 0 ) ? 1:0;
        end else begin    
            LessThan200Reg <= 0;
            ZeroTimeLeftReg <= 0;
        end    
    end
    
    always @(posedge slowClk) begin
        //Decrements if cnt == secPeriod (which means a second has passed)
        //and also updates the outputs
        if (cnt == 20) begin
                //Checks if Time left on Parking meter is Greater than 0
                //If true, decrement and set proper outputs
                //Else, time is 0 and no decrement
                if(TimeLeftCntReg > 0) begin
                   
                    TimeLeftCntReg <= TimeLeftCntReg - 1;
                end           
                else begin
                    TimeLeftCntReg <= 0;
                end
            cnt = 0;
        end
        //Else if the cnt doesn't equal the secPeriod, increment cnt and update TimeLeftCntReg according to buttons and switches on
        else begin
            cnt = cnt + 1;
            //if SWITCH 0 is on, then display is stuck at 10 until switch 0 is off
            if(Sw0) begin
                TimeLeftCntReg <= 10;
            end
            //if SWITCH 1 is on, then display is stuck at 205 until switch is off
            else if (Sw1) begin
                TimeLeftCntReg <= 205;
            end 
            //Else decrement as normal and check if any of the buttons have been pressed
            //and increment according to button pressed
            else begin     
                
                //Checks if any of the buttons have been pressed
                //if true, increment according to button value
                if(U) begin
                    TimeLeftCntReg <= TimeLeftCntReg + 10;
                end    
                if(L) begin
                    TimeLeftCntReg <= TimeLeftCntReg + 180;
                end    
                if(R) begin
                    TimeLeftCntReg <= TimeLeftCntReg + 200;
                end    
                if(D) begin
                    TimeLeftCntReg <= TimeLeftCntReg + 550;
                end    
             end                   
        end
        
        //If Time left on meter is > 9999, time left will default to 9999
        if(TimeLeftCntReg > 9999) begin
            TimeLeftCntReg <= 9999;
        end    
    end    
    
    
endmodule