`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2024 16:31:05
// Design Name: 
// Module Name: Memory_Cycle
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

module Memory_Cycle(
        input clk, rst, RegWriteM, MemtoRegM, MemWriteM,
        input [4:0] WriteRegM,
        input [31:0] WriteDataM, ALUOutM,
        output RegWriteW, MemtoRegW,
        output [4:0] WriteRegW,
        output [31:0] ALUOutW, ReadDataM,ReadDataW
    );
    //wire [31:0] ReadDataM;
    reg RegWriteM_reg, MemtoRegM_reg;
    reg [4:0] WriteRegM_reg;
    reg [31:0] ALUOutM_reg, ReadDataM_reg;

    // Data Memory
    data_memory Data_Memory (
        .a(ALUOutM[5:0]),      // input wire [5 : 0] a
        .d(WriteDataM),      // input wire [31 : 0] d
        .clk(clk),  // input wire clk
        .we(MemWriteM),    // input wire we
        .spo(ReadDataM)  // output wire [31 : 0] spo
    );

    // Memory Stage Register Logic
    always @(posedge clk)
        begin
            if (rst == 1'b1) 
                begin
                    RegWriteM_reg <= 1'b0; 
                    MemtoRegM_reg <= 1'b0;
                    WriteRegM_reg <= 5'h00;
                    ALUOutM_reg <= 32'h00000000; 
                    ReadDataM_reg <= 32'h00000000;
                end
            else 
                begin
                    RegWriteM_reg <= RegWriteM; 
                    MemtoRegM_reg <= MemtoRegM;
                    WriteRegM_reg <= WriteRegM; 
                    ALUOutM_reg <= ALUOutM; 
                    ReadDataM_reg <= ReadDataM;
                end
        end 

    // Declaration of output assignments
    assign RegWriteW = RegWriteM_reg;
    assign MemtoRegW = MemtoRegM_reg;
    assign WriteRegW = WriteRegM_reg;
    assign ALUOutW = ALUOutM_reg;
    assign ReadDataW = ReadDataM_reg;

endmodule
