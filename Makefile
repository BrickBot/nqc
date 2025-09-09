# Makefile for nqc
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# The Initial Developer of this code is David Baum.
# Portions created by David Baum are Copyright (C) 1999 David Baum.
# All Rights Reserved.
#
# Portions created by John Hansen are Copyright (C) 2005 John Hansen.
# All Rights Reserved.
#
#   original author:
#		Dave Baum <dbaum@enteract.com>
#
#   other contributors:
#		Rodd Zurcher <rbz@enteract.com>
#		Patrick Nadeau <pnadeau@wave.home.com>
#		Jonathan W. Miner <jminer@fcmail.com>
#		Matthew Sheets
#		Maeh W. <maehw@posteo.de>
#
#
.SUFFIXES: .cpp .c

# Project-related names (all lowercase by convention)
ORG = brickbot
PACKAGE = nqc

#
# Pick your C++ compiler.
#
CXX ?= ${CXX}
# CXX ?= g++
ifeq ($(origin CXX_FOR_BUILD), undefined)
  CXX_FOR_BUILD := $(CXX)
endif

#
# Pick your YACC processor
#
YACC ?= bison -y
# YACC ?= yacc

#
# Define the FLEX processor
# NOTE: lex will not work
#
FLEX ?= flex -Cfe

#
# Link in any necessary C++ libraries
#
LIBS ?= -lstdc++

#
# Toolchain for h8300-hitachi-coff
#
H8300_TOOLPREFIX ?= h8300-hitachi-coff-
H8300_LD ?= $(H8300_TOOLPREFIX)ld
H8300_AS ?= $(H8300_TOOLPREFIX)as
H8300_OBJDUMP ?= $(H8300_TOOLPREFIX)objdump

H8300_FOUND := $(shell $(H8300_AS) --version > /dev/null 2>&1 && echo found)
ifneq ($(H8300_FOUND), found)
  $(warning h8300-hitachi-coff binutils toolchain not found, using pre-built files)
endif

#
# Toolchain for Emscripten
#
EMSCRIPTEN_MAKE ?= emmake
# NOTE: "emmake --version" does not work as a test and returns a non-zero error code
EMSCRIPTEN_FOUND := $(shell which $(EMSCRIPTEN_MAKE) > /dev/null 2>&1 && echo found)
ifneq ($(EMSCRIPTEN_FOUND), found)
  $(warning Emscripten "$(EMSCRIPTEN_MAKE)" toolchain not found, skipping Emscripten build)
endif

#
# Toolchain for pandoc
#
PANDOC ?= pandoc
PANDOC_FOUND := $(shell $(PANDOC) --version > /dev/null 2>&1 && echo found)
ifneq ($(PANDOC_FOUND), found)
  $(warning pandoc not found, skipping documentation build)
endif


# installation defaults

# Normalize for path prepending (remove any trailing slash)
# Cannot use \$(realpath \$(dir)) since this path might not exist
ifneq ($(DESTDIR),)
DESTDIR := $(patsubst %/,%,$(DESTDIR))
endif

ifneq ($(prefix),)
prefix := $(patsubst %/,%,$(prefix))
endif

prefix      ?= /opt/stow/$(PACKAGE)
exec_prefix ?= $(prefix)
bindir      ?= $(exec_prefix)/bin
includedir  ?= $(prefix)/include
datarootdir ?= $(prefix)/share
docdir      ?= $(datarootdir)/doc/$(PACKAGE)
mandir      ?= $(datarootdir)/man
man1dir     ?= $(mandir)/man1
manext      ?= 1

# other commands
CP ?= cp -f
MKDIR ?= mkdir -p
MV ?= mv -f
RM ?= rm -f
DOXYGEN ?= doxygen

# Common local include directories
INCLUDE_DIRS = platform rcxlib nqc compiler $(GEN_DIR)/rcxlib $(GEN_DIR)/compiler
INCLUDES = $(addprefix -I, $(INCLUDE_DIRS))

# Common compiler flags
CFLAGS += $(INCLUDES) -Wall
CFLAGS_FOR_BUILD += $(INCLUDES) -Wall

# Default configuration values
OBJ_SUBDIR_NAME ?= obj
H8300_SUBDIR_NAME ?= h8300
UTILS_SUBDIR_NAME ?= utils
EXEC_SUBDIR_NAME ?= bin
GEN_SUBDIR_NAME ?= generated
DOCS_SUBDIR_NAME ?= docs

