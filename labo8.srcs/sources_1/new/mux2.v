`timescale 1ns / 1ps

module mux2 #(parameter WIDTH = 32) (
        input wire selection,
        input wire [WIDTH-1:0] one,
        input wire [WIDTH-1:0] two,
        output wire [WIDTH-1:0] out
    );
    
    assign out = (selection) ? two : one;
    
endmodule
