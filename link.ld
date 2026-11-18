ENTRY(_reset);

MEMORY {
    flash(rx) : ORIGIN = 0x08000000, LENGTH = 512K
    sram(rwx) : ORIGIN = 0x20000000, LENGTH = 128K
}

_estack = ORIGIN(sram) + LENGTH(sram);

SECTIONS {
    .vectors : {KEEP(*(vectors))} > flash   /* Interrupt vector table */
    .text : {*(.text*)} > flash             /* Holds executable code */
    .rodata : {*(.rodata*)} > flash         /* Read-only data like global constants */

    /*
        data - Data section holds 
    */
    
    .data : {
        _sdata = .;     /* Start of data section */
        *(.first_data)
        *(.data SORT(.data.*))
        _edata = .;      /* End of data section */
    } > sram AT > flash
    _sidata = LOADADDR(.data);

    /* 
        bss - Block starting symbol - contains statically allocated variables that are uninitialized
    */
    
    .bss : {
        _sbss = .;
        *(.bss SORT(.bss.*) COMMON)
        _ebss = .;
    } > sram

    /* Alignment */
    . = ALIGN(8);

    _end = .;
}