BUILD_DIR ?= build
OBJ_DIR ?= $(BUILD_DIR)/$(OBJ_SUBDIR_NAME)
H8300_DIR ?= $(BUILD_DIR)/$(H8300_SUBDIR_NAME)
EXEC_DIR ?= $(BUILD_DIR)/$(EXEC_SUBDIR_NAME)
UTILS_DIR ?= $(BUILD_DIR)/$(UTILS_SUBDIR_NAME)
GEN_DIR ?= $(BUILD_DIR)/$(GEN_SUBDIR_NAME)
DOCS_DIR ?= $(BUILD_DIR)/$(DOCS_SUBDIR_NAME)


# Default to NO USB tower support and NO TCP support.
# USB and TCP support can be enabled
# via the platform-specific settings below.
USBOBJ ?= RCX_USBTowerPipe_none
TCPOBJ ?= RCX_TcpPipe_none

DEFAULT_USB_NAME ?= "/dev/usb/legousbtower0"
DEFAULT_DEVICE_NAME ?= "usb"

#
# Platform specific settings
#
OSTYPE := $(strip $(shell uname -s))

ifneq (,$(strip $(findstring $(TARGETTYPE), JS-WebAssembly)))
	# WebAssembly embedded in JavaScript
	CXX = emcc
	OBJ_SUBDIR_NAME = wobj
	EXEC_SUBDIR_NAME = js-wasm
	EXEC_EXT = .js

	# Emscripten optimization flags documentation
	# - https://emscripten.org/docs/optimizing/Optimizing-Code.html#optimizing-code
	# - https://emscripten.org/docs/tools_reference/emcc.html#emcc-compiler-optimization-options
	CFLAGS += -Os
	
	# Documentation for various Emscripten flags
	# - Full List:    https://github.com/emscripten-core/emscripten/blob/main/src/settings.js
	# - Modularize:   https://emscripten.org/docs/getting_started/FAQ.html#can-i-use-multiple-emscripten-compiled-programs-on-one-web-page
	# - Environment:  https://emscripten.org/docs/getting_started/FAQ.html#can-i-build-javascript-that-only-runs-on-the-web
	# - Single File:  https://emscripten.org/docs/compiling/Building-Projects.html?highlight=SINGLE_FILE#emscripten-linker-output-files
	# - Target JavaScript instead of WASM:  -s WASM=0
	CFLAGS_EXEC += --shell-file ./emscripten/webnqc_shell.html -s EXPORT_NAME=createWebNqc  -s EXPORTED_RUNTIME_METHODS='["callMain","FS"]' \
		-s INVOKE_RUN=false  -s MODULARIZE=1  -s ENVIRONMENT=web  -s SINGLE_FILE
else ifneq (,$(strip $(findstring $(OSTYPE), Darwin)))
	# Mac OS X
	LIBS += -framework IOKit -framework CoreFoundation
	USBOBJ = RCX_USBTowerPipe_osx
	CXX = c++
	CFLAGS += -O3 -std=c++11 -Wno-deprecated-register
else ifneq (,$(strip $(findstring $(OSTYPE), Linux)))
	# Linux
	USBOBJ = RCX_USBTowerPipe_linux
	TCPOBJ = RCX_TcpPipe_linux
	DEFAULT_SERIAL_NAME ?= "/dev/ttyS0"
	# Timeout value is 200 in kernel driver module legousbtower.c
	LEGO_TOWER_SET_READ_TIMEOUT ?= 200
	CFLAGS += -DLEGO_TOWER_SET_READ_TIMEOUT='$(LEGO_TOWER_SET_READ_TIMEOUT)' -Wno-deprecated
else ifneq (,$(strip $(findstring $(OSTYPE), CYGWIN)))
	# Cygwin
	# USBOBJ = RCX_USBTowerPipe_linux
	TCPOBJ = RCX_TcpPipe_linux
	DEFAULT_DEVICE_NAME ?= "tcp"
	DEFAULT_SERIAL_NAME ?= "/dev/ttyS0"
	# Timeout value is 200 in kernel driver module legousbtower.c
	LEGO_TOWER_SET_READ_TIMEOUT ?= 200
	CFLAGS += -DLEGO_TOWER_SET_READ_TIMEOUT='$(LEGO_TOWER_SET_READ_TIMEOUT)' -Wno-deprecated
else ifneq (,$(findstring $(OSTYPE), SunOS))
	# Solaris
	CFLAGS += -DSOLARIS
else ifneq (,$(strip $(findstring $(OSTYPE), FreeBSD)))
	# FreeBSD
	USBOBJ = RCX_USBTowerPipe_fbsd
	DEFAULT_SERIAL_NAME?= "/dev/cuad0"
	CFLAGS += -Wno-deprecated
