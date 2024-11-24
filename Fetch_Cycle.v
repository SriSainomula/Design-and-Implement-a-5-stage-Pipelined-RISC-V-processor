`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2024 22:28:19
// Design Name: 
// Module Name: Fetch_Cycle
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


module Fetch_Cycle(
        input clk, rst,
        input PCSrcD,StallF,StallD,
        input [31:0] PCBranchD,
        output [31:0] InstrD,
        output [31:0] PCD, PCPlus4D,
        output hit
    );
    
    wire [31:0] PC, PCF, PCPlus4F;
    wire [31:0] InstrF_interim,InstrF;
    reg [31:0] InstrF_reg;
    reg [31:0] PCF_reg, PCPlus4F_reg;

    // PC Mux
    mux2_32 PC_MUX (
        .I0(PCPlus4F),
        .I1(PCBranchD),
        .sel(PCSrcD),
        .out(PC)
     );

    // PC Register
    flipflops_32 PC_Register (
        .D(PC),
        .clk(clk),
        .rst(rst),
        .en(StallF && ~hit),    //StallF && ~hit
        .Q(PCF)
    );
    
    /*
    //Instruction Memory
    instruction_memory Instruction_Memory (
        .a(PCF[5:0]),      // input wire [5 : 0] a
        .spo(InstrF_interim)  // output wire [31 : 0] spo
    );
    */
    
    //Cache Block Instantiation
    Cache_Block Instruction_Cache(
        .addr(PCF),
        .clk(clk),
        .rst(rst),
        .data(InstrF_interim),
        .hit(hit)
    );
    
    // NOP Mux
    mux2_32 NOP_MUX (
        .I0(32'd0),
        .I1(InstrF_interim),
        .sel(~StallF && hit),
        .out(InstrF)
     );

    // Declare PC adder
    assign PCPlus4F = PCF + 32'd1;

    // Fetch Cycle Register Logic
    always @(posedge clk) 
        begin
            if(rst == 1'b1 || PCSrcD == 1'b1) 
                begin
                    InstrF_reg <= 32'h00000000;
                    PCF_reg <= 32'h00000000;
                    PCPlus4F_reg <= 32'h00000000;
                end
            else if (StallD == 1'b0)
                begin
                    InstrF_reg <= InstrF;
                    PCF_reg <= PCF;
                    PCPlus4F_reg <= PCPlus4F;
                end
        end


    // Assigning Registers Value to the Output port
    assign  InstrD = InstrF_reg;
    assign  PCD = PCF_reg;
    assign  PCPlus4D = PCPlus4F_reg;

endmodule
