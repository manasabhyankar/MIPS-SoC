`timescale 1ns / 1ps

module MUL #(parameter WIDTH = 32) (
        input [WIDTH-1:0] A, B,
        output [WIDTH-1:0] OUT
    );
    
    assign OUT = A * B; 
    
endmodule
