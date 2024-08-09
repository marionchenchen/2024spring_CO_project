`timescale 1ns / 1ps
//111550168

/* checkout FIGURE C.5.10 (Top) */
module bit_alu (
    input            a,          // 1 bit, a
    input            b,          // 1 bit, b
    input            less,       // 1 bit, Less
    input            a_invert,   // 1 bit, Ainvert
    input            b_invert,   // 1 bit, Binvert
    input            carry_in,   // 1 bit, CarryIn
    input      [1:0] operation,  // 2 bit, Operation
    output reg       result,     // 1 bit, Result (Must it be a reg?)
    output           carry_out   // 1 bit, CarryOut
);

    wire ai, bi; 
    assign ai = (a_invert)? ~a:a;  
    assign bi = (b_invert)? ~b:b; 

    wire sum;
    assign carry_out=(bi&carry_in)|(ai&carry_in)|(ai&bi);
    assign sum = (ai&~bi&(~carry_in))|(~ai&~bi&carry_in)|(ai&bi&carry_in)|(~ai&bi&(~carry_in));

    always @(*) begin  // `*` auto captures sensitivity ports, now it's combinational logic
        case (operation)  // `case` is similar to `switch` in C
            2'b00:   result <= ai&bi;  // AND
            2'b01:   result <= ai|bi;  // OR
            2'b10:   result <= sum;  // ADD
            2'b11:   result <= 0; //LESS
            default: result <= 0;  // should not happened
        endcase
    end
endmodule
