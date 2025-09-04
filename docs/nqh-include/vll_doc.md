RCX VLL
=======
An NQC library to enable a LEGO RCX to send Visual Light Link (VLL) commands to a LEGO MicroScout.

MicroScout Direct (Immediate) VLL commands
------------------------------------------
When sent, the MicroScout will respond directly to these commands by executing them.

```
port: set to the RCX output port where the light source for sending VLL
      is attached; either OUT_A, OUT_B or OUT_C. 
MsInit(port) - Initialize communication. 
      Run this once before starting your first commands, and again if 
      MsOff() has been used and you want to start sending new commands.
MsOff(port) - Turn off communication
MsFwd(port) - Motor forward
MsRev(port) - Motor reverse
MsStopMotors(port) - Stop motor
MsBeep1(port) - Play beep 1
MsBeep2(port) - Play beep 2
MsBeep3(port) - Play beep 3
MsBeep4(port) - Play beep 4
MsBeep5(port) - Play beep 5
MsRunScript(port) - Run a previously programmed script (see below)
MsDeleteScript(port) - Delete a previously programmed script
```


MicroScout VLL Scripting Commands
---------------------------------
A sequence of up to 15 of the following commands can be sent to the MicroScout, which will together form a script. The MicroScout will subsequently execute them when pressing the “run” button or sending it the direct command MsRunScript().

```
port: set to the RCX output port where the light source for sending
      VLL is attached; either OUT_A, OUT_B or OUT_C.
MsScriptFwd05(port) - Run motor forward for 0.5 seconds
MsScriptFwd10(port) - Run motor forward for 1.0 seconds
MsScriptFwd20(port) - Run motor forward for 2.0 seconds
MsScriptFwd50(port) - Run motor forward for 5.0 seconds
MsScriptRev05(port) - Run motor reverse for 0.5 seconds
MsScriptRev10(port) - Run motor reverse for 1.0 seconds
MsScriptRev20(port) - Run motor reverse for 2.0 seconds
MsScriptRev50(port) - Run motor reverse for 5.0 seconds
MsScriptBeep1(port) - Play beep 1
MsScriptBeep2(port) - Play beep 2
MsScriptBeep3(port) - Play beep 3
MsScriptBeep4(port) - Play beep 4
MsScriptBeep5(port) - Play beep 5
MsScriptWaitLight(port) - Wait until the light sensor detects a light source
MsScriptSeekLight(port) - Turn on the motor if a light source is detected
MsScriptCode(port) - 
MsScriptKeepAlive(port) -
```

## Usage
Include rcxvll.nqh in your NQC program, then the Ms commands can be used.
Example program using direct commands:

```
#include "rcxvll.nqh"
task main()
{
   MsInit(OUT_A);  // Lamp attached to Output A

   //move motor forwards and backwards once
   MsFwd(OUT_A);
   Wait(20);
   MsRev(OUT_A);
   Wait(20);

   //now produce all five beeps
   MsBeep1(OUT_A);
   Wait(150);
   MsBeep2(OUT_A);
   Wait(150);
   MsBeep3(OUT_A);
   Wait(150);
   MsBeep4(OUT_A);
   Wait(150);
   MsBeep5(OUT_A);
   Wait(150);

   // Always turn off the lamp when done, to save batteries.
   MsOff(OUT_A); 
}
```

&nbsp;

------

References
* [Original Documentation Source](https://pbrick.info/rcxvll-nqh/)
* [Author’s Usage Example](http://pbrick.info/2013/10/microscout-rcx-vll/)
