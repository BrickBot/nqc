# NQC on Linux

## LEGO USB Tower

Most Linux distributions ship with Linux kernels which include support for the LEGO USB Tower by default.

To check if your Linux has support for the LEGO USB Tower open a terminal and show the kernel ring buffer using this command:

```
sudo dmesg --follow
```

(If your `dmesg` does not support the `--follow` option, plug in the tower first and call `dmesq` afterwards.)

Now plug in the LEGO USB Tower. The kernel ring buffer should lines similar to those below:
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

## Build NQC

### Prerequisite

In order to build NQC you need

- `git` to download the source code (optional - you can also download a ZIP archive)
- a toolchain, `yacc` and `flex` to build the sources
- `emscripten` for WebAssembly support

On Debian based distributions you can install those using:

```
sudo apt update
sudo apt install git build-essential yacc flex emscripten
```

### Download NQC sources

Goto https://github.com/BrickBot/nqc to dowload the ZIP archive (`<>` Code -> Download ZIP).

Or use `git`:

```
git clone https://github.com/BrickBot/nqc.git
```

### Compile NQC

Change into the NQC source directory

```
cd nqc
```
and build it:

```
make
```

## Upload Firmware to RCX

Change into the NQC source directory (if not already there):

```
cd nqc
```

```
./bin/nqc  -Susb -firmware firmware/firm0332.lgo
```

## Run test programm

Change into the NQC source directory (if not already there):

```
cd nqc
```

Upload the test program:

```
./bin/nqc  -Susb -d test.nqc
```

See [Getting started](./README.md?#getting-started) for details.


