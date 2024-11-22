/********************************************************
 * The data types for the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2023 Lennart M. Reimann
********************************************************/


package loopyV_data_types;


  typedef struct packed {
    logic [3:0] aluControl;
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
    logic [4:0] rdAddr;
    logic rdWriteEn;
    logic [1:0] destinationSelect;
    logic [31:0] pc;
    logic [31:0] rdWriteData;
  } EXMEMPipelineType;

  typedef struct packed {
    logic [4:0] rdAddr;
    logic rdWriteEn;
    logic [1:0] destinationSelect;
    logic [31:0] pc;
    logic [31:0] rdWriteData;
  } MEMStageSignalsType;

  typedef struct packed {logic rdWriteEn;} WBStageSignals;

endpackage


