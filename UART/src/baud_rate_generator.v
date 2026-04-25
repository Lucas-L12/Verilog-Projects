`timescale 1ns / 1ps

module baud_rate_generator
#(
    parameter M=27,//baud rate divisor
              N=8  
)
(   
    input wire clk,reset,
    output wire max_tick,
    output wire [N-1:0] q
     );
     
     //signal declaration
     reg [N-1:0] r_reg;
     wire [N-1:0] r_next;
     //register
     always @(posedge clk, posedge reset)
        if(reset)
            r_reg<=0;
        else 
            r_reg<=r_next;
     //next state logic
     assign r_next=(r_reg==M-1)? 0: r_reg+1;
     
     //output logic
     assign max_tick=(r_reg==M-1);
     assign q= r_reg;
     
     
endmodule

