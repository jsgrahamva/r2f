C0CMXP	  ; GPL - MXML based XPath utilities;12/04/09  17:05
	;;1.2;CCD/CCR GENERATION UTILITIES;;Oct 30, 2012;Build 51
	;Copyright 2009 George Lilly.  
	;
	; This program is free software: you can redistribute it and/or modify
	; it under the terms of the GNU Affero General Public License as
	; published by the Free Software Foundation, either version 3 of the
	; License, or (at your option) any later version.
	;
	; This program is distributed in the hope that it will be useful,
	; but WITHOUT ANY WARRANTY; without even the implied warranty of
	; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	; GNU Affero General Public License for more details.
	;
	; You should have received a copy of the GNU Affero General Public License
	; along with this program.  If not, see <http://www.gnu.org/licenses/>.
	;
	Q
	;
INITXPF(ARY)	;INITIAL XML/XPATH FILE ARRAY
	; DON'T USE THIS ONE ... USE INITFARY^C0CSOAP("FARY") INSTEAD
	D INITFARY^C0CSOAP(ARY) ;
	Q
	S @ARY@("XML FILE NUMBER")=178.101
	S @ARY@("XML SOURCE FIELD")=2.1
	S @ARY@("XML TEMPLATE FIELD")=3
	S @ARY@("XPATH BINDING SUBFILE")=178.1014
	S @ARY@("REDUX FIELD")=2.5
	Q
	;
SETXPF(ARY)	; SET FILE AND FIELD VARIABLES FROM XPF ARRAY
	;
	S C0CXPF=@ARY@("XML FILE NUMBER")
	S C0CXFLD=@ARY@("XML")
	S C0CXTFLD=@ARY@("TEMPLATE XML")
	S C0CXPBF=@ARY@("BINDING SUBFILE NUMBER")
	S C0CRDUXF=@ARY@("XPATH REDUCTION STRING")
	Q
	;
ADDXP(INARY,TID,FARY)	;ADD XPATH .01 FIELD TO BINDING SUBFILE OF TEMPLATE TID
	I '$D(FARY) D  ;
	. S FARY="FARY" ; FILE ARRAY
	. D INITXPF("FARY") ;IF FILE ARRAY NOT PASSED, INITIALIZE
	D SETXPF(FARY) ;SET FILE VARIABLES
	N C0CA,C0CB
	S C0CA="" S C0CB=0
	F  S C0CA=$O(@INARY@(C0CA)) Q:C0CA=""  D  ; FOR EACH XPATH
	. S C0CB=C0CB+1 ; COUNT OF XPATHS
	. S C0CFDA(C0CXPBF,"?+"_C0CB_","_TID_",",.01)=C0CA
	. D UPDIE ; CREATE THE BINDING SUBFILE FOR THIS XPATH
	Q
	;
FIXICD9	; FIX THE ICD9RESULT XML 
	D GETXML("GPL","ICD9RESULT") ; GET SOME BAD XML OUT OF THE FILE
	S ZI=""
	S G=""
	F  S ZI=$O(GPL(ZI)) Q:ZI=""  D  ; FOR EACH LINE
	. S G=G_GPL(ZI) ; MAKE ONE BIG STRING OF XML
	D NORMAL^C0CSOAP("G2","G") ;NO NORMALIZE IT BACK INTO AN ARRAY
	D ADDXML("G2","ICD9RESULT") ; AND PUT IT BACK
	Q
ADDXML(INXML,TEMPID,INFARY)	;ADD XML TO A TEMPLATE ID TEMPID
	; INXML IS PASSED BY NAME
	I '$D(INFARY) D  ;
	. S INFARY="FARY" ; FILE ARRAY
	. D INITXPF("FARY") ;IF FILE ARRAY NOT PASSED, INITIALIZE
	I +TEMPID=0 S TEMPID=$$RESTID^C0CSOAP(TEMPID,INFARY) ;RESOLVE TEMPLATE NAME
	D SETXPF(INFARY) ;SET FILE VARIABLES
	D WP^DIE(C0CXPF,TEMPID_",",C0CXFLD,,INXML)
	Q
	;
