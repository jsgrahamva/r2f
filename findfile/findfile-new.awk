# test 1
# test 2
# test3
test4
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
	msgcnt               = 0;
	tags["FILE"]         = 2;
	tags["UPDATE"]       = 2;
	tags["HELP"]         = 1;
	tags["WP"]           = 1;
	tags["CHK"]          = 1;
	linesfound[" "][" "] = "";
}

function doSaves(routine,filenum) {
	if (rtnfile[routine][filenum] == "") {
		rtnfile[routine][filenum] = 1; 
		filenums[filenum]         = 1
	}
}

# Found file num variable in scanLines.  Now find the value for the variable representing the file number
#
function getFilenumVariable(routine,linecnt,filenumArray, arr, arr2, filenumValue, fnd, len, line, linecnt2) {
	linecnt2 = linecnt - 1; 
	len      = length(filenumArray) + 2;
	line     = lines[routine][linecnt2]; 
	#
	# Stop when tag line is found
	#
	while (line ~ /^( |\t)/) {
		while (1) {
			len          = length(filenumArray)
			fnd          = index(line, filenumArray "(")
			if (!fnd) break
			split(substr(line, fnd),arr,"(");
			split(arr[2], arr2, ",");
			filenumValue = arr2[1]
			if (filenumValue ~ /^([a-z]|[A-Z])/) {
				getFilenumValue(routine,linecnt2,filenumValue)
			}
			else {
				doSaves(routine,filenumValue)
			}
			line         = substr(line, fnd + 1)
		}
		line                 = lines[routine][--linecnt2]
	}
}

