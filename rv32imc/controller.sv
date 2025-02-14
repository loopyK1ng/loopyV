/********************************************************
 * The controller of the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
********************************************************/

module controller (
    input clk,
    input arstn,
    input [31:0] immediate,
    output [31:0] pcIF,
    output [31:0] pcLink
);

  logic pcWriteEn;

  logic [31:0] nextPc;
  logic [31:0] pcPlus4;
  logic [31:0] pcPlusImmediate;

  assign pcPlus4 = pcIF + 4;
  assign pcPlusImmediate = pcIF + immediate;
  assign pcLink = pcPlus4;


  // TODO Just temporary:
  logic [1:0] pcSelect;



  // Instantiate the program counter 

  pcReg pc (
      .clk(clk),
      .arstn(arstn),
      .writeEn(pcWriteEn),
      .writeData(nextPc),
      .readData(pcIF)
  );

  // Determine the next program counter
  always_comb begin

    case (pcSelect)

      default: begin
        nextPc = pcPlus4;
        pcWriteEn = 1;
      end
    endcase
  end

  // Determine necessary flushes





endmodule