else ifneq (,$(strip $(findstring $(OSTYPE), OpenBSD)))
	# OpenBSD i386
	DEFAULT_SERIAL_NAME ?= "/dev/cua00"
	CFLAGS += -O2 -std=gnu++98 -pipe
else
	# default Unix build without USB support
	CFLAGS += -O2
endif

CXX:=$(TOOLPREFIX)$(CXX)

#
# If the serial port is explicitly set, use it.
#
ifneq ($(strip $(DEFAULT_SERIAL_NAME)),)
  CFLAGS += -DDEFAULT_SERIAL_NAME='$(DEFAULT_SERIAL_NAME)'
endif

ifneq ($(strip $(DEFAULT_USB_NAME)),)
  CFLAGS += -DDEFAULT_USB_NAME='$(DEFAULT_USB_NAME)'
endif

ifneq ($(strip $(DEFAULT_DEVICE_NAME)),)
CFLAGS += -DDEFAULT_DEVICE_NAME='$(DEFAULT_DEVICE_NAME)'
endif

#
# Debug builds for most Clang/GCC environments.
# This implies -DDEBUG_TIMEOUT
#
#CFLAGS += -DDEBUG -DPDEBUG -g -O0

#
# Object files
#
OBJ = $(addprefix $(OBJ_DIR)/, $(NQCOBJ) $(COBJ) $(RCXOBJ) $(POBJ))

RCXOBJS = RCX_Cmd RCX_Disasm RCX_Image RCX_Link RCX_Log \
	RCX_Target RCX_Pipe RCX_PipeTransport RCX_Transport \
	RCX_SpyboticsLinker RCX_SerialPipe \
	$(USBOBJ) $(TCPOBJ)
RCXOBJ = $(addprefix rcxlib/, $(addsuffix .o, $(RCXOBJS)))

POBJS = PStream PSerial_unix PHashTable PListS PDebug StrlUtil
POBJ = $(addprefix platform/, $(addsuffix .o, $(POBJS)))

COBJS = AsmStmt AssignStmt BlockStmt Bytecode Conditional \
	CondParser DoStmt Expansion Fragment IfStmt JumpStmt \
	lexer Macro parse PreProc Program RepeatStmt \
	AssignMathStmt Stmt Symbol TaskStmt WhileStmt Error \
	AutoFree parse_util Expr GosubStmt Scope InlineStmt \
	CallStmt CaseStmt SwitchStmt MonitorStmt AcquireStmt \
	DeclareStmt ScopeStmt ForStmt CatchStmt LabelStmt \
	GotoStmt Compiler Buffer Mapping FunctionDef ExprStmt \
	AtomExpr IncDecExpr BinaryExpr UnaryExpr ValueExpr \
	TypeExpr ModExpr EventSrcExpr SensorExpr ArrayExpr \
	TaskIdExpr RelExpr LogicalExpr NegateExpr IndirectExpr \
	NodeExpr ShiftExpr TernaryExpr VarAllocator VarTranslator \
	Resource AddrOfExpr DerefExpr GosubParamStmt
COBJ = $(addprefix compiler/, $(addsuffix .o, $(COBJS)))

NQCOBJS = nqc SRecord DirList CmdLine
NQCOBJ = $(addprefix nqc/, $(addsuffix .o, $(NQCOBJS)))


all: info exec emscripten-emmake default-check-fastdl maybe-docs-user

exec: info $(EXEC_DIR)/$(PACKAGE)$(EXEC_EXT)

$(EXEC_DIR)/$(PACKAGE)$(EXEC_EXT): compiler/parse.cpp $(OBJ)
	$(MKDIR) $(dir $@)
	$(CXX) $(CFLAGS) $(CFLAGS_EXEC) -o $@ $(OBJ) $(LIBS) $(LDFLAGS)

#
# Emscripten build for WebAssembly
#
emscripten-emmake:
ifeq ($(EMSCRIPTEN_FOUND), found)
	$(EMSCRIPTEN_MAKE) make exec TARGETTYPE=JS-WebAssembly
else
	@echo -e "WARNING: \"$(EMSCRIPTEN_MAKE)\" not found; skipping Emscripten build"
endif

#
# general rule for compiling
#
$(OBJ_DIR)/%.o: %.cpp | compiler/parse.cpp
	$(MKDIR) $(dir $@)
	$(CXX) -c $(CFLAGS) $< -o $@

#
# clean up stuff
#
clean: clean-parser clean-lexer clean-obj clean-build

clean-build:
	-$(RM) -r $(BUILD_DIR)/*

clean-obj:
	-$(RM) */*.o

clean-parser:
	-$(RM) compiler/parse.cpp compiler/parse.tab.h

