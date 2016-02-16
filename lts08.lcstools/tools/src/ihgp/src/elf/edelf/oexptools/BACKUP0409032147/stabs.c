// perform editing operations

// headers
#include "edelf.h"
#include "trans.h"
#include "data.h"

// check if a section is a stab section
int
isStabSection(int csec)
{
	char *psecname = pshstrtbl+pshdrs[csec].sh_name;
	return(pshdrs[csec].sh_type == SHT_PROGBITS &&
	       ((strncmp(psecname, ".stab.", 6) == 0) ||
	        (strncmp(psecname, ".stab", 5) == 0)));
}

// editing stabs
void
readstabs(char *s)
{
	// read in file, section headers, and string tables
	readstrings(s);

	// delete old stab tables
	if (pstabtbls != NULL)
	{
		for (int sec=0; sec<pehdr->e_shnum; sec++)
		{
			if (pstabtbls[sec] != NULL)
			{
				delete [] pstabtbls[sec];
				pstabtbls[sec] = NULL;
			}
		}
		delete [] pstabtbls;
		pstabtbls = NULL;
	}
	if (pstaboffsets != NULL)
	{
		for (int sec=0; sec<pehdr->e_shnum; sec++)
		{
			if (pstaboffsets[sec] != NULL)
			{
				delete [] pstaboffsets[sec];
				pstaboffsets[sec] = NULL;
			}
		}
		delete [] pstaboffsets;
		pstaboffsets = NULL;
	}

	// allocate a new stab table
	if (pstabtbls == NULL)
	{
		// allocate a array of stab tables
		pstabtbls = new char * [pehdr->e_shnum];
		MustBeTrue(pstabtbls != NULL);

		// allocate section stab tables
		for (int sec=0; sec<pehdr->e_shnum; sec++)
		{
			// initialize
			pstabtbls[sec] = NULL;

			// skip sections that are not stab tables
			if (!isStabSection(sec))
				continue;

			// allocate a stab table
			pstabtbls[sec] = new char [pshdrs[sec].sh_size];
			MustBeTrue(pstabtbls[sec] != NULL);
		}
	}

	// read in stab tables.
	for (int sec=0; sec<pehdr->e_shnum; sec++)
	{
		// skip sections that are not stab tables
		if (!isStabSection(sec))
			continue;

		// seek and read in stab table
		MustBeTrue(lseek(efd, pshdrs[sec].sh_offset, SEEK_SET) != NOTOK)
		int numbytes = pshdrs[sec].sh_size;
		MustBeTrue(read(efd, pstabtbls[sec], numbytes) == numbytes);
	}

	// calculate offsets into string table per file.
	pstaboffsets = new staboffsetdata *[pehdr->e_shnum];
	for (sec=0; sec<pehdr->e_shnum; sec++)
	{
		long total_offset = 0;
		long old_offset = 0;

		// skip sections that are not stab tables
		if (pstabtbls[sec] == NULL)
			continue;

		// process entries in each stab section
		int nentries = 0;
		char *p0 = pstabtbls[sec];
		char *pe = pstabtbls[sec]+pshdrs[sec].sh_size;

		// count the number of entries in the section
		for (int stabno=0; 
		    (p0+stabno*pshdrs[sec].sh_entsize)<pe;
		     stabno++)
		{
			stab *pstab = 
				(stab *)(p0+stabno*pshdrs[sec].sh_entsize);
			if (pstab->n_type == N_UNDF) nentries++;
		}

		// allocate an array to store data
		pstaboffsets[sec] = (new staboffsetdata [nentries+1]);

		// kludge - store number of elements in array itself.
		pstaboffsets[sec][0].start = nentries;	// end stabno
		pstaboffsets[sec][0].end = nentries;	// end stabno
		pstaboffsets[sec][0].offset = nentries;	// total offset

		// calculate offsets and store
		long ientry = 0;
		for (stabno=0; 
		    (p0+stabno*pshdrs[sec].sh_entsize)<pe;
		     stabno++)
		{
			stab *pstab = 
				(stab *)(p0+stabno*pshdrs[sec].sh_entsize);
			if (pstab->n_type == N_ILDPAD)
			{
				// padding, add correction to string offset.
				total_offset += pstab->n_value;
				continue;
			}
			else if (pstab->n_type != N_UNDF)
				continue;
			ientry++;
			total_offset += old_offset;
#if 0
			printf("N_UNDF DATA - sec: %ld, stabno: %ld, \nnentries: %ld, size: %ld, total_offset: %ld\n",
				(long)sec, (long)stabno, 
				(long)pstab->n_desc, (long)pstab->n_value,
				total_offset);
#endif
			old_offset = pstab->n_value;
			pstaboffsets[sec][ientry].start = stabno;
			pstaboffsets[sec][ientry].end = stabno+pstab->n_desc;
			pstaboffsets[sec][ientry].offset = total_offset;
		}
	}
#if 0
	for (sec=0; sec<pehdr->e_shnum; sec++)
	{
		if (pstaboffsets[sec] == NULL)
			continue;
		int maxentry = pstaboffsets[sec][0].end;
		for (int ientry=1; ientry<=maxentry; ientry++)
		{
			printf("(sec,ientry,start,end,offset)=(%ld,%ld,%ld,%ld,%ld)\n",
				(long)sec, (long)ientry, 
				(long) pstaboffsets[sec][ientry].start,
				(long) pstaboffsets[sec][ientry].end,
				(long) pstaboffsets[sec][ientry].offset);
		}
	}
#endif
	return;
}

