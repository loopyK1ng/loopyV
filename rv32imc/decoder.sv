/********************************************************
 * The decoder of the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2023 Lennart M. Reimann
********************************************************/

`include "loopyV_constants.svh"

module decoder( input logic[31:0] instruction,
                output logic illegal_insn);//,
                //output pipeSignalsIFID control);


always_comb begin
    
    case(instruction[6:0]) // opcode check
            OPCODE_OP:  begin
                            case (instruction[31:25])
                                FUNCT7_ZEROS:   begin
                                                    case(instruction[14:12]) // funct3 check
                                                        FUNCT3_ADD:
                                                            illegal_insn = 0;
                                                        FUNCT3_SLT:
                                                            illegal_insn = 0;
                                                        FUNCT3_SLTU:
                                                            illegal_insn = 0;
                                                        FUNCT3_AND:
                                                            illegal_insn = 0;
                                                        FUNCT3_OR:
                                                            illegal_insn = 0;
                                                        FUNCT3_XOR:
                                                            illegal_insn = 0;
                                                        FUNCT3_SLL:
                                                            illegal_insn = 0;
                                                        FUNCT3_SRL:
                                                            illegal_insn = 0;
                                                        default:
                                                            illegal_insn = 1;
                                                    endcase
                                                end

                                FUNCT7_ONE:     begin
                                                    case(instruction[14:12]) // funct3 check
                                                        FUNCT3_SUB:
                                                            illegal_insn = 0;
                                                        FUNCT3_SRA:
                                                            illegal_insn = 0;
                                                        default:
                                                            illegal_insn = 1;
                                                    endcase
                                                end
                                default: illegal_insn = 1;
                            endcase
                        end

        OPCODE_OP_IMM:  begin
                            case (instruction[14:12]) //funct3 check
                                FUNCT3_ADDI:
                                    illegal_insn = 0;
                                FUNCT3_SLTI:
                                    illegal_insn = 0;
                                FUNCT3_SLTIU:
                                    illegal_insn = 0;
                                FUNCT3_ANDI:
                                    illegal_insn = 0;
                                FUNCT3_ORI:
                                    illegal_insn = 0;
                                FUNCT3_XORI:
                                    illegal_insn = 0;
                                FUNCT3_SLLI:begin
                                                if (instruction[31:25] == FUNCT7_ZEROS) begin //funct7 check
                                                    illegal_insn = 0;
                                                end else begin
                                                    illegal_insn = 1;
                                                end
                                            end
                                FUNCT3_SRLI_SRAI:begin
                                                if (instruction[31:25] == FUNCT7_ZEROS) begin //funct7 check
                                                    illegal_insn = 0;
                                                end else if(instruction[31:25] == FUNCT7_ZEROS) begin
                                                    illegal_insn = 0;
                                                end else
                                                    illegal_insn = 1;
                                                end
                                default: begin
                                    illegal_insn = 1;
                                end
                            endcase
                        end

        OPCODE_LUI:     illegal_insn = 0;

        OPCODE_AUIPC:   illegal_insn = 0;

        OPCODE_JAL:     illegal_insn = 0;

        OPCODE_JALR:    begin
                            if (instruction[14:12] == 3'b0) begin //funct3 check
                                illegal_insn = 0;
                            end else begin
                                illegal_insn = 1;
                            end 
                        end
        OPCODE_BRANCH:  begin
                            case (instruction[14:12]) //funct3 check
                                FUNCT3_BEQ:
                                    illegal_insn = 0;
                                FUNCT3_BNE:
                                    illegal_insn = 0;
                                FUNCT3_BLT:
                                    illegal_insn = 0;
                                FUNCT3_BLTU:
                                    illegal_insn = 0;
                                FUNCT3_BGE:
                                    illegal_insn = 0;
                                FUNCT3_BGEU:
                                    illegal_insn = 0;
                                default: begin
                                    illegal_insn = 1;
                                end
                            endcase
                        end 
        OPCODE_LOAD:    begin
                            case (instruction[14:12]) //funct3 check
                                FUNCT3_BYTE: illegal_insn = 0;
                                FUNCT3_HALFWORD: illegal_insn = 0;
                                FUNCT3_WORD: illegal_insn = 0;
                                FUNCT3_BYTE_U: illegal_insn = 0;
                                FUNCT3_HALFWORD_U: illegal_insn = 0;
                                default: illegal_insn = 1;
                            endcase
                        end
        OPCODE_STORE:   begin
                            case (instruction[14:12]) //funct3 check
                                FUNCT3_BYTE: illegal_insn = 0;
                                FUNCT3_HALFWORD: illegal_insn = 0;
                                FUNCT3_WORD: illegal_insn = 0;
                                default: illegal_insn = 1;
                            endcase
                        end

        OPCODE_MISC_MEM:begin
                            if (instruction[14:12] == FUNCT3_FENCE) begin   //funct3 check
                                illegal_insn = 0;
                            end else begin
                                illegal_insn = 1;
                            end  
                        end

        OPCODE_SYSTEM:  begin
                            case (instruction[14:12]) //funct3 check
                                FUNCT3_PRIV:    begin
                                                    case (instruction[31:20])
                                                        FUNCT12_ECALL: illegal_insn = 0;
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