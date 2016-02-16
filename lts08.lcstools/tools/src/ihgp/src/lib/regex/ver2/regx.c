/* functions for regular expression class are defined here */

/* unix headers */
#include <sysent.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <memory.h>
#include <string.h>

/* other headers */
#include "regx.h"
#include "set.h"
#include "debug.h"

/* constants */
static const int MaxRegxSize = 8192;
static const int MaxChar = 0177;

/* constructor with a given RE */
Regx::Regx(char *regularExprString): RegularExpr()
{
	anchorAtStart = anchorAtEnd = 0;
	newRegx(regularExprString);
}

/* initialize to a new regular expression */
int
Regx::newRegx(char *regxString)
{
	char tmpRe[MaxRegxSize+1];

	/* check input */
	if ((regxString == (char *)0) || (*regxString == (char)0))
	{
		status = EINVAL;
		ERROR("EINVAL for regxString.", status);
		return(NOTOK);
	}

	/* convert compact RE to wordy type */
	char *ptmp = tmpRe; 
	char *pre = regxString;

	/* check for special case of first character */
	if (*pre == '^')
	{
		/* pattern is anchor at beginning */
		pre++;
		anchorAtStart = 1;
	}

	while (*pre != 0 && ptmp <= (tmpRe+MaxRegxSize))
	{
		/* switch on character */
		switch (*pre)
		{
		case '[':
			/* we have a range */
			if (getRange(pre, ptmp, tmpRe) != OK)
			{
				ERROR("getRange failed .", status);
				return(NOTOK);
			}
			break;
		case '\\':
			/* escaped character, copy two characters */
			*ptmp++ = *pre++;
			*ptmp++ = *pre++;
			break;
		case '.':
			/* match anything */
			if (anything(pre, ptmp, tmpRe) != OK)
			{
				ERROR("anything failed .", status);
				return(NOTOK);
			}
			break;
		default:
			/* just copy character */
			*ptmp++ = *pre++;
			break;
		}
	}

	/* check for errors */
	if (*pre != 0 && ptmp >= (tmpRe+MaxRegxSize))
	{
		status = EFAULT;
		ERROR("regular expression is to long.", status);
		return(NOTOK);
	}
	*ptmp = 0;

	/* check for anchor at end */
	if (*pre == 0 && *(pre-1) == '$')
	{
		/* pattern is anchor at end */
		pre++;
		anchorAtEnd = 1;

		/* remove dollar sign from expanded regular expression */
		*--ptmp = 0;
	}
	tmpRe[MaxRegxSize] = 0;

	/* build fsm for RE */
	return(newRegularExpr(tmpRe));
}

/* translate ranges */
int
Regx::getRange(char *&pre, char *&ptmp, char *tmp)
{
	/* check arguments */
	if (pre == (char *)0 || ptmp == (char *)0 || tmp == (char *)0)
	{
		status = EINVAL;
		ERROR("regular expression or buffer is null.", status);
		return(NOTOK);
	}
	if (*pre++ != '[')
	{
		status = EINVAL;
		ERROR("range does not start with a '['.", status);
		return(NOTOK);
	}

	/* check for complentary ranges */
	int complement = 0;
	if (*pre == '^')
	{
		pre++;
		complement = 1;
	}

	/* construct characters in range */
	Set charsInRange(128);
	while (*pre != 0 && *pre != ']')
	{
		/* check for ranges */
		if (*(pre+1) != '-')
		{
			charsInRange += (int)*pre++;
			continue;
		}

		/* we have a range, get start and end */
		int lstart = *pre;
		int lend = *pre;
		pre += 2;
		switch (*pre)
		{
		case 0:
		case ']':
			status = EINVAL;
			ERROR("invalid range.", status);
			return(NOTOK);
		case '\\':
			lend = *++pre;
			pre++;
			break;
		default:
			lend = *pre++;
			break;
		}

		/* set members */
		for (int c = lstart; c <= lend; c++)
		{
			charsInRange += c;
		}
	}

	/* check for end of range */
	if (*pre++ != ']')
	{
		status = EINVAL;
		ERROR("range does not end with a ']'.", status);
		return(NOTOK);
	}

	/* complement range, if required */
	if (complement)
	{
		Set tmp(128);
		tmp.fill();
		charsInRange = tmp - charsInRange;
	}

	/* expand range */
	int c;
	SetIterator rangeIter(charsInRange);
	if ((status = rangeIter.getStatus()) != OK)
	{
		ERROR("rangeIter failed.", status);
		return(NOTOK);
	}
	*ptmp++ = '(';
	while ((c = rangeIter()) != LASTMEMBER && c < MaxChar)
	{
		switch (c)
		{
		case 0:
			continue;
		case '(':
		case ')':
		case '|':
		case '*':
		case '\\':
			*ptmp++ = '\\';
		default:
			*ptmp++ = c;
			*ptmp++ = '|';
			break;
		}
	}
	if (*--ptmp != '|')
	{
		status = EINVAL;
		ERROR("empty range.", status);
		return(NOTOK);
	} 
	*ptmp++ = ')';
	*ptmp = 0;

	/* all done */
	status = OK;
	return(OK);
}

