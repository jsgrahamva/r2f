routine=$1
date > datetime.txt 
awk -v routine=$routine -f ff.awk datetime.txt
