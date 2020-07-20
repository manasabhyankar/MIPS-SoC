`timescale 1ns / 1ps

module datapath (
        input wire clock,
        input wire reset,
        input wire BR,
        input wire jumpTo,
        input wire reg_dst,
        input wire we_reg,
        input wire alu_src,
        input wire dm2reg,
        input wire we_dm,
        input wire mult_en,
        input wire [2:0] alu_control,
        input wire [4:0] ra_three,
        input wire [31:0] instr,
        input wire [31:0] rd_datamem,
        output wire [31:0] pc_current,
        // output wire [31:0] alu_out,
        output wire [31:0] alu_outM2W,
        output wire [31:0] wd_dmQ,
        output wire [31:0] rd_three,
        /*NEW WIRES*/
        input wire l_or_r,
        input wire shift_sel,
        input wire jal_pc_sel,
        input wire mult_sel,
        input wire jal_addr_sel,
        input wire jr_mux_sel,
        input wire lo_hi_sel,
        output wire [31:0] jal_wd_mux_out, // for probing
        output wire [31:0] shift_out,
        output wire [31:0] alu_pa,
        output wire we_dmQ,
        output wire [31:0] lo_product,
        output wire [31:0] hi_product,
        output wire [31:0] lo_out,
        output wire [31:0] hi_out,
        output wire [31:0] lo_hi_out,
        output wire [31:0] mult_mux_out
    );
        wire [4:0] rf_wa;
        wire pc_src;
        wire [31:0] pc_plus4;
        // wire [31:0] pc_plus8;
        wire [31:0] pc_pre;
        wire [31:0] pc_next;
        wire [31:0] sext_imm;
        wire [31:0] ba;
        wire [31:0] bta;
        //wire [31:0] btaQ;s
        wire [31:0] jta;
        //wire [31:0] alu_pa;
        wire [31:0] alu_pb;
        wire [31:0] wd_rf;
        wire [31:0] wd_dm;
        wire [31:0] alu_out;
        wire zero;
        /*NEW WIRES*/
        //wire [31:0] shift_out;
        wire [31:0] shift_mux_out;
        //wire [31:0] jal_wd_mux_out;
        // wire [31:0] mult_mux_out;
        // wire [31:0] lo_hi_out;
        wire [4:0] jal_mux_out;
        // wire [31:0] lo_product;
        // wire [31:0] hi_product;
        // wire [31:0] lo_out;
        // wire [31:0] hi_out;
        wire [31:0] jr_mux_out;
        /*NEW PIPELINE WIRES*/
        wire jumpToQ;
        wire reg_dstQ;
        wire jal_addr_selQ;
        wire alu_srcQ;
        wire [2:0] alu_controlQ;
        wire [31:0] sext_immQ;
        wire [31:0] alu_paQ;
        wire [4:0] rsQ;
        wire [4:0] rtQ;
        wire BRQ;
        wire zeroQ;
        wire mult_enQ;
        // wire [31:0] wd_dmQ;
        wire [31:0] lo_productQ;
        wire [31:0] hi_productQ;
        wire jal_pc_regQ;
        wire dm2regQ;
        wire lo_hi_selQ;
        wire mult_selQ;
        wire [4:0] jal_mux_outQ;
        wire shift_selQ;
        wire jr_mux_selQ;
        // wire we_dmQ;
        wire l_or_rQ;
        wire [31:0] btaQ;
        wire jal_pc_selQ;
        wire we_regQ;
        // wire [31:0] alu_outQ;
        wire [31:0] alu_outQ;
        wire [4:0] rf_waQ;
        wire [31:0] pc_plus4Q;
        wire [31:0] rd_datamemQ;
        wire [31:0] instrQ;
        wire [31:0] wd_dm_shiftQ;
        wire l_or_r_shiftQ;
        /*PIPELINE WIRES*/
        /* FROM DECODE TO EXECUTE */
        wire BRD2E;
        wire jal_pc_selD2E;
        wire reg_dstD2E;
        wire jal_addr_selD2E;
        wire alu_srcD2E;
        wire we_dmD2E;
        wire dm2regD2E;
        wire we_regD2E;
        wire l_or_rd_twoE;
        wire [2:0] alu_controlD2E;
        wire lo_hi_selD2E;
        wire mult_enD2E;
        wire mult_selD2E;
        wire jr_mux_selD2E;
        wire shift_selD2E;
        wire [31:0] instrd_twoE;
        wire [31:0] pc_plus4D2E;
        /* FROM EXECUTE TO MEMORY REG*/
        wire BRE2M;
        wire we_dmE2M;
        wire we_regE2M;
        wire dm2regE2M;
        wire l_or_rE2M;
        wire lo_hi_selE2M;
        wire mult_enE2M;
        wire shift_selE2M;
        wire [31:0] wd_dmE2M;
        wire [31:0] pc_plus4E2M;
        wire jal_pc_selE2M;
        wire jal_addr_selE2M;
        wire mult_selE2M;
        wire [31:0] alu_paE2M;
        wire [31:0] instrE2M;
        wire [31:0] sext_immE2M;
        // FROM MEMORY TO WRITEBACK REG
        wire we_dmM2W;
        wire we_regM2W;
        wire dm2regM2W;
        wire lo_hi_selM2W;
        wire shift_selM2W;
        wire jal_pc_selM2W;
        wire jal_addr_selM2W;
        wire l_or_rM2W;
        wire mult_selM2W;
        wire mult_enM2W;
        //wire [31:0] alu_outM2W;
        wire [4:0] rf_waM2W;
        wire [31:0] pc_plus4M2W;
        wire [31:0] lo_productM2W;
        wire [31:0] hi_productM2W;
        wire [31:0] instrM2W;
        // assign pc_src = BR & zero;
        assign pc_src = BRQ & zeroQ;
        // assign ba = {sext_imm[29:0], 2'b00};
        assign ba = {sext_immQ[29:0], 2'b00};
        assign jta = {pc_plus4[31:28], instr[25:0], 2'b00};
        //
        // PIPELINE LOGIC //
        //12/2/18
        CUdecodeReg cu_decReg(
        .clock (clock),
        .reset (reset),
        .BRD (BR),
        .jal_pc_selD (jal_pc_sel),
        .reg_dstD (reg_dst),
        .jal_addr_selD (jal_addr_sel),
        .alu_srcD (alu_src),
        .writeE_dmD (we_dm),
        .dm2regD (dm2reg),
        .writeE_regD (we_reg),
        .l_or_rD (l_or_r),
        .alu_controlD (alu_control),
        .lo_hi_selD (lo_hi_sel),
        .mult_enD (mult_en),
        .mult_selD (mult_sel),
        .jr_mux_selD (jr_mux_sel),
        .shift_selD (shift_sel),
        .BRQ (BRD2E),
        .jal_pc_selQ (jal_pc_selD2E),
        .reg_dstQ (reg_dstD2E), //connected to rf_wa_mux
        .jal_addr_selQ (jal_addr_selD2E),
        .alu_srcQ (alu_srcD2E),
        .writeE_dmQ (we_dmD2E),
        .dm2regQ (dm2regD2E),
        .writeE_regQ (we_regD2E),
        .l_or_rQ (l_or_rd_twoE),
        .alu_controlQ (alu_controlD2E),
        .lo_hi_selQ (lo_hi_selD2E),
        .mult_enQ (mult_enD2E),
        .mult_selQ (mult_selD2E),
        .jr_mux_selQ (jr_mux_selD2E),
        .shift_selQ (shift_selD2E)
        );
        DPdecodeReg dp_decReg(
        .clock (clock),
        .reset (reset),
        .instrD (instr),
        .pc_plus4D (pc_plus4),
        .instrQ (instrd_twoE),
        .pc_plus4Q (pc_plus4D2E)
        );
        
        CUexecuteReg cu_exeReg(
        .clock (clock),
        .reset (reset),
        .BRD (BRD2E),
        .jal_pc_selD (jal_pc_selD2E),
        .reg_dstD (reg_dstD2E),
        .jal_addr_selD (jal_addr_selD2E),
        .alu_srcD (alu_srcD2E),
        .writeE_dmD (we_dmD2E),
        .dm2regD (dm2regD2E),
        .writeE_regD (we_regD2E),
        .l_or_rD (l_or_rd_twoE),
        .alu_controlD (alu_controlD2E),
        .lo_hi_selD (lo_hi_selD2E),
        .mult_enD (mult_enD2E),
        .mult_selD (mult_selD2E),
        .jr_mux_selD (jr_mux_selD2E),
        .shift_selD (shift_selD2E),
        .BRQ (BRE2M),
        .jal_pc_selQ (jal_pc_selE2M),
        .reg_dstQ (reg_dstQ), //connected to rf_wa_mux
        .jal_addr_selQ (jal_addr_selE2M),
        .alu_srcQ (alu_srcQ),
        .writeE_dmQ (we_dmE2M),
        .dm2regQ (dm2regE2M),
        .writeE_regQ (we_regE2M),
        .l_or_rQ (l_or_rE2M),
        .alu_controlQ (alu_controlQ),
        .lo_hi_selQ (lo_hi_selE2M),
        .mult_enQ (mult_enE2M),
        .mult_selQ (mult_selE2M),
        .jr_mux_selQ (jr_mux_selQ),
        .shift_selQ (shift_selE2M)
        );
        DPexecuteReg dp_exeReg(
        .clock (clock),
        .reset (reset),
        .alu_paD (alu_pa),
        .wd_dmD (wd_dm),
        .instrD (instrd_twoE),
        .sext_immD (sext_imm),
        .pc_plus4D (pc_plus4D2E),
        .alu_paQ (alu_paQ),
        .wd_dmQ (wd_dmE2M),
        .instrQ (instrE2M),
        .sext_immQ (sext_immQ),
        .pc_plus4Q (pc_plus4E2M)
        );
        CUmemoryReg cu_memReg(
        .clock (clock),
        .reset (reset),
        .BRD (BRE2M),
        .jal_pc_selD (jal_pc_selE2M),
        .jal_addr_selD (jal_addr_selE2M),
        .writeE_dmD (we_dmE2M),
        .dm2regD (dm2regE2M),
        .writeE_regD (we_regE2M),
        .l_or_rD (l_or_rE2M),
        .lo_hi_selD (lo_hi_selE2M),
        .mult_enD (mult_enE2M),
        .mult_selD (mult_selE2M),
        .shift_selD (shift_selE2M),
        .BRQ (BRQ),
        .jal_pc_selQ (jal_pc_selM2W),
        .jal_addr_selQ (jal_addr_selM2W),
        .writeE_dmQ (we_dmQ),
        .dm2regQ (dm2regM2W),
        .writeE_regQ (we_regM2W),
        .l_or_rQ (l_or_rQ),
        .lo_hi_selQ (lo_hi_selM2W),
        .mult_enQ (mult_enM2W),
        .mult_selQ (mult_selM2W),
        .shift_selQ (shift_selM2W)
        );
        DPmemoryReg dp_memReg(
        .clock (clock),
        .reset (reset),
        .zeroD (zero),
        .alu_outD (alu_out),
        .wd_dmD (wd_dmE2M),
        .rf_waD (rf_wa),
        .btaD (bta),
        .pc_plus4D (pc_plus4E2M),
        .hi_productD (hi_product),
        .lo_productD (lo_product),
        .instrD (instrE2M),
        .zeroQ (zeroQ),
        .alu_outQ (alu_outM2W),
        .wd_dmQ (wd_dmQ),
        .rf_waQ (rf_waM2W),
        .btaQ (btaQ),
        .pc_plus4Q (pc_plus4M2W),
        .hi_productQ (hi_productM2W),
        .lo_productQ (lo_productM2W),
        .instrQ (instrM2W)
        );
        CUwritebackReg cu_wbReg(
        .clock (clock),
        .reset (reset),
        .jal_pc_selD (jal_pc_selM2W),
        .jal_addr_selD (jal_addr_selM2W),
        .dm2regD (dm2regM2W),
        .writeE_regD (we_regM2W),
        .lo_hi_selD (lo_hi_selM2W),
        .mult_enD (mult_enM2W),
        .mult_selD (mult_selM2W),
        .shift_selD (shift_selM2W),
        .l_or_r_shiftD (l_or_rQ),
        .jal_pc_selQ (jal_pc_selQ),
        .jal_addr_selQ (jal_addr_selQ),
        .dm2regQ (dm2regQ),
        .writeE_regQ (we_regQ),
        .lo_hi_selQ (lo_hi_selQ),
        .mult_enQ (mult_enQ),
        .mult_selQ (mult_selQ),
        .shift_selQ (shift_selQ),
        .l_or_r_shiftQ (l_or_r_shiftQ)
        );
        DPwritebackReg dp_wbReg(
        .clock (clock),
        .reset (reset),
        .alu_outD (alu_outM2W),
        .rf_waD (rf_waM2W),
        .pc_plus4D (pc_plus4M2W),
        .rd_datamemD (rd_datamem),
        .lo_productD (lo_productM2W),
        .hi_productD (hi_productM2W),
        .instrD (instrM2W),
        .wd_dm_shiftD (wd_dmQ),
        //.mult_outD
        .alu_outQ (alu_outQ),
        .rf_waQ (rf_waQ),
        .pc_plus4Q (pc_plus4Q),
        .rd_datamemQ (rd_datamemQ),
        .lo_productQ (lo_productQ),
        .hi_productQ (hi_productQ),
        .instrQ (instrQ),
        .wd_dm_shiftQ (wd_dm_shiftQ)
        //.mult_outQ
        );
        // --- PC Logic --- //
        dreg pc_reg (
        .clock (clock),
        .reset (reset),
        // .d (pc_next),
        .en (1'b1),
        .d (jr_mux_out), // NEW WIRE
        .q (pc_current)
        );
        adder pc_plus_4 (
        .a (pc_current),
        .b (32'd4),
        .y (pc_plus4)
        );
        // adder pc_plus_8(
        // .a (pc_plus4),
        // .b (32'd4),
        // .y (pc_plus8)
        // );
        adder pc_plus_br (
        .a (pc_plus4),
        //.a (pc_plus4E2M),
        .b (ba),
        .y (bta)
        );
        mux2 #(32) pc_src_mux (
        .selection (pc_src),
        .one (pc_plus4),
        // .two (bta),
        .two (btaQ),
        .out (pc_pre)
        );
        mux2 #(32) pc_jmp_mux (
        .selection (jumpTo),
        .one (pc_pre),
        .two (jta),
        .out (pc_next)
        );
        // --- RF Logic --- //
        mux2 #(5) rf_wa_mux (
        // .selection (reg_dst),
        .selection (reg_dstQ),
        .one (instrE2M[20:16]),
        .two (instrE2M[15:11]),
        .out (rf_wa)
        );
        
        regfile rf (
        .clock (clock),
        .we (we_regQ),
        .ra_one (instrd_twoE[25:21]),
        .ra_two (instrd_twoE[20:16]),
        .ra_three (ra_three),
        //.wa (rf_wa),
        .wa (jal_mux_outQ), // NEW WIRE
        .wd (jal_wd_mux_out),
        .rd_one (alu_pa),
        .rd_two (wd_dm),
        .rd_three (rd_three)
        );
        //NEW MODULES
        // mux2 #(32) jr_mux {
        // .selectionectionection (jr_mux_sel),
        // .one (pc_next),
        // .two (alu_pa),
        // .out (jr_mux_out)
        // };
        mux2 #(32) jr_mux (
        // .selection (jr_mux_sel),
        .selection (jr_mux_selQ),
        .one (pc_next),
        .two (alu_pa),
        .out (jr_mux_out)
        );
        // mux2 #(32) jal_wd_mux{
        // .selectionectionection(jal_pc_sel),
        // .one(shift_mux_out),
        // .two(pc_plus_4),
        // .out(jal_wd_mux_out)
        // };
        mux2 #(32) jal_wd_mux (
        // .selection (jal_pc_sel),
        .selection (jal_pc_selQ),
        .one (shift_mux_out),
        .two (pc_plus4Q),
        .out (jal_wd_mux_out)
        );
        // mux2 $(32) jal_mux{
        // .selectionectionection(jal_addr_sel),
        // .one(rf_wa),
        // .two(5'b11111),
        // .out(jal_mux_out)
        // };
        mux2 #(5) jal_mux (
        // .selection (jal_addr_sel),
        .selection (jal_addr_selQ),
        // .one (rf_wa),
        .one (rf_waQ),
        .two (5'b11111),
        .out (jal_mux_outQ)
        );
        shifter shift (
        .in (wd_dm_shiftQ),
        //.in(wd_dmQ),
        // .l_or_r (l_or_r),
        .l_or_r (l_or_r_shiftQ),
        .shamt (instrQ[10:6]),
        //.shamt (instrQ[10:6]),
        .out (shift_out)
        );
        // mux2 #(32) shift_mux{
        // .selection (shift_sel),
        // .one (mult_mux_out),
        // .two (shift_out),
        // .out(shift_mux_out)
        // };
        mux2 #(32) shift_mux (
        // .selection (shift_sel),
        .selection (shift_selQ),
        .one (mult_mux_out),
        .two (shift_out),
        .out (shift_mux_out)
        );
        // multu mult{
        // .a (alu_pa),
        // .b (wd_dm),
        // .hi (hi_product),
        // .lo (lo_product)
        // };
        multu mult(
        .a (alu_paQ),
        .b (wd_dmE2M),
        .hi (hi_product),
        .lo (lo_product)
        );
        // mux2 $(32) mult_mux{
        // .selection(mult_sel),
        // .one(wd_rf),
        // .two(lo_hi_out),
        // .out(mult_mux_out)
        // };
        mux2 #(32) mult_mux (
        // .selection (mult_sel),
        .selection (mult_selQ),
        .one (wd_rf),
        .two (lo_hi_out),
        .out (mult_mux_out)
        );
        // mux2 $(32) lo_hi_mux{
        // .selection(lo_hi_sel),
        // .one(lo_out),
        // .two(hi_out),
        // .out(lo_hi_out)
        // };
        mux2 #(32) lo_hi_mux (
        // .selection (lo_hi_sel),
        .selection (lo_hi_selQ),
        .one (lo_out),
        .two (hi_out),
        .out (lo_hi_out)
        );
        dreg mflo(
        .clock (clock),
        .reset (reset),
        .en (mult_enQ),
        .d (lo_productQ),
        .q (lo_out)
        );
        dreg mfhi(
        .clock (clock),
        .reset (reset),
        .en (mult_enQ),
        .d (hi_productQ),
        .q (hi_out)
        );
        //END NEW MODULES
        signext se (
        .in (instrd_twoE[15:0]),
        .out (sext_imm)
        );
        // --- ALU Logic --- //
        mux2 #(32) alu_pb_mux (
        // .selection (alu_src),
        .selection (alu_srcQ),
        .one (wd_dmE2M),
        .two (sext_immQ),
        .out (alu_pb)
        );
        alu alu (
        // .op (alu_control),
        .op (alu_controlQ),
        // .a (alu_pa),
        .a (alu_paQ),
        .b (alu_pb),
        .zero (zero),
        .y (alu_out)
        );
        // --- MEM Logic --- //
        mux2 #(32) rf_wd_mux (
        // .selection (dm2reg),
        .selection (dm2regQ),
        // .one (alu_out),
        .one (alu_outQ),
        .two (rd_datamemQ),
        .out (wd_rf)
        );
endmodule
