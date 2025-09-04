LDCC
====
An NQC library to enable a LEGO RCX to send commands to another RCX running the LDCC firmware.

For more info on LDCC, please visit the [LDCC project](https://github.com/BrickBot/LDCC) under the BrickBot org. 

Methods
-------
Public (non-internal) method commands include the following:

### InitLdccComm()
Initialize LDCC Communication

### SetLdccPower(int state)
Set the power state to either on (`LDCC_STATE_ON`) or off (`LDCC_STATE_OFF`)

### EmergencyLdccStop()
Force an emergency stop

### SetLdccSpeed(int loco, int speed)
Set the specified locomotive to the specified speed

### SetLdccFunction(int loco, int fn, int state)
Set the specified function on the specified locomotive to the specified state of either on (`LDCC_STATE_ON`) or off (`LDCC_STATE_OFF`)

### SetLdccAccessory(int address, int state)
Set the accessory at the specified address to the specified state of either on (`LDCC_STATE_ON`) or off (`LDCC_STATE_OFF`)
