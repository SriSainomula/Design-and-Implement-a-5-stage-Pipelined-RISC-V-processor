`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2024 19:26:56
// Design Name: 
// Module Name: mux4_32
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

//32-bit 4to1 mux
module mux4_32 (I0,I1,I2,I3,sel,out );

    input [31:0] I0,I1,I2,I3;
    input [1:0]sel;
    output [31:0]out;
    
    assign out = (sel == 2'b00) ? I0 : (sel == 2'b01) ? I1 : (sel == 2'b10) ? I2 : I3;

endmodule
