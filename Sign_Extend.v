`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2024 19:32:55
// Design Name: 
// Module Name: Sign_Extend
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

module Sign_Extend (In,Imm_Ext);

    input [31:0]In;
    output reg [31:0]Imm_Ext;
    
    wire [6:0]OpCode;
    
    assign OpCode = In[6:0];
    
    parameter RType = 7'b0110011, IType1 = 7'b0010011, IType2 = 7'b0000011, SType = 7'b0100011 , BType = 7'b1100011 , UType1 = 7'b0110111 , UType2 = 7'b0010111 , LUI = 7'b0110111 , JType = 7'b1101111;
    
    //IType1 is used for addi,andi,ori etc and IType2 is used for load instructions
    //UType1 is used for lui and UType2 is used for auipc instructions
    always@(*)
        begin
	       case(OpCode)
	           BType : Imm_Ext = {{20{In[31]}},In[31],In[7],In[30:25],In[11:8]};
		       IType1 : Imm_Ext = {{20{In[31]}},In[31:20]};
		       IType2 : Imm_Ext = {{20{In[31]}},In[31:20]};
		       SType : Imm_Ext = {{20{In[31]}},In[31:25],In[11:7]};
		       UType1 : Imm_Ext = {{12{In[31]}},In[31:12]};
		       UType2 : Imm_Ext = {{12{In[31]}},In[31:12]};
		       LUI : Imm_Ext = {In[31:12],12'h000};
		       JType : Imm_Ext = {{12{In[31]}},In[31],In[19:12],In[20],In[30:21]};
               default : Imm_Ext= 32'b0;
	       endcase
        end                              
endmodule
