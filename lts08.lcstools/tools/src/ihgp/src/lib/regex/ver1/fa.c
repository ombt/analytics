/* member functions for finite automata class */

/* unix headers */
#include <stdio.h>
#include <errno.h>

/* other headers */
#include "fa.h"

/* debugging macros */
#ifdef DEBUG
#define ERROR(msg) fprintf(stderr, "%s'%d: ERROR %s\n", __FILE__, __LINE__, msg)
#else
#define ERROR(msg) 
#endif

/* default constructor for FAstate */
FAstate::FAstate()
{
	state = NOSTATE;
	input = new FAinputList;
	if (input == (FAinputList *)0)
	{
		status = ENOMEM;
		ERROR("FAstate, ENOMEM for input");
	}
	else if ((status = input->getStatus()) != OK)
	{
		ERROR("FAstate, FAinputList constructor failed");
	}
}

/* constructor with a state value */
FAstate::FAstate(int newState)
{
	state = newState;
	input = new FAinputList;
	if (input == (FAinputList *)0)
	{
		status = ENOMEM;
		ERROR("FAstate, ENOMEM for input");
	}
	else if ((status = input->getStatus()) != OK)
	{
		ERROR("FAstate, FAinputList constructor failed");
	}
}

/* destructor for FAstate */
FAstate::~FAstate()
{
	if (input != (FAinputList *)0) delete input;
	input = 0;
	status = OK;
}

/* default constructor for FAstateList */
FAstateList::FAstateList()
{
	stateSet = new Set;
	if (stateSet == (Set *)0)
	{
		status = ENOMEM;
		ERROR("FAstateList, ENOMEM for stateSet");
	}
	else if ((status = stateSet->getStatus()) != OK)
	{
		ERROR("FAstateList, Set constructor failed");
	}
}

/* copy constructor */
FAstateList::FAstateList(const FAstateList &src)
{
	copyFAstateList(src);
}

void
FAstateList::copyFAstateList(const FAstateList &src)
{
	delete stateSet;
	stateSet = new Set(*src.stateSet);
	if (stateSet == (Set *)0)
	{
		status = ENOMEM;
		ERROR("FAstate, ENOMEM for stateSet");
		return;
	}
	else if ((status = stateSet->getStatus()) != OK)
	{
		ERROR("FAstate, Set constructor failed");
		return;
	}
	FAstate *pstate;
	FAstateIterator stateIter(src);
	if ((status = stateIter.getStatus()) != OK)
	{
		ERROR("copyFAstateList, FAstateIterator constructor failed");
		return;
	}
	while ((pstate = stateIter()) != (FAstate *)0)
	{
		FAstate *pnewState = new FAstate(pstate->state);
		if (pnewState == (FAstate *)0)
		{
			status = ENOMEM;
			ERROR("copyFAstateList, ENOMEM for pnewState");
			return;
		}
		if ((status = pnewState->status) != OK)
		{
			ERROR("copyFAstateList, FAstate constructor failed");
			return;
		}
		append(pnewState);
		if (status != OK)
		{
			ERROR("copyFAstateList, append failed");
			return;
		}
	}
	stateIter = src;
	if ((status = stateIter.getStatus()) != OK)
	{
		ERROR("copyFAstateList, FAstateIterator operator = failed");
		return;
	}
	while ((pstate = stateIter()) != (FAstate *)0)
	{
		FAinput *pinput;
		int inState = pstate->state;
		FAstate *pinState = findState(inState);
		if (pinState == (FAstate *)0)
		{
			status = EINVAL;
			ERROR("copyFAstateList, findState failed");
			return;
		}
		FAinputIterator inputIter;
		inputIter = *pstate->input;
		while ((pinput = inputIter()) != (FAinput *)0)
		{
			int input = pinput->getInput();
			int outState = pinput->getState()->state;
			FAstate *poutState = findState(outState);
			if (poutState == (FAstate *)0)
			{
				status = EINVAL;
				ERROR("copyFAstateList, findState failed");
				return;
			}
			FAinput *pnewInput = new FAinput(input, poutState);
			if (pnewInput == (FAinput *)0)
			{
				status = ENOMEM;
				ERROR("copyFAstateList, ENOMEM for FAinput");
				return;
			}
			if ((status = pnewInput->getStatus()) != OK)
			{
				ERROR("copyFAstateList, FAinput constructor failed");
				return;
			}
			pinState->input->append(pnewInput);
			if ((status = pinState->input->getStatus()) != OK)
			{
				ERROR("copyFAstateList, append failed");
				return;
			}
		}
	}
	return;
}

