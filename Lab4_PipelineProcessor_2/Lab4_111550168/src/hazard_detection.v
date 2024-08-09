`timescale 1ns / 1ps
// <111550168>

/** [Reading] 4.7 p.372-375
 * Understand when and how to detect stalling caused by data hazards.
 * When read a reg right after it was load from memory,
 * it is impossible to solve the hazard just by forwarding.
 */

/* checkout FIGURE 4.59 to understand why a stall is needed */
/* checkout FIGURE 4.60 for how this unit should be connected */
module hazard_detection (
    input        ID_EX_mem_read,
    input  [4:0] ID_EX_rd, //for load-use hazard
    input  [4:0] IF_ID_rs,
    input  [4:0] IF_ID_rt,
    //input  [31:0] EX_MEM_alu_result,
    input        EX_MEM_mem_read,
    input        cur_branch,
    //input        pre_r_format,
    //input        pre_load,
    output       pc_write,        // only update PC when this is set
    output       IF_ID_write,     // only update IF/ID stage registers when this is set
    output       stall            // insert a stall (bubble) in ID/EX when this is set //set all control signal to zero
);

    // Load-use hazard detection (not for branch)
    wire load_use_hazard;
    assign load_use_hazard = ID_EX_mem_read && ((ID_EX_rd == IF_ID_rs) || (ID_EX_rd == IF_ID_rt));

    // Branch data hazard detection
    wire branch_data_hazard_exe; //lw->beq: first stall
    assign branch_data_hazard_exe = ID_EX_mem_read && cur_branch && ((ID_EX_rd == IF_ID_rs) || (ID_EX_rd == IF_ID_rt));

    wire branch_data_hazard_mem; //lw->beq: second stall, r-format->beq: first stall
    assign branch_data_hazard_mem = EX_MEM_mem_read && cur_branch && ((ID_EX_rd == IF_ID_rs) || (ID_EX_rd == IF_ID_rt));

    // Stall conditions
    wire [1:0] stall_counter;
    assign stall_counter = (load_use_hazard) ? 2'b01 :
                           (branch_data_hazard_exe) ? 2'b01 :
                           (branch_data_hazard_mem) ? 2'b10 : 2'b00;

    // Control signals
    assign pc_write = (stall_counter > 0) ? 1'b0 : 1'b1;
    assign IF_ID_write = (stall_counter > 0) ? 1'b0 : 1'b1;
    assign stall = (stall_counter > 0) ? 1'b1 : 1'b0;


endmodule
