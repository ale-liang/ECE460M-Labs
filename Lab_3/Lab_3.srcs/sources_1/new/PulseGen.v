`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2023 04:58:26 PM
// Design Name: 
// Module Name: PulseGen
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


module PulseGen(
    input St,
    input [1:0] Sel,
    input Clk,
    output PulseOut
    );
    
    wire Sec;
    reg pulseGen = 0;
    reg [8:0] secCnt;
    
    reg [21:0] cnt, PulsePerSecCnt;
    reg [21:0] PrevPulsePerSecCnt = 0;
    
    
    assign PulseOut = pulseGen;
    
    SecGen secondGenerator(Clk, Sec);
    
    always@(posedge Sec) begin
        if((Sel == 2'b11) & St)
            secCnt = secCnt + 1;
        else
            secCnt = 0;
    end
    
    always@(secCnt, Sel) begin 
        if (Sel == 2'b00) //WALK MODE    
            PulsePerSecCnt = 22'd1562500; //32 pulses per second (1 up/1 down)
        else if (Sel == 2'b01) //JOG MODE
            PulsePerSecCnt = 22'd781250; //64 pulses per second (1 up/1 down
        else if (Sel == 2'b10) //RUN MODE
            PulsePerSecCnt = 22'd390625; //128 pulses per second (1 up/1 down)    
        else if ((Sel == 2'b11) & (secCnt == 0)) //HYBRID MODE (1st Sec)
            PulsePerSecCnt = 22'd2500000; //20 pulses per second (1 up/1 down)  
        else if ((Sel == 2'b11) & ((secCnt == 1)|(secCnt == 8))) //HYBRID MODE (2nd or 9th Sec)
            PulsePerSecCnt = 22'd1515152; //33 pulses per second (1 up/1 down)       
        else if ((Sel == 2'b11) & (secCnt == 2)) //HYBRID MODE (3rd Sec)
            PulsePerSecCnt = 22'd757576; //66 pulses per second (1 up/1 down)  
        else if ((Sel == 2'b11) & (secCnt == 3)) //HYBRID MODE (4th Sec)
            PulsePerSecCnt = 22'd1851852; //27 pulses per second (1 up/1 down)
        else if ((Sel == 2'b11) & (secCnt == 4)) //HYBRID MODE (5th Sec)
            PulsePerSecCnt = 22'd714286; //70 pulses per second (1 up/1 down)
        else if ((Sel == 2'b11) & ((secCnt == 5)|(secCnt == 7))) //HYBRID MODE (6th pr 8th Sec)
            PulsePerSecCnt = 22'd1666667; //30 pulses per second (1 up/1 down)            
        else if ((Sel == 2'b11) & (secCnt > 8) & (secCnt < 74)) //HYBRID MODE (10th-73rd Sec)
            PulsePerSecCnt = 22'd724638; //69 pulses per second (1 up/1 down)    
        else if ((Sel == 2'b11) & (secCnt > 73) & (secCnt < 80)) //HYBRID MODE (74th-79th Sec)
            PulsePerSecCnt = 22'd1470588; //34 pulses per second (1 up/1 down) 
        else if ((Sel == 2'b11) & (secCnt > 79) & (secCnt < 145)) //HYBRID MODE (80th-144th Sec)
            PulsePerSecCnt = 22'd403226; //124 pulses per second (1 up/1 down)
        else
            PulsePerSecCnt = 0;  // no pulses if greater 144 seconds   
        end
    
                      
    always@(posedge Clk) begin
        if(PulsePerSecCnt != PrevPulsePerSecCnt) begin
            cnt = 1;
            PrevPulsePerSecCnt = PulsePerSecCnt;
        end 
        else begin
            if(St & (PulsePerSecCnt != 0)) begin
                if(cnt == PulsePerSecCnt) begin
                    pulseGen = ~pulseGen;
                    cnt = 0;
                end 
                else begin
                    cnt = cnt + 1;
                end   
            end 
            
        end                
    end
endmodule
