`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2024 19:14:35
// Design Name: 
// Module Name: WriteBack_Cycle
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

module WriteBack_Cycle(
            input clk, rst, MemtoRegW,
            input [31:0] ALUOutW, ReadDataW,
            output [31:0] ResultW
        );

        // Declaration of Module
        mux2_32 result_mux (
            .I0(ALUOutW),
            .I1(ReadDataW),
            .sel(MemtoRegW),
            .out(ResultW)
        );
endmodule
