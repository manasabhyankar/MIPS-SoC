`timescale 1ns / 1ps

module dmem (
    input  wire        clock,
    input  wire        we,
    input  wire [5:0]  a,
    input  wire [31:0] d,
    output wire [31:0] q
);

    reg [31:0] ram [0:63];
    
    integer n;
    
    initial begin
        for (n = 0; n < 64; n = n + 1) ram[n] = 32'hFFFFFFFF;
    end
    
    always @ (posedge clock) begin
        if (we) ram[a] <= d;
    end
    
    assign q = ram[a];
    
endmodule
