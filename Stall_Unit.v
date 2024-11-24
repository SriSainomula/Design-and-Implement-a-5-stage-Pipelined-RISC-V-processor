`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.11.2024 00:53:52
// Design Name: 
// Module Name: Stall_Unit
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

module Stall_Unit(
        input [4:0] WriteRegE,WriteRegM,RS1D,RS2D,RdE,
        input RegWriteE,BranchD,MemtoRegE,MemtoRegM,
        output StallF,StallD,FlushE
       );
    parameter rcm = 2'd2;
    reg [5:0] stall_count;
    wire lwStall,branchStall;
    
    // Load Store Stall 
    assign lwStall = (MemtoRegE && ((RS1D == RdE) || (RS2D == RdE)));
    
    //Branch Stall
    assign branchStall = (BranchD && RegWriteE && ((WriteRegE == RS1D) || (WriteRegE == RS2D))) || (BranchD && MemtoRegM && ((WriteRegM == RS1D) || (WriteRegM == RS2D)));
    
    assign StallF = lwStall || branchStall;
    assign StallD = lwStall || branchStall;
    assign FlushE = lwStall || branchStall;
    
endmodule

