`timescale 1ns / 1ps

module regfile (
        input wire clock,
        input wire we,
        input wire [4:0] ra_one,
        input wire [4:0] ra_two,
        input wire [4:0] ra_three,
        input wire [4:0] wa,
        input wire [31:0] wd,
        output wire [31:0] rd_one,
        output wire [31:0] rd_two,
        output wire [31:0] rd_three
    );
    
        reg [31:0] rf [0:31];
        
        integer n;
        
        initial begin
            for (n = 0; n < 32; n = n + 1) rf[n] = 32'h0;
            rf[29] = 32'h100; // Initialze $sp
        end
        
        always @ (posedge clock) begin
            if (we) rf[wa] <= wd;
        end
        
        assign rd_one = (ra_one == 0) ? 0 : rf[ra_one];
        assign rd_two = (ra_two == 0) ? 0 : rf[ra_two];
        assign rd_three = (ra_three == 0) ? 0 : rf[ra_three];
        
endmodule