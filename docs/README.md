NQC  ![NQC CI](https://github.com/BrickBot/nqc/workflows/NQC%20CI/badge.svg)
===
Not Quite C is a simple language with a C-like syntax that can be used to program
LEGO’s RCX programmable brick (from the MindStorms set) that is running
firmware either [standard LEGO firmware](https://github.com/BrickBot/Archive/releases/tag/LEGO) (latest [0332] recommended)
or the earlier versions of [Dick Swan’s “fast” firmware](https://github.com/BrickBot/RobotC/releases/tag/Firmware)
that were still compatible with NQC.

Usage recommendation matrix:

| Scenario | Suggestion |
| -------- | ---------- |
| Just getting started with programming? | Graphical environments such as the MindStorms RIS software, [VisualNQC](https://github.com/BrickBot/VisualNQC), or RoboLab might offer a more suitable starting point. |
| A C programmer who prefers typing a few lines code over drag-and-drop icon programming ? | NQC might be perfect for you. |


About This Project
------------------
This BrickBot/nqc repo continues the 3.1r6 codebase as found under the
[SourceForge project site](http://bricxcc.sourceforge.net/nqc/).  For a
full list of all updates since that NQC 3.1r6 release, please refer to
this project’s [Releases page](https://github.com/BrickBot/nqc/releases).

For bug reports about _this_ fork of NQC, please
[file a GitHub Issue](https://github.com/BrickBot/nqc/issues) for this project.


Resources & Information
-----------------------
* [Getting Started](#getting-started)
* [FAQ](FAQ.md)
* Platform-Specific Setup
  + [Windows](PLATFORM-Windows.md)
  + [Linux/Unix (including Cygwin)](PLATFORM-Linux.md)
  + [Mac](PLATFORM-Mac.md)
  + [WebAssembly](PLATFORM-WebAssembly.md)
* Documentation
  + [NQC User Manual](NQC_User_Manual.pdf)
  + [NQC Programmer’s Guide](NQC_Programmers_Guide.pdf)
  + Libraries for NQC
    - LEGO Ecosystem  (ldcc.nqh, vll.nqh)
      * [LEGO Digital Command Control (LDCC)](./nqh-include/ldcc_doc.md)
      * [Visual Light Link (VLL)](./nqh-include/vll_doc.md)
    - [Mathematics](./nqh-include/math_doc.md)  (math-compare.nqh, math-trig.nqh)
    - [System—IPC](./nqh-include/nqcipc_doc.md)  (NQCIPC package: sys-msg.nqh, sys-sem.nqh)
  + [NQC and the Scout](Scout.md)
* NQC Coding Examples
  + [NQC Tutorial](./tutorial/)
  + [Example code that accompanied Dave Baum’s _Definitive Guide to LEGO MindStorms, Second Edition_](./guidebook/)
  + [Community Examples](./examples/)
    - [Bulldozer](./examples/Bulldozer/)
    - [KickerBot](./examples/KickerBot/)
    - [Omni](./examples/Omni/)
    - [Radar](./examples/Radar/)


Getting Started
---------------

See [NQC on Windows](#nqc-on-windows) or [NQC on Linux](#nqc-on-linux) for how
to download the appropriate compiler (`nqc` or `nqc.exe`) and put it where your
shell can find it as a command.

On Debian-based systems, check out the `nqc` package (`sudo apt install nqc`)!

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



&nbsp;

---

References to Original NQC Project Content:
* Original [ReadMe](./_original/readme.txt).
* Original [FAQ](./_original/faq.html)
* Original [NQC Web Site](http://bricxcc.sourceforge.net/nqc)
