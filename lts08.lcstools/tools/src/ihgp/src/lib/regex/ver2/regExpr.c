/* functions for regular expression class are defined here */

/* unix headers */
#include <sysent.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <memory.h>

/* other headers */
#include "regExpr.h"
#include "fsm.h"
#include "debug.h"

/* tokenizer constants */ 
static const int Special = 0x100;
static const int LeftParen = ('(' | Special);
static const int RightParen = (')' | Special);
static const int Bar = ('|' | Special);
static const int Star = ('*' | Special);
static const int EndOfString = 0x200;
static const int Accepted = 0x400;
static const int Delete = 0x7f;
static const int EndOfRegExpr = Delete;

/* tokenizer definitions */ 
#define IS_SPECIAL(spchar) (((spchar) & Special) == Special)
#define IS_EOS(spchar) (((spchar) & EndOfString) == EndOfString)

/* default constructor for RE */
RegularExpr::RegularExpr()
{
	initRegularExpr();
}

/* constructor with a given RE */
RegularExpr::RegularExpr(char *regularExprString)
{
	initRegularExpr();
	newRegularExpr(regularExprString);
}

/* initialize regular expression */
int
RegularExpr::initRegularExpr()
{
	followpos.init();
	fsm.init();
	symbols.clear();
	regExprStr = (char *)0;
	regExprStrLen = 0;
	nextCharIndex = 0;
	nextChar = 0;
	charPos = 0;
	status = OK;
	return(OK);
}

/* destructor for RE */
RegularExpr::~RegularExpr()
{
	/* delete everything */
	deleteRegularExpr();
}

/* reset to a new regular expression */
int
RegularExpr::newRegularExpr(char *regularExprString)
{
	int ret;

	/* check if a new RE was given */
	if ((regularExprString == (char *)0) ||
	    (*regularExprString == (char)0))
	{
		/* free everything */
		return(deleteRegularExpr());
	}

	/* delete existing regular expression */
	if ((ret = deleteRegularExpr()) != OK)
	{
		ERROR("deleteRegularExpr failed", status);
		return(ret);
	}
	initRegularExpr();

	/* store new regular expression and add "end-of-RE" character */
	int regexlen = strlen(regularExprString);
	regExprStr = new char [regexlen+4]; 
	if (regExprStr == (char *)0)
	{
		status = ENOMEM;
		ERROR("new for string failed", status);
		return(NOTOK);
	}
	regExprStr[0] = '(';
	strcpy(regExprStr+1, regularExprString);
	regExprStr[regexlen+1] = ')';
	regExprStr[regexlen+2] = EndOfRegExpr;
	regExprStr[regexlen+3] = 0;
	regExprStrLen = regexlen + 3;

	/* convert RE to an FA */
	if ((ret = regularExprToFa()) != OK)
	{
		ERROR("regExprToFa failed", status);
		return(ret);
	}

	/* minimize the number of FA states */
	if ((ret = minimizeFaStates()) != OK)
	{
		ERROR("minimizeFaStates failed", status);
		return(ret);
	}

	/* all done */
	status = OK;
	return(OK);
}

/* delete present regular expression */
int
RegularExpr::deleteRegularExpr()
{
	/* delete RE data */
	if (regExprStr != (char *)0) delete regExprStr;
	regExprStr = (char *)0;
	regExprStrLen = 0;
	nextChar = 0;

	/* delete all semantic RE info */
	followpos.deleteAll();

	/* delete FSM data */
	fsm.deleteAll();

	/* all done */
	status = OK;
	return(OK);
}

