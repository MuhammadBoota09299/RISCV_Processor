MEMORY
{
    FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 256
    RAM (xrw)   : ORIGIN = 0x00000100, LENGTH = 256
}

SECTIONS
{
    .text :
    {
        *(.text.init)
        *(.text*)
        *(.rodata*)
    } > FLASH

    .data :
    {
        *(.data*)
    } > RAM AT > FLASH

    .bss :
    {
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        __bss_end = .;
    } > RAM
}