#
# Associate files with routines
#

# 20210816 - Work on this:  i
# a) Allow for multiple filenums per line
# b) S DIE="^IB(",DA=IBN,DR=".05////"_$S(IBERR="":3,1:9)
#    D ^DIE K DIE,DR,DA

#
# Find file number value for parameter variable
#
BEGIN {
	tags["FILE"]         = 2;
	tags["UPDATE"]       = 2;
	tags["HELP"]         = 5;
	tags["WP"]           = 1;
	tags["CHK"]          = 1;
	linesfound[" "][" "] = ""
}

function getFilenumValue(routine,linecnt2,var, linecnt3, fnd, i) {
	linecnt3 = linecnt2 - 1; 
	len      = length(var) + 2;
	line     = lines[routine][linecnt3]; 
	#
	# Stop when tag line is found
	#
	while (line ~ /^( |\t)/) { 
		fnd = index(line,"S " var); # Find Set <var>
		if (fnd > 0) {
			#
			# Make sure it's a set 
			#
			if (substr(line,fnd-1) ~ /[ |\t]/) {
				#
				# Make sure the rest of the line is:
				# . 0 or more spaces
				# . =
				# . 0 or more spaces
				#
				if (substr(line,fnd+len) ~ / *= */) {
					line = substr(line,fnd+len); 
					fnd  = index(line,"="); 
					line = substr(line,fnd+1);
					pos  = 0; 
					#
					# Looking for 1st non-space charaacter after =
					#
					for (i = 1; i<= length(line); i++) { 
						if (substr(line,i,1) != " ") { 
							pos = i;
							break
						} 
					}
					if (pos > 0) {
						split(substr(line,pos),arr," "); 
						filenum = arr[1]; 
						#
						# If parameter value is not a $Select statement
						#
						if (filenum !~ /\$S/) {
							saveFilenum(routine,filenum)
						}
						else {
							#
							# Get values for $Select statement
							#
							filenum = substr(filenum,4,length(filenum)-4);
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
		if (substr(line,fnd - length(tag) - 4, length(tag)) == tag) {
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
			if (substr(line,2,1) == ";") {
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
				line = substr(line,fnd); 
				n    = split(line,arr,",");
				split(arr[piecenum],arr2,")"); 
				var  = arr2[1]; 
				gsub(/"/,"",var); 
				len      = length(var);
				linecnt2 = linecnt - 1;
				line2    = lines[routine][linecnt2];
				scanLines(line2,len,routine,linecnt2)
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
	rtnfile[routine][filenum] = ""; 
	filenums[filenum]         = "" 
}

#
# Scanning lines above <tag>^DIE( for file number
#
function scanLines(line,len,routine,linecnt2) {
	#
	# Stop at the line with the tag
	#
	while (line ~ /^( |\t)/) {
		flg = 0;
		#
		# Ignore comment lines
		#
		if (substr(line,2,1) == ";") {
			line = lines[routine][--linecnt2]
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
			fnd = index(line,var "("); 
			if (fnd > 0) { 
				line                 = substr(line,fnd + len + 1); 
				split(line,arr,","); 
				filenum              = arr[1]; 
				if (filenum != "") { flg                  = 1 }
			}
		}
		if (flg == 1) {
			#
			# If parameter name is alphabetic, search for corresponding value
			#
			if (filenum ~ /[A-Z]+/) {
				getFilenumValue(routine,linecnt2,filenum)
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
	printRoutinesAndFiles(routine);
	n1 = asorti(rtnfile,rtnfile2);
	n2 = asorti(filenums,filenums2,"@ind_num_asc");
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
