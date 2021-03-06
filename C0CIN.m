C0CIN	  ; CCDCCR/GPL - CCR IMPORT utilities; 9/20/08
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
	W "This is the CCR Import Utility Library ",!
	Q
	;
TEST	; TESTS BOTH ROUTINES AT ONCE
	N ZI,ZJ
	S ZI="/home/vademo2/CCR" ;directory purposely leaving off the trailing /
	S ZJ="PAT_358_CCR_V1_0_21.xml" ; random test patient
	D RPCFIN(.GPL,358,135,"GPLTEST","CCR",ZJ,ZI)
	Q
	;
RPCAIN(RTN,DFN,DUZ,SOURCE,TYPE,ARY)	; ARRAY IN RPC - ACCEPT AN XML DOCUMENT
	; AND STORE IT IN THE INCOMING XML FILE
	; RETURNS THE IEN OF THE RECORD OR TEXT IF THERE IS AN ERROR
	I $G(DFN)="" S RTN="DFN NOT DEFINED" Q  ;
	N C0CXF S C0CXF=175 ; FILE NUMBER FOR INCOMING XML FILE
	N C0CFDA,ZX
	S C0CFDA(C0CXF,"+1,",.01)=DFN ; PATIENT
	S C0CFDA(C0CXF,"+1,",.02)=DUZ ; PROVIDER CREATING THE RECORD
	S C0CFDA(C0CXF,"+1,",1)=$$NOW^XLFDT ;DATE
	S C0CFDA(C0CXF,"+1,",2)=TYPE  ;TYPE
	S C0CFDA(C0CXF,"+1,",3)=$$ADDSRC(SOURCE) ;SOURCE
	S C0CFDA(C0CXF,"+1,",7)="NEW" ; STATUS OF NEW FOR NOT PROCESSED
	D UPDIE ; CREATE THE RECORD
	S ZX=C0CIEN(1) ; CAPTURE THE RECORD NUMBER
	D WP^DIE(C0CXF,ZX_",",4,,ARY,"ZERR")
	;W "RECORD:",ZX,!
	S RTN=ZX ; RETURN IEN OF THE XML FILE
	Q
	;
ADDSRC(ZSRC)	;EXTRISIC TO ADD A SOURCE TO THE CCR SOURCE FILE
	; RETURNS RECORD NUMBER. IF SOURCE EXISTS, JUST RETURNS IT'S RECORD NUMBER
	;
	N ZX,ZF,C0CFDA
	S ZF=171.401 ; FILE NUMBER FOR CCR SOURCE FILE
	S C0CFDA(ZF,"?+1,",.01)=ZSRC
	D UPDIE
	Q $O(^C0C(171.401,"B",ZSRC,""))
	;
RPCFIN(RTN,DFN,DUZ,SOURCE,TYPE,FN,FP)	; FILE IN RPC - READ AN XML DOCUMENT
	; FROM A HOST FILE AND STORE IT IN THE INCOMING XML FILE
	N ZX,ZTMP
	I $E($RE(FP))'="/" S ZX=FP_"/"
	E  S ZX=FP
	S ZX=ZX_FN
	D LOAD("ZTMP",ZX)
	I '$D(ZTMP) D  Q  ; NO LUCK
	. W "FILE NOT LOADED",!
	D RPCAIN(.RTN,DFN,DUZ,SOURCE,TYPE,"ZTMP")
	N C0CFDA
	S C0CFDA(175,RTN_",",5)=FN ; FILE NAME
	S C0CFDA(175,RTN_",",6)=FP ; FILE PATH
	D UPDIE ; UPDATE WITH FILE NAME AND PATH
	Q
	;
RPCLIST(RTN,DFN)	; CCR LIST - LIST XML DOCUMENTS FOR PATIENT DFN
	; THAT ARE STORED IN THE INCOMING XML FILE
	; RETURNS AN ARRAY OF THE FORM 
	; RTN(x)="IEN^DATE^TYPE^SOURCE^STATUS^CREATEDBY" WHERE
	; IEN IS THE RECORD NUMBER OF THE XML DOCUMENT
	; DATE IS THE DATE THE DOCUMENT WAS STORED IN THE FILE
	; TYPE IS "CCD" OR "CCR" OR "OTHER"
	; SOURCE IS THE NAME OF THE DOCUMENT SOURCE FROM THE CCR SOURCE FILE
	; STATUS IS THE STATUS OF THE DOCUMENT (VALUES TO BE DEFINED)
	; CREATEDBY IS THE NAME OF THE PROVIDER WHO UPLOADED THE XML
	N ZF S ZF=175 ; FILE NUMBER OF INCOMING XML FILE
	N ZI S ZI=""
	N ZN S ZN=0
	F  S ZI=$O(^C0CIN("B",DFN,ZI),-1) Q:ZI=""  D  ; FOR EACH RECORD FOR THIS PATIENT
	. S ZN=ZN+1 ;INCREMENT COUNT OF RETURN ARRAY
	. S $P(RTN(ZN),"^",1)=ZI ; IEN OF RECORD
	. S $P(RTN(ZN),"^",2)=$$GET1^DIQ(ZF,ZI_",",1,"E") ;DATE
	. S $P(RTN(ZN),"^",3)=$$GET1^DIQ(ZF,ZI_",",2,"E") ;TYPE
	. S $P(RTN(ZN),"^",4)=$$GET1^DIQ(ZF,ZI_",",3,"E") ;SOURCE
	. S $P(RTN(ZN),"^",5)=$$GET1^DIQ(ZF,ZI_",",7,"I") ; STATUS
	. S $P(RTN(ZN),"^",6)=$$GET1^DIQ(ZF,ZI_",",.02,"E") ; CREATED BY
	Q
	;
