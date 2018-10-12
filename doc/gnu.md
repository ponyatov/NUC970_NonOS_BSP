# GNU toolchain support {#gnu}
## for OpenSource compilers and developer's workstations uses Linux OS variants

*This part of the BSP project do not officially supported by Nuvoton Technology Corp.*

https://github.com/OpenNuvoton/NUC970_NonOS_BSP/issues/3

### Currently we (Nuvoton) only plan to support Keil development environment  in NUC970 bare bone BSP.

This, in fact, is a big problem and a strange decision, as NUC970 series
suggests the cheap Linux-friendly solution for low-cost devices.
If a developer works with some nuc976 making embedded Linux build for it,
it is natural that developer itself uses Linux on his workstation
(native installation of a virtual machine). Then the developer makes a decision
to move low-level to avoid some Linux disadvantages (leave more memory to application,
hard real-time control, fast system startup,..). And, oops, he immediately
must buy commercial Keil license and install Windows to run it.

* @ref gcc
* @ref gdb
* @ref doxy

