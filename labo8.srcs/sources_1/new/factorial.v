`timescale 1ns / 1ps

module factorial(
        input wire [3:0] n,
        input wire GO, clock, reset,
        output wire [3:0] state,
        output wire [31:0] result,
        output wire DONE, ERR
    );
    
        wire sel, ld_cnt, en, ld_reg, OE, GT, GT12;
        
        factorial_dp DUT (n, sel, ld_cnt, en, ld_reg, OE, clock, reset, result, GT, GT12);
        
        factorial_cu DDT (GT, GT12, clock, GO, reset, sel, ld_cnt, en, ld_reg, OE, DONE, ERR, state);
        
endmodule
