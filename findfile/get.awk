function afunc(line, pos) {
	print "line = " line
	print "pos  = " pos
	print "substr = " substr(line,pos)
	pos2 = 0
	for (i = pos + 2; i <= length(line); i++) {
		if (substr(line,i,1) !~ /([a-z]|[A-Z]|[0-9]|%)/) {
			print "i = " i
			print "not match " substr(line,i,1)
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
		line2 = "function = ??"
	}

	return line2
}

{
	line  = $0;
	pos   = 8;
	line2 = afunc(line,pos);
	print line2
}
