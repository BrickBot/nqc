/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * The Initial Developer of this code is David Baum.
 * Portions created by David Baum are Copyright (C) 1999 David Baum.
 * All Rights Reserved.
 *
 * Portions created by John Hansen are Copyright (C) 2005 John Hansen.
 * All Rights Reserved.
 *
 */
#ifndef __version_h
#define __version_h

#define MAJOR_VERSION	4
#define MINOR_VERSION	0
#define PATCH_VERSION 0

// 0=alpha, 2=release
#define RELEASE_STAGE	"r"
#define RELEASE_STAGE_INDEX 0

#define RELEASE_BUILD	2

#define STR_(x)	#x
#define STR(x)	STR_(x)

#define VERSION_STRING STR(MAJOR_VERSION) "." STR(MINOR_VERSION) "." STR(PATCH_VERSION) "\0"

#endif
