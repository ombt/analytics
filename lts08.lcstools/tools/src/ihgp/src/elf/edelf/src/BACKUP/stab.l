%{
/* standard unix headers */
#include <stdio.h>
#include <string.h>

/* other headers */
#include "stabyacc.h"

#ifdef YYDEBUG
#define YYDUMP() fprintf(stderr, "token is <%s>.\n", yytext)
#define MYECHO ECHO
#else
#define YYDUMP() 
#define MYECHO
#endif

#define GETTOKEN(tokenId) { \
	MYECHO; \
	YYDUMP(); \
	strcpy(yylval.string, yytext); \
	return(tokenId); \
}

%}
name			[^;:"']+
string			(\".*\"|\'\.*\')
real			[0-9]+"."[0-9]+([eE][-+]?[0-9]+)?
decimal			[+-]?[0-9]+
hexadecimal		[A-F0-9]+
whitespace		[ \t]+
newline			"\n"

%%

{whitespace}	MYECHO;
{newline}	MYECHO;
[a-zA-Z]	{
		MYECHO;
		YYDUMP();
		strcpy(yylval.string, yytext);
		return(*yytext);
		}
{name}		GETTOKEN(NAME);
{string}	GETTOKEN(STRING);
{real}		GETTOKEN(REAL);
{decimal}	GETTOKEN(INTEGER);
{hexadecimal}	GETTOKEN(HEXADECIMAL);
.		{
		MYECHO;
		YYDUMP();
		strcpy(yylval.string, yytext);
		return(*yytext);
		}

%%

int yywrap(void) { return(1); }

#if 0
main()
{
	while (yylex() != 0);
}
#endif
