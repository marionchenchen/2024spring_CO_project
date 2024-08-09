`timescale 1ns / 1ps
// 111550168

/* checkout FIGURE C.5.12 */
/** [Prerequisite] complete bit_alu.v & msb_alu.v
 * We recommend you to design a 32-bit ALU with 1-bit ALU.
 * However, you can still implement ALU with more advanced feature in Verilog.
 * Feel free to code as long as the I/O ports remain the same shape.
 */
module alu (
    input  [31:0] a,        // 32 bits, source 1 (A)
    input  [31:0] b,        // 32 bits, source 2 (B)
    input  [ 3:0] ALU_ctl,  // 4 bits, ALU control input
    output [31:0] result,   // 32 bits, result
    output        zero,     // 1 bit, set to 1 when the output is 0
    output        overflow  // 1 bit, overflow
);
    /* [step 1] instantiate multiple modules */
    /**
     * First, we need wires to expose the I/O of 32 1-bit ALUs.
     * You might wonder if we can declare `operation` by `wire [31:0][1:0]` for better readability.
     * No, that is a feature call "packed array" in "System Verilog" but we are using "Verilog" instead.
     * System Verilog and Verilog are similar to C++ and C by their relationship.
     */
    wire [31:0] less, a_invert, b_invert, carry_in;
    wire [30:0] carry_out;
    wire [63:0] operation;  // flatten vector
    wire        set;  // set of most significant bit
    wire [31:0]temp_result;
    /**
     * Second, we instantiate the less significant 31 1-bit ALUs
     * How are these modules wried?
     */
    bit_alu lsbs[30:0] (
        .a        (a[30:0]),
        .b        (b[30:0]),
        .less     (less[30:0]),
        .a_invert (a_invert[30:0]),
        .b_invert (b_invert[30:0]),
        .carry_in (carry_in[30:0]),
        .operation(operation[61:0]),
        .result   (temp_result[30:0]),
        .carry_out(carry_out[30:0])
    );
    /* Third, we instantiate the most significant 1-bit ALU */
    msb_bit_alu msb (
        .a        (a[31]),
        .b        (b[31]),
        .less     (less[31]),
        .a_invert (a_invert[31]),
        .b_invert (b_invert[31]),
        .carry_in (carry_in[31]),
        .operation(operation[63:62]),
        .result   (temp_result[31]),
        .set      (set),
        .overflow (overflow)
    );

     assign less[31:0]={31'b0,set};
     assign a_invert[31:0]={32{ALU_ctl[3]}};
     assign b_invert[31:0]={32{ALU_ctl[2]}};
     assign carry_in[0]=b_invert[0];
     assign carry_in[31:1]=carry_out[30:0];
     assign operation[63:0]={32{ALU_ctl[1:0]}};

    //slt handle;
    assign result=(ALU_ctl == 4'b0111)? {31'b0,set}: temp_result;

     //assign set=msb.set;
     //assign overflow=msb.overflow;
     assign zero= ~|result;
     

endmodule
