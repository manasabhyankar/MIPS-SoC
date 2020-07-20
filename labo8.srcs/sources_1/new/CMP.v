`timescale 1ns / 1ps

module CMP #(parameter WIDTH = 8)(
        input [WIDTH-1:0] A, B,
        output reg GT
    );
        always @ (A or B) begin
                GT <= 1'b1;
            if (A <= B) GT <= 1'b0;
            else GT <= 1'b1;
        end
endmodule