clean-lexer:
	-$(RM) compiler/lexer.cpp

#
# create the parser files (parse.cpp and parse.tab.h)
#
compiler/parse.tab.h: compiler/parse.cpp
compiler/parse.cpp: compiler/parse.y
	cd compiler ; \
	$(YACC) -d parse.y ; \
	$(MV) y.tab.c parse.cpp ; \
	$(MV) y.tab.h parse.tab.h

#
# create the lexer file (lexer.cpp)
#
compiler/lexer.cpp: compiler/lex.l
	cd compiler ; \
	$(FLEX) lex.l

#
# mkdata utility
#
$(UTILS_DIR)/mkdata: mkdata/mkdata.cpp nqc/SRecord.cpp
	$(MKDIR) $(dir $@)
	$(CXX_FOR_BUILD) $(CFLAGS_FOR_BUILD) $(LDFLAGS_FOR_BUILD) -o $@ $^

#
# NQH files
#
nqh: $(GEN_DIR)/compiler/rcx1_nqh.h $(GEN_DIR)/compiler/rcx2_nqh.h

$(GEN_DIR)/compiler/%_nqh.h: compiler/%.nqh $(UTILS_DIR)/mkdata
	$(MKDIR) $(dir $@)
	$(UTILS_DIR)/mkdata $< $@ $*_nqh

$(OBJ_DIR)/compiler/Compiler.o: $(GEN_DIR)/compiler/rcx1_nqh.h $(GEN_DIR)/compiler/rcx2_nqh.h

#
# rcxnub.h & rcxnub_odd.h
#
nub: $(GEN_DIR)/rcxlib/rcxnub.h $(GEN_DIR)/rcxlib/rcxnub_odd.h

$(GEN_DIR)/rcxlib/rcxnub.h: $(H8300_DIR)/rcxlib/fastdl.srec $(UTILS_DIR)/mkdata
	$(MKDIR) $(dir $@)
	$(UTILS_DIR)/mkdata -s $< $@ rcxnub

$(GEN_DIR)/rcxlib/rcxnub_odd.h: $(H8300_DIR)/rcxlib/fastdl_odd.srec $(UTILS_DIR)/mkdata
	$(MKDIR) $(dir $@)
	$(UTILS_DIR)/mkdata -s $< $@ rcxnub_odd

$(OBJ_DIR)/rcxlib/RCX_Link.o: $(GEN_DIR)/rcxlib/rcxnub.h $(GEN_DIR)/rcxlib/rcxnub_odd.h

#
# fastdl.srec & fastdl_odd.srec
#
FASTDL = fastdl fastdl_odd
fastdl: $(FASTDL:%=$(H8300_DIR)/rcxlib/%.srec)

ifeq ($(H8300_FOUND), found)

$(H8300_DIR)/rcxlib/fastdl.o: rcxlib/fastdl.s
	$(MKDIR) $(dir $@)
	$(H8300_AS) -o $@ $<

$(H8300_DIR)/rcxlib/fastdl_odd.o: rcxlib/fastdl.s
	$(MKDIR) $(dir $@)
	$(H8300_AS) --defsym odd=1 -o $@ $<

$(H8300_DIR)/rcxlib/%.srec: $(H8300_DIR)/rcxlib/%.o
	$(MKDIR) $(dir $@)
	$(H8300_LD) -Ttext 0x8000 -e __start --oformat srec -o $@ $<
	chmod -x $@

dis: $(FASTDL:%=$(H8300_DIR)/rcxlib/%.dis.s)
%.dis.s: %.srec
	$(H8300_OBJDUMP) -m h8300 -D $< > $@ || rm $@

default-snapshot-fastdl: $(FASTDL:%=$(H8300_DIR)/rcxlib/%.srec)
	$(MKDIR) default
	$(CP) $(FASTDL:%=$(H8300_DIR)/rcxlib/%.srec) default

default-check-fastdl: $(FASTDL:%=$(H8300_DIR)/rcxlib/%.srec.check)

$(H8300_DIR)/rcxlib/%.srec.check: default/%.srec $(H8300_DIR)/rcxlib/%.srec
	@echo "Please run make default-snapshot-fastdl and commit if this fail:"
	diff -u $^
	touch $@

else

$(H8300_DIR)/rcxlib/%.srec: default/%.srec
	$(MKDIR) $(dir $@)
	$(CP) $< $@

default-snapshot-fastdl:
	@echo "no h8300-hitachi-coff toolchain"
	false

default-check-fastdl:
	@echo "no h8300-hitachi-coff toolchain, cannot check pre-built files"

endif

