---
layout: default
title: "Assignment 1 source files"
---

# [Assignment 1](../assign01.html) Source Files

"`loader.S`"

:   

"`loader.h`"
:   The kernel loader. Assembles to 512 bytes of code and data that the
    PC BIOS loads into memory and which in turn finds the kernel on
    disk, loads it into memory, and jumps to `start()` in "`start.S`".
    See section [A.1.1 The Loader](pintos/pintos_7.html#SEC103), for details.
    You should not need to look at this code or modify it.

"`start.S`"
:   Does basic setup needed for memory protection and 32-bit operation
    on 80`x`{.variable}86 CPUs. Unlike the loader, this code is actually
    part of the kernel. See section [A.1.2 Low-Level Kernel
    Initialization](pintos/pintos_7.html#SEC104), for details.

"`kernel.lds.S`"
:   The linker script used to link the kernel. Sets the load address of
    the kernel and arranges for "`start.S`" to be near the beginning of
    the kernel image. See section [A.1.1 The
    Loader](pintos/pintos_7.html#SEC103), for details. Again, you should not
    need to look at this code or modify it, but it\'s here in case
    you\'re curious.

"`init.c`"

:   

"`init.h`"
:   Kernel initialization, including `main()`, the kernel\'s \"main
    program.\" You should look over `main()` at least to see what gets
    initialized. You might want to add your own initialization code
    here. See section [A.1.3 High-Level Kernel
    Initialization](pintos/pintos_7.html#SEC105), for details.

"`thread.c`"

:   

"`thread.h`"
:   Basic thread support. Much of your work will take place in these
    files. "`thread.h`" defines `struct thread`, which you are likely to
    modify in all four projects. See [A.2.1
    `struct thread`](pintos/pintos_7.html#SEC108) and [A.2
    Threads](pintos/pintos_7.html#SEC107) for more information.

"`switch.S`"

:   

"`switch.h`"
:   Assembly language routine for switching threads. Already discussed
    above. See section [A.2.2 Thread Functions](pintos/pintos_7.html#SEC109),
    for more information.

"`palloc.c`"

:   

"`palloc.h`"
:   Page allocator, which hands out system memory in multiples of 4 kB
    pages. See section [A.5.1 Page Allocator](pintos/pintos_7.html#SEC123), for
    more information.

"`malloc.c`"

:   

"`malloc.h`"
:   A simple implementation of `malloc()` and `free()` for the kernel.
    See section [A.5.2 Block Allocator](pintos/pintos_7.html#SEC124), for more
    information.

"`interrupt.c`"

:   

"`interrupt.h`"
:   Basic interrupt handling and functions for turning interrupts on and
    off. See section [A.4 Interrupt Handling](pintos/pintos_7.html#SEC118), for
    more information.

"`intr-stubs.S`"

:   

"`intr-stubs.h`"
:   Assembly code for low-level interrupt handling. See section [A.4.1
    Interrupt Infrastructure](pintos/pintos_7.html#SEC119), for more
    information.

"`synch.c`"

:   

"`synch.h`"
:   Basic synchronization primitives: semaphores, locks, condition
    variables, and optimization barriers. You will need to use these for
    synchronization in all four projects. See section [A.3
    Synchronization](pintos/pintos_7.html#SEC111), for more information.

"`io.h`"
:   Functions for I/O port access. This is mostly used by source code in
    the "`devices`" directory that you won\'t have to touch.

"`vaddr.h`"

:   

"`pte.h`"
:   Functions and macros for working with virtual addresses and page
    table entries. These will be more important to you in project 3. For
    now, you can ignore them.

"`flags.h`"
:   Macros that define a few bits in the 80`x`{.variable}86 \"flags\"
    register. Probably of no interest. See \[
    [IA32-v1](pintos/pintos_14.html#IA32-v1)\], section 3.4.3, \"EFLAGS
    Register,\" for more information.

## "`devices`" code

The basic threaded kernel also includes these files in the "`devices`"
directory:

"`timer.c`"

:   

"`timer.h`"
:   System timer that ticks, by default, 100 times per second. You will
    modify this code in this project.

"`vga.c`"

:   

"`vga.h`"
:   VGA display driver. Responsible for writing text to the screen. You
    should have no need to look at this code. `printf()` calls into the
    VGA display driver for you, so there\'s little reason to call this
    code yourself.

"`serial.c`"

:   

"`serial.h`"
:   Serial port driver. Again, `printf()` calls this code for you, so
    you don\'t need to do so yourself. It handles serial input by
    passing it to the input layer (see below).

"`block.c`"

:   

"`block.h`"
:   An abstraction layer for *block devices*, that is, random-access,
    disk-like devices that are organized as arrays of fixed-size blocks.
    Out of the box, Pintos supports two types of block devices: IDE
    disks and partitions. Block devices, regardless of type, won\'t
    actually be used until project 2.

"`ide.c`"

:   

"`ide.h`"
:   Supports reading and writing sectors on up to 4 IDE disks.

"`partition.c`"

:   

"`partition.h`"
:   Understands the structure of partitions on disks, allowing a single
    disk to be carved up into multiple regions (partitions) for
    independent use.

"`kbd.c`"

:   

"`kbd.h`"
:   Keyboard driver. Handles keystrokes passing them to the input layer
    (see below).

"`input.c`"

:   

"`input.h`"
:   Input layer. Queues input characters passed along by the keyboard or
    serial drivers.

"`intq.c`"

:   

"`intq.h`"
:   Interrupt queue, for managing a circular queue that both kernel
    threads and interrupt handlers want to access. Used by the keyboard
    and serial drivers.

"`rtc.c`"

:   

"`rtc.h`"
:   Real-time clock driver, to enable the kernel to determine the
    current date and time. By default, this is only used by
    "`thread/init.c`" to choose an initial seed for the random number
    generator.

"`speaker.c`"

:   

"`speaker.h`"
:   Driver that can produce tones on the PC speaker.

"`pit.c`"

:   

"`pit.h`"
:   Code to configure the 8254 Programmable Interrupt Timer. This code
    is used by both "`devices/timer.c`" and "`devices/speaker.c`"
    because each device uses one of the PIT\'s output channel.

## "`lib`" files

Finally, "`lib`" and "`lib/kernel`" contain useful library routines.
("`lib/user`" will be used by user programs, starting in project 2, but
it is not part of the kernel.) Here\'s a few more details:

"`ctype.h`"

:   

"`inttypes.h`"

:   

"`limits.h`"

:   

"`stdarg.h`"

:   

"`stdbool.h`"

:   

"`stddef.h`"

:   

"`stdint.h`"

:   

"`stdio.c`"

:   

"`stdio.h`"

:   

"`stdlib.c`"

:   

"`stdlib.h`"

:   

"`string.c`"

:   

"`string.h`"
:   A subset of the standard C library. See section [C.2
    C99](pintos/pintos_9.html#SEC151), for information on a few recently
    introduced pieces of the C library that you might not have
    encountered before. See section [C.3 Unsafe String
    Functions](pintos/pintos_9.html#SEC152), for information on what\'s been
    intentionally left out for safety.

"`debug.c`"

:   

"`debug.h`"
:   Functions and macros to aid debugging. See section [E. Debugging
    Tools](pintos/pintos_11.html#SEC156), for more information.

"`random.c`"

:   

"`random.h`"
:   Pseudo-random number generator. The actual sequence of random values
    will not vary from one Pintos run to another, unless you do one of
    three things: specify a new random seed value on the
    "`-rs`{.sample}" kernel command-line option on each run, or use a
    simulator other than Bochs, or specify the "`-r`{.sample}" option to
    `pintos`.

"`round.h`"
:   Macros for rounding.

"`syscall-nr.h`"
:   System call numbers. Not used until project 2.

"`kernel/list.c`"

:   

"`kernel/list.h`"
:   Doubly linked list implementation. Used all over the Pintos code,
    and you\'ll probably want to use it a few places yourself in project
    1.

"`kernel/bitmap.c`"

:   

"`kernel/bitmap.h`"
:   Bitmap implementation. You can use this in your code if you like,
    but you probably won\'t have any need for it in project 1.

"`kernel/hash.c`"

:   

"`kernel/hash.h`"
:   Hash table implementation. Likely to come in handy for project 3.

"`kernel/console.c`"

:   

"`kernel/console.h`"

:   

"`kernel/stdio.h`"
:   Implements `printf()` and a few other functions.
