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
    input logic operandASelectDE,
    input logic operandBSelectDE,
    input logic [31:0] rs1DataDE,
    input logic [31:0] rs2DataDE,
    input logic [31:0] pcDE,
    input logic [31:0] immediateDE,
    input logic [3:0] aluControlDE,
    input logic loadSignalDE,
    input logic storeSignalDE,
    input logic [2:0] loadStoreByteSelectDE,
    input logic [4:0] rdAddrDE,
    input logic rdWriteEnDE,
    input logic [1:0] destinationSelectDE,
    
    output logic [3:0] aluControlEX, 
    output logic loadSignalEX, 
    output logic storeSignalEX, 
    output logic [2:0] loadStoreByteSelectEX, 
    output logic [31:0] storeDataEX, 
    output logic [31:0] operandAEX, 
    output logic [31:0] operandBEX, 
    output logic [4:0] rdAddrEX, 
    output logic rdWriteEnEX, 
    output logic [1:0] destinationSelectEX, 
    output logic [31:0] pcEX 
);

  logic [31:0] nextOperandA;
  logic [31:0] nextOperandB;

  IDEXPipelineType IDEXPipeRegister;

  // Operand Selection
  always_comb begin
    if (operandASelectDE == OF_ALU_A_RS1) begin
      nextOperandA = rs1DataDE;
    end else begin
      nextOperandA = pcDE;
    end

    if (operandBSelectDE == OF_ALU_B_RS2) begin
      nextOperandB = rs2DataDE;
    end else begin
      nextOperandB = immediateDE;
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
      IDEXPipeRegister.aluControl = aluControlDE;
      IDEXPipeRegister.loadSignal = loadSignalDE;
      IDEXPipeRegister.storeSignal = storeSignalDE;
      IDEXPipeRegister.loadStoreByteSelect = loadStoreByteSelectDE;
      IDEXPipeRegister.storeData = rs2DataDE;
      IDEXPipeRegister.operandA = nextOperandA;
      IDEXPipeRegister.operandB = nextOperandB;
      IDEXPipeRegister.rdAddr = rdAddrDE;
      IDEXPipeRegister.rdWriteEn = rdWriteEnDE;
      IDEXPipeRegister.destinationSelect = destinationSelectDE;
      IDEXPipeRegister.pc = pcDE;
    end
  end


  assign aluControlEX = IDEXPipeRegister.aluControl;
  assign loadSignalEX = IDEXPipeRegister.loadSignal;
  assign storeSignalEX = IDEXPipeRegister.storeSignal;
  assign loadStoreByteSelectEX = IDEXPipeRegister.loadStoreByteSelect;
  assign storeDataEX = IDEXPipeRegister.storeData;
  assign operandAEX = IDEXPipeRegister.operandA;
  assign operandBEX = IDEXPipeRegister.operandB;
  assign rdAddrEX = IDEXPipeRegister.rdAddr;
  assign rdWriteEnEX = IDEXPipeRegister.rdWriteEn;
  assign destinationSelectEX = IDEXPipeRegister.destinationSelect;
  assign pcEX = IDEXPipeRegister.pc;

endmodule
