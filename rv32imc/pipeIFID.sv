/********************************************************
 * The pipeline IF/ID for the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
********************************************************/

module pipeIFID (
    input clk,
    input arstn,
    input IFStageSignals IFControl,
    output DEStageSignals DEControl
);