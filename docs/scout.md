Scout Support in NQC
====================

LEGO has introduced a number of new (and useful) extensions in the Scout.
Taking full advantage of these within NQC is going to take some work.  However,
adhering to the "release early, release often", I've decided to release a
version of NQC with very preliminary Scout support.  Currently, many of
the Scout features must be manually invoked from within NQC, and there are a
few things that aren't supported at all.  Future releases will improve this.

The `-TScout` option can be used to inform NQC that it should target (and/or
download to) a Scout.  Downloading will only work if the Scout is in "power
mode".


> The Scout API is very preliminary.  It will change.  A lot.  Anything
> you write today probably won't compile two months from now.  You've been
> warned.


Why so preliminary?  Simple...nobody has much experience using the Scout from
within NQC.  The RCX API evolved over many months (including a good amount of
use by myself before NQC was ever posted).  I'm looking for feedback on the
names for the different API calls and/or constants.  I want to keep the names
consistent with the RCX API as much as possible, but also make sure that the
resulting functions seem intuitive from a Scout perspective.


Scout API Calls
---------------
Here are the Scout API calls (listed with their Scout SDK mnemonic)

```
cntd	DecCounter(counter)
cnti	IncCounter(counter)
cnts	SetCounterLimit(counter, limit)
cntz	ClearCounter(counter)
event	Event(eventMask)
gdir	GSetDirection(outputs, direction)
gout	GSetOutput(outputs, mode)
gpwr	GSetPower(outputs, power)
light	SetLight(mode)
lsbt	LSBlink(time)
lscal	LSCal()
lsh     LSHyst(hysteresis)
lslt	LSLower(cutoff)
lsut	LSUpper(cutoff)
playv	PlayTone(note, duration)
rules	Rules(m,t,l,time,fx)
scout	Scout(mode)
setfb	SetFeedback(fb)
setp	SetPriority(p)
sound	Sound(mode)
tmrs	SetTimerLimit(timer, limit)
vll     VLL(value)
```

There are also global versions of the standard NQC output calls:

GOn, GOff, GFloat, GToggle, GFwd, GRev, GOnFwd, GOnRev, GOnFor


Counters
--------
If you want to read one of the counters, use Counter(n) (just like reading a 
timer for the RCX)...

x = Counter(0); // read counter 0 into variable x


Variables and Subroutines
-------------------------
Variables present some new problems.  Scout has global variables (just like the
RCX) and "local" variables.  The locals are pretty useful, and it will take a
good deal of work to get NQC to support them fully.  In the meantime, NQC simply
makes use of the 10 globals and leaves all of the locals alone.  You can use
them manually with the "local(n)" expression where "n" is a value between 0
and 7 inclusive.  For example, to set the first local variable to the value
123, you'd do this:

local(0) = 123;

This is particularly useful for calling the built in subroutines which expect
parameters in certain local locations.  NQC doesn't really know about the
subroutine library, so you can't call them like you call user subroutines.
Instead, use "Call(n)" where "n" is the subroutine number:

Call(3); // call subroutine 3

Both the local() and Call() macros are hacks.  Real support will follow later on.

I've added some really crude support for events in the form of the WaitEvents()
function.  You pass it an event mask and control waits at that point until one
of the specified events happens.


Pending Issues for Future Releases
----------------------------------

1. Consistent mnemonics for listings.  Scout-style mnemonics are being used,
however there are still some RCX-only functions using my old mnemonics.

2. Full support for resource acquisition, events, and loops (decvjn, decvjnl, monal,
monax, mone, monel, and monex bytecodes).  This will probably involve new syntax,
and I'd love to hear some suggestions.

3. Use short forms of branches where possible (this will save program space)

4. Full utilization of locals

5. Calling of library subroutines with normal call syntax (including parameter
lists for the arguments).

6. Better names for the various API functions.  What should the output
functions be called?  Is is ok to just prepend "G" to the standard ones,
or does this look hideous?  What about the light sensor calls?  LSxxx is
pretty ugly.  Any ideas?  In general, feel free to suggest names for some
or all of the API functions.

7. Support for all of the different data sources (listed in the SDK).  All
that's really needed here is good names for each of them.
