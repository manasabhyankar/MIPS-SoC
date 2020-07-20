`timescale 1ns / 1ps

module auxdec (
            input wire [1:0] aluopcode,
            input wire [5:0] funct,
            output wire [2:0] alu_control,
            //NEW WIRES
            output wire l_or_r,
            output wire shift_sel,
            output wire mult_sel,
            output wire lo_hi_sel,
            output wire jr_mux_sel,
            output wire mult_en
        );
            // reg [2:0] ctrl;
            reg [8:0] ctrl;
            //assign {alu_control} = ctrl;
            assign {mult_en, l_or_r, shift_sel, mult_sel, lo_hi_sel, jr_mux_sel, alu_control} =
            ctrl;
            always @ (aluopcode, funct) begin
                case (aluopcode)
                    // 2'b00: ctrl = 3'b010; // ADD
                    // 2'b01: ctrl = 3'b110; // SUB
                    //NEW CHANGES
                    2'b00: ctrl = 9'b0_0_0_0_0_0_010; // ADD
                    2'b01: ctrl = 9'b0_0_0_0_0_0_110; // SUB
                    
                    default: case (funct)
                        // 6'b10_0100: ctrl = 3'b000; // AND
                        // 6'b10_0101: ctrl = 3'b001; // OR
                        // 6'b10_0000: ctrl = 3'b010; // ADD
                        // 6'b10_0010: ctrl = 3'b110; // SUB
                        // 6'b10_1010: ctrl = 3'b111; // SLT
                        //NEW CHANGES
                        6'b10_0100: ctrl = 9'b0_0_0_0_0_0_000; // AND
                        6'b10_0101: ctrl = 9'b0_0_0_0_0_0_001; // OR
                        6'b10_0000: ctrl = 9'b0_0_0_0_0_0_010; // ADD
                        6'b10_0010: ctrl = 9'b0_0_0_0_0_0_110; // SUB
                        6'b10_1010: ctrl = 9'b0_0_0_0_0_0_111; // SLT
                        6'b00_0010: ctrl = 9'b0_1_1_0_0_0_000;// SRL, might need to change alu_control
                        6'b00_0000: ctrl = 9'b0_0_1_0_0_0_000;// SLL, might need to change alu_control
                        6'b01_1001: ctrl = 9'b1_0_0_0_0_0_000;// MULTU
                        6'b01_0010: ctrl = 9'b0_0_0_1_0_0_000;// mflo
                        6'b01_0000: ctrl = 9'b0_0_0_1_1_0_000;//mfhi
                        6'b00_1000: ctrl = 9'b0_0_0_0_0_1_000;//jr
                        //default: ctrl = 3'bxxx;
                        default: ctrl = 9'bxxxxxxxxx;
                    endcase
                endcase
            end
endmodule