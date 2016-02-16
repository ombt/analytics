package provide cleis 1.0
# 
set cleis(ba1ax60aab) "voip";
set cleis(ba2a30tgaa) "ena";
set cleis(ba2a30tgab) "ena";
set cleis(ba4a701faa) "octds3_2";
set cleis(ba7atp0faa) "ds1_2";
set cleis(ba9ats0faa) "cm";
set cleis(ba9ats0fab) "cm";
set cleis(ba9axy0faa) "octds3_3";
set cleis(ba9iaa0aaa) "ds1";
set cleis(bauiaa1eab) "vs3";
set cleis(bauiaa1eac) "vs3";
set cleis(bauiadpeaa) "ena2";
set cleis(ba4a60zfaa) "trids3";
set cleis(ba4aw60faa) "tdmoc";
set cleis(ba9awx0faa) "trids3_3";
set cleis(ba91x70aaa) "ds3";
set cleis(ba91x70aab) "ds3";
#
set cleis(Main,ba1ax60aab) "vs2";
set cleis(Main,ba2a30tgaa) "ena2";
set cleis(Main,ba2a30tgab) "ena2";

set cleis(BRANCH-6-2-0,ba1ax60aab) "vs2";
set cleis(BRANCH-6-2-0,ba2a30tgaa) "ena2";
set cleis(BRANCH-6-2-0,ba2a30tgab) "ena2";
#
set cleis(BP-6-2-0-1,ba1ax60aab) "vs2";
set cleis(BP-6-2-0-1,ba2a30tgaa) "ena2";
set cleis(BP-6-2-0-1,ba2a30tgab) "ena2";
#
set cleis(BP-6-2-1-1,ba1ax60aab) "vs2";
set cleis(BP-6-2-1-1,ba2a30tgaa) "ena2";
set cleis(BP-6-2-1-1,ba2a30tgab) "ena2";
#
# set cleis(BRANCH-DEV-6-2-1,ba1ax60aab) "vs2";
set cleis(BRANCH-DEV-6-2-1,ba2a30tgaa) "ena2";
set cleis(BRANCH-DEV-6-2-1,ba2a30tgab) "ena2";
#
proc printCleiData { } {
	global cleis;
	foreach item [lsort [array names cleis]] {
		puts "cleis\($item\): <$cleis($item)> <$item> ";
	}
	return "0 - success";
}
