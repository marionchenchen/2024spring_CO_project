        .data   0x10008000      # start of Dynamic Data (pointed by $gp)
        .word   0x0             # 0($gp)
        .word   0x1             # 4($gp)
        .word   0x2             # 8($gp)
        .word   0x3             # 12($gp)

        .text   0x00400000      # start of Text (pointed by PC), 
                                # Be careful there might be some other instructions in JsSPIM.
                                # Recommend at least 9 instructions to cover out those other instructions.
main:   lw      $a1, 4($gp)
        lw      $a2, 8($gp)
        lw      $a3, 12($gp)     # Load with the following store
        sw      $a3, 16($gp)    
        add     $t0, $a1, $a2  
        sw      $t0, 20($gp)    # Store instruction following an add (hazard example)
        lw      $a3, 8($gp)     
        beq     $a3, $a2, end   # Branch instruction following a load (hazard example)
        add     $s1, $0, $a1    # will this executed even branch is taken? How about others?
        add     $s2, $0, $a2
        add     $s3, $0, $a3
        add     $s4, $a2, $a2
        add     $s5, $a2, $a3
        add     $s6, $a3, $a3
end:    add     $s7, $s4, $a2   # s7 = 2
