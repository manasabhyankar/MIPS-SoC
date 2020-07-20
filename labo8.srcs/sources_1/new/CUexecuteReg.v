`timescale 1ns / 1ps

module CUexecuteReg(
            input wire clock,
            input wire reset,
            input wire BRD,
            input wire jal_pc_selD,
            input wire reg_dstD,
            input wire jal_addr_selD,
            input wire alu_srcD,
            input wire writeE_dmD,
            input wire dm2regD,
            input wire writeE_regD,
            input wire l_or_rD,
            input wire [2:0] alu_controlD,
            input wire lo_hi_selD,
            input wire mult_enD,
            input wire mult_selD,
            input wire jr_mux_selD,
            input wire shift_selD,
            output reg BRQ,
            output reg jal_pc_selQ, //
            output reg reg_dstQ, //
            output reg jal_addr_selQ, //
            output reg alu_srcQ, //
            output reg writeE_dmQ,
            output reg dm2regQ,
            output reg writeE_regQ, // ????
            output reg l_or_rQ,
            output reg [2:0] alu_controlQ, //
            output reg lo_hi_selQ,
            output reg mult_enQ,
            output reg mult_selQ,
            output reg jr_mux_selQ,
            output reg shift_selQ
        );
            always @ (posedge clock, posedge reset) begin
                if (reset) begin
                    BRQ <= 0;
                    jal_pc_selQ <= 0;
                    reg_dstQ <= 0;
                    jal_addr_selQ <= 0;
                    alu_srcQ <= 0;
                    writeE_dmQ <= 0;
                    dm2regQ <= 0;
                    writeE_regQ <= 0;
                    l_or_rQ <= 0;
                    alu_controlQ <= 0;
                    lo_hi_selQ <= 0;
                    mult_enQ <= 0;
                    mult_selQ <= 0;
                    jr_mux_selQ <= 0;
                    shift_selQ <= 0;
                end
                else begin
                    BRQ <= BRD;
                    jal_pc_selQ <= jal_pc_selD;
                    reg_dstQ <= reg_dstD;
                    jal_addr_selQ <= jal_addr_selD;
                    alu_srcQ <= alu_srcD;
                    writeE_dmQ <= writeE_dmD;
                    dm2regQ <= dm2regD;
                    writeE_regQ <= writeE_regD;
                    l_or_rQ <= l_or_rD;
                    alu_controlQ <= alu_controlD;
                    lo_hi_selQ <= lo_hi_selD;
                    mult_enQ <= mult_enD;
                    mult_selQ <= mult_selD;
                    jr_mux_selQ <= jr_mux_selD;
                    shift_selQ <= shift_selD;
                end
            end
endmodule
