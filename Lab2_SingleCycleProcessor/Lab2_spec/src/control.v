`timescale 1ns / 1ps
// <111550168>

/** [Reading] 4.4 p.318-321
 * "Designing the Main Control Unit"
 */
/** [Prerequisite] alu_control.v
 * This module is the Control unit in FIGURE 4.17
 * You can implement it by any style you want.
 */

/* checkout FIGURE 4.16/18 to understand each definition of control signals */
module control (
    input  [5:0] opcode,      // the opcode field of a instruction is [?:?]
    input  [5:0] funct,       // the funct field of a instruction is [?:?]
    output       reg_dst,     // select register destination: rt(0), rd(1)
    output       alu_src,     // select 2nd operand of ALU: rt(0), sign-extended(1)
    output       mem_to_reg,  // select data write to register: ALU(0), memory(1)
    output       reg_write,   // enable write to register file
    output       mem_read,    // enable read form data memory
    output       mem_write,   // enable write to data memory
    output       branch,      // this is a branch instruction or not (work with alu.zero)
    output [1:0] alu_op       // ALUOp passed to ALU Control unit
);
    wire R_format, lw, sw, beq,ori,lui,nop;
    assign R_format=opcode == 6'b000000;
    assign lw = opcode == 6'b100011;
    assign sw = opcode == 6'b101011;
    assign beq = opcode == 6'b000100;
    assign nop = R_format&(~|funct);    //handle nop:funct == 000000
    assign lui = opcode == 6'b001111;    //handle lui ori 
    assign ori = opcode == 6'b001101;
    
    assign reg_dst=R_format;
    assign alu_src=lw|sw|ori|lui;
    assign mem_to_reg=lw;//ori,lui在execution處理
    assign reg_write=(R_format&~nop)|lw|ori|lui;//enable write to register file
    assign mem_read=lw;//
    assign mem_write=sw;
    assign branch=beq;
    assign alu_op[1]=R_format;
    assign alu_op[0]=beq;

    /* implement "combinational" logic satisfying requirements in FIGURE 4.18 */
    /* You can check the "Green Card" to get the opcode/funct for each instruction. */

endmodule
