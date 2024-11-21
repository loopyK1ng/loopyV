/********************************************************
 * The program counter of the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2023 Lennart M. Reimann
********************************************************/


module pcReg(
                    input clk,
                    input arstn,
                    input writeEn,
                    input [31:0]writeData,
                    output [31:0]readData);

logic [31:0] pc;

always_ff @(posedge clk or negedge arstn) begin
    if(!arstn) begin
        pc <= 0;
    end else if(writeEn) begin
        pc <= writeData;
    end
end

assign readData <= pc;


endmodule