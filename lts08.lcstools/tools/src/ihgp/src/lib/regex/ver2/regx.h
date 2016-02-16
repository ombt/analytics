#ifndef __REGX_H
#define __REGX_H
/* definition of regular expression class */

/* unix headers */
#include <sysent.h>
#include <stdlib.h>

/* other headers */
#include "returns.h"
#include "regExpr.h"

/* regular expression class */
class Regx: public RegularExpr {
public:
	/* constructors and destructor */
	Regx(): RegularExpr() { anchorAtStart = anchorAtEnd = 0; }
	Regx(char *);
	~Regx() { };

	/* reset to a new regular expression */
	int newRegx(char *);
	int initRegx() { 
		anchorAtStart = anchorAtEnd = 0;
		return(initRegularExpr());
	}
	int deleteRegx() {
		anchorAtStart = anchorAtEnd = 0;
		return(deleteRegularExpr());
	}
	int match(char *string);

private:
	/* internal functions */
	int getRange(char *&, char *&, char *);
	int anything(char *&, char *&, char *);

	/* don't allow these */
	Regx(const Regx &);
	Regx &operator=(const Regx &);

protected:
	/* internal data */
	int anchorAtStart;
	int anchorAtEnd;
};

#endif
