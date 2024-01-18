---
layout: default
title: "Building a toolchain from source"
---

# Building a toolchain from source

This document contains information on building an i386-elf toolchain
from source.  However, these instructions are not likely to work correctly
if your host system compiler is a recent (as of Spring 2024) version of gcc, which is
almost certainly the case if you're using a recent version of Linux
or MacOS. Therefore, rather than building a toolchain from source,
we strongly recommend that you [install a prebuilt toolchain](setup.html#21-install-a-prebuilt-toolchain).
These instructions remain here for posterity.

<div class='admonition danger'>
  <div class='title'>Warning</div>
  <div class='content' markdown='1'>
Like we said, following these instructions is not likely to lead
to a working toolchain. Please either use a ugrad or grad machine
(where prebuilt development tools are available), or install a prebuilt
toolchain [as described in the setup document](setup.html#21-install-a-prebuilt-toolchain).
  </div>
</div>

### 2.1: Test Your Compiler Toolchain

The compiler toolchain is a collection of tools that turns source code
into binary executables for a target architecture. Pintos is written in
C and x86 assembly, and runs on 32-bit x86 machines. So we will need the
appropriate C compiler (`gcc`), assembler (`as`), linker (`ld`),
and debugger (`gdb`).

If you are using a Linux machine, it is likely equipped with the
compiler toolchain already. But it should support 32-bit x86
architecture. A quick test of the support is to run
`objdump -i | grep elf32-i386`
in the terminal. If it returns matching lines, your system's default
tool chain supports the target, **then you can skip Section 2.2**.
Otherwise, you will need to build the toolchain from source.

<div class='admonition caution'>
  <div class='title'>Important</div>
  <div class='content' markdown='1'>
If you are using MacOS, you **have to** either (1) build the toolchain from source
or (2) use a prebuilt toolchain, because MacOS\'s object file format is not ELF
that we need, and the `objdump -i` test won't work. (Also, if your Mac is
has an Apple silicon CPU, the native compiler won't target x86 architecture anyway.)
  </div>
</div>

<div class='admonition caution'>
  <div class='title'>Warning</div>
  <div class='content' markdown='1'>
If you are using Ubuntu 18.04 or later, you might pass the
`objdump -i` test. However, you will likely
encounter an issue later presumably due to a gcc 7 toolchain bug (see
[discussion](https://github.com/ryanphuang/PintosM/issues/1)).
It is recommended that you build the toolchain from source according to
Section 2.2.
  </div>
</div>

<div class='admonition info'>
  <div class='title'>Info</div>
  <div class='content' markdown='1'>
If you are using Ubuntu 16.04, the stock GCC 5.4 should work. If you
don\'t have GCC installed yet, install it with
`sudo apt-get install build-essential gdb gcc-multilib`.
The `objdump -i` test should pass.
  </div>
</div>

### 2.2: Build Toolchain from Source

When you are building the toolchain from source, to distinguish the new
toolchain from your system's default one, you should add a
`i386-elf-` prefix to the build
target, *e.g.*, `i386-elf-gcc`,
`i386-elf-as`.

#### 2.2.1 Prerequisite

- Standard build tools including `make`, `gcc`, etc. To build GDB, you will need the `ncurses` and `texinfo` libraries.

- For Ubuntu, you can install these packages with
  <div class='shell'><pre>sudo apt-get install build-essential automake git libncurses5-dev texinfo</pre></div>

- For macOS, first you should have the command-line tools in Xcode
  installed:
  <div class='shell'><pre>xcode-select --install</pre></div>
  You can then install `ncurses` and `texinfo` with brew:
  <div class='shell'><pre>brew install ncurses texinfo</pre></div>

#### 2.2.2 The Easy Way

<div class='admonition info'>
  <div class='title'>Info</div>
  <div class='content' markdown='1'>
We\'ve provided a
[script](https://github.com/jhu-cs318/pintos/blob/master/src/misc/toolchain-build.sh)
(`pintos/src/misc/toolchain-build.sh`) that
automates the building instructions. So you can just run the script and
modify your PATH setting after the build finishes. The script has been
tested on recent version of Ubuntu, Mac OS and Fedora.
(Spring 2024: this script will probably not actually work on recent versions
of Linux, unfortunately.)
  </div>
</div>

Replace `/path/to/setup` below
with a real path to store the toolchain source and build, e.g.,
`/home/ryan/318/toolchain`; and
replace `/path/to/pintos` with
the real path where you cloned the `pintos` repo, e.g., `~/318/pintos`.

<div class='shell'><pre>SWD=/path/to/setup
mkdir -p $SWD
cd /path/to/pintos
src/misc/toolchain-build.sh $SWD</pre></div>

If the above commands succeeded, add the toolchain path to your PATH environment
variable settings in the `.bashrc` (or `.zshrc` if you are using zsh) file in
your home directory.

<div class='shell'><pre>export PATH=$SWD/x86_64/bin:$PATH</pre></div>

Don't forget to replace the `$SWD` above with the real path, e.g.,
`export PATH=/home/ryan/318/toolchain/x86_64/bin:$PATH`.

**For the Hardcores**:

If you are curious to build the toolchain manually, below are the
detailed instructions.

1.  Directory and environment variables:
    -   Create a setup directory (e.g.,
        `~/318/toolchain`) and subdirectories that
        look like this:
        ```
        /path/to/setup
        ├── build
        ├── x86_64
        └── src
        ```

    -   Set the environment variables (remember to replace
        `/path/to/setup` with the *full path* to the
        actual setup directory you've created, e.g.,
        `SWD=/home/ryan/318/toolchain`).
        <div class='shell'><pre>SWD=/path/to/setup
PREFIX=$SWD/x86_64
export PATH=$PREFIX/bin:$PATH
export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH</pre></div>

        For Mac users, the last command is
        <div class='shell'><pre>export DYLD_LIBRARY_PATH=$PREFIX/lib:$DYLD_LIBRARY_PATH</pre></div>
        instead.

2.  GNU binutils:
    -   **Download**:
        <div class='shell'><pre>cd $SWD/src 
wget https://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.gz && tar xzf binutils-2.27.tar.gz</pre></div>
    -   **Build**:
        <div class='shell'><pre>mkdir -p $SWD/build/binutils && cd $SWD/build/binutils
../../src/binutils-2.27/configure --prefix=$PREFIX --target=i386-elf --disable-multilib --disable-nls --disable-werror
make -j8
make install</pre></div>

3.  GCC:
    -   **Download**:
        <div class='shell'><pre>cd $SWD/src
wget https://ftp.gnu.org/gnu/gcc/gcc-6.2.0/gcc-6.2.0.tar.bz2 && tar xjf gcc-6.2.0.tar.bz2
cd $SWD/src/gcc-6.2.0 && contrib/download_prerequisites</pre></div>
    -   **Build**:
        <div class='shell'><pre>mkdir -p $SWD/build/gcc && cd $SWD/build/gcc
../../src/gcc-6.2.0/configure --prefix=$PREFIX --target=i386-elf --disable-multilib --disable-nls --disable-werror --disable-libssp --disable-libmudflap --with-newlib --without-headers --enable-languages=c,c++
make -j8 all-gcc 
make install-gcc
make all-target-libgcc
make install-target-libgcc</pre></div>

4.  GDB:
    -   **Download**:
        <div class='shell'><pre>cd $SWD/src
wget https://ftp.gnu.org/gnu/gdb/gdb-7.9.1.tar.xz  && tar xJf gdb-7.9.1.tar.xz</pre></div>
    -   **Build**:
        <div class='shell'><pre>mkdir -p $SWD/build/gdb && cd $SWD/build/gdb
../../src/gdb-7.9.1/configure --prefix=$PREFIX --target=i386-elf --disable-werror
make -j8
make install</pre></div>

<div class='admonition caution'>
  <div class='title'>Note</div>
  <div class='content' markdown='1'>
If you are using macOS and the above compilation failed. It might be
caused by changes in the latest gcc or libraries on macOS. You can post
the errors in the discussion forum. We will investigate. In the
meantime, you can try to directly use our pre-built toolchain binaries
by following instructions in this
[README](https://github.com/jhu-cs318/cross-compiler-toolchain).
(Spring 2024: please just install the prebuilt toolchain.)
  </div>
</div>

#### 2.2.3 Verify Installation {#223-verify-installation}

Now check if the toolchain has been installed to the proper place and
the version is `6.2.0`:

<div class='shell'><pre>
which i386-elf-gcc
i386-elf-gcc --version</pre></div>

<div class='admonition tip'>
  <div class='title'>Tip</div>
  <div class='content' markdown='1'>
If you see the `command not found` error message, check if you have
added `export PATH=$SWD/x86_64/bin:$PATH`{.highlighter-rogue} to your
`.bashrc` or `.zshrc` (depending on your shell `echo $SHELL`). If so,
you may need to restart your terminal for the new `PATH` to take effect.

After successfully building the toolchain, you may delete the source and
build directories in `$SWD/{src,build}` to save space.
  </div>
</div>
