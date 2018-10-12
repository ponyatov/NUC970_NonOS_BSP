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

BINUTILS_VER	= 2.29.1
GCC_VER			= 7.3.0
GDB_VER			= 7.11.1

## @}

## @defgroup packages toolchain packages
## @{

## @brief assembler, linker, ELF and library file tools
BINUTILS		= binutils-$(BINUTILS_VER)

## @brief C/C++ compiler
GCC				= gcc-$(GCC_VER)

## @brief debugger
GDB				= gdb-$(GDB_VER)

## @}

## @defgroup srcgz source archives
## @{

BINUTILS_GZ		= $(BINUTILS).tar.xz
GCC_GZ			= $(GCC).tar.xz
GDB_GZ			= $(GDB).tar.xz

## @}

## @defgroup dirs directories for build and install
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

## @}

## @brief make directories
dirs:
	mkdir -p $(GZ) $(TMP) $(SRC) $(SYSROOT) $(CROSS)

## @defgroup cfg configure variables
## @{

## @brief variable prefixes all commands to prefix cross-compiler `$PATH` before system one
XPATH			= PATH=$(CROSS)/bin:$(PATH)

CFG_ALL 		= --disable-nls --prefix=$(CROSS)

BINUTILS_CFG	= --with-sysroot=$(SYS) --with-native-system-header-dir=/include  \
				  --enable-lto --target=$(TARGET) $(CFG_CPU)

GCC_CFG			= $(BINUTILS_CFG) --enable-languages="c" \
					--disable-shared --disable-threads \
					--without-headers --with-newlib \
					--disable-bootstrap 

GDB_CFG			= $(BINUTILS_CFG)



## @}

## @}

