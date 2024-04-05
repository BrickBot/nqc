NQC  ![NQC CI](https://github.com/BrickBot/nqc/workflows/NQC%20CI/badge.svg)
===
Not Quite C is a simple language with a C-like syntax that can be used to program Lego's RCX programmable brick (from the MindStorms set).
* If you are just getting started with programming, then graphical environments such as the MindStorms RIS software or RoboLab are probably better choices.
* If, however, you are a C programmer and prefer typing a few lines to drag-and-drop icon programming, then NQC might be perfect for you.

> [!TIP]
> For tutorials, examples, reusable libraries, and more, please check out the associated [NQC-Libs project](https://github.com/BrickBot/nqc-libs).

About
-----
This BrickBot/nqc repo captures changes to the 3.1r6 code as found on
[BricxCC](http://bricxcc.sourceforge.net/nqc/), including the following [patches that were posted by Matthew Sheets to the original SourceForge project site following the release of nqc 3.1r6 but never incorporated](https://sourceforge.net/p/bricxcc/patches/):
1. [Added TCP support, facilitating use of NQC with programs such as BrickEmu (an RCX emulator)](https://sourceforge.net/p/bricxcc/patches/2/)
2. [Added additional capabilities for specifying the default USB port, including at both compile time using a Make variable and via enhanced command-line argument support](https://sourceforge.net/p/bricxcc/patches/2/)
3. [Support Makefile variables DESTDIR and TOOLPREFIX](https://sourceforge.net/p/bricxcc/patches/3/)
4. [Enable specifying the default IR tower name in a configuration file](https://sourceforge.net/p/bricxcc/patches/4/)
5. [Support using a Make variable to specify the default compile-time port name, instead of having to modify source code files](https://sourceforge.net/p/bricxcc/patches/5/)

This release also attempts to build on the [jverne/nqc](https://github.com/jverne/nqc) copy, which was maintained to keep NQC building and running on OS X and BSD.

For bug reports about _this_ fork of NQC, please [file a GitHub Issue](https://github.com/BrickBot/nqc/issues) for this project.

The original README from the NQC project follows.

---

NQC ReadMe
----------

If you have a problem, PLEASE CHECK THE FAQ:
* http://bricxcc.sourceforge.net/nqc/doc/faq.html
  
Send bug reports to bricxcc@comcast.net.  Be sure to include details about what
platform you are running nqc on and a sample file that demonstrates the bug if
possible.

For updates and additional documentation, visit the [NQC Web Site](http://bricxcc.sourceforge.net/nqc)


Note to Windows Users
---------------------

NQC is a command line based tool - normally you run it by typing an
appropriate command into an MS-DOS window.  There is no GUI for it and
if you double-click the nqc.exe file an MS-DOS console will be created
for you, NQC will run within it, then since NQC finishes almost
immediately, the entire window will disappear.

Some people prefer command line based tools because they allow you to
use the text editor of your choice, etc. It also makes for identical
behavior under Windows, Mac, and Linux. In order to use the command line
version of NQC you'll need to do two things:

1. Use some sort of text editor (such as Notepad) to edit and save a
source file for NQC to compile.

2. From an MS-DOS window type the appropriate NQC command. Its usually
best to either put all of your programs and nqc.exe in the same
directory, or make sure the directory containing NQC is in your command
path. 

If any of the above seem either too confusing or too tedious, then you
may want to try the BricxCC which provides a familiar Windows style GUI on top
of the standard NQC compiler.  You can download BricxCC here:

http://bricxcc.sourceforge.net/


Getting started
---------------

Download the appropriate compiler (nqc or nqc.exe) and put it where
your shell can find it as a command.

The IR tower should be connected to your modem port (macintosh) or COM1
(Win32/Linux). The IR tower should be set for "near" mode (small
triangle). The RCX should also be set for this mode, and firmware must
already be downloaded.

Compile and download the test file using the following command line:

`nqc -d test.nqc

The test program assumes there's a motor on output A and a touch sensor
on input 1.  It turns on the motor and waits for the switch to be
pressed, then it turns off the motor and plays a sound.

If you are using a USB tower or a different serial port you will need to
specify the port either by adding a -Sx option (where x is the name of the
port) to the command line or by setting the RCX_PORT environment variable.

Here are some examples:

USB tower (where supported)
	nqc -Susb -d test.nqc

Win32 COM2 port:
	set RCX_PORT=COM2

Win32 USB port:
	set RCX_PORT=usb
	
Linux:
	The syntax for setting environment variables is shell specific.  By
	default nqcc uses "/dev/ttyS0" as the device name for the serial
    port.  If you are using the second serial port, then "/dev/ttyS1"
    should work.  Other device drivers may or may not work depending on if
    they implement the expected ioctl's to setup the baud rate, parity,
    etc.
