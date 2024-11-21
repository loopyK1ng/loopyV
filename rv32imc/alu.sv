/********************************************************
 * The arithmetic logic unit of the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2023 Lennart M. Reimann
********************************************************/

`include "loopyV_constants.svh"

module alu ( 
            input logic[31:0] operand1,
            input logic[31:0] operand2,
            input logic[3:0] aluCntrl,
            output logic[31:0] result);

//TODO 



always_comb begin
    case (aluCntrl)
        ALU_ADD:    result = signed'(operand1) + signed'(operand2);
        ALU_SUB:    result = signed'(operand1) - signed'(operand2);
        ALU_SLT:    result = {31'b0, signed'(operand1) < signed'(operand2)};
        ALU_SLTU:   result = {31'b0, unsigned'(operand1) < unsigned'(operand2)};
        ALU_AND:    result = operand1 & operand2;
        ALU_OR:     result = operand1 | operand2;
        ALU_XOR:    result = operand1 ^ operand2;
        ALU_SLL:    result = operand1 << operand2[4:0];
        ALU_SRL:    result = operand1 >> operand2[4:0];
        ALU_SRA:    result = signed'(operand1) >>> operand2[4:0];
        default:    result = 32'b0;
    endcase
end


endmodule