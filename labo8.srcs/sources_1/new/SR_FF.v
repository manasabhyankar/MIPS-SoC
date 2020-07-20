`timescale 1ns / 1ps

module SR_FF #(parameter WIDTH=32) (
        input clock, reset,
        input [WIDTH-1:0] S,
        output reg [WIDTH-1:0] Q 
    );
    
        initial Q <= 0;
        
        always @ ( posedge clock, posedge reset ) begin
        if(reset) begin
            Q <= 0;
            end 
            else if(S) begin
            Q <= S;
            end
        end
        
endmodule
