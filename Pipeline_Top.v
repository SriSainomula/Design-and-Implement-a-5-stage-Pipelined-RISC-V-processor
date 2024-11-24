`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2024 23:25:51
// Design Name: 
// Module Name: Pipeline_Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Pipeline_top(
            input clk, rst,
            output [31:0] max
       );

    // Declaration of Interim Wires
    wire PCSrcD, BranchD, RegWriteW, RegWriteE, MemtoRegE, ALUSrcE, MemWriteE, RegWriteM, MemWriteM, MemtoRegM, MemtoRegW;
    wire [2:0] ALUControlE;
    wire [4:0] RdE, WriteRegW, WriteRegM, WriteRegE;
    wire [31:0] PCBranchD, InstrD, PCD, PCPlus4D, ResultW, RD1E, RD2E, SignImmE, WriteDataM, ALUOutM;
    wire [31:0] ALUOutW, ReadDataW,ReadDataM;
    wire [4:0] RS1E, RS2E;
    wire [1:0] ForwardAE, ForwardBE, ForwardAD, ForwardBD;
    wire StallF, StallD, FlushE, hit;
    wire [4:0] RS1D, RS2D;
    
    assign RS1D = InstrD[19:15];
    assign RS2D = InstrD[24:20];
    assign WriteRegE = RdE;
    
    // Fetch Stage
    Fetch_Cycle Fetch (
            .clk(clk), 
            .rst(rst), 
            .PCSrcD(PCSrcD), 
            .StallF(StallF),
            .StallD(StallD),
            .PCBranchD(PCBranchD), 
            .InstrD(InstrD), 
            .PCD(PCD), 
            .PCPlus4D(PCPlus4D),
            .hit(hit)
        );

    // Decode Stage
    Decode_Cycle Decode (
            .clk(clk), 
            .rst(rst), 
            .RegWriteW(RegWriteW),
            .ForwardAD(ForwardAD),
            .ForwardBD(ForwardBD),
            .FlushE(FlushE),
            .WriteRegW(WriteRegW),
            .InstrD(InstrD), 
            .PCD(PCD), 
            .PCPlus4D(PCPlus4D), 
            .ALUOutM(ALUOutM),
            .ResultW(ResultW),
            .ReadDataM(ReadDataM),
            .RegWriteE(RegWriteE),
            .MemtoRegE(MemtoRegE),
            .MemWriteE(MemWriteE),
            .ALUSrcE(ALUSrcE),
            .PCSrcD(PCSrcD),
            .BranchD(BranchD),
            .ALUControlE(ALUControlE),
            .RD1E(RD1E), 
            .RD2E(RD2E),
            .SignImmE(SignImmE),
            .ref_out(max),
            .RS1E(RS1E),
            .RS2E(RS2E),
            .RdE(RdE), 
            .PCBranchD(PCBranchD)
        );

    // Execute Stage
    Execute_Cycle Execute (
            .clk(clk), 
            .rst(rst), 
            .RegWriteE(RegWriteE),
            .MemtoRegE(MemtoRegE),
            .MemWriteE(MemWriteE),
            .ALUSrcE(ALUSrcE), 
            .ALUControlE(ALUControlE),
            .RD1E(RD1E), 
            .RD2E(RD2E), 
            .SignImmE(SignImmE),
            .RS1E(RS1E),
            .RS2E(RS2E),
            .RdE(RdE),
            .ResultW(ResultW),
            .ForwardAE(ForwardAE),
            .ForwardBE(ForwardBE),
            .RegWriteM(RegWriteM),
            .MemtoRegM(MemtoRegM),
            .MemWriteM(MemWriteM),
            .WriteRegM(WriteRegM),
            .WriteDataM(WriteDataM),
            .ALUOutM(ALUOutM) 
        );
    
    // Memory Stage
    Memory_Cycle Memory (
            .clk(clk), 
            .rst(rst), 
            .RegWriteM(RegWriteM), 
            .MemtoRegM(MemtoRegM),
            .MemWriteM(MemWriteM), 
            .WriteRegM(WriteRegM), 
            .WriteDataM(WriteDataM),
            .ALUOutM(ALUOutM),
            .RegWriteW(RegWriteW),
            .MemtoRegW(MemtoRegW),
            .WriteRegW(WriteRegW),
            .ALUOutW(ALUOutW),
            .ReadDataM(ReadDataM),
            .ReadDataW(ReadDataW)
        );

    // Write Back Stage
    WriteBack_Cycle WriteBack (
            .clk(clk), 
            .rst(rst), 
            .MemtoRegW(MemtoRegW), 
            .ALUOutW(ALUOutW),
            .ReadDataW(ReadDataW),
            .ResultW(ResultW)
        );

    // Forwarding Unit
    Forwarding_Unit Forwarding_block (
            .WriteRegW(WriteRegW),
            .WriteRegM(WriteRegM),
            .RS1E(RS1E), 
            .RS2E(RS2E),
            .RS1D(RS1D),
            .RS2D(RS2D),
            .RegWriteW(RegWriteW), 
            .RegWriteM(RegWriteM),
            .MemtoRegM(MemtoRegM),
            .ForwardAE(ForwardAE), 
            .ForwardBE(ForwardBE),
            .ForwardAD(ForwardAD),
            .ForwardBD(ForwardBD)
        );
        
    //Stalling and Flushing Unit
    Stall_Unit Stalling_block (
            .WriteRegE(WriteRegE),
            .WriteRegM(WriteRegM),
            .RS1D(RS1D),
            .RS2D(RS2D),
            .RdE(RdE),
            .RegWriteE(RegWriteE),
            .BranchD(BranchD),
            .MemtoRegE(MemtoRegE),
            .MemtoRegM(MemtoRegM),
            .StallF(StallF),
            .StallD(StallD),
            .FlushE(FlushE)
        );
endmodule
