/********************************************************
The register file of the 32-bit RISC-V processor
written by Lennart M. Reimann


Apache License, Version 2.0
Copyright (c) 2024 Lennart M. Reimann
********************************************************/


// TODO fix x0 to 0.. rename the registers to X? 

module registerfile (
    input clk,
    input arstn,
    input writeEn,
    input [4:0] writeAddr,
    input [31:0] writeData,
    input [4:0] readAddr1,
    input [4:0] readAddr2,
    output [31:0] readData1,
    output [31:0] readData2
);

  logic [31:0] registers[32];

  // Register x0 is always 0
  initial registers[0] = 32'b0;

  always_ff @(posedge clk or negedge arstn) begin
    if (!arstn) begin
      for (integer i = 0; i < 32; i = i + 1) begin
        registers[i] <= 0;
      end
    end else if (writeEn) begin
      if (writeAddr != 5'b0) begin
        registers[writeAddr] <= writeData;
      end
    end
  end

  assign readData1 = registers[readAddr1];
  assign readData2 = registers[readAddr2];


endmodule
