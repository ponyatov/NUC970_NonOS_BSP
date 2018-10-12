# GNU C/C++ compiler collection build {#gcc}
## for bare metal development on NUC970 processor series

*This part of the BSP project do not officially supported by Nuvoton Technology Corp.*

https://github.com/OpenNuvoton/NUC970_NonOS_BSP/issues/3

### Currently we (Nuvoton) only plan to support Keil development environment  in NUC970 bare bone BSP.

GNU toolchain includes this [packages](@ref packages)

* `binutils`: assembler, linker, ELF and library file tools
* `gcc`: C/C++ compiler
* `gdb`: debugger
* `gprof`: profiler

[Package versions](@ref versions)

## Directories will be used for build & install

@ref dirs :

* `CWD`
	* current directory where `make` was first run
	* (full specified path `/home/user/NUC970_NonOS_BSP/gnu`)
* `GZ=$HOME/gz`
	* archives: directory where `.tar.?z` files resides (toolchain packages source code)
	* if you frequently use [Buildroot](https://buildroot.org/) it is good to share
		all source code in one directory in your home path
* `TMP=/tmp`
	* temp directory for source code unpack and build
	* for most software build in Linux source code directory does not used,
		but *separated build* preferred for most cases out of source tree
* `SRC=/tmp/src`
	* directory for source code unpack
* `SYSROOT=$CWD/sysroot`
	* `sysroot` is a directory where `/include` and `/lib`rary files resides
* `CROSS=$CWD/cross`
	* cross-compiler toolchain will be installed into this directory
	* we will not put builded toolchain system-wide as it traditionally
		can be done in `/usr/local` by defeault: it requires root access
		and will affect all users on a developer workstation
	* inplace we'll install it directly into `NUC970_NonOS_BSP/gnu` directory
		and define special `$XPATH` variable used in all Makefiles to prefix
		cross-compiler `$PATH` before system one

### make dirs

If you want to follow build process step by step manually,
this is a first command creates directory structure
required for build toolchain from source code

```
BSP/gnu$ make -f nuc976.mk dirs
```
Note then you must run it in `BSP/gnu` directory
```
~/BSP/gnu/nuc976.mk
~/BSP/gnu/toolchain.mk

~/BSP/gnu/cross
~/BSP/gnu/sysroot
~/BSP/gz
/tmp
/tmp/src
```

## Download source code packages

```
BSP/gnu$ make -f nuc876.mk gz
```

We'll skip this step assuming you already used BUildroot with `/home/user/gz`
as a directory for its source code archive.