#
# Use these targets to use the default parser/lexer files.  This is handy if
# your system does not have a suitable flex and/or yacc tool.
#
default-parser:
	$(CP) default/parse.cpp default/parse.tab.h nqc

default-lexer:
	$(CP) default/lexer.cpp nqc

#
# This is used to create a default parser and lexer files for later use.
# You shouldn't need to do this as part of a port.
#
DEF_FILES = compiler/parse.cpp compiler/parse.tab.h \
	    compiler/lexer.cpp
default-snapshot: default-snapshot-fastdl $(DEF_FILES)
	$(MKDIR) default
	$(CP) $(DEF_FILES) default


#
# Generate user doc content
#
rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
HTML_DOCS=$(patsubst %.md,$(BUILD_DIR)/%.html,$(call rwildcard,$(DOCS_SUBDIR_NAME)/,*.md))

ifeq ($(PANDOC_FOUND), found)
maybe-docs-user:   docs-user
maybe-install-doc: install-doc
else
maybe-docs-user:
maybe-install-doc:
endif

$(BUILD_DIR)/%.html: %.md
	-$(MKDIR) $(dir $@)
	$(PANDOC) --from=gfm --to=html --lua-filter=links-md-to-html.lua --output=$@ $<

docs-user-markdown: docs-user-content $(HTML_DOCS)

docs-user-content:
	rsync -av --exclude='*.md' docs/ "$(DOCS_DIR)"

docs-user: docs-user-markdown

#
# Generate API docs. Not part of a port.
#
docs-api:
	@$(DOXYGEN) Doxyfile

#
# Generate docs
#
docs: docs-user docs-api

#
# Installation of binary and man page
#
install: info exec maybe-install-doc
	-$(MKDIR) $(DESTDIR)$(bindir)
	$(CP) -r $(EXEC_DIR)/* $(DESTDIR)$(bindir)
	-$(MKDIR) $(DESTDIR)$(man1dir)
	$(CP) nqc-man.man $(DESTDIR)$(man1dir)/$(PACKAGE).$(manext)
	-$(MKDIR) $(DESTDIR)$(includedir)/$(PACKAGE)
	$(CP) nqh-include/*.nqh $(DESTDIR)$(includedir)/$(PACKAGE)

install-doc: docs-user
	-$(MKDIR) $(DESTDIR)$(docdir)
	$(CP) -r $(DOCS_DIR)/* $(DESTDIR)$(docdir)

#
# Print some info about the environment
#
info:
	@echo Building for: $(OSTYPE)
	@echo DESTDIR=$(DESTDIR)
	@echo prefix=$(prefix)
	@echo exec_prefix=$(exec_prefix)
	@echo bindir=$(bindir)
	@echo includedir=$(includedir)
	@echo datarootdir=$(datarootdir)
	@echo docdir=$(docdir)
	@echo mandir=$(mandir)
	@echo man1dir=$(man1dir)
	@echo manext=$(manext)
	@echo STOW_TARGET=$(STOW_TARGET)
	@echo STOW_DIR=$(STOW_DIR)
	@echo STOW_PACKAGE=$(STOW_PACKAGE)
	@echo STOW_STANDARD_ARGS=$(STOW_STANDARD_ARGS)
	@echo STOW_PREREQ_TARGET=$(STOW_PREREQ_TARGET)
	@echo BUILD_DIR=$(BUILD_DIR)
	@echo OBJ_DIR=$(OBJ_DIR)
	@echo H8300_DIR=$(H8300_DIR)
	@echo UTILS_DIR=$(UTILS_DIR)
	@echo GEN_DIR=$(GEN_DIR)
	@echo EXEC_DIR=$(EXEC_DIR)
	@echo EXEC_EXT=$(EXEC_EXT)
	@echo USBOBJ=$(USBOBJ)
	@echo TCPOBJ=$(TCPOBJ)
	@echo YACC=$(YACC)
	@echo FLEX=$(FLEX)
	@echo LIBS=$(LIBS)
	@echo CXX=$(CXX)
	@echo CFLAGS=$(CFLAGS)
	@echo CFLAGS_EXEC=$(CFLAGS_EXEC)
	@echo OBJ=$(OBJ)
	@echo HTML_DOCS=$(HTML_DOCS)
	@echo H8300_TOOLPREFIX=$(H8300_TOOLPREFIX)
	@echo H8300_LD=$(H8300_LD)
	@echo H8300_AS=$(H8300_AS)
	@echo H8300_OBJDUMP=$(H8300_OBJDUMP)
	@echo H8300_FOUND=$(H8300_FOUND)

# Include the common Makefile utility targets
include Makefile.utility
