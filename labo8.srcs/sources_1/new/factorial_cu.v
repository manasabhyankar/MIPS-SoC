`timescale 1ns / 1ps

module factorial_cu(
        input GT, GT12, clock, GO, reset,
        output reg sel, ld_cnt, en, ld_reg, OE, DONE, ERR,
        output reg [3:0] state
    );
        parameter S0 = 4'b0000;
        parameter S1 = 4'b0001;
        parameter S2 = 4'b0010;
        parameter S3 = 4'b0011;
        parameter S4 = 4'b0100;
        parameter S5 = 4'b0101;
    
        reg [3:0] CS, NS;
        
        always@(posedge reset, posedge clock) begin // at the rising edge of the clock, the
                                                    //state is going to be assigned to current state
            if(reset) begin //If reset is enabled, then current state becomes 0
                CS = S0;
                end else begin
                    CS = NS;
                end
            state = CS; 
        end
            
        always@(CS, GT, GT12, GO) begin
            case(CS)
                S0: begin
                    if(GO) begin
                        NS = S1;
                    end else begin
                        NS = S0;
                    end
                end
                
                S1: begin NS = S2; end
                
                S2: begin
                    if(GT12)begin
                        NS = S0;
                    end
                    else if(GT)begin
                        NS = S2;
                    end else begin
                        NS = S0;
                    end
                end
            endcase
        end
                
        always@(CS, GT, GT12)begin
            case(CS)
                S0: begin
                    sel=1'b0; ld_cnt=1'b0; en=1'b0;
                    ld_reg=1'b0; OE=1'b0; DONE=1'b0; ERR=1'b0;
                end
                
                S1: begin
                    sel=1'b0; ld_cnt=1'b1; en=1'b1;
                    ld_reg=1'b1; OE=1'b0; DONE=1'b0; ERR=1'b0;
                end
                
                S2: begin
                    if(GT12) begin
                        sel=1'b0; ld_cnt=1'b0; en=1'b0;
                        ld_reg=1'b0; OE=1'b0; DONE=1'b0; ERR=1'b1; // OE=0
                    end else if(GT) begin
                        sel=1'b1; ld_cnt=1'b0; en=1'b1;
                        ld_reg=1'b1; OE=1'b0; DONE=1'b0; ERR=1'b0; // OE=0
                    end else begin
                        sel=1'b0; ld_cnt=1'b0; en=1'b0;
                        ld_reg=1'b0; OE=1'b1; DONE=1'b1; ERR=1'b0;
                    end
                end
                
                default: begin
                    sel=1'b0; ld_cnt=1'b0; en=1'b0;
                    ld_reg=1'b0; OE=1'b0; DONE=1'b0; ERR=1'b0;
                end
            endcase
        end
        
endmodule
