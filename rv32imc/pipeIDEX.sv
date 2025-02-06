/********************************************************
 * The pipeline ID/EX for the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
********************************************************/
import loopyV_data_types::*;

module pipeIDEX (
    input clk,
    input arstn,
    input DEStageSignalsType DEControl,
    output EXStageSignalsType EXControl
);

  logic [31:0] nextOperandA;
  logic [31:0] nextOperandB;

  IDEXPipelineType IDEXPipeRegister;

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
      IDEXPipeRegister.loadSignal = 1'b0;
      IDEXPipeRegister.storeSignal = 1'b0;
      IDEXPipeRegister.loadStoreByteSelect = FUNCT3_BYTE;
      IDEXPipeRegister.storeData = 32'b0;
      IDEXPipeRegister.operandA = 32'b0;
      IDEXPipeRegister.operandB = 32'b0;
      IDEXPipeRegister.rdAddr = 5'b0;
      IDEXPipeRegister.rdWriteEn = 0;
      IDEXPipeRegister.destinationSelect = WB_SEL_ALU;
      IDEXPipeRegister.pc = 32'b0;
    end else begin
      IDEXPipeRegister.aluControl = DEControl.aluControl;
      IDEXPipeRegister.loadSignal = DEControl.loadSignal;
      IDEXPipeRegister.storeSignal = DEControl.storeSignal;
      IDEXPipeRegister.loadStoreByteSelect = DEControl.loadStoreByteSelect;
      IDEXPipeRegister.storeData = DEControl.rs2Data;
      IDEXPipeRegister.operandA = nextOperandA;
      IDEXPipeRegister.operandB = nextOperandB;
      IDEXPipeRegister.rdAddr = DEControl.rdAddr;
      IDEXPipeRegister.rdWriteEn = DEControl.rdWriteEn;
      IDEXPipeRegister.destinationSelect = DEControl.destinationSelect;
      IDEXPipeRegister.pc = DEControl.pc;
    end
  end


  assign EXControl.aluControl = IDEXPipeRegister.aluControl;
  assign EXControl.loadSignal = IDEXPipeRegister.loadSignal;
  assign EXControl.storeSignal = IDEXPipeRegister.storeSignal;
  assign EXControl.loadStoreByteSelect = IDEXPipeRegister.loadStoreByteSelect;
  assign EXControl.storeData = IDEXPipeRegister.storeData;
  assign EXControl.operandA = IDEXPipeRegister.operandA;
  assign EXControl.operandB = IDEXPipeRegister.operandB;
  assign EXControl.rdAddr = IDEXPipeRegister.rdAddr;
  assign EXControl.rdWriteEn = IDEXPipeRegister.rdWriteEn;
  assign EXControl.destinationSelect = IDEXPipeRegister.destinationSelect;
  assign EXControl.pc = IDEXPipeRegister.pc;

endmodule
