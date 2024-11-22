/********************************************************
 * The pipeline ID/EX for the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2023 Lennart M. Reimann
********************************************************/

module pipeIDEX (
    input clk,
    input arstn,
    input DEStageSignals DEControl,
    output EXStageSignals EXControl
);

  logic [31:0] nextOperandA;
  logic [31:0] nextOperandB;

  IDEXPipelineType IDIDEXPipeRegister;

  // Operand Selection
  always_comb begin
    if (DEControl.operandASelect == OF_ALU_A_RS1) begin
      nextOperandA = DEControl.rs1Data;
    end else begin
      nextOperandA = DEControl.pc;
    end

    if (DEControl.operandBSelect == OF_ALU_B_RS2) begin
      nextOperandB = DEControl.rs2Data;
    end else begin
      nextOperandB = DEControl.immediate;
    end
  end

  always_ff @(posedge clk or negedge arstn) begin
    if (!arstn) begin
      IDEXPipeRegister.aluControl = ALU_ADD;
      IDEXPipeRegister.operandA = 32'b0;
      IDEXPipeRegister.operandB = 32'b0;
      IDEXPipeRegister.rdAddr = 5'b0;
      IDEXPipeRegister.rdWriteEn = 0;
      IDEXPipeRegister.destinationSelect = WB_SEL_ALU;
      IDEXPipeRegister.pc = 32'b0;
    end else begin
      IDEXPipeRegister.aluControl = DEControl.aluControl;
      IDEXPipeRegister.operandA = nextOperandA;
      IDEXPipeRegister.operandB = nextOperandB;
      IDEXPipeRegister.rdAddr = DEControl.rdAddr;
      IDEXPipeRegister.rdWriteEn = DEControl.rdWriteEn;
      IDEXPipeRegister.destinationSelect = DEControl.destinationSelect;
      IDEXPipeRegister.pc = DEControl.pc;
    end
  end


  assign EXControl.aluControl = IDEXPipeRegister.aluControl;
  assign EXControl.operandA = IDEXPipeRegister.operandA;
  assign EXControl.operandB = IDEXPipeRegister.operandB;
  assign EXControl.rdAddr = IDEXPipeRegister.rdAddr;
  assign EXControl.rdWriteEn = IDEXPipeRegister.rdWriteEn;
  assign EXControl.destinationSelect = IDEXPipeRegister.destinationSelect;
  assign EXControl.pc = IDEXPipeRegister.pc;

endmodule
