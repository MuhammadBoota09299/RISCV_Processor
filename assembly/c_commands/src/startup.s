.section .text.init
.global _start
.type _start, @function

_start:
    /* Initialize stack pointer */
    /* Set SP to top of RAM: RAM origin 0x00000100 + 256 bytes-1 = 0x00000200-1 */
    li sp, 0x000001ff
    
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