`timescale 1ns / 1ps

module fact_ad(
        input [1:0]A,
        input WE,
        output reg secWE, firstWE,
        output [1:0]RdSel
    );
        assign RdSel = A;
        
        always @( WE, A ) begin
            case (A)
                2'b00: {secWE, firstWE} = {1'b0, WE};
                2'b01: {secWE, firstWE} = {WE, 1'b0};
                2'b10: {secWE, firstWE} = 2'b00;
                2'b11: {secWE, firstWE} = 2'b00;
                default: {secWE, firstWE} = 2'bxx ;
            endcase
        end
endmodule