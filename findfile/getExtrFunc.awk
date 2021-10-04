# Variables passed in:  line2, pos
#
function getExtFunc(line, pos) {
	print "line = " line
	print "pos  = " pos
	pos2 = 0
	for (i = pos + 2; i <= length(line); i++) {
		if (substr(line,i,1) !~ /([a-z]|[A-Z]|[0-9]%)/) {
			pos2 = i - 1;
			i = length(line)
		}
	}
	if (pos2) {
		line2 = substr(line, pos, pos2 - pos + 1);
		line2 = "function = $$" line2 "()"
	}
	else {
		line2 = "function = ??"
	}

	return line2
}

{
	line = $0;
	pos  = index($0, "$");
	print getExtFunc(line, pos)
}