static void
printmenu()
{
	printf("stabs menu:\n");
	printf("? or h - show menu\n");
	printf("n - show all stabs tables section names\n");

	printf("r - review current stab\n");
	printf("r * - review all stabs in stab tables\n");
	printf("r * <pattern> - review <pattern> in all stab tables\n");
	printf("rt * <type> - review <type> in all stab tables\n");

	printf("r <section> - review 1st stab in <section> stab table\n");
	printf("r <section> * - review all stabs in <section> stab table\n");
	printf("r <section> <pattern> - review <pattern> in <section> stab table\n");
	printf("rt <section> <type> - review <type> in <section> stab table\n");

	printf("r <section#> - review 1st stab in <section#> stab table\n");
	printf("r <section#> * - review all stabs in <section#> stab table\n");
	printf("r <section#> <pattern> - review <pattern> in <section#> stab table\n");
	printf("rt <section#> <type> - review <type> in <section#> stab table\n");

	printf("+ - next stab\n");
	printf("- - previous stab\n");
	printf("u - update current stab in current stab table\n");
	printf("D - toggle demangle mode\n");
	printf("q - quit\n");
	return;
}

void
showstab(int &cstabno, int &csec, char *&p0, char *&pe)
{
	static int showsec = -1;
	static int showstart = 65565;
	static int showend = -1;
	static int showoffset = 0;

	if ((showsec != csec) || (cstabno < showstart) || (cstabno > showend))
	{
		// need to recalculate the offset
		MustBeTrue(pstaboffsets[csec] != NULL);
		int maxentry = pstaboffsets[csec][0].end;
		for (int ientry=1; ientry<=maxentry; ientry++)
		{
			if ((pstaboffsets[csec][ientry].start <= cstabno) &&
			     (cstabno <= pstaboffsets[csec][ientry].end))
			{
				showstart = pstaboffsets[csec][ientry].start;
				showend = pstaboffsets[csec][ientry].end;
				showoffset = pstaboffsets[csec][ientry].offset;
				break;
			}
		}
	}
	stab *pstab = (stab *)(p0+cstabno*pshdrs[csec].sh_entsize);
	char *pstabstr = pstrtbls[pshdrs[csec].sh_link]+
				pstab->n_strx+showoffset;
	printf("%d: n_strx : 0x%lx (%s)\n", 
		cstabno, (long)pstab->n_strx, pstabstr);
	printf("%d: n_type : 0x%lx (%s)\n", 
		cstabno, (unsigned long)pstab->n_type, 
		i2s(n_type, pstab->n_type));
	printf("%d: n_other: 0x%lx\n", 
		cstabno, (unsigned long)pstab->n_other);
	printf("%d: n_desc : 0x%lx\n", 
		cstabno, (unsigned long)pstab->n_desc);
	printf("%d: n_value: 0x%lx\n", 
		cstabno, (unsigned long)pstab->n_value);
	return;
}

static void
review(int &cstabno, int &csec, char *&p0, char *&pe)
{
	char save_pt3[BUFSIZ];
	*save_pt3 = '\0';

	// get tokens from user stream
	char *pt1 = gettoken(1);
	char *pt2 = gettoken(2);
	char *pt3 = gettoken(3);
	int tflag = (*(pt1+1)=='t');

	// determine user request
	if (pt2 == NULL)
	{
		// check current section and location
		if (!isStabSection(csec))
		{
			printf("current section is not a stab table.\n");
			return;
		}
		if (cstabno < 0 || 
		    cstabno*pshdrs[csec].sh_entsize > pshdrs[csec].sh_size)
		{
			printf("stab number is out of range.\n");
			return;
		}

		// show current stab
		showstab(cstabno, csec, p0, pe);
	}
	else if (*pt2 == '*')
	{
		// check if a string was given
		if (pt3 == NULL)
		{
			// show all stabs
			for (csec=0; csec<pehdr->e_shnum; csec++)
			{
				// skip sections that are not symbol tables
				if (!isStabSection(csec))
					continue;
	
				// print section name
				printf("section %d: %s (%d)\n", csec,
					pshstrtbl+pshdrs[csec].sh_name, 
					pshdrs[csec].sh_name);
	
				// print stabs in section
				p0 = pstabtbls[csec];
				pe = pstabtbls[csec]+pshdrs[csec].sh_size;
				char *pstr = pstrtbls[pshdrs[csec].sh_link];
				for (cstabno=0; 
				    (p0+cstabno*pshdrs[csec].sh_entsize)<pe;
				     cstabno++)
				{
					showstab(cstabno, csec, p0, pe);
				}
			}
		}
		else if (!tflag)
		{
			// show a specific stab
			for (csec=0; csec<pehdr->e_shnum; csec++)
			{
				// skip sections that are not stab tables
				if (!isStabSection(csec))
					continue;
	
				// print section name
				printf("section %d: %s (%d)\n", csec,
					pshstrtbl+pshdrs[csec].sh_name, 
					pshdrs[csec].sh_name);
	
				// print stabs in section
				p0 = pstabtbls[csec];
				pe = pstabtbls[csec]+pshdrs[csec].sh_size;
				char *pstr = pstrtbls[pshdrs[csec].sh_link];
				for (cstabno=0; 
				    (p0+cstabno*pshdrs[csec].sh_entsize)<pe;
				     cstabno++)
				{
					stab *pstab = (stab *)(p0 + 
						cstabno*pshdrs[csec].sh_entsize);
					char *pstring = pstr + pstab->n_strx;
					if (!REequal(pt3, pstring))
						continue;
					showstab(cstabno, csec, p0, pe);
					char s[BUFSIZ];
					printf("next stab? [n/y/cr=y] ");
					rmvnlgets(s);
					if (*s != 'y' && *s != '\0')
						goto all_done;
				}
			}
			all_done: ;
		}
		else
		{
			long search_type = -1;

			// get type, either a number or a mnemonic.
			if ((strncmp(pt3, "0x", 2) == 0) ||
			    (strncmp(pt3, "0X", 2) == 0))
			{
				search_type = strtol(pt3, NULL, 16);
			}
			else if (strlen(pt3) == strspn(pt3, "0123456789"))
			{
				search_type = strtol(pt3, NULL, 10);
			}
			else
			{
				strcpy(save_pt3, pt3);
				search_type = s2i(n_type, pt3);
				if (search_type == NOTOK)
				{
					printf("unknown type: %s.\n", save_pt3);
					return;
				}
			}

			// show a specific stab, search by type
			for (csec=0; csec<pehdr->e_shnum; csec++)
			{
				// skip sections that are not stab tables
				if (!isStabSection(csec))
					continue;
	
				// print section name
				printf("section %d: %s (%d)\n", csec,
					pshstrtbl+pshdrs[csec].sh_name, 
					pshdrs[csec].sh_name);
	
				// print stabs in section
				p0 = pstabtbls[csec];
				pe = pstabtbls[csec]+pshdrs[csec].sh_size;
				for (cstabno=0; 
				    (p0+cstabno*pshdrs[csec].sh_entsize)<pe;
				     cstabno++)
				{
					stab *pstab = (stab *)(p0 + cstabno*
						pshdrs[csec].sh_entsize);
					if (pstab->n_type != search_type)
						continue;
					showstab(cstabno, csec, p0, pe);
					char s[BUFSIZ];
					printf("next stab? [n/y/cr=y] ");
					rmvnlgets(s);
					if (*s != 'y' && *s != '\0')
						goto all_done2;
				}
			}
			all_done2: ;
		}
	}
	else if (strlen(pt2) == strspn(pt2, "0123456789"))
	{
		// a section number was given
		int sec = MYatoi(pt2);
		if (sec < 0 || sec >= pehdr->e_shnum)
		{
			printf("out-of-range section number.\n");
			printf("minimum section number = 0\n");
			printf("maximum section number = %d\n",
				pehdr->e_shnum);
			return;
		}
		if (!isStabSection(sec))
		{
			printf("section is not a stab table.\n");
			return;
		}
		csec = sec;
		cstabno = 0;
		p0 = pstabtbls[csec];
		pe = pstabtbls[csec]+pshdrs[csec].sh_size;

		// was a string given
		if (pt3 == NULL)
		{
			// show first stab in table
			showstab(cstabno, csec, p0, pe);
		}
		else if (*pt3 == '*')
		{
			// show all stabs in section
			// print section name
			printf("section %d: %s (%d)\n", csec,
				pshstrtbl+pshdrs[csec].sh_name, 
				pshdrs[csec].sh_name);
	
			// print stabs in section
			char *pstr = pstrtbls[pshdrs[csec].sh_link];
			for (cstabno=0; 
			    (p0+cstabno*pshdrs[csec].sh_entsize)<pe; cstabno++)
			{
				showstab(cstabno, csec, p0, pe);
			}
		}
		else if (!tflag)
		{
			// search for stab within the section
			// print section name
			printf("section %d: %s (%d)\n", csec,
				pshstrtbl+pshdrs[csec].sh_name, 
				pshdrs[csec].sh_name);
	
			// print stab in section
			char *pstr = pstrtbls[pshdrs[csec].sh_link];
			for (cstabno=0; 
			    (p0+cstabno*pshdrs[csec].sh_entsize)<pe; cstabno++)
			{
				stab *pstab = (stab *)(p0 + 
					cstabno*pshdrs[csec].sh_entsize);
				char *pstring = pstr + pstab->n_strx;
				if (!REequal(pt3, pstring))
					continue;
				showstab(cstabno, csec, p0, pe);
				char s[BUFSIZ];
				printf("next string? [n/y/cr=y] ");
				rmvnlgets(s);
				if (*s != 'y' && *s != '\0')
					break;
			}
		}
		else
		{
			long search_type = -1;

			// get type, either a number or a mnemonic.
			if ((strncmp(pt3, "0x", 2) == 0) ||
			    (strncmp(pt3, "0X", 2) == 0))
			{
				search_type = strtol(pt3, NULL, 16);
			}
			else if (strlen(pt3) == strspn(pt3, "0123456789"))
			{
				search_type = strtol(pt3, NULL, 10);
			}
			else
			{
				strcpy(save_pt3, pt3);
				search_type = s2i(n_type, pt3);
				if (search_type == NOTOK)
				{
					printf("unknown type: %s.\n", save_pt3);
					return;
				}
			}
			// search for stab within the section
			// print section name
			printf("section %d: %s (%d)\n", csec,
				pshstrtbl+pshdrs[csec].sh_name, 
				pshdrs[csec].sh_name);
	
			// print stab in section
			char *pstr = pstrtbls[pshdrs[csec].sh_link];
			for (cstabno=0; 
			    (p0+cstabno*pshdrs[csec].sh_entsize)<pe; cstabno++)
			{
				stab *pstab = (stab *)(p0 + 
					cstabno*pshdrs[csec].sh_entsize);
				if (pstab->n_type != search_type)
					continue;
				showstab(cstabno, csec, p0, pe);
				char s[BUFSIZ];
				printf("next string? [n/y/cr=y] ");
				rmvnlgets(s);
				if (*s != 'y' && *s != '\0')
					break;
			}
		}
	}
	else
	{
		// a section name was given
		int sec = nametosec(pt2);
		if (sec == NOTOK)
		{
			printf("section not found.\n");
			return;
		}
		if (!isStabSection(sec))
		{
			printf("section is not a stab table.\n");
			return;
		}
		csec = sec;
		cstabno = 0;
		p0 = pstabtbls[csec];
		pe = pstabtbls[csec]+pshdrs[csec].sh_size;

		// was a string given
		if (pt3 == NULL)
		{
			// show first stab in table
			showstab(cstabno, csec, p0, pe);
		}
		else if (*pt3 == '*')
		{
			// show all stabs in section
			// print section name
			printf("section %d: %s (%d)\n", csec,
				pshstrtbl+pshdrs[csec].sh_name, 
				pshdrs[csec].sh_name);
	
			// print stabs in section
			char *pstr = pstrtbls[pshdrs[csec].sh_link];
			for (cstabno=0; 
			    (p0+cstabno*pshdrs[csec].sh_entsize)<pe; cstabno++)
			{
				showstab(cstabno, csec, p0, pe);
			}
		}
		else if (!tflag)
		{
			// search for stab within the section
			// print section name
			printf("section %d: %s (%d)\n", csec,
				pshstrtbl+pshdrs[csec].sh_name, 
				pshdrs[csec].sh_name);
	
			// print stab in section
			char *pstr = pstrtbls[pshdrs[csec].sh_link];
			for (cstabno=0; 
			    (p0+cstabno*pshdrs[csec].sh_entsize)<pe; cstabno++)
			{
				stab *pstab = (stab *)(p0 + 
					cstabno*pshdrs[csec].sh_entsize);
				char *pstring = pstr + pstab->n_strx;
				if (!REequal(pt3, pstring))
					continue;
				showstab(cstabno, csec, p0, pe);
				char s[BUFSIZ];
				printf("next string? [n/y/cr=y] ");
				rmvnlgets(s);
				if (*s != 'y' && *s != '\0')
					break;
			}
		}
		else
		{
			long search_type = -1;

			// get type, either a number or a mnemonic.
			if ((strncmp(pt3, "0x", 2) == 0) ||
			    (strncmp(pt3, "0X", 2) == 0))
			{
				search_type = strtol(pt3, NULL, 16);
			}
			else if (strlen(pt3) == strspn(pt3, "0123456789"))
			{
				search_type = strtol(pt3, NULL, 10);
			}
			else
			{
				strcpy(save_pt3, pt3);
				search_type = s2i(n_type, pt3);
				if (search_type == NOTOK)
				{
					printf("unknown type: %s.\n", save_pt3);
					return;
				}
			}
			// search for stab within the section
			// print section name
			printf("section %d: %s (%d)\n", csec,
				pshstrtbl+pshdrs[csec].sh_name, 
				pshdrs[csec].sh_name);
	
			// print stab in section
			char *pstr = pstrtbls[pshdrs[csec].sh_link];
			for (cstabno=0; 
			    (p0+cstabno*pshdrs[csec].sh_entsize)<pe; cstabno++)
			{
				stab *pstab = (stab *)(p0 + 
					cstabno*pshdrs[csec].sh_entsize);
				if (pstab->n_type != search_type)
					continue;
				showstab(cstabno, csec, p0, pe);
				char s[BUFSIZ];
				printf("next string? [n/y/cr=y] ");
				rmvnlgets(s);
				if (*s != 'y' && *s != '\0')
					break;
			}
		}
	}
	return;
}

static void
update(int &cstabno, int &csec, char *&p0, char *&pe)
{
	// check section and stab
	if (csec < 0 || csec > pehdr->e_shnum)
	{
		printf("invalid section number.\n");
		return;
	}
	if (!isStabSection(csec))
	{
		printf("section is not a stab table.\n");
		return;
	}
	if (cstabno < 0 || cstabno*pshdrs[csec].sh_entsize > pshdrs[csec].sh_size)
	{
		printf("current stab number is out-of-range.\n");
		return;
	}
	MustBeTrue(pstabtbls[csec] == p0);

	// update stab
	int upd = 0;
	char s[BUFSIZ];
	printf("section %d: %s (%d)\n", csec,
		pshstrtbl+pshdrs[csec].sh_name, pshdrs[csec].sh_name);
	stab *pstab = (stab *)(p0 + cstabno*pshdrs[csec].sh_entsize);

	printf("%d: n_strx [cr=0x%lx]: ", cstabno, (long)pstab->n_strx);
	rmvnlgets(s);
	if (*s != '\0')
	{
		upd++;
		pstab->n_type = MYatoi(s);
		printf("n_type: 0x%lx\n", (long)pstab->n_type);
	}
	printf("%d: n_other [cr=0x%lx]: ", cstabno, (long)pstab->n_other);
	rmvnlgets(s);
	if (*s != '\0')
	{
		upd++;
		pstab->n_other = MYatoi(s);
		printf("n_other: 0x%lx\n", (long)pstab->n_other);
	}
	printf("%d: n_desc [cr=0x%lx]: ", cstabno, (long)pstab->n_desc);
	rmvnlgets(s);
	if (*s != '\0')
	{
		upd++;
		pstab->n_desc = MYatoi(s);
		printf("n_desc: 0x%lx\n", (long)pstab->n_desc);
	}
	printf("%d: n_value [cr=0x%lx]: ", cstabno, (long)pstab->n_value);
	rmvnlgets(s);
	if (*s != '\0')
	{
		upd++;
		pstab->n_value = MYatoi(s);
		printf("n_value: 0x%lx\n", (long)pstab->n_value);
	}

	// write to file
	if (upd > 0)
	{
		printf("write to file [cr=n/n/y] ? ");
		rmvnlgets(s);
		if (*s == 'y')
		{
			if (!uflag)
			{
				close(efd);
				MustBeTrue((efd = open(efn, O_RDWR)) != NOTOK);
				uflag = 1;
			}
			MustBeTrue(lseek(efd, pshdrs[csec].sh_offset, 
					SEEK_SET) != NOTOK);
			int numbytes = pshdrs[csec].sh_size;
			MustBeTrue(write(efd, pstabtbls[csec], 
					numbytes) == numbytes);
		}

		// reread data
		char dummy[1];
		readstabs(dummy);
	}
	return;
}

