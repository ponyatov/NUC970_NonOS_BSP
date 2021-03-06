## @file
## @brief shared makefile for GNU toolchain build

# this vars must be defined:

#CPU	  = arm926ej-s
#HW		  = none
#ARCH	  = arm
#TARGET	  = $(ARCH)-$(HW)-eabi
#CFG_CPU += --with-cpu=$(CPU)

## @defgroup gnu GNU toolchain
## @{

## @defgroup versions package versions
## @{

BINUTILS_VER	= 2.31.1
# 2.29.1
GCC_VER			= 8.2.0
# 7.3.0
GDB_VER			= 8.2
# 7.11.1

## @defgroup libversions support libs
## @{

GMP_VER			= 6.1.0
MPFR_VER		= 3.1.4
MPC_VER			= 1.0.3
ISL_VER			= 0.18

## @}

## @}

## @defgroup packages toolchain packages
## @{

## @brief assembler, linker, ELF and library file tools
BINUTILS		= binutils-$(BINUTILS_VER)

## @brief C/C++ compiler
GCC				= gcc-$(GCC_VER)

## @brief debugger
GDB				= gdb-$(GDB_VER)

## @defgroup libpackages libs
## @{

GMP				= gmp-$(GMP_VER)
MPFR			= mpfr-$(MPFR_VER)
MPC				= mpc-$(MPC_VER)
ISL				= isl-$(ISL_VER)

## @}

## @}

## @defgroup srcgz source archives
## @{

BINUTILS_GZ		= $(BINUTILS).tar.xz
GCC_GZ			= $(GCC).tar.xz
GDB_GZ			= $(GDB).tar.xz

## @defgroup gzpackages libs
## @{

GMP_GZ			= $(GMP).tar.bz2
MPFR_GZ			= $(MPFR).tar.bz2
MPC_GZ			= $(MPC).tar.gz
ISL_GZ			= $(ISL).tar.bz2

## @}

## @}

## @defgroup dirs directories for build and install
## @brief `make dirs`
## @{

## @brief current directory where `make` was first run
CWD		= $(CURDIR)

## @brief archives: directory where `.tar.?z` files resides (toolchain packages source code)
GZ		= $(HOME)/gz

## @brief temp directory for source code unpack and build
TMP		= /tmp

## @brief directory for source code unpack
SRC		= $(TMP)/src

## @brief `sysroot` is a directory where include and library files resides
SYSROOT	= $(CWD)/sysroot

## @brief cross-compiler toolchain will be installed into this directory
CROSS	= $(CWD)/cross

# make directories
.PHONY: dirs
dirs:
	mkdir -p $(GZ) $(TMP) $(SRC) $(SYSROOT) $(CROSS)

## @}

## @defgroup cfg configure variables
## @{

## @brief variable prefixes all commands to prefix cross-compiler `$PATH` before system one
XPATH			= PATH=$(CROSS)/bin:$(PATH)

## @brief this will be the first argument for `configure`
CFG_ALL 		= --disable-nls --prefix=$(CROSS)

## @brief debugger options
GDB_CFG			= $(BINUTILS_CFG)

## @}

## @defgroup bintuils bintuils build
## @brief `make binutils`
## @{

## @brief binutils options for bare-metal build
CFG_BINUTILS	= --with-sysroot=$(SYSROOT) --with-native-system-header-dir=/include \
				  --enable-lto --target=$(TARGET) $(CFG_CPU)

.PHONY: binutils
binutils: $(SRC)/$(BINUTILS)/configure
	rm -rf $(TMP)/$@ ; mkdir $(TMP)/$@ ; cd $(TMP)/$@ ;\
		$(XPATH) $< $(CFG_ALL) $(CFG_BINUTILS) &&\
			$(MAKE) -j4 && $(MAKE) install-strip

## @}

## @defgroup gcc0 standalone C compiler for libc build
## @brief `make gcc0`
## @{

## @brief support libs configuration for `gcc[0]`
CFG_WITH_LIBS	= --with-gmp=$(CROSS) --with-mpfr=$(CROSS) --with-mpc=$(CROSS) \
				  --with-isl=$(CROSS)

## @brief gcc options for bare-metal build (for cross libc build)
CFG_GCC0		= $(CFG_BINUTILS) $(CFG_WITH_LIBS) --enable-languages="c" \
					--disable-shared --disable-threads \
					--without-headers --with-newlib

.PHONY: gcc0
gcc0: $(SRC)/$(GCC)/configure
	rm -rf $(TMP)/$@ ; mkdir $(TMP)/$@ ; cd $(TMP)/$@ ;\
		$(XPATH) $< $(CFG_ALL) $(CFG_GCC0) &&\
			$(MAKE) -j4 all-gcc && $(MAKE) install-gcc &&\
			$(MAKE) -j4 all-target-libgcc && $(MAKE) install-target-libgcc

## @}

## @defgroup gdb GNU debugger
## @brief `make gdb`
## @{

## @brief configure gdb build for specific target
CFG_GDB			= $(CFG_BINUTILS)

