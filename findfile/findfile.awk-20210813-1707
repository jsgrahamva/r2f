#
# Associate files with routines
#

function printRoutinesAndFiles() {
	for (routine in linesfound) {
		for (linecnt in linesfound[routine]) { 
			line = lines[routine][linecnt];
			if (substr(line,2,1) == ";") {
				continue
			}
			# print "-----------------------"
			# print ""
			# print "*** " line " ***"
			# print ""
			# print "length = " length(line)
			fnd  = index(line,"^DIE(");
			if (fnd == 0) {
				continue
			}
			fnd = fnd + 4;
			# print "fnd = " fnd
			# print substr(line,fnd,1)
			# print "line 1 = " line
			# print "line 2 = " substr(line,fnd-8,4)
			if (substr(line,fnd-8,4) == "FILE") {
				piecenum = 2
			}
			else {
				if (substr(line,fnd-10,6) == "UPDATE") {
					piecenum = 2
				}
				else {
					if (substr(line,fnd-8,4) == "HELP") {
						piecenum = 5
					}
					else {
						piecenum = 0
					}
				}
			}
			# print "piecenum = " piecenum
			if (piecenum == 0) {
				continue
			}
			line = substr(line,fnd); 
			# print "fnd  = " fnd
			# print "line = " line
			n    = split(line,arr,",");
			split(arr[piecenum],arr2,")"); 
			var  = arr2[1]; 
			# print "var = " var
			gsub(/"/,"",var); 
			len      = length(var);
			linecnt2 = linecnt - 1;
			line     = lines[routine][linecnt2]; 
			while (line ~ /^( |\t)/) {
				flg = 0;
				# print line;
				if (substr(line,2,1) != ";") { 
					# print "A"
					fnd = index(line,"FDA^DILF(");
					if (fnd > 0) {
						# print "B"
						line    = substr(line,fnd + 9);
						# print "line = " line
						split(line,arr,",");
						split(arr[1],arr2,")");
						filenum = arr2[1];
						flg     = 1
					}
					else { 
						# print "C"
						fnd = index(line,var "("); 
						if (fnd > 0) { 
							# print "D"
							line                 = substr(line,fnd + len + 1); 
							# print "D1: line = " line
							split(line,arr,","); 
							# print "D2: arr[1] = " arr[1]
							filenum              = arr[1]; 
							# print "D3: filenum = " filenum
							flg                  = 1;
							if (filenum == "") { 
								# print "E"
								print filename ": " FNR; 
								print $0; 
								exit 
							}
						}
					}
					# print "F"
					if (flg == 1) {
						# print "G: " routine " | " filenum
						rtnfile[routine][filenum] = ""; 
						filenums[filenum]         = "" 
					}
				}
				# print "H"
				line = lines[--linecnt2] 
			} 
		} 
	}

}

BEGIN {
	filename = ""
}

(FNR == 1) {
	if (filename != "") {
		printRoutinesAndFiles()
	}
	filename = FILENAME;
	# delete lines
}

{ 
	lines[FILENAME][FNR] = $0; 
	if (index($0,"^DIE(")) { linesfound[FILENAME][FNR] = 1 } 
} 

END {
	printRoutinesAndFiles();
	n1 = asorti(rtnfile,rtnfile2);
	n2 = asorti(filenums,filenums2,"@ind_num_asc");
	header = "Routines";
	for (i = 1; i <= n2; i++) {
		filenum            = filenums2[i];
		header             = header "," filenum;
		filenums3[filenum] = i
	}
	print header;
	for (i = 1; i <= n1; i++) {
		rtn  = rtnfile2[i];
		data = rtn;
		for (j = 1; j <= n2; j++) {
			filenum    = filenums2[j];
			filenumpos = filenums3[filenum];
			if (filenum in rtnfile[rtn]) { 
				data = data ",X"
			}
			else {
				data = data ","
			}
		}
		print data
	}
}