static void
increment(int &cstabno, int &csec, char *&p0, char *&pe)
{
	// check section and stab
	if (csec < 0 || csec > pehdr->e_shnum)
	{
		printf("invalid section number.\n");
		return;
	}
	if (!isStabSection(csec))
	{
		printf("section is not a stab table.\n");
		return;
	}
	if (cstabno < 0 || cstabno*pshdrs[csec].sh_entsize > pshdrs[csec].sh_size)
	{
		printf("current stab number is out-of-range.\n");
		return;
	}

	// check most common case
	if ((cstabno+1)*pshdrs[csec].sh_entsize < pshdrs[csec].sh_size)
	{
		cstabno++;
		showstab(cstabno, csec, p0, pe);
		return;
	}
	
	// we are passed the end of the current section, look for
	// the next stab table section, if any.
	//
	int ncsec = csec+1;
	for ( ; ncsec < pehdr->e_shnum; ncsec++)
	{
		if (isStabSection(ncsec))
			break;
	}
	if (ncsec >= pehdr->e_shnum)
	{
		printf("no next stab table found.\n");
		return;
	}

	// return the first stab in the section
	cstabno = 0;
	csec = ncsec;
	p0 = pstabtbls[csec];
	pe = pstabtbls[csec]+pshdrs[csec].sh_size;
	showstab(cstabno, csec, p0, pe);
	return;
}