.PHONY: gdb
gdb: $(SRC)/$(GDB)/configure
	rm -rf $(TMP)/$@ ; mkdir $(TMP)/$@ ; cd $(TMP)/$@ ;\
		$(XPATH) $< $(CFG_ALL) $(CFG_GDB) &&\
			$(MAKE) -j4 && $(MAKE) install

## @}

## @defgroup libs libraries required for gcc build
## @brief `make libs0 [ gcc0 mpfr0 mpc0 isl0 ]`
## @{

## @brief options for all libs0
CFG_LIBS	= --disable-shared $(CFG_WITH_LIBS)

CFG_GMP		= $(CFG_LIBS)
CFG_MPFR	= $(CFG_LIBS)
CFG_MPC		= $(CFG_LIBS)
CFG_ISL		= --disable-shared --with-gmp-prefix=$(CROSS) 

.PHONY: libs0
libs0: gmp0 mpfr0 mpc0 isl0

.PHONY: gmp0
gmp0: $(SRC)/$(GMP)/configure
	rm -rf $(TMP)/$@ ; mkdir $(TMP)/$@ ; cd $(TMP)/$@ ;\
		$(XPATH) $< $(CFG_ALL) $(CFG_GMP) &&\
			$(MAKE) -j4 && $(MAKE) install-strip

.PHONY: mpfr0
mpfr0: $(SRC)/$(MPFR)/configure
	rm -rf $(TMP)/$@ ; mkdir $(TMP)/$@ ; cd $(TMP)/$@ ;\
		$(XPATH) $< $(CFG_ALL) $(CFG_MPFR) &&\
			$(MAKE) -j4 && $(MAKE) install-strip

.PHONY: mpc0
mpc0: $(SRC)/$(MPC)/configure
	rm -rf $(TMP)/$@ ; mkdir $(TMP)/$@ ; cd $(TMP)/$@ ;\
		$(XPATH) $< $(CFG_ALL) $(CFG_MPC) &&\
			$(MAKE) -j4 && $(MAKE) install-strip

.PHONY: isl0
isl0: $(SRC)/$(ISL)/configure
	rm -rf $(TMP)/$@ ; mkdir $(TMP)/$@ ; cd $(TMP)/$@ ;\
		$(XPATH) $< $(CFG_ALL) $(CFG_ISL) &&\
			$(MAKE) -j4 && $(MAKE) install-strip

## @}

## @defgroup src unpack source code
## @{

$(SRC)/$(BINUTILS)/configure: $(GZ)/binutils/$(BINUTILS_GZ)
	cd $(SRC) ; xzcat $< | tar x && touch $@
$(SRC)/$(GCC)/configure: $(GZ)/gcc/$(GCC_GZ)
	cd $(SRC) ; xzcat $< | tar x && touch $@
$(SRC)/$(GDB)/configure: $(GZ)/gdb/$(GDB_GZ)
	cd $(SRC) ; xzcat $< | tar x && touch $@

## @defgroup srclibs libs
## @{

$(SRC)/$(GMP)/configure: $(GZ)/$(GMP_GZ)
	cd $(SRC) ; bzcat $< | tar x && touch $@
$(SRC)/$(MPFR)/configure: $(GZ)/$(MPFR_GZ)
	cd $(SRC) ; bzcat $< | tar x && touch $@
$(SRC)/$(MPC)/configure: $(GZ)/$(MPC_GZ)
	cd $(SRC) ;  zcat $< | tar x && touch $@
$(SRC)/$(ISL)/configure: $(GZ)/$(ISL_GZ)
	cd $(SRC) ; bzcat $< | tar x && touch $@

## @}

## @}

## @defgroup gz download source code
## @brief `make gz`
## @{

## @brief http(s) download command line (`wget`)
WGET = wget -c

.PHONY: gz
gz: $(GZ)/binutils/$(BINUTILS_GZ) $(GZ)/gcc/$(GCC_GZ)

$(GZ)/binutils/$(BINUTILS_GZ):
	mkdir $(GZ)/binutils ;\
	$(WGET) -O $@ http://ftp.gnu.org/gnu/binutils/$(BINUTILS_GZ)

$(GZ)/gcc/$(GCC_GZ):
	mkdir $(GZ)/gcc ;\
	$(WGET) -O $@ http://mirror.linux-ia64.org/gnu/gcc/releases/$(GCC)/$(GCC_GZ)

$(GZ)/gdb/$(GDB_GZ):
	mkdir $(GZ)/gdb ;\
	$(WGET) -O $@ http://ftp.gnu.org/gnu/gdb/$(GDB_GZ)

## @defgroup gzlibs libs
## @{

$(GZ)/$(GMP_GZ):
	$(WGET) -O $@ ftp://gcc.gnu.org/pub/gcc/infrastructure/$(GMP_GZ)

$(GZ)/$(MPFR_GZ):
	$(WGET) -O $@ ftp://gcc.gnu.org/pub/gcc/infrastructure/$(MPFR_GZ)

$(GZ)/$(MPC_GZ):
	$(WGET) -O $@ ftp://gcc.gnu.org/pub/gcc/infrastructure/$(MPC_GZ)

$(GZ)/$(ISL_GZ):
	$(WGET) -O $@ ftp://gcc.gnu.org/pub/gcc/infrastructure/$(ISL_GZ)

## @}

## @}

## @}