/* destructor for FAstateList */
FAstateList::~FAstateList()
{
	delete stateSet;
	status = OK;
}

/* append a link to list */
FAstateList &
FAstateList::append(FAstate *newState)
{
	List::append((Link *)newState);
	if (status == OK) *stateSet += newState->state;
	return(*this);
}

/* prepend a link to list */
FAstateList &
FAstateList::prepend(FAstate *newState)
{
	List::prepend((Link *)newState);
	if (status == OK) *stateSet += newState->state;
	return(*this);
}

/* remove a link from list */
FAstateList &
FAstateList::remove(FAstate *oldState)
{
	*stateSet -= oldState->state;
	List::remove((Link *)oldState);
	return(*this);
}

/* find a state in a list */
FAstate *
FAstateList::findState(int state)
{
	FAstate *pfa;
	FAstateIterator faIter(*this);

	/* check if state exists */
	if ( ! stateSet->isMember(state)) return((FAstate *)0);

	/* check interator constructor */
	if ((status = faIter.getStatus()) != OK)
	{
		ERROR("findState, FAstateIterator constructor failed");
		return((FAstate *)0);
	}

	/* cycle thru all states looking for state */
	while ((pfa = faIter()) != (FAstate *)0)
	{
		/* check for a match */
		if (pfa->state == state) break;
	}

	/* return what was found */
	if ((status = faIter.getStatus()) != OK)
	{
		ERROR("findState, FAstateIterator operator () failed");
		return((FAstate *)0);
	}
	return(pfa);
}


/* merge two states in FA list */
int
FAstateList::mergeStates(int finalState, int startState)
{
	FAstate *pf, *ps;

	/* find both states */
	if ((pf = findState(finalState)) == (FAstate *)0)
	{
		status = EINVAL;
		ERROR("mergeStates, EINVAL for finalState");
		return(NOTOK);
	}
	if ((ps = findState(startState)) == (FAstate *)0)
	{
		status = EINVAL;
		ERROR("mergeStates, EINVAL for startState");
		return(NOTOK);
	}

	/* check that final state is really a final state */
	if ( ! pf->input->isEmpty())
	{
		status = EINVAL;
		ERROR("mergeStates, EINVAL, input is NOT empty");
		return(NOTOK);
	}

	/* save data from start state in final state */
	pf->input = ps->input;

	/* delete start state, but first zap input pointer */
	ps->input = (FAinputList *)0;
	remove(ps);
	if (status != OK)
	{
		ERROR("mergeStates, remove failed");
		return(NOTOK);
	}
	delete ps;

	/* all done */
	status = OK;
	return(OK);
}

/* dump list of states */
void
FAstateList::dumpList()
{
	FAstate *pfa;
	FAstateIterator faIter(*this);

	while ((pfa = faIter()) != (FAstate *)0)
	{
		if ((pfa->input == (FAinputList *)0) || (pfa->input->isEmpty()))
		{
			fprintf(stderr, "(%d) --> [0, ] --> (EOF)\n", 
				pfa->state);
		}
		else
		{
			pfa->input->dumpList(pfa->state);
		}
	}
	status = OK;
	return;
}

/* assignment operator for lists */
FAstateList &
FAstateList::operator=(const FAstateList &list)
{
	if (this == &list) return(*this);
	List::~List();
	first = last = (Link *)0;
	copyFAstateList(list);
	return(*this);
}

/* compress states in FA */
int
FAstateList::compressStates()
{
	FAstateIterator stateIter(*this);
	if ((status = stateIter.getStatus()) != OK)
	{
		ERROR("compressStates, FAstateIter constructor failed");
		return(NOTOK);
	}
	int newState = 1;
	FAstate *pstate;
	stateSet->clear();
	while ((pstate = stateIter()) != (FAstate *)0)
	{
		/* don't reset start state */
		if (pstate->getState() != 0)
		{
			*stateSet += newState;
			pstate->setState(newState++);
		}
		else
		{
			/* set start state */
			*stateSet += 0;
		}
	}
	status = OK;
	return(OK);
}

/* default constructor for FA interator */
FAstateIterator::FAstateIterator()
{
	status = OK;
}

/* copy constructor */
FAstateIterator::FAstateIterator(const FAstateIterator &src): Iterator(src)
{
}

/* constructor for FA iterator */
FAstateIterator::FAstateIterator(const FAstateList &stateList): 
	Iterator(stateList)
{
}

/* destructor for FA interator */
FAstateIterator::~FAstateIterator()
{
	status = OK;
}

/* assignment operator */
FAstateIterator &
FAstateIterator::operator=(const FAstateIterator &src)
{
	next = src.next;
	status = OK;
	return(*this);
}

