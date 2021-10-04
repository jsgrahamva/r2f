C0CRXNRD	; VEN/SMH - RxNorm Utilities: Routine to Read RxNorm files;2013-11-14  1:23 PM
	;;2.3;RXNORM FOR VISTA;;Jul 22, 2014;Build 16
	; (C) Sam Habiel 2013
	; See license for terms of use.
	;
	W "No entry from top" Q
IMPORT(PATH,RESTRICTED)	; PUBLIC ENTRY POINT. Rest are private
	I PATH="" QUIT
	S RESTRICTED=$G(RESTRICTED,0)
	S U="^"
	N STARTTIME S STARTTIME=$P($H,",")*24*60*60+$P($H,",",2)
	N SABS
	D SAB(PATH,.SABS) ; Load restriction values into SAB.     ; 176.006
	D CONSO(PATH,.SABS,RESTRICTED),SAT(PATH,.SABS,RESTRICTED) ; 176.001,176.002
	D STY(PATH),REL(PATH),DOC(PATH)                           ; 176.003-5
	N ENDTIME S ENDTIME=$P($H,",")*24*60*60+$P($H,",",2)
	W !,(ENDTIME-STARTTIME)/60_" minutes elapsed"
	QUIT
	;
	; Everything is private from down on...
DELFILED(FN)	; Delete file data; PEP procedure; only for RxNorm files
	; FN is Filenumber passed by Value
	QUIT:$E(FN,1,3)'=176  ; Quit if not RxNorm files
	N ROOT S ROOT=$$ROOT^DILFD(FN,"",1) ; global root
	N ZERO S ZERO=@ROOT@(0) ; Save zero node
	S $P(ZERO,U,3,9999)="" ; Remove entry # and last edited
	K @ROOT ; Kill the file -- so sad!
	S @ROOT@(0)=ZERO ; It riseth again!
	QUIT
GETLINES(PATH,FILENAME)	; Get number of lines in a file
	N POP
	D OPEN^%ZISH("FILE",PATH,FILENAME,"R")
	Q:POP
	U IO
	N I,LINE
	F I=1:1 R LINE:0 Q:$$STATUS^%ZISH
	D CLOSE^%ZISH("FILE")
	Q I-1
CONSO(PATH,SABS,RESTRICTED)	; Open and read concepts file: RXNCONSO.RRF
	; PATH ByVal, path of RxNorm files
	; SABS ByRef, arrays of SABS(SAB)=restriction level
	; RESTRICTED ByVal, include restricted sources. 1 for yes, 0 for no
	I PATH="" QUIT
	N FILENAME S FILENAME="RXNCONSO.RRF"
	D DELFILED(176.001) ; delete data
	N LINES S LINES=$$GETLINES(PATH,FILENAME)
	N POP
	D OPEN^%ZISH("FILE",PATH,FILENAME,"R")
	IF POP D EN^DDIOL("Error reading file..., Please check...") G EX
	N C0CCOUNT
	F C0CCOUNT=1:1 D  Q:$$STATUS^%ZISH
	. U IO
	. N LINE R LINE:0
	. IF $$STATUS^%ZISH QUIT
	. I '(C0CCOUNT#1000) U $P W C0CCOUNT," of ",LINES," read ",! U IO ; update every 1000
	. ;
	. ; Deal with restriction level
	. N SAB S SAB=$P(LINE,"|",12)
	. I 'RESTRICTED,SABS(SAB) QUIT  ; If not include restricted, and SABS(SAB) is not zero, quit
	. ;
	. ; Save data
	. S ^C0CRXN(176.001,C0CCOUNT,0)=$TR(LINE,"|^","^|")
EX	D CLOSE^%ZISH("FILE")
	N DIK S DIK="^C0CRXN(176.001," D IXALL^DIK
	QUIT
	;
	;
SAT(PATH,SABS,RESTRICTED)	; Open and read Concept and Atom attributes: RXNSAT.RRF
	; PATH ByVal, path of RxNorm files
	; SABS ByRef, arrays of SABS(SAB)=restriction level
	; RESTRICTED ByVal, include restricted sources. 1 for yes, 0 for no
	I PATH="" QUIT
	N FILENAME S FILENAME="RXNSAT.RRF"
	D DELFILED(176.002) ; delete data
	N LINES S LINES=$$GETLINES(PATH,FILENAME)
	N POP
	D OPEN^%ZISH("FILE",PATH,FILENAME,"R")
	IF POP W "Error reading file..., Please check...",! G EX2
	N C0CCOUNT F C0CCOUNT=1:1 Q:$$STATUS^%ZISH  D
	. U IO
	. N LINE R LINE:0
	. IF $$STATUS^%ZISH QUIT
	. I '(C0CCOUNT#1000) U $P W C0CCOUNT," of ",LINES," read ",! U IO ; update every 1000
	. ;
	. ; We switch around the fields .01 and .09 because the .01 isn't always present; where as .09 is required
	. N RXCUI1,ATN9
	. S RXCUI1=$P(LINE,"|",1)
	. S ATN9=$P(LINE,"|",9)
	. S $P(LINE,"|",1)=ATN9
	. S $P(LINE,"|",9)=RXCUI1
	. ;
	. ; Deal with restricted sources
	. N SAB S SAB=$P(LINE,"|",10)
	. I 'RESTRICTED,SABS(SAB) QUIT  ; If not include restricted, and SABS(SAB) is not zero, quit
	. ;
	. ; Save off
	. S ^C0CRXN(176.002,C0CCOUNT,0)=$TR(LINE,"|^","^|")
