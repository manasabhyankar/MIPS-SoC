`timescale 1ns / 1ps

module DPwritebackReg(
        input wire clock,
        input wire reset,
        input wire [31:0] alu_outD,
        input wire [4:0] rf_waD,
        input wire [31:0] pc_plus4D,
        input wire [31:0] rd_datamemD,
        input wire [31:0] lo_productD,
        input wire [31:0] hi_productD,
        input wire [31:0] instrD,
        input wire [31:0] wd_dm_shiftD,
        output reg [31:0] alu_outQ,
        output reg [4:0] rf_waQ,
        output reg [31:0] pc_plus4Q,
        output reg [31:0] rd_datamemQ,
        output reg [31:0] lo_productQ,
        output reg [31:0] hi_productQ,
        output reg [31:0] instrQ,
        output reg [31:0] wd_dm_shiftQ
    );
        always @ (posedge clock, posedge reset) begin
            if (reset) begin
                alu_outQ <= 0;
                rf_waQ <= 0;
                pc_plus4Q <= 0;
                rd_datamemQ <= 0;
                lo_productQ <= 0;
                hi_productQ <= 0;
                instrQ <= 0;
                wd_dm_shiftQ <= 0;
            end
            else begin
                alu_outQ <= alu_outD;
                rf_waQ <= rf_waD;
                pc_plus4Q <= pc_plus4D;
                rd_datamemQ <= rd_datamemD;
                lo_productQ <= lo_productD;
                hi_productQ <= hi_productD;
                instrQ <= instrD;
                wd_dm_shiftQ <= wd_dm_shiftD;
            end
        end
endmodule