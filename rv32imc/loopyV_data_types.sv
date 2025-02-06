/********************************************************
 * The data types for the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
********************************************************/


package loopyV_data_types;

  typedef struct packed {
    logic [31:0] pc;
    logic [31:0] pcPlus4;
  } IFStageSignalsType;

  typedef struct packed {
    logic [31:0] pc;
    logic [31:0] pcPlus4;
    logic [31:0] instruction;
  } IFDEPipelineType;

  typedef struct packed {
    logic [3:0] aluControl;
    logic loadSignal;
    logic storeSignal;
    logic [2:0] loadStoreByteSelect;
    logic [31:0] storeData;
    logic [4:0] rs1Addr;
    logic [31:0] rs1Data;
    logic [4:0] rs2Addr;
    logic [31:0] rs2Data;
    logic [4:0] rdAddr;
    logic rdWriteEn;
    logic operandASelect;
    logic operandBSelect;
    logic [1:0] destinationSelect;
    logic [31:0] operandA;
    logic [31:0] operandB;
    logic [31:0] immediate;
    logic [31:0] pc;
  } DEStageSignalsType;


  typedef struct packed {
    logic [3:0] aluControl;
    logic loadSignal;
    logic storeSignal;
    logic [2:0] loadStoreByteSelect;
    logic [31:0] storeData;
    logic [31:0] operandA;
    logic [31:0] operandB;
    logic [4:0] rdAddr;
    logic rdWriteEn;
    logic [1:0] destinationSelect;
    logic [31:0] immediate;
    logic [31:0] pc;
  } IDEXPipelineType;

  typedef struct packed {
    logic [3:0] aluControl;
    logic loadSignal;
    logic storeSignal;
    logic [2:0] loadStoreByteSelect;
    logic [31:0] storeData;
    logic [31:0] operandA;
    logic [31:0] operandB;
    logic [4:0] rdAddr;
    logic rdWriteEn;
    logic [1:0] destinationSelect;
    logic [31:0] immediate;
    logic [31:0] pc;
    logic [31:0] aluResult;
  } EXStageSignalsType;

  typedef struct packed {
    logic loadSignal;
    logic storeSignal;
    logic [2:0] loadStoreByteSelect;
    logic [31:0] storeData;
    logic [4:0] rdAddr;
    logic rdWriteEn;
    logic [1:0] destinationSelect;
    logic [31:0] pc;
    logic [31:0] rdWriteData;
  } EXMEMPipelineType;

  typedef struct packed {
    logic loadSignal;
    logic storeSignal;
    logic [2:0] loadStoreByteSelect;
    logic [31:0] storeData;
    logic [4:0] rdAddr;
    logic rdWriteEn;
    logic [1:0] destinationSelect;
    logic [31:0] pc;
    logic [31:0] rdWriteData;
  } MEMStageSignalsType;

  typedef struct packed {
    logic [2:0] loadStoreByteSelect;
    logic [4:0] rdAddr;
    logic rdWriteEn;
    logic [1:0] destinationSelect;
    logic [31:0] pc;
    logic [31:0] rdWriteData;
  } MEMWBPipelineType;

  typedef struct packed {
    logic [2:0] loadStoreByteSelect;
    logic rdWriteEn;
    logic [4:0] rdAddr;
    logic [1:0] destinationSelect;
    logic [31:0] pc;
    logic [31:0] rdWriteData;
  } WBStageSignalsType;

endpackage


