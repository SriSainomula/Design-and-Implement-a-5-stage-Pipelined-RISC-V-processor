`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2024 23:56:34
// Design Name: 
// Module Name: Main_Decoder
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

module Main_Decoder(
        input [6:0]Op,
        output RegWrite,MemWrite,MemtoReg,Branch,ALUSrc,lui,
        output [1:0]ALUOp
    );
    
    parameter RType = 7'b0110011, IType1 = 7'b0010011, IType2 = 7'b0000011, SType = 7'b0100011 , BType = 7'b1100011 , UType1 = 7'b0110111 , UType2 = 7'b0010111 , LUI = 7'b0110111;
    
    //IType1 is used for addi,andi,ori etc and IType2 is used for load instructions
    //UType1 is used for lui and UType2 is used for auipc instructions
    
    //We will write into Register for R-Type,I-Type and UTtpe
    assign RegWrite = (Op == 7'b0110011 | Op == 7'b0010011 | Op == 7'b0000011 | Op == 7'b0110111 | Op == 7'b0010111) ? 1'b1 : 1'b0 ;
                                         
   //We need to select the correct Input for ALU Operations 
   //We will select PC for lui and auipc Instructions i.e., UType ALUSrcA = 0 and for all other instructions ALUSrcA = 1
    //assign ALUSrcA = (Op == 7'b0110111 | Op == 7'b0010111) ? 1'b0 : 1'b1 ;
    
    //We need to select the correct Input for ALU Operations 
   //We will select rs2 for R-type,S-type and B-Type instructions i.e., ALUSrcB=0 and for all other instructions ALUSrcB = 1
    assign ALUSrc = (Op == 7'b0110011 | Op == 7'b0100011 | Op == 7'b1100011) ? 1'b0 : 1'b1 ;
                                                            
                                                            
    //We will write into Memory When we want to Store into Some Memory address
    assign MemWrite = (Op == 7'b0100011) ? 1'b1 : 1'b0 ;
    
    //We will read from Memory When we want to Load from Some Memory address
    //assign MemRead = (Op == 7'b0000011) ? 1'b1 : 1'b0 ;
                                           
   //We need to Write into Registers either form ALUResult or Data Memory
   //For Load Instructions we will write from Data Memory
    assign MemtoReg = (Op == 7'b0000011) ? 1'b1 : 1'b0 ;
                                            
   //We need to Write into Registers either form ALUResult or Data Memory
   //For Load Instructions we will write from Data Memory
    assign lui = (Op == 7'b0110111) ? 1'b1 : 1'b0 ;
    
    //Branching Instructions
    //assign Branch = (Op == 7'b1100011) ? 1'b1 : 1'b0 ;
                                         
    //We will use ALU for Reg-Reg operations and Branching Instructions
    assign ALUOp = (Op == 7'b0110011) ? 2'b10 :
                   (Op == 7'b1100011) ? 2'b01 :
                                        2'b00 ;

endmodule
