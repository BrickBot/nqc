NQCIPC Documentation
====================

NQCIPC: Simple Interprocess Communication for LEGO MindStorms and NQC
---------------------------------------------------------------------

### 1 Introduction

This package is a very simple implementation of semaphores and intertask messages for Lego MindStorms designed for use with the NQC package. It is designed to provide explicit notations for intertask communication within RCX programs. What it doesn't do is operate between separate programs on one RCX; though the RCX firmware seems to be preemptively multitasking within programs, it runs only one program at once and the concept is therefore moot. It also does not provide an external (i.e. infrared) messaging API; IR messaging works somewhat differently than the design laid out here, though I'm not ruling out adding it later on.

This package also doesn't do
*   sockets
*   pipes (trivially emulated using messages anyway)
*   anything resembling SysV IPC (too complicated)

#### Legalities

In accordance with the prevailing practice in the MindStorms developer community, NQCIPC is (c)1999 Brian Connors, made available under the terms of the [Mozilla Public License](http://www.mozilla.org/). I would also appreciate recieving a free copy of anything that you use my code in.

Neither the author nor this software is associated with [LEGO Group](http://www.lego.com/), so don't go crying to them if this code doesn't work. They've never heard of me anyway. Equally, [Dave Baum](http://www.enteract.com/~dbaum) wrote a pretty good programming language given what he had to work with, but NQCIPC isn't part of his package, so don't tell him that my stuff doesn't work.

This is a simple package to do a simple job. I don't guarantee that it's good for anything in particular, so you use it at your own risk. Remember that whatever you may think it's good for, MindStorms is intended as a toy, so use some common sense when you're playing with my code.

### 2 The NQCIPC Package

The NQCIPC package consists of the following files:

*   This document (nqcipcdoc.html)
*   [rcxsem.nqh](rcxsem.txt) -- the semaphore macros
*   [rcxmsg.nqh](rcxmsg.txt) -- the internal messaging macros
*   [README](readme.txt) -- A readme file describing the current release in detail

The home page for the package is at [2266 Research Triangle](http://www.geocities.com/ResearchTriangle/Station/2266/nqcipc/nqcipcdoc.html), my personal webpage. It's at GeoCities, so prepare to be bothered a bit.

#### 2.1 System Requirements

NQCIPC requires the use of David Baum's [NQC compiler](http://www.enteract.com/~dbaum/lego/nqc) (version 2.0 or later), and can be used with Lego's [MindStorms](http://www.legomindstorms.com) and Cybermaster robotics products. It is intended for use with the standard Lego firmware, though I wouldn't mind seeing someone port the API to LegOS.

Note that NQC does not support Lego's standalone MindStorms Robotics Discovery Kit or Star Wars Droid Developer kit; though it is theoretically possible for a computer to communicate with the former, both are marketed as self-contained toys at present and details of their internal systems ("Scout" and "MicroScout") remain unpublished.

#### 2.2 Bugs

As I write, I don't actually have an RCX of my own yet, but they're very simple macros (based on canned code), so I don't expect bug problems. If you do have any, you can contact me at [connorbd@yahoo.com](mailto:connorbd@yahoo.com) and let me know what the problem is. Include the filename and version number (defined under SEMVER and MSGVER for semaphores and messages respectively) and a fix if you have it.

### 3 Semaphores -- [rcxsem.nqh](rcxsem.txt)

This file contains three macros for handling semaphores. A semaphore is like a "talking stick": it's a variable that several tasks have access to that lets them know not to all talk at once. It's useful for synchronizing several operations; for example, perhaps multiple tasks need access to the motors. If two different tasks try to execute movement instructions at the same time, they might wind up causing the robot to do lots of random things (or maybe nothing at all); likewise, in a regular computer program, this sort of collision might cause a file to be scrambled or a pointer to be redirected into the void, causing core dumps and other unpleasantness. These functions implement basic semaphore semantics.

For readability, _rcxsem.nqh_ allows you to define a variable of type `sem`. This is not enforced by the compiler, but it may be helpful for writing readable code.

#### 3.1 sem\_clear

**Syntax:**

	sem\_clear(s);

`sem_clear()` takes one argument, a semaphore variable named s, and clears it. It is recommended that you don't use this macro outside your `main` task, as it could create confusion.

#### 3.2 sem\_acquire

**Syntax:**

	sem\_acquire(s);

`sem_acquire()` waits for semaphore s to clear, then takes command of it.

#### 3.3 sem\_release

**Syntax:**

	sem\_release(s);

`sem_release()` relinquishes control of semaphore s.

#### 3.4 SSET/SCLEAR

The `SSET` and `SCLEAR` constants allow you to check the current status of a semaphore variable:

	sem s;
	...
	if (s == SSET) {
		//do something appropriate to a set semaphore
	}

In the current implementation, `SSET = 1` and `SCLEAR = 0`.

### 4 Internal Messages -- [rcxmsg.nqh](rcxmsg.txt)

NQC contains functions that handle messages over the IR link (to the controlling computer or to other RCXen), but none that allow tasks to communicate with each other. Given the architecture of the RCX firmware, any interrupt-driven design is impossible, but a simple drop-box algorithm is trivially implemented in a manner much like the semaphore implementation.

The messaging system has two notable limitations: the only data that can be passed are standard NQC integers, since NQC doesn't support strings or any other data type; and all message buffers are considered shared space, so all `msg_send()` operations are technically broadcasts. It is recommended that if targeted messages are needed, multiple buffers be set aside for the purpose.

`rcxmsg.h` defines a datatype `msg` which behaves exactly as the `sem` type does. It is optional, but useful.

#### 4.1 msg\_clear

**Syntax:**

	msg\_clear(buf);

`msg_clear()` sets the contents of `buf` to 0. For the most part, you should avoid using `msg_clear()` in any routine except task main().

#### 4.2 msg\_send

**Syntax:**

	msg\_send(buf,msg);

`msg_send()` sets the contents of `buf` to `msg`.

#### 4.3 msg\_await

**Syntax:**

	msg\_await(buf,val);

`msg_await()` blocks (as with `sem_acquire()` above) until the value in `buf` is equal to `val`, then continues.

#### 4.4 msg\_read

**Syntax:**

	msg\_read(buf,v);

`msg_read()` copies the contents of `buf` into variable `v`.

#### 4.5 msg\_biff

**Syntax:**

	msg\_biff(buf);

`msg_biff()` returns true if there is a message (i.e. nonzero value) in `buf`. It's named for the BSD UNIX mail-alert program, in case you didn't know.

### 5 Further Information

#### 5.1 How To Get NQCIPC

Due to limitations in GeoCities' file handling, you have to download NQCIPC piece by piece. The following are the files you need:

*   [This file](nqcipcdoc.html), the HTML docs.
*   [rcxsem.txt](rcxsem.txt) and [rcxmsg.txt](rcxmsg.txt). Download these as text files and rename with an .nqh extension.
*   [The README file](readme.txt).

If you want the latest version, the home page is at [http://www.geocities.com/ResearchTriangle/Station/2266/nqcipc/nqcipcdoc.html](http://www.geocities.com/ResearchTriangle/Station/2266/nqcipc/nqcipcdoc.html). If you prefer a .tar.gz format file or wish to include NQCIPC in a separate product, contact me and I'll email it to you.

#### 5.2 Links and Downloads

The following are some useful Lego MindStorms links that relate more or less directly to this software and its uses.

*   The [Official Lego MindStorms Page](http://mindstorms.lego.com/) at Lego. Don't expect to see links to this page from there, though; this stuff is pretty unofficial. Related products are LEGO Dacta Robolab (available through [Pitsco](http://www.pitsco.com/)), a multiplatform educational version of MindStorms; and Lego Technic Cybermaster, a slightly more primitive but very similar system available only in Europe (and based on RF instead of infrared; I don't know if this is an FCC issue or simply marketing). I don't have web links for those at this time.
*   [Dave Baum's Lego Page](http://www.enteract.com/~dbaum/lego), original home site for the [Not Quite C](http://www.enteract.com/~dbaum/lego/nqc) programming language that this was written to work with and also the best choice for doing MindStorms programming on the Mac or Linux platforms.
*   [The Lego Robotics page](http://www.crynwr.com/lego-robotics) – probably the most important MindStorms/Cybermaster link farm on the net. It contains links to everything of interest on Lego's robotics products, including technical specs, project pages, and even replacement firmware (such as LegOS).
*   [Kekoa Proudfoot's RCX Internals Page](http://graphics.stanford.edu/~kekoa/rcx) – home to as thorough a reverse-engineering as possible of the RCX computer that controls the standard MindStorms.
*   [O'Reilly and Associates](http://www.ora.com/) – Famed the world over for their software references with the animals on the cover, O'Reilly publishes a fairly comprehensive guide to MindStorms programming and design. Not available as I write this, I've seen a preprint and it's definitely a must-have for MindStorms hackers.

### 6 Change Log

#### NQCIPC v19991016

This is the October 16, 1999, Mozilla Public License release of NQCIPC by Brian Connors.

Release Notes:

19991016

* Updated code to use v2 `until` construct. 
  + semaphores v2
  + messages v2
  + docs v2


### 7 Conclusion

The standard RCX architecture is a bit strange and limited in places, but it's good enough to get the job done. NQCIPC simply extends the package a bit to make it a little more professional, and it's simple enough to give a beginning programmer an education in multitasking.

This (10/9/99) is the first release of this package, and as yet it's untested (since I have the NQC docs but no MindStorms set of my own). I'm willing to take suggestions and contributions (especially example code); just email them to me at [connorbd@yahoo.com](mailto:connorbd@yahoo.com) and I'll put them in if I like them. Finally, if you like this stuff, send me an email and tell me what you're doing with it.

Enjoy!

_/Brian_

_[Brian Connors](mailto:connorbd@yahoo.com)  
posted: 9 October 1999  
last updated: 16 October 1999_

Website:
* [Original](http://www.geocities.com/ResearchTriangle/Station/2266/nqcipc/nqcipcdoc.html)
* [Archived](https://web.archive.org/web/20091026230348/http://www.geocities.com/ResearchTriangle/Station/2266/nqcipc/nqcipcdoc.html)

- - -

Click [here](http://www.geocities.com/ResearchTriangle/Station/2266) to go to my (Brian's) homepage, 2266 Research Triangle.

![setstats](http://visit.geocities.yahoo.com/visit.gif?us1151763774)

![1](http://geo.yahoo.com/serv?s=76001067&t=1151763774&f=us-w85)