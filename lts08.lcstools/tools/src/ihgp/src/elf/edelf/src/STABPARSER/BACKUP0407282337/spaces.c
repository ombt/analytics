#include <stdio.h>
#include <string.h>

int numberofspaces = 0;
static char spacebuf[BUFSIZ+1];

char *spaces() {
	int i=0;
	for ( ; i<BUFSIZ && i<numberofspaces; i++)
	{
		spacebuf[i] = ' ';
	}
	spacebuf[i] = '\0';
	return(spacebuf);
}

