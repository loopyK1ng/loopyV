/********************************************************
 * The decoder of the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
********************************************************/

`include "loopyV_constants.svh"


import loopyV_data_types::*;

module decoder (
    input logic [31:0] instruction,
    output logic illegal_insn,
    output logic loadSignalDE,
    output logic storeSignalDE,
    output logic rdWriteEnDE,
    output logic [4:0] rs1AddrDE,
    output logic [4:0] rs2AddrDE,
    output logic [4:0] rdAddrDE,
    output logic operandASelectDE,
    output logic operandBSelectDE,
    output logic [1:0] destinationSelectDE,
    output logic [3:0] aluControlDE,
    output logic [31:0] immediateDE,
    output logic [2:0] loadStoreByteSelectDE
);


  always_comb begin
    loadSignalDE  = 0;
    storeSignalDE = 0;
    rdWriteEnDE   = 0;
    case (instruction[6:0])  // opcode check
      OPCODE_OP: begin
        rs1AddrDE = instruction[19:15];
        rs2AddrDE = instruction[24:20];
        rdAddrDE = instruction[11:7];
        operandASelectDE = OF_ALU_A_RS1;
        operandBSelectDE = OF_ALU_B_RS2;
        destinationSelectDE = WB_SEL_ALU;
        case (instruction[31:25])
          FUNCT7_ZEROS: begin
            case (instruction[14:12])  // funct3 check
              FUNCT3_ADD: begin
                illegal_insn = 0;
                aluControlDE = ALU_ADD;
                rdWriteEnDE = 1;
              end
              FUNCT3_SLT: begin
                illegal_insn = 0;
                aluControlDE = ALU_SLT;
                rdWriteEnDE = 1;
              end
              FUNCT3_SLTU: begin
                illegal_insn = 0;
                aluControlDE = ALU_SLTU;
                rdWriteEnDE = 1;
              end
              FUNCT3_AND: begin
                illegal_insn = 0;
                aluControlDE = ALU_AND;
                rdWriteEnDE = 1;
              end
              FUNCT3_OR: begin
                illegal_insn = 0;
                aluControlDE = ALU_OR;
                rdWriteEnDE = 1;
              end
              FUNCT3_XOR: begin
                illegal_insn = 0;
                aluControlDE = ALU_XOR;
                rdWriteEnDE = 1;
              end
              FUNCT3_SLL: begin
                illegal_insn = 0;
                aluControlDE = ALU_SLL;
                rdWriteEnDE = 1;
              end
              FUNCT3_SRL: begin
                illegal_insn = 0;
                aluControlDE = ALU_SRL;
                rdWriteEnDE = 1;
              end
              default: begin
                illegal_insn = 1;
                rdWriteEnDE = 0;
              end
            endcase
          end

          FUNCT7_ONE: begin
            case (instruction[14:12])  // funct3 check
              FUNCT3_SUB: begin
                illegal_insn = 0;
                aluControlDE = ALU_SUB;
                rdWriteEnDE = 1;
              end
              FUNCT3_SRA: begin
                illegal_insn = 0;
                aluControlDE = ALU_SRA;
                rdWriteEnDE = 1;
              end
              default: begin
                illegal_insn = 1;
                rdWriteEnDE = 0;
              end
            endcase
          end
          default: begin
            illegal_insn = 1;
            rdWriteEnDE = 0;
          end
        endcase
      end

      OPCODE_OP_IMM: begin
        rs1AddrDE = instruction[19:15];
        rdAddrDE = instruction[11:7];
        operandASelectDE = OF_ALU_A_RS1;
        operandBSelectDE = OF_ALU_B_IMM;
        destinationSelectDE = WB_SEL_ALU;
        case (instruction[14:12])  //funct3 check
          FUNCT3_ADDI: begin
            illegal_insn = 0;
            aluControlDE = ALU_ADD;
            immediateDE = {{20{instruction[31]}}, instruction[31:20]};
            rdWriteEnDE = 1;
          end
          FUNCT3_SLTI: begin
            illegal_insn = 0;
            aluControlDE = ALU_SLT;
            immediateDE = {{20{instruction[31]}}, instruction[31:20]};
            rdWriteEnDE = 1;
          end
          FUNCT3_SLTIU: begin
            illegal_insn = 0;
            aluControlDE = ALU_SLTU;
            immediateDE = {{20{instruction[31]}}, instruction[31:20]};
            rdWriteEnDE = 1;
          end
          FUNCT3_ANDI: begin
            illegal_insn = 0;
            aluControlDE = ALU_AND;
            immediateDE = {{20{instruction[31]}}, instruction[31:20]};
            rdWriteEnDE = 1;
          end
          FUNCT3_ORI: begin
            illegal_insn = 0;
            aluControlDE = ALU_OR;
            immediateDE = {{20{instruction[31]}}, instruction[31:20]};
            rdWriteEnDE = 1;
          end
          FUNCT3_XORI: begin
            illegal_insn = 0;
            aluControlDE = ALU_XOR;
            immediateDE = {{20{instruction[31]}}, instruction[31:20]};
            rdWriteEnDE = 1;
          end
          FUNCT3_SLLI: begin
            if (instruction[31:25] == FUNCT7_ZEROS) begin  //funct7 check
              illegal_insn = 0;
              aluControlDE = ALU_SLL;
              immediateDE = {27'b0, instruction[24:20]};
              rdWriteEnDE = 1;
            end else begin
              illegal_insn = 1;
            end
          end
          FUNCT3_SRLI_SRAI: begin
            if (instruction[31:25] == FUNCT7_ZEROS) begin  //funct7 check
              illegal_insn = 0;
              aluControlDE = ALU_SRA;
              immediateDE = {27'b0, instruction[24:20]};
              rdWriteEnDE = 1;
            end else if (instruction[31:25] == FUNCT7_ZEROS) begin
              illegal_insn = 0;
              aluControlDE = ALU_SRL;
              immediateDE = {27'b0, instruction[24:20]};
              rdWriteEnDE = 1;
            end else illegal_insn = 1;
          end
          default: begin
            illegal_insn = 1;
          end
        endcase
      end

      OPCODE_LUI: begin
        destinationSelectDE = WB_SEL_IMM;
        immediateDE = {instruction[31:12], 12'b0};
        rdWriteEnDE = 1;
        rdAddrDE = instruction[11:7];
        illegal_insn = 0;
      end

      OPCODE_AUIPC: begin
        destinationSelectDE = WB_SEL_ALU;
        operandASelectDE = OF_ALU_A_PC;
        operandBSelectDE = OF_ALU_B_IMM;
        rdWriteEnDE = 1;
        aluControlDE = ALU_ADD;
        immediateDE = {instruction[31:12], 12'b0};
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
        rs1AddrDE = instruction[19:15];
        rdAddrDE = instruction[11:7];
        operandASelectDE = OF_ALU_A_RS1;
        operandBSelectDE = OF_ALU_B_IMM;
        aluControlDE = ALU_ADD;
        immediateDE = {{20{instruction[31]}}, instruction[31:20]};
        case (instruction[14:12])  //funct3 check
          FUNCT3_BYTE: begin
            illegal_insn = 0;
            loadSignalDE = 1;
            destinationSelectDE = WB_SEL_LOAD;
            loadStoreByteSelectDE = FUNCT3_BYTE;
            rdWriteEnDE = 1;
          end
          FUNCT3_HALFWORD: begin
            illegal_insn = 0;
            loadSignalDE = 1;
            destinationSelectDE = WB_SEL_LOAD;
            loadStoreByteSelectDE = FUNCT3_HALFWORD;
            rdWriteEnDE = 1;
          end
          FUNCT3_WORD: begin
            illegal_insn = 0;
            loadSignalDE = 1;
            destinationSelectDE = WB_SEL_LOAD;
            loadStoreByteSelectDE = FUNCT3_WORD;
            rdWriteEnDE = 1;
          end
          FUNCT3_BYTE_U: begin
            illegal_insn = 0;
            loadSignalDE = 1;
            destinationSelectDE = WB_SEL_LOAD;
            loadStoreByteSelectDE = FUNCT3_BYTE_U;
            rdWriteEnDE = 1;
          end
          FUNCT3_HALFWORD_U: begin
            illegal_insn = 0;
            loadSignalDE = 1;
            destinationSelectDE = WB_SEL_LOAD;
            loadStoreByteSelectDE = FUNCT3_HALFWORD_U;
            rdWriteEnDE = 1;
          end
          default: illegal_insn = 1;
        endcase
      end
      OPCODE_STORE: begin
        rs1AddrDE = instruction[19:15];
        rs2AddrDE = instruction[24:20];
        operandASelectDE = OF_ALU_A_RS1;
        operandBSelectDE = OF_ALU_B_IMM;
        aluControlDE = ALU_ADD;
        immediateDE = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        case (instruction[14:12])  //funct3 check
          FUNCT3_BYTE: begin
            illegal_insn = 0;
            storeSignalDE = 1;
            rdWriteEnDE = 0;
            loadStoreByteSelectDE = FUNCT3_BYTE;
          end
          FUNCT3_HALFWORD: begin
            illegal_insn = 0;
            storeSignalDE = 1;
            rdWriteEnDE = 0;
            loadStoreByteSelectDE = FUNCT3_BYTE;
          end
          FUNCT3_WORD: begin
            illegal_insn = 0;
            storeSignalDE = 1;
            rdWriteEnDE = 0;
            loadStoreByteSelectDE = FUNCT3_BYTE;
          end
          default: begin
            illegal_insn = 1;
          end
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
