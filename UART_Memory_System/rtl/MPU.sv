`timescale 1ns / 1ps

module MPU(

    input  logic [7:0] addr,
    output logic access_valid

);

assign access_valid = (addr < 8'h80);

endmodule