/* execute regular expression */
int
Regx::match(char *string)
{
	/* check if string is anchored at beginning */
	if (anchorAtStart)
	{
		switch(RegularExpr::match(string))
		{
		case MATCH:
			if (anchorAtEnd && length != strlen(string))
			{
				length = 0;
				return(NOMATCH);
			}
			else
			{
				return(MATCH);
			}
		case NOMATCH:
			start = string;
			length = 0;
			return(NOMATCH);
		default:
			start = string;
			length = 0;
			return(NOTOK);
		}
	}

	/* no anchor at beginning */
	for (char *pstr = string; *pstr != 0; pstr++)
	{
		switch(RegularExpr::match(pstr))
		{
		case MATCH:
			if (anchorAtEnd && 
			   (pstr - string + length != strlen(string)))
			{
				length = 0;
				return(NOMATCH);
			}
			else
			{
				return(MATCH);
			}
		case NOMATCH:
			break;
		default:
			start = string;
			length = 0;
			return(NOTOK);
		}
	}

	/* no match */
	start = string;
	length = 0;
	return(NOMATCH);
}

/* match anything */
int
Regx::anything(char *&pre, char *&ptmp, char *tmp)
{
	/* check arguments */
	if (pre == (char *)0 || ptmp == (char *)0 || tmp == (char *)0)
	{
		status = EINVAL;
		ERROR("regular expression or buffer is null.", status);
		return(NOTOK);
	}
	if (*pre++ != '.')
	{
		status = EINVAL;
		ERROR("anything does not start with a '.'.", status);
		return(NOTOK);
	}

#ifdef USESTATIC
	strcpy(ptmp, 
		"("
		"\001|\002|\003|\004|\005|\006|\007|\010|"
		"\011|\012|\013|\014|\015|\016|\017|\020|"
		"\021|\022|\023|\024|\025|\026|\027|\030|"
		"\031|\032|\033|\034|\035|\036|\037|\040|"
		"\041|\042|\043|\044|\045|\046|\047|\\\050|"
		"\\\051|\\\052|\053|\054|\055|\056|\057|\060|"
		"\061|\062|\063|\064|\065|\066|\067|\070|"
		"\071|\072|\073|\074|\075|\076|\077|\100|"
		"\101|\102|\103|\104|\105|\106|\107|\110|"
		"\111|\112|\113|\114|\115|\116|\117|\120|"
		"\121|\122|\123|\124|\125|\126|\127|\130|"
		"\131|\132|\133|\134|\135|\136|\137|\140|"
		"\141|\142|\143|\144|\145|\146|\147|\150|"
		"\151|\152|\153|\154|\155|\156|\157|\160|"
		"\161|\162|\163|\164|\165|\166|\167|\170|"
		"\171|\172|\173|\\\174|\175|\176"
		")");
	ptmp = tmp + strlen(tmp);
#else
	/* construct all characters */
	Set allChars(128);
	allChars.fill();

	/* write regular expression */
	int c;
	SetIterator rangeIter(allChars);
	if ((status = rangeIter.getStatus()) != OK)
	{
		ERROR("rangeIter failed.", status);
		return(NOTOK);
	}
	*ptmp++ = '(';
	while ((c = rangeIter()) != LASTMEMBER && c < MaxChar)
	{
		switch (c)
		{
		case 0:
			continue;
		case '(':
		case ')':
		case '|':
		case '*':
		case '\\':
			*ptmp++ = '\\';
		default:
			*ptmp++ = c;
			*ptmp++ = '|';
			break;
		}
	}
	if (*--ptmp != '|')
	{
		status = EINVAL;
		ERROR("empty range.", status);
		return(NOTOK);
	} 
	*ptmp++ = ')';
	*ptmp = 0;
#endif

	/* all done */
	status = OK;
	return(OK);
}
