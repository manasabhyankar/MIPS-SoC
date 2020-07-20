`timescale 1ns / 1ps

module BUFFER #(parameter WIDTH = 8)(
        input wire OE,
        input wire [WIDTH-1:0] in,
        output wire [WIDTH-1:0] out
    );
    
    assign out = OE ? in : {WIDTH{1'bz}};
    
endmodule