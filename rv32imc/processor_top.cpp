#include <stdio.h>
#include <stdlib.h>
#include "Vprocessor_top.h"
#include "Vprocessor_top_processor_top.h"
#include "verilated.h"


unsigned pm[20] = {
    0xfd010113,  //addi sp, sp, -48
    0x02112623,  //sw ra, 44(sp)
    0x02812423,  //sw s0, 40(sp)
    0x03010413,  //addi s0, sp, 48
    0x07d00793,  //li a5, 125
    0xfef42623,  //sw a5, -20(s0)
    0x10000793,  //li a5, 256
    0xfef42423,  //sw a5, -24(s0)
    0xfec42703,  //lw a4, -20(s0)
    0xfe842783,  //lw a5, -24(s0)
    0x00f707b3,  //add a5, a4, a5
    0xfef42223,  //sw a5, -28(s0)
    0xfe442783,  //lw a5, -28(s0)
    0xfef42023,  //sw a5, -32(s0)
    0x0007a783   //lw a5, -32(s0)
};

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    Vprocessor_top *tb = new Vprocessor_top;

    tb->arstn = 0;
    tb->clk = 0;
    tb->eval();
    printf("clk = %2d, ", tb->clk);
    printf("arstn = %2d, ", tb->arstn);
    printf("\n");

    tb->arstn = 1;

    for (int k = 0; k < 20; k++)
    {
        tb->clk = k & 1;
        tb->pmData = pm[tb->pmAddr/4];
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
        printf("dataBusWriteMask = %2d, ", tb->dataBusWriteMask);

        if ((k & 1) == 0)
        {
            printf("PC = %2d, ", tb->processor_top->pc[0]);
        }
        printf("\n\n");
    }
}