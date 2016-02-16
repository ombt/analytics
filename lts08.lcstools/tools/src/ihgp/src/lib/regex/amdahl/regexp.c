/*	Copyright (c) 1984 AT&T
	All rights reserved

	THIS IS UNPUBLISHED PROPRIETARY
	SOURCE CODE OF AT&T
	The copyright notice above does not
	evidence any actual or intended
	publication of such source code.
*/
static char sccsid[] = "@(#)regexp.c	1.1";
#include <stdio.h>
#include <signal.h>
#include "db.h"

/* defines for regular expression matching */
#define INIT    register char *sp = instring;
#define GETC()          (*sp++)
#define PEEKC()         (*sp)
#define UNGETC(C)	(--sp)
#define RETURN(c)       return;
#define ERROR(c)        regerr(c)

#include "regexp.h"

/*static int sed,nbra;	/* needed on some machines for regexp.h */

regerr(c)
int c;
{
	error(E_GENERAL,"bad regular expression in where clause\n");
	switch(c) {
	case 11:
		error(E_GENERAL,"Range endpoint too large.\n");
		break;
	case 16:
		error(E_GENERAL,"Bad number.\n");
		break;
	case 25:
		error(E_GENERAL,"\"\\digit\" out of range.\n");
		break;
	case 36:
		error(E_GENERAL,"Illegal or missing delimiter.\n");
		break;
	case 41:
		error(E_GENERAL,"No remembered search string.\n");
		break;
	case 42:
		error(E_GENERAL,"\\( \\) imbalance.\n");
		break;
	case 43:
		error(E_GENERAL,"Too many \\(.\n");
		break;
	case 44:
		error(E_GENERAL,"More than 2 numbers given in \\{ \\}.\n");
		break;
	case 45:
		error(E_GENERAL,"} expected after \\.\n");
		break;
	case 46:
		error(E_GENERAL,"First number exceeds second in \\{ \\}.\n");
		break;
	case 49:
		error(E_GENERAL,"[ ] imbalance.\n");
		break;
	case 50:
		error(E_GENERAL,"Regular expression overflow.\n");
		break;
	}
	kill(0,SIGINT);
}
