`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2024 22:47:48
// Design Name: 
// Module Name: fiftyMHZ_generator
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

module fiftyMHZ_generator(
        input clk_100MHz,
        output clk_50MHz
       );
        reg clk_out_reg=0;
        reg [25:0] counter_reg=0;
        always @(posedge clk_100MHz)
            begin
                if(counter_reg == 2)
                    begin    
                        //We will change the 50MHz clock state once we reached the alternate edge of 100MHz clock
                        counter_reg<=0;
                        clk_out_reg<= ~clk_out_reg;
                    end
                else
                    counter_reg<=counter_reg+1;
            end
        assign clk_50MHz=clk_out_reg;
endmodule