static void
decrement(int &cstabno, int &csec, char *&p0, char *&pe)
{
	// check section and stab
	if (csec < 0 || csec > pehdr->e_shnum)
	{
		printf("invalid section number.\n");
		return;
	}
	if (!isStabSection(csec))
	{
		printf("section is not a stab table.\n");
		return;
	}
	if (cstabno < 0 || cstabno*pshdrs[csec].sh_entsize > pshdrs[csec].sh_size)
	{
		printf("current stab number is out-of-range.\n");
		return;
	}

	// check most common case
	if ((cstabno-1) >= 0)
	{
		cstabno--;
		showstab(cstabno, csec, p0, pe);
		return;
	}
	
	// we are passed the end of the current section, look for
	// the previous stab table section, if any.
	//
	int ncsec = csec-1;
	for ( ; ncsec >= 0; ncsec--)
	{
		if (isStabSection(ncsec))
			break;
	}
	if (ncsec < 0)
	{
		printf("no previous stab table found.\n");
		return;
	}

	// return the last stab in the section
	csec = ncsec;
	p0 = pstabtbls[csec];
	pe = pstabtbls[csec]+pshdrs[csec].sh_size;
	cstabno = pshdrs[csec].sh_size/pshdrs[csec].sh_entsize;
	showstab(cstabno, csec, p0, pe);
	return;
}

