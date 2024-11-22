/********************************************************
 * The controller of the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2023 Lennart M. Reimann
********************************************************/

module controller(
                    input clk,
                    input arstn

)

logic pcWriteEn;
logic nextPc;


// Instantiate the program counter 

pcReg pc(
    .clk(clk),
    .arstn(arstn),
    .writeEn(pcWriteEn),
    .writeData(nextPc),
    .readData(pcIF)
);


