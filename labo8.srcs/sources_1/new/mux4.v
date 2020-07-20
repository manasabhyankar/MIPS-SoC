`timescale 1ns / 1ps

module mux4 #(parameter WIDTH = 8) (
        input  wire [1:0]       selection,
        input  wire [WIDTH-1:0] one,
        input  wire [WIDTH-1:0] two,
        input  wire [WIDTH-1:0] three,
        input  wire [WIDTH-1:0] four,
        output wire [WIDTH-1:0] out
    );
    
    assign out = selection[1] ? (selection[0] ? four : three) : (selection[0] ? two : one);
    
endmodule
