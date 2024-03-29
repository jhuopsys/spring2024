---
layout: default
title: "Setup Instructions"
---

# Setup Instructions

To develop the Pintos projects, you'll need two essential sets of tools:

- 80x86 cross-compiler toolchain for 32-bit architecture including a C
  compiler, assembler, linker, and debugger.
- x86 emulator, QEMU or Bochs

This page contains instructions to help you with the setup of the core
development environment needed for Pintos on your own machines. They are
intended for Unix and Mac OS machines. If you are running Windows, we
recommend you to run a virtual machine with Linux or you will have to
setup [Cygwin](http://www.cygwin.com) first. This guide, and the course
in general, assumes you are familiar with Unix commands.

## Getting Started

To get started, you need to clone the [Pintos repository](https://github.com/jhu-cs318/pintos)
we provided.

<div class='shell'><pre>
git clone https://github.com/jhu-cs318/pintos.git
</pre></div>

## 1. Development Environment

### Option A: JHU CS Lab Machine

The CS department's [lab
machines](https://support.cs.jhu.edu/wiki/Category:Linux_Clients)
already have these tools available under
`/usr/local/data/cs318/x86_64`.
You just need to modify your PATH setting to include it.

- See what shell you are using with `echo $SHELL`.
- For Bash, that is to put the following at the end of your
  `~/.bash_profile`:
  <div class='shell'><pre>export PATH=/usr/local/data/cs318/x86_64/bin:$PATH </pre></div>
- For tcsh, the syntax is different: add
  `set path = (/usr/local/data/cs318/x86_64/bin $path)` to the end of your
  `~/.tcshrc`. Log out and
  re-login to let it take effect.

If you are using macOS to connect to the CS Lab machine, you should
install [XQuartz](https://www.xquartz.org), so that you can get GUI
windows to show up locally in your macOS for the exercise 0.1 in [Lab
0](project/project0.html).

Choosing option A, you do **NOT** need to follow steps 2-4 below.

### Option B: Your Own Machine

Besides the lab machines, you may want to work on the projects on your
own laptop/desktop to be more productive.

- If you computer runs Linux, it is the perfect development
  environment for Pintos. In terms of suitable Linux distributions,
  Ubuntu 22.04 is what we use. But you may also try other
  distributions like Ubuntu 20.04 or Fedora.
- If your computer runs macOS, it should work too. You have two
  choices: (i) follow step 2 below to build the toolchain, so you can
  later compile Pintos natively on macOS; (ii) install a Linux virtual
  machine (VM). The first choice is recommended because native
  compilation is faster, but feel free to go with the second choice.
- If you are using a Windows machine, however, we recommend you to
  install a Linux virtual machine.

<div class='admonition info'>
  <div class='title'>Info</div>
  <div class='content' markdown='1'>
For virtual-machine-based development, you can choose our pre-built
[VirtualBox](https://www.virtualbox.org) VM running Ubuntu 18.04 with
the necessary toolchain installed. The VM image is available
[here](https://bit.ly/3j9Elp4). The image is large (2.5 GB), so the
downloading can take a while. The md5sum for the VM image is
`69c89938d4b768bdcca4362fd39f06e4`. The initial login password is
`jhucs318`.
  </div>
</div>

<div class='admonition info'>
  <div class='title'>Info</div>
  <div class='content' markdown='1'>
If you would like to build/use your own virtual machine,
[Vagrant](https://www.vagrantup.com/) is a popular tool to make VM-based
development environment convenient. We have provided a [Vagrant
configuration](https://github.com/jhu-cs318/vagrant) that you can use to
set up your Pintos dev box.
  </div>
</div>

<div class='admonition info'>
  <div class='title'>Info</div>
  <div class='content' markdown='1'>
Unless you are using our pre-built VM, you have to follow steps 2-4
below to install the compiler toolchain, the emulator, and the Pintos
utility tools.
  </div>
</div>

## 2. Compiler Toolchain

You will need a compiler toolchain that can target the `i386-elf` architecture.

### 2.1 Install a prebuilt toolchain

If you are using Linux or MacOS, we recommend that you download and install a prebuilt
compiler toolchain. To do so, visit the following link and follow the instructions:

> <https://github.com/jhu-cs318/cross-compiler-toolchain>

Note that you should click on the "Pre-built toolchain binaries" link
under "Releases" on the right-hand side of the page in order to
get access to the toolchain download files.

<div class='admonition info'>
  <div class='title'>Info</div>
  <div class='content' markdown='1'>
On Linux, the binaries in the prebuilt toolchain may require shared libraries
that you don't have installed. On Ubuntu 22.04, you can install them with the command
<div class='shell'><pre>sudo apt install libncurses5 libpython2.7</pre></div>
  </div>
</div>

### 2.2 Build a toolchain from source

In theory you could compile the toolchain from source code.
The [Building a toolchain from source](build_toolchain.html) document has
instructions for doing so. **However**, these instructions are not
likely to work using recent versions of gcc, so we don't recommend
trying this.

## 3. Emulator

Besides the cross-compiler toolchain, we also need an x86 emulator to
run Pintos OS. We will use two popular emulators QEMU and Bochs.

### 3.1 QEMU

- QEMU is modern and fast. To install it:
  -   For Ubuntu: `sudo apt-get install qemu`
  -   For MacOS: `brew install qemu`
  -   Other: build it from [source](https://www.qemu.org/download/)

<div class='admonition info'>
  <div class='title'>Info</div>
  <div class='content' markdown='1'>
Recent versions of Ubuntu have a QEMU package that should work well
for Pintos. You can install QEMU with all supported architectures
(including x86) with the command
<div class='shell'><pre>sudo apt install qemu-system</pre></div>
  </div>
</div>

### 3.2 Bochs

- Bochs is slower than QEMU but provides full emulation (i.e., higher
  accuracy).
- For Lab 1, we will use Bochs as the default emulator and *for Lab
  2-4, we will use QEMU as the default emulator*. Nevertheless,
  nothing will prevent you from using one or another for all the labs.
- There are some bugs in Bochs that should be fixed when using it with
  Pintos. Thus, we need to install Bochs from source, and apply the
  patches that we have provided under
  `pintos/src/misc/bochs*.patch`. We will build two versions of Bochs: one,
  simply named `bochs`, with
  the GDB stub enabled, and the other, named
  `bochs-dbg`, with the
  built-in debugger enabled.
- Version **2.6.2** (note: not 2.2.6) has been tested to work with
  Pintos. Newer versions of Bochs have not been tested.
  (Update Spring 2024: Bochs 2.7 and later indeed do not appear to
  work correctly with Pintos.)
  <div class='admonition info'>
   <div class='title'>Note</div>
   <div class='content' markdown='1'>
  We have provided a build script `pintos/src/misc/bochs-2.6.2-build.sh`
  that will download, patch and build two versions of the Bochs for you.
  But you need to make sure X11 and its library is installed.
  
    - For Mac OS, you should install [XQuartz](https://www.xquartz.org)
      **2.7.11** ([here](https://www.xquartz.org/releases/index.html)).
      Note: bochs build does not work with XQuartz version 2.8.x. Later
      XQuartz might prompt you to upgrade to 2.8.x, please do not upgrade
      it!
    - For Ubuntu,
      `sudo apt-get install libx11-dev libxrandr-dev`

    Spring 2024 note: this script does appear to work correctly and should
    yield you a functioning installation of Bochs.
   </div>
  </div>
  (`$SWD` should be set previously, e.g., `/home/ryan/318/toolchain`)
<div class='shell'><pre>src/misc/bochs-2.6.2-build.sh $SWD/x86_64</pre></div>
- After build succeeds, make sure the `bochs` or `bochs-db` are in PATH.
  You can verify the install with `bochs -h`. The output should contain `2.6.2`.

<div class='admonition caution'>
  <div class='title'>Reminder</div>
  <div class='content' markdown='1'>
To reiterate, if you are using macOS, you should install XQuartz
**2.7.11** and **do not upgrade it to higher version!**. Otherwise, the
bochs build will fail.
  </div>
</div>

## 4. Pintos Utility Tools

The Pintos source distribution comes with a few handy scripts that you
will be using frequently. They are located within
`src/utils/`. The most important one is the `pintos` Perl script,
which you will be using to start and run tests in pintos. You need to
make sure it can be found in your PATH environment variable. In
addition, the `src/misc/gdb-macros` is provided with a number of GDB macros that you
will find useful when you are debugging Pintos. The
`pintos-gdb` is a wrapper around the `i386-elf-gdb` that reads
this macro file at start. It assumes the macro file resides in
`../misc`.

The commands to do the above setup for the Pintos utilities are: (make
sure `SWD` is set previously to the correct directory path)

<div class='shell'><pre>
dest=$SWD/x86_64
cd pintos/src/utils && make
cp backtrace pintos Pintos.pm pintos-gdb pintos-set-cmdline pintos-mkdisk setitimer-helper squish-pty squish-unix $dest/bin
mkdir $dest/misc
cp ../misc/gdb-macros $dest/misc
</pre></div>

## 5. Others

- Required: [Perl](http://www.perl.org). Version 5.8.0 or later.
- Recommended:
  -   [cgdb](https://cgdb.github.io) (**strongly recommended**)
      -   For Ubuntu, `sudo apt-get install cgdb`; For macOS,
          `brew install cgdb`.
      -   Once you installed cgdb, the `pintos-gdb` script
          would [use](https://github.com/jhu-cs318/pintos/blob/master/src/utils/pintos-gdb#L16)
          cgdb to invoke GDB.
  -   [ctags](http://ctags.sourceforge.net/)
  -   [cscope](http://cscope.sourceforge.net/)
  -   [NERDTree](https://github.com/scrooloose/nerdtree)
  -   [YouCompleteMe](https://github.com/Valloric/YouCompleteMe).
- Optional:
  -   GUI IDEs like [Eclipse CDT](https://eclipse.org/cdt) or
      [clion](http://www.jetbrains.com/clion). The instructor has not
      tried them. Vim or Emacs plus the standard Unix development
      tools would suffice for the course. But if you can't live
      without GUI IDEs. You may explore the setup yourself (potential
      [reference](https://uchicago-cs.github.io/mpcs52030/pintos_eclipse.html))
      and let us know if they are helpful!

### Happy hacking :)
