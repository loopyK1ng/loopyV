/********************************************************
 * The pipeline IF/DE for the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
********************************************************/
import loopyV_data_types::*;

module pipeIFDE (
    input clk,
    input arstn,
    input logic stallIFDE,
    input logic [31:0] instructionIF,
    input logic [31:0] pcIF,
    output logic [31:0] instructionDE,
    output logic [31:0] pcDE
);

  logic [31:0] pcIFDEPipeRegister;
  logic [31:0] instructionIFDEPipeRegister;

  always_ff @(posedge clk or negedge arstn) begin
    if (!arstn) begin
      pcIFDEPipeRegister <= 32'b0;
      instructionIFDEPipeRegister <= 32'b0;
    end else if (!stallIFDE) begin
      pcIFDEPipeRegister <= pcIF;
      instructionIFDEPipeRegister <= instructionIF;
    end
  end

  assign pcDE = pcIFDEPipeRegister;
  assign instructionDE = instructionIFDEPipeRegister;

endmodule