# Found file num variable in scanLines.  Now find the value for the variable representing the file number
#
function getFilenumValue(routine,linecnt3,filenumValue, fnd, fnd2, i, len, line, linecnt, line2, pos, value) {
	len     = length(filenumValue);
	linecnt = linecnt3;
	line    = lines[routine][linecnt]
	#
	# Stop when tag line is found
	#
	while (line !~ /^([A-Z|[0-9]|[a-z]|%)/) {
		while (1) {
			fnd = index(line, "S " filenumValue);
			if (fnd == 0) {
				break
			}
			line2 = substr(line,fnd + 2 + len);
			if (line2 ~ / *= */) {
				fnd2 = index(line2,"=");
				pos  = 0;
				for (i = fnd2 + 1; i <= length(line2); i++) {
					if (substr(line2,i,1) != " ") {
						pos = i;
						break
					}
				}
				if (pos) {
					if (substr(line2,pos) ~ /\$(SELECT|Select|S|s)/) {
						value = substr(line2,pos);
						processSelectFilenum(routine, linecnt, value)
					}
					else { 
						pos2 = 0; 
						for (i = pos; i <= length(line2); i++) { 
							if (substr(line2,i,1) !~ /[0-9]/) { 
								pos2 = i; 
								i = length(line2) 
							} 
						} 
						value = substr(line2, pos, pos2 - pos + 1); 
						doSaves(routine, value)
					}
				}
			}
			line = substr(line, fnd + len);
			if (line == "") {
				break
			}
		}
		line = lines[routine][--linecnt]
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

# This searches for <tag>^DIE( and gets the parameter # holding the number/variable for the <tag>
# If the parameter is a number, it calls saveFilenum
# Otherwise, it calls getVariable to get the value for the variable
#
function printRoutinesAndFiles(routine) {
	if ((routine in linesfound) == 1) {
		for (linecnt in linesfound[routine]) { 
			line = lines[routine][linecnt];
			#
			# Ignore comment lines
			#
		 	if (substr(line,2) ~ /^(\. *)?1;/) {
				continue
			}
			while (1) {
				fnd  = index(line,"^DIE(");
				#
				# Looking for ^DIE(
				#
	
				if (fnd == 0) {
					break
				}
				fnd      = fnd + 4;
				piecenum = getPieceNum(line,fnd);
	
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
				line    = substr(line,fnd+1); 
				n       = split(line,arr,",");
				split(arr[piecenum],arr2,")"); 
				filenum = arr2[1]; 
				gsub(/"/,"",filenum); 
				if (length(filenum) > 0) { 
					if (filenum ~ /^[0-9]+$/) { 
						saveFilenum(routine,filenum,lines[routine][linecnt]) 
					} 
					else { 
						if (filenum ~ /^[0-9]+\.[0-9]+$/) { 
							saveFilenum(routine,filenum,lines[routine][linecnt]) 
						} 
						else { 
							len      = length(filenum); 
							line2    = lines[routine][linecnt]; 
							scanLines(line2,filenum,len,routine,linecnt) 
						}
					}
				}
				else {
					filenum = "<Empty string>"
					saveFilenum(routine,filenum,lines[routine][linecnt])
				}
			} 
		}
	}
}

function processDoubleQuotes(routine,filenum,line,pos) {
	if (substr(line,pos + 2) ~ / (F|f|FOR|for) /) { 
		filenum = "<LOOP>" 
		msgs[++msgcnt] = "processDoubleQuotes 1: routine = " routine ", filenum = " filenum ", line = " line
	} 
	else { 
		if (filenum ~ /^\$(P|p|PIECE|piece)\(/) { 
			msgs[++msgcnt] = "processDoubleQuotes 2: routine = " routine ", filenum = " filenum ", line = " line
		} 
		else { 
			filenum = "<Unknown>" 
			msgs[++msgcnt] = "processDoubleQuotes 3:  routine = " routine ", filenum = " filenum ", line = " line
		} 
	}
}

function processPieces(routine,filenum,line) {
	if (filenum ~ /^\$(P|p|PIECE|Piece|piece)\(("|[0-9]|[A-Z]|[a-z])/) {
		split(filenum,arr,","); 
		split(arr[1],arr2,"("); 
		values = arr2[2]; 
		delimiter = arr[2]; 
		gsub(/"/,"",delimiter); 
		start = substr(values,1,1); 
		end   = substr(values,length(values),1) 
		if ((start == "\"") && (end == "\"")) { 
			gsub(/"/,"",values) 
		} 
		n = split(values,arr,delimiter); 
		for (i = 1; i <= n; i++) { 
			filenum = arr[i]; 
			if (filenum != "") { 
				saveFilenum(routine,filenum,line) 
			} 
		}
	}
	else {
		doSaves(routine,filenum)
	}
}

function processSelectFilenum(routine,linecnt3,filenum) {
	#
	# Get values for $Select statement
	#
	pos = index(filenum,"(");
	if (pos == 0) {
		return
	}
	numParens = 1;
	pos2      = 0;
	for (i = pos+1; i < 1000000; i++) {
		char = substr(filenum,i,1)
		if (char == "(") {
			numParens++
		}
		else if (char == ")") {
			numParens--;
			if (numParens == 0) {
				pos2 = i;
				i    = 1000000
			}
		}
	}
	if (pos2 == 0) return
	filenum = substr(filenum, pos + 1, pos2 - pos - 1);
	n       = split(filenum,arr,",");
	for (i = 1; i <= n; i++) {
		phrase                  = arr[i];
		split(phrase,arr2,":");
		filenum                 = arr2[2];
		gsub(/"/,"",filenum);
		if (filenum != "") {
			saveFilenum(routine,filenum,lines[routine][linecnt3])
		}
	}
}

#
# Save filenum/routine
#
function saveFilenum(routine,filenum,line) {
	pos = index(filenum,",");
	if (pos > 0) {
		if (filenum ~ /^\$(P|p|PIECE|Piece|piece)\(/) {
			processPieces(routine,filenum,line)
		}
	}
	else {
		if (filenum ~ /"[0-9]+(\.[0-9]+)?"/) {
			gsub(/"/,"",filenum)
		}
		doSaves(routine,filenum)
	}
}

#
# Scanning lines starting with <tag>^DIE( for file number
#
function scanLines(line,filenum,len,routine,linecnt2) {
	#
	# Stop at the line with the tag
	#
	while (line ~ /^( |\t)/) {
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
			line    = substr(line,fnd + 9);
			split(line,arr,",");
			split(arr[1],arr2,")");
			filenum = arr2[1];
			flg     = 1
		}
		else { 
			#
			# Looking for line with parameter/name in it
			#
			if (filenum ~ /[0-9]+(\.[0-9]+)?/) {
				flg = 1
			}
			else { 
				fnd = index(line,filenum "("); 
				if (fnd > 0) { 
					line                 = substr(line,fnd + len + 1); 
					split(line,arr,","); 
					filenum              = arr[1]; 
					if (filenum != "") { 
						flg          = 1 
					} 
				}
			}
		}
		if (flg == 1) {
			#
			# If parameter name is variable name, search for corresponding value
			#
			if (filenum ~ /([A-Z]|[a-z])+/) {
				filenumArray = filenum
				getFilenumVariable(routine,linecnt2,filenumArray)
			}
			else { 
				#
				# Otherwise, store value
				#
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
	separator = "\t";
	printRoutinesAndFiles(routine);
	n1 = asorti(rtnfile,rtnfile2);
	n2 = asorti(filenums,filenums2,"@ind_num_asc");
	if (!n1) {
		print "No data to report"
		exit
	}
	header = "Routines";
	for (i = 1; i <= n2; i++) {
		filenum            = filenums2[i];
		header             = header separator filenum;
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
				data = data separator "X"
			}
			#
			# Routine does not access the file number
			#
			else {
				data = data separator
			}
		}
		print data
	}

	print "\n# of routines: " n1;
	print "# of files:    " n2;
	if (msgcnt > 0) {
		print "\nMessages:"; 
		for (i in msgs) print msgs[i]
	}
}