EX2	D CLOSE^%ZISH("FILE")
	N DIK S DIK="^C0CRXN(176.002," D IXALL^DIK
	QUIT
	;
	;
SAB(PATH,SABS)	; Open the read RxNorm Sources file: RXNSAB.RRF
	I PATH="" QUIT
	N FILENAME S FILENAME="RXNSAB.RRF"
	D DELFILED(176.003) ; delete data
	N POP
	D OPEN^%ZISH("FILE",PATH,FILENAME,"R")
	IF POP W "Error reading file..., Please check...",! G EX3
	N I F I=1:1 Q:$$STATUS^%ZISH  D
	. U IO
	. N LINE R LINE:0
	. IF $$STATUS^%ZISH QUIT
	. U $P W I,! U IO  ; Write I to the screen, then go back to reading the file
	. ; Switch pieces 1 and 4 because 4 is always defined. Goes into .01 field.
	. N VCUI S VCUI=$P(LINE,"|",1)
	. N RSAB S RSAB=$P(LINE,"|",4)
	. S $P(LINE,"|",1)=RSAB
	. S $P(LINE,"|",4)=VCUI
	. S ^C0CRXN(176.003,I,0)=$TR(LINE,"^|","|^")
EX3	D CLOSE^%ZISH("FILE")
	N DIK S DIK="^C0CRXN(176.003," D IXALL^DIK
	N C0CI F C0CI=0:0 S C0CI=$O(^C0CRXN(176.003,C0CI)) Q:'C0CI  D
	. S SABS($$GET1^DIQ(176.003,C0CI,.01))=$$GET1^DIQ(176.003,C0CI,"SRL")
	QUIT
STY(PATH)	; Open and read RxNorm Semantic types file: RXNSTY.RRF
	I PATH="" QUIT
	N FILENAME S FILENAME="RXNSTY.RRF"
	D DELFILED(176.004) ; delete data
	N LINES S LINES=$$GETLINES(PATH,FILENAME) ; Get # of lines
	N POP
	D OPEN^%ZISH("FILE",PATH,FILENAME,"R")
	IF POP W "Error reading file..., Please check...",! G EX4
	N I F I=1:1 Q:$$STATUS^%ZISH  D
	. U IO
	. N LINE R LINE:0
	. IF $$STATUS^%ZISH QUIT
	. I '(I#1000) U $P W I," of ",LINES," read ",! U IO ; update every 1000
	. S ^C0CRXN(176.004,I,0)=$TR(LINE,"^|","|^")
EX4	D CLOSE^%ZISH("FILE")
	N DIK S DIK="^C0CRXN(176.004," D IXALL^DIK
	QUIT
	;
REL(PATH)	; Open and read RxNorm Relationships file: RXNREL.RRF
	I PATH="" QUIT
	N FILENAME S FILENAME="RXNREL.RRF"
	D DELFILED(176.005) ; delete data
	N LINES S LINES=$$GETLINES(PATH,FILENAME) ; Get # of lines
	N POP
	D OPEN^%ZISH("FILE",PATH,FILENAME,"R")
	IF POP W "Error reading file..., Please check...",! G EX5
	N I F I=1:1 Q:$$STATUS^%ZISH  D
	. U IO
	. N LINE R LINE:0
	. IF $$STATUS^%ZISH QUIT
	. I '(I#1000) U $P W I," of ",LINES," read ",! U IO ; update every 1000
	. ; swap RXCUI1 location with SAB b/c SAB is required so can be .01 field
	. N RXCUI1 S RXCUI1=$P(LINE,"|",1)
	. N SAB S SAB=$P(LINE,"|",11)
	. S $P(LINE,"|",1)=SAB
	. S $P(LINE,"|",11)=RXCUI1
	. S ^C0CRXN(176.005,I,0)=$TR(LINE,"^|","|^")
EX5	D CLOSE^%ZISH("FILE")
	N DIK S DIK="^C0CRXN(176.005," D IXALL^DIK
	QUIT
DOC(PATH)	; Open the read RxNorm Abbreviation Documentation file: RXNDOC.RRF
	I PATH="" QUIT
	N FILENAME S FILENAME="RXNDOC.RRF"
	D DELFILED(176.006) ; delete data
	N LINES S LINES=$$GETLINES(PATH,FILENAME) ; Get # of lines
	N POP
	D OPEN^%ZISH("FILE",PATH,FILENAME,"R")
	IF POP W "Error reading file..., Please check...",! G EX6
	N I F I=1:1 Q:$$STATUS^%ZISH  D
	. U IO
	. N LINE R LINE:0
	. IF $$STATUS^%ZISH QUIT
	. I '(I#1000) U $P W I," of ",LINES," read ",! U IO ; update every 1000
	. S ^C0CRXN(176.006,I,0)=$TR(LINE,"^|","|^")
EX6	D CLOSE^%ZISH("FILE")
	N DIK S DIK="^C0CRXN(176.006," D IXALL^DIK
	QUIT