/* 
 * convert an RE to a deterministic finite automata.
 * the BNF for an RE is as follows.
 *
 * start 	-> ORexpr
 * ORexpr 	-> ANDexpr |
 * 		   ORexpr "|" ANDexpr
 * ANDexpr	-> postfix |
 *		   ANDexpr postfix
 * postfix	-> primary |
 *		   primary "*"
 * primary	-> "any character" |
 *		   "(" ORexpr ")"
 *
 * the above is not LL(1). converting to LL(1), you get the 
 * following.
 *
 * start 	-> ORexpr
 * ORexpr 	-> ANDexpr ORexprtail
 * ORexprtail	-> "|" ANDexpr ORexprtail | ""
 * ANDexpr	-> postfix ANDexprtail
 * ANDexprtail	-> postfix ANDexprtail | ""
 * postfix	-> primary postfixtail
 * postfixtail	-> "" | "*"
 * primary	-> "any character" |
 *		   "(" ORexpr ")"
 *
 * start sets for the above non-terminals.
 *
 * start(start) = start(ORexpr)
 * start(ORexpr) = { "(", "any non-special character" }
 * start(ORexprtail) = { "|", empty }
 * start(ANDexpr) = { "(", "any non-special character" }
 * start(ANDexprtail) = { "(", "any non-special character" }
 * start(postfix) = { "(", "any non-special character" }
 * start(postfixtail) = { "*", empty }
 * start(primary) = { "(", "any non-special character" }
 *
 * special characters = { "(", ")", "|", "*", "\" }
 * these must be escaped with a back slash.
 *
 * the algorithm described on pages 135 to 141 in the "Dragon" book
 * is used to build a DFA which recognizes the regular expression.
 */
int
RegularExpr::regularExprToFa()
{
	Semantic root;

	/* check if an RE exists to parse */
	if ((regExprStr == (char *)0) || (*regExprStr == (char)0))
	{
		status = EINVAL;
		ERROR("EINVAL error for regular expression", status);
		return(NOTOK);
	}
	nextChar = 0;

	/* parse regular expression */
	nextChar = Accepted;
	if ((root = startSymbol()) != OK)
	{
		ERROR("start failed", status);
		return(NOTOK);
	}

	/* build first state in DFA */
	int nextDFAstate = 0;
	SetState *proot = new SetState(root.firstpos, nextDFAstate++);
	if (proot == (SetState *)0)
	{
		status = ENOMEM;
		ERROR("ENOMEM for root", status);
		return(NOTOK);
	}
	SetStateGroup Dstates;
	if ((status = Dstates.getStatus()) != OK)
	{
		ERROR("SetStateConstructor failed for Dstates", status);
		return(NOTOK);
	}
	SetStateGroup Dunmarked;
	if ((status = Dunmarked.getStatus()) != OK)
	{
		ERROR("SetStateConstructor failed for Dunmarked", status);
		return(NOTOK);
	}
	Dstates.insert(proot);
	if ((status = Dstates.getStatus()) != OK)
	{
		ERROR("insert failed for Dstates", status);
		return(NOTOK);
	}
	Dunmarked.insert(proot);
	if ((status = Dunmarked.getStatus()) != OK)
	{
		ERROR("insert failed for Dunmarked", status);
		return(NOTOK);
	}

	/* cycle thru and determine DFA states */
	while ( ! Dunmarked.isEmpty())
	{
		/* iterate thru unmarked states */
		SetStateGroupIterator unmarkedIter(Dunmarked);
		if ((status = Dunmarked.getStatus()) != OK)
		{
			ERROR("SetStateGroupIter constructor failed for Dunmarked", status);
			return(NOTOK);
		}
		SetState *punmarked;
		while ((punmarked = unmarkedIter()) != (SetState *)0)
		{
			/* remove unmarked state */
			Dunmarked.remove((int)*punmarked);
			if ((status = Dunmarked.getStatus()) != OK)
			{
				ERROR("remove failed for Dunmarked", status);
				return(NOTOK);
			}

			/* scan input symbols */
			if (scanSymbols(Dstates, Dunmarked, 
				       *punmarked, nextDFAstate) != OK)
			{
				ERROR("scanSymbols failed", status);
				return(NOTOK);
			}
		}
	}

	/* all done */
	status = OK;
	return(OK);
}

/* scan input symbols */
int
RegularExpr::scanSymbols(SetStateGroup &Dstates, SetStateGroup &Dunmarked, 
			 SetState &unmarked, int &nextState)
{
	/* cycle thru symbols */
	SetIterator symbolsIter(symbols);
	if ((status = symbolsIter.getStatus()) != OK)
	{
		ERROR("SetIterator constructor failed for symbols", status);
		return(NOTOK);
	}
	int symbol;
	SetState newState;
	while ((symbol = symbolsIter()) != LASTMEMBER)
	{
		/* clear new state */
		newState.Set::clear();
		newState.deleteAll();
		newState.init();

		/* cycle thru positions in unmarked state */
		SetStateIterator unmarkedIter(unmarked);
		if ((status = unmarkedIter.getStatus()) != OK)
		{
			ERROR("SetStateIterator constructor failed for unmarked", status);
			return(NOTOK);
		}
		int position;
		while ((position = unmarkedIter()) != LASTMEMBER)
		{
			/* compare symbol at position to current symbol */
			SetState *pstate = followpos.find(position);
			if (pstate == (SetState *)0)
			{
				status = EINVAL;
				ERRORI("position not found", position, status);
				return(NOTOK);
			}

			/* check for a match in symbols */
			if ((char)*pstate != symbol) continue;
			if ((char)*pstate == EndOfRegExpr)
			{
				/* accepting state */
				unmarked.setAccepting(1);
				fsm.insertState((int)unmarked, 1);
			}

			/* construct new state */
			newState |= *pstate;
		}

		/* was a new state found */
		if (newState.isEmpty())
		{
			/* transition NOT allowed, state is empty */
			continue;
		}

		/* transition is allowed, we have a state */
		SetState *pnew = Dstates.find(newState);
		if (pnew == (SetState *)0)
		{
			/* create and insert new state */
			pnew = new SetState(newState, nextState++);
			if ((status = pnew->getStatus()) != OK)
			{
				status = ENOMEM;
				ERROR("ENOMEM for new state", status);
				return(NOTOK);
			}
			Dstates.insert(pnew);
			if ((status = Dstates.getStatus()) != OK)
			{
				ERROR("Dstates insert failed", status);
				return(NOTOK);
			}
			Dunmarked.insert(pnew);
			if ((status = Dunmarked.getStatus()) != OK)
			{
				ERROR("Dunmarked insert failed", status);
				return(NOTOK);
			}
		}

		/* save transition */
		fsm.insertTransition((int)unmarked, symbol, (int)*pnew);
	}

	/* all done */
	status = OK;
	return(OK);
}

/* minimize the number of states in DFA */
int
RegularExpr::minimizeFaStates()
{
	/* all done */
	status = OK;
	return(OK);
}

/* tokenizer for regular expression */
int
RegularExpr::getChar()
{
	/* get next character */
	if (nextChar != Accepted)
	{
		return(nextChar);
	}

	/* check for end of string */
	if (nextCharIndex >= regExprStrLen)
	{
		nextChar = EndOfString;
		return(EndOfString);
	}

	/* get token */
	switch (regExprStr[nextCharIndex])
	{
	case '(':
		nextChar = LeftParen;
		break;
	case ')':
		nextChar = RightParen;
		break;
	case '|':
		nextChar = Bar;
		break;
	case '*':
		nextChar = Star;
		break;
	case '\\':
		/* something was escaped */
		switch (regExprStr[++nextCharIndex])
		{
		case '(':
		case ')':
		case '|':
		case '*':
		case '\\':
			nextChar = regExprStr[nextCharIndex];
			break;
		default:
			status = EINVAL;
			return(EndOfString);
		}
	default:
		nextChar = regExprStr[nextCharIndex];
		break;
	}

	/* return token */
	status = OK;
	nextCharIndex++;
	return(nextChar);
}

/* entry point into regular expression parser */
RegularExpr::Semantic
RegularExpr::startSymbol()
{
	Semantic ret;
	
	/* get expression, if any */
	if ((ret = ORexpr()) != OK)
	{
		ERROR("ORexpr failed", status);
		return(ret);
	}

	/* check for end of file */
	getChar();
	if (nextChar != EndOfString)
	{
		status = EINVAL;
		ERROR("startSymbol: expecting EndOfString.", status);
		return((Semantic)NOTOK);
	}

	/* all done */
	status = OK;
	return(ret);
}

