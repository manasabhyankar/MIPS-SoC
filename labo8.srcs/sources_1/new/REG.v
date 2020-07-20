`timescale 1ns / 1ps

module REG #(parameter WIDTH = 8)(
        input clock,
        input reset,
        input ld,
        input [WIDTH-1:0] d,
        output reg [WIDTH-1:0] q
    );
        // asynchronous, active HIGH reset w. enable input
        initial begin
            q = 0;
        end
        
        always @(posedge reset, posedge clock) begin
            if (reset) q <= 0;
            else if (ld) q <= d;
            else q <= q;
        end
        
endmodule
