FILE(FIL2,IENS,FIELD,VALUE)     ;
        N ROR8FDA,ROR8MSG,TMP
	S FILE=200 ; This is a test
        S TMP=$S($E(IENS,$L(IENS))=",":IENS,1:IENS_",")
        S ROR8FDA(+FILE,TMP,+FIELD)=VALUE
        D FILE^DIE(,"ROR8FDA","ROR8MSG")
        Q
