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
    reg [7:0] DVR; 
    // DAR - display address register -> hold address of the data that should be displayed on the output  (1 under SPR)
    // SPR - stack pointer -> contain the address of the next free address past the top of the stack
    reg [6:0] DAR, SPR;
    reg [4:0] state;
    wire btn0, btn1, btn2, btn3;
    wire emp;
    //var1 and var2 hold the values from the stack to be added or subtracted
    reg [7:0] var1, var2;
    
    assign cs = we;
    assign emp = (SPR == 7'b1111111) ? 1 : 0;   
    assign leds[6:0] = DAR;
    assign leds[7] = emp;
    
    ButtonDebounce b0(clk, btns[0], btn0);
    ButtonDebounce b1(clk, btns[1], btn1);
    ButtonDebounce b2(clk, btns[2], btn2);
    ButtonDebounce b3(clk, btns[3], btn3);
    
    initial begin
        state <= 0;
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
        case (state)
            0: begin
                SPR <= 7'b1111111;
                DAR <= 7'b0000000;
                DVR <= 8'b00000000;
                address <= 7'b1111111;
                data_out <= 8'b11111111;
                we <= 0;
                state <= 1;
                var1 <= 0;
                var2 <= 0;
            end
            1: begin
                if(btn3 == 0 && btn2 == 0)
                    state <= 2;
                else if (btn3 == 0 && btn2 == 1)
                    state <= 3;
                else if (btn3 == 1 && btn2 == 0)        
                    state <= 4;
                else if (btn3 == 1 && btn2 == 1) 
                    state <= 5;
                else
                    state <= 1;       
            end
            2: begin // mode btn 3 = 0, btn 2 = 0
                DVR <= data_in;
                we <= 0;
                address <= DAR;
                if(btn1) begin // delete/pop - pops and discards the 8 bit value on the top of the stack
                    we <= 0;
                    if(emp != 1) begin
                        SPR <= SPR + 1;
                        DAR <= SPR + 2;
                    end
                end
                else if (btn0) begin // enter/push - read the values from switches and pushes it onto stack
                    we <= 1;
                    data_out <= swtchs;
                    address <= SPR;
                    SPR <= SPR - 1;
                    DAR <= SPR;
                end
                else begin
                    state <= 1;
                end
            end
            3: begin // mode btn 3 = 0, btn2 = 1
                DVR <= data_in;
                we <= 0;
                address <= DAR;
                if(btn1) begin // subtract - pops the top 2 values on stack and subtracts them and then pushes the result onto the stack
                    DAR <= SPR + 1; // DAR at address of top element on the stack
                    address <= SPR + 1; 
                    state <= 12;
                end
                else if (btn0) begin // add - pop top 2 values on stack and adds them and then pushes the result onto top of stack
                    DAR <= SPR + 1; // DAR at address of top element on the stack
                    address <= SPR + 1;
                    state <= 6;
                end
                else begin
                    state <= 1;
                end
            end
           4: begin // mode btn3 = 1, btn2 = 0
                DVR <= data_in;
                we <= 0;
                address <= DAR;
                if(btn1) begin // clear/RST - set SPR = 0x7F, DAR = 0x00, DVR = 0x00
                    SPR <= 7'b1111111;
                    DAR <= 7'b0000000;
                    DVR <= 8'b00000000;
                    address <= 7'b1111111;
                    data_out <= 8'b11111111;
                end
                else if (btn0) begin // top - set DAR to top of stack (SPR + 1)
                    DAR <= SPR + 1;
                end
                else begin
                    state <= 1;
                end
            end
            5: begin //mode btn3 = 1, btn2 = 1
                DVR <= data_in;
                we <= 0;
                address <= DAR;                
                if(btn1) begin // dec addr - decrements DAR by 1
                    DAR <= DAR - 1;
                end
                else if (btn0) begin // inc addr - increments DAR by 1
                    DAR <= DAR + 1;
                end
                else begin
                    state <= 1;
                end
            end
            6: begin // wait state transition for addition
                state <= 7;
            end
            7: begin //read in 1st value
                var2 <= data_in;
                SPR <= SPR + 1; //drop stack by 1 element
                DAR <= DAR + 1; // move to next element by going down 1
                address <= DAR + 1;
                state <= 8;
            end    
            8: begin // wait
                state <= 9;
            end
            9: begin //read in 2nd value
                var1 <= data_in;
                SPR <= SPR + 1; //drop stack by element
                state <= 10;
            end
            10: begin //wait
                state <= 11;
            end
            11: begin // push addition value
                we <= 1;
                address <= SPR; //push given SPR with value onto address
                data_out <= var1 + var2; 
                SPR <= SPR - 1; //increment SPR by 1
                state <= 18;
            end
            12: begin // wait state transition for addition
                state <= 13;
            end
            13: begin //read in first value and update addresses
                var2 <= data_in;
                SPR <= SPR + 1;
                DAR <= DAR + 1;
                address <= DAR + 1;
                state <= 14;
            end    
            14: begin //wait
                state <= 15;
            end
            15: begin //read in 2nd value
                var1 <= data_in;
                SPR <= SPR + 1;
                state <= 16;
            end
            16: begin // wait
                state <= 17;
            end
            17: begin //pushing for subtraction
                we <= 1;
                address <= SPR; //push to this address where the SPR is 
                data_out <= var1 - var2;
                SPR <= SPR - 1;
                state <= 18;
            end
            18: begin
                state <= 1;
            end
            default: begin
                state <= 0;
                SPR <= 7'b1111111;
                DAR <= 7'b0000000;
                DVR <= 8'b00000000;
                address <= 7'b1111111;
                data_out <= 8'b11111111;
                we <= 0;
             end    
        endcase        
    end
    
    
    
endmodule
