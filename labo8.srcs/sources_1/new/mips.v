`timescale 1ns / 1ps

module mips (
            input  wire       clock,
            input  wire       reset,
            input  wire [4:0] ra_three,
            input  wire [31:0] instr,
            input  wire [31:0] rd_datamem,
            output wire        we_dm,
            output wire [31:0] pc_current,
            output wire [31:0] alu_out,
            output wire [31:0] wd_dm,
            output wire [31:0] rd_three,
            //needed for probbing
            output wire [31:0] jal_wd_mux_out, 
            output wire [31:0] shift_out,
            output wire        we_reg,
            output wire [31:0] alu_pa,
            output wire [31:0] lo_product,
            output wire [31:0] hi_product,
            output wire [31:0] lo_out,
            output wire [31:0] hi_out,
            output wire [31:0] lo_hi_out,
            output wire [31:0] mult_mux_out
        );
        wire BR;
        wire jumpTo;
        wire reg_dst;
        //wire we_reg;
        wire alu_src;
        wire dm2reg;
        wire [2:0] alu_control;
        wire mult_en;
        //NEW WIRES
        wire l_or_r;
        wire shift_sel;
        wire jal_pc_sel;
        wire mult_sel;
        wire jal_addr_sel;
        wire jr_mux_sel;
        wire lo_hi_sel;
        wire we_dm_dp_cu;
        
        datapath dp (
            .clock          (clock),
            .reset          (reset),
            .BR             (BR),
            .jumpTo         (jumpTo),
            .reg_dst        (reg_dst),
            .we_reg         (we_reg),
            .alu_src        (alu_src),
            .dm2reg         (dm2reg),
            .we_dm      (we_dm_dp_cu),
            .mult_en        (mult_en),
            .alu_control    (alu_control),
            .ra_three       (ra_three),
            .instr          (instr),
            .rd_datamem     (rd_datamem),
            .pc_current     (pc_current),
            .alu_outM2W     (alu_out),
            .wd_dmQ         (wd_dm),
            .rd_three       (rd_three),
            //NEW WIRES
            .l_or_r         (l_or_r),
            .shift_sel      (shift_sel),
            .jal_pc_sel     (jal_pc_sel),
            .mult_sel       (mult_sel),
            .jal_addr_sel   (jal_addr_sel),
            .jr_mux_sel     (jr_mux_sel),
            .lo_hi_sel      (lo_hi_sel),
            .we_dmQ     (we_dm),
            .jal_wd_mux_out (jal_wd_mux_out),
            .shift_out      (shift_out),
            .alu_pa         (alu_pa),
            .lo_product     (lo_product),
            .hi_product     (hi_product),
            .lo_out         (lo_out),
            .hi_out         (hi_out),
            .lo_hi_out      (lo_hi_out),
            .mult_mux_out   (mult_mux_out)
        );
        
        controlunit cu (
            .opcode         (instr[31:26]),
            .funct          (instr[5:0]),
            .BR             (BR),
            .jumpTo         (jumpTo),
            .reg_dst        (reg_dst),
            .we_reg     (we_reg),
            .alu_src        (alu_src),
            .we_dm      (we_dm_dp_cu),
            .dm2reg         (dm2reg),
            .alu_control    (alu_control),
            .l_or_r         (l_or_r),
            .shift_sel      (shift_sel),
            .jal_pc_sel     (jal_pc_sel),
            .mult_sel       (mult_sel),
            .jal_addr_sel   (jal_addr_sel),
            .jr_mux_sel     (jr_mux_sel),
            .lo_hi_sel      (lo_hi_sel),
            .mult_en        (mult_en)
        );
        
endmodule
