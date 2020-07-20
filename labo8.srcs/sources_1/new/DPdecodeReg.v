`timescale 1ns / 1ps

module DPdecodeReg(
        input wire clock,
        input wire reset,
        input wire [31:0] instrD,
        input wire [31:0] pc_plus4D,
        output reg [31:0] instrQ,
        output reg [31:0] pc_plus4Q
    );
    
        always @ (posedge clock, posedge reset) begin
            if (reset) begin
                instrQ <= 0;
                pc_plus4Q <= 0;
            end
            else begin
                instrQ <= instrD;
                pc_plus4Q <= pc_plus4D;
            end
        end
        
endmodule
