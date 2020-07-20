`timescale 1ns / 1ps

module FMUX2 #(parameter WIDTH = 8)(
        input wire [WIDTH-1:0] in1,
        input wire [WIDTH-1:0] in2,
        input wire s2,
        output reg [WIDTH-1:0] m2out
    );
    
        always @(in1, in2, s2) begin
            if(s2) begin
                m2out = in1;
            end else begin
                m2out = in2;
            end
        end
        
endmodule
