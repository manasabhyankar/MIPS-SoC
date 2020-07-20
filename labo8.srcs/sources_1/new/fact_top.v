`timescale 1ns / 1ps

module fact_top(
        input [1:0] A,
        input       WE,
        input [3:0] WD,
        input       reset,
        input       clock,
        output [31:0] RD
    );
        wire [3:0] state;
        wire secWE, firstWE;
        wire [1:0] RdSel;
        wire [3:0] n;
        wire Go, GoPulse, GoPulseCmb;
        wire Done, Err, ResDone, ResErr;
        wire [31:0] nf;
        wire [31:0] Result;
        
        assign GoPulseCmb = (WD[0] & secWE);
        
        fact_ad F_AD (A, WE, secWE, firstWE, RdSel);
        
        REG #(4) n_REG (clock, reset, firstWE, WD, n);
        
        REG #(1) Go_REG (clock, reset, secWE, WD[0], Go);
        
        REG #(1) GoPulse_R (clock, reset, 1'b1, GoPulseCmb, GoPulse);
        
        REG #(32) result_R (clock, reset, Done, nf, Result);
        
        factorial FA (n, GoPulse, clock, reset, state, nf, Done, Err);
        
        SR_FF #(1) SR_Done (clock, GoPulseCmb, Done, ResDone);
        
        SR_FF #(1) SR_Err (clock, GoPulseCmb, Err, ResErr);
        
        mux4 #(32) toRD (RdSel, {28'b0, n}, {31'b0, Go}, {30'b0, ResErr, ResDone}, Result, RD);
        
endmodule
