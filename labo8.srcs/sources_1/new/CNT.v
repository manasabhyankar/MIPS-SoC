`timescale 1ns / 1ps

module CNT #(parameter WIDTH = 8)(
        input LD, EN, clock, reset,
        input [WIDTH-1:0] D,
        output reg [WIDTH-1:0] Q
    );
        always @(posedge reset, posedge clock) begin
            if(reset) begin
                Q <= 0;
            end else if(EN) begin
                if(LD) begin
                    Q <= D;
                end else begin
                    //Q = Q - {{{WIDTH-1}{1'b0}},1};
                    Q <= Q - 1;
                end
            end else begin
                Q <= Q;
            end
        end
        
endmodule
