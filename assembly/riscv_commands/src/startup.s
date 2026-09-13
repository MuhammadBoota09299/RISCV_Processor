.section .text.init
.global _start
.type _start, @function

_start:
    /* Initialize stack pointer */
    li sp, 0x80028000
    
    /* Clear BSS section */
    la t0, __bss_start
    la t1, __bss_end
    
clear_bss:
    beq t0, t1, bss_done
    sw zero, 0(t0)
    addi t0, t0, 4
    j clear_bss
    
bss_done:
    /* Call main */
    call main
    
    /* Halt */
    j _start