/********************************************************
 * The hazard control unit
 * written by Lennart M. Reimann.
 *
 *
 * Apache License, Version 2.0
 * Copyright (c) 2024 Lennart M. Reimann
********************************************************/


module hazard_control(
    input logic [4:0] rs1AddrDE,
    input logic [4:0] rs2AddrDE,
    input logic [4:0] rdAddrEX,
    input logic [4:0] rdAddrMEM,
    input logic [4:0] rdAddrWB,

    input logic rdWriteEnEX,
    input logic rdWriteEnMEM,
    input logic rdWriteEnWB,

    output logic stallIFDE,
    output logic flushEX
);

// Identify Data Hazards

always_comb begin
    if((rs1AddrDE != 5'b0) & (rs1AddrDE == rdAddrEX) & rdWriteEnEX) begin
        stallIFDE = 1'b1;
        flushEX = 1'b1;
    end else if ((rs1AddrDE != 5'b0) & (rs1AddrDE == rdAddrMEM) & rdWriteEnMEM) begin
        stallIFDE = 1'b1;
        flushEX = 1'b1;
    end else if ((rs1AddrDE != 5'b0) & (rs1AddrDE == rdAddrWB) & rdWriteEnWB) begin
        stallIFDE = 1'b1;
        flushEX = 1'b1;
    end else if((rs2AddrDE != 5'b0) & (rs2AddrDE == rdAddrEX) & rdWriteEnEX) begin
        stallIFDE = 1'b1;
        flushEX = 1'b1;
    end else if ((rs2AddrDE != 5'b0) & (rs2AddrDE == rdAddrMEM) & rdWriteEnMEM) begin
        stallIFDE = 1'b1;
        flushEX = 1'b1;
    end else if ((rs2AddrDE != 5'b0) & (rs2AddrDE == rdAddrWB) & rdWriteEnWB) begin
        stallIFDE = 1'b1;
        flushEX = 1'b1;
    end else begin
        stallIFDE = 1'b0;
        flushEX = 1'b0;
    end

end
endmodule