/********************************************************
 * The top module of the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
********************************************************/
import loopyV_data_types::*;

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
Instruction Decode (DE): Decode the instructions and load the operands
Execute (EX): Execute the instruction (mostly ALU operations)
Memory (MEM): Memory accesses are started here
Write-back (WB): Write back the result to the register file
*/

  logic [31:0] pc[PS_WB:PS_IF]  /*verilator public*/;
  logic [3:0] aluControl[PS_EX:PS_DE];
  logic loadSignal[PS_MEM:PS_DE];
  logic storeSignal[PS_MEM:PS_DE];
  logic [2:0] loadStoreByteSelect[PS_WB:PS_DE];
  logic [31:0] storeData[PS_MEM:PS_EX];
  logic [4:0] rs1Addr[PS_DE:PS_DE]/*verilator public*/;
  logic [4:0] rs2Addr[PS_DE:PS_DE]/*verilator public*/;
  logic [31:0] rs1Data[PS_DE:PS_DE]/*verilator public*/;
  logic [31:0] rs2Data[PS_DE:PS_DE]/*verilator public*/;
  logic [4:0] rdAddr[PS_WB:PS_DE]/*verilator public*/;
  logic rdWriteEn[PS_WB:PS_DE]  /*verilator public*/;
  logic operandASelect[PS_DE:PS_DE]/*verilator public*/;
  logic operandBSelect[PS_DE:PS_DE]/*verilator public*/;
  logic [1:0] destinationSelect[PS_WB:PS_DE]/*verilator public*/;
  logic [31:0] operandA[PS_EX:PS_EX]  /*verilator public*/;
  logic [31:0] operandB[PS_EX:PS_EX]  /*verilator public*/;
  logic [31:0] immediate[PS_EX:PS_DE] /*verilator public*/;
  logic [31:0] aluResult[PS_EX:PS_EX];
  logic [31:0] rdWriteData[PS_WB:PS_MEM]  /*verilator public*/;
  logic [31:0] dmAddr[PS_WB:PS_MEM];
  logic [31:0] dmLdData[PS_WB:PS_WB];
  logic [31:0] instruction[PS_DE:PS_IF];

  logic illegal_insn ;
  logic stallIFDE /*verilator public*/;
  logic flushEX;

  logic [31:0] dummyPC;

  assign dataBusLdSignal = loadSignal[PS_MEM];
  assign dataBusStSignal = storeSignal[PS_MEM];
  assign dataBusAddr     = rdWriteData[PS_MEM];
  assign pmAddr          = pc[PS_IF];
  assign instruction[PS_IF] = pmData;

  dm_interface dm_interface (

      .loadStoreByteSelectMEM(loadStoreByteSelect[PS_MEM]),
      .loadStoreByteSelectWB (loadStoreByteSelect[PS_WB]),

      .dmAddrMEM (dmAddr[PS_MEM]),
      .dmAddrWB  (dmAddr[PS_WB]),
      .dmStData  (storeData[PS_MEM]),
      .dmLdData  (dmLdData[PS_WB]),
      .dmLdSignal(loadSignal[PS_MEM]),
      .dmStSignal(storeSignal[PS_MEM]),

      .dataBusAddr(dataBusAddr),
      .dataBusReadData(dataBusLdData),
      .dataBusWriteData(dataBusStData),
      .dataBusWriteEn(dataBusStSignal),
      .dataBusReadEn(dataBusLdSignal),
      .dataBusWriteMask(dataBusWriteMask)
  );

  registerfile registerfile (
      .clk(clk),
      .arstn(arstn),
      .writeEn(rdWriteEn[PS_WB]),
      .writeAddr(rdAddr[PS_WB]),
      .writeData(rdWriteData[PS_WB]),
      .readAddr1(rs1Addr[PS_DE]),
      .readAddr2(rs2Addr[PS_DE]),
      .readData1(rs1Data[PS_DE]),
      .readData2(rs2Data[PS_DE])
  );

  alu alu (
      .operandA(operandA[PS_EX]),
      .operandB(operandB[PS_EX]),
      .aluCntrl(aluControl[PS_EX]),
      .result  (aluResult[PS_EX])
  );

  controller controller (
      .clk(clk),
      .arstn(arstn),
      .stallIFDE(stallIFDE),
      .immediate(immediate[PS_EX]),  //Check and rename what PS
      .pcIF(pc[PS_IF]),
      .pcLink(dummyPC)
  );

  decoder decoder (
      .instruction(instruction[PS_DE]),
      .illegal_insn(illegal_insn),
      .loadSignalDE(loadSignal[PS_DE]),
      .storeSignalDE(storeSignal[PS_DE]),
      .rdWriteEnDE(rdWriteEn[PS_DE]),
      .rs1AddrDE(rs1Addr[PS_DE]),
      .rs2AddrDE(rs2Addr[PS_DE]),
      .rdAddrDE(rdAddr[PS_DE]),
      .operandASelectDE(operandASelect[PS_DE]),
      .operandBSelectDE(operandBSelect[PS_DE]),
      .destinationSelectDE(destinationSelect[PS_DE]),
      .aluControlDE(aluControl[PS_DE]),
      .immediateDE(immediate[PS_DE]),
      .loadStoreByteSelectDE(loadStoreByteSelect[PS_DE])
  );

  hazard_control hazard_control (
      .rs1AddrDE(rs1Addr[PS_DE]),
      .rs2AddrDE(rs2Addr[PS_DE]),
      .rdAddrEX(rdAddr[PS_EX]),
      .rdAddrMEM(rdAddr[PS_MEM]),
      .rdAddrWB(rdAddr[PS_WB]),
      .rdWriteEnEX(rdWriteEn[PS_EX]),
      .rdWriteEnMEM(rdWriteEn[PS_MEM]),
      .rdWriteEnWB(rdWriteEn[PS_WB]),
      .stallIFDE(stallIFDE),
      .flushEX(flushEX)
  );

  pipeIFDE pipeIFDE (
      .clk  (clk),
      .arstn(arstn),
      .stallIFDE(stallIFDE),
      .instructionIF(instruction[PS_IF]),
      .pcIF (pc[PS_IF]),
      .instructionDE(instruction[PS_DE]),
      .pcDE (pc[PS_DE])
  );

  pipeDEEX pipeDEEX (
      .clk(clk),
      .arstn(arstn),
      .operandASelectDE(operandASelect[PS_DE]),
      .operandBSelectDE(operandBSelect[PS_DE]),
      .rs1DataDE(rs1Data[PS_DE]),
      .rs2DataDE(rs2Data[PS_DE]),
      .pcDE(pc[PS_DE]),
      .immediateDE(immediate[PS_DE]),
      .aluControlDE(aluControl[PS_DE]),
      .loadSignalDE(loadSignal[PS_DE]),
      .storeSignalDE(storeSignal[PS_DE]),
      .loadStoreByteSelectDE(loadStoreByteSelect[PS_DE]),
      .rdAddrDE(rdAddr[PS_DE]),
      .rdWriteEnDE(rdWriteEn[PS_DE]),
      .destinationSelectDE(destinationSelect[PS_DE]),
      .flushEX(flushEX),
      .aluControlEX(aluControl[PS_EX]),
      .loadSignalEX(loadSignal[PS_EX]),
      .storeSignalEX(storeSignal[PS_EX]),
      .loadStoreByteSelectEX(loadStoreByteSelect[PS_EX]),
      .storeDataEX(storeData[PS_EX]),
      .operandAEX(operandA[PS_EX]),
      .operandBEX(operandB[PS_EX]),
      .rdAddrEX(rdAddr[PS_EX]),
      .rdWriteEnEX(rdWriteEn[PS_EX]),
      .destinationSelectEX(destinationSelect[PS_EX]),
      .pcEX(pc[PS_EX]),
      .immediateEX(immediate[PS_EX])
  );

  pipeEXMEM pipeEXMEM (
      .clk(clk),
      .arstn(arstn),
      .aluResultEX(aluResult[PS_EX]),
      .immediateEX(immediate[PS_EX]),
      .loadSignalEX(loadSignal[PS_EX]),
      .storeSignalEX(storeSignal[PS_EX]),
      .loadStoreByteSelectEX(loadStoreByteSelect[PS_EX]),
      .storeDataEX(storeData[PS_EX]),
      .rdAddrEX(rdAddr[PS_EX]),
      .rdWriteEnEX(rdWriteEn[PS_EX]),
      .destinationSelectEX(destinationSelect[PS_EX]),
      .pcEX(pc[PS_EX]),
      .loadSignalMEM(loadSignal[PS_MEM]),
      .storeSignalMEM(storeSignal[PS_MEM]),
      .loadStoreByteSelectMEM(loadStoreByteSelect[PS_MEM]),
      .storeDataMEM(storeData[PS_MEM]),
      .rdAddrMEM(rdAddr[PS_MEM]),
      .rdWriteEnMEM(rdWriteEn[PS_MEM]),
      .destinationSelectMEM(destinationSelect[PS_MEM]),
      .pcMEM(pc[PS_MEM]),
      .rdWriteDataMEM(rdWriteData[PS_MEM]),
      .dmAddrMEM(dmAddr[PS_MEM])
  );

  pipeMEMWB pipeMEMWB (
      .clk(clk),
      .arstn(arstn),
      .dmLoadData(dmLdData[PS_WB]),
      .rdAddrMEM(rdAddr[PS_MEM]),
      .rdWriteEnMEM(rdWriteEn[PS_MEM]),
      .destinationSelectMEM(destinationSelect[PS_MEM]),
      .pcMEM(pc[PS_MEM]),
      .rdWriteDataMEM(rdWriteData[PS_MEM]),
      .dmAddrMEM(dmAddr[PS_MEM]),
      .loadStoreByteSelectMEM(loadStoreByteSelect[PS_MEM]),

      .rdAddrWB(rdAddr[PS_WB]),
      .rdWriteEnWB(rdWriteEn[PS_WB]),
      .destinationSelectWB(destinationSelect[PS_WB]),
      .pcWB(pc[PS_WB]),
      .rdWriteDataWB(rdWriteData[PS_WB]),
      .dmAddrWB(dmAddr[PS_WB]),
      .loadStoreByteSelectWB(loadStoreByteSelect[PS_WB])
  );


endmodule
