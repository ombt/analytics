/* functions for regular expression class are defined here */

/* unix headers */
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <memory.h>

/* other headers */
#include "fa.h"
#include "regExpr.h"

/* debugging macros */
#ifdef DEBUG
#define ERROR(msg) fprintf(stderr, "%s'%d: ERROR %s\n", __FILE__, __LINE__, msg)
#else
#define ERROR(msg) 
#endif

/* default constructor for RE */
RegularExpr::RegularExpr()
{
	initRegularExpr();
}

/* constructor with a given RE */
RegularExpr::RegularExpr(char *regularExprString)
{
	initRegularExpr();
	(void)newRegularExpr(regularExprString);
}

/* initialize regular expression */
void
RegularExpr::initRegularExpr()
{
	regExprStr = (char *)0;
	regExprStrLen = 0;
	nextChar = 0;
	status = OK;
	fa = (FA *)0;
	nextNFAstate = STARTSTATE;
	useDFA = 0;
	charPos = 0;
	return;
}

/* destructor for RE */
RegularExpr::~RegularExpr()
{
	/* delete everything */
	(void)deleteRegularExpr();
}

/* execute the regular expression */
int
RegularExpr::match(char *inbuff)
{
	Set set;
	char *pin;
	int acceptingState;

	/* execute a DFA or NFA algorithm */
	if (useDFA)
	{
		/* use a DFA machine to recognize the string */
		set += STARTSTATE;
		for (pin = inbuff; *pin != 0; pin++)
		{
			acceptingState = 0;
			set = fa->move(set, *pin, acceptingState);
			if (set.isEmpty())
			{
				status = OK;
				return(NOMATCH);
			}
		}
		set = fa->epsilonClosure(set, acceptingState);
		if ( ! acceptingState)
		{
			status = OK;
			return(NOMATCH);
		}
	}
	else
	{
		/* use an NFA machine to recognize the string */
		set += STARTSTATE;
		set = fa->epsilonClosure(set, acceptingState);
		for (pin = inbuff; *pin != 0; pin++)
		{
			acceptingState = 0;
			set = fa->move(set, *pin, acceptingState);
			if (set.isEmpty())
			{
				status = OK;
				return(NOMATCH);
			}
			set = fa->epsilonClosure(set, acceptingState);
		}
		if ( ! acceptingState)
		{
			status = OK;
			return(NOMATCH);
		}
	}

	/* all done */
	status = OK;
	return(MATCH);
}

/* reset to a new regular expression */
int
RegularExpr::newRegularExpr(char *regularExprString)
{
	int ret, save;

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
		ERROR("newRegularExpr: deleteRegularExpr failed");
		return(ret);
	}

	/* store new regular expression */
	if (regExprStr != (char *)0) delete regExprStr;
	regExprStr = new char [strlen(regularExprString)+1]; 
	if (regExprStr == (char *)0)
	{
		status = ENOMEM;
		ERROR("newRegularExpr: new failed");
		return(NOTOK);
	}
	strcpy(regExprStr, regularExprString);
	regExprStrLen = strlen(regularExprString);

	/* convert to an NFA */
	if ((ret = regularExprToNFA()) != OK)
	{
		save = status;
		(void)deleteRegularExpr();
		status = save;
		ERROR("newRegularExpr: regularExprToNFA failed");
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

	/* delete FA data */
	if (fa != (FA *)0) delete fa;
	fa = (FA *)0;

	/* all done */
	status = OK;
	return(OK);
}

/* 
 * convert an RE to a nondeterministic finite automata.
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
 */
