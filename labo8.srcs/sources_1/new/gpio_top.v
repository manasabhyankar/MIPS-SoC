`timescale 1ns / 1ps

module gpio_top(
        input [1:0]A,
        input WE,
        input [31:0]gpi_one,
        input [31:0]gpi_two,
        input [31:0]WD,
        input reset,
        input clock,
        output [31:0]RD,
        output [31:0]gpo_one,
        output [31:0]gpo_two
    );
    
    wire secWE, firstWE;
    wire [1:0]RdSel;
    
    gpio_ad ad (A, WE, secWE, firstWE, RdSel);
    
    REG #(32) gpo_one_reg(clock, reset, firstWE, WD, gpo_one);
    
    REG #(32) gpo_two_reg(clock, reset, secWE, WD, gpo_two);
    
    mux4 #(32) toRD(RdSel, gpi_one, gpi_two, gpo_one, gpo_two, RD);
    
endmodule
