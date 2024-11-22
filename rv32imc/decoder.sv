/********************************************************
 * The decoder of the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2023 Lennart M. Reimann
********************************************************/

`include "loopyV_constants.svh"

import loopyV_data_types::*;

module decoder (
    input logic [31:0] instruction,
    output logic illegal_insn,
    output DEStageSignalsType control
);


  always_comb begin

    case (instruction[6:0])  // opcode check
      OPCODE_OP: begin
        control.rs1Addr = instruction[19:15];
        control.rs2Addr = instruction[24:20];
        control.rdAddr = instruction[11:7];
        control.operandASelect = OF_ALU_A_RS1;
        control.operandBSelect = OF_ALU_B_RS2;
        control.destinationSelect = WB_SEL_ALU;
        case (instruction[31:25])
          FUNCT7_ZEROS: begin
            case (instruction[14:12])  // funct3 check
              FUNCT3_ADD: begin
                illegal_insn = 0;
                control.aluControl = ALU_ADD;
                control.rdWriteEn = 1;
              end
              FUNCT3_SLT: begin
                illegal_insn = 0;
                control.aluControl = ALU_SLT;
                control.rdWriteEn = 1;
              end
              FUNCT3_SLTU: begin
                illegal_insn = 0;
                control.aluControl = ALU_SLTU;
                control.rdWriteEn = 1;
              end
              FUNCT3_AND: begin
                illegal_insn = 0;
                control.aluControl = ALU_AND;
                control.rdWriteEn = 1;
              end
              FUNCT3_OR: begin
                illegal_insn = 0;
                control.aluControl = ALU_OR;
                control.rdWriteEn = 1;
              end
              FUNCT3_XOR: begin
                illegal_insn = 0;
                control.aluControl = ALU_XOR;
                control.rdWriteEn = 1;
              end
              FUNCT3_SLL: begin
                illegal_insn = 0;
                control.aluControl = ALU_SLL;
                control.rdWriteEn = 1;
              end
              FUNCT3_SRL: begin
                illegal_insn = 0;
                control.aluControl = ALU_SRL;
                control.rdWriteEn = 1;
              end
              default: begin
                illegal_insn = 1;
                control.rdWriteEn = 0;
              end
            endcase
          end

          FUNCT7_ONE: begin
            case (instruction[14:12])  // funct3 check
              FUNCT3_SUB: begin
                illegal_insn = 0;
                control.aluControl = ALU_SUB;
                control.rdWriteEn = 1;
              end
              FUNCT3_SRA: begin
                illegal_insn = 0;
                control.aluControl = ALU_SRA;
                control.rdWriteEn = 1;
              end
              default: begin
                illegal_insn = 1;
                control.rdWriteEn = 0;
              end
            endcase
          end
          default: begin
            illegal_insn = 1;
            control.rdWriteEn = 0;
          end
        endcase
      end

      OPCODE_OP_IMM: begin
        control.rs1Addr = instruction[19:15];
        control.rdAddr = instruction[11:7];
        control.operandASelect = OF_ALU_A_RS1;
        control.operandBSelect = OF_ALU_B_IMM;
        control.destinationSelect = WB_SEL_ALU;
        case (instruction[14:12])  //funct3 check
          FUNCT3_ADDI: begin
            illegal_insn = 0;
            control.aluControl = ALU_ADD;
            control.immediate = {{20{instruction[31]}}, instruction[31:20]};
            control.rdWriteEn = 1;
          end
          FUNCT3_SLTI: begin
            illegal_insn = 0;
            control.aluControl = ALU_SLT;
            control.immediate = {{20{instruction[31]}}, instruction[31:20]};
            control.rdWriteEn = 1;
          end
          FUNCT3_SLTIU: begin
            illegal_insn = 0;
            control.aluControl = ALU_SLTU;
            control.immediate = {{20{instruction[31]}}, instruction[31:20]};
            control.rdWriteEn = 1;
          end
          FUNCT3_ANDI: begin
            illegal_insn = 0;
            control.aluControl = ALU_AND;
            control.immediate = {{20{instruction[31]}}, instruction[31:20]};
            control.rdWriteEn = 1;
          end
          FUNCT3_ORI: begin
            illegal_insn = 0;
            control.aluControl = ALU_OR;
            control.immediate = {{20{instruction[31]}}, instruction[31:20]};
            control.rdWriteEn = 1;
          end
          FUNCT3_XORI: begin
            illegal_insn = 0;
            control.aluControl = ALU_XOR;
            control.immediate = {{20{instruction[31]}}, instruction[31:20]};
            control.rdWriteEn = 1;
          end
          FUNCT3_SLLI: begin
            if (instruction[31:25] == FUNCT7_ZEROS) begin  //funct7 check
              illegal_insn = 0;
              control.aluControl = ALU_SLL;
              control.immediate = {27'b0, instruction[24:20]};
              control.rdWriteEn = 1;
            end else begin
              illegal_insn = 1;
            end
          end
          FUNCT3_SRLI_SRAI: begin
            if (instruction[31:25] == FUNCT7_ZEROS) begin  //funct7 check
              illegal_insn = 0;
              control.aluControl = ALU_SRA;
              control.immediate = {27'b0, instruction[24:20]};
              control.rdWriteEn = 1;
            end else if (instruction[31:25] == FUNCT7_ZEROS) begin
              illegal_insn = 0;
              control.aluControl = ALU_SRL;
              control.immediate = {27'b0, instruction[24:20]};
              control.rdWriteEn = 1;
            end else illegal_insn = 1;
          end
          default: begin
            illegal_insn = 1;
          end
        endcase
      end

      OPCODE_LUI: begin
        control.destinationSelect = WB_SEL_IMM;
        control.immediate = {instruction[31:12], 12'b0};
        control.rdWriteEn = 1;
        control.rdAddr = instruction[11:7];
        illegal_insn = 0;
      end

      OPCODE_AUIPC: begin
        control.destinationSelect = WB_SEL_ALU;
        control.operandASelect = OF_ALU_A_PC;
        control.operandBSelect = OF_ALU_B_IMM;
        control.rdWriteEn = 1;
        control.aluControl = ALU_ADD;
        control.immediate = {instruction[31:12], 12'b0};
        illegal_insn = 0;
      end

      OPCODE_JAL: illegal_insn = 0;

      OPCODE_JALR: begin
        if (instruction[14:12] == 3'b0) begin  //funct3 check
          illegal_insn = 0;
        end else begin
          illegal_insn = 1;
        end
      end
      OPCODE_BRANCH: begin
        case (instruction[14:12])  //funct3 check
          FUNCT3_BEQ:  illegal_insn = 0;
          FUNCT3_BNE:  illegal_insn = 0;
          FUNCT3_BLT:  illegal_insn = 0;
          FUNCT3_BLTU: illegal_insn = 0;
          FUNCT3_BGE:  illegal_insn = 0;
          FUNCT3_BGEU: illegal_insn = 0;
          default: begin
            illegal_insn = 1;
          end
        endcase
      end
      OPCODE_LOAD: begin
        case (instruction[14:12])  //funct3 check
          FUNCT3_BYTE: illegal_insn = 0;
          FUNCT3_HALFWORD: illegal_insn = 0;
          FUNCT3_WORD: illegal_insn = 0;
          FUNCT3_BYTE_U: illegal_insn = 0;
          FUNCT3_HALFWORD_U: illegal_insn = 0;
          default: illegal_insn = 1;
        endcase
      end
      OPCODE_STORE: begin
        case (instruction[14:12])  //funct3 check
          FUNCT3_BYTE: illegal_insn = 0;
          FUNCT3_HALFWORD: illegal_insn = 0;
          FUNCT3_WORD: illegal_insn = 0;
          default: illegal_insn = 1;
        endcase
      end

      OPCODE_MISC_MEM: begin
        if (instruction[14:12] == FUNCT3_FENCE) begin  //funct3 check
          illegal_insn = 0;
        end else begin
          illegal_insn = 1;
        end
      end

      OPCODE_SYSTEM: begin
        case (instruction[14:12])  //funct3 check
          FUNCT3_PRIV: begin
            case (instruction[31:20])
              FUNCT12_ECALL:  illegal_insn = 0;
              FUNCT12_EBREAK: illegal_insn = 0;
              default: begin
                illegal_insn = 1;
              end
            endcase
          end
          default: begin
            illegal_insn = 1;
          end
        endcase
      end

      default: illegal_insn = 1;

    endcase
  end

endmodule
