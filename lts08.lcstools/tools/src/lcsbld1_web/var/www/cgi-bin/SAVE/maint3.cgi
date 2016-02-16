#!/opt/exp/bin/perl
#
use File::Basename;
#
require "/home/lcstools/public_html/cgi-bin/cgiutils.cgi";
require "/home/lcstools/public_html/cgi-bin/cgidata.cgi";
#
sub lcspicks {
	$labid = $FORM_DATA{labid};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> LCS PICKS</h3>\n";
	#
	print "<h4>($labid)</h4>\n";
	print "</center>\n";
	#
	print "<pre>\n";
	open(PIPE, "/home/lcstools/tools/bin/weblcspicks ${labid} |");
	#
	PIPE->autoflush(1);
	STDOUT->autoflush(1);
	#
	while (defined($urec = <PIPE>)) {
		chomp($urec);
		if ($urec =~ /no *such *file *or *directory/i) {
			print "${urec}\n";
			last;
		}
		print "==>> ${1} ${urec}\n";
	}
	close(PIPE);
	STDOUT->autoflush(0);
	print "</pre>\n";
	#
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub lcsspaudit {
	$labid = $FORM_DATA{labid};
	$sps = $FORM_DATA{sps};
	$type = $FORM_DATA{type};
	$getcpuload = $FORM_DATA{getcpuload};
	$ucondtoc = $FORM_DATA{ucondtoc};
	$lynxuser = $FORM_DATA{lynxuser};
	$lynxpasswd = $FORM_DATA{lynxpasswd};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> LCS SP/IOM AUDIT </h3>\n";
	#
	print "<h4>($labid, $sps, $type, $getcpuload, $ucondtoc, $lynxuser, $lynxpasswd)</h4>\n";
	#
	$cmd = "/home/lcstools/tools/bin/weblcsspaudit";
	if ($lynxuser ne "") {
		$cmd .= " -u ${lynxuser}";
	} else {
		$cmd .= " -u root";
	}
	if ($lynxpasswd ne "") {
		$cmd .= " -p ${lynxpasswd}";
	} else {
		$cmd .= " -p plexus9000";
	}
	if ($type eq "knownioms") {
		$cmd .= " -i";
	} elsif ($type eq "allioms") {
		$cmd .= " -a";
	} elsif ($type eq "cpu") {
		$cmd .= " -c";
	}
	if ($sps eq "spa") {
		$cmd .= " -A";
	} elsif ($sps eq "spb") {
		$cmd .= " -B";
	}
	if ($getcpuload eq "on") {
		$cmd .= " -L";
	}
	if ($ucondtoc eq "on") {
		$cmd .= " -U";
	}
	$cmd .= " ${labid}";
	#
	print "<h4>CMD: $cmd</h4>\n";
	#
	print "<hr>\n";
	print "<h3> Start Command?</h3>\n";
	print "<form method=\"post\" action=\"execcmd2.cgi\">\n";
	print "<input type=hidden name=\"outfile\" value=\"lcsspaudit.${labid}\">\n";
	print "<input type=hidden name=\"cmd\" value=\"${cmd}\">\n";
	print "<input type=submit value=\"confirm\">\n";
	print "<hr>\n";
	#
	print "</center>\n";
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub nlcsstat {
	$labid = $FORM_DATA{labid};
	$options = $FORM_DATA{options};
	$tl1user = $FORM_DATA{tl1user};
	$tl1passwd = $FORM_DATA{tl1passwd};
	$lynxuser = $FORM_DATA{lynxuser};
	$lynxpasswd = $FORM_DATA{lynxpasswd};
	$verbose = $FORM_DATA{verbose};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> LCS SP STATUS</h3>\n";
	#
	print "<h4>($labid, $options, $tl1user, $tl1passwd, $lynxuser, $lynxpasswd)</h4>\n";
	#
	$cmd = "/home/lcstools/tools/bin/webnlcsstat";
	if ($tl1user ne "") {
		$cmd .= " -U ${tl1user}";
	} else {
		$cmd .= " -U telica";
	}
	if ($tl1passwd ne "") {
		$cmd .= " -P ${tl1passwd}";
	} else {
		$cmd .= " -P telica";
	}
	if ($lynxuser ne "") {
		$cmd .= " -u ${lynxuser}";
	} else {
		$cmd .= " -u root";
	}
	if ($lynxpasswd ne "") {
		$cmd .= " -p ${lynxpasswd}";
	} else {
		$cmd .= " -p plexus9000";
	}
	if ($options eq "ignoretl1") {
		$cmd .= " -i";
	} elsif ($options eq "pingonly") {
		$cmd .= " -I";
	}
	if ($verbose eq "on") {
		$cmd .= " -V";
	}
	$cmd .= " ${labid}";
	#
	print "<h4>CMD: $cmd</h4>\n";
	#
	print "<hr>\n";
	print "<h3> Start Command?</h3>\n";
	print "<form method=\"post\" action=\"execcmd2.cgi\">\n";
	print "<input type=hidden name=\"outfile\" value=\"nlcsstat.${labid}\">\n";
	print "<input type=hidden name=\"cmd\" value=\"${cmd}\">\n";
	print "<input type=submit value=\"confirm\">\n";
	print "<hr>\n";
	#
	print "</center>\n";
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub cpymems {
	$labid = $FORM_DATA{labid};
	$maxcpymems = $FORM_DATA{maxcpymems};
	$updateioms = $FORM_DATA{updateioms};
	$tl1user = $FORM_DATA{tl1user};
	$tl1passwd = $FORM_DATA{tl1passwd};
	$lynxuser = $FORM_DATA{lynxuser};
	$lynxpasswd = $FORM_DATA{lynxpasswd};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> CPY-MEM ALL IOMS</h3>\n";
	#
	print "<h4>($labid, $maxcpymems, $updateioms, $tl1user, $tl1passwd, $lynxuser, $lynxpasswd)</h4>\n";
	#
	$cmd = "/home/lcstools/tools/bin/webcpymems";
	if ($tl1user ne "") {
		$cmd .= " -u ${tl1user}";
	} else {
		$cmd .= " -u telica";
	}
	if ($tl1passwd ne "") {
		$cmd .= " -p ${tl1passwd}";
	} else {
		$cmd .= " -p telica";
	}
	if ($lynxuser ne "") {
		$cmd .= " -U ${lynxuser}";
	} else {
		$cmd .= " -U root";
	}
	if ($lynxpasswd ne "") {
		$cmd .= " -P ${lynxpasswd}";
	} else {
		$cmd .= " -P plexus9000";
	}
	$cmd .= " -c ${maxcpymems}";
	if ($updateioms eq "yes") {
		$cmd .= " -R";
	}
	$cmd .= " ${labid}";
	#
	print "<h4>CMD: $cmd</h4>\n";
	#
	# startcmd("cpymems.${labid}", $cmd);
	#
	print "<hr>\n";
	print "<h3> Start Command?</h3>\n";
	print "<form method=\"post\" action=\"execcmd2.cgi\">\n";
	print "<input type=hidden name=\"outfile\" value=\"cpymems.${labid}\">\n";
	print "<input type=hidden name=\"cmd\" value=\"${cmd}\">\n";
	print "<input type=submit value=\"confirm\">\n";
	print "<hr>\n";
	#
	print "</center>\n";
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub rmvioms {
	$labid = $FORM_DATA{labid};
	$tl1user = $FORM_DATA{tl1user};
	$tl1passwd = $FORM_DATA{tl1passwd};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> RMV-EQPT ALL IOMS</h3>\n";
	#
	print "<h4>($labid, $tl1user, $tl1passwd)</h4>\n";
	#
	$cmd = "/home/lcstools/tools/bin/webrmvallioms";
	if ($tl1user ne "") {
		$cmd .= " -u ${tl1user}";
	} else {
		$cmd .= " -u telica";
	}
	if ($tl1passwd ne "") {
		$cmd .= " -p ${tl1passwd}";
	} else {
		$cmd .= " -p telica";
	}
	$cmd .= " ${labid}";
	#
	print "<h4>CMD: $cmd</h4>\n";
	#
	# startcmd("rmvioms.${labid}", $cmd);
	#
	print "<hr>\n";
	print "<h3> Start Command?</h3>\n";
	print "<form method=\"post\" action=\"execcmd2.cgi\">\n";
	print "<input type=hidden name=\"outfile\" value=\"rmvioms.${labid}\">\n";
	print "<input type=hidden name=\"cmd\" value=\"${cmd}\">\n";
	print "<input type=submit value=\"confirm\">\n";
	print "<hr>\n";
	#
	print "</center>\n";
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub rstioms {
	$labid = $FORM_DATA{labid};
	$tl1user = $FORM_DATA{tl1user};
	$tl1passwd = $FORM_DATA{tl1passwd};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> RST-EQPT ALL IOMS</h3>\n";
	#
	print "<h4>($labid, $tl1user, $tl1passwd)</h4>\n";
	#
	$cmd = "/home/lcstools/tools/bin/webrstallioms";
	if ($tl1user ne "") {
		$cmd .= " -u ${tl1user}";
	} else {
		$cmd .= " -u telica";
	}
	if ($tl1passwd ne "") {
		$cmd .= " -p ${tl1passwd}";
	} else {
		$cmd .= " -p telica";
	}
	$cmd .= " ${labid}";
	#
	print "<h4>CMD: $cmd</h4>\n";
	#
	# startcmd("rstioms.${labid}", $cmd);
	#
	print "<hr>\n";
	print "<h3> Start Command?</h3>\n";
	print "<form method=\"post\" action=\"execcmd2.cgi\">\n";
	print "<input type=hidden name=\"outfile\" value=\"rstioms.${labid}\">\n";
	print "<input type=hidden name=\"cmd\" value=\"${cmd}\">\n";
	print "<input type=submit value=\"confirm\">\n";
	print "<hr>\n";
	#
	print "</center>\n";
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub updateioms {
	$labid = $FORM_DATA{labid};
	$flashparts = $FORM_DATA{flashparts};
	$all = $FORM_DATA{all};
	$oosma = $FORM_DATA{oosma};
	$oosauflt = $FORM_DATA{oosauflt};
	$oosaumaflt = $FORM_DATA{oosaumaflt};
	$tl1user = $FORM_DATA{tl1user};
	$tl1passwd = $FORM_DATA{tl1passwd};
	$lynxuser = $FORM_DATA{lynxuser};
	$lynxpasswd = $FORM_DATA{lynxpasswd};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> UPDATE IOMS</h3>\n";
	#
	print "<h4>($labid, $flashparts, $all, $oosma, $oosauflt, $oosaumaflt, $tl1user, $tl1passwd, $lynxuser, $lynxpasswd)</h4>\n";
	#
	$cmd = "/home/lcstools/tools/bin/webupdateioms";
	#
	if ($tl1user ne "") {
		$cmd .= " -u ${tl1user}";
	} else {
		$cmd .= " -u telica";
	}
	if ($tl1passwd ne "") {
		$cmd .= " -p ${tl1passwd}";
	} else {
		$cmd .= " -p telica";
	}
	if ($lynxuser ne "") {
		$cmd .= " -U ${lynxuser}";
	} else {
		$cmd .= " -U root";
	}
	if ($lynxpasswd ne "") {
		$cmd .= " -P ${lynxpasswd}";
	} else {
		$cmd .= " -P plexus9000";
	}
	if ($flashparts eq "all") {
		$cmd .= " -A";
	}
	#
	$iomstates = "";
	if ($oosma eq "on") {
		$iomstates .= " oosma";
	}
	if ($oosauflt eq "on") {
		$iomstates .= " oosauflt";
	}
	if ($oosaumaflt eq "on") {
		$iomstates .= " oosaumaflt";
	}
	if ($all eq "on") {
		$iomstates = " +S";
	} elsif ($iomstates ne "") {
		$iomstates =~ s/^[\s]*//;
		$iomstates =~ s/[\s]*$//;
		$iomstates =~ s/ /,/g;
		$iomstates = " -S \'${iomstates}\'";
	}
	#
	$ioms = "";
	for (my ${iomno}=1; ${iomno}<=17; ${iomno}++) {
		$iomstatus = $FORM_DATA{"iom${iomno}"};
		if (defined($iomstatus) && $iomstatus eq "on") {
			$ioms .= ",${iomno}";
		}
	}
	$ioms =~ s/^,*//;
	$iomstatus = $FORM_DATA{iomall};
	if (defined($iomstatus) && $iomstatus eq "on") {
		$ioms = "";
	} elsif ($ioms ne "") {
		$ioms = " -I \'${ioms}\'";
	}
	#
	$cmd .= " ${iomstates} ${ioms} ${labid}";
	#
	print "<h4>CMD: $cmd</h4>\n";
	#
	# startcmd("updateioms.${labid}", $cmd);
	#
	print "<hr>\n";
	print "<h3> Start Command?</h3>\n";
	print "<form method=\"post\" action=\"execcmd2.cgi\">\n";
	print "<input type=hidden name=\"outfile\" value=\"updateioms.${labid}\">\n";
	print "<input type=hidden name=\"cmd\" value=\"${cmd}\">\n";
	print "<input type=submit value=\"confirm\">\n";
	print "<hr>\n";
	#
	print "</center>\n";
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub recoversps {
	$labid = $FORM_DATA{labid};
	$bootsps = $FORM_DATA{bootsps};
	$tl1user = $FORM_DATA{tl1user};
	$tl1passwd = $FORM_DATA{tl1passwd};
	$lynxuser = $FORM_DATA{lynxuser};
	$lynxpasswd = $FORM_DATA{lynxpasswd};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> RECOVER SPS</h3>\n";
	#
	print "<h4>($labid, $bootsps, $tl1user, $tl1passwd, $lynxuser, $lynxpasswd)</h4>\n";
	#
	$cmd = "/home/lcstools/tools/bin/webrecoversps";
	#
	if ($tl1user ne "") {
		$cmd .= " -u ${tl1user}";
	} else {
		$cmd .= " -u telica";
	}
	if ($tl1passwd ne "") {
		$cmd .= " -p ${tl1passwd}";
	} else {
		$cmd .= " -p telica";
	}
	if ($lynxuser ne "") {
		$cmd .= " -U ${lynxuser}";
	} else {
		$cmd .= " -U root";
	}
	if ($lynxpasswd ne "") {
		$cmd .= " -P ${lynxpasswd}";
	} else {
		$cmd .= " -P plexus9000";
	}
	if ($bootsps eq "min-mode") {
		$cmd .= " -m";
	} elsif ($bootsps eq "app-mode") {
		$cmd .= " -a";
	}
	#
	$cmd .= " ${labid}";
	#
	print "<h4>CMD: $cmd</h4>\n";
	#
	# startcmd("recoversps.${labid}", $cmd);
	#
	print "<hr>\n";
	print "<h3> Start Command?</h3>\n";
	print "<form method=\"post\" action=\"execcmd2.cgi\">\n";
	print "<input type=hidden name=\"outfile\" value=\"recoversps.${labid}\">\n";
	print "<input type=hidden name=\"cmd\" value=\"${cmd}\">\n";
	print "<input type=submit value=\"confirm\">\n";
	print "<hr>\n";
	#
	print "</center>\n";
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub auditips {
	$labid = $FORM_DATA{labid};
	$fixips = $FORM_DATA{fixips};
	$lynxuser = $FORM_DATA{lynxuser};
	$lynxpasswd = $FORM_DATA{lynxpasswd};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> AUDIT SP IPS</h3>\n";
	#
	print "<h4>($labid, $fixips, $lynxuser, $lynxpasswd)</h4>\n";
	#
	$cmd = "/home/lcstools/tools/bin/webauditsps";
	if ($lynxuser ne "") {
		$cmd .= " -U ${lynxuser}";
	} else {
		$cmd .= " -U root";
	}
	if ($lynxpasswd ne "") {
		$cmd .= " -P ${lynxpasswd}";
	} else {
		$cmd .= " -P plexus9000";
	}
	if ($fixips eq "yes") {
		$cmd .= " -f";
	}
	if ($labid eq "ALL_LABS") {
		$cmd .= " -a";
	} else {
		$cmd .= " ${labid}";
	}
	#
	print "<h4>CMD: $cmd</h4>\n";
	#
	# startcmd("auditsps.${labid}", $cmd);
	#
	print "<hr>\n";
	print "<h3> Start Command?</h3>\n";
	print "<form method=\"post\" action=\"execcmd2.cgi\">\n";
	print "<input type=hidden name=\"outfile\" value=\"auditsps.${labid}\">\n";
	print "<input type=hidden name=\"cmd\" value=\"${cmd}\">\n";
	print "<input type=submit value=\"confirm\">\n";
	#
	print "</center>\n";
	print "<hr>\n";
	#
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub taillogfiles {
	$labid = $FORM_DATA{labid};
	$logfiletype = $FORM_DATA{logfiletype};
	$lines = $FORM_DATA{lines};
	#
	my $ignorelabid = ${filedata}{${logfiletype}}{ignorelabid};
	my $pattern = ${filedata}{${logfiletype}}{pattern};
	my $lslines = 0;
	if (${labid} ne "NONE" && ${ignorelabid} ne "yes") {
		$pattern =~ s/<labid>/${labid}/g;
		$lslines = 10;
	} else {
		$pattern =~ s/<labid>//g;
		$pattern =~ s/\*\**/\*/g;
		$lslines = 50;
	}
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> TAIL LOG FILES</h3>\n";
	#
	print "<h4>($labid, $logfiletype, $pattern)</h4>\n";
	print "</center>\n";
	#
	print "<pre>\n";
	open(PIPE, "/usr/bin/ls -lt ${pattern} 2>&1 | sed -n '1,${lslines}p' |");
	#
	PIPE->autoflush(1);
	STDOUT->autoflush(1);
	#
	while (defined($urec = <PIPE>)) {
		chomp($urec);
		if ($urec =~ /no *such *file *or *directory/i) {
			print "${urec}\n";
			last;
		}
		$urec =~ /^(.*) ([^ ]*)$/;
		print "${1} <a href=\"taillogfile.cgi?logfile=${2}\&lines=${lines}\" target=\"contents\">${2}</a>\n";
	}
	close(PIPE);
	STDOUT->autoflush(0);
	print "</pre>\n";
	#
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub rtrveqptdata {
	$labid = $FORM_DATA{labid};
	$rtrveqptcmd = $FORM_DATA{rtrveqptcmd};
	$tl1params = $FORM_DATA{tl1params};
	$tl1user = $FORM_DATA{tl1user};
	$tl1passwd = $FORM_DATA{tl1passwd};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> RTRV EQPT DATA</h3>\n";
	#
	print "<h4>($labid, $rtrveqptcmd, $tl1user, $tl1passwd)</h4>\n";
	#
	$cmd = "/home/lcstools/tools/bin/webtl1";
	if ($tl1user ne "") {
		$cmd .= " -u ${tl1user}";
	} else {
		$cmd .= " -u telica";
	}
	if ($tl1passwd ne "") {
		$cmd .= " -p ${tl1passwd}";
	} else {
		$cmd .= " -p telica";
	}
	$cmd .= " -l ${labid} \"${rtrveqptcmd}${tl1params}\"";
	#
	print "<h4>CMD: $cmd</h4>\n";
	print "</center>\n";
	#
	startcmd("rtrveqptdata.${labid}", $cmd);
	#
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub lcsreboot {
	$labid = $FORM_DATA{labid};
	$type = $FORM_DATA{type};
	$sps = $FORM_DATA{sps};
	$removesyncxml = $FORM_DATA{removesyncxml};
	$removeconfigdata = $FORM_DATA{removeconfigdata};
	$unconditional = $FORM_DATA{unconditional};
	$lynxuser = $FORM_DATA{lynxuser};
	$lynxpasswd = $FORM_DATA{lynxpasswd};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> LCS REBOOT </h3>\n";
	#
	print "<h4>($labid, $type, $sps, $removesyncxml, $removeconfigdata, $unconditional, $lynxuser, $lynxpasswd)</h4>\n";
	#
	$cmd = "/home/lcstools/tools/bin/weblcsreboot";
	#
	if ($lynxuser ne "") {
		$cmd .= " -u ${lynxuser}";
	} else {
		$cmd .= " -u root";
	}
	if ($lynxpasswd ne "") {
		$cmd .= " -p ${lynxpasswd}";
	} else {
		$cmd .= " -p plexus9000";
	}
	if ($removesyncxml eq "on") {
		$cmd .= " -S";
	}
	if ($removeconfigdata eq "on") {
		$cmd .= " -C";
	}
	if ($unconditional eq "on") {
		$cmd .= " -U";
	}
	#
	if ($sps eq "spa") {
		$cmd .= " -A";
	} elsif ($sps eq "spb") {
		$cmd .= " -B";
	}
	#
	if ($type eq "minmode") {
		$cmd .= " -m";
	} elsif ($type eq "appmode") {
		$cmd .= " -a";
	}
	#
	$cmd .= " ${labid}";
	#
	print "<h4>CMD: $cmd</h4>\n";
	#
	# startcmd("updateioms.${labid}", $cmd);
	#
	print "<hr>\n";
	print "<h3> Start Command?</h3>\n";
	print "<form method=\"post\" action=\"execcmd2.cgi\">\n";
	print "<input type=hidden name=\"outfile\" value=\"lcsreboot.${labid}\">\n";
	print "<input type=hidden name=\"cmd\" value=\"${cmd}\">\n";
	print "<input type=submit value=\"confirm\">\n";
	print "<hr>\n";
	#
	print "</center>\n";
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub gench2ioms {
	$labid = $FORM_DATA{labid};
	$laball = $FORM_DATA{laball};
	$labre = $FORM_DATA{labre};
	$branch = $FORM_DATA{branch};
	$branchall = $FORM_DATA{branchall};
	$merge = $FORM_DATA{merge};
	$tl1user = $FORM_DATA{tl1user};
	$tl1passwd = $FORM_DATA{tl1passwd};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> GENERATE CHASSIS2IOMS</h3>\n";
	#
	print "<h4>($labid, $laball, $labre, $branch, $branchall, $merge, $tl1user, $tl1passwd )</h4>\n";
	#
	$cmd = "/home/lcstools/tools/bin/weblcsgench2ioms";
	#
	if ($tl1user ne "") {
		$cmd .= " -u ${tl1user}";
	} else {
		$cmd .= " -u telica";
	}
	if ($tl1passwd ne "") {
		$cmd .= " -p ${tl1passwd}";
	} else {
		$cmd .= " -p telica";
	}
	#
	if ($merge eq "on") {
		$cmd .= " -M";
	}
	#
	if ($branchall eq "on") {
		$cmd .= " -B";
	} else {
		$cmd .= " -b ${branch}";
	}
	#
	if ($laball eq "on") {
		$cmd .= " -L";
		$labid = "alllabs";
	} elsif ($labre ne "") {
		$cmd .= " -R \'${labre}\'";
		$labid = "labre";
	} else {
		$cmd .= " ${labid}";
	}
	#
	print "<h4>CMD: $cmd</h4>\n";
	#
	print "<hr>\n";
	print "<h3> Start Command?</h3>\n";
	print "<form method=\"post\" action=\"execcmd2.cgi\">\n";
	print "<input type=hidden name=\"outfile\" value=\"gench2ioms.${labid}\">\n";
	print "<input type=hidden name=\"cmd\" value=\"${cmd}\">\n";
	print "<input type=submit value=\"confirm\">\n";
	print "<hr>\n";
	#
	print "</center>\n";
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub syncfs {
	$labid = $FORM_DATA{labid};
	$unconditional = $FORM_DATA{unconditional};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> SYNCHRONIZE MA BASESCRIPTS </h3>\n";
	#
	print "<h4>($labid, $unconditional)</h4>\n";
	#
	$cmd = "/home/lcstools/tools/bin/weblcssyncfs";
	if ($unconditional eq "on") {
		$cmd .= " -U";
	}
	$fromfs = "/lcsl100/basescripts";
	$tofs = "/home2/tester/bin/lcstools/lcsl100/basescripts";
	if ($labid ne "all_labs") {
		$fromfs .= "/${labid}";
		$tofs .= "/${labid}";
	}
	$cmd .= " ${fromfs}";
	$cmd .= " ${tofs}";
	#
	$cmd .= " 2>&1";
	#
	print "<h4>CMD: $cmd</h4>\n";
	#
	print "<hr>\n";
	print "<h3> Start Command?</h3>\n";
	print "<form method=\"post\" action=\"execcmd2.cgi\">\n";
	print "<input type=hidden name=\"outfile\" value=\"syncfs.${labid}\">\n";
	print "<input type=hidden name=\"cmd\" value=\"${cmd}\">\n";
	print "<input type=submit value=\"confirm\">\n";
	print "<hr>\n";
	#
	print "</center>\n";
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub ftpload {
	$ftpload = $FORM_DATA{ftpload};
	$ftpuser = $FORM_DATA{ftpuser};
	$ftppasswd = $FORM_DATA{ftppasswd};
	$ftpmachine = $FORM_DATA{ftpmachine};
	$ftpdirectory = $FORM_DATA{ftpdirectory};
	#
	my ($ftpbranch, $ftpcpuload) = split /\s/, "${ftpload}", 2;
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> FTP LOAD - ${ftpload} </h3>\n";
	#
	print "<h4>($ftpbranch, $ftpcpuload, $ftpuser, $ftppasswd, $ftpmachine)</h4>\n";
	#
	print "<form method=\"post\" action=\"ftpload.cgi\">\n";
	#
	print "<h4>Choose files to FTP:<br><br>\n";
	#
	system("/opt/exp/lib/unity/bin/uprintf -q -f\"%s %s\\n\" type name in /home/lcstools/tools/data/images where branch req \"^${ftpbranch}\$\" and cpuload req \"^${ftpcpuload}\$\"| sort -u >/tmp/data.$$ 2>&1 ");
	#
	open(INFD, "/tmp/data.$$") or die "can't open /tmp/data.$$";
	#
	$ftptypes = "";
	#
	while (defined($rec = <INFD>)) {
		chomp($rec);
		my ($ftptype, $ftpname) = split / /, ${rec}, 2;
		print "<input type=\"checkbox\" name=\"${ftptype}file\" value=\"${ftpname}\"> ${ftpname}<br>\n";
		$ftptypes .= " ${ftptype}";
	}
	$ftptypes =~ s/^\s//;
	#
	close(INFD);
	#
	unlink("/tmp/data.$$");
	#
	print "</h4>\n";
	#
	print "<h4><hr>\n";
	print "Choose operation:\n";
	print "<select name=ftpoperation>\n";
	print "<option> verify\n";
	print "<option selected> execute\n";
	print "</select>\n";
	print "</h4>\n";
	#
	print "<input type=hidden name=\"ftpbranch\" value=\"${ftpbranch}\">\n";
	print "<input type=hidden name=\"ftpcpuload\" value=\"${ftpcpuload}\">\n";
	#
	print "<input type=hidden name=\"ftpuser\" value=\"${ftpuser}\">\n";
	print "<input type=hidden name=\"ftppasswd\" value=\"${ftppasswd}\">\n";
	print "<input type=hidden name=\"ftpmachine\" value=\"${ftpmachine}\">\n";
	print "<input type=hidden name=\"ftpdirectory\" value=\"${ftpdirectory}\">\n";
	print "<input type=hidden name=\"ftptypes\" value=\"${ftptypes}\">\n";
	print "<input type=submit value=\"submit\">\n";
	print "<input type=reset value=\"reset\">\n";
	print "<hr>\n";
	#
	print "</center>\n";
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub bbbscripts {
	$bbblabid = $FORM_DATA{bbblabid};
	$bbboper = $FORM_DATA{bbboper};
	$bbbtype = $FORM_DATA{bbbtype};
	$bbbverbose = $FORM_DATA{bbbverbose};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> Create BBB TL1 Scripts For Labid ${bbblabid}</h3>\n";
	print "<h4>($bbblabid, $bbboper, $bbbtype, $bbbverbose)</h4>\n";
	#
	print "<form method=\"post\" action=\"bbbscripts.cgi\">\n";
	#
	print "<h4>Branch: \n";
	print "<select name=bbbbranch>\n";
	#
	system("ls /lcsl100/basescripts/${bbblabid} | sort -u >/tmp/data.$$ 2>&1 ");
	#
	open(DATAFD, "/tmp/data.$$") or die "can't open /tmp/data.$$";
	#
	if ($bbboper ne "mcreate") {
		print "<option> ALL_BRANCHES\n";
	}
	#
	while (defined($rec = <DATAFD>)) {
		chomp($rec);
		if ( ! -d "/lcsl100/basescripts/${bbblabid}/${rec}") {
			next;
		}
		print "<option> ${rec}\n";
	}
	#
	close(DATAFD);
	#
	unlink("/tmp/data.$$");
	#
	print "</select>\n";
	print "</h4>\n";
	#
	print "<input type=hidden name=\"bbblabid\" value=\"${bbblabid}\">\n";
	print "<input type=hidden name=\"bbboper\" value=\"${bbboper}\">\n";
	print "<input type=hidden name=\"bbbtype\" value=\"${bbbtype}\">\n";
	print "<input type=hidden name=\"bbbverbose\" value=\"${bbbverbose}\">\n";
	#
	print "<input type=submit value=\"submit\">\n";
	print "<input type=reset value=\"reset\">\n";
	print "</center>\n";
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub getsploads {
	$labid = $FORM_DATA{labid};
	$dospa = $FORM_DATA{dospa};
	$dospb = $FORM_DATA{dospb};
	$bothsps = $FORM_DATA{bothsps};
	$lynxuser = $FORM_DATA{lynxuser};
	$lynxpasswd = $FORM_DATA{lynxpasswd};
	$verbose = $FORM_DATA{verbose};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> GET SP LOADS</h3>\n";
	#
	print "<h4>($labid, $dospa, $dospb, $bothsps, $lynxuser, $lynxpasswd, $verbose)</h4>\n";
	#
	$cmd = "/home/lcstools/tools/bin/webgetsploads";
	if ($lynxuser ne "") {
		$cmd .= " -u ${lynxuser}";
	} else {
		$cmd .= " -u root";
	}
	if ($lynxpasswd ne "") {
		$cmd .= " -p ${lynxpasswd}";
	} else {
		$cmd .= " -p plexus9000";
	}
	if ($bothsps eq "on") {
		$cmd .= " -A -B";
	} else {
		if ($dospa eq "on") {
			$cmd .= " -A";
		}
		if ($dospb eq "on") {
			$cmd .= " -B";
		}
	}
	if ($verbose eq "on") {
		$cmd .= " -V";
	}
	$cmd .= " ${labid}";
	#
	print "<h4>CMD: $cmd</h4>\n";
	#
	print "<hr>\n";
	print "<h3> Start Command?</h3>\n";
	print "<form method=\"post\" action=\"execcmd2.cgi\">\n";
	print "<input type=hidden name=\"outfile\" value=\"getsploads.${labid}\">\n";
	print "<input type=hidden name=\"cmd\" value=\"${cmd}\">\n";
	print "<input type=submit value=\"confirm\">\n";
	print "<hr>\n";
	#
	print "</center>\n";
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub cleanupsps {
	$labid = $FORM_DATA{labid};
	$sps = $FORM_DATA{sps};
	$lynxuser = $FORM_DATA{lynxuser};
	$lynxpasswd = $FORM_DATA{lynxpasswd};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> Clean Up SPs</h3>\n";
	#
	print "<h4>($labid, $sps, $lynxuser, $lynxpasswd)</h4>\n";
	print "</center>\n";
	#
	print "<h4> Collecting data from SPs: </h4>\n";
	#
	$cmd = "/home/lcstools/tools/bin/webgetsploadsonly";
	$cmd .= " -u ${lynxuser}";
	$cmd .= " -p ${lynxpasswd}";
	#
	if ($sps eq "spa") {
		$cmd .= " -A";
	} elsif ($sps eq "spb") {
		$cmd .= " -B";
	} else {
		$cmd .= " -A -B";
	}
	$cmd .= " ${labid}";
	#
	print "<h4><pre>\n";
	open(PIPE, "${cmd} 2>&1 |");
	#
	PIPE->autoflush(1);
	STDOUT->autoflush(1);
	#
	$maxidx = 0;
	while (defined($urec = <PIPE>)) {
		# remove leading/trailing whitespace
		chomp($urec);
		# skip junk records
		if ($urec !~ /^spdata\(sp-[ab],/i) {
			next;
		}
		# scan these records for the load data
		if ($urec =~ /^spdata\((sp-[ab]),currrel,path\) *= *(.*)$/i) {
			print "==>> ${1} CURREL - ${2}\n";
			$spdata{${1}}{currrel} = ${2};
			$currrelcpuloads{${1}} = basename(${2});
		} elsif ($urec =~ /^spdata\((sp-[ab]),[0-9]*,path\) *= *(.*)$/i) {
			print "==>> ${1} PATH - ${2}\n";
			$spdata{${1}}{${maxidx}} = ${2};
		} else {
			# skip anything else
			next;
		}
		$maxidx += 1;
	}
	#
	close(PIPE);
	print "</pre></h4>\n";
	#
	if ($maxidx <= 0) {
		fatalerrormsg(0,"ERROR: Unable to determine SP loads.");
	}
	#
	print "<h4> Choose loads to delete from SPs: </h4>\n";
	print "<form method=\"post\" action=\"maint4.cgi\">\n";
	#
	foreach $sp (sort keys %{spdata}) {
		$currrelcpuload = $currrelcpuloads{${sp}};
		print "<h4> SP: ${sp} CURREL: ${currrelcpuload}</h4><h4>\n";
		foreach $idx (sort keys %{$spdata{${sp}}}) {
			if ($idx !~ /^[0-9]*$/) {
				# skip anything that is not an index.
				next;
			}
			$load = $path = $spdata{${sp}}{${idx}};
			$load = basename(${load});
			if ($path =~ /.*swCPU.*/ && $load eq $currrelcpuload) {
				print "<input type=\"checkbox\" name=\"path${idx}\" value=\"${sp} ${path} CURRREL\"> ${path} &nbsp;&nbsp;&lt;&lt;&lt;=== CURR REL LOAD (MUST BE IN MIN-MODE)<br>\n";
			} else {
				print "<input type=\"checkbox\" name=\"path${idx}\" value=\"${sp} ${path} NOTCURRREL\"> ${path}<br>\n";
			}
		}
		print "</h4>\n";
	}
	#
	print "<input type=hidden name=\"labid\" value=\"${labid}\">\n";
	print "<input type=hidden name=\"sps\" value=\"${sps}\">\n";
	print "<input type=hidden name=\"lynxuser\" value=\"${lynxuser}\">\n";
	print "<input type=hidden name=\"lynxpasswd\" value=\"${lynxpasswd}\">\n";
	print "<input type=hidden name=\"maxidx\" value=\"${maxidx}\">\n";
	print "<input type=hidden name=\"operation\" value=\"${operation}\">\n";
	#
	print "<center>\n";
	print "<input type=submit value=\"submit\">\n";
	print "<input type=reset value=\"reset\">\n";
	print "</center>\n";
	#
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub OLDcleanupsps {
	$labid = $FORM_DATA{labid};
	$sps = $FORM_DATA{sps};
	#
	$removecurrentcpuloads = $FORM_DATA{removecurrentcpuloads};
	$removeoldcpuloads = $FORM_DATA{removeoldcpuloads};
	$removecurrentiomloads = $FORM_DATA{removecurrentiomloads};
	$removeoldiomloads = $FORM_DATA{removeoldiomloads};
	#
	$lynxuser = $FORM_DATA{lynxuser};
	$lynxpasswd = $FORM_DATA{lynxpasswd};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> Clean Up SPs</h3>\n";
	#
	print "<h4>($labid, $dospa, $dospb, $removecurrentcpuloads, $removeoldcpuloads, $removecurrentiomloads, $removeoldiomloads, $lynxuser, $lynxpasswd)</h4>\n";
	#
	$cmd = "/home/lcstools/tools/bin/webcleanupsps";
	if ($sps eq "spa") {
		$cmd .= " -A";
	} elsif ($sps eq "spb") {
		$cmd .= " -B";
	}
	if ($removecurrentcpuloads eq "on") {
		$cmd .= " -C";
	}
	if ($removeoldcpuloads eq "on") {
		$cmd .= " -c";
	}
	if ($removecurrentiomloads eq "on") {
		$cmd .= " -I";
	}
	if ($removeoldiomloads eq "on") {
		$cmd .= " -i";
	}
	if ($lynxuser ne "") {
		$cmd .= " -u ${lynxuser}";
	} else {
		$cmd .= " -u telica";
	}
	if ($lynxpasswd ne "") {
		$cmd .= " -p ${lynxpasswd}";
	} else {
		$cmd .= " -p plexus9000";
	}
	$cmd .= " ${labid}";
	#
	print "<h4>CMD: $cmd</h4>\n";
	#
	print "<hr>\n";
	print "<h3> Start Command?</h3>\n";
	print "<form method=\"post\" action=\"execcmd2.cgi\">\n";
	print "<input type=hidden name=\"outfile\" value=\"cleanupsps.${labid}\">\n";
	print "<input type=hidden name=\"cmd\" value=\"${cmd}\">\n";
	print "<input type=submit value=\"confirm\">\n";
	print "<hr>\n";
	#
	print "</center>\n";
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
sub procstatus {
	$userid = $FORM_DATA{userid};
	#
	print "Content-type: text/html\n\n";
	#
	print "<html>\n";
	print "<body bgcolor=\"E0E0E0\">\n";
	print "<center>\n";
	#
	print "<h3> Process Status: ${userid}</h3>\n";
	#
	print "</center>\n";
	#
	print "<pre>\n";
	if (${userid} eq "all" || ${userid} eq "") {
		open(PIPE, "/usr/bin/ps -fe 2>&1 |");
	} else {
		open(PIPE, "/usr/bin/ps -fu ${userid} 2>&1 |");
	}
	#
	PIPE->autoflush(1);
	STDOUT->autoflush(1);
	#
	while (defined($urec = <PIPE>)) {
		chomp($urec);
		if ($urec =~ /no *such *file *or *directory/i) {
			print "${urec}\n";
			last;
		}
		print "${urec}\n";
	}
	close(PIPE);
	STDOUT->autoflush(0);
	print "</pre>\n";
	#
	print "</body>\n";
	print "</html>\n";
	#
	return(0);
}
#
parse_form_data();
$operation = $FORM_DATA{operation};
#
my $retval = -2;
if (defined(&{${operation}})) {
	$retval = &{${operation}}();
} else {
	fatalerrormsg(1,"ERROR: Unknown maintenance operation: ${operation}");
}
#
exit($retval);