FAstateIterator &
FAstateIterator::operator=(const FAstateList &list)
{
	next = list.first;
	status = OK;
	return(*this);
}

/* iterator for FA state class */
FAstate *
FAstateIterator::operator()()
{
	return((FAstate *)Iterator::operator()());
}

/* default constructor for FAinput class */
FAinput::FAinput()
{
	input = NOSTATE;
	state = (FAstate *)0;
	status = OK;
}

/* constructor for FAinput class */
FAinput::FAinput(int newInput, FAstate *outState)
{
	input = newInput;
	state = outState;
	status = OK;
}

/* destructor for FAinput class */
FAinput::~FAinput()
{
	status = OK;
}

/* default constructor for FAinputList */
FAinputList::FAinputList()
{
	status = OK;
}

/* destructor for FAinputList */
FAinputList::~FAinputList()
{
	status = OK;
}

/* append a link to list */
FAinputList &
FAinputList::append(FAinput *newInput)
{
	List::append((Link *)newInput);
	return(*this);
}

/* prepend a link to list */
FAinputList &
FAinputList::prepend(FAinput *newInput)
{
	List::prepend((Link *)newInput);
	return(*this);
}

/* remove a link from list */
FAinputList &
FAinputList::remove(FAinput *oldInput)
{
	List::remove((Link *)oldInput);
	return(*this);
}

/* dump list of inputs */
void
FAinputList::dumpList(int inState)
{
	FAinput *pin;
	FAinputIterator inIter(*this);

	while ((pin = inIter()) != (FAinput *)0)
	{
		fprintf(stderr, "(%d) --> [%d, %c] --> (%d)\n",
			inState, pin->input, pin->input, 
			pin->state->getState());
	}
	status = OK;
	return;
}

/* default constructor for FA interator */
FAinputIterator::FAinputIterator()
{
	status = OK;
}

/* copy constructor for FA interator */
FAinputIterator::FAinputIterator(const FAinputIterator &src): Iterator(src)
{
}

/* constructor for FA interator */
FAinputIterator::FAinputIterator(const FAinputList &inputList): 
	Iterator(inputList)
{
}

/* destructor for FA interator */
FAinputIterator::~FAinputIterator()
{
	status = OK;
}

/* assignment operator */
FAinputIterator &
FAinputIterator::operator=(const FAinputIterator &src)
{
	next = src.next;
	status = OK;
	return(*this);
}

FAinputIterator &
FAinputIterator::operator=(const FAinputList &list)
{
	next = list.first;
	status = OK;
	return(*this);
}

/* iterator for FA class */
FAinput *
FAinputIterator::operator()()
{
	return((FAinput *)Iterator::operator()());
}

/* constructor for FA */
FA::FA()
{
	status = OK;
	fa = new FAstateList;
	if (fa == (FAstateList *)0)
	{
		status = ENOMEM;
		ERROR("FA, ENOMEM for input");
	}
	else if ((status = fa->getStatus()) != OK)
	{
		ERROR("FA, FAstateList constructor failed");
	}
}

/* destructor for FA */
FA::~FA()
{
#ifdef DEBUG
	if (fa != (FAstateList *)0) fa->dumpList();
#endif
	if (fa != (FAstateList *)0) delete fa;
	fa = (FAstateList *)0;
}

