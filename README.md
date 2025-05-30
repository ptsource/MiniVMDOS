# Disk Operating System

DOS, or Disk Operating System, holds a significant place in computing history as one of the pioneering operating systems. Initially developed by Microsoft, it became ubiquitous in the 1980s and early 1990s, serving as the primary interface for personal computers. Characterized by its command-line interface, users interacted with DOS through typed commands, navigating file systems and executing programs. Despite its simplicity, DOS provided a robust platform for software development and application execution, laying the groundwork for the digital revolution. Its influence persists in modern computing, as DOS principles underpin many aspects of contemporary operating systems.

# PTSource MiniVMDOS
### Current version 7 ([LTSR](LTSR.md)) updated 30/05/2025 for Windows

PTSource MiniVMDOS is a professional operating system in the lineage of DOS operating systems intended to run legacy software inside [PTSource MiniVM](https://wiki.ptsource.eu/soft/ptminivm/start) for Windows x86 and x64. Integrates transparent web and network access seamlessly into its familiar command-line interface. Moreover, it introduces native support for printing text to Windows printers, streamlining document management across platforms. With network support, users can effortlessly collaborate and share resources in real-time, enhancing productivity and efficiency.

|  System requirements  |
|         :---:         | 
| Windows 8.1, 10 or 11 platforms arch x86 or x64. | 

## Download

 [![Maintenance](/images/maintained.svg)](https://wiki.ptsource.eu/soft/mvmdos/start) [![You can download here.](/images/version-7-red.svg)](https://wiki.ptsource.eu/files_windows) [![You can download here.](/images/download-here-green.svg)](https://wiki.ptsource.eu/files_windows) [![Help here.](/images/docs-here-blue.svg)](https://wiki.ptsource.eu/soft/mvmdos/start)

## Screenshots
<img src="https://raw.githubusercontent.com/ptsource/PTMiniVMDOS/master/images/01B.PNG" width="33%"><img src="https://raw.githubusercontent.com/ptsource/PTMiniVMDOS/master/images/02B.PNG" width="33%"><img src="https://raw.githubusercontent.com/ptsource/PTMiniVMDOS/master/images/03B.PNG" width="33%">
<img src="https://raw.githubusercontent.com/ptsource/PTMiniVMDOS/master/images/04B.PNG" width="33%"><img src="https://raw.githubusercontent.com/ptsource/PTMiniVMDOS/master/images/05B.PNG" width="33%"><img src="https://raw.githubusercontent.com/ptsource/PTMiniVMDOS/master/images/06B.PNG" width="33%">
## Note
Although PTSource MiniVMDOS is a real DOS system and can be installed in real hardware with the provided tools disk, it comes preconfigured and optimized for [PTSource MiniVM](https://wiki.ptsource.eu/soft/ptminivm/start).
## PTSource MiniVM Emulated Hardware
* Intel Pentium MMX Processor at 580 MHz
* 64Mb SDRAM (default) 128Mb SDRAM (using the --extramem switch)
* S3 ViRGE graphics chipset
* Serial Mouse
* Sound Blaster 16 Sound Card
* Ne2000 Network Card
* 3 Hard Drives (RAW Disk Image format)
* 1 CDROM Drive (ISO Files)
* 2 2.88 Mb Floppy Drives (IMG, IMA, FDI Files)

## Features 

* Runs contained inside [PTSource MiniVM](https://wiki.ptsource.eu/soft/ptminivm/start)
* [PTSource PTSGET](https://wiki.ptsource.eu/soft/ptsget/start) package manager included
* [PTSource MiniVMDOS SDK](https://store.ptsource.eu/soft/mvmdos/devel) available for developers
* Network support and multiuser environment
* Printing text to Windows printers
* Transparent web and network access
* [PTSource Imager](https://wiki.ptsource.eu/soft/ptminivm/utilities#ptimager)  hard drive image creator included
* [PTSource Image Converter](https://wiki.ptsource.eu/soft/ptminivm/utilities#ptimgconverter)  hard drive image converter included
* [PTSource ISO Creator](https://wiki.ptsource.eu/soft/ptminivm/utilities#ptisocreator)  ISO file creator included
* [PTSource Printer](https://wiki.ptsource.eu/soft/ptminivm/utilities#ptprinter) manager for host included
* [PTSource Image Mounter](https://wiki.ptsource.eu/soft/ptminivm/utilities#ptimgmount) in host system included
* [PTSource Rawrite](https://wiki.ptsource.eu/soft/ptminivm/utilities#ptrawrite) floppy boot images included
* [PTSource Tools Disk](https://wiki.ptsource.eu/soft/mvmdos/tools_disk) hard drive tools included
* [PTSource Guides](https://wiki.ptsource.eu/files_16bits#ptguides) reader and compiler included
* [PTSource Basic](https://wiki.ptsource.eu/files_16bits#ptbasic) interpreter and compiler included
* [PTSource Calc](https://wiki.ptsource.eu/files_16bits#ptcalc) included
* [PTSource X System](https://wiki.ptsource.eu/soft/mvmdos/x_system) included
* DPMI support and VDM based multitasking
* Multiuser session manager
* VESA Graphics
* [MiniVMDOS Commander](https://wiki.ptsource.eu/soft/mvmdos/commander)
* [MiniVMDOS Editor](https://wiki.ptsource.eu/soft/mvmdos/editor)
* [MiniVMDOS RECALL Utility](https://wiki.ptsource.eu/soft/mvmdos/utilities)
* [MiniVMDOS PTL Utility](https://wiki.ptsource.eu/soft/mvmdos/utilities)
* [MiniVMDOS FILEC Utility](https://wiki.ptsource.eu/soft/mvmdos/utilities)
* [MiniVMDOS User Manager](https://wiki.ptsource.eu/soft/mvmdos/utilities)
* [MiniVMDOS Precision Pointer Mouse Driver](https://wiki.ptsource.eu/soft/mvmdos/utilities)
* [MiniVMDOS Enhanced Disk Performance Driver](https://wiki.ptsource.eu/soft/mvmdos/utilities)
* [MiniVMDOS Clipboard Driver](https://wiki.ptsource.eu/soft/mvmdos/utilities)
* [Online Help System](https://wiki.ptsource.eu/soft/mvmdos/tutorial)
* UNIX and CMD style commands
* ZIP & UNZIP
* ARJ & UNARJ
* ZOO & UNZOO
* TAR & GZIP
* LHA
* NASM
* Python
* Perl
* TclSH
* Bash, CSH and CMD interpreters
* Mutt email client
* PGPShell with PGP encryption
* Dialog, BBOX
* Samba Client
* TCP/IP Netserver Client and Driver
* Lynx, Gopher, WGET, Curl, FTP, IRC, RSYNC and more...
* 100% Compatible with MS-DOS, PC-DOS, DR-DOS
* Windows 3.11 Enhanced Mode Support


**Info :** Use login root and and password root in first login.

## Extra Packages

PTSource MiniVMDOS uses [PTSource PTSGet](https://store.ptsource.eu/soft/ptsget/start) to maintain extra packages. [PTSource PTSGet](https://store.ptsource.eu/soft/ptsget/start) is a command-line package management tool used in PTSource distributions. It simplifies the process of installing, updating, and removing software packages. With a vast repository of precompiled packages provides access to a wide range of applications for users and administrators alike.
See [here](https://store.ptsource.eu/soft/ptsget/start#ptsgetmvmdos) all avaliable extra packages.

## Tribute

MiniVMDOS pays tribute to [Gary Kildall](https://en.wikipedia.org/wiki/Gary_Kildall), the visionary pioneer behind CP/M and a key influence on modern operating systems, including DOS. Kildall's groundbreaking work laid the foundation for personal computing, enabling millions to harness the power of microcomputers. His innovation not only shaped the software industry but also inspired generations of developers. MiniVMDOS honors his legacy by keeping the spirit of simplicity, efficiency, and accessibility alive.

## Why use DOS at the present time?

Using DOS, or Disk Operating System, offers several benefits despite being an older technology. Its simplicity provides users with a straightforward interface, making it easy to learn and use, even for those unfamiliar with computing. DOS requires minimal system resources, making it lightweight and ideal for running on older hardware or in embedded systems where efficiency is paramount. Additionally, DOS facilitates direct access to hardware, allowing for greater control and customization, which is advantageous for specialized applications or troubleshooting purposes. Its reliability and stability have stood the test of time, ensuring consistent performance for basic computing tasks. Overall, DOS remains a valuable tool for certain use cases, offering efficiency, reliability, and simplicity in operation.

## PTSource MiniVMDOS and the differences with other DOS(ES)

PTSource MiniVMDOS is tailored specifically for programming and networking, designed to evoke the nostalgic charm of yesteryears' computing while seamlessly integrating modern conveniences. Is virtual environment is meticulously configured, offering a seamless experience akin to tinkering with emulated real hardware inside [PTSource MiniVM](https://wiki.ptsource.eu/soft/ptminivm/start). Every keystroke resonates with the spirit of traditional DOS programming, yet the system auto-configures effortlessly, sparing users the headaches of manual setup. Emulating authentic hardware nuances, it provides an immersive journey into the realm of retro programming, where creativity knows no bounds, and innovation flourishes in the timeless allure of classic computing.


**Note :** This software does not use a digitally signed installer, so
you might get a warning. You should dismiss it and continue.

-   Download the Installer.
-   When Windows says the installer is not trusted, click "more info"
    and then "run anyway".
-   Follow the instructions in the installer.
-   You can now launch the software from your desktop.

## Support

[![Visit homepage.](/images/homepage-here-yellowgreen.svg)](https://wiki.ptsource.eu/soft/mvmdos/start)

