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
    input  logic [31:0] operandA,
    input  logic [31:0] operandB,
    input  logic [ 3:0] aluCntrl,
    output logic [31:0] result
);

  //TODO 



  always_comb begin
    case (aluCntrl)
      ALU_ADD:  result = signed'(operandA) + signed'(operandB);
      ALU_SUB:  result = signed'(operandA) - signed'(operandB);
      ALU_SLT:  result = {31'b0, signed'(operandA) < signed'(operandB)};
      ALU_SLTU: result = {31'b0, unsigned'(operandA) < unsigned'(operandB)};
      ALU_AND:  result = operandA & operandB;
      ALU_OR:   result = operandA | operandB;
      ALU_XOR:  result = operandA ^ operandB;
      ALU_SLL:  result = operandA << operandB[4:0];
      ALU_SRL:  result = operandA >> operandB[4:0];
      ALU_SRA:  result = signed'(operandA) >>> operandB[4:0];
      default:  result = 32'b0;
    endcase
  end


endmodule
