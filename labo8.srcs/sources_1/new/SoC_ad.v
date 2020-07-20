`timescale 1ns / 1ps

module SoC_ad(
        input [31:0]A,
        input WE,
        output reg secWE, firstWE, WEM,
        output reg [1:0]RdSel
    );
        initial begin
            secWE = 1'b0;
            firstWE = 1'b0;
            WEM = 1'b0;
        end
        always @( WE, A ) begin
            case (A[11:8])
            4'h9: begin { WEM, firstWE, secWE } = { 1'b0, 1'b0, WE }; RdSel = 2'b11; end
            // GPIO
            4'h8: begin { WEM, firstWE, secWE } = { 1'b0, WE, 1'b0 }; RdSel = 2'b10; end
            // Factorial Accelerator
            default: begin { WEM, firstWE, secWE } = { WE, 1'b0, 1'b0 }; RdSel = 2'b00; end
            // Data Memory
            endcase
        end
endmodule