void
editstabs(char *)
{
	char s[BUFSIZ];

	// start of stabs editing
	printf("editing stabs:\n");

	// initialize stab pointers
	int csec = pehdr->e_shnum;
	int cstabno = 0;

	// find the first stab table
	for (int sec=0; sec<pehdr->e_shnum; sec++)
	{
		if (isStabSection(sec))
		{
			csec = sec;
			break;
		}
	}
	if (csec >= pehdr->e_shnum)
	{
		printf("no stab tables found.\n");
		return;
	}

	// pointers to stab tables
	char *p0 = pstabtbls[csec];
	char *pe = pstabtbls[csec]+pshdrs[csec].sh_size;

	// start interactive loop
	for (int done=0; !done; )
	{
		// get cmd from user
		printf("stabs cmd: ");
		rmvnlgets(s);
		tokenize(s, " \t");
		char *pt = gettoken(1);

		// what is the command
		if (pt == NULL || *pt == '\0')
		{
			// printf("unknown cmd.\n");
			increment(cstabno, csec, p0, pe);
		}
		else if (*pt == 'n')
		{
			// show all section names
			printf("stab table names:\n");
			for (int sec=0; sec<pehdr->e_shnum; sec++)
			{
				if (!isStabSection(sec))
					continue;
				printf("section %d: %s (%d)\n", 
					sec, pshstrtbl+pshdrs[sec].sh_name,
					pshdrs[sec].sh_name);
			}
		}
		else if (*pt == '?' || *pt == 'h')
		{
			printmenu();
		}
		else if (*pt == 'D')
		{
			dflag = !dflag;
			if (dflag)
				printf("demangle mode ON.\n");
			else
				printf("demangle mode OFF.\n");
		}
		else if (*pt == 'r')
		{
			review(cstabno, csec, p0, pe);
		}
		else if (*pt == 'u')
		{
			update(cstabno, csec, p0, pe);
		}
		else if (*pt == '+')
		{
			increment(cstabno, csec, p0, pe);
		}
		else if (*pt == '-')
		{
			decrement(cstabno, csec, p0, pe);
		}
		else if (*pt == 'q')
		{
			done = 1;
		}
		else
		{
			printf("unknown cmd.\n");
		}
	}
	return;
}

