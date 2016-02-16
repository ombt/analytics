#ifndef __REGEXPR_H
#define __REGEXPR_H
/* definition of regular expression class for a tokenizer */

/* unix headers */
#include <sysent.h>
#include <stdlib.h>

/* other headers */
#include "returns.h"
#include "set.h"
#include "setState.h"
#include "fsm.h"

/* regular expression class */
class RegularExpr {
public:
	/* semantic record */
	class Semantic {
	public:
		/* constructors and destructor */
		Semantic() { nullable = 0; status = OK; }
		Semantic(int stat) { nullable = 0; status = stat; }
		Semantic(const Semantic &src) { 
			status = src.status; nullable = src.nullable;
			firstpos = src.firstpos; lastpos = src.lastpos; }
		~Semantic() { status = OK; }

		/* operations */
		inline operator int() { return(status); }
		inline Semantic &operator=(int stat) {
			status = stat; return(*this); }
		Semantic &operator=(const Semantic &src) { 
			status = src.status; nullable = src.nullable;
			firstpos = src.firstpos; lastpos = src.lastpos; 
			return(*this); }
		inline void dump(char *fn, int ln) {
			fprintf(stderr, 
				"%s'%d: dumping semantic record...\n", fn, ln);
			fprintf(stderr, "nullable = %d\n", nullable);
			fprintf(stderr, "firstpos = \n");
			firstpos.dump();
			fprintf(stderr, "lastpos = \n");
			lastpos.dump();
		}

		/* data */
		int status;
		int nullable;
		SetState firstpos;
		SetState lastpos;
	};

public:
	/* constructors and destructors */
	RegularExpr();
	RegularExpr(char *);
	~RegularExpr();

	/* reset to a new regular expression */
	int initRegularExpr();
	int deleteRegularExpr();
	int newRegularExpr(char *);
	int regularExprToFa();
	int minimizeFaStates();
	int scanSymbols(SetStateGroup &, SetStateGroup &, SetState &, int &);
	virtual int match(char *);

	/* other routines */
	inline int getStatus() { return(status); }
	inline int move(int from, int input) { 
		int to = fsm.move(from, input);
		status = fsm.getStatus();
		return(to);
	}
	inline void dump() { fsm.dump(); }

	/* parse regular expression */
	Semantic startSymbol();
	Semantic ORexpr();
	Semantic ORexprtail();
	Semantic ANDexpr();
	Semantic ANDexprtail();
	Semantic postfix();
	Semantic postfixtail(Semantic &);
	Semantic primary();
	int getChar();
	void accepted();

private:
	/* don't allow these */
	RegularExpr(const RegularExpr &);
	RegularExpr &operator=(const RegularExpr &);

public:
	/* public data */
	char *start;
	int length;

protected:
	/* internal data */
	int status;
	char *regExprStr;
	int regExprStrLen;
	int nextCharIndex;
	int nextChar;
	int charPos;
	SetStateGroup followpos;
	Set symbols;
	Fsm fsm;
};

#endif
