`timescale 1ns / 1ps

module CUmemoryReg(
        input wire clock,
        input wire reset,
        input wire BRD,
        input wire jal_pc_selD,
        input wire jal_addr_selD,
        input wire writeE_dmD,
        input wire dm2regD,
        input wire writeE_regD,
        input wire l_or_rD,
        input wire lo_hi_selD,
        input wire mult_enD,
        input wire mult_selD,
        input wire shift_selD,
        output reg BRQ,
        output reg jal_pc_selQ, //
        output reg jal_addr_selQ, //
        output reg writeE_dmQ,
        output reg dm2regQ,
        output reg writeE_regQ, // ????
        output reg l_or_rQ,
        output reg lo_hi_selQ,
        output reg mult_enQ,
        output reg mult_selQ,
        output reg shift_selQ
    );
        always @ (posedge clock, posedge reset) begin
            if (reset) begin
                BRQ <= 0;
                jal_pc_selQ <= 0;
                jal_addr_selQ <= 0;
                writeE_dmQ <= 0;
                dm2regQ <= 0;
                writeE_regQ <= 0;
                l_or_rQ <= 0;
                lo_hi_selQ <= 0;
                mult_enQ <= 0;
                mult_selQ <= 0;
                shift_selQ <= 0;
            end
            else begin
                BRQ <= BRD;
                jal_pc_selQ <= jal_pc_selD;
                jal_addr_selQ <= jal_addr_selD;
                writeE_dmQ <= writeE_dmD;
                dm2regQ <= dm2regD;
                writeE_regQ <= writeE_regD;
                l_or_rQ <= l_or_rD;
                lo_hi_selQ <= lo_hi_selD;
                mult_enQ <= mult_enD;
                mult_selQ <= mult_selD;
                shift_selQ <= shift_selD;
            end
        end
endmodule
