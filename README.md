NQC  ![NQC CI](https://github.com/BrickBot/nqc/workflows/NQC%20CI/badge.svg)
===
Not Quite C is a simple language with a C-like syntax that can be used to program Lego's RCX programmable brick (from the MindStorms set).
* If you are just getting started with programming, then graphical environments such as the MindStorms RIS software or RoboLab are probably better choices.
* If, however, you are a C programmer and prefer typing a few lines to drag-and-drop icon programming, then NQC might be perfect for you.

Getting Started
---------------

See [NQC on Windows](#nqc-on-windows) or [NQC on Linux](#nqc-on-linux) for how
to download the appropriate compiler (`nqc` or `nqc.exe`) and put it where your
shell can find it as a command.

The IR tower should be connected to your modem port (Mac/Linux) or COM1
(Windows). The IR tower should be set for "near" mode (small triangle). The RCX
should also be set for this mode, and firmware must already be downloaded.

Compile and download the test file using the following command line:

```
nqc -d test.nqc
```

The test program assumes there's a motor on output A and a touch sensor
on input 1.  It turns on the motor and waits for the switch to be
pressed, then it turns off the motor and plays a sound.

If you are using a USB tower or a different serial port you will need to
specify the port either by adding a `-Sx` option (where `x` is the name of the
port) to the command line or by setting the `RCX_PORT` environment variable.
Refer to [Installation on Linux](#installation-on-linux) for using USB tower on
Linux.

Here are some examples:

USB tower (where supported)
```
nqc -Susb -d test.nqc
```

Win32 COM2 port:
```
set RCX_PORT=COM2
```

Win32 USB port:
```
set RCX_PORT=usb
```

> [!Tip]
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


NQC on Windows
--------------

You can download the The "official" Win32 release of NQC posted on the original
project website [here](https://github.com/BrickBot/nqc/releases/tag/v3.1-r6).

The `nqc-win-3.1-r6.zip` contains the `nqc.exe` needed to compile and upload
your programs and RCX firmware.

This is the note to Windows Users from the [original README](./readme.txt):

NQC is a command line based tool - normally you run it by typing an
appropriate command into an MS-DOS window.  There is no GUI for it and
if you double-click the `nqc.exe` file an MS-DOS console will be created
for you, NQC will run within it, then since NQC finishes almost
immediately, the entire window will disappear.

Some people prefer command line based tools because they allow you to
use the text editor of your choice, etc. It also makes for identical
behavior under Windows, Mac, and Linux. In order to use the command line
version of NQC you'll need to do two things:

1. Use some sort of text editor (such as Notepad) to edit and save a
source file for NQC to compile.

2. From an MS-DOS window type the appropriate NQC command. Its usually
best to either put all of your programs and `nqc.exe` in the same
directory, or make sure the directory containing NQC is in your command
path.

If any of the above seem either too confusing or too tedious, then you
may want to try the BricxCC which provides a familiar Windows style GUI on top
of the standard NQC compiler.  You can download BricxCC
[here](http://bricxcc.sourceforge.net/).

NQC on Linux
------------

### USB Tower

Most Linux distributions ship with Linux kernels which include support for the LEGO USB Tower by default.

To check if your Linux has support for the LEGO USB Tower open a terminal and show the kernel ring buffer using this command:

```
sudo dmesg --follow
```

(If your `dmesg` does not support the `--follow` option, plug in the tower first and call `dmesq` afterwards.)

Now plug in the LEGO USB Tower. The kernel ring buffer should show lines similar to those below:
```
[1006170.647340] usb 1-2: new low-speed USB device number 26 using xhci_hcd
[1006170.815426] usb 1-2: New USB device found, idVendor=0694, idProduct=0001, bcdDevice= 1.00
[1006170.815441] usb 1-2: New USB device strings: Mfr=4, Product=26, SerialNumber=0
[1006170.815449] usb 1-2: Product: LEGO USB Tower
[1006170.815456] usb 1-2: Manufacturer: LEGO Group
[1006171.465241] legousbtower 1-2:1.0: LEGO USB Tower firmware version is 1.0 build 134
[1006171.465453] legousbtower 1-2:1.0: LEGO USB Tower #0 now attached to major 180 minor 160
[1006171.465511] usbcore: registered new interface driver legousbtower
```

Most important here are the last three lines containing "legousbtower". They indicate that the tower has been recognized and its driver has been loaded.

### Serial Port

By default `nqc` uses `/dev/ttyS0` as the device name for the serial port.  If
you are using the second serial port, then `/dev/ttyS1` should work.

### Build NQC

#### Prerequisite

In order to build NQC you need

- `git` to download the source code (optional - you can also download a ZIP archive)
- a toolchain, `yacc` and `flex` to build the sources
- `emscripten` for WebAssembly support

On Debian based distributions you can install those using:

```
sudo apt update
sudo apt install git build-essential yacc flex emscripten
```

#### Download NQC sources

Goto https://github.com/BrickBot/nqc to dowload the ZIP archive (`<>` Code -> Download ZIP).

Or use `git`:

```
git clone https://github.com/BrickBot/nqc.git
```

#### Compile NQC

Change into the NQC source directory

```
cd nqc
```
and build it:

```
make
```

### Upload Firmware to RCX

Change into the NQC source directory (if not already there):

```
cd nqc
```
Upload the latest firmware:

```
./bin/nqc  -Susb -firmware firmware/firm0332.lgo
```

### Run test programm

Change into the NQC source directory (if not already there):

```
cd nqc
```

Upload the test program:

```
./bin/nqc -Susb -d test.nqc
```

Proceed with [Getting started](#getting-started).

---

WebAssembly Support
===================

A new NQC platform target demonstrated by GitHub user [maehw](https://github.com/maehw) is WebAssembly, which is part of a
[broader vision](https://www.eurobricks.com/forum/index.php?/forums/topic/197807-webpbrickcom-programming-the-1st-generation-lego-mindstorms-ris-yellow-rcx-brick-from-the-webbrowser/).
The initial [WebNQC](https://github.com/maehw/WebNQC) implementation only targets WebAssembly (dropping support for Linux, Unix, Windows, and MacOS platforms),
but WebAssembly targeting support has now been incorporated into this main repository while preserving the support for other platforms.
Additionally, the Makefile has also been updated so that only one command—`make`—is needed to build from source.

With NQC compiled as **WebAssembly bytecode (WASM)**, it can run in a web browser—without any installation and independent of the machine’s platform (Windows, Linux, Unix, MacOS, etc).

---

Original NQC Project
===================

For reference the original README is still [here](./readme.txt).

* Original [NQC Web Site](http://bricxcc.sourceforge.net/nqc)
* [FAQ](http://bricxcc.sourceforge.net/nqc/doc/faq.html)
* You may contact the project founder via bricxcc@comcast.net
