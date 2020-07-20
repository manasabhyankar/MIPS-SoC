`timescale 1ns / 1ps

module maindec (
        input wire [5:0] opcode,
        output wire BR,
        output wire jumpTo,
        output wire reg_dst,
        output wire we_reg,
        output wire alu_src,
        output wire we_dm,
        output wire dm2reg,
        output wire [1:0] aluopcode,
        //NEW WIRES
        output wire jal_addr_sel,
        output wire jal_pc_sel
    );
    
    //reg [8:0] ctrl;
    reg[10:0] ctrl;
    //assign {BR, jumpTo, reg_dst, we_reg, alu_src, we_dm, dm2reg, aluopcode} = ctrl;
    assign {jal_pc_sel, jal_addr_sel, BR, jumpTo, reg_dst, we_reg, alu_src, we_dm, dm2reg, aluopcode} = ctrl;
    always @ (opcode) begin
        case (opcode)
            // 6'b00_0000: ctrl = 9'b0_0_1_1_0_0_0_10; // R-type
            // 6'b00_1000: ctrl = 9'b0_0_0_1_1_0_0_00; // ADDI
            // 6'b00_0100: ctrl = 9'b1_0_0_0_0_0_0_01; // BEQ
            // 6'b00_0010: ctrl = 9'b0_1_0_0_0_0_0_00; // J
            // 6'b10_1011: ctrl = 9'b0_0_0_0_1_1_0_00; // SW
            // 6'b10_0011: ctrl = 9'b0_0_0_1_1_0_1_00; // LW
            //NEW CONTROL SIGNALS
            6'b00_0000: ctrl = 11'b0_0_0_0_1_1_0_0_0_10; // R-type
            6'b00_1000: ctrl = 11'b0_0_0_0_0_1_1_0_0_00; // ADDI
            6'b00_0100: ctrl = 11'b0_0_1_0_0_0_0_0_0_01; // BEQ
            6'b00_0010: ctrl = 11'b0_0_0_1_0_0_0_0_0_00; // J
            6'b10_1011: ctrl = 11'b0_0_0_0_0_0_1_1_0_00; // SW
            6'b10_0011: ctrl = 11'b0_0_0_0_0_1_1_0_1_00; // LW
            6'b00_0011: ctrl = 11'b1_1_0_1_0_1_0_0_0_00; // JAL might need to change aluopcode
            default: ctrl = 11'bx_x_x_x_x_x_x_x_x_xx;
        endcase
    end
endmodule
