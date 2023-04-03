`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2023 01:17:51 PM
// Design Name: 
// Module Name: controller
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



module controller(clk, cs, we, address, data_in, data_out, btns, swtchs, leds, segs,an);
    input clk;
    output cs;
    output reg we;
    output reg [6:0] address;
    input[7:0] data_in;
    output reg [7:0] data_out;
    input[3:0] btns;
    input[7:0] swtchs;
    output[7:0] leds;
    output[6:0] segs;
    output[3:0] an;
    
    // DVR - display value register -> value to be displayed on output
    reg [7:0] DVR, nDVR; 
    // DAR - display address register -> hold address of the data that should be displayed on the output  (1 under SPR)
    // SPR - stack pointer -> contain the address of the next free address past the top of the stack
    reg [6:0] DAR, SPR, nDAR, nSPR;
    reg [4:0] state, nstate;
    
    wire btn0, btn1, btn2, btn3;
    reg prevbtn0, prevbtn1, prevbtn2, prevbtn3;
    wire emp;
    //var1 and var2 hold the values from the stack to be added or subtracted
    reg [7:0] var1, var2, nvar1, nvar2;
    
    assign cs = we;
    assign emp = (SPR == 7'b1111111) ? 1 : 0;   
    assign leds[6:0] = DAR;
    assign leds[7] = emp;
    
    ButtonDebounce b0(clk, btns[0], btn0);
    ButtonDebounce b1(clk, btns[1], btn1);
    //ButtonDebounce b2(clk, btns[2], btn2);
    //ButtonDebounce b3(clk, btns[3], btn3);
    
    assign btn2 = btns[2];
    assign btn3 = btns[3];
    
    //Display stuff
    Display dis (clk, DVR, an, segs);
    
    initial begin
        state <= 0;
        nstate <= 0;
    end
    /*
    Notes
    controller logic should be one large state machine
    data_in - data from memory
    data_out - data sent across data bus to memory
    
    if you make we = 0 in one clock cycle, read data in the next clock cycle (in next state of controller)
    
    we - WRITE ENABLE
    Push - we = 1
    Pop - we = 0
    Add - we = 1 when pushing
    Subtract - we = 1 when pushing
    Clear - we = 0
    Top - we = 0
    Dec - we = 0
    Inc - we = 0
    */
    always @(posedge clk) begin
        state <= nstate;
        SPR <= nSPR;
        DAR <= nDAR;
        DVR <= nDVR;
        prevbtn0 <= btn0;
        prevbtn1 <= btn1;
        prevbtn2 <= btn2;
        prevbtn3 <= btn3;
        var1 <= nvar1;
        var2 <= nvar2;
    end
    
    always @(*) begin
        case (state)
            0: begin
                nSPR = 7'b1111111;
                nDAR = 7'b0000000;
                nDVR = 8'b00000000;
                address = 7'b1111111;
                data_out = 8'b11111111;
                we = 0;
                nstate = 1;
                nvar1 = 0;
                nvar2 = 0;
            end
            1: begin
                we = 0;
                nSPR = SPR;
                nDAR = DAR;
                nDVR = DVR;
                address = DAR;
                nvar1 = 0;
                nvar2 = 0;
                
                if(btn3 == 0 && btn2 == 0 && btn1 == 0 && btn0 == 1 && prevbtn0 == 0) //push
                    nstate = 20;
                else if (btn3 == 0 && btn2 == 0 && btn1 == 1 && btn0 == 0 && prevbtn1 == 0) //pop
                    nstate = 2;    
                else if (btn3 == 0 && btn2 == 1 && btn1 == 0 && btn0 == 1 && prevbtn0 == 0) //add
                    nstate = 21;
                else if (btn3 == 0 && btn2 == 1 && btn1 == 1 && btn0 == 0 && prevbtn1 == 0) //subtract
                    nstate = 3;
                else if (btn3 == 1 && btn2 == 0 && btn1 == 0 && btn0 == 1 && prevbtn0 == 0) //top 
                    nstate = 22;
                else if (btn3 == 1 && btn2 == 0 && btn1 == 1 && btn0 == 0 && prevbtn1 == 0) //clear   
                    nstate = 4;    
                else if (btn3 == 1 && btn2 == 1 && btn1 == 0 && btn0 == 1 && prevbtn0 == 0) //increment
                    nstate = 23;
                else if (btn3 == 1 && btn2 == 1 && btn1 == 1 && btn0 == 0 && prevbtn1 == 0) //decrement
                    nstate = 5;    
                else
                    nstate = 1;       
            end
            2: begin // mode btn 3 = 0, btn 2 = 0 - pop
                if(!emp) begin
                    we = 0;
                    nSPR = SPR + 1;
                    nDAR = DAR + 1;
                    nDVR = DVR;
                    address = DAR + 1;
                    nvar1 = 0;
                    nvar2 = 0;
                    nstate = 19;
                end
                else begin
                    we = 0;
                    nSPR = SPR;
                    nDAR = DAR;
                    nDVR = DVR;
                    address = DAR;
                    nvar1 = 0;
                    nvar2 = 0;
                    nstate = 1;
                end
            end
            20: begin //push
                we = 1;
                data_out = swtchs;
                nSPR = SPR - 1;
                nDAR = DAR - 1;
                nDVR = swtchs;
                address = DAR - 1;
                nvar1 = 0;
                nvar2 = 0;
                nstate <= 18;    
            end
            3: begin // mode btn 3 = 0, btn2 = 1 - subtract
                we = 0;
                nSPR = SPR;
                nDAR = DAR;
                nDVR = DVR;
                address = DAR;
                nvar1 = 0;
                nvar2 = 0;
                nstate = 12;
            end
            21: begin // add
                we = 0;
                nSPR = SPR;
                nDAR = DAR;
                nDVR = DVR;
                address = DAR;
                nvar1 = 0;
                nvar2 = 0;
                nstate = 6;
            end
            4: begin // mode btn3 = 1, btn2 = 0 - CLEAR/RESET
                nstate = 0;
            end
            22: begin // TOP
                we = 0;
                nSPR = SPR;
                nDAR = SPR + 1;
                nDVR = DVR;
                address = SPR + 1;
                nvar1 = 0;
                nvar2 = 0;
                nstate = 19;
            end
            5: begin //mode btn3 = 1, btn2 = 1 - DECREMENT
                we = 0;
                nSPR = SPR;
                nDAR = DAR - 1;
                nDVR = DVR;
                address = DAR - 1;
                nvar1 = 0;
                nvar2 = 0;
                nstate = 19;
            end
            23: begin // INCREMENT DAR
                we = 0;
                nSPR = SPR;
                nDAR = DAR + 1;
                nDVR = DVR;
                address = DAR + 1;
                nvar1 = 0;
                nvar2 = 0;
                nstate = 19;
            end
            6: begin // wait state transition for addition
                we = 0;
                nSPR = SPR;
                nDAR = DAR;
                nDVR = DVR;
                address = DAR;
                nvar1 = 0;
                nvar2 = 0;
                nstate = 7;
            end
            7: begin //read in 1st value
                nvar2 = data_in;
                we = 0;
                nSPR = SPR;
                nDAR = DAR;
                nDVR = DVR;
                nvar1 = 0;
                address = DAR + 1;
                nstate = 8;
            end    
            8: begin // wait
                we = 0;
                nSPR = SPR;
                nDAR = DAR;
                nDVR = DVR;
                address = DAR;
                nvar2 = var2;
                nvar1 = var1;
                nstate = 9;
            end
            9: begin //read in 2nd value
                nvar1 = data_in;
                we = 0;
                nSPR = SPR;
                nDAR = DAR;
                nDVR = DVR;
                address = DAR;
                nvar2 = var2;
                nstate = 10;
            end
            10: begin //wait
                we = 0;
                nSPR = SPR;
                nDAR = DAR;
                nDVR = DVR;
                address = DAR;
                nvar2 = var2;
                nvar1 = var1;
                nstate = 11;
            end
            11: begin // push addition value
                we = 1;
                nvar1 = 0;
                nvar2 = 0;
                data_out = var1 + var2; 
                nSPR = SPR + 1; //increment SPR by 1
                nDAR = DAR + 1;
                nDVR = DVR;
                address = DAR + 1;
                nstate = 18;
            end
            12: begin // wait state transition for addition
                we = 0;
                nSPR = SPR;
                nDAR = DAR;
                nDVR = DVR;
                address = DAR;
                nvar1 = 0;
                nvar2 = 0;
                nstate = 13;
            end
            13: begin //read in first value and update addresses
                nvar2 = data_in;
                we = 0;
                nSPR = SPR;
                nDAR = DAR;
                nDVR = DVR;
                nvar1 = 0;
                address = DAR + 1;
                nstate = 14;
            end    
            14: begin //wait
                we = 0;
                nSPR = SPR;
                nDAR = DAR;
                nDVR = DVR;
                address = DAR;
                nvar2 = var2;
                nvar1 = var1;
                nstate = 15;
            end
            15: begin //read in 2nd value
                nvar1 = data_in;
                we = 0;
                nSPR = SPR;
                nDAR = DAR;
                nDVR = DVR;
                address = DAR;
                nvar2 = var2;
                nstate = 16;
            end
            16: begin // wait
                we = 0;
                nSPR = SPR;
                nDAR = DAR;
                nDVR = DVR;
                address = DAR;
                nvar2 = var2;
                nvar1 = var1;
                nstate = 17;
            end
            17: begin //pushing for subtraction
                we = 1;
                nvar1 = 0;
                nvar2 = 0;
                data_out = var1 - var2; 
                nSPR = SPR + 1; //increment SPR by 1
                nDAR = DAR + 1;
                nDVR = DVR;
                address = DAR + 1;
                nstate = 18;
            end
            18: begin //wait
                we = 0;
                nvar1 = 0;
                nvar2 = 0;
                nSPR = SPR; 
                nDAR = DAR;
                nDVR = DVR;
                address = DAR;
                nstate = 19;
            end
            19: begin //READ AND UPDATE THE DVR
                we = 0;
                nSPR = SPR;
                nDAR = DAR;
                address = DAR;
                nvar1 = 0;
                nvar2 = 0;
                nDVR = data_in;
                address = DAR;
                nstate = 1;
            end
            default: begin
                nstate = 0;
                nSPR = 7'b1111111;
                nDAR = 7'b0000000;
                nDVR = 8'b00000000;
                address = 7'b1111111;
                data_out = 8'b11111111;
                we = 0;
                nvar1 = 0;
                nvar2 = 0;
             end    
        endcase        
    end
    
    
    
endmodule