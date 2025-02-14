/********************************************************
 * The pipeline MEM/WB for the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
********************************************************/

import loopyV_data_types::*;

// TODO DESTINATION SELECTION needs to be done here.. 
//after the read! as we need to wait for the memload

module pipeMEMWB (
    input clk,
    input arstn,
    input [31:0] dmLoadData,
    input logic [4:0] rdAddrMEM,
    input logic rdWriteEnMEM,
    input logic [1:0] destinationSelectMEM,
    input logic [31:0] pcMEM,
    input logic [31:0] rdWriteDataMEM,
    input logic [31:0] dmAddrMEM,
    input logic [2:0] loadStoreByteSelectMEM,

    output logic [4:0] rdAddrWB,
    output logic rdWriteEnWB,
    output logic [1:0] destinationSelectWB,
    output logic [31:0] pcWB,
    output logic [31:0] rdWriteDataWB,
    output logic [31:0] dmAddrWB,
    output logic [2:0] loadStoreByteSelectWB
);

  MEMWBPipelineType MEMWBPipeRegister;



  always_ff @(posedge clk or negedge arstn) begin
    if (!arstn) begin
      MEMWBPipeRegister.rdAddr <= 5'b0;
      MEMWBPipeRegister.dmAddr <= 32'b0;
      MEMWBPipeRegister.rdWriteEn <= 0;
      MEMWBPipeRegister.destinationSelect <= WB_SEL_ALU;
      MEMWBPipeRegister.pc <= 32'b0;
      MEMWBPipeRegister.rdWriteData <= 32'b0;
      MEMWBPipeRegister.loadStoreByteSelect <= 3'b0;
    end else begin
      MEMWBPipeRegister.rdAddr <= rdAddrMEM;
      MEMWBPipeRegister.dmAddr <= dmAddrMEM;
      MEMWBPipeRegister.rdWriteEn <= rdWriteEnMEM;
      MEMWBPipeRegister.destinationSelect <= destinationSelectMEM;
      MEMWBPipeRegister.pc <= pcMEM;
      MEMWBPipeRegister.rdWriteData <= rdWriteDataMEM;
      MEMWBPipeRegister.loadStoreByteSelect <= loadStoreByteSelectMEM;
    end
  end

  always_comb begin
    if((MEMWBPipeRegister.destinationSelect == WB_SEL_ALU) | (MEMWBPipeRegister.destinationSelect == WB_SEL_IMM))begin
      rdWriteDataWB = MEMWBPipeRegister.rdWriteData;
    end else if (MEMWBPipeRegister.destinationSelect == WB_SEL_LOAD) begin
      rdWriteDataWB = dmLoadData;
    end else begin
      //TODO
      rdWriteDataWB = 32'b0;
    end
  end

  assign rdAddrWB = MEMWBPipeRegister.rdAddr;
  assign rdWriteEnWB = MEMWBPipeRegister.rdWriteEn;
  assign destinationSelectWB = MEMWBPipeRegister.destinationSelect;
  assign pcWB = MEMWBPipeRegister.pc;
  assign dmAddrWB = MEMWBPipeRegister.dmAddr;
  assign loadStoreByteSelectWB = MEMWBPipeRegister.loadStoreByteSelect;


endmodule
