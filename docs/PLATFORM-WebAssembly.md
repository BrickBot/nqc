NQC for WebAssembly
===================

A new NQC platform target demonstrated by GitHub user [maehw](https://github.com/maehw) is WebAssembly, which is part of a
[broader vision](https://www.eurobricks.com/forum/index.php?/forums/topic/197807-webpbrickcom-programming-the-1st-generation-lego-mindstorms-ris-yellow-rcx-brick-from-the-webbrowser/).
The initial [WebNQC](https://github.com/maehw/WebNQC) implementation only targets WebAssembly (dropping support for Linux, Unix, Windows, and MacOS platforms),
but WebAssembly targeting support has now been incorporated into this main repository while preserving the support for other platforms.
Additionally, the Makefile has also been updated so that only one command—`make`—is needed to build from source.

With NQC compiled as **WebAssembly bytecode (WASM)**, it can run in a web browser—without any installation and independent of the machine’s platform (Windows, Linux, Unix, MacOS, etc).
