/************************************************************
 * The data memory interface of the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 * Load is started in MEM stage, data arrives in WB stage
 * Store is completed in MEM stage (processor's tasks are completed)
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
************************************************************/
import loopyV_data_types::*;

module dm_interface (
    input logic [2:0] loadStoreByteSelectMEM,
    input logic [2:0] loadStoreByteSelectWB,

    input logic [31:0] dmAddrMEM,
    input logic [31:0] dmAddrWB,
    input logic [31:0] dmStData,
    output logic [31:0] dmLdData,
    input logic dmLdSignal,
    input logic dmStSignal,

    output logic [31:0] dataBusAddr,
    input logic [31:0] dataBusReadData,
    output logic [31:0] dataBusWriteData,
    output logic dataBusWriteEn,
    output logic dataBusReadEn,
    output logic [3:0] dataBusWriteMask
);

  logic [31:0] aligned;

  assign dataBusWriteEn = dmStSignal;
  assign dataBusReadEn = dmLdSignal;
  assign dataBusAddr = dmAddrMEM;

  // Write enable mask for storing 

  always_comb begin
    case (loadStoreByteSelectMEM)
      FUNCT3_BYTE, FUNCT3_BYTE_U: begin
        dataBusWriteMask = 4'b0001 << dmAddrMEM[1:0];
      end
      FUNCT3_HALFWORD, FUNCT3_HALFWORD_U: begin
        dataBusWriteMask = 4'b0011 << dmAddrMEM[1:0];
      end
      FUNCT3_WORD: begin
        dataBusWriteMask = 4'b1111;
      end
      default: begin
        dataBusWriteMask = 4'bx;
      end
    endcase
  end

  // Align the data (to be stored) within a word
  assign dataBusWriteData = dmStData << (dmAddrMEM[1:0] * 8);

  // TODO Assumes naturally aligned accesses! 
  // Might have to implement an exception.

  // Align the naturally aligned accesses to the 32-bit format
  // Todo fix address to come from WB stage
  assign aligned = dataBusReadData >> (dmAddrWB[1:0] * 8);


  // todo fix signals to not have WB Control
  always_comb begin
    case (loadStoreByteSelectWB)
      FUNCT3_BYTE: begin
        dmLdData = {{24{aligned[7]}}, aligned[7:0]};
      end
      FUNCT3_HALFWORD: begin
        dmLdData = {{16{aligned[15]}}, aligned[15:0]};
      end
      FUNCT3_WORD: begin
        dmLdData = aligned;
      end
      FUNCT3_BYTE_U: begin
        dmLdData = {24'b0, aligned[7:0]};
      end
      FUNCT3_HALFWORD_U: begin
        dmLdData = {16'b0, aligned[15:0]};
      end
      default: begin
        dmLdData = 32'bx;
      end
    endcase
  end


endmodule
