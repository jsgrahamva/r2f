#
# Associate files with routines
#
# Completed:
# 20210901 - Allowed S TOFILE=$P($P(RES("POINTER"),","),"(",2)  ; example: RES("POINTER")="IBE(365.011,"
#            Enabled D FILE^DIE(,"ARR","ARRMSG") and ARR(+FILE,TMP,+FIELD)=VALUE and S FILE=200 --> 200
# 20210831 - Allowed multiple filenums on same line
# 20210827 - Fixed wrong filenums for IBCNEHL4.m
# 20210827 - Fixed
#    S DGFDA(1,29.11,"+1,",6)=DGSITE ;
#    D UPDATE^DIE("","DGFDA(1)","MSTIEN","DGERR")
#
# To Do:
# a) Allow for multiple filenums per line:
#    1) DIE line
# b) S DIE="^IB(",DA=IBN,DR=".05////"_$S(IBERR="":3,1:9)
#    D ^DIE K DIE,DR,DA
# d) Allow for:
#    TESTVAL(DGFIL,DGFLD,DGVAL)      ; Determine if a field value is valid.
#     .. D CHK^DIE(DGFIL,DGFLD,,DGVALEX,.DGRSLT) I DGRSLT="^" S VALID=0
# f) Find file number value for parameter variable
# g) Report on error conditions:
#    1) When there is a DIE without a corresponding file number
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
	if (filenum ~ / $/) {
		filenum = substr(filenum,1,length(filenum-1))
	}
	if (rtnfile[routine][filenum] == "") {
		rtnfile[routine][filenum] = 1; 
		filenums[filenum]         = 1
	}
}

# Get extrinsic function
#
function getExtFunc(line,pos, i, line2, numParens, pos2, pos3) {
        pos2 = 0
        for (i = pos + 2; i <= length(line); i++) {
                if (substr(line,i,1) !~ /([a-z]|[A-Z]|[0-9]|%)/) {
                        pos2 = i - 1;
                        i = length(line)
                }
        }
        if (pos2) {
                if (substr(line,pos2+1,1) == "(") {
                        numParens = 1;
                        pos3      = 0;
                        for (i = pos2 + 2; i <= length(line); i++) {
                                char = substr(line, i, 1);
                                if (char == "(") {
                                        numParens++
                                }
                                else if (char == ")") {
                                        numParens--;
                                        if (!numParens) {
                                                pos3 = i;
                                                i    = length(line)
                                        }
                                }
                        }
                        line2 = substr(line, pos, pos3 - pos + 1)
                }
                else {
                        line2 = substr(line, pos, pos2 - pos + 1)
                }
        }
        else {
                line2 = "Extrinsic function = ??"
        }

	return line2
}