ADDTEMP(INXML,TEMPID,INFARY)	;ADD XML TEMPLATE TO TEMPLATE RECORD TEMPID
	;
	I '$D(INFARY) D  ;
	. S INFARY="FARY" ; FILE ARRAY
	. D INITXPF("FARY") ;IF FILE ARRAY NOT PASSED, INITIALIZE
	I +TEMPID=0 S TEMPID=$$RESTID^C0CSOAP(TEMPID,INFARY) ;RESOLVE TEMPLATE NAME
	D SETXPF(INFARY) ;SET FILE VARIABLES
	D WP^DIE(C0CXPF,TEMPID_",",C0CXTFLD,,INXML)
	Q
	;
GETXML(OUTXML,TEMPID,INFARY)	;GET THE XML FROM TEMPLATE TEMPID
	;
	I '$D(INFARY) D  ;
	. S INFARY="FARY" ; FILE ARRAY
	. D INITXPF("FARY") ;IF FILE ARRAY NOT PASSED, INITIALIZE
	D SETXPF(INFARY) ;SET FILE VARIABLES
	I +TEMPID=0 S TEMPID=$$RESTID^C0CSOAP(TEMPID,INFARY) ;RESOLVE TEMPLATE NAME
	I $$GET1^DIQ(C0CXPF,TEMPID_",",C0CXFLD,,OUTXML)'=OUTXML D  Q  ;
	. W "ERROR RETRIEVING TEMPLATE",!
	Q
	;
GETTEMP(OUTXML,TEMPID,FARY)	;GET THE TEMPLATE XML FROM TEMPLATE TEMPID
	;
	I '$D(FARY) D  ;
	. S FARY="FARY" ; FILE ARRAY
	. D INITXPF("FARY") ;IF FILE ARRAY NOT PASSED, INITIALIZE
	D SETXPF(FARY) ;SET FILE VARIABLES
	I +TEMPID=0 S TEMPID=$$RESTID^C0CSOAP(TEMPID,FARY) ;RESOLVE TEMPLATE NAME
	I $$GET1^DIQ(C0CXPF,TEMPID_",",C0CXTFLD,,OUTXML)'=OUTXML D  Q  ;
	. W "ERROR RETRIEVING TEMPLATE",!
	Q
	;
COPYWP(ZFLD,ZSRCREC,ZDESTREC,ZSRCF,ZDESTF)	; COPIES A WORD PROCESSING FIELD
	; FROM ONE RECORD TO ANOTHER RECORD 
	; ZFLD IS EITHER A NUMBERIC FIELD OR A NAME IN ZSRCF
	; ZSRCF IS THE SOURCE FILE, IN FILE REDIRECT FORMAT
	; IF ZSRCF IS OMMITED, THE DEFAULT C0C XML MISC FILE WILL BE ASSUMED
	; ZDESTF IS DESTINATION FILE. IF OMMITED, IS ASSUMED TO BE THE SAME
	; A ZSRCF
	I '$D(ZSRCF) D  ;
	. S ZSRCF="ZSRCF"
	. D INITFARY^C0CSOAP(ZSRCF)
	I '$D(ZDESTF) D  ;
	. S ZDESTF="ZDESTF"
	. M @ZDESTF=@ZSRCF
	N ZSF,ZDF,ZSFREF,ZDFREF
	S ZSF=@ZSRCF@("XML FILE NUMBER")
	S ZSFREF=$$FILEREF^C0CRNF(ZSF)
	S ZDF=@ZDESTF@("XML FILE NUMBER")
	S ZDFREF=$$FILEREF^C0CRNF(ZDF)
	N ZSIEN,ZDIEN
	S ZSIEN=$O(@ZSFREF@("B",ZSRCREC,""))
	I ZSIEN="" W !,"ERROR SOURCE RECORD NOT FOUND" Q  ;
	S ZDIEN=$O(@ZDFREF@("B",ZDESTREC,""))
	I ZDIEN="" W !,"ERROR DESTINATION RECORD NOT FOUND" Q  ;
	N ZFLDNUM
	I +ZFLD=0 S ZFLDNUM=@ZSRCF@(ZFLD) ; IF FIELD IS PASSED BY NAME
	E  S ZFLDNUM=ZFLD ; IF FIELD IS PASSED BY NUMBER
	N ZWP,ZWPN
	S ZWPN=$$GET1^DIQ(ZSF,ZSIEN_",",ZFLDNUM,,"ZWP") ; GET WP FROM SOURCE
	I ZWPN'="ZWP" W !,"ERROR SOURCE FIELD EMPTY" Q  ;
	D WP^DIE(ZDF,ZDIEN_",",ZFLDNUM,,"ZWP") ; PUT WP FIELD TO DEST
	Q
	;
