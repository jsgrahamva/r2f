C0CRXN	  ; CCDCCR/GPL - CCR RXN utilities; 12/6/08
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
	W "This is the CCR RXNORM Utility Library ",!
	W !
	Q
	;
EXPAND	; MAIN ROUTINE TO CREATE THE C0C RXNORM VUID EXPANSION FILE (176.112)
	; READ EACH RECORD FROM 176.111 AND USE THE VUID TO LOOK UP THE RXNORM
	; CODE FROM 176.001 (RXNORM CONCEPTS)
	; POPULATE ALL FIELDS IN 176.112 AND SET "NEW" TO "Y" IF 176.111 DOES NOT
	; ALREADY HAVE AN RXNORM CODE.
	; ADD THE RXNORM TEXT FIELD TO EVERY RECORD (NOT PRESENT IN 176.111)
	; AND COMPARE THE RXNORM TEXT FIELD WITH THE VUID TEXT FIELD, SETTING THE
	; "DIFFERENT TEXT" FIELD TO "Y" IF THERE ARE DIFFERENCES
	; USES SUPPORT ROUTINES FROM C0CRNF.m
	N C0CFDA,C0CA,C0CB,C0CC,C0CZX ;FDA WORK ARRAY, RNF ARRAYS, AND IEN ITERATOR
	N C0CFVA,C0CFRXN ; CLOSED ROOTS FOR SOURCE FILES
	N C0CF ; CLOSED ROOT FOR DESTINATION FILE
	S C0CVA=$$FILEREF^C0CRNF(176.111) ; C0C PHARMACY VA RXNORM MAPPING FILE
	S C0CFRXN=$$FILEREF^C0CRNF(176.001) ; CLOSED ROOT FOR RXNORM CONCEPT FILE
	S C0CF=$$FILEREF^C0CRNF(176.112) ; C0C RXNORM VUID MAPPING EXPANSION FILE
	W C0CVA,C0CFRXN,C0CF,!
	S C0CZX=0
	S (HASRXN,NORXN,NOVUID,RXFOUND,RXMATCH,TXTMATCH)=0 ; INITIALIZE COUNTERS
	F  S C0CZX=$O(^C0CCODES(176.111,C0CZX)) Q:+C0CZX=0  D  ; FOR EVERY RECORD
	. K C0CA,C0CB,C0CC ; CLEAR ARRAYS
	. D FIELDS^C0CRNF("C0CC",176.112) ;GET FIELD NAMES FOR OUTPUT FILE
	. D GETN1^C0CRNF("C0CA",176.111,C0CZX,"","ALL") ;GET THE FIELDS
	. I $$ZVALUE("MEDIATION CODE")="" D
	. . S NORXN=NORXN+1 ;
	. E  D  ; PROCESS MEDIATION CODE
	. . S HASRXN=HASRXN+1
	. . D SETFDA("MEDIATION CODE",$$ZVALUE("MEDIATION CODE")) ;
	. I $$ZVALUE("VUID")="" D  ; BAD RECORD
	. . S NOVUID=NOVUID+1
	. . ;D SETFDA("VUID",$$ZVALUE("VUID"))
	. E  D SETFDA("VUID TEXT",$$ZVALUE("VUID TEXT"))
	. ;ZWR C0CA
	. D GETN1^C0CRNF("C0CB",176.001,$$ZVALUE("VUID"),"VUID","ALL")
	. I $$ZVALUE("RXCUI","C0CB")'="" D  ; RXNORM FOUND
	. . S RXFOUND=RXFOUND+1
	. . I $$ZVALUE("MEDIATION CODE")="" D  ; THIS IS A NEW CODE
	. . . D SETFDA("MEDIATION CODE",$$ZVALUE("RXCUI","C0CB"))
	. . . D SETFDA("NEW","Y") ;FLAG RECORD HAS HAVING NEW RXNORM
	. . W "RXNORM=",$$ZVALUE("RXCUI","C0CB")," ",$$ZVALUE("STR","C0CB"),!
	. . W "VUID TEXT: ",$$ZVALUE("VUID TEXT"),!
	. . I $$ZVALUE("VUID TEXT")=$$ZVALUE("STR","C0CB") S TXTMATCH=TXTMATCH+1
	. . E  D  ;
	. . . S ZZ=$$ZVALUE("VUID TEXT")_"^"_$$ZVALUE("STR","C0CB")
	. . . D PUSH^GPLXPATH("NOMATCH",ZZ)
	. . . D SETFDA("RXNORM TEXT",$$ZVALUE("STR","C0CB")) ;
	. . . D SETFDA("DIFFERENT TEXT","Y") ;FLAG RECORD FOR DIFFERENT TEXT
	. I $$ZVALUE("MEDIATION CODE")=$$ZVALUE("RXCUI","C0CB") D  ;
	. . S RXMATCH=RXMATCH+1
	. . W "VUID=",$$ZVALUE("VUID")," MATCH RXNORM=",$$ZVALUE("MEDIATION CODE"),!
	. D CLEAN^DILF ; MAKE SURE WE ARE CLEANED UP
	. S C0CFDA(176.112,"+"_C0CZX_",",.01)=$$ZVALUE("VUID") ; NEW VUID RECORD
	. D UPDATE^DIE("","C0CFDA")
	. I $D(^TMP("DIERR",$J)) S $EC=",U1,"
	W "HAS RXN=",HASRXN,!
	W "NO RXN=",NORXN,!
	W "NO VUID=",NOVUID,!
	W "RXNORM FOUND=",RXFOUND,!
	W "RXNORM MATCHES:",RXMATCH,!
	W "TEXT MATCHES:",TXTMATCH,!
	Q
	;
EXP2	; ROUTINE TO CREATE 176.113 C0C RXNORM VUID MAPPING DISCREPANCIES FILE
	; CROSS CHECKS THE NATIONAL DRUG FILE AND THE VA MAPPING FILE AGAINST
	; THE UMLS RXNORM DATABASE
	; THIS ROUTINE HAS BEEN ENHANCED TO ALSO CHECK THE 50.416 DRUG INGREDIENT
	; FILE AND TREAT VUIDS FOUND THERE LIKE THE ONES BEING FOUND IN THE NDF
	; IF THE VUID EXISISTS IN ALL THREE FILES, THE RXNORM CODE MATCHES IN
	; THE VA MAPPING FILE AND THE TEXT STRINGS ARE THE SAME, THE VUID IS INCLUDED
	; IN THE FILE BUT NO FLAGS ARE SET
	; IF THE VUID IS MISSING FROM THE NATIONAL DRUG FILE NDF=N
	; (IF THE VUID IS MISSING FROM THE NDF, IT IS CHECKED IN THE DRUG INGREDIENT
	; FILE, AND IF FOUND, THE FLAG IS NOT SET. IN THIS CASE THE TEXT FROM THE
	; DRUG INGREDIENT FILE IS USED FOR COMPARISONS)
	; IF THE VUID IS MISSING FROM THE VA MAPPING FILE VAMAP=N
	; IF THE VUID IS PRESENT IN THE VA MAPPING FILE, BUT THE RXNORM
	; CODE IS MISSING IN THAT FILE, VARXN=N
	; IF THE TEXT STRINGS DO NOT MATCH EXACTLY, TXTM=N AND ALL THREE STRINGS
	; ARE SHOWN; NDF TEXT=NDF TEXT STRING, VA MAP TEXT=VA MAPPING TEXT STRING
	; RXNORM TEXT=RXNORM TEXT STRING
	; THE FILE IS KEYED ON VUID AND WOULD USUALLY BE SORTED BY VUID
	; THE OBJECTIVE IS TO SEE IF NDF (50.68) AND VA MAPPING (176.111) HAVE
	; ALL THE VUID CODES THAT ARE IN THE UMLS RXNORM DATABASE
	N C0CFDA,C0CA,C0CB,C0CC,C0CZX ;FDA WORK ARRAY, RNF ARRAYS, AND IEN ITERATOR
	N C0CFVA,C0CFRXN ; CLOSED ROOTS FOR SOURCE FILES
	N C0CF ; CLOSED ROOT FOR DESTINATION FILE
	S C0CVA=$$FILEREF^C0CRNF(176.111) ; C0C PHARMACY VA RXNORM MAPPING FILE
	S C0CFRXN=$$FILEREF^C0CRNF(176.001) ; CLOSED ROOT FOR RXNORM CONCEPT FILE
	;S C0CF=$$FILEREF^C0CRNF(176.113) ; C0C RXNORM VUID MAPPING ADDITIONAL FILE
	W C0CVA,C0CFRXN,! ;C0CF,!
	S C0CZX=0
	S (NDFVCNT,NDFTCNT,NDFNO)=0 ; COUNTERS FOR NDF TESTS
	S (VAVCNT,VATCNT,VARCNT,VANO)=0 ; COUNTERS FOR VA MAPPING FILE TESTS
	F  S C0CZX=$O(^C0CRXN(176.001,"VUID",C0CZX)) Q:+C0CZX=0  D  ; FOR EVERY VUID
	. K C0CA,C0CB,C0CC,C0CD ; CLEAR ARRAYS
	. D FIELDS^C0CRNF("C0CC",176.113) ;GET FIELD NAMES FOR OUTPUT FILE
	. D GETN1^C0CRNF("C0CA",176.001,C0CZX,"VUID","ALL") ;GET FROM RXNORM FILE
	. D GETN1^C0CRNF("C0CB",176.111,C0CZX,"B","ALL") ;GET FROM VA MAPPING FILE
	. D GETN1^C0CRNF("C0CD",50.68,C0CZX,"AVUID","ALL") ;GET FROM NDF
	. D GETN1^C0CRNF("C0CE",50.416,C0CZX,"AVUID","ALL") ;GET FROM DRUG INGREDIENTS
	. ;D SETFDA("VUID",$$ZVALUE("CODE")) ;SET THE VUID CODE
	. D SETFDA("RXNORM",$$ZVALUE("RXCUI")) ;SET THE RXNORM CODE
	. D SETFDA("RXNORM TEXT",$$ZVALUE("STR")) ;SET THE RXNORM TEXT
	. ;VA MAPPING FILE TESTS
	. I $$ZVALUE("VUID","C0CB")=C0CZX D  ; VUID FOUND
	. . S VAVCNT=VAVCNT+1 ;INCREMENT COUNT
	. . I $$ZVALUE("STR")'=$$ZVALUE("VUID TEXT","C0CB") D  ;TEXT MISMATCH
	. . . S VATCNT=VATCNT+1 ; INCREMENT VA TEXT MISMATCH COUNT
	. . . D SETFDA("TXTM","N") ;MARK THAT TEXT DOESN'T MATCH
	. . . D SETFDA("VA MAP TEXT",$$ZVALUE("VUID TEXT","C0CB")) ; SET VA MAP TEXT
	. E  D  ; VUID NOT FOUND
	. . S VANO=VANO+1
	. . D SETFDA("VAMAP","N") ;MARK AS MISSING FROM VA MAPPING FILE
	. ; NATIONAL DRUG FILE TESTS
	. I ($$ZVALUE("VUID","C0CD")=C0CZX)!($$ZVALUE("VUID","C0CE")=C0CZX) D  ;
	. . ;FOUND IN NATIONAL DRUG FILE OR DRUG INGREDIENT FILE
	. . S NDFVCNT=NDFVCNT+1 ;INCREMENT VUID FOUND COUNT
	. . I $$ZVALUE("NAME","C0CD")'=$$ZVALUE("STR") D  ;NDF TEXT DOESN'T MATCH
	. . . I $$ZVALUE("NAME","C0CE")'=$$ZVALUE("STR") D  ;DRUG ING FILE ALSO
	. . . . S NDFTCNT=NDFTCNT+1 ; INCREMENT MISMATCHED NDF TEXT COUNT
	. . . . D SETFDA("TXTM","N") ; SET TEXT MATCH FLAG TO N
	. . . . D SETFDA("NDF TEXT",$$ZVALUE("NAME","C0CD")) ;POST THE TEXT
	. . . . D SETFDA("NAT DRUG TEXT",$$ZVALUE("NAME","C0CE")) ;POST TEXT
	. E  D  ;
	. . D SETFDA("NDF","N") ;MARK AS MISSING
	. . S NDFNO=NDFNO+1 ;INCREMENT MISSING COUNT
	. D CLEAN^DILF ; MAKE SURE WE ARE CLEANED UP
	. S C0CFDA(176.113,"+"_C0CZX_",",.01)=C0CZX ; NEW VUID RECORD
	. D UPDATE^DIE("","C0CFDA")
	. I $D(^TMP("DIERR",$J)) S $EC=",U1,"
	W "VA MAPPING VUID COUNT: ",VAVCNT,!
	W "VA MAPPING MISSING: ",VANO,!
	W "VA MAPPING TEXT MISMATCH: ",VATCNT,!
	W "NDF VUID COUNT: ",NDFVCNT,!
	W "NDF MISSING: ",NDFNO,!
	W "NDF TEXT MISMATCH: ",NDFTCNT,!
	Q
CHKNDF	; ROUTINE TO CHECK THE NATIONAL DRUG FILE WITH THE UMLS RXNORM DB
	; USING THE AVUID INDEX, READS ALL VUID CODES IN ^PSNDF(50.68),
	; CHECKS TO SEE IF THE CODE IS IN 176.001, AND CREATES A RECORD
	; IN 176.114
	; THE OBJECTIVE IS TO SEE IF ^PSNDF(50.68) HAS ALL THE VUID CODES IN THE
	; UMLS RXNORM DATABASE AND IF THE TEXT FIELDS MATCH
	; ALSO CAPTURES THE RXNORM CODE MAPPING
	; CHKNDF2 WILL CHECK THE OTHER DIRECTION, STARTING WITH THE 176.001 VUID INDEX
	; THIS ROUTINE ALSO CHECKS IF THE VUID CODE IS IN 176.111 AND IF NOT
	; SETS NOTMAPPED=Y
	N C0CFDA,C0CA,C0CB,C0CC,C0CZX ;FDA WORK ARRAY, RNF ARRAYS, AND IEN ITERATOR
	N C0CFVA,C0CFRXN,C0CPSNDF ; CLOSED ROOTS FOR SOURCE FILES
	N C0CF ; CLOSED ROOT FOR DESTINATION FILE
	S C0CPSNDF=$$FILEREF^C0CRNF(50.68) ; NDF CLOSED ROOT REFERENCE
	S C0CVA=$$FILEREF^C0CRNF(176.111) ; C0C PHARMACY VA RXNORM MAPPING FILE
	S C0CFRXN=$$FILEREF^C0CRNF(176.001) ; CLOSED ROOT FOR RXNORM CONCEPT FILE
	;S C0CF=$$FILEREF^C0CRNF(176.113) ; C0C RXNORM VUID MAPPING ADDITIONAL FILE
	W C0CVA,C0CFRXN,! ;C0CF,!
	S C0CZX=0
	S (FOUND,MISSING)=0
	S (NOVUID,VMATCH,NOMATCH,MISSING,FOUND,TXTMATCH,NOTM,NVAM)=0 ; COUNTERS
	F  S C0CZX=$O(^PSNDF(50.68,"AVUID",C0CZX)) Q:+C0CZX=0  D  ; FOR EVERY VUID
	. K C0CA,C0CB,C0CC,C0CD ; CLEAR ARRAYS
	. ;D FIELDS^C0CRNF("C0CC",176.113) ;GET FIELD NAMES FOR OUTPUT FILE
	. D GETN1^C0CRNF("C0CA",50.68,C0CZX,"AVUID","ALL") ;GET THE FIELDS
	. I $$ZVALUE("VUID")="" D  ; ERROR, SHOULD NOT HAPPEN
	. . S NOVUID=NOVUID+1 ; FLAG THE ERROR
	. . D PUSH^GPLXPATH("NOVUID",C0CZX) ; RECORD THE VUID
	. D GETN1^C0CRNF("C0CD",176.001,C0CZX,"VUID","ALL") ;TRY RXNORM DB
	. I $$ZVALUE("CODE","C0CD")=C0CZX D  ; FOUND IN RXNORM
	. . S VMATCH=VMATCH+1 ; COUNT OF PSNDF VUIDS FOUND IN RXNORM
	. . I $$ZVALUE("NAME")=$$ZVALUE("STR","C0CD") D  ;TEXT MATCHES
	. . . S TXTMATCH=TXTMATCH+1 ; COUNT IT
	. . E  D  ; TEXT DOESN'T MATCH
	. . . S NOTM=NOTM+1 ;NO TEXT MATCH COUNTER
	. . . S ZV=$$ZVALUE("NAME")_"^"_$$ZVALUE("STR","C0CD")
	. . . W ZV,!
	. . . D PUSH^GPLXPATH("TXTNM",ZV) ; RECORD THE TXT MISMATCH
	. E  S NOMATCH=NOMATCH+1 ; NOT FOUND IN RXNORM
	. D GETN1^C0CRNF("C0CB",176.111,C0CZX,"B","ALL") ;TRY TO GET FROM 176.111
	. I $$ZVALUE("VUID","C0CB")="" D  ; VUID NOT FOUND
	. . ;W "NOT FOUND: ",C0CZX," ",$$ZVALUE("STR")," ",$$ZVALUE("RXCUI"),!
	. . S MISSING=MISSING+1
	. . D PUSH^GPLXPATH("MISSING",C0CZX) ;MISSING FROM MAPPING FILE
	. E  D  ; FOUND IN VA MAPPING FILE
	. . S FOUND=FOUND+1
	. . I $$ZVALUE("VUID TEXT","C0CB")'=$$ZVALUE("NAME") D  ; TEXT DOESN'T MATCH
	. . . S NVAM=NVAM+1 ; MAPPING FILE TEXT IS DIFFERENT THAN NDF
	. . . S ZY=$$ZVALUE("VUID TEXT","C0CB")_"^"_$$ZVALUE("NAME") ;BOTH STRINGS
	. . . W "VA: ",ZY,!
	. . . D PUSH^GPLXPATH("NVAM",ZY) ;SAVE IT
	W "MISSING IN MAPPING FILE: ",MISSING,!
	W "FOUND IN MAPPING FILE: ",FOUND,!
	W "FOUND IN RXNORM: ",VMATCH,!
	W "NOT FOUND IN RXNORM: ",NOMATCH,!
	W "ERRORS: ",NOVUID,!
	Q
	;
	D
	. I $$ZVALUE("MEDIATION CODE")="" D
	. . S NORXN=NORXN+1 ;
	. E  D  ; PROCESS MEDIATION CODE
	. . S HASRXN=HASRXN+1
	. . D SETFDA("MEDIATION CODE",$$ZVALUE("MEDIATION CODE")) ;
	. I $$ZVALUE("VUID")="" D  ; BAD RECORD
	. . S NOVUID=NOVUID+1
	. . ;D SETFDA("VUID",$$ZVALUE("VUID"))
	. E  D SETFDA("VUID TEXT",$$ZVALUE("VUID TEXT"))
	. ;ZWR C0CA
	. D GETN1^C0CRNF("C0CB",176.001,$$ZVALUE("VUID"),"VUID","ALL")
	. I $$ZVALUE("RXCUI","C0CB")'="" D  ; RXNORM FOUND
	. . S RXFOUND=RXFOUND+1
	. . I $$ZVALUE("MEDIATION CODE")="" D  ; THIS IS A NEW CODE
	. . . D SETFDA("MEDIATION CODE",$$ZVALUE("RXCUI","C0CB"))
	. . . D SETFDA("NEW","Y") ;FLAG RECORD HAS HAVING NEW RXNORM
	. . W "RXNORM=",$$ZVALUE("RXCUI","C0CB")," ",$$ZVALUE("STR","C0CB"),!
	. . W "VUID TEXT: ",$$ZVALUE("VUID TEXT"),!
	. . I $$ZVALUE("VUID TEXT")=$$ZVALUE("STR","C0CB") S TXTMATCH=TXTMATCH+1
	. . E  D  ;
	. . . D PUSH^GPLXPATH("NOMATCH",$$ZVALUE("VUID TEXT")_"^"_$$ZVALUE("STR","C0CB"))
	. . . D SETFDA("RXNORM TEXT",$$ZVALUE("STR","C0CB")) ;
	. . . D SETFDA("DIFFERENT TEXT","Y") ;FLAG RECORD FOR DIFFERENT TEXT
	. I $$ZVALUE("MEDIATION CODE")=$$ZVALUE("RXCUI","C0CB") D  ;
	. . S RXMATCH=RXMATCH+1
	. . W "VUID=",$$ZVALUE("VUID")," MATCH RXNORM=",$$ZVALUE("MEDIATION CODE"),!
	. D CLEAN^DILF ; MAKE SURE WE ARE CLEANED UP
	. S C0CFDA(176.112,"+"_C0CZX_",",.01)=$$ZVALUE("VUID") ; NEW VUID RECORD
	. D UPDATE^DIE("","C0CFDA")
	. I $D(^TMP("DIERR",$J)) S $EC=",U1,"
	W "HAS RXN=",HASRXN,!
	W "NO RXN=",NORXN,!
	W "NO VUID=",NOVUID,!
	W "RXNORM FOUND=",RXFOUND,!
	W "RXNORM MATCHES:",RXMATCH,!
	W "TEXT MATCHES:",TXTMATCH,!
	Q
SETFDA(C0CSN,C0CSV)	; INTERNAL ROUTINE TO MAKE AN FDA ENTRY FOR FIELD C0CSN
	; TO SET TO VALUE C0CSV.
	; C0CFDA,C0CA,C0CZX ARE ASSUMED FROM THE CALLING ROUTINE
	; C0CSN,C0CSV ARE PASSED BY VALUE
	;
	N C0CSI,C0CSJ
	S C0CSI=$$ZFILE(C0CSN,"C0CC") ; FILE NUMBER
	S C0CSJ=$$ZFIELD(C0CSN,"C0CC") ; FIELD NUMBER
	S C0CFDA(C0CSI,"+"_C0CZX_",",C0CSJ)=C0CSV
	Q
ZFILE(ZFN,ZTAB)	; EXTRINSIC TO RETURN FILE NUMBER FOR FIELD NAME PASSED
	; BY VALUE IN ZFN. FILE NUMBER IS PIECE 1 OF C0CA(ZFN)
	; IF ZTAB IS NULL, IT DEFAULTS TO C0CA
	I '$D(ZTAB) S ZTAB="C0CA"
	N ZR
	I $D(@ZTAB@(ZFN)) S ZR=$P(@ZTAB@(ZFN),"^",1)
	E  S ZR=""
	Q ZR
ZFIELD(ZFN,ZTAB)	;EXTRINSIC TO RETURN FIELD NUMBER FOR FIELD NAME PASSED
	; BY VALUE IN ZFN. FILE NUMBER IS PIECE 2 OF C0CA(ZFN)
	; IF ZTAB IS NULL, IT DEFAULTS TO C0CA
	I '$D(ZTAB) S ZTAB="C0CA"
	N ZR
	I $D(@ZTAB@(ZFN)) S ZR=$P(@ZTAB@(ZFN),"^",2)
	E  S ZR=""
	Q ZR
	;
ZVALUE(ZFN,ZTAB)	;EXTRINSIC TO RETURN VALUE FOR FIELD NAME PASSED
	; BY VALUE IN ZFN. FILE NUMBER IS PIECE 3 OF C0CA(ZFN)
	; IF ZTAB IS NULL, IT DEFAULTS TO C0CA
	I '$D(ZTAB) S ZTAB="C0CA"
	N ZR
	I $D(@ZTAB@(ZFN)) S ZR=$P(@ZTAB@(ZFN),"^",3)
	E  S ZR=""
	Q ZR
	;
