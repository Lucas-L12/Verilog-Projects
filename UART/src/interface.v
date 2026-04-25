`timescale 1ns / 1ps

module interface
#(
    parameter W = 8   // buffer bits
)(
    input wire clk,
    input wire reset,
    input wire clr_flag,
    input wire set_flag,
    input wire [W-1:0] din,
    output wire flag,
    output wire [W-1:0] dout
);

    // Signal declaration
    reg [W-1:0] buf_reg, buf_next;
    reg flag_reg, flag_next;

    // FF and registers
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            buf_reg  <= 0;
            flag_reg <= 1'b0;
        end else begin
            buf_reg  <= buf_next;
            flag_reg <= flag_next;
        end
    end

    // Next state logic
    always @* begin
        buf_next  = buf_reg;
        flag_next = flag_reg;

        if (set_flag) begin
            buf_next  = din;
            flag_next = 1'b1;
        end else if (clr_flag) begin
            flag_next = 1'b0;
        end
    end

    // Output logic
    assign dout = buf_reg;
    assign flag = flag_reg;

endmodule
