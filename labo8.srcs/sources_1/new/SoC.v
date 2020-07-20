`timescale 1ns / 1ps

module SoC(
            input  wire        clk,
            input  wire        rst,
            input  wire [4:0]  ra3,
            input  wire [31:0] gpi1,
            input  wire [31:0] gpi2,
            output wire        we_dm,
            output wire [31:0] pc_current,
            output wire [31:0] instr,
            output wire [31:0] alu_out,
            output wire [31:0] alu_pa,
            output wire [31:0] wd_dm,
            output wire [31:0] rd_dm,
            output wire [31:0] rd3,
            output wire [31:0] gpo1,
            output wire [31:0] gpo2 
//            // ra_three and rd_three will not be used
//            input clock, reset, we_dm,
//            input [4:0] ra_three,
//            input [31:0] gpi_one, gpi_two,
//            output [31:0] rd_three, gpo_one, gpo_two
        );
        
        wire WEM, WE1, WE2;
        wire [1:0] RD_sel;
        wire [31:0] DONT_USE;
        wire [31:0] reg31_or_rf_wa;
        wire [31:0] dmem_out;
        wire [31:0] fact_out;
        wire [31:0] gpio_out;
        
        
        mips mips_top(
            .clock          (clk),
            .reset          (rst),
            .ra_three       (ra3),
            .instr          (instr),
            .rd_datamem     (rd_dm),
            .we_dm          (we_dm),
            .pc_current     (pc_current),
            .alu_out        (alu_out),
            .alu_pa         (alu_pa),
            .wd_dm          (wd_dm),
            .rd_three       (rd3)
        );
        
        imem imem (
            .a              (pc_current[7:2]),
            .y              (instr)
        );
        
        dmem dmem (
            .clock          (clk),
            .we             (WEM),
            .a              (alu_out[7:2]),
            .d              (rd_dm),
            .q              (dmem_out)
        );
        //address
        SoC_ad Soc_ad(
            .A              (alu_out),
            .WE             (we_dm),
            .secWE          (WE1),
            .firstWE        (WE2),
            .WEM            (WEM),
            .RdSel          (RD_sel)
        );
        
        fact_top fact_top(
            .A              (alu_out[3:2]),
            .WE             (WE1),
            .WD             (wd_dm[3:0]),
            .reset          (rst),
            .clock          (clk),
            .RD             (fact_out)
        );
        
        gpio_top gpio_top(
            .A              (alu_out[3:2]),
            .WE             (WE2),
            .gpi_one        (gpi1),
            .gpi_two        (gpi2),
            .WD             (wd_dm),
            .reset          (rst),
            .clock          (clk),
            .RD             (gpio_out),
            .gpo_one        (gpo1),
            .gpo_two        (gpo2)
        );
        
        mux4 #(32) mux4(
            RD_sel,
            dmem_out,
            dmem_out,
            fact_out,
            gpio_out,
            rd_dm
        );
endmodule
