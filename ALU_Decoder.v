`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2024 00:03:48
// Design Name: 
// Module Name: ALU_Decoder
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

module ALU_Decoder(
        input [1:0]ALUOp,
        input [2:0]funct3,
        input [6:0]funct7,op,
        output [2:0]ALUControl,
        output z,g
    );
    
    assign z = (op == 7'b1100011) ? (funct3 == 3'b000) ? 1'b1 : 1'b0 : 1'b0;
    assign g = (op == 7'b1100011) ? (funct3 == 3'b101) ? 1'b1 : 1'b0 : 1'b0;
    

    assign ALUControl = (ALUOp == 2'b00) ? 3'b000 :
                        (ALUOp == 2'b01) ? 3'b001 :
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({op[5],funct7[5]} == 2'b11)) ? 3'b001 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({op[5],funct7[5]} != 2'b11)) ? 3'b000 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b010)) ? 3'b101 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b110)) ? 3'b011 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b111)) ? 3'b010 : 
                        ((ALUOp == 2'b10) & (funct3 == 3'b100)) ? 3'b100 : 
                                                                  3'b000 ;
endmodule
