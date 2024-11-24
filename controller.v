`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2024 23:49:01
// Design Name: 
// Module Name: controller
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

module controller(
        input [6:0]Op,funct7,
        input [2:0]funct3,
        output RegWrite,MemtoReg,MemWrite,ALUSrc,Branch,
        output [2:0]ALUControl,
        output lui,z,g
    );

    wire [1:0]ALUOp;

    Main_Decoder Main_Decoder(
                .Op(Op),
                .RegWrite(RegWrite),
                .MemWrite(MemWrite),
                .MemtoReg(MemtoReg),
                .Branch(Branch),
                .ALUSrc(ALUSrc),
                .lui(lui),
                .ALUOp(ALUOp)
    );

    ALU_Decoder ALU_Decoder(
                 .ALUOp(ALUOp),
                 .funct3(funct3),
                 .funct7(funct7),
                 .op(Op),
                 .ALUControl(ALUControl),
                 .z(z),
                 .g(g)
    );


endmodule