RPCDOC(RTN,IEN)	; RETRIEVE DOCUMENT NUMBER IEN FROM THE INCOMING XML FILE
	; RETURNED IN ARRAY RTN
	N ZI
	S ZI=$$GET1^DIQ(175,IEN_",",4,,"RTN")
	Q
	;
EN(INXML,SOURCE,C0CDFN)	; IMPORT A CCR, PASSED BY NAME INXML
	; FILE UNDER SOURCE, WHICH IS A POINTER TO THE CCR SOURCE FILE
	; FOR PATIENT C0CDFN
	;N C0CXP
	S C0CINB=$NA(^TMP("C0CIN",$J,"VARS",C0CDFN))
	S C0CDOCID=$$PARSE^C0CMXML(INXML) ;W !,"DocID: ",C0CDOCID
	;S REDUX="//ContinuityOfCareRecord/Body"
	S REDUX=""
	D XPATH^C0CMXML(1,"/","C0CIDX","C0CXP",,REDUX)
	;D INDEX^C0CXPATH(INXML,"C0CXP",-1) ; GENERATE XPATHS FROM THE CCR
	;N ZI,ZJ,ZK 
	S ZI=""
	F  S ZI=$O(C0CXP(ZI)) Q:ZI=""  D  ; FOR EACH XPATH
	. D DEMUX^C0CMXP("ZJ",ZI) ;
	. W ZJ,!
	. S ZK=$P(ZJ,"^",3) ; PULL OUT THE XPATH
	. S ZM=$P(ZJ,"^",1) ; PULL OUT THE MULTIPLE
	. S ZS=$P(ZJ,"^",2) ; PULL OUT THE SUBMULTIPLE
	. S C0CDICN=$O(^C0CDIC(170,"XPATH",ZK,""))
	. I C0CDICN="" D  Q  ;
	. . W "MISSING XPATH:",!,ZK,! ; OOPS, XPATH NOT IN C0CDIC
	. . S MISSING(ZK)=""
	. ;D GETS^DIQ(170,C0CDICN_",","*",,"C0CFDA")
	. S C0CVAR=$$GET1^DIQ(170,C0CDICN_",",.01) ; VARIABLE NAME
	. S C0CSEC=$$GET1^DIQ(170,C0CDICN_",",12) ;ELEMENT TYPE
	. W C0CSEC,":",C0CVAR,!
	Q
	; 
GETACCR(AOUT,C0CDFN)	; EXTRACT A CCR FOR PATIENT ADFN AND PUT IT IN ARRAY AOUT
	;PASSED BY NAME
	N ZT
	D CCRRPC^C0CCCR(.ZT,C0CDFN,"LABLIMIT:T-1000")
	M @AOUT=ZT
	Q
	;
TEST64	;TEST BASE64 DECODING FOR IMPORTING CCR FROM THE NHIN
	W $$FTG^%ZISH("/tmp/","base64_encoded_ccr.txt","G64(1)",1)
	S G=G64(1)
	S ZI=""
	F  S ZI=$O(G64(1,"OVF",ZI)) Q:ZI=""  D  ; FOR EVERY OVERFLOW RECORD
	. S G=G_G64(1,"OVF",ZI) ;HOPE IT'S NOT TOO BIG
	S G2=$$DECODE^RGUTUU(G)
	Q
	;
NORMAL(OUTXML,INXML)	;NORMALIZES AN XML STRING PASSED BY NAME IN INXML
	; INTO AN XML ARRAY RETURNED IN OUTXML, ALSO PASSED BY NAME
	;
	N ZI,ZN,ZTMP
	S ZN=1
	S @OUTXML@(ZN)=$P(@INXML,"><",ZN)_">"
	S ZN=ZN+1
	F  S @OUTXML@(ZN)="<"_$P(@INXML,"><",ZN) Q:$P(@INXML,"><",ZN+1)=""  D  ;
	. S @OUTXML@(ZN)=@OUTXML@(ZN)_">"
	. S ZN=ZN+1
	Q
	;
CLEANCR(OUTXML,INXML)	; USE $C(10) TO SEPARATE THE STRING INXML INTO
	;AN ARRAY OUTXML(n) OUTXML AND INXML PASSED BY NAME
	N ZX,ZY,ZN
	S ZX=1,ZN=1
	F  S ZY=$F(@INXML,$C(10),ZX) Q:ZY=0  D  ;
	. S @OUTXML@(ZN)=$E(G2,ZX,ZY-2)
	. I @OUTXML@(ZN)'="" S ZN=ZN+1
	. S ZX=ZY
	Q
	;
LOAD(ZRTN,filepath)	; load an xml file into the ZRTN array, passed by name
	n i
	D  ;
	. n zfile,zpath,ztmp,zok s (zfile,zpath,ztmp)=""
	. s ztmp=$na(^TMP("C0CLOAD",$J))
	. k @ztmp
	. s zfile=$re($p($re(filepath),"/",1)) ;file name
	. s zpath=$p(filepath,zfile,1) ; file path
	. s zok=$$FTG^%ZISH(zpath,zfile,$NA(@ztmp@(1)),3) ; import the file incr sub 3
	. m @ZRTN=@ztmp
	. k @ztmp
	. s i=$o(@ZRTN@(""),-1) ; highest line number
	q
	;
UPDIE	; INTERNAL ROUTINE TO CALL UPDATE^DIE AND CHECK FOR ERRORS
	K ZERR,C0CIEN
	D CLEAN^DILF
	D UPDATE^DIE("","C0CFDA","C0CIEN","ZERR")
	I $D(ZERR) S $EC=",U1,"
	K C0CFDA
	Q
	; 