/* OR expression nonterminal */
RegularExpr::Semantic
RegularExpr::ORexpr()
{
	Semantic ret1, ret2;

	/* get next character */
	getChar();

	/* check start character */
	if (IS_SPECIAL(nextChar) && (nextChar != LeftParen))
	{
		status = EINVAL;
		ERROR("ORexpr: expecting a <(>.", status);
		return((Semantic)NOTOK);
	}

	/* call AND nonterminal */
	if ((ret1 = ANDexpr()) != OK)
	{
		ERROR("ORexpr: ANDexpr failed", status);
		return(ret1);
	}

	/* check for any OR expressions */
	getChar();
	if (nextChar == Bar)
	{
		/* loop thru any OR expressions */
		do {
			/* handle or expression */
			if ((ret2 = ORexprtail()) != OK)
			{
				ERROR("ORexpr: ORexprtail failed", status);
				return(ret2);
			}

			/* semantic processing */
			ret1.firstpos |= ret2.firstpos;
			ret1.lastpos |= ret2.lastpos;
			ret1.nullable = ret1.nullable || ret2.nullable;
	
			/* get next character */
			getChar();
		} while (nextChar == Bar);
	}

	/* all done */
	status = OK;
	return(ret1);
}

/* OR expression tail nonterminal */
RegularExpr::Semantic
RegularExpr::ORexprtail()
{
	/* get next character */
	getChar();

	/* check start character */
	if (nextChar != Bar)
	{
		status = EINVAL;
		ERROR("ORexprtail: expecting a <|>.", status);
		return((Semantic)NOTOK);
	}
	accepted();

	/* call AND nonterminal */
	return(ANDexpr());
}

/* AND expression nonterminal */
RegularExpr::Semantic
RegularExpr::ANDexpr()
{
	Semantic ret1, ret2;

	/* get next character */
	getChar();

	/* check start character */
	if (IS_SPECIAL(nextChar) && (nextChar != LeftParen))
	{
		status = EINVAL;
		ERROR("ANDexpr: expecting a <(>.", status);
		return((Semantic)NOTOK);
	}

	/* call postfix nonterminal */
	if ((ret1 = postfix()) != OK)
	{
		ERROR("ANDexpr: postfix failed", status);
		return(ret1);
	}

	/* check if any AND expressions */
	getChar();
	if ((( ! IS_SPECIAL(nextChar)) || (nextChar == LeftParen)) && 
	     ( ! IS_EOS(nextChar)))
	{
		/* loop thru AND expressions */
		do {
			/* handle and-tail expression */
			if ((ret2 = ANDexprtail()) != OK)
			{
				ERROR("ANDexpr: ANDexprtail failed", status);
				return(ret2);
			}

			/* construct followpos sets */
			int ret1state;
			SetStateIterator ret1Iter(ret1.lastpos);
			while ((ret1state = ret1Iter()) != LASTMEMBER)
			{
				SetState *pfollowpos = followpos.find(ret1state);
				if (pfollowpos == (SetState *)0) continue;
				*pfollowpos |= ret2.firstpos;
			}

			/* semantic processing */
			if (ret1.nullable) 
				ret1.firstpos |= ret2.firstpos;
			if (ret2.nullable)
				ret1.lastpos |= ret2.lastpos;
			else
				ret1.lastpos = ret2.lastpos;
			ret1.nullable = ret1.nullable && ret2.nullable;

			/* get next character */
			getChar();
		} while ((( ! IS_SPECIAL(nextChar)) || 
			(nextChar == LeftParen)) && ( ! IS_EOS(nextChar)));
	}

	/* all done */
	status = OK;
	return(ret1);
}

/* AND expression tail nonterminal */
RegularExpr::Semantic
RegularExpr::ANDexprtail()
{
	/* get next character */
	getChar();

	/* check start character */
	if (IS_SPECIAL(nextChar) && (nextChar != LeftParen))
	{
		status = EINVAL;
		ERROR("ANDexprtail: expecting a <(>.", status);
		return((Semantic)NOTOK);
	}

	/* call postfix nonterminal */
	return(postfix());
}