COMPILE(TID,UFARY)	; COMPILES AN XML TEMPLATE AND GENERATES XPATH BINDINGS
	; UFARY IF SPECIFIED WILL REDIRECT THE XML FILE TO USE
	; INTID IS THE IEN OF THE RECORD TO USE IN THE XML FILE
	; XML IS PULLED FROM THE "XML" FIELD AND THE COMPILED RESULT PUT
	; IN THE "XML TEMPLATE" FIELD. ALL XPATHS USED IN THE TEMPLATE
	; WILL BE POPULATED TO THE XPATH BINDINGS SUBFILE AS .01
	I '$D(UFARY) D  ;
	. S UFARY="DEFFARY" ; FILE ARRAY
	. ;D INITXPF("UFARY") ;IF FILE ARRAY NOT PASSED, INITIALIZE
	. D INITFARY^C0CSOAP(UFARY)
	D SETXPF(UFARY) ;SET FILE VARIABLES
	I +TID=0 S INTID=$$RESTID^C0CSOAP(TID,UFARY)
	E  S INTID=TID
	;B
	;N C0CXML,C0CREDUX,C0CTEMP,C0CIDX
	D GETXML("C0CXML",INTID,UFARY)
	S C0CREDUX=$$GET1^DIQ(C0CXPF,INTID_",",C0CRDUXF,"E") ;XPATH REDUCTION STRING
	D MKTPLATE("C0CTEMP","C0CIDX","C0CXML",C0CREDUX) ; CREATE TEMPLATE AND IDX
	D ADDTEMP("C0CTEMP",INTID,UFARY) ; WRITE THE TEMPLATE TO FILE
	D ADDXP("C0CIDX",INTID,UFARY) ;CREATE XPATH SUBFILE ENTRIES FOR EVERY XPATH
	Q
	;
MKTPLATE(OUTT,OUTIDX,INXML,REDUX)	;MAKE A TEMPLATE FROM INXML, RETURNED IN OUTT
	; BOTH PASSED BY NAME. THE REDUX XPATH REDUCTION STRING IS USED IF PASSED
	; OUTIDX IS AN ARRAY OF THE XPATHS USED IN MAKING THE TEMPLATE
	;
	S C0CXLOC=$NA(^TMP("C0CXML",$J))
	K @C0CXLOC
	M @C0CXLOC=@INXML
	S C0CDOCID=$$PARSE^C0CMXML(C0CXLOC,"C0CMKT")
	K @C0CXLOC
	S C0CDOM=$NA(^TMP("MXMLDOM",$J,C0CDOCID))
	;N GIDX,GIDX2,GARY,GARY2
	I '$D(REDUX) S REDUX=""
	D XPATH^C0CMXML(1,"/","GIDX","GARY",,REDUX)
	D INVERT("GIDX2","GIDX") ;MAKE ARRAY TO LOOK UP XPATH BY NODE
	N ZI,ZD S ZI=""
	F  S ZI=$O(@C0CDOM@(ZI)) Q:ZI=""  D  ; FOR EACH NODE IN THE DOM
	. K ZD ;FOR DATA
	. D DATA^C0CMXML("ZD",ZI) ;SEE IF THERE IS DATA FOR THIS NODE
	. ;I $D(ZD(1)) D  ; IF YES
	. I $$FIRST^C0CMXML(ZI)=0 D  ; IF THERE ARE NO CHILDREN TO THIS NODE
	. . ;I ZI<3 B  ;W !,ZD(1)
	. . K @C0CDOM@(ZI,"T") ; KILL THE DATA
	. . N ZXPATH
	. . S ZXPATH=$G(GIDX2(ZI)) ;FIND AN XPATH FOR THIS NODE
	. . S @C0CDOM@(ZI,"T",1)="@@"_ZXPATH_"@@"
	. . I ZXPATH'="" S @OUTIDX@(ZXPATH)="" ; PASS BACK XPATH USED IN IDX
	D OUTXML^C0CMXML(OUTT,C0CDOCID)
	Q
	;
