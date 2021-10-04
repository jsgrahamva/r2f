{ 
	old = $1; 
	new = "20210" substr(old,5); 
	print old;
	print new "\n";
	system("git branch -m " old " " new);
}
