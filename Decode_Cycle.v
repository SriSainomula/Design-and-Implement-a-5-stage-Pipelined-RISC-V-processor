`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2024 23:25:09
// Design Name: 
// Module Name: Decode_Cycle
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

module Decode_Cycle(
        input clk, rst, RegWriteW,FlushE,
        input [1:0] ForwardAD,ForwardBD,
        input [4:0] WriteRegW,
        input [31:0] InstrD, PCD, PCPlus4D, ALUOutM, ResultW,ReadDataM,
        output RegWriteE,MemtoRegE,MemWriteE,ALUSrcE,PCSrcD,BranchD,
        output [2:0] ALUControlE,
        output [31:0] RD1E, RD2E, SignImmE, ref_out,
        output [4:0] RS1E, RS2E, RdE,
        output [31:0] PCBranchD
    );
    
    wire RegWriteD,MemtoRegD,MemWriteD,ALUSrcD;
    wire lui,z,g,res_zero,res_greater;
    //wire [1:0] ImmSrcD;
    wire [2:0] ALUControlD;
    wire [31:0] RD1D, RD2D, SignImmD, BranchOp1, BranchOp2;
    wire [31:0]ref_out_interim;
    reg RegWriteD_reg,MemtoRegD_reg,MemWriteD_reg,ALUSrcD_reg,BranchD_reg;
    reg [2:0] ALUControlD_reg;
    reg [31:0] RD1D_reg, RD2D_reg, SignImmD_reg;
    reg [4:0] RS1D_reg, RS2D_reg,RdD_reg;
    //reg [31:0] PCD_r, PCPlus4D_r;

    // Control Unit
    controller Control_Path (
        .Op(InstrD[6:0]),
        .funct7(InstrD[31:25]),
        .funct3(InstrD[14:12]),
        .RegWrite(RegWriteD),
        .MemtoReg(MemtoRegD),
        .MemWrite(MemWriteD),
        .ALUControl(ALUControlD),
        .ALUSrc(ALUSrcD),
        .Branch(BranchD),
        .lui(lui),
        .z(z),
        .g(g)
    );

    // Register File
    Register_File reg_file (
        .clk(clk),
        .rst(rst),
        .write_en(RegWriteW),
        .A1(InstrD[19:15]),
        .A2(InstrD[24:20]),
        .A3(WriteRegW),
        .RD1(RD1D),
        .RD2(RD2D),
        .WD3(ResultW),
        .ref_out(ref_out_interim)
    );
    
    //2 by 1 for Branch Operand-1
    //mux2_32 RD1_mux(
    //    .I0(RD1D),
    //    .I1(ALUOutM),
    //    .sel(ForwardAD),
    //    .out(BranchOp1)
    //);
    
    // 3 by 1 for Branch Operand-1
    mux4_32 RD1_mux (
        .I0(RD1D),
        .I1(ALUOutM),
        .I2(ReadDataM),
        .I3(32'd0),
        .sel(ForwardAD),
        .out(BranchOp1)
    );
    
     // 3 by 1 for Branch Operand-2
    mux4_32 RD2_mux (
        .I0(RD2D),
        .I1(ALUOutM),
        .I2(ReadDataM),
        .I3(32'd0),
        .sel(ForwardBD),
        .out(BranchOp2)
    );
    
    //2 by 1 for Branch Operand-2
   // mux2_32 RD2_mux(
    //    .I0(RD2D),
    //    .I1(ALUOutM),
    //    .sel(ForwardBD),
     //   .out(BranchOp2)
   // );
    
    //Branching Check for BGE and BEQ
    wire [31:0] Result_interim;
    assign Result_interim = BranchOp1 + (~BranchOp2) + 1'b1;
    assign res_zero = (Result_interim == 32'h00000000) ? 1'b1 : 1'b0; // Zero Flag
    assign res_greater = (Result_interim[31] == 1'b0) ? 1'b1 : 1'b0; // Greater Flag 
    //[We will perform SrcA - SrcB, if Result is +ve it means SrcA is greater than SrcB 
    //                              else if Result is -ve it means SrcA is less than SrcB
    
    //Branching Assignment
    assign PCSrcD = (z && res_zero) || (g && res_greater);
    
    //Whether the Instruction is Branch or not
    assign BranchD = z || g;   

    // Sign Extension
    Sign_Extend ImmGen(
        .In(InstrD),
        .Imm_Ext(SignImmD)
     );
     
     // Adder
    assign PCBranchD = SignImmD;
    
    //Max value assignment to ref_out
    assign ref_out = (rst == 1'b1) ? 32'd0 : ref_out_interim;

    // Declaring Register Logic
    always @(posedge clk) 
        begin
            if(rst == 1'b1 || FlushE) 
                begin
                    RegWriteD_reg <= 1'b0;
                    MemtoRegD_reg <= 1'b0;
                    MemWriteD_reg <= 1'b0;
                    ALUControlD_reg <= 3'b000;
                    ALUSrcD_reg <= 1'b0;
                    BranchD_reg <= 1'b0;
            
                    RD1D_reg <= 32'h00000000; 
                    RD2D_reg <= 32'h00000000; 
            
                    RS1D_reg <= 5'h00;
                    RS2D_reg <= 5'h00;
                    RdD_reg <= 5'h00;
                    SignImmD_reg <= 32'h00000000;
                end
            else 
                begin
                    RegWriteD_reg <= RegWriteD;
                    MemtoRegD_reg <= MemtoRegD;
                    MemWriteD_reg <= MemWriteD;
                    ALUControlD_reg <= ALUControlD;
                    ALUSrcD_reg <= ALUSrcD;
                    BranchD_reg <= BranchD;
            
                    RD1D_reg <= RD1D; 
                    RD2D_reg <= RD2D; 
            
                    RS1D_reg <= InstrD[19:15];
                    RS2D_reg <= InstrD[24:20];
                    RdD_reg <= InstrD[11:7];
                    SignImmD_reg <= SignImmD;
                end
        end

    // Output asssign statements
    assign RegWriteE = RegWriteD_reg;
    assign MemtoRegE = MemtoRegD_reg;
    assign MemWriteE = MemWriteD_reg;
    assign ALUControlE = ALUControlD_reg;
    assign ALUSrcE = ALUSrcD_reg;
    //assign BranchE = BranchD_reg;
    
    assign RD1E = RD1D_reg;
    assign RD2E = RD2D_reg;
    
    assign RS1E = RS1D_reg;
    assign RS2E = RS2D_reg;
    assign RdE = RdD_reg;
    assign SignImmE = SignImmD_reg;

endmodule


