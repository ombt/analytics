#include <sysent.h>
#include <stdlib.h>
#include <errno.h>
#include "returns.h"
#include "debug.h"
#include "set.h"
#include "setState.h"

main(int, char **)
{
	SetStateGroup group;
	if ((errno = group.getStatus()) != OK)
	{
		ERROR("SetStateGroup iterator failed.", errno);
		return(2);
	}
	for (int istate = 0, done = 0; ! done; istate++)
	{
		Set set;
		set.clear();
		int member;
		while ( 1 )
		{
			printf("enter member for set state %d : ", istate);
			scanf("%d", &member);
			if (member < 0) break;
			set += member;
			if ((errno = set.getStatus()) != OK)
			{
				ERRORI("adding member to set failed", 
				       errno, istate);
				return(2);
			}
		}
		SetState *state = new SetState(set, istate);
		if (state == (SetState *)0)
		{
			ERROR("ENOMEM for new SetState.", ENOMEM);
			return(2);
		}
		if (group.insert(state) == (SetState *)0)
		{
			ERROR("group.insert failed for new SetState.", 
			      group.getStatus());
			return(2);
		}
		printf("continue adding states ??? [y/n]");
		char ans[16];
		*ans = 0;
		scanf("%s", ans);
		if (*ans == 'n') done = 1;
	}
	SetStateGroupIterator groupiter(group);
	if ((errno = group.getStatus()) != OK)
	{
		ERROR("SetStateGroupIterator constructor failed", errno);
		return(2);
	}
	SetState all;
	SetState *pstate;
	while ((pstate = groupiter()) != (SetState *)0)
	{
		printf("iterating thru state %d ...\n", (int)*pstate);
		pstate->dump();
		printf("searching for state ...\n");
		SetState *pst = group.find((int)*pstate);
		if (pst != (SetState *)0)
		{
			printf("STATE FOUND !!!\n");
			pst->dump();
			all |= *pst;
			printf("dumping combined state ...\n");
			all.dump();
		}
		else
		{
			printf("STATE NOT FOUND !!!\n");
		}
		printf("searching for BOGUS state ...\n");
		pst = group.find((int)*pstate+10);
		if (pst != (SetState *)0)
		{
			printf("STATE FOUND !!!\n");
			pst->dump();
		}
		else
		{
			printf("STATE NOT FOUND !!!\n");
		}
	}
	printf("dumping final combined state ...\n");
	all.dump();
	return(0);
}
