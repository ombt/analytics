#ifndef __FSM_H
#define __FSM_H
/* definitions for fsm class */

/* headers */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <assert.h>
#include "returns.h"

/* constants */
const int FsmNoState = -1;
const int FsmNumberOfChars = 128;
const int FsmDeltaStates = 8;

/* fsm class */
class Fsm {
private:
	/* fsm data structure */
	struct FsmData {
		short *toState;
		short accepting;
	};

public:
	/* constructors and destructor */
	Fsm();
	~Fsm();

	/* maintaining fsm */
	int insertState(int, int = 0);
	int insertTransition(int, int, int);
	int removeTransition(int, int);

	/* return next state for given input and current state */
	int move(int, int);

	/* other functions */
	int init();
	int deleteAll();
	inline int getStatus() { return(status); }
	inline int isAccepting(int state) { 
		return(fsm[state].accepting); }
	void dump();

private:
	/* block these for now */
	Fsm(const Fsm &);
	Fsm &operator=(const Fsm &);

protected:
	/* internal data */
	FsmData *fsm;
	int maxState;
	int status;
};

#endif
