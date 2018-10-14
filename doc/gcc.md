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

## Configuration

Source build of every package is managed by autotools, which generates special
`configure` script resides in every source code package.

Every `make package` command 
* extracts source to `$SRC/packagename-version`directory, 
* runs `configure` in out-of-tree build directory in `$TMP/packagename-version`
* and finally run long `$MAKE` process which build package and installs it in `$CROSS`

To control every package confgiguration we use `$CFG_PACKAGE` variables

* `CFG_ALL` will be the first argument for `configure`
	* `--disable-nls`
		* switch off cross-compiler localization: 
			all messages will be in english only
	* `--prefix=$CROSS`
		* setup installation directory for all packages

## binutils: assembler, linker and object file tools

* `CFG_BINUTILS`
	* `--with-sysroot=$SYSROOT`
		* setup `$SYSROOT` directory which will contain 
			`/include` and `/lib`rary files (some include files will reside
			in gcc installation)
	* `--with-native-system-header-dir=/include`
		* set system `/include` directory *relative to sysroot*
	* `--enable-lto`
	* `--target=$TARGET`
			* select target system architecture by triplet
	* `$CFG_CPU`
			* provide flags specific for concrete $CPU you want to use

`$TARGET` and `$CPU` **must be configured before `toolchain.mk` will be run**, so we use

```nuc976.mk

ARCH	= arm
CPU		= arm926ej-s
TARGET	= $(ARCH)-none-eabi

CFG_CPU	= --with-cpu=$(CPU)

-include toolchain.mk
```

Run build command:

```
BSP/gnu$ make -f nuc976.mk binutils
```

Make target first tests is source code ready:

```toolchain.mk
binutils: $(SRC)/$(BINUTILS)/configure
```

### Source code unpack

All *makefile targets* makes packet build *uses automatic dependency resolving*:
* package build requires source code unpacked
* to unpack source code we need downloaded `.tar.xz` in `$GZ`
* if we have no source code archive, we `$WGET` it (see `make gz` above)

```
$(SRC)/$(BINUTILS)/configure: $(GZ)/binutils/$(BINUTILS_GZ)
	cd $(SRC) ; xzcat $< | tar x && touch $@
```

When you run any package build it will first unpack source to `$SRC`:

```
BSP/gnu$  make -f nuc976.mk binutils
cd /tmp/src ; xzcat /home/dpon/gz/binutils/binutils-2.29.1.tar.xz | tar x && touch /tmp/src/binutils-2.29.1/configure
```

### Package build: makefile section structure

```
[1] .PHONY: binutils
[2] binutils: $(SRC)/$(BINUTILS)/configure [3]
[4]	rm -rf $(TMP)/binutils ; mkdir $(TMP)/binutils ; cd $(TMP)/binutils ;\	[5]
		$(XPATH) $< $(CFG_ALL) $(CFG_BINUTILS) &&\ 							[6]
			$(MAKE) -j4 &&\						    						[7]
			 $(MAKE) install												[8]
```

1. declare that this *make targets* is not files, but just a names:
	* `make` tool will not check filesystem for this names 
	to find what files were updated,
	and what files must be rebuilt by dependency

2. `make` *targets*
	* all file names (targets) in left side of a *make rule* point on files
		which should be rebuilt...
3. `make` *sources*
	* ...if any file in sources list changed
4. make rule body must be padded with `TAB` symbols, no spaces
	* make rule body contains generic OS commands must be run for targets update
	* In make rule commands you can substitute sources and tagets using pseudovariables:
		* `$<` first source name
		* `$^` full sources list splitted by spaces
		* `$?` only changed sources list
		* `$@` target name
5. (re)create empty directory for out-of-tree build
6. run source package `configure` creates set of script files will be run build itself
7. `make` in parallel with `-jN`
	(N can be equal to number of processor cores on your workstation desktop)
8. install builded package into `$CROSS` (`--prefix`)

## libs0: support libraries required for GCC build

For gcc build we require a set of support libraries. We can rely on `libxxx-dev`
packages provided by your Linux distribution, but for devkit portability we'll
build them from sources like a part of this toolchain build.

@dot
digraph {
	rankdir=LR;
	gmp -> mpfr -> mpc;
	gmp -> isl;
	gmp -> gcc;
	mpfr -> gcc;
	mpc -> gcc;
	isl -> gcc [label=optional];
	{rank=same; gmp; isl; }
}
@enddot

* `gmp`
* `mpfr` <- `gmp`
* `mpc` <-  `mpfr`
* `isl` <- `gmp`
	* loop optimizations

```
BSP/gnu$ make -f nuc976.mk libs0
```

## gcc0: standalone C compiler for libc build

On first stage we need minimal C compiler with all features disabled, able
to build code without use of standard C library (libc).

gcc has deep bound with libc, so to build libc we need standalone gcc

`CFG_GCC0`
* `--enable-languages="c"`
	* we need only pure C for `libc` build
	* C++ can be added only after `libc` will be available
		(dynamic memory management and multiprocessing required for C++ runtime)
* `--without-headers --with-newlib`
	* disables libc usage for programs build
* `--disable-shared --disable-threads`
	* switch off features can't be used w/o libc

```
gcc0: $(SRC)/$(GCC)/configure												[1]
	rm -rf $(TMP)/gcc ; mkdir $(TMP)/gcc ; cd $(TMP)/gcc ;\					[2]
		$(XPATH) $< $(CFG_ALL) $(CFG_GCC0) &&\								[3]
			$(MAKE) -j4 all-gcc && $(MAKE) install-gcc &&\					[4]
			$(MAKE) -j4 all-target-libgcc && $(MAKE) install-target-libgcc	[5]
```
1. package : source code
2. out of tree build directory
3. configure
4. build & install only gcc core
5. build & install only `libgcc`

```
BSP/gnu$ make -f nuc976.mk gcc0
```

## `gdb`: GNU debugger

We need it for @ref gdb

```
BSP/gnu$ make -f nuc976.mk gdb
```

## clean up after toolchain build

After toolchain build we have a lot of temporary files, so ant end of the process
we must do @ref clean

```
BSP/gnu$ make -f nuc976.mk clean
```

