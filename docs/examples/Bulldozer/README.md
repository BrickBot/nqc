CMPS2D21 - Operating Systems Kernels and Architecture; Coursework 1
====================================================================

> Original Website – https://github.com/mudge/lego_bulldozer


Structure of the Program
------------------------

Upon receiving a message from the PC, this program will instruct the RCX brick to begin moving forward while playing a tune until the boundary of the playing field is reached. If any obstacles were encountered during the radius, a continuous tone will be played while the robot pushes them out of the area. The robot must then reverse while playing an intermittent tone back to its starting point and then turn slightly and proceed to move forward again. It does this until it has rotated a full 360 degrees and therefore explored the entire playing field. At this point it will stop and report back to the PC the number of obstacles cleared and the time taken.

The major weakness of this approach is that very large playing fields will mean that even if the robot makes very small turns, it may not explore certain areas towards the field's edge. However, it is a relatively uncomplicated approach that benefits from being guaranteed to always push an obstacle outwards from the centre.

The program is separated into several tasks: each deal with a specific part of the problem specification and have been designed to run concurrently with each other.

The `main` task is the first task to be executed by the RCX brick and is responsible for:

* Setting up the robot's various motors, timers, variables and sensors;
* Starting other tasks;
* Controlling the robot's movement;
* Ending the program.

It uses a busy-wait loop to stall the program until the value of `Message()` is not 0 so that the robot will only start execution when the PC sends it a message.

The bulk of `main`'s control is within a `monitor` statement that instructs the robot to move forward---and push forward any obstacles it encounters---by default. If the event denoted by the macro `BOUNDARY` is detected however, then it can be assumed that the robot has met the boundary of the playing field and must reverse for the same amount of time that it has moved forward. This is achieved with the aid of a timer which is always reset to zero (using `ClearTimer()`) before the robot moves forward so that it records the amount of time elapsed for one radius. After returning to where it started, the robot must then rotate slightly and duly increment the `turns` variable to record this movement and continue on its way. When a certain number of turns have been made, the program drops out of the `while` loop which continually evaluates the `monitor` statement, stops the motors and creates a data log containing the time taken (by using `Timer(0)`) and the number of obstacles cleared (by using the `obstacles` variable).

The `countObstacles` task is responsible for counting the number of obstacles encountered by the robot. It monitors the `OBSTACLE` event which is triggered when the robot's front bumper is pressed (as set up in the main task using the NQC `SetEvent()` function) and, if it has occurred, a global variable called `obstacles` is incremented. Simply incrementing this variable every time the `OBSTACLE` event is triggered is error-prone however as the robot can be pushing one obstacle and yet have its front bumper register as being "pressed" many times. To correct this, a variable called `status` is used which denotes whether the robot is currently pushing an obstacle or not. By default it is not (as denoted by the convenience macro `EXPLORING`) but once the `OBSTACLE` event is triggered, the status is changed to `PUSHING`. In this case any new `OBSTACLE` events will be ignored as redundant presses. This solution relies on the assumption that once an obstacle is encountered, the robot will succeed in pushing it out of the playing field in one radius. Upon reaching the boundary and therefore successfully removing the obstacle from the field, the status of the robot is set back to `EXPLORING` and new `OBSTACLE` events will no longer be ignored.

The `displayTimeTaken` task displays how long the program has been running in seconds on the LCD display of the robot. In order to convert the timer value---which is in 1/10ths of a second---to seconds, a simple division by 10 is used.

The `playReversingTone` task makes the robot play an intermittent tone when it is reversing. This is done by acquiring the sound facilities of the robot and continually playing the `SOUND_DOUBLE_BEEP` sound. This task is only run when the robot is reversing (it is started and stopped in the `main` task) and---due to its high-priority---it will interrupt any other use of the sound facilities.

The `playPushingTone` task is responsible for playing a continuous tone while the robot is pushing an obstacle. This task constantly checks the `status` variable (as used in the `countObstacles` task) to determine whether the robot is pushing an obstacle or not. If it is then it will acquire the sound facilities (interrupting other uses of sound because of its priority) and play a single tone until the status changes to `EXPLORING`.

The `playTune` task continually plays a tune for the duration of the robot's execution. It has the lowest priority of the music-related tasks and can therefore be interrupted by any of the others. This ensures that the robot will play a tune when it is moving forward but if it is reversing or pushing an object, another music task will have priority.

Role of the RCX Operating System Kernel and Interaction Between the NQC Program and Kernel
------------------------------------------------------------------------------------------

The RCX operating system kernel provides a "virtual machine" that provides users with an interface to memory, input/output devices, controllers and CPU. In the case of the RCX: control of the robot's motors, infrared serial communications port, sensors and main memory is required. The kernel must also support a variety of activities and manage hardware resources while being as efficient, reliable and fair as possible. Multi-programming must be supported by including some form of process scheduling which will "time multiplex" the CPU in order to run several processes concurrently.

> "At the core of the RCX is a Hitachi H8 microcontroller with 32K of external RAM. The microcontroller is used to control three motors, three sensors, and an infrared serial communications port. An on-chip, 16K ROM contains a driver that is run when the RCX is first powered up. The on-chip driver is extended by downloading 16K of firmware to the RCX. Both the driver and firmware accept and execute commands from the PC through the IR communications port. Additionally, user programs are downloaded to the RCX as byte code and are stored in a 6K region of memory."
> 
> -- Kekoa Proudfoot, "RCX internals", http://www.mralligator.com/rcx/

This means that NQC programs are compiled into byte code (using the same principle of having an interpreter or "virtual machine" as Java) that the RCX firmware then executes.

With respect to this program, the NQC variables `obstacles`, `status` and `turns` will be stored in main memory. Tasks that are running concurrently are processes that need to be scheduled simultaneously and several---specifically the music-oriented ones---require the implementation of an interrupt service routine to halt the execution of lower priority processes.

In NQC, interrupt-driven programming is implemented primarily by the `acquire` and `monitor` commands and by setting the priorities of tasks with `SetPriority()`. When two tasks are running concurrently, the one with the highest priority gets the appropriately high interrupt vector and takes precedence over other processes until it is either complete or interrupted by a process with a higher (or equal) priority. In order to do this, the kernel has to save any registers which will be used, clear the interrupt, service the interrupt (by taking appropriate action or by passing sufficient information to the calling program for it to act appropriately when required) and then restore any registers. Using `acquire` or `monitor` mimics using interrupt service routines: with the former it will interrupt any other processes using the desired resources (perhaps a motor as defined by  `ACQUIRE_OUT_A`) and with the latter it will interrupt itself when a certain event has been detected.

Events themselves (as defined by the use of `SetEvent()`) are merely polling loops that check whether a device has met a certain criterion---such as going high (`EVENT_TYPE_PRESSED`)---and when they do, set a certain designated area in memory to be appropriately high. A `monitor` statement merely polls these event-designated areas of memory and when such an event has been triggered (as defined by its relevant area of memory being set to a certain value), executes its relevant `catch` statement.
