/********************************************************
 * The top module of the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
********************************************************/


module processor_top (
    input clk,
    input arstn,
    output [31:0] pmAddr,
    input [31:0] pmData,
    output [31:0] dataBusAddr,
    output [31:0] dataBusStData,
    input [31:0] dataBusLdData,
    output dataBusLdSignal,
    output dataBusStSignal,
    output [3:0] dataBusWriteMask

);


  /* The processor implements the following pipeline stages:
Instruction Fetch (IF): Fetch the instruction
Insutrction Decode (ID): Decode the instructions and load the operands
Execute (EX): Execute the instruction (mostly ALU operations)
Memory (MEM): Memory accesses are started here
Write-back (WB): Write back the result to the register file
*/

  logic illegal_insn;

  DEStageSignalsType DEStageSignals;
  EXStageSignalsType EXStageSignals;
  MEMStageSignalsType MEMStageSignals;
  WBStageSignalsType WBStageSignals;
  logic [31:0] dmLdData;

  assign dmLdSignal = MEMStageSignals.loadSignal;
  assign dmStSignal = MEMStageSignals.storeSignal;
  assign dmAddr     = MEMStageSignals.rdWriteData;

  dm_interface dm_interface (
      .dmAddr(MEMStageSignals.rdWriteData),
      .dmStData(MEMStageSignals.storeData),
      .dmLdData(dmLdData),
      .loadStoreByteSelect(MEMStageSignals.loadStoreByteSelect),
      .dmLdSignal(MEMStageSignals.loadSignal),
      .dmStSignal(MEMStageSignals.storeSignal),

      .dataBusAddr(dataBusAddr),
      .dataBusReadData(dataBusLdData),
      .dataBusWriteData(dataBusStData),
      .dataBusWriteEn(dataBusStSignal),
      .dataBusReadEn(dataBusLdSignal),
      .dataBusWriteMask(dataBusWriteMask),

  );

  registerfile registerfile (
      .clk(clk),
      .arstn(arstn),
      .writeEn(WBStageSignals.rdWriteEn),
      .writeAddr(WBStageSignals.rdWriteAddr),
      .writeData(WBStageSignals.rdWriteData),
      .readAddr1(DEStageSignals.rs1Addr),
      .readAddr2(DEStageSignals.rs2Addr),
      .readData1(DEStageSignals.readData1),
      .readData2(DEStageSignals.readData2)
  );

  alu alu (
      .operandA(EXStageSignals.operandA),
      .operandB(EXStageSignals.operandB),
      .aluCntrl(EXStageSignals.aluControl),
      .results (EXStageSignals.aluResult)
  );

  decoder decoder (
      .instruction(TODO),
      .illegal_insn(illegal_insn),
      .control(DEStageSignals)
  );

  pipeIDEX pipeIDEX (
      .clk(clk),
      .arstn(arstn),
      .DEControl(DEStageSignals),
      .EXControl(EXStageSignals)
  );

  pipeEXMEM pipeEXMEM (
      .clk(clk),
      .arstn(arstn),
      .EXControl(EXStageSignals),
      .MEMControl(MEMStageSignals)
  );

  pipeMEMWB pipeMEMWB (
      .clk(clk),
      .arstn(arstn),
      .dmLoadData(dmLdData),
      .MEMControl(MEMStageSignals),
      .WBControl(WBStageSignals)
  );


endmodule