/* insert a state into FA */
int
FA::insertTransition(int inState, int input, int outState, FAstateList *newFA)
{
	FAinput *pinput;
	FAinputList *pinputList;
	FAstate *pin, *pout;

	/* which FA to use */
	FAstateList *pfa = (newFA != 0) ? newFA : fa;
	
	/* find each state, or create them */
	if ((pin = pfa->findState(inState)) == (FAstate *)0)
	{
		/* create new state */
		if ((pin = new FAstate(inState)) == (FAstate *)0)
		{
			status = ENOMEM;
			ERROR("FAinsertTransition, ENOMEM for inState");
			return(NOTOK);
		}
		if ((status = pin->getStatus()) != OK)
		{
			ERROR("FAinsertTransition, FAstate(inState) failed");
			return(NOTOK);
		}

		/* add new state to FA list */
		pfa->prepend(pin);
		if ((status = pfa->getStatus()) != OK)
		{
			ERROR("FAinsertTransition, prepend(inState) failed");
			return(NOTOK);
		}
	}
	if ((pout = pfa->findState(outState)) == (FAstate *)0)
	{
		/* create new state */
		if ((pout = new FAstate(outState)) == (FAstate *)0)
		{
			status = ENOMEM;
			ERROR("FAinsertTransition, ENOMEM for outState");
			return(NOTOK);
		}
		if ((status = pout->getStatus()) != OK)
		{
			ERROR("FAinsertTransition, FAstate(outState) failed");
			return(NOTOK);
		}

		/* add new state to FA list */
		pfa->prepend(pout);
		if ((status = pfa->getStatus()) != OK)
		{
			ERROR("FAinsertTransition, prepend(outState) failed");
			return(NOTOK);
		}
	}

	/* get input list */
	pinputList = pin->getInput();
	if ((status = pinputList->getStatus()) != OK)
	{
		ERROR("FAinsertTransition, getInput() failed");
		return(NOTOK);
	}

	/* create a new input */
	if ((pinput = new FAinput(input, pout)) == (FAinput *)0)
	{
		status = ENOMEM;
		ERROR("FAinsertTransition, ENOMEM for input");
		return(NOTOK);
	}
	if ((status = pinput->getStatus()) != OK)
	{
		ERROR("FAinsertTransition, FAinput constructor failed");
		return(NOTOK);
	}
	
	/* add a new transistion to list */
	pinputList->prepend(pinput);
	if ((status = pinputList->getStatus()) != OK)
	{
		ERROR("FAinsertTransition, prepend() failed");
		return(NOTOK);
	}

	/* save input in input set */
	inputSet += input;

	/* all done */
	status = OK;
	return(OK);
}

/* merge two states in FA */
int
FA::mergeStates(int finalState, int startState)
{
	int ret;

	/* merge states in FA list */
	ret = fa->mergeStates(finalState, startState);
	if ((status = fa->getStatus()) != OK)
	{
		ERROR("mergeStates, mergeStates failed");
	}

	/* all done */
	return(ret);
}

/* dump FA table */
void
FA::dumpFA()
{
	if (fa) fa->dumpList();
	status = OK;
	return;
}

/* compress states in FA */
int
FA::compressStates()
{
	int ret = fa->compressStates();
	status = fa->getStatus();
	return(ret);
}

/* get state for given input and start states */
Set
FA::move(Set &startSet, int input, int &acceptingState)
{
	Set nullSet, endSet;
	SetIterator startIter(startSet);
	if ((status = startIter.getStatus()) != OK)
	{
		ERROR("move, SetIterator constructor failed");
		return(nullSet);
	}
	int startState;
	while ((startState = startIter()) != LASTMEMBER)
	{
		FAstate *pstate = fa->findState(startState);
		if (pstate == (FAstate *)0)
		{
			status = EINVAL;
			ERROR("move, start state not in FA");
			return(nullSet);
		}
		FAinputIterator inputIter;
		inputIter = *pstate->getInput();
		if ((status = inputIter.getStatus()) != OK)
		{
			ERROR("move, FAinputIterator constructor failed");
			return(nullSet);
		}
		FAinput *pinput;
		while ((pinput = inputIter()) != (FAinput *)0)
		{
			if (input == pinput->getInput())
			{
				int outState = pinput->getState()->getState();
				if ( ! endSet.isMember(outState))
				{	
					/* add state to set */
					endSet += outState;
				}
				if ((pinput->getState()->getInput() == (FAinputList *)0) ||
				    (pinput->getState()->getInput()->isEmpty())) 
				{
					acceptingState = 1;
				}
			}
		}
	}
	status = OK;
	return(endSet);
}

Set
FA::move(int start, int input, int &acceptingState)
{
	Set startSet;
	startSet += start;
	return(move(startSet, input, acceptingState));
}

/* set of states reachable by epsilon transitions */
Set
FA::epsilonClosure(Set &startSet, int &acceptingState)
{
	Set nullSet, holdSet(startSet);
	if ((status = holdSet.getStatus()) != OK)
	{
		ERROR("epsilonClosure, Set constructor failed");
		return(nullSet);
	}
	Set eclose(startSet);
	if ((status = eclose.getStatus()) != OK)
	{
		ERROR("epsilonClosure, Set constructor failed");
		return(nullSet);
	}
	while ( ! holdSet.isEmpty())
	{
		int state;
		SetIterator holdSetIter;
		holdSetIter = holdSet;
		for ( ; (state = holdSetIter()) != LASTMEMBER; holdSet -= state)
		{
			FAstate *pinState = fa->findState(state);
			if (pinState == (FAstate *)0)
			{
				status = EINVAL;
				ERROR("epsilonClosure, findState returned a null");
				return(nullSet);
			}
			FAinputIterator inputIter;
			inputIter = *pinState->getInput();
			if ((status = inputIter.getStatus()) != OK)
			{
				ERROR("epsilonClosure, FAinputIterator failed");
				return(nullSet);
			}
			FAinput *pinput;
			while ((pinput = inputIter()) != (FAinput *)0)
			{
				if (pinput->getInput() != NULLTOKEN) continue;
				int outState = pinput->getState()->getState();
				if (eclose.isMember(outState)) continue;
				eclose += outState;
				holdSet += outState;
				if ((pinput->getState()->getInput() == (FAinputList *)0) ||
				    (pinput->getState()->getInput()->isEmpty())) 
				{
					acceptingState = 1;
				}
			}
		}
	}
	return(eclose);
}

