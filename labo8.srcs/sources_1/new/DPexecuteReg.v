`timescale 1ns / 1ps

module DPexecuteReg(
            input wire clock,
            input wire reset,
            input wire [31:0] alu_paD,
            input wire [31:0] wd_dmD,
            input wire [31:0] instrD,
            input wire [31:0] sext_immD,
            input wire [31:0] pc_plus4D,
            output reg [31:0] alu_paQ,
            output reg [31:0] wd_dmQ,
            output reg [31:0] instrQ,
            output reg [31:0] sext_immQ,
            output reg [31:0] pc_plus4Q
        );
        
        always @ (posedge clock, posedge reset) begin
            if (reset) begin
                alu_paQ <= 0;
                wd_dmQ <= 0;
                instrQ <= 0;
                sext_immQ <= 0;
                pc_plus4Q <= 0;
            end
            else begin
                alu_paQ <= alu_paD;
                wd_dmQ <= wd_dmD;
                instrQ <= instrD;
                sext_immQ <= sext_immD;
                pc_plus4Q <= pc_plus4D;
            end
        end
endmodule
