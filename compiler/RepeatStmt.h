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
#ifndef __RepeatStmt_h
#define __RepeatStmt_h

#ifndef __Stmt_h
#include "Stmt.h"
#endif

class Expr;

class RepeatStmt : public ChainStmt
{
public:
			RepeatStmt(Expr *c, Stmt *s);
			~RepeatStmt();

	void	EmitActual(Bytecode &b);
	Stmt*	CloneActual(Mapping *b) const;

	virtual void	GetExprs(vector<Expr*> & v) const;

private:
	void	EmitRCXLoop(Bytecode &b);
	void	EmitRCXVar(Bytecode &b);
	void	EmitDecJump(Bytecode &b);
	int		EmitCountToTemp(Bytecode &b);

	Expr*	fCount;

	// flag to indicate if rcx loop counter can be used
	static bool sRCXLoopInUse;
};


#endif