Set
FA::epsilonClosure(int start, int &acceptingState)
{
	Set startSet;
	startSet += start;
	return(epsilonClosure(startSet, acceptingState));
}

/* convert NFA to a DFA */
int
FA::NFAtoDFA()
{
	/* get new DFA */
	FAstateList *dfa = new FAstateList;
	if (dfa == (FAstateList *)0)
	{
		status = ENOMEM;
		ERROR("FA, ENOMEM for input");
		return(NOTOK);
	}
	else if ((status = dfa->getStatus()) != OK)
	{
		delete dfa;
		ERROR("FA, FAstateList constructor failed");
		return(NOTOK);
	}

	/* get initial state */
	int acceptingState = 0;
	int newState = STARTSTATE;
	Set set = epsilonClosure(STARTSTATE, acceptingState);
	if (status != OK)
	{
		delete dfa;
		ERROR("NFAtoDFA, epsilonClosure failed");
		return(NOTOK);
	}
	SetState *psetState = new SetState(set, newState);

	/* create list of new states for DFA */
	SetStateList Dstates;
	Dstates.append(psetState);
	if ((status = Dstates.getStatus()) != OK)
	{
		delete dfa;
		ERROR("NFAtoDFA, append failed");
		return(NOTOK);
	}

	/* keep track of unmarked states */
	Set unmarked;
	unmarked += newState;

	/* get final accepting state */
	int finalState = ++newState;

	/* process unmarked states */
	while ( ! unmarked.isEmpty())
	{
		/* cycle thru unmarked states */
		int state;
		SetIterator unmarkedIter;
		unmarkedIter = unmarked;
		while ((state = unmarkedIter()) != LASTMEMBER)
		{
			/* mark state by removing from list */
			unmarked -= state;

			/* get unmarked state */
			SetState *ps = Dstates.findState(state);
			if (ps == (SetState *)0)
			{
				delete dfa;
				status = EINVAL;
				ERROR("NFAtoDFA, findState failed");
				return(NOTOK);
			}

			/* cycle thru all input symbols */
			int input;
			SetIterator inputIter;
			inputIter = inputSet;
			while ((input = inputIter()) != LASTMEMBER)
			{
				/* skip null transition */
				if (input == 0) continue;

				/* get transition set for this input */
				acceptingState = 0;
				Set moveSet = move(ps->getSet(), input, acceptingState);
				if (status != OK)
				{
					delete dfa;
					ERROR("NFAtoDFA, move failed");
					return(NOTOK);
				}
				if (moveSet.isEmpty()) continue;
				Set eclSet = epsilonClosure(moveSet, acceptingState);
				if (status != OK)
				{
					delete dfa;
					ERROR("NFAtoDFA, epsilonClosure failed");
					return(NOTOK);
				}

				/* check if state is already known */
				psetState = Dstates.findState(eclSet);
				if (psetState == (SetState *)0)
				{
					/* unknown state, add transition */
					psetState = 
						new SetState(eclSet, ++newState);
					Dstates.append(psetState);
					if ((status = Dstates.getStatus()) != OK)
					{
						delete dfa;
						ERROR("NFAtoDFA, append failed");
						return(NOTOK);
					}
	
					/* add an unmarked state */
					unmarked += newState;

					/* check if accepting state */
					if (acceptingState)
					{
						insertTransition(newState, NULLTOKEN, 
								 finalState, dfa);
						if (status != OK)
						{
							delete dfa;
							ERROR("NFAtoDFA, insertTransition failed");
							return(NOTOK);
						}
					}
				}

				/* insert transition into new DFA */
				insertTransition(state, input, psetState->getState(), dfa);
				if (status != OK)
				{
					delete dfa;
					ERROR("NFAtoDFA, insertTransition failed");
					return(NOTOK);
				}
			}
		}
	}

	/* replace NFA with DFA */
	delete fa;
	fa = dfa;

	/* all done */
	status = OK;
	return(OK);
}
