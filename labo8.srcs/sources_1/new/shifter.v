`timescale 1ns / 1ps

module shifter(
        input wire [31:0] in,
        input wire l_or_r,
        input wire [4:0] shamt,
        output wire [31:0] out
    );
    
        //always@(in, l_or_r, shamt)
        //begin
        assign out = l_or_r ? {in >> shamt} : {in << shamt};
        //end
endmodule
