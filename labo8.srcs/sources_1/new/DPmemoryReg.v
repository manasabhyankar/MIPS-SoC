`timescale 1ns / 1ps

module DPmemoryReg(
            input wire clock,
            input wire reset,
            input wire zeroD,
            input wire [31:0] alu_outD,
            input wire [31:0] wd_dmD,
            input wire [4:0] rf_waD,
            input wire [31:0] btaD,
            input wire [31:0] pc_plus4D,
            input wire [31:0] hi_productD,
            input wire [31:0] lo_productD,
            input wire [31:0] instrD,
            output reg zeroQ,
            output reg [31:0] alu_outQ,
            output reg [31:0] wd_dmQ,
            output reg [4:0] rf_waQ,
            output reg [31:0] btaQ,
            output reg [31:0] pc_plus4Q,
            output reg [31:0] hi_productQ,
            output reg [31:0] lo_productQ,
            output reg [31:0] instrQ
        );
        
        always @ (posedge clock, posedge reset) begin
            if (reset) begin
                zeroQ <= 0;
                alu_outQ <= 0;
                wd_dmQ <= 0;
                rf_waQ <= 0;
                btaQ <= 0;
                pc_plus4Q <= 0;
                lo_productQ <= 0;
                hi_productQ <= 0;
                instrQ <= 0;
            end
            else begin
                zeroQ <= zeroD;
                alu_outQ <= alu_outD;
                wd_dmQ <= wd_dmD;
                rf_waQ <= rf_waD;
                btaQ <= btaD;
                pc_plus4Q <= pc_plus4D;
                lo_productQ <= lo_productD;
                hi_productQ <= hi_productD;
                instrQ <= instrD;
            end
        end
endmodule
