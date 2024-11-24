`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2024 19:07:59
// Design Name: 
// Module Name: Register_File
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

//32-bit REGISTER FILE
module Register_File (clk,rst, write_en, A1, A2, A3, RD1, RD2 ,WD3, ref_out);
    input clk,rst, write_en;
    input [4:0] A1, A2, A3;
    input [31:0] WD3;
    output [31:0] RD1, RD2;
    output [31:0] ref_out;
    integer i;
    reg [31:0] mem [31:0];

    always @(posedge clk or posedge rst) 
        begin
            if (rst) 
                begin
                    for (i = 0; i < 32; i = i + 1) 
                        begin
                            //mem[i] <= 16'h0000;
                            mem[i] <= i;
                        end
                end
            else if (write_en && (A3 != 3'b000)) 
                //We can't modify R0 as it should always be 0 [According to RISC-V Constraints]
                begin
                    mem[A3] <= WD3;
                end
        end

    assign RD1 = mem[A1];
    assign RD2 = mem[A2];
    assign ref_out = mem[3'b011];
endmodule
