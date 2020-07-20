`timescale 1ns / 1ps

module tb_mips_top;
    reg         clk;
    reg         rst;
    wire        we_dm;
    wire [31:0] pc_current;
    wire [31:0] instr;
    wire [31:0] alu_out;
    wire [31:0] wd_dm;
    wire [31:0] rd_datamem;
    wire [31:0] DONT_USE;
    //new wires
//    wire [31:0] jal_wd_mux_out; 
//    wire [31:0] shift_out; 
//    wire        we_reg;
//    wire [31:0] alu_pa;
//    wire [31:0] lo_produc;
//    wire [31:0] hi_product;
//    wire [31:0] lo_out;
//    wire [31:0] hi_out;
//    wire [31:0] lo_hi_out;
//    wire [31:0] mult_mux_out;
    
    mips DUT (
            .clock          (clk),
            .reset          (rst),
            .ra_three       (5'h0),
            .instr          (instr),
            .rd_datamem     (rd_datamem),
            .we_dm          (we_dm),
            .pc_current     (pc_current),
            .alu_out        (alu_out),
            .wd_dm          (wd_dm),
            .rd_three       (DONT_USE)
            //this is just to see what is happening
//            .jal_wd_mux_out (jal_wd_mux_out),
//            .shift_out      (shift_out),
//            .we_reg         (we_reg),
//            .alu_pa         (alu_pa),
//            .lo_product     (lo_produc),
//            .hi_product     (hi_product),
//            .lo_out         (lo_out),
//            .hi_out         (hi_out),
//            .lo_hi_out      (lo_hi_out),
//            .mult_mux_out   (mult_mux_out)
        );
    
    task tick; 
    begin 
        clk = 1'b0; #5;
        clk = 1'b1; #5;
    end
    endtask

    task reset;
    begin 
        rst = 1'b0; #5;
        rst = 1'b1; #5;
        rst = 1'b0;
    end
    endtask
    
    initial begin
        reset;
        while(pc_current != 32'h48) tick;
        $finish;
    end

endmodule