/* postfix nonterminal */
RegularExpr::Semantic
RegularExpr::postfix()
{
	Semantic ret;

	/* get next character */
	getChar();

	/* check start character */
	if (IS_SPECIAL(nextChar) && (nextChar != LeftParen))
	{
		status = EINVAL;
		ERROR("postfix: expecting a <(>.", status);
		return((Semantic)NOTOK);
	}

	/* call primary nonterminal */
	if ((ret = primary()) != OK)
	{
		ERROR("postfix: primary failed", status);
		return(ret);
	}

	/* call postfix tail nonterminal */
	return(postfixtail(ret));
}

/* postfix tail nonterminal */
RegularExpr::Semantic
RegularExpr::postfixtail(Semantic &record)
{
	/* get next character */
	getChar();

	/* check start character */
	if (IS_SPECIAL(nextChar) && (nextChar == Star))
	{
		/* accept star */
		accepted();

		/* construct followpos sets */
		int recstate;
		SetStateIterator recordIter(record.lastpos);
		while ((recstate = recordIter()) != LASTMEMBER)
		{
			SetState *pfollowpos = followpos.find(recstate);
			if (pfollowpos == (SetState *)0) continue;
			*pfollowpos |= record.firstpos;
		}

		/* semantic processing */
		record.nullable = 1;
		record.status = OK;
	}

	/* all done */
	status = OK;
	return(record);
}

/* primary nonterminal */
RegularExpr::Semantic
RegularExpr::primary()
{
	Semantic ret;

	/* get next character */
	getChar();

	/* check start character */
	if (IS_SPECIAL(nextChar))
	{
		/* check for opening parenthesis */
		if (nextChar != LeftParen)
		{
			status = EINVAL;
			ERROR("primary: expecting a <(>.", status);
			return((Semantic)NOTOK);
		}
		accepted();

		/* call OR expression */
		if ((ret = ORexpr()) != OK)
		{
			ERROR("primary: ORexpr failed", status);
			return(ret);
		}
		
		/* check for closing parenthesis */
		getChar();
		if (nextChar != RightParen)
		{
			status = EINVAL;
			ERROR("primary: expecting a <)>.", status);
			return((Semantic)NOTOK);
		}
		accepted();
	}
	else
	{
		/* semantic processing */
		ret.nullable = 0;
		ret.firstpos += ++charPos;
		ret.lastpos += charPos;
		ret.status = OK;

		/* create record for followpos */
		Set newSet;
		SetState *pfollowpos = new SetState(newSet, charPos, nextChar);
		if (pfollowpos == (SetState *)0) 
		{
			status = ENOMEM;
			ERROR("primary: ENOMEM for followpos", status);
			return((Semantic)NOTOK);
		}
		followpos.insert(pfollowpos);
		if ((status = followpos.getStatus()) != OK)
		{
			ERROR("ANDexpr: followpos.insert failed", status);
			return((Semantic)NOTOK);
		}

		/* store symbol */
		symbols += nextChar;

		/* accept any other character */
		accepted();
	}

	/* all done */
	status = OK;
	return(ret);
}

/* accept token */
void 
RegularExpr::accepted()
{
	if (nextChar != EOF) nextChar = Accepted;
	return;
}

/* execute RE for a character string */
int
RegularExpr::match(char *string)
{
	int newstate = 0, state = 0;
	start = string;
	length = 0;
	for (char *pstr = string; *pstr != 0; pstr++)
	{
		newstate = fsm.move(state, (int)*pstr);
		if ((status = fsm.getStatus()) != OK) return(NOTOK);
		if (newstate == FsmNoState) break;
		state = newstate;
	}
	if (fsm.isAccepting(state))
	{
		status = MATCH;
		length = pstr-string;
		return(MATCH);
	}
	else
	{
		status = NOMATCH;
		length = 0;
		return(NOMATCH);
	}
}