# Found variable for file number in scanLines.  Now find the variable's value (file number)
#
function getFilenumValue(routine,linecnt3,filenumVariable, alldone, arr, fnd, fnd2, i, len, line, line2, linecnt, n, loneComma, offset, numParens, plus, pos, pos2, value, var2) {
	# print "\ngetFilenumValue: filenumVariable = " filenumVariable
	if (filenumVariable ~ /^\+/) {
		filenumVariable = substr(filenumVariable,2);
		plus            = 1
	}
	len     = length(filenumVariable);
	linecnt = linecnt3;
	line    = lines[routine][linecnt]
	#
	# Stop when tag line is found
	#
	while (line !~ /^([A-Z|[0-9]|[a-z]|%)/) {
		while (1) {
			alldone   = 0;
			loneComma = 0;
			#
			# *** Make sure no letters or variables after filenumVariable ***
			#
			if (!index(line,filenumVariable)) {
				break
			}
			n   = split("S|Set|SET|s|,",arr,"|");
			fnd = 0;
			for (i = 1; i <= n; i++) {
				fnd = index(line, arr[i] " " filenumVariable);
				if (fnd) {
					break
				}
				else {
					fnd = index(line, arr[i] "  " filenumVariable);
					if (fnd) {
						break
					}
				}
			}
			if (fnd == 0) {
				fnd = index(line,"," filenumVariable)
				if (fnd) {
					loneComma = 1
				}
				else {
					break
				}
			}
			if (!loneComma) { 
				line2 = substr(line,fnd + 2 + len)
			}
			else {
				line2 = substr(line,fnd + 1 + len)
			}
			# print "\nAA: line = " line
			# print "AA2: line2 = " line2
			if (line2 ~ / *= */) {
				fnd2  = index(line2,"=");
				pos   = 0;
				for (i = fnd2 + 1; i <= length(line2); i++) {
					if (substr(line2,i,1) != " ") {
						pos = i;
						break
					}
				}
				if (pos) {
					# print "BB: pos = " pos
					if (substr(line2,pos) ~ /\$(SELECT|Select|select|S|s)\(/) {
						value = substr(line2,pos);
						# print "CC: value = " value
						processSelectFilenum(routine, linecnt, value);
						alldone  = 1
					}
					else {
						if (substr(line2,pos,2) == "$$") {
							value = getExtFunc(line2, pos);
							# print "DD: value = " value
							doSaves(routine, value);
							alldone  = 1
						}
						else {
							# print "EE: fnv = " filenumVariable
							if (line2 ~ /[0-9]+$/) {
								if (line2 ~ /^=/) {
									value = substr(line2,2)
								}
								else { 
									value = line2
								}
								# print "EE 2: value = " value
								doSaves(routine,value)
								alldone = 1
							}
							else {
								# print "EE 2.5: line2 = " line2
								if (line2 ~ /^=(\+)?\$([A-Z]|[a-z])+\(/) { # function
									# print "EE 3: line2 = " line2
									numParens = 0;
									n         = index(line2, "(");
									for (i = n; i <= length(line2); i++) {
										if (substr(line2, i, 1) == "(") {
											if ((substr(line2, i-1, 1) !~ /"/) || (substr(line2, i+1, 1) !~ /"/)) {
												numParens++
											}
										}
										else { 
											if (substr(line2, i, 1) == ")") { 
												if ((substr(line2, i-1, 1) !~ /"/) || (substr(line2, i+1, 1) !~ /"/)) { 
													if (--numParens == 0) {
														value   = substr(line2, 2, i - 1);
														# print "FF: value = " value
														doSaves(routine, value);
														alldone = 1;
														break
													}
												}
											}
										}
									}
								}
								else { 
									pos2 = 0; 
									for (i = pos; i <= length(line2); i++) { 
										if (substr(line2,i,1) !~ /([0-9]|\.)/) { 
											pos2 = i - 1; 
											break
										} 
									} 
									if (pos2) {
										value    = substr(line2, pos, pos2 - pos + 1);
										if (value ~ / $/) {
											value = substr(value, 1, length(value) - 1)
										}
										# print "GG: plus = " plus ", filenumVariable = " filenumVariable ", value = '" value "'"
										if ((plus) && (value !~ /[0-9]+(\.[0-9]*)?$/)) {
											value = "+" value
										}
										# print "GG2: value = '" value "'"
										doSaves(routine, value);
										alldone
									}
									alldone  = 1
								}
							}
						}
					}
				}
			}
			if (!loneComma) {
				line = substr(line, fnd + len)
			}
			else {
				line = substr(line, fnd + len + 1)
			}
			if (line == "") {
				break
			}
		}
		line = lines[routine][--linecnt]
	}
	if (!alldone) {
		fnd = index(line,"(");
		if (fnd) {
			line = substr(line, fnd + 1); 
			n = split(line, arr, ",");
			for (i = 1; i <= n; i++) {
				if (arr[i] == filenumVariable) {
					# print "HH: value = " filenumVariable
					doSaves(routine, filenumVariable);
					break
				}
			}
		}
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
# Have name for array, now need example of array in use and determine file number or variable which contains it (1st array subscript)
#
function scanLines(line,arrayName,len,routine,linecnt2, arr, arr2, filenum, flg, fnd, i) {
	#
	# Stop at the line with the tag
	#
	while (line ~ /^( |\t)/) {
		if (line ~ /([A-Z]|[a-z]|[0-9])+\^DIE/) {
			line = lines[routine][--linecnt2]
			continue
		}
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

		while (1) {
			flg = 0;
			fnd = index(line,"FDA^DILF(");
			if (fnd > 0) {
				line     = substr(line,fnd + 9);
				split(line,arr,",");
				split(arr[1],arr2,")");
				filenum  = arr2[1];
				fnd      = fnd + 9;
				flg      = 1
			}
			else { 
				#
				# Looking for line with parameter/name in it
				#
				#
				# arrayName is integer or decimal number
				#
				if (arrayName ~ /^[0-9]+(\.[0-9]+)?/) {
					for (i = 2; i <= length(arrayName); i++) {
						if (substr(arrayName,i,1) !~ /[0-9]|\./) {
							filenum = substr(arrayName,1,i-1);
							fnd     = i;
							break
						}
					}
					flg      = 1
				}
				else { 
					#
					# arrayName ends in "(<digit>", like DGFDA(1
					# 
					if (arrayName ~ /\([0-9]+$/) {
						fnd = index(line, arrayName);
						if (fnd) {
							line    = substr(line, fnd + 1);
							split(line,arr,"(");
							split(arr[2],arr2,",");
							filenum = arr2[2];
							fnd     = fnd + length(arrayName) + 2
							#
							# File number is extracted from, i.e. DGFDA(1,29.11,"+1,",3)=DGSTA
							#
							if (filenum ~ /[0-9]+(\.[0-9])?/) {
								doSaves(routine,filenum)
							}
						}
					}
					else { 
						#
						# arrayName is array / Looking for its first subscript (i.e. file number)
						#
						fnd = index(line,arrayName "("); 
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
			}
			if (flg == 1) {
				#
				# If parameter name is variable name, search for corresponding value
				#
				if (filenum ~ /([A-Z]|[a-z])+/) {
					filenumArray = filenum
					getFilenumValue(routine,linecnt2,filenumArray)
				}
				else { 
					#
					# Otherwise, store value
					#
					saveFilenum(routine,filenum)
				}
			}
			if (fnd) {
				line = substr(line, fnd)
			}
			else {
				break
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
	separator = "|";
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
	print header separator;
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
