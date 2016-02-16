#ifndef __REGEXPR_H
#define __REGEXPR_H
/* definition of regular expression class for a tokenizer */

/* unix headers */
#include <stdio.h>

/* other headers */
#include "fa.h"

/* return definitions */
#define OK 0
#define NOTOK -1
#define NOMATCH -2
#define MATCH -3

/* tokenizer definitions */ 
#define SPECIAL 0x100
#define IS_SPECIAL(spchar) (((spchar) & SPECIAL) == SPECIAL)
#define LEFTPAREN ('(' | SPECIAL)
#define RIGHTPAREN (')' | SPECIAL)
#define BAR ('|' | SPECIAL)
#define STAR ('*' | SPECIAL)
#define BACKSLASH ('\\' | SPECIAL)
#define ENDOFSTRING 0x200
#define IS_EOS(spchar) (((spchar) & ENDOFSTRING) == ENDOFSTRING)
#define ACCEPTED 0x400

/* regular expression class */
class RegularExpr {
public:
	/* constructors and destructors */
	RegularExpr();
	RegularExpr(char *regularExprString);
	~RegularExpr();

	/* execute the regular expression */
	int match(char *inbuff);

	/* reset to a new regular expression */
	int newRegularExpr(char *regularExprString);

	/* build finite state machine */
	int regularExprToNFA();
	int NFAtoDFA();

	/* initialize regular expression */
	void initRegularExpr();

	/* delete existing regular expression */
	int deleteRegularExpr();

	/* other routines */
	inline int getStatus();
	inline FA *getFA();

private:
	/* don't allow these for now */
	RegularExpr(const RegularExpr &);
	RegularExpr &operator=(const RegularExpr &);

protected:
	/* parse regular expression */
	int start();
	int ORexpr(int &startState, int &finalState);
	int ORexprtail(int &startState, int &finalState);
	int ANDexpr(int &startState, int &finalState);
	int ANDexprtail(int &startState, int &finalState);
	int postfix(int &startState, int &finalState);
	int postfixtail(int &startState, int &finalState);
	int primary(int &startState, int &finalState);
	int getChar();
	inline void accepted();
	void syntaxError(char *fileName, int lineNo, char *msg);

protected:
	/* internal data */
	int status;
	char *regExprStr;
	int regExprStrLen;
	int nextCharIndex;
	int nextChar;
	int nextNFAstate;
	int useDFA;
	int charPos;
	FA *fa;
};

inline int
RegularExpr::getStatus()
{
	return(status);
}

inline FA *
RegularExpr::getFA()
{
	return(fa);
}

inline void
RegularExpr::accepted()
{
	if (nextChar != EOF) nextChar = ACCEPTED;
}
#endif
