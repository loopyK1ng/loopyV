/********************************************************
 * The pipeline EX/MEM for the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
********************************************************/
import loopyV_data_types::*;

module pipeEXMEM (
    input clk,
    input arstn,
    input logic [31:0] aluResultEX,
    input logic [31:0] immediateEX,
    input logic loadSignalEX,
    input logic storeSignalEX,
    input logic [2:0] loadStoreByteSelectEX,
    input logic [31:0] storeDataEX,
    input logic [4:0] rdAddrEX,
    input logic rdWriteEnEX,
    input logic [1:0] destinationSelectEX,
    input logic [31:0] pcEX,

    output logic loadSignalMEM,
    output logic storeSignalMEM,
    output logic [2:0] loadStoreByteSelectMEM,
    output logic [31:0] storeDataMEM,
    output logic [4:0] rdAddrMEM,
    output logic rdWriteEnMEM,
    output logic [1:0] destinationSelectMEM,
    output logic [31:0] pcMEM,
    output logic [31:0] rdWriteDataMEM,
    output logic [31:0] dmAddrMEM

);

  logic [31:0] nextWriteData;
  EXMEMPipelineType EXMEMPipeRegister;


  // Write Data Selection (doing it here saves a pipeline register)
  always_comb begin
    if (destinationSelectEX == WB_SEL_ALU) begin
      nextWriteData = aluResultEX;
    end else begin
      nextWriteData = immediateEX; //it could also be a different select, but we don't care here.
    end
  end

  always_ff @(posedge clk or negedge arstn) begin
    if (!arstn) begin
      EXMEMPipeRegister.loadSignal = 1'b0;
      EXMEMPipeRegister.storeSignal = 1'b0;
      EXMEMPipeRegister.loadStoreByteSelect = FUNCT3_BYTE;
      EXMEMPipeRegister.storeData = 32'b0;
      EXMEMPipeRegister.rdAddr = 5'b0;
      EXMEMPipeRegister.rdWriteEn = 0;
      EXMEMPipeRegister.destinationSelect = WB_SEL_ALU;
      EXMEMPipeRegister.pc = 32'b0;
      EXMEMPipeRegister.rdWriteData = 32'b0;
    end else begin
      EXMEMPipeRegister.loadSignal = loadSignalEX;
      EXMEMPipeRegister.storeSignal = storeSignalEX;
      EXMEMPipeRegister.loadStoreByteSelect = loadStoreByteSelectEX;
      EXMEMPipeRegister.storeData = storeDataEX;
      EXMEMPipeRegister.rdAddr = rdAddrEX;
      EXMEMPipeRegister.rdWriteEn = rdWriteEnEX;
      EXMEMPipeRegister.destinationSelect = destinationSelectEX;
      EXMEMPipeRegister.pc = pcEX;
      EXMEMPipeRegister.rdWriteData = nextWriteData;
    end
  end

  assign loadSignalMEM = EXMEMPipeRegister.loadSignal;
  assign storeSignalMEM = EXMEMPipeRegister.storeSignal;
  assign loadStoreByteSelectMEM = EXMEMPipeRegister.loadStoreByteSelect;
  assign storeDataMEM = EXMEMPipeRegister.storeData;
  assign rdAddrMEM = EXMEMPipeRegister.rdAddr;
  assign rdWriteEnMEM = EXMEMPipeRegister.rdWriteEn;
  assign destinationSelectMEM = EXMEMPipeRegister.destinationSelect;
  assign pcMEM = EXMEMPipeRegister.pc;
  assign rdWriteDataMEM = EXMEMPipeRegister.rdWriteData;
  assign dmAddrMEM = EXMEMPipeRegister.rdWriteData;

endmodule