INVERT(OUTX,INX)	;INVERTS AN XPATH INDEX RETURNING @OUTX@(x)=XPath from
	; @INX@(XPath)=x
	N ZI S ZI=""
	F  S ZI=$O(@INX@(ZI)) Q:ZI=""  D  ;FOR EACH XPATH IN THE INPUT
	. S @OUTX@(@INX@(ZI))=ZI ; SET INVERTED ENTRY
	Q
	;
DEMUX(OUTX,INX)	;PARSES XPATH PASSED BY VALUE IN INX TO REMOVE [x] MULTIPLES
	; RETURNS OUTX: MULTIPLE^SUBMULTIPLE^XPATH 
	N ZX,ZY,ZZ,ZZ1,ZMULT,ZSUB
	S (ZMULT,ZSUB)=""
	S ZX=$P(INX,"[",2)
	I ZX'="" D  ; THERE IS A [x] MULTIPLE
	. S ZY=$P(INX,"[",1) ;FIRST PART OF XPATH
	. S ZMULT=$P(ZX,"]",1) ; NUMBER OF THE MULTIPLE
	. S ZX=ZY_$P(ZX,"]",2) ; REST OF THE XPATH
	. I $P(ZX,"[",2)'="" D  ; A SUB MULTIPLE EXISTS
	. . S ZZ=$P(ZX,"[",1) ; FIRST PART OF XPATH
	. . S ZX=$P(ZX,"[",2) ; DELETE THE [
	. . S ZSUB=$P(ZX,"]",1) ; NUMBER OF THE SUBMULTIPLE
	. . S ZX=ZZ_$P(ZX,"]",2) ; REST OF THE XPATH
	E  S ZX=INX ;NO MULTIPLE HERE
	S @OUTX=ZMULT_"^"_ZSUB_"^"_ZX ;RETURN MULTIPLE^SUBMULTIPLE^XPATH
	Q
	;
DEMUXARY(OARY,IARY,DEPTH)	;CONVERT AN XPATH ARRAY PASSED AS IARY TO
	; FORMAT @OARY@(x,variablename) where x is the first multiple
	; IF DEPTH=2, THE LAST 2 PARTS OF THE XPATH WILL BE USED
	N ZI,ZJ,ZK,ZL,ZM S ZI=""
	F  S ZI=$O(@IARY@(ZI)) Q:ZI=""  D  ;
	. D DEMUX^C0CMXP("ZJ",ZI)
	. S ZK=$P(ZJ,"^",3)
	. S ZM=$RE($P($RE(ZK),"/",1))
	. I $G(DEPTH)=2 D  ;LAST TWO PARTS OF XPATH USED FOR THE VARIABLE NAME
	. . S ZM=$RE($P($RE(ZK),"/",2))_ZM
	. S ZL=$P(ZJ,"^",1)
	. I ZL="" S ZL=1
	. I $D(@OARY@(ZL,ZM)) D  ;IT'S A DUP
	. . S @OARY@(ZL,ZM_"[2]")=@IARY@(ZI)
	. E  S @OARY@(ZL,ZM)=@IARY@(ZI)
	Q
	;
DEMUX2(OARY,IARY,DEPTH)	;CONVERT AN XPATH ARRAY PASSED AS IARY TO
	; FORMAT @OARY@(x,variablename) where x is the first multiple
	; IF DEPTH=2, THE LAST 2 PARTS OF THE XPATH WILL BE USED
	N ZI,ZJ,ZK,ZL,ZM S ZI=""
	F  S ZI=$O(@IARY@(ZI)) Q:ZI=""  D  ;
	. D DEMUX^C0CMXP("ZJ",ZI)
	. S ZK=$P(ZJ,"^",3)
	. S ZM=$RE($P($RE(ZK),"/",1))
	. I $G(DEPTH)=2 D  ;LAST TWO PARTS OF XPATH USED FOR THE VARIABLE NAME
	. . S ZM=$RE($P($RE(ZK),"/",2))_"."_ZM
	. S ZL=$P(ZJ,"^",1)
	. I ZL="" S ZL=1
	. I $D(@OARY@(ZL,ZM)) D  ;IT'S A DUP
	. . S @OARY@(ZL,ZM_"[2]")=@IARY@(ZI)
	. E  S @OARY@(ZL,ZM)=@IARY@(ZI)
	Q
	;
DEMUXXP1(OARY,IARY)	;IARY IS INCOMING XPATH ARRAY
	; BOTH IARY AND OARY ARE PASSED BY NAME
	; RETURNS A SIMPLE XPATH ARRAY WITHOUT MULTIPLES. DUPLICATES ARE REMOVED
	N ZI,ZJ,ZK
	S ZI=""
	F  S ZI=$O(@IARY@(ZI)) Q:ZI=""  D  ; FOR EACH XPATH IN IARY
	. D DEMUX^C0CMXP("ZJ",ZI)
	. S ZK=$P(ZJ,"^",3) ;THE XPATH
	. S @OARY@(ZK)=@IARY@(ZI) ;THE RESULT. DUPLICATES WILL NOT SHOW
	. ; CAUTION, IF THERE ARE MULTIPLES, ONLY THE DATA FOR THE LAST
	. ; MULTIPLE WILL BE INCLUDED IN THE OUTPUT ARRAY, ASSIGNED TO THE
	. ; COMMON XPATH
	Q
	;
DEMUXXP2(OARY,IARY)	; IARY AND OARY ARE PASSED BY NAME
	; IARY IS AN XPATH ARRAY THAT MAY CONTAIN MULTIPLES
	; OARY IS THE OUTPUT ARRAY WHERE MULTIPLES ARE RETURNED IN THE FORM
	; @OARY@(x,Xpath)=data or @OARY@(x,y,Xpath)=data WHERE x AND y ARE
	; THE MULTIPLES AND Xpath IS THE BASE XPATH WITHOUT [x] AND [y]
	; 
	N ZI,ZJ,ZK,ZX,ZY,ZP
	S ZI=""
	F  S ZI=$O(@IARY@(ZI)) Q:ZI=""  D  ; FOR EACH INPUT XPATH
	. D DEMUX("ZJ",ZI) ; PULL OUT THE MULTIPLES
	. S ZX=$P(ZJ,"^",1) ;x
	. S ZY=$P(ZJ,"^",2) ;y
	. S ZP=$P(ZJ,"^",3) ;Xpath
	. I ZX="" S ZX=1 ; NO MULTIPLE WILL STORE IN x=1
	. I ZY'="" D  ;IS THERE A y?
	. . S @OARY@(ZX,ZY,ZP)=@IARY@(ZI)
	. E  D  ;NO y
	. . S @OARY@(ZX,ZP)=@IARY@(ZI)
	Q
	;
UPDIE	; INTERNAL ROUTINE TO CALL UPDATE^DIE AND CHECK FOR ERRORS
	K ZERR
	D CLEAN^DILF
	D UPDATE^DIE("","C0CFDA","","ZERR")
	I $D(ZERR) S $EC=",U1,"
	K C0CFDA
	Q
	;