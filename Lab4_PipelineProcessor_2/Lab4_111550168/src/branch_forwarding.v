`timescale 1ns / 1ps
// <111550168>

/** [Reading] 4.7 p.363-371
 * Understand when and how to forward
 */

/* checkout FIGURE 4.55 for definition of mux control signals */
/* checkout FIGURE 4.56/60 for how this unit should be connected */
module branch_forwarding (
    input      [4:0] IF_ID_rs,          // inputs are pipeline registers relate to forwarding
    input      [4:0] IF_ID_rt,
    input            EX_MEM_reg_write,
    input      [4:0] EX_MEM_rd,
    input            MEM_WB_reg_write,
    input      [4:0] MEM_WB_rd,
    input            cur_branch,
    //input            pre_r_format,
    output  reg[1:0] branch_forward_A,         // ALU operand is from: 00:ID/EX, 10: EX/MEM, 01:MEM/WB
    output  reg[1:0] branch_forward_B
);

     always @(*) begin
        // 初始化前遞信號
        branch_forward_A = 2'b00;
        branch_forward_B = 2'b00;

        // EX hazard
        if (cur_branch && EX_MEM_reg_write && (EX_MEM_rd != 0) && (EX_MEM_rd == IF_ID_rs)) begin
            branch_forward_A = 2'b10;
        end
        if (cur_branch && EX_MEM_reg_write && (EX_MEM_rd != 0) && (EX_MEM_rd == IF_ID_rt)) begin
            branch_forward_B = 2'b10;
        end

        // MEM hazard
        if (cur_branch && MEM_WB_reg_write && (MEM_WB_rd != 0) && (MEM_WB_rd == IF_ID_rs)) begin
            branch_forward_A = 2'b01;
        end
        if (cur_branch && MEM_WB_reg_write && (MEM_WB_rd != 0) && (MEM_WB_rd == IF_ID_rt)) begin
           branch_forward_B = 2'b01;
        end
    end

endmodule

