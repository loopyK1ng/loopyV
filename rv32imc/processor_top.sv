/********************************************************
 * The top module of the 32-bit RISC-V processor
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2023 Lennart M. Reimann
********************************************************/


module processor_top(input clk,
                    input arstn,
                    output [31:0]pmAddr,
                    input [31:0]pmData,
                    output [31:0]dmAddr,
                    output [31:0]dmStData,
                    input [31:0]dmLdData,
                    output dmSignal,
                    

                    );


/* The processor implements the following pipeline stages:
Instruction Fetch (IF): Fetch the instruction
Insutrction Decode (ID): Decode the instructions and load the operands
Execute (EX): Execute the instruction (mostly ALU operations)
Memory (MEM): Memory accesses are started here
Write-back (WB): Write back the result to the register file
*/

endmodule
