`timescale 1ns / 1ps

module dreg # (parameter WIDTH = 32) (
        input wire clock,
        input wire reset,
        input wire en,
        input wire [WIDTH-1:0] d,
        output reg [WIDTH-1:0] q
    );
    
    always @ (posedge clock, posedge reset) begin
        if (reset) q <= 0;
        else if (en) q <= d;
        else q <= q;
    end
    
endmodule
