`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2024 22:40:11
// Design Name: 
// Module Name: Forwarding_Unit
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

module Forwarding_Unit(
        input [4:0] WriteRegW,WriteRegM,RS1E,RS2E,RS1D,RS2D,
        input RegWriteW,RegWriteM,MemtoRegM,
        output reg [1:0] ForwardAE,ForwardBE,
        output reg [1:0] ForwardAD,ForwardBD
       );
                  
    always @(*) begin
        // Forwarding logic for source register SrcAE
        if (RegWriteM && (RS1E != 5'b00000) && (RS1E == WriteRegM))
            ForwardAE = 2'b10;  //If RS1E matches with the Result in Mem Stage
        else if (RegWriteW && (RS1E != 5'b00000) && (RS1E == WriteRegW))
            ForwardAE = 2'b01;  //If RS1E matches with the Result in Write Back Stage
        else 
            ForwardAE = 2'b00;

        // Forwarding logic for source register SrcBE
        if (RegWriteM && (RS2E != 5'b00000) && (RS2E == WriteRegM))
            ForwardBE = 2'b10;  //If RS2E matches with the Result in Mem Stage
        else if (RegWriteW && (RS2E != 5'b00000) && (RS2E == WriteRegW))
            ForwardBE = 2'b01;  //If RS2E matches with the Result in Write Back Stage
        else 
            ForwardBE = 2'b00;
            
       // Forwarding logic for RD1
       if (RegWriteM && (RS1D != 5'b00000) && (RS1D == WriteRegM))
            ForwardAD = 2'b01;
       else if (MemtoRegM && (RS1D != 5'b00000) && (RS1D == WriteRegM))
            ForwardAD = 2'b10;
       else
            ForwardAD = 2'b00;
            
       // Forwarding logic for RD2
       if (RegWriteM && (RS2D != 5'b00000) && (RS2D == WriteRegM))
            ForwardBD = 1'b1;
       else if (MemtoRegM && (RS2D != 5'b00000) && (RS2D == WriteRegM))
            ForwardAD = 2'b10;
       else
            ForwardBD = 1'b0;
    end                             
endmodule


