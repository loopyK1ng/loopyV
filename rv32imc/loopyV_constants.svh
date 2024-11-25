/********************************************************
 * The constants for the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
********************************************************/

`ifndef RV_CONSTANTS
`define RV_CONSTANTS



/***********************************************/
/* INSTRUCTION ENCODING DEFINITIONS FOR RISC-V */
/***********************************************/

/* OPCODE definitions for RV32I*/

localparam OPCODE_OP = 7'b0110011;
localparam OPCODE_OP_IMM = 7'b0010011;
localparam OPCODE_LUI = 7'b0110111;
localparam OPCODE_AUIPC = 7'b0010111;
localparam OPCODE_JAL = 7'b1101111;
localparam OPCODE_JALR = 7'b1100111;
localparam OPCODE_BRANCH = 7'b1100011;
localparam OPCODE_LOAD = 7'b0000011;
localparam OPCODE_STORE = 7'b0100011;
localparam OPCODE_MISC_MEM = 7'b0001111;
localparam OPCODE_SYSTEM = 7'b1110011;

/* FUNCT3 opcode definitions */

//ALU

localparam FUNCT3_ADDI = 3'b000;
localparam FUNCT3_SLTI = 3'b010;
localparam FUNCT3_SLTIU = 3'b011;
localparam FUNCT3_ANDI = 3'b111;
localparam FUNCT3_ORI = 3'b110;
localparam FUNCT3_XORI = 3'b100;
localparam FUNCT3_SLLI = 3'b001;
localparam FUNCT3_SRLI_SRAI = 3'b101;
localparam FUNCT3_ADD = 3'b000;
localparam FUNCT3_SLT = 3'b010;
localparam FUNCT3_SLTU = 3'b011;
localparam FUNCT3_AND = 3'b111;
localparam FUNCT3_OR = 3'b110;
localparam FUNCT3_XOR = 3'b100;
localparam FUNCT3_SLL = 3'b001;
localparam FUNCT3_SRL = 3'b101;
localparam FUNCT3_SUB = 3'b000;
localparam FUNCT3_SRA = 3'b101;

// BRANCH
localparam FUNCT3_BEQ = 3'b000;
localparam FUNCT3_BNE = 3'b001;
localparam FUNCT3_BLT = 3'b100;
localparam FUNCT3_BLTU = 3'b110;
localparam FUNCT3_BGE = 3'b101;
localparam FUNCT3_BGEU = 3'b111;

// "width" load/store definitions
localparam FUNCT3_BYTE = 3'b000;
localparam FUNCT3_HALFWORD = 3'b001;
localparam FUNCT3_WORD = 3'b010;
localparam FUNCT3_BYTE_U = 3'b100;
localparam FUNCT3_HALFWORD_U = 3'b101;

// MISC-MEM

localparam FUNCT3_FENCE = 3'b000;

// SYSTEM

localparam FUNCT3_PRIV = 3'b000;


/* FUNCT7 opcode definitions */

localparam FUNCT7_ZEROS = 7'b0000000;
localparam FUNCT7_ONE = 7'b0100000;

/* FUNCT12 opcode definitions */

localparam FUNCT12_ECALL = 12'b000000000000;
localparam FUNCT12_EBREAK = 12'b000000000001;


/**********************************/
/* ALU-Control signal definitions */
/**********************************/

localparam ALU_ADD = 4'b0000;
localparam ALU_SUB = 4'b0001;
localparam ALU_SLT = 4'b0010;
localparam ALU_SLTU = 4'b0011;
localparam ALU_AND = 4'b0100;
localparam ALU_OR = 4'b0101;
localparam ALU_XOR = 4'b0110;
localparam ALU_SLL = 4'b0111;
localparam ALU_SRL = 4'b1000;
localparam ALU_SRA = 4'b1001;

/*****************************/
/* Operand fetch definitions */
/*****************************/

localparam OF_ALU_A_RS1 = 1'b0;
localparam OF_ALU_A_PC  = 1'b1;

localparam OF_ALU_B_RS2 = 1'b0;
localparam OF_ALU_B_IMM = 1'b1;

/*********************************/
/* Destination store definitions */
/*********************************/

localparam WB_SEL_ALU = 2'b00;
localparam WB_SEL_IMM = 2'b01;
localparam WB_SEL_LOAD = 2'b10;
//localparam WB_SEL_I = 2'b11;

`endif