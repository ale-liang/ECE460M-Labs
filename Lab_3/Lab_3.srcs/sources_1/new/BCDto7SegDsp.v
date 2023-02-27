
`define D3 BCD[15:12] 
`define D2 BCD[11:8] 
`define D1 BCD[7:4] 
`define D0 BCD[3:0]  

module BCDto7SegDsp(
    input [15:0] BCD,
    output [6:0] S0,
    output [6:0] S1,
    output [6:0] S2,
    output [6:0] S3
    );
    
    bcd_seven B0 (`D0,S0);
    bcd_seven B1 (`D1,S1);
    bcd_seven B2 (`D2,S2);
    bcd_seven B3 (`D3,S3);
    
endmodule