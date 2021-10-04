function rest() {
#				break
#			}
#			n   = split("S|Set|SET|s",arr,"|");
#			fnd = 0;
#			for (i = 1; i <= n; i++) {
#				fnd = index(line, arr[i] " " filenumVariable);
#				if (fnd) {
#					break
#				}
#				else {
#					fnd = index(line, arr[i] "  " filenumVariable);
#					if (fnd) {
#						break
#					}
#				}
#			}
#			if (fnd == 0) {
#				fnd = index(line,"," filenumVariable)
#				if (fnd) {
#					loneComma = 1
#				}
#				else {
#					break
#				}
#			}
#			if (!loneComma) { 
#				line2 = substr(line,fnd + 2 + len)
#			}
#			else {
#				line2 = substr(line,fnd + 1 + len)
#			}
#			print "\nAA: line = " line
#			print "AA2: line2 = " line2
#			if (line2 ~ /^ *= */) {
#				fnd2  = index(line2,"=");
#				pos   = 0;
#				for (i = fnd2 + 1; i <= length(line2); i++) {
#					if (substr(line2,i,1) != " ") {
#						pos = i;
#						break
#					}
#				}
#				if (pos) {
#					print "BB: pos = " pos
#					if (substr(line2,pos) ~ /\$(SELECT|Select|select|S|s)\(/) {
#						value = substr(line2,pos);
#						print "CC: value = " value
#						processSelectFilenum(routine, linecnt, value);
#						alldone  = 1
#					}
#					else {
#						if (substr(line2,pos,2) == "$$") {
#							value = getExtFunc(line2, pos);
#							print "DD: value = " value
#							doSaves(routine, value);
#							alldone  = 1
#						}
#						else {
#							print "EE: fnv = " filenumVariable
#							if (line2 ~ /[0-9]+$/) {
#								if (line2 ~ /^=/) {
#									value = substr(line2,2)
#								}
#								else { 
#									value = line2
#								}
#								print "EE 2: value = " value
#								doSaves(routine,value)
#								alldone = 1
#							}
#							else {
#								print "EE 2.5: line2 = " line2
#								if (line2 ~ /^=(\+)?\$([A-Z]|[a-z])+\(/) { # function
#									print "EE 3: line2 = " line2
#									numParens = 0;
#									n         = index(line2, "(");
#									for (i = n; i <= length(line2); i++) {
#										if (substr(line2, i, 1) == "(") {
#											if ((substr(line2, i-1, 1) !~ /"/) || (substr(line2, i+1, 1) !~ /"/)) {
#												numParens++
#											}
#										}
#										else { 
#											if (substr(line2, i, 1) == ")") { 
#												if ((substr(line2, i-1, 1) !~ /"/) || (substr(line2, i+1, 1) !~ /"/)) { 
#													if (--numParens == 0) {
#														value   = substr(line2, 2, i - 1);
#														print "FF: value = " value
#														doSaves(routine, value);
#														alldone = 1;
#														break
#													}
#												}
#											}
#										}
#									}
#								}
#								else { 
#									pos2 = 0; 
#									for (i = pos; i <= length(line2); i++) { 
#										if (substr(line2,i,1) !~ /([0-9]|\.)/) { 
#											pos2 = i - 1; 
#											break
#										} 
#									} 
#									if (pos2) {
#										value    = substr(line2, pos, pos2 - pos + 1);
#										if (value ~ / $/) {
#											value = substr(value, 1, length(value) - 1)
#										}
#										print "GG: plus = " plus ", filenumVariable = " filenumVariable ", value = '" value "'"
#										if ((plus) && (value !~ /[0-9]+(\.[0-9]*)?$/)) {
#											value = "+" value
#										}
#										print "GG2: value = '" value "'"
#										doSaves(routine, value);
#										alldone
#									}
#									alldone  = 1
#								}
#							}
#						}
#					}
#				}
#			}
#			line = !loneComma ? substr(line, fnd + len) : substr(line, fnd + len + 1)
#			if (line == "") {
#				break
#			}
#		}
#		line = lines[routine][--linecnt]
#	}
#	if (!alldone) {
#		fnd = index(line,"(");
#		if (fnd) {
#			line = substr(line, fnd + 1); 
#			n = split(line, arr, ",");
#			for (i = 1; i <= n; i++) {
#				if (arr[i] == filenumVariable) {
#					print "HH: value = " filenumVariable
#					doSaves(routine, filenumVariable);
#					break
#				}
#			}
#		}
#	}
}


