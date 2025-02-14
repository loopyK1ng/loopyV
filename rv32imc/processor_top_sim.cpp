#include <stdio.h>
#include <stdlib.h>
#include "Vprocessor_top.h"
#include "Vprocessor_top_processor_top.h"
#include "Vprocessor_top_pipeDEEX.h"
#include "verilated.h"

unsigned pm[20] = {
    0xfd010113, // addi sp, sp, -48         0x0
    0x02112623, // sw ra, 44(sp)            0x4
    0x02812423, // sw s0, 40(sp)            0x8
    0x03010413, // addi s0, sp, 48          0xc
    0x07d00793, // li a5, 125               0x10
    0xfef42623, // sw a5, -20(s0)           0x14
    0x10000793, // li a5, 256               0x18
    0xfef42423, // sw a5, -24(s0)           0x1c
    0xfec42703, // lw a4, -20(s0)           0x20
    0xfe842783, // lw a5, -24(s0)           0x24
    0x00f707b3, // add a5, a4, a5           0x28
    0xfef42223, // sw a5, -28(s0)           0x2c
    0xfe442783, // lw a5, -28(s0)           0x30
    0xfef42023, // sw a5, -32(s0)           0x34
    0x0007a783  // lw a5, -32(s0)           0x38

};


int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    Vprocessor_top *tb = new Vprocessor_top;

    int half_cycle_delay_address = 0;
    int cycle_delay_address = 0;
    tb->arstn = 0;
    tb->clk = 0;
    tb->eval();
    printf("clk = %2d, ", tb->clk);
    printf("arstn = %2d, ", tb->arstn);
    printf("\n");

    tb->arstn = 1;

    for (int k = 0; k < 60; k++)
    {
        cycle_delay_address = half_cycle_delay_address;
        half_cycle_delay_address = tb->pmAddr;
        tb->clk = k & 1;
        tb->pmData = pm[tb->pmAddr / 4];

        tb->eval();

        printf("Cycle = %2d\n", int(k / 2));
        printf("Inputs:\n");
        printf("clk = %2d, ", tb->clk);
        printf("arstn = %2d, ", tb->arstn);
        printf("pmData = %#06x, ", tb->pmData);
        printf("dataBusLdData = %2d\n", tb->dataBusLdData);
        printf("Outputs:\n");

        printf("pmAddr = %2d, ", tb->pmAddr);
        printf("dataBusAddr = %2d, ", tb->dataBusAddr);
        printf("dataBusStData = %2d, ", tb->dataBusStData);
        printf("dataBusLdSignal = %2d, ", tb->dataBusLdSignal);
        printf("dataBusStSignal = %2d, ", tb->dataBusStSignal);
        printf("dataBusWriteMask = %2d\n", tb->dataBusWriteMask);

            printf("StallSignal = %2d, ", tb->processor_top->stallIFDE);
            printf("PC(IF) = %2d, ", tb->processor_top->pc[0]);

        if ((k & 1) == 1)
        {

            printf("DestinationSelect(DE) = %u, ", tb->processor_top->destinationSelect[0]);
            printf("DestinationSelect(EX) = %u, ", tb->processor_top->destinationSelect[1]);
            printf("DestinationSelect(MEM) = %u, ", tb->processor_top->destinationSelect[2]);
            printf("DestinationSelect(WB) = %u\n", tb->processor_top->destinationSelect[3]);

            printf("PC(IF) = %2d, ", tb->processor_top->pc[0]);
            printf("PC(DE) = %2d, ", tb->processor_top->pc[1]);
            printf("PC(EX) = %2d, ", tb->processor_top->pc[2]);
            printf("PC(MEM) = %2d, ", tb->processor_top->pc[3]);
            printf("PC(WB) = %2d\n", tb->processor_top->pc[4]);

            printf("WE(DE) = %2d, ", tb->processor_top->rdWriteEn[0]);
            printf("WE(EX) = %2d, ", tb->processor_top->rdWriteEn[1]);
            printf("WE(MEM) = %2d, ", tb->processor_top->rdWriteEn[2]);
            printf("WE(WB) = %2d\n", tb->processor_top->rdWriteEn[3]);

            printf("Rs1Data(DE) = %#010x, ", tb->processor_top->rs1Data[0]);
            printf("Rs2Data(DE) = %#010x, ", tb->processor_top->rs2Data[0]);
            printf("RdData(MEM) = %#010x, ", tb->processor_top->rdWriteData[0]);
            printf("RdData(WB) = %#010x\n", tb->processor_top->rdWriteData[1]);

            printf("OperandASelect(DE) = %#010x, ", tb->processor_top->operandASelect[0]);
            printf("OperandBSelect(DE) = %#010x, ", tb->processor_top->operandBSelect[0]);
            printf("OperandA(EX) = %#010x, ", tb->processor_top->operandA[0]);
            printf("OperandB(EX) = %#010x, ", tb->processor_top->operandB[0]);
            printf("NEXTOperandA(DE) = %#010x, ", tb->processor_top->pipeDEEX->nextOperandA);
            printf("NEXTOperandB(DE) = %#010x, ", tb->processor_top->pipeDEEX->nextOperandB);
            printf("Immediate(DE) = %#010x, ", tb->processor_top->immediate[0]);
            printf("Immediate(EX) = %#010x, ", tb->processor_top->immediate[1]);
        
        }
        printf("\n\n");
    }
}