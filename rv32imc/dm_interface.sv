/************************************************************
 * The data memory interface of the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
************************************************************/

module dm_interface(
    input [31:0] dmAddr,
    input [31:0] dmStData,
    output [31:0] dmLdData,
    input [2:0] loadStoreByteSelect
    input dmLdSignal,
    input dmStSignal,

    output [31:0] dataBusAddr,
    input [31:0] dataBusReadData,
    output [31:0] dataBusWriteData,
    output dataBusWriteEn,
    output dataBusReadEn,
    output [3:0] dataBusWriteMask,


);

assign dataBusWriteEn = dmStSignal;
assign dataBusReadEn = dmLdSignal;
assign dataBusAddr = dmAddr;


// TODO Check allowed memory alignments! 


always_comb begin
    case (loadStoreByteSelect)
      case (WBControl.loadStoreByteSelect)
        FUNCT3_BYTE: begin
          WBControl.rdWriteData = {{24{dmLoadData[7]}}, dmLoadData[7:0]};
        end
        FUNCT3_HALFWORD: begin
          WBControl.rdWriteData = {{16{dmLoadData[15]}}, dmLoadData[15:0]};
        end
        FUNCT3_WORD: begin
          WBControl.rdWriteData = dmLoadData;
        end
        FUNCT3_BYTE_U: begin
          WBControl.rdWriteData = {24'b0, dmLoadData[7:0]};
        end
        FUNCT3_HALFWORD_U: begin
          WBControl.rdWriteData = {16'b0, dmLoadData[15:0]};
        end
        default: begin
          WBControl.rdWriteData = dmLoadData;
        end
      endcase
    endcase
end


endmodule 