/********************************************************
 * The pipeline MEM/WB for the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
********************************************************/

// DESTINATION SELECTION needs to be done here.. 
//after the read! as we need to wait for the memload

module pipeMEMWB (
    input clk,
    input arstn,
    input [31:0] dmLoadData,
    input MEMStageSignalsType MEMControl,
    input WBStageSignalsType WBControl
);

  MEMWBPipelineType MEMWBPipeRegister;

  always_ff @(posedge clk or negedge arstn) begin
    if (!arstn) begin
      MEMWBPipeRegister.rdAddr = 5'b0;
      MEMWBPipeRegister.rdWriteEn = 0;
      MEMWBPipeRegister.destinationSelect = WB_SEL_ALU;
      MEMWBPipeRegister.pc = 32'b0;
      MEMWBPipeRegister.rdWriteData = 32'b0;
    end else begin
      MEMWBPipeRegister.rdAddr = MEMControl.rdAddr;
      MEMWBPipeRegister.rdWriteEn = MEMControl.rdWriteEn;
      MEMWBPipeRegister.destinationSelect = MEMControl.destinationSelect;
      MEMWBPipeRegister.pc = MEMControl.pc;
      MEMWBPipeRegister.rdWriteData = MEMControl.rdWriteData;
    end
  end

  assign WBControl.rdAddr = MEMWBPipeRegister.rdAddr;
  assign WBControl.rdWriteEn = MEMWBPipeRegister.rdWriteEn;
  assign WBControl.destinationSelect = MEMWBPipeRegister.destinationSelect;
  assign WBControl.pc = MEMWBPipeRegister.pc;

  always_comb begin
    if((WBControl.destinationSelect == WB_SEL_ALU) | (WBControl.destinationSelect == WB_SEL_IMM))begin
      WBControl.rdWriteData = MEMWBPipeRegister.rdWriteData;
    end else if (WBControl.destinationSelect == WB_SEL_LOAD) begin
          WBControl.rdWriteData = dmLoadData;
    end else begin
      //TODO
      WBControl.rdWriteData = 32'b0;
    end
  end




endmodule
