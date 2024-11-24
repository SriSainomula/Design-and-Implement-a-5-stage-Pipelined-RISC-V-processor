`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2024 15:35:04
// Design Name: 
// Module Name: Execute_Cycle
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

module Execute_Cycle(
        input clk, rst, RegWriteE,MemtoRegE,MemWriteE,ALUSrcE,
        input [2:0] ALUControlE,
        input [31:0] RD1E, RD2E, SignImmE,
        input [4:0] RS1E,RS2E,RdE,
        input [31:0] ResultW,
        input [1:0] ForwardAE, ForwardBE,
        output RegWriteM,MemtoRegM,MemWriteM,
        output [4:0] WriteRegM,
        output [31:0] WriteDataM, ALUOutM
    );

    wire [31:0] SrcAE, SrcB_interim, SrcBE,ALUOutE;
    wire [4:0]WriteRegE;
    reg RegWriteE_reg,MemtoRegE_reg,MemWriteE_reg;
    reg [4:0] WriteRegE_reg;
    reg [31:0] WriteDataE_reg,ALUOutE_reg;
    
    // 3 by 1 Mux for Source A
    mux4_32 SrcA_mux (
        .I0(RD1E),
        .I1(ResultW),
        .I2(ALUOutM),
        .I3(32'd0),
        .sel(ForwardAE),
        .out(SrcAE)
    );

    // 3 by 1 Mux for Source A
    mux4_32 SrcB_mux (
        .I0(RD2E),
        .I1(ResultW),
        .I2(ALUOutM),
        .I3(32'd0),
        .sel(ForwardBE),
        .out(SrcB_interim)
    );
    
    
    // ALU SrcB 2 by 1 Mux
    mux2_32 ALUSrcB_mux (
        .I0(SrcB_interim),
        .I1(SignImmE),
        .sel(ALUSrcE),
        .out(SrcBE)
    );
    
    //WriteReg
    assign WriteRegE = RdE;

    // ALU Unit
    ALU ALU_Unit (
        .SrcA(SrcAE),
        .SrcB(SrcBE),
        .ALUControl(ALUControlE),
        .ALUResult(ALUOutE)
    );

    // Register Logic
    always @(posedge clk)
        begin
            if(rst == 1'b1) 
                begin
                    RegWriteE_reg <= 1'b0;
                    MemtoRegE_reg <= 1'b0; 
                    MemWriteE_reg <= 1'b0; 
                    ALUOutE_reg <= 32'h00000000;
                    WriteDataE_reg <= 32'h00000000;
                    WriteRegE_reg <= 5'd00000;
                    
                end
            else 
                begin
                    RegWriteE_reg <= RegWriteE; 
                    MemtoRegE_reg <= MemtoRegE;
                    MemWriteE_reg <= MemWriteE; 
                    ALUOutE_reg <= ALUOutE;
                    WriteDataE_reg <= SrcB_interim;
                    WriteRegE_reg <= WriteRegE;
                end
        end

    // Output Assignments
    //assign PCSrcE = ZeroE &  BranchE;
    assign RegWriteM = RegWriteE_reg;
    assign MemtoRegM = MemtoRegE_reg;
    assign MemWriteM = MemWriteE_reg;
    assign ALUOutM = ALUOutE_reg;
    assign WriteDataM = WriteDataE_reg;
    assign WriteRegM = WriteRegE_reg;

endmodule
