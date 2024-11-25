/********************************************************
 * The pipeline EX/MEM for the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
********************************************************/

module pipeEXMEM (
    input clk,
    input arstn,
    input EXStageSignalsType EXControl,
    output MEMStageSignalsType MEMControl
);

  logic nextWriteData;
  EXMEMPipelineType EXMEMPipeRegister;


  // Write Data Selection (doing it here saves a pipeline register)
  always_comb begin
    if (EXControl.destinationSelect == WB_SEL_ALU) begin
      nextWriteData = DEControl.aluResult;
    end else begin
      nextWriteData = DEControl.immediate; //it could also be a different select, but we don't care here.
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
      EXMEMPipeRegister.loadSignal = EXControl.loadSignal;
      EXMEMPipeRegister.storeSignal = EXControl.storeSignal;
      EXMEMPipeRegister.loadStoreByteSelect = EXControl.loadStoreByteSelect;
      EXMEMPipeRegister.storeData = EXControl.storeData;
      EXMEMPipeRegister.rdAddr = EXControl.rdAddr;
      EXMEMPipeRegister.rdWriteEn = EXControl.rdWriteEn;
      EXMEMPipeRegister.destinationSelect = EXControl.destinationSelect;
      EXMEMPipeRegister.pc = EXControl.pc;
      EXMEMPipeRegister.rdWriteData = nextWriteData;
    end
  end

  assign MEMControl.loadSignal = EXMEMPipeRegister.loadSignal;
  assign MEMControl.storeSignal = EXMEMPipeRegister.storeSignal;
  assign MEMControl.loadStoreByteSelect = EXMEMPipeRegister.loadStoreByteSelect;
  assign MEMControl.storeData = EXMEMPipeRegister.storeData;
  assign MEMControl.rdAddr = EXMEMPipeRegister.rdAddr;
  assign MEMControl.rdWriteEn = EXMEMPipeRegister.rdWriteEn;
  assign MEMControl.destinationSelect = EXMEMPipeRegister.destinationSelect;
  assign MEMControl.pc = EXMEMPipeRegister.pc;
  assign MEMControl.rdWriteData = EXMEMPipeRegister.rdWriteData;

endmodule
