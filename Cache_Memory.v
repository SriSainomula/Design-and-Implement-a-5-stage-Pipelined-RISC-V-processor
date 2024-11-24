`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2024 23:05:18
// Design Name: 
// Module Name: Cache_Memory
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

module Cache_Memory(
        input hit,rst,clk,
        input [26:0]tag_in,
        input [127:0]data_in,
        input [2:0]addr,
        output [127:0]data_out,
        output [26:0]tag_out,
        output valid
      );

        reg [155:0] mem [0:7];
        integer i; 
    
        always @(posedge clk) 
            begin
                if (rst) 
                    begin
                        for(i=0; i<8; i= i+1)
                            mem[i] <= 156'd0;
                    end
                else 
                    begin 
                        if(!hit) 
                            begin
                                mem[addr] <= {1'b1, tag_in, data_in};
                                           //Valid bit,Instr_Tag,4Instructions  
                            end
                    end
            end 
        assign valid = mem[addr][155];
        assign tag_out = mem[addr][154:128];
        assign data_out = mem[addr][127:0];
endmodule

