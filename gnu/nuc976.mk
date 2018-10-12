## @file
## @brief build toolchain for nuc976 variants

## @brief CPU core
CPU		= arm926ej-s

## @brief must be `none` for bare matal build
HW		= none

## @brief architecture
ARCH	= arm

## @brief target architecture **triplet**
TARGET	= $(ARCH)-$(HW)-eabi

## @brief CPU-specific options for `configure`
CFG_CPU = --with-cpu=$(CPU)

-include toolchain.mk

