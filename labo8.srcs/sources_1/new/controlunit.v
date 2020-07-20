`timescale 1ns / 1ps

module controlunit (
        input wire [5:0] opcode,
        input wire [5:0] funct,
        output wire BR,
        output wire jumpTo,
        output wire reg_dst,
        output wire we_reg,
        output wire alu_src,
        output wire we_dm,
        output wire dm2reg,
        output wire [2:0] alu_control,
        //NEW WIRES
        output wire l_or_r,
        output wire shift_sel,
        output wire jal_pc_sel,
        output wire mult_sel,
        output wire jal_addr_sel,
        output wire jr_mux_sel,
        output wire lo_hi_sel,
        output wire mult_en
    );
        wire [1:0] aluopcode;
        
        maindec md (
        .opcode (opcode),
        .BR (BR),
        .jumpTo (jumpTo),
        .reg_dst (reg_dst),
        .we_reg (we_reg),
        .alu_src (alu_src),
        .we_dm (we_dm),
        .dm2reg (dm2reg),
        .aluopcode (aluopcode),
        //MEW WIRES
        .jal_addr_sel (jal_addr_sel),
        .jal_pc_sel (jal_pc_sel)
        );
        
        auxdec ad (
        .aluopcode (aluopcode),
        .funct (funct),
        .alu_control (alu_control),
        //NEW WIRES
        .l_or_r (l_or_r),
        .shift_sel (shift_sel),
        .mult_sel (mult_sel),
        .lo_hi_sel (lo_hi_sel),        
        .jr_mux_sel (jr_mux_sel),
        .mult_en (mult_en)
        );

endmodule
