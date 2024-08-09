`timescale 1ns / 1ps
// 111550168

/* checkout FIGURE C.5.10 (Bottom) */

module msb_bit_alu (
    input        a,          // 1 bit, a
    input        b,          // 1 bit, b
    input        less,       // 1 bit, Less
    input        a_invert,   // 1 bit, Ainvert
    input        b_invert,   // 1 bit, Binvert
    input        carry_in,   // 1 bit, CarryIn
    input  [1:0] operation,  // 2 bit, Operation
    output       result,     // 1 bit, Result (Must it be a reg?)
    output       set,        // 1 bit, Set
    output       overflow    // 1 bit, Overflow
);

    wire ai, bi; 
    assign ai = (a_invert)? ~a:a;  
    assign bi = (b_invert)? ~b:b; 
    
    wire sum;
    //wire carry_out;
    //assign carry_out=(bi&carry_in)|(ai&carry_in)|(ai&bi);
    assign sum = (ai&~bi&(~carry_in))|(~ai&~bi&carry_in)|(ai&bi&carry_in)|(~ai&bi&(~carry_in));
    assign overflow=(operation == 2'b11)? 0 :(operation[1]&~operation[0])&((~ai&~bi&sum)|(ai&bi&~sum));


    assign result = (operation == 2'b00) ? (ai & bi) :
               (operation == 2'b01) ? (ai | bi) :
               (operation == 2'b10) ? (sum) :
               (operation == 2'b11) ? (((~ai&~bi&sum)|(ai&bi&~sum))&~sum)|(~((~ai&~bi&sum)|(ai&bi&~sum))&sum) : 
                                       0; 
    assign set = (operation==2'b11)? result:0;

endmodule
