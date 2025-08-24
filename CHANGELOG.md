NQC Release Notes
=================

version 4.0.3 – August 12, 2025
-------------

Matthew Sheets
* Make handling of Emscripten unavailability more robust


version 4.0.2 – July 19, 2025
-------------

Matthew Sheets
* Add support for building under Cygwin (specifically in `PSerial_unix.cpp`)
* Update `Makefile` to skip Emscripted build if `emmake` is not found
* Update `Makefile.utility` with latest common version
* Update CI Workflow with a matrix build configuration
  + Cross-BinUtils:  With or Without
  + OS: Ubuntu or Cygwin (Windows)
  + Cygwin Platforms: x86_64 or x86


version 4.0.1 – May 12, 2025
-------------

Nicolas Schodet
* Remove execute permissions from files that don't need it
* Build fastdl from the added source code
* Generate rcxnub and rcxnub_odd from the assembly file
* Fix build dependencies to enable parallel builds
Matthew Sheets
* Add the BrickBot Makefile.utility, including Stow support


version 4.0.0 – April 26, 2025
-------------

First release from the BrickBot/nqc repository on GitHub
* [Patches that were posted by Matthew Sheets to the original SourceForge project site following the release of nqc 3.1r6 but never incorporated](https://sourceforge.net/p/bricxcc/patches/) (primarily enhancing capabilities on Linux):
  + [Added TCP support, facilitating use of NQC with programs such as BrickEmu (an RCX emulator)](https://sourceforge.net/p/bricxcc/patches/2/)
  + [Added additional capabilities for specifying the default USB port, including at both compile time using a Make variable and via enhanced command-line argument support](https://sourceforge.net/p/bricxcc/patches/2/)
  + [Support Makefile variables DESTDIR and TOOLPREFIX](https://sourceforge.net/p/bricxcc/patches/3/)
  + [Enable specifying the default IR tower name in a configuration file](https://sourceforge.net/p/bricxcc/patches/4/)
  + [Support using a Make variable to specify the default compile-time port name, instead of having to modify source code files](https://sourceforge.net/p/bricxcc/patches/5/)
* Updates and cleanup from the [jverne/nqc](https://github.com/jverne/nqc) fork of John D. Vern, which was maintained to keep NQC building and running on OS X and BSD
* Add support for building as a WebAssembly (based on work initiated by [maehw](https://github.com/maehw/WebNQC), which was itself forked from this BrickBot/nqc project)
* Address compiler warnings
* Add support for linker hardening via LDFLAGS
* Ensure Swan code does not segfault
* Fix error text format assuming %d usage for intptr_t
* Cleanup and typo fixes
* Replace or remove dead links in manual page
* Update release versioning to generally align with [semantic versioning](https://semver.org/) practices
* Update Makefile
  + Created or enhanced troubleshooting targets (e.g. info, list-variables, submake-list)
  + Added targets for Stow support
  + Adopted more common install variables, such as prefix, exec_prefix, bindir, datarootdir, mandir, man1dir, etc.
  + Updated the default path for manuals to move under the "share" directory


version 3.1 r6 – June 6, 2007
--------------

* Minor code changes to support 64bit platforms.
* Minor additions to the built-in API header.
* USB and serial tower timing tweaks.


version 3.1 r4 – October 13, 2005
--------------

* Modified Spybot program code generation slightly so that it
  matches that generated via the MindScript compiler.  Tasks 
  that are not empty no longer are terminated by the two byte
  stop task sequence.  Empty tasks are flagged via the standard
  two byte stop task sequence but the task numbers are 0-7 rather
  than 8-15.


version 3.1 r3 – October 3, 2005
--------------

* Fixed bug in NQC code generation for expressions like `a = a*2 + a*3;`.


version 3.1 r2 – June 9, 2005
--------------

* Fixed Spybot FindWorld API function.


version 3.1 r1 – March 15, 2005
--------------

* LASM-compatible listing output via the -c switch
* Support for Dick Swan's replacement firmware
* Fixes for Linux/Free BSD compilation
* SetEEPROM API fix
* Change to USB Tower timing (Win32) when downloading user programs


version 3.0 a2 – February 11, 2004
--------------

* Fixed a bug in returning from Spybotic subroutines 


version 3.0 a1 – January 22, 2004
--------------

* -q quiet mode (no sound played after program download and firmware download)

* improved firmware download (support for alternate firmwares and fast mode 
via USB tower on Windows platform)

* changed asm statement to use $ rather than &

* incorporated Spybotics API into built-in API definitions.

* added support for more writable sources for RCX2 and Spybotics.

* added support for pointers and function parameters of type int* and const int*


version 2.5 r3
--------------

* Improved disassembly listings for Spybotics.

* Fixed some bugs in the Scout API's output functions.


version 2.5 r2
--------------

* Added support for the USB tower Linux driver available from http://legousb.sourceforge.net/.
  Any questions regarding the USB driver itself should be directed to David Glance <david@csse.uwa.edu.au>.


version 2.5 r1
--------------

Functionally the same as 2.5 a5, except that it is now an official release instead of
in beta test.


version 2.5 a5
--------------

* fixed RepeatStmt to work with Spybotics
* fixed bug with writable sources and Spybotics
* fixed bug with jump optimization causing jumps to end-of-program to jump to the start of program instead
* fixed a bug with right shift of a negative operand
* added version resource in win32 build


version 2.5 a4
--------------

* added resource support for Spybotics (`__res` keyword)

* removed a few Spybotics features from the built-in API file.  The
  Spybotics API will be maintained as a separate file until it becomes
  more stable, at which point it will be merged back into the compiler.


version 2.5 a3
--------------

* Added optimizations for using short branches (jmp instead of jmpl and
  chk instead of chkl).

* Added fast firmware for USB (Mac OS X only, but framework is in place
  for other platforms to use).

* Added the -R option to redirect text output to a file (this is somewhat
  redundant for operating systems that provide good control over
  redirecting stdout and stderr).

* Added limited "goto" support.  Goto should be used with care since
  the compiler doesn't currently check to see if the goto would
  enter/leave control blocks such as `acquire()` and `monitor()`.  As
  a result, those control blocks may not be properly set up or
  finished.  The bottom line is that you probably shouldn't be using
  goto in the first place, but if you need to, then you should use
  it with care.

* Removed nullable algorithm.  This was done in order to clean up some
  of the code generation code.  The only noticeable effect is that one
  previous optimization (empty repeat within a while loop) is no
  longer made.



version 2.5 a1
--------------

* Added supoprt for Spybotics.  Use -Tspy to tell NQC that you are using
  the Spybotics brick.  Currently, only serial communications are supported.
  Spybotics is very similar to an RCX 2.0 in terms of programming, except
  that it has only two motors, the sensors are pre-configured, there is
  no LCD display, and no Datalog.  There are some new capabilities with
  Spybotics, but not everything has an API in NQC yet.  Use "nqc -api"
  to view the current API definition (pay particular attention to things
  conditionally defined using `__SPY`).
  
* Fixed a bug with the `Program()` call.

* Removed a debugging printf (kept saying "draining") from the Unix build.

* Added a check for no firmware


version 2.4 r3
--------------

* fixed bug in RCX_PipeTransport::Open() that would sometimes pick
  the wrong pipe mode.  This would result in an error when NQC started
  to download a program.

* The Unix builds (including Mac OS X) now support disabling of calls
  to tcdrain() (which would hang on some flavors of Unix with some
  device drivers).  If NQC hangs when you try to download, append
  ":nodrain" to the device name.  For example, if your device was
  /dev/ttys0 then you would do this:
```Bash
     nqc -S/dev/ttys0:nodrain -d test.nqc
```

* Mac OS X now defaults to enabling tcdrain().  This works fine under
  10.1.3 with the Keyspan serial drivers.  If you are using a combination
  of OS / drivers that hangs when NQC tries to download a program, add
  ":nodrain" to the serial device name (as described above).
  


version 2.4 r2
--------------

* added some error checking for empty -S, -I, -D, -U, and -O options
* added Mac OS 9 USB support (via the Lego Ghost API)

version 2.4 r1
--------------

* Fixed a bug that caused -D arguments not to be processed
* Improved `#pragma` reserve for locals
* changed -firmfast send delay to 100ms (should have better performance now)
* srecord parser is now more tolerant about line endings
* fixed bug with `#elif` not expanding macros if previous condition was false
* return code from `main()` is now an error code instead of just 0 or -1 
* reorganized the Makefile

version 2.4 a4
--------------

* fixed bug that caused a crash when no serial device was specified (either
  with a -S option or the `RCX_PORT` environment variable).


version 2.4 a3
--------------

* added support for the Lego USB tower under some operating systems.  If
  supported, the tower is selected by specifying -Susb on the command line.
  Currently, Win32 and Mac OS X are the only platforms with USB support.
  I'll be adding Mac OS9 support as soon as Lego releases their driver for
  it.  Note that fast firmware download (-firmfast) is not allowed when
  using a USB tower.
  

version 2.4 a2
--------------

* added `__sensor()` expression for arg checking.  This fixes an old
  problem with `SensorValueRaw(SENSOR_x)` and other macros that can
  take a `SENSOR_x` as an argument.

* added the `__NQC__` compile time symbol for the version number of
  NQC (for 2.4, `__NQC__` is 204)
  
* improved the predictive timing of `RCX_Link`

* fixed a few minor bugs



version 2.4 a1
--------------

* added -s option, which will cause -L to emit merged source/assembly listings.
  This option only has effect when a source file is compiled/listed (it is
  ignored when binary .rcx files are listed).  The merged listing can be a bit
  confusing; especially since functions are expaned inline, and you will see
  the expanded function source mixed in with the caller's source.

* improved support for various operators and assignements (<<, >>, ^, ~).  The
  shift operators still require a constant shift amount, but the left operand
  may be any expression.  For the other operators, all constant restrictions
  have been removed.

* added new assignement operators (<<=, >>=, ^=, %=).  The shift assignments
  require a constant shift amount.

* added the ternary (?:) operator.

* some very old deprecated features from 1.x have been removed.  Specifically,
  the old syntax for tasks, subs, and function declaration has been removed. If
  you have been compiling without the -1 option and not seeing any warnings,
  then your code is fine and does not use the deprecated syntax.
  
* the deprecated -s and -c options (for Scout and CyberMaster support) have
  been eliminated.  The -T<target> option is now the only way to specify a
  target.

* expression evaluation when targeting RCX 2 has been optimized slightly.
  Specifically, prior to RCX 2 there were restrictions on the types of
  effective addresses that could be used in math bytecodes.  So NQC would
  typically move data from these types of addresses to a temporary variable,
  then use the temporary variable as an operand to the math bytecode.  With
  RCX 2, the restrictions have been eased, and NQC now takes advantage of this
  and uses the effective addresses directly as operands to math bytecodes
  when possible.

* Mac-only: eliminated call to LMGetUnitTableEntry() when opening serial port.
  Apparently for a brief period of time Apple forgot to include this call in
  their system ROMs (after of course telling all developers to use this call
  rather than access the low mem globals directly).



version 2.3 r1  (previously 2.3 b1)
-----------------------------------

* added the -b option to force input file to be treated as binary file
regardless of filename extension

* automatically switches a Scout to "power mode" when downloading a program

* fixed a bug with the -clear action (previously it would return an error even
though the RCX was cleared)

* fixed a bug that produced garbage when printing an error message that
occurred at the end of the source file

* fixed two bugs associated with evaluating expressions as conditions


version 2.3 a1
--------------

* merged conditions and expressions - relational operators may now be used
in expressions and the result of a calculation is a valid condition.  The
precedence and associativity is identical to that of C

* implemented partial catches for monitor statements, that is it is possible
to have multiple catch clauses to handle separate events.  This only works
for RCX 2.0.
```C
    monitor(EVENT_MASK(1) + EVENT_MASK(2) + EVENT_MASK(3))
    {
    }
    catch (EVENT_MASK(1))
    {
      // will handle event 1
    }
    catch
    {
      // will handle any other events (2 and 3)
    }
```

* Added `CurrentEvents()` to the API.  This returns the events that triggered
an event handler.  In general, its simpler to just use partial catches and
let the compiler do the work for you.

* Fixed a bug in the definition of DisableOutput

* rcxifile version updated to 1.0.2 (addition of target type)

* `__taskid` added - this expression returns the number of the task.  Note it
must be possible to determine the task number lexically at compile time for
this to be a valid expression (in other words, don't use it in a subroutine
called from multiple tasks).



version 2.2 r2
--------------


* enabled `SetSleepTime()` and `SleepNow()` in Scout API

* fixed a bug in `Event()`

* allow 16-bit unsigned constants (`EVENT_MASK(15)` now works)

* ignore ctrl-Z characters (0x1a) in input files

* error added for unterminated comments



version 2.2 r1
--------------

* removed `SensorParam()` from the API

* added `SENSOR_TYPE_NONE` to the API

* fixed a bug where `CalibrateEvent()` used the args in the wrong order

* fixed a bug in the disassembly listing for the chkl opcode

* fixed a bug with the code generation for repeat statments that
  used decvjnl for looping.  The offsets were not computed correctly
  (due to a sign bit) for offsets greater than 127 bytes.

* optimized code generation when `__ASM_NO_LOCAL`restrictor is used
  with an atomic expression of a restricted source.  Previously,
  the restricted source was moved to a local temp, then a global.  Now
  the restricted source is moved directly to a global temp.  In practice
  this means that `AddToDatalog(Message())` takes two opcodes instead of
  three (and dirties one temp instead of two).


version 2.2 b1
--------------

* 'for' statement added

* simple array support for RCX2 added.  You can declare, set, and read
 array elements.  There is currently no support for initializing arrays,
 passing them as arguments, incrementing or decrementing elements with
 ++ and --, or any math assignment such as += or -=.

* SetUserDisplay() and AddToDatalog() now correctly use a global temp
 rather than a local one.  Even so, SetUserDisplay() should be used with
 care - generally a temp is the wrong thing to display!

* Most of the raw serial APIs have been changed slightly.  For the most
 part the change was replacing SerXXX with SerialXXX.

* `EVENT_MASK()` macro added to help in building event sets

* `EVENT_TYPE_MAILBOX` changed to `EVENT_TYPE_MESSAGE`

* `Duration()` changed to `ClickTime()`

* Most parameters, such as `UpperLimit()` now have calls such as 
 `SetUpperLimit()` to set their value.

* Most of the global output commands were removed due to how confusing
 the whole system was.  There are now only three primitive commands:
 `SetGlobalOutput()`, `SetGlobalDirection()`, and `SetMaxPower()`.

* Minor changes to Scout calls for setting up the light sensor.  These
 changes make the Scout terminology align with the RCX2 calls.

* Constants for scout events, such as `EVENT_1_PRESSED` have been added.

* fixed bug that prevented 'continue' from working in a switch nested
 within a loop


version 2.2 a2
--------------

* `#praga reserve` may be used to prevent RCX variables from being used
by NQC.  The syntax is
```C
#pragma reserve start [end]
```

For example, to reserve locations 0 and 1 (where the RCX2 counters are):
```C
#pragma reserve 0 1
```

* added `SetSleepTime()` and `SleepNow()` to the API

* removed `Display()` from the API (`SetUserDisplay()` is sufficient)

* changed SetEvent and event sources...now just specify the source literally:
```C
	SetEvent(0, SENSOR_2, EVENT_TYPE_PRESSED);
```

* Error checking netsted monitor or acquire statements

* monitor/acquire exits loops and functions correctly

* fixed bug where non-existant handlers could cause a crash

* MonitorStmt properly restricts event sources when generating Scout code


version 2.2 a1
--------------

* rcx1.nqh and rcx2.nqh are no longer supplied in the distribution.  Instead,
they can be generated directly from NQC (which contains ebmedded versions of
these files).  The -api option will cause NQC to emit the appropraite API
file (normally the 2.0 api, unless 1.0 compatability mode has been selected):
```Bash
	nqc -api

	nqc -1 -api
```

* Firmware download supports large files (such as the RCX 2.0 firmware).  Also
fixed a bug in fast firmware download.

* modulo operator (%) now supported for non-constant operands

* Preliminary RCX 2.0 API - see the api file for the actual constants and
functions.  Use a target of rcx2  in order to generate RCX 2.0 code.
For example:
```Bash
	nqc -Trcx2 -d test.nqc
```

* local variables are utilized when compiling for Scout or RCX 2

* event monitoring is supported with a monitor/catch construct...
```C
	monitor(events)
	{
		// body
	}
	catch
	{
		// handler
	}
```
	
	'events' is the set of events to watch.  The 'catch' and handler are
	optional.  The body is executed.  If one of the monitored events occur,
	then body will be interrupted and the handler will be executed.   Events
	are only availabe for Scout and RCX 2.

* resource acquisition is supported with acquire/catch construct...
```C
	acquire(resources)
	{
		// body
	}
	catch
	{
		// handler
	}
```

	'resources' is the set of resources to acquire (`ACQUIRE_OUT_A`, etc) and
	must be a compile-time constant.  An attempt is made to acquire the
	resources.  If sucessful, execution proceeds to the body.  If unsuccessful,
	or if during execution of the body the resources are preempted by another
	task, execution jumps to the handler (if any).  Under normal operation
	resources are released at the conclusion of the body.  Resource acqusition
	is only supported for Scout and RCX 2.


NOTE - event monitoring and resource acquisition are still in preliminary form.
There are a number of unimplemented details...

  - Nesting of monitor and/or acquire statements will almost certainly result
 in programs that don't operate as expected.
 
  - Statments such as break, continue, or return that cause flow control from
 inside a monitor/acquire statement to outside it will not operate properly.



version 2.1 r2
--------------

* disabled duplicate reduction code in rcxlib when sending RCX messages.  This
should only affect people using the rcxlib sources for their own projects - nqc
never directly used this behavior.

* added an error for recursive function calls

* fixed a bug in local variable allocation when one inline function calls a
second one

* orphan subs (those never invoked from any task) are now allowed to allocate
variables from the main task's pool (previously they couldn't allocate any
variables)


version 2.1 r1
--------------

* code generation for repeat() has been improved quite a bit
   - correctly implemented for Scout
   - nested repeats() are now legal
   - the repeat count can be greater than 255
   - the RCX loop counter is used whenever possible (non-nested
     repeat with compile time constant count of 0-255), otherwise
     a temporary variable is claimed to do the repeat.  Note that this
     will break code that used every single variable and then had a repeat
     count that came from a variable.  In previous versions of NQC, the
     repeat would use the built-in loop counter even though the repeat
     count (in the variable) may have exceeded 255.  The current version
     of NQC is more paranoid, and will not use the built-in loop counter
     in this case, thus a temporary variable needs to be allocated.

* total bytecode size is included in the listing


version 2.1 b3 (beta 3)
-----------------------

* Fixed bug where `__SCOUT` was not defined properly

* Output files now default to being placed in the current directory rather
that next to the source file.

* Trailing directory delimiter (e.g. / for Unix) is now optional with the
-I option.

* For WIN32, command line escaping of quotes (e.g. \") is disabled.  This
is a temporary measure for RcxCC compatability until RcxCC can be updated.


version 2.1 b2 (beta 2)
-----------------------

* Added the `NQC_OPTIONS` environment variable, which can be used to specify
extra options to be inserted into the command line.  For example, setting
`NQC_OPTIONS` to "-TScout" would cause nqc to target the Scout by default.

* A 'switch' statement was added. The generated code is reasonably good
considering the limitations of the RCX bytecodes.  However, some optimizations
(such as surpressing a 'break' in the last case) are not implemented [yet].
  
* Expressions are now coerced into conditions where appropriate.  For example,
you can do this:
```C
  int x;
  
  while(x)
  {
  }
```

* Improved Scout support - battery level is checked on download, API file
merged into compiler so "scout.nqh" no longer needs to be included, PlayTone()
now supports both constant and variable argument for frequency.

* Switched over to official Lego mnemonics for those operations listed in the
Scout SDK.  Bytecodes not present on Scout still use the older NQC mnemonics,
but will change eventually.

* `__type()` operator added.  This is just a nasty low-level hack to
allow an inline function to call two different bytecodes depending on the
type of the argument passed in.  Used for PlayTone() when targeting the Scout.

* fixed a bug introduced in 2.1 b1 that caused problems using include files
with DOS line endings.


version 2.1 b1 (beta 1)
-----------------------

* Added preliminary support for Scout.  See "scout.txt" for more information
on Scout support in NQC.

* Added support for faster firmware downloading.  Firmware will download
about 4 times as fast with this option, but it requires the IR tower to
be in "near" mode.  If you have trouble getting the fast download to work,
please revert to the older (and slower) method.
```
  Fast:  nqc -firmfast <filename>
  Slow:  nqc -firmware <filename>
```

* The -o, -e, and -s options have been removed (they were deprecated quite
a while back).  If you still use these options, please change to the -O,
-E, and -S variant.

* The -c option (cybermaster support) has been deprectaed.  NQC now has a
more general option to specify the target: use -TCM for cybermaster:
```Bash
  nqc -TCM -d test.nqc
```

  - Other targets include -TScout and -TRCX (the default).

* A couple of bugs relating to compiling stdin were fixed.



version 2.0.2
-------------

Fixed a bug which caused NQC to crash when compiling programs containing
functions with certain errors in them.


version 2.0.1
-------------

Fixed a bug that caused the compiler to crash when more than 32 variables
were used in a program.

The Win32 version no longer aborts due to serial driver errors - the retry
algorithm will remain in effect.  This makes download of very long programs
much more reliable (especially under WinNT).

The retry algorithm is now more forgiving if the IR tower doesn't echo the
serial data properly.  This makes very long downloads a little more reliable.


version 2.0
-----------

First official release of NQC 2.0
