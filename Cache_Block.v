`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2024 23:09:23
// Design Name: 
// Module Name: Cache_Block
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

module Cache_Block(
        input [31:0]addr,
        input clk,rst,
        output reg [31:0]data,
        output hit
       );

        wire [26:0]tag;
        wire [26:0]tag_out;
        wire [1:0]offset;
        wire [2:0]index;
        wire valid;
        wire [127:0]cache_line,temp;
        reg [127:0]cache_line_in;

        assign tag = addr[29:2];  // decoding tag index offset from address
        assign index = addr[4:2];
        assign offset = addr[1:0];    

        Cache_Memory cache_mem(
            .hit(hit),
            .rst(rst),
            .clk(clk),
            .tag_in(tag),
            .data_in(cache_line_in),
            .addr(index),
            .data_out(cache_line),
            .tag_out(tag_out),
            .valid(valid)
         );
           
        assign hit = (tag == tag_out)& valid ? 1'b1 : 1'b0;

        always @ (*) 
            begin
                if(~hit)
                    cache_line_in = {1'b1,tag,temp};
                else
                    cache_line_in = 156'b0;
            end

    //Instantiating Instruction Memory
    /*
    Instruction_Memory instruction_memory (
        .a(addr[7:2]),      // input wire [5 : 0] a
        .spo(temp)  // output wire [127 : 0] spo
    );
    */
    
    instruction_memcache instruction_memory (
        .a(addr[7:2]),      // input wire [5 : 0] a
        .spo(temp)  // output wire [127 : 0] spo
    );

    always @(*) 
        begin
            if(offset == 2'd0) 
                data = cache_line[127:96];
            else if(offset == 2'd1) 
                data = cache_line[95:64];
            else if(offset == 2'd2) 
                data = cache_line[63:32];
            else 
                data = cache_line[31:0];
        end
endmodule