int
RegularExpr::regularExprToNFA()
{
	int ret;

	/* check if an RE exists to parse */
	if ((regExprStr == (char *)0) || (*regExprStr == (char)0))
	{
		status = EINVAL;
		ERROR("RegularExprToNFA: EINVAL error");
		return(NOTOK);
	}
	nextChar = 0;

	/* create NFA */
	if ((fa = new FA) == (FA *)0)
	{
		status = ENOMEM;
		ERROR("RegularExprToNFA: ENOMEM error");
		return(NOTOK);
	}

	/* parse regular expression */
	nextChar = ACCEPTED;
	if ((ret = start()) != OK)
	{
		ERROR("RegularExprToNFA: start failed");
		return(ret);
	}

	/* conpress states in NFA */
	if ((ret = fa->compressStates()) != OK)
	{
		status = fa->getStatus();
		ERROR("RegularExprToNFA: compressStates failed");
		return(ret);
	}

	/* all done */
	status = OK;
	return(OK);
}

/* tokenizer for regular expression */
int
RegularExpr::getChar()
{
	/* get next character */
	if (nextChar != ACCEPTED)
	{
		return(nextChar);
	}

	/* check for end of string */
	if (nextCharIndex >= regExprStrLen)
	{
		nextChar = ENDOFSTRING;
		return(ENDOFSTRING);
	}

	/* get token */
	switch (regExprStr[nextCharIndex])
	{
	case '(':
		nextChar = LEFTPAREN;
		break;
	case ')':
		nextChar = RIGHTPAREN;
		break;
	case '|':
		nextChar = BAR;
		break;
	case '*':
		nextChar = STAR;
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
			return(ENDOFSTRING);
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
int
RegularExpr::start()
{
	int ret, NFAstartState, startState, finalState;
	
	/* get start state */
	NFAstartState = nextNFAstate++;

	/* get expression, if any */
	if ((ret = ORexpr(startState, finalState)) != OK)
	{
		ERROR("start: ORexpr failed");
		return(ret);
	}

	/* put in transition for start state */
	ret = fa->insertTransition(NFAstartState, NULLTOKEN, startState);
	if (ret != OK)
	{
		status = fa->getStatus();
		ERROR("start: insertTransition failed");
		return(ret);
	}

	/* check for end of file */
	getChar();
	if (nextChar != ENDOFSTRING)
	{
		syntaxError(__FILE__, __LINE__, "start: expecting ENDOFSTRING.\n");
		status = EINVAL;
		return(NOTOK);
	}

	/* all done */
	status = OK;
	return(OK);
}

/* OR expression nonterminal */
int
RegularExpr::ORexpr(int &ORstartState, int &ORfinalState)
{
	int ret, startState, finalState;

	/* get next character */
	getChar();

	/* check start character */
	if (IS_SPECIAL(nextChar) && (nextChar != LEFTPAREN))
	{
		syntaxError(__FILE__, __LINE__, "ORexpr: expecting a <(>.\n");
		status = EINVAL;
		return(NOTOK);
	}

	/* call AND nonterminal */
	if ((ret = ANDexpr(startState, finalState)) != OK)
	{
		ERROR("ORexpr: ANDexpr failed");
		return(ret);
	}

	/* check for any OR expressions */
	getChar();
	if (nextChar == BAR)
	{
		/* we have an OR, get OR start and final states */
		ORstartState = nextNFAstate++;
		ORfinalState = nextNFAstate++;

		/* put in transitions for AND states */
		ret = fa->insertTransition(ORstartState, NULLTOKEN, 
				       startState);
		if (ret != OK)
		{
			status = fa->getStatus();
			ERROR("ORexpr: insertTransition failed");
			return(ret);
		}
		ret = fa->insertTransition(finalState, NULLTOKEN, 
				       ORfinalState);
		if (ret != OK)
		{
			status = fa->getStatus();
			ERROR("ORexpr: insertTransition failed");
			return(ret);
		}

		/* loop thru any OR expressions */
		do {
			/* handle or expression */
			ret = ORexprtail(startState, finalState);
			if (ret != OK)
			{
				ERROR("ORexpr: ORexprtail failed");
				return(ret);
			}

			/* put in transitions for AND states */
			ret = fa->insertTransition(ORstartState, NULLTOKEN, 
					       startState);
			if (ret != OK)
			{
				status = fa->getStatus();
				ERROR("ORexpr: insertTransition failed");
				return(ret);
			}
			ret = fa->insertTransition(finalState, NULLTOKEN, 
					       ORfinalState);
			if (ret != OK)
			{
				status = fa->getStatus();
				ERROR("ORexpr: insertTransition failed");
				return(ret);
			}
	
			/* get next character */
			getChar();
		} while (nextChar == BAR);
	}
	else
	{
		/* use exiting states as start and final states */
		ORstartState = startState;
		ORfinalState = finalState;
	}

	/* all done */
	status = OK;
	return(OK);
}

/* OR expression tail nonterminal */
int
RegularExpr::ORexprtail(int &startState, int &finalState)
{
	/* get next character */
	getChar();

	/* check start character */
	if (nextChar != BAR)
	{
		syntaxError(__FILE__, __LINE__, "ORexprtail: expecting a <|>.\n");
		status = EINVAL;
		return(NOTOK);
	}
	accepted();

	/* call AND nonterminal */
	return(ANDexpr(startState, finalState));
}

/* AND expression nonterminal */
int
RegularExpr::ANDexpr(int &ANDstartState, int &ANDfinalState)
{
	int ret, startState, finalState, oldFinalState;

	/* get next character */
	getChar();

	/* check start character */
	if (IS_SPECIAL(nextChar) && (nextChar != LEFTPAREN))
	{
		syntaxError(__FILE__, __LINE__, "ANDexpr: expecting a <(>.\n");
		status = EINVAL;
		return(NOTOK);
	}

	/* call postfix nonterminal */
	if ((ret = postfix(startState, finalState)) != OK)
	{
		ERROR("ANDexpr: postfix failed");
		return(ret);
	}

	/* check if any AND expressions */
	getChar();
	if ((( ! IS_SPECIAL(nextChar)) || (nextChar == LEFTPAREN)) && 
	     ( ! IS_EOS(nextChar)))
	{
		/* save start state for AND expression */
		ANDstartState = startState;

		/* loop thru AND expressions */
		do {
			/* save final state */
			oldFinalState = finalState;

			/* handle and-tail expression */
			ret = ANDexprtail(startState, finalState);
			if (ret != OK)
			{
				ERROR("ANDexpr: ANDexprtail failed");
				return(ret);
			}

			/* merge previous final state and new start state */
			ret = fa->mergeStates(oldFinalState, startState);
			if (ret != OK)
			{
				status = fa->getStatus();
				ERROR("ANDexpr: mergeState failed");
				return(ret);
			}

			/* get next character */
			getChar();
		} while ((( ! IS_SPECIAL(nextChar)) || 
			(nextChar == LEFTPAREN)) && ( ! IS_EOS(nextChar)));

		/* save final state for AND expression */
		ANDfinalState = finalState;
	}
	else
	{
		/* return start and final states for AND expression */
		ANDstartState = startState;
		ANDfinalState = finalState;
	}

	/* all done */
	status = OK;
	return(OK);
}

/* AND expression tail nonterminal */
int
RegularExpr::ANDexprtail(int &startState, int &finalState)
{
	/* get next character */
	getChar();

	/* check start character */
	if (IS_SPECIAL(nextChar) && (nextChar != LEFTPAREN))
	{
		syntaxError(__FILE__, __LINE__, "ANDexprtail: expecting a <(>.\n");
		status = EINVAL;
		return(NOTOK);
	}

	/* call postfix nonterminal */
	return(postfix(startState, finalState));
}

/* postfix nonterminal */
int
RegularExpr::postfix(int &startState, int &finalState)
{
	int ret;

	/* get next character */
	getChar();

	/* check start character */
	if (IS_SPECIAL(nextChar) && (nextChar != LEFTPAREN))
	{
		syntaxError(__FILE__, __LINE__, "postfix: expecting a <(>.\n");
		status = EINVAL;
		return(NOTOK);
	}

	/* call primary nonterminal */
	if ((ret = primary(startState, finalState)) != OK)
	{
		ERROR("postfix: primary failed");
		return(ret);
	}

	/* call postfix tail nonterminal */
	return(postfixtail(startState, finalState));
}

/* postfix tail nonterminal */
int
RegularExpr::postfixtail(int &startState, int &finalState)
{
	int ret, KstartState, KfinalState;

	/* get next character */
	getChar();

	/* check start character */
	if (IS_SPECIAL(nextChar) && (nextChar == STAR))
	{
		/* get states for Kleene closure */
		KstartState = nextNFAstate++;
		KfinalState = nextNFAstate++;

		/* insert states for Kleene closure */
		ret = fa->insertTransition(KstartState, NULLTOKEN, startState);
		if (ret != OK)
		{
			status = fa->getStatus();
			ERROR("postfixtail: insertTransition failed");
			return(ret);
		}
		ret = fa->insertTransition(KstartState, NULLTOKEN, KfinalState);
		if (ret != OK)
		{
			status = fa->getStatus();
			ERROR("postfixtail: insertTransition failed");
			return(ret);
		}
		ret = fa->insertTransition(finalState, NULLTOKEN, startState);
		if (ret != OK)
		{
			status = fa->getStatus();
			ERROR("postfixtail: insertTransition failed");
			return(ret);
		}
		ret = fa->insertTransition(finalState, NULLTOKEN, KfinalState);
		if (ret != OK)
		{
			status = fa->getStatus();
			ERROR("postfixtail: insertTransition failed");
			return(ret);
		}

		/* return new states */
		startState = KstartState;
		finalState = KfinalState;

		/* accept star */
		accepted();
	}

	/* all done */
	status = OK;
	return(OK);
}

/* primary nonterminal */
int
RegularExpr::primary(int &startState, int &finalState)
{
	int ret;

	/* get next character */
	getChar();

	/* check start character */
	if (IS_SPECIAL(nextChar))
	{
		/* check for opening parenthesis */
		if (nextChar != LEFTPAREN)
		{
			syntaxError(__FILE__, __LINE__, "primary: expecting a <(>.\n");
			status = EINVAL;
			return(NOTOK);
		}
		accepted();

		/* call OR expression */
		if ((ret = ORexpr(startState, finalState)) != OK)
		{
			ERROR("primary: ORexpr failed");
			return(ret);
		}
		
		/* check for closing parenthesis */
		getChar();
		if (nextChar != RIGHTPAREN)
		{
			syntaxError(__FILE__, __LINE__, "primary: expecting a <)>.\n");
			status = EINVAL;
			return(NOTOK);
		}
		accepted();
	}
	else
	{
		/* insert state transition */
		startState = nextNFAstate++;
		finalState = nextNFAstate++;
		ret = fa->insertTransition(startState, nextChar, finalState);
		if (ret != OK)
		{
			status = fa->getStatus();
			ERROR("primary: insertTransition failed");
			return(ret);
		}
		fprintf(stderr, "(pos, char) = (%d, %c)\n",
			++charPos, nextChar);

		/* accept any other character */
		accepted();
	}

	/* all done */
	status = OK;
	return(OK);
}

/* print out an error msg */
void
RegularExpr::syntaxError(char *fileName, int lineNo, char *msg)
{
	fprintf(stderr, "%s'%d: SYNTAX ERROR, %s\n", fileName, lineNo, msg);
	return;
}

/* convert an NFA to a DFA */
int
RegularExpr::NFAtoDFA()
{
	int ret;
	if ((ret = fa->NFAtoDFA()) != OK) 
	{
		useDFA = 0;
		status = fa->getStatus();
	}
	else
	{
		useDFA = 1;
		status = OK;
	}
	return(ret);
}

