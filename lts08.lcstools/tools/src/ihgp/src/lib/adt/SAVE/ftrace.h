#ifndef __FTRACE_H
#define __FTRACE_H
// function trace class definition

// headers
#include <stdlib.h>
#include <iostream.h>

// macro
#ifdef DEBUG
#define FTRACE() ftrace(__FILE__, __LINE__)
#else
#define FTRACE()
#endif

// tuple class
class ftrace {
public:
        // constructors and destructor
        ftrace(char *flnm, int lnno):
		fileName(new char [strlen(flnm)+1]), lineNumber(lnno) {
		strcpy(fileName, flnm);
		cerr << "Entering " << fileName << "'" << lineNumber << endl;
	};
        ~ftrace() {
		cerr << "Returning from " << fileName << "'" << lineNumber << endl;
		delete [] fileName;
	};

public:
        // internal data
	char *fileName;
	int lineNumber;
};

#endif
