`timescale 1ns / 1ps
// <111550168>

/** [Reading] 4.4 p.318-321
 * "Designing the Main Control Unit"
 */
/** [Prerequisite] alu_control.v
 * This module is the Control unit in FIGURE 4.17
 * You can implement it by any style you want.
 */

module control (
    input  [5:0] opcode,      
    input  [5:0] funct,      
    output       reg_dst,     
    output       alu_src,     
    output       mem_to_reg,  
    output       reg_write,   
    output       mem_read,    
    output       mem_write,
    output       branch,      
    output [1:0] alu_op       
);
    wire R_format, lw, sw, beq,ori,lui,nop,addi;
    assign R_format=opcode == 6'b000000;
    assign lw = opcode == 6'b100011;
    assign sw = opcode == 6'b101011;
    assign beq = opcode == 6'b000100;
    assign nop = R_format&(~|funct);    
    //assign lui = opcode == 6'b001111;    
    //assign ori = opcode == 6'b001101;
    assign addi = opcode == 6'b001000;
    
    assign reg_dst=R_format;
    assign alu_src=lw|sw|addi;
    assign mem_to_reg=lw;//ori,lui¦bexecution³B²z
    assign reg_write=(R_format&~nop)|lw|addi;//enable write to register file
    assign mem_read=lw;//
    assign mem_write=sw;
    assign branch=beq;
    assign alu_op[1]=R_format;
    assign alu_op[0]=beq;

endmodule
