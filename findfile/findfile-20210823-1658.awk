#
# Associate files with routines
#
# 20210816 - Work on this:
# Getting wrong filenums for IBCNEHL4.m
# a) Allow for multiple filenums per line:
#    1) DIE line
#    2) Other lines
# b) S DIE="^IB(",DA=IBN,DR=".05////"_$S(IBERR="":3,1:9)
#    D ^DIE K DIE,DR,DA
# c) Allow for:
#    S DGFDA(1,29.11,"+1,",6)=DGSITE ;
#    D UPDATE^DIE("","DGFDA(1)","MSTIEN","DGERR")
# d) Allow for:
#    TESTVAL(DGFIL,DGFLD,DGVAL)      ; Determine if a field value is valid.
#     .. D CHK^DIE(DGFIL,DGFLD,,DGVALEX,.DGRSLT) I DGRSLT="^" S VALID=0
#
# Find file number value for parameter variable
#
BEGIN {
	debug                = 1;
	tags["FILE"]         = 2;
	tags["UPDATE"]       = 2;
	tags["HELP"]         = 1;
	tags["WP"]           = 1;
	tags["CHK"]          = 1;
	linesfound[" "][" "] = "";
}

function getFilenumValue(routine,linecnt2,var, linecnt3, fnd, i) {
	linecnt3 = linecnt2 - 1; 
	len      = length(var) + 2;
	line     = lines[routine][linecnt3]; 
	#
	# Stop when tag line is found
	#
	while (line ~ /^( |\t)/) {
		if (debug) print "   Looking for Set <var> = " line
		fnd = index(line,"S " var); # Find Set <var>
		if (fnd > 0) {
			if (debug) print "      fnd > 0"
			#
			# Make sure it's a set 
			#
			if (substr(line,fnd-1) ~ /[ |\t]/) {
				if (debug) print "      It's a set"
				#
				# Make sure the rest of the line is:
				# . 0 or more spaces
				# . =
				# . 0 or more spaces
				#
				if (substr(line,fnd+len) ~ /^ *= */) {
					if (debug) print "finding =: " substr(line,fnd+len)
					line = substr(line,fnd+len); 
					fnd  = index(line,"="); 
					line = substr(line,fnd+1);
					pos  = 0; 
					#
					# Looking for 1st non-space character after =
					#
					for (i = 1; i<= length(line); i++) { 
						if (substr(line,i,1) != " ") { 
							pos = i;
							break
						} 
					}
					if (pos > 0) {
						if (debug) print "      pos > 0"
						split(substr(line,pos),arr," "); 
						filenum = arr[1]; 
						if (debug) print "      GFV 1: filenum = |" filenum "|"
						#
						# If parameter value is a $Select statement
						#
						if (filenum ~ /\$(S|s|SELECT|select|Select)\)/) {
							print "      **"
							if (debug) print "      GFV 2: $Select"
							filenum = substr(filenum,4,length(filenum)-4);
							n       = split(filenum,arr,",");
							for (i = 1; i <= n; i++) {
								phrase                  = arr[i];
								split(phrase,arr2,":");
								filenum                 = arr2[2];
								gsub(/"/,"",filenum);
								if (filenum != "") {
									if (debug) print "      GFV 2a: filenum = '" filenum "'"
									if (substr(filenum,length(filenum)) == ")") {
										filenum = substr(filenum,1,length(filenum)-1);
										i       = n
										print "      GFV 2b: filenum = '" filenum "'"
									}
									saveFilenum(routine,filenum,lines[routine][linecnt3])
								}
							}
						}
						else if (filenum = "\"\"") {
							print "      ***"
							print "      GFV 3: double quotes - '" filenum "'"
							filenum = "Ends in double quotes"
						} 
						else if (substr(line,pos + 2) ~ / (F|f|FOR|for) /) {
							print "      ****"
							print "      GFV 4: For"
							filenum = "<LOOP>"
						}
						else if (filenum ~ /^\$(P|p|PIECE|piece)\(/) {
							print "      *****"
							print "      GFV 5: PIECE"
							filenum = "line = " line ", filenum = " filenum
						}
						else {
							print "      ******"
							print "     GFV 6: Unknown"
							filenum = "<Unknown>" 
						}
						saveFilenum(routine,filenum)
					} 
				} 
			}
		}
		line = lines[routine][--linecnt3]
	}

}

#
# Check for various <tag>^DIE(
#
function getPieceNum(line,fnd) {
	piecenum = 0;
	for (tag in tags) {
		len = length(tag);
		if (substr(line,fnd - len - 4, len) == tag) {
			piecenum = tags[tag];
			break
		}
	}

	return piecenum

}

function printRoutinesAndFiles(routine) {
	if ((routine in linesfound) == 1) {
		for (linecnt in linesfound[routine]) { 
			line = lines[routine][linecnt];
			#
			# Ignore comment lines
			#
			# if (substr(line,2,1) == ";") {
		 	if (substr(line,2) ~ /^(\. *)?1;/) {
				continue
			}
			while (1) {
				if (debug) print "printRoutines..."
				fnd  = index(line,"^DIE(");
				#
				# Looking for ^DIE(
				#
	
				if (fnd == 0) {
					break
				}
				fnd      = fnd + 4;
				piecenum = getPieceNum(line,fnd);
				if (debug) print "   prt: line     = " line
				if (debug) print "   prt: piecenum = " piecenum
	
				#
				# Did not find the tags we were looking for
				#
				if (piecenum == 0) {
					line = substr(line,fnd);
					continue
				}
				#
				# Looking for parameter which holds the name of the file
				#
				if (debug) print "   prt: line 1 = " line
				line = substr(line,fnd+1); 
				if (debug) print "   prt: line 2 = " line
				n    = split(line,arr,",");
				split(arr[piecenum],arr2,")"); 
				filenum = arr2[1]; 
				gsub(/"/,"",filenum); 
				if (debug) print "   prt: filenum = " filenum
				if (debug) print "   prt: line = " line
				if (debug) print "   prt: length(filenum) = " length(filenum)
				if (length(filenum) > 0) { 
					if (filenum ~ /^[0-9]+$/) { 
						if (debug) print "   prt: Integer" 
						saveFilenum(routine,filenum,lines[routine][linecnt]) 
					} 
					else { 
						if (debug) print "   prt: B1" 
						if (filenum ~ /^[0-9]+\.[0-9]+$/) { 
							if (debug) print "   prt: Decimal"
							saveFilenum(routine,filenum,lines[routine][linecnt]) 
						} 
						else { 
							if (debug) print "   prt: B3: filenum = " filenum 
							len      = length(filenum); 
							line2    = lines[routine][linecnt]; 
							if (debug) print "   prt: Other"
							scanLines(line2,filenum,len,routine,linecnt) 
						}
					}
				}
				else {
					filenum = "<Empty string>"
					if (debug) print "   prt: filenum = " filenum
					saveFilenum(routine,filenum,lines[routine][linecnt])
				}
			} 
		}
	}
}

#
# Save filenum/routine
#
function saveFilenum(routine,filenum,line) {
	if (index(filenum,",") > 0) {
		filenum = "Unknown: " routine " / " line
	}
	else {
		if (filenum ~ /"[0-9]+\.[0-9]+"/) {
			gsub(/"/,"",filenum)
		}
	}
	rtnfile[routine][filenum] = ""; 
	filenums[filenum]         = "" 
}

#
# Scanning lines above <tag>^DIE( for file number
#
function scanLines(line,filenum,len,routine,linecnt2) {
	#
	# Stop at the line with the tag
	#
	if (debug) print "scanLines"
	while (line ~ /^( |\t)/) {
		if (debug) print "scanLines: line = " line
		flg = 0;
		#
		# Ignore comment lines
		#
		if (substr(line,2) ~ /^(\. *)?1;/) {
			line = lines[routine][--linecnt2];
			continue
		}
		if (substr(line,2) ~ /^\. *;/) {
			line = lines[routine][--linecnt2];
			continue
		}

		fnd = index(line,"FDA^DILF(");
		if (fnd > 0) {
			if (debug) print "   scan A"
			line    = substr(line,fnd + 9);
			split(line,arr,",");
			split(arr[1],arr2,")");
			filenum = arr2[1];
			flg     = 1
		}
		else { 
			if (debug) print "   scan B: line = " line " | filenum = " filenum
			#
			# Looking for line with parameter/name in it
			#
			if (filenum ~ /[0-9]+(\.[0-9]+)?/) {
				flg = 1
			}
			else { 
				fnd = index(line,filenum "("); 
				if (fnd > 0) { 
					if (debug) print "   scan B2: fnd = " fnd 
					line                 = substr(line,fnd + len + 1); 
					split(line,arr,","); 
					filenum              = arr[1]; 
					if (debug) print "   scan B3: filenum = " filenum 
					if (filenum != "") { 
						flg          = 1 
					} 
				}
			}
		}
		if (flg == 1) {
			if (debug) print "   scan C"
			#
			# If parameter name is alphabetic, search for corresponding value
			#
			if (debug) print "   scan C2"
			if (filenum ~ /[A-Z]+/) {
				if (debug) print "   scan C3: " filenum
				getFilenumValue(routine,linecnt2,filenum)
			}
			else { 
				#
				# Otherwise, store value
				#
				if (debug) print "   scan C4: " filenum
				saveFilenum(routine,filenum)
			}
		}
		line = lines[routine][--linecnt2]
	}
}

(FNR == 1) {
	if (NR != 1) {
		printRoutinesAndFiles(routine)
	}
	routine = FILENAME
}

{ 
	lines[routine][FNR] = $0; 
	if (index($0,"^DIE(")) { linesfound[routine][FNR] = 1 } 
} 

END {
	printRoutinesAndFiles(routine);
	n1 = asorti(rtnfile,rtnfile2);
	n2 = asorti(filenums,filenums2,"@ind_num_asc");
	if (debug) print "# of filenums = " n2
	header = "Routines";
	for (i = 1; i <= n2; i++) {
		filenum            = filenums2[i];
		header             = header "," filenum;
		filenums3[filenum] = i
	}
	print header;
	#
	# For each routine
	#
	for (i = 1; i <= n1; i++) {
		rtn  = rtnfile2[i];
		data = rtn;
		#
		# For each file number
		for (j = 1; j <= n2; j++) {
			filenum    = filenums2[j];
			filenumpos = filenums3[filenum];
			#
			# Routine accesses the file number
			#
			if (filenum in rtnfile[rtn]) { 
				data = data ",X"
			}
			#
			# Routine does not access the file number
			#
			else {
				data = data ","
			}
		}
		print data
	}
}
