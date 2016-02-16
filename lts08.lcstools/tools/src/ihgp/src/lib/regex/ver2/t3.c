#include "regExpr.h"
#include "debug.h"

main(int, char **argv)
{
	RegularExpr regx(argv[1]);
	if (regx.getStatus() != OK)
	{
		ERROR("main: regular expr constructor failed.", 
		      regx.getStatus());
		return(2);
	}
	regx.dump();
	switch(regx.match(argv[2]))
	{
	case MATCH:
		DUMPS("we have a match; length matched ... ");
		DUMPI(regx.length);
		break;
	case NOMATCH:
		DUMPS("we do not have a match !!!");
		break;
	default:
		ERROR("execRegularExpr failed.", NOTOK);
		return(2);
	}
	return(0);
}
