test08	;
FILE(FIL2,IENS,FIELD,VALUE)     ;
	N ROR8FDA,ROR8MSG,TMP
	s FILE=123.05 
	S TMP=$S($E(IENS,$L(IENS))=",":IENS,1:IENS_",")
	S ROR8FDA(+FILE,TMP,+FIELD)=VALUE
	D FILE^DIE(,"ROR8FDA","ROR8MSG")
	Q