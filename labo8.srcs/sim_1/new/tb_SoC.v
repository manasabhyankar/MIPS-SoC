`timescale 1ns / 1ps

module tb_SoC;
            reg         tb_clk;
            reg         tb_rst;
            reg  [4:0]  tb_ra3;
            reg  [31:0] tb_gpi1;
            reg  [31:0] tb_gpi2;
            wire        tb_we_dm;
            wire [31:0] tb_pc_current;
            wire [31:0] tb_instr;
            wire [31:0] tb_alu_out;
            wire [31:0] tb_alu_pa;
            wire [31:0] tb_wd_dm;
            wire [31:0] tb_rd_dm;
            wire [31:0] tb_rd3;
            wire [31:0] tb_gpo1;
            wire [31:0] tb_gpo2;
    
    SoC DUT(
            .clk            (tb_clk),
            .rst            (tb_rst),
            .ra3            (tb_ra3),
            .gpi1           (tb_gpi1),
            .gpi2           (tb_gpi2),
            .we_dm          (tb_we_dm),
            .pc_current     (tb_pc_current),
            .instr          (tb_instr),
            .alu_out        (tb_alu_out),
            .alu_pa         (tb_alu_pa),
            .wd_dm          (tb_wd_dm),
            .rd_dm          (tb_rd_dm),
            .rd3            (tb_rd3),
            .gpo1           (tb_gpo1),
            .gpo2           (tb_gpo2)
    );
    
    task tick;
        begin
            tb_clk = 1'b0; #10; 
            tb_clk = 1'b1; #10; 
        end
    endtask
    
    task reset; 
        begin
            tb_rst = 1'b0; #1; 
            tb_rst = 1'b1; #1; 
            tb_rst = 1'b0;
        end
    endtask 
           
    integer i, j;
    integer exp_result = 0;        
    initial begin
    
        reset; 
        
        for(i = 0; i < 4; i = i +1) begin
            tb_gpi1 = i; 
            exp_result = 1;
            if(i==0)exp_result = 1; 
            for(j = i; j > 0; j = j-1) begin
                exp_result = exp_result * j;
            end
            tick;
            while(tb_pc_current != 32'h64) tick; 
             
        end 
        $finish;       
    end
    
endmodule
