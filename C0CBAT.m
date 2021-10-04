C0CBAT	  ; CCDCCR/GPL - CCR Batch utilities; 4/21/09
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
	;
	W "This is the CCR Batch Utility Library ",!
	Q
	;
STOP	; STOP A CURRENTLY RUNNING BATCH JOB
	I '$D(^TMP("C0CBAT","RUNNING")) Q  ;
	W !,!,"HALTING CCR BATCH",!
	S ^TMP("C0CBAT","STOP")="" ; SIGNAL JOB TO TERMINATE
	H 10 ; WAIT TEN SECONDS FOR SIGNAL TO BE RECEIVED
	I '$D(^TMP("C0CBAT","STOP")) D  ; SIGNAL RECEIVED
	. W "CCR BATCH JOB TERMINATING",!
	E  D  ;
	. K ^TMP("C0CBAT","STOP") ; STOP SIGNALING
	. W !,"BATCH PROCESSING APPARENTLY NOT RUNNING",!
	Q
	;
START	; STARTS A TAKSMAN CCR BATCH JOB - FOR USE IN A MENU OPTION
	;
	I $D(^TMP("C0CBAT","RUNNING")) D  Q  ; ONLY ONE ALLOWED AT A TIME
	. W !,"CCR BATCH ALREADY RUNNING",!
	. W !,"STOP FIRST WITH STOP^C0CBAT",!
	N ZTRTN,ZTDESC,ZTDTH,ZTSAVE,ZTSK,ZTIO
	S ZTRTN="EN^C0CBAT",ZTDESC="CCR Batch"
	S ZTDTH=$H ; 
	;S ZTDTH=$S(($P(ZTDTH,",",2)+10)\86400:(1+ZTDTH)_","_((($P(ZTDTH,",",2)+10)#86400)/100000),1:(+ZTDTH)_","_($P(ZTDTH,",",2)+10))
	S ZTSAVE("C0C")="",ZTSAVE("C0C*")=""
	S ZTIO="NULL" ;
	W !,!,"CCR BATCH JOB STARTED",!
	D ^%ZTLOAD
	Q
	;
EN	; BATCH ENTRY POINT
	; PROCESSES THE SUBSCRIPTION FILE, EXTRACTING CCR VARIABLES FOR EACH
	; PATIENT WITH AN ACTIVE SUBSCRIPTION, AND IF CHECKSUMS INDICATE A CHANGE,
	; GENERATES A NEW CCR FOR THE PATIENT
	; UPDATES THE E2 CCR ELEMENTS FILE
	;
	S C0CQT=1 ; QUIET MODE
	I $D(^TMP("C0CBAT","RUNNING")) Q  ; ONLY ONE AT A TIME
	S ^TMP("C0CBAT","RUNNING")="" ; RUNNING SIGNAL
	S C0CBDT=$$NOW^XLFDT ; DATE OF THIS RUN
	S C0CBF=177.301 ; FILE NUMBER OF C0C BATCH CONTROL FILE
	S C0CBFR=177.3013 ; FILE NUMBER OF UPDATE SUBFILE
	S C0CBB=$NA(^TMP("C0CBATCH",C0CBDT)) ; BATCH WORK AREA
	I $D(@C0CBB@(0)) D  ; ERROR SHOULDN'T EXIST
	. W "WORK AREA ERROR",!
	. S $EC=",U1,"
	S @C0CBB@(0)="V22" ; VERSION USED TO CREATE THIS WORK AREA
	S C0CBH=$NA(@C0CBB@("HOTLIST")) ; BASE FOR HOT LIST
	S C0CBS=$NA(^C0CS("B")) ; SUBSCRIPTION LIST BASE
	;I $D(^C0CB("B",C0CDT)) D  ; BATCH RECORD EXISTS
	;. H 10 ; HANG 10 SECONDS
	;. S C0CBDT=$$NOW^XLFDT ; NEW DATE FOR THIS RUN
	;. I $D(^C0CB("B",C0CDT)) B ;DIDN'T WORK
	D BLDHOT(C0CBH) ; BUILD THE HOT LIST
	S C0CHN=$$COUNT(C0CBH) ;COUNT NUMBER IN HOT LIST
	S C0CSN=$$COUNT(C0CBS) ;COUNT NUMBER OF PATIENTS WITH SUBSCRIPTIONS
	S C0CFDA(C0CBF,"+1,",.01)=C0CBDT ; DATE KEY OF BATCH CONTROL
	S C0CFDA(C0CBF,"+1,",.02)=C0CBDT ; BATCH ID IS DATE IN STRING FORM
	S C0CFDA(C0CBF,"+1,",1)=C0CSN ; TOTAL SUBSCRIPTIONS
	S C0CFDA(C0CBF,"+1,",2)=C0CHN ; TOTAL HOT LIST
	D UPDIE ; CREATE THE BATCH RECORD
	S C0CIEN=$O(^C0CB("B",C0CBDT,""))
	S (C0CN,C0CNH)=0 ; COUNTERS FOR TOTAL AND HOT LIST
	S C0CBCUR="" ; CURRENT PATIENT
	S C0CSTOP=0 ; STOP FLAG FOR HALTING BATCH SET ^TMP("C0CBAT","STOP")=""
	;F  S C0CBCUR=$O(@C0CBH@(C0CBCUR),-1) Q:C0CBCUR=""  D  ; HOT LIST LATEST FIRST
	F  S C0CBCUR=$O(@C0CBH@(C0CBCUR)) Q:(C0CSTOP)!(C0CBCUR="")  D  ; HOT LIST FIRST
	. D ANALYZE^C0CRIMA(C0CBCUR,1,"LABLIMIT:T-900^VITLIMIT:T-900")
	. I $G(C0CCHK) D  ;
	. . D PUTRIM^C0CFM2(C0CBCUR)
	. . D XPAT^C0CCCR(C0CBCUR) ; IF VARIABLES HAVE CHANGED GENERATE CCR
	. . K C0CFDA
	. . S C0CFDA(C0CBFR,"+1,"_C0CIEN_",",.01)=C0CBCUR
	. . S C0CFDA(C0CBFR,"+1,"_C0CIEN_",",1)="Y"
	. . S C0CFDA(C0CBFR,"+1,"_C0CIEN_",",2)=$G(^TMP("C0CCCR","FNAME",C0CBCUR))
	. . D UPDIE ; CREATE UPDATE SUBFILE 
	. S C0CN=C0CN+1 ; INCREMENT NUMBER IN TOTAL
	. S C0CNH=C0CNH+1 ; INCREMENT HOT LIST TOTAL
	. S C0CFDA(C0CBF,C0CIEN_",",1.1)=C0CN ;UPDATE TOTAL PROGRESS
	. S C0CFDA(C0CBF,C0CIEN_",",2.1)=C0CNH ; UPDATE HOT LIST PROGRESS
	. S C0CNOW=$$NOW^XLFDT
	. S C0CFDA(C0CBF,C0CIEN_",",4)=C0CNOW ; LAST UPDATED FIELD
	. S C0CELPS=$$FMDIFF^XLFDT(C0CNOW,C0CBDT,2) ; DIFFERENCE IN SECONDS
	. S C0CAVG=C0CELPS/C0CN ; AVERAGE ELAPSED TIME
	. S C0CFDA(C0CBF,C0CIEN_",",4.1)=C0CAVG ; AVERAGE ELAPSED TIME
	. S C0CETOT=C0CAVG*C0CSN ; EST TOT ELASPSED TIME 
	. S C0CEST=$$FMADD^XLFDT(C0CBDT,0,0,0,C0CETOT) ; ADD SECONDS TO BATCH START
	. S C0CFDA(C0CBF,C0CIEN_",",4.2)=C0CEST ;ESTIMATED COMPLETION TIME
	. S C0CFDA(C0CBF,C0CIEN_",",5)=C0CBCUR ; LAST RECORD PROCESSED
	. D UPDIE ;
	. I $D(^TMP("C0CBAT","STOP")) D  ; IF STOP SIGNAL DETECTED
	. . S C0CSTOP=1
	. . K ^TMP("C0CBAT","STOP") ; SIGNAL RECEIVED 
	. H 1 ; GIVE OTHERS A CHANCE 
	F  S C0CBCUR=$O(@C0CBS@(C0CBCUR)) Q:(C0CSTOP)!(C0CBCUR="")  D  ; SUBS LIST
	. I $D(@C0CBH@(C0CBCUR)) Q  ; SKIP IF IN HOT LIST - ALREADY DONE
	. D ANALYZE^C0CRIMA(C0CBCUR,1,"LABLIMIT:T-760^VITLIMIT:T-760")
	. I $G(C0CCHK) D  ; IF CHECKSUMS HAVE CHANGED
	. . D PUTRIM^C0CFM2(C0CBCUR)
	. . D XPAT^C0CCCR(C0CBCUR) ; IF VARIABLES HAVE CHANGED GENERATE CCR
	. . K C0CFDA
	. . S C0CFDA(C0CBFR,"+1,"_C0CIEN_",",.01)=C0CBCUR
	. . S C0CFDA(C0CBFR,"+1,"_C0CIEN_",",1)="Y"
	. . S C0CFDA(C0CBFR,"+1,"_C0CIEN_",",2)=$G(^TMP("C0CCCR","FNAME",C0CBCUR))
	. . D UPDIE ; CREATE UPDATE SUBFILE 
	. S C0CN=C0CN+1 ; INCREMENT NUMBER IN TOTAL
	. S C0CFDA(C0CBF,C0CIEN_",",1.1)=C0CN ;UPDATE TOTAL PROGRESS
	. S C0CNOW=$$NOW^XLFDT
	. S C0CFDA(C0CBF,C0CIEN_",",4)=C0CNOW ; LAST UPDATED FIELD
	. S C0CELPS=$$FMDIFF^XLFDT(C0CNOW,C0CBDT,2) ; DIFFERENCE IN SECONDS
	. S C0CAVG=C0CELPS/C0CN ; AVERAGE ELAPSED TIME
	. S C0CFDA(C0CBF,C0CIEN_",",4.1)=C0CAVG ; AVERAGE ELAPSED TIME
	. S C0CETOT=C0CAVG*C0CSN ; EST TOT ELASPSED TIME 
	. S C0CEST=$$FMADD^XLFDT(C0CBDT,0,0,0,C0CETOT) ; ADD SECONDS TO BATCH START
	. S C0CFDA(C0CBF,C0CIEN_",",4.2)=C0CEST ;ESTIMATED COMPLETION TIME
	. S C0CFDA(C0CBF,C0CIEN_",",5)=C0CBCUR ; 
	. D UPDIE ; 
	. I $D(^TMP("C0CBAT","STOP")) D  ; IF STOP SIGNAL DETECTED
	. . S C0CSTOP=1
	. . K ^TMP("C0CBAT","STOP") ; SIGNAL RECEIVED 
	. H 1 ; GIVE IT A BREAK
	I (C0CSTOP) S C0CDISP="KILLED"
	E  S C0CDISP="FINISHED"
	S C0CFDA(C0CBF,C0CIEN_",",6)=C0CDISP
	D UPDIE ; SET DISPOSITION FIELD
	K ^TMP("C0CBAT","RUNNING")
	Q
	;
BLDHOT(ZHB)	; BUILD HOT LIST AT GLOBAL ZHB, PASSED BY NAME
	; SEARCHS FOR PATIENTS IN THE "AC" INDEX OF THE ORDER FILE
	N ZDFN
	S ZDFN=""
	F  S ZDFN=$O(^OR(100,"AC",ZDFN)) Q:ZDFN=""  D  ; ALL PATIENTS IN THE AC INDX
	. S ZZDFN=$P(ZDFN,";",1) ; FORMAT IS "N;DPT("
	. I '$D(@C0CBS@(ZZDFN)) Q  ; SKIP IF NOT IN SUBSCRIPTION LIST
	. S @ZHB@(ZZDFN)="" ;ADD PATIENT TO THE HOT LIST
	Q
	;
COUNT(ZB)	; EXTRINSIC THAT RETURNS THE NUMBER OF ARRAY ELEMENTS
	N ZI,ZN
	S ZN=0
	S ZI=""
	F  S ZI=$O(@ZB@(ZI)) Q:ZI=""  D  ;
	. S ZN=ZN+1
	Q ZN
	;
UVARPTR(ZVAR,ZTYP)	;EXTRINSIC WHICH RETURNS THE POINTER TO ZVAR IN THE
	; CCR DICTIONARY. IT IS LAYGO, AS IT WILL ADD THE VARIABLE TO
	; THE CCR DICTIONARY IF IT IS NOT THERE. ZTYP IS REQUIRED FOR LAYGO
	;
	N ZCCRD,ZVARN,C0CFDA2
	S ZCCRD=170 ; FILE NUMBER FOR CCR DICTIONARY
	S ZVARN=$O(^C0CDIC(170,"B",ZVAR,"")) ;FIND IEN OF VARIABLE
	I ZVARN="" D  ; VARIABLE NOT IN CCR DICTIONARY - ADD IT
	. I '$D(ZTYP) D  Q  ; WON'T ADD A VARIABLE WITHOUT A TYPE
	. . W "CANNOT ADD VARIABLE WITHOUT A TYPE: ",ZVAR,!
	. S C0CFDA2(ZCCRD,"?+1,",.01)=ZVAR ; NAME OF NEW VARIABLE
	. S C0CFDA2(ZCCRD,"?+1,",12)=ZTYP ; TYPE EXTERNAL OF NEW VARIABLE
	. D CLEAN^DILF ;MAKE SURE ERRORS ARE CLEAN
	. D UPDATE^DIE("E","C0CFDA2","","ZERR") ;ADD VAR TO CCR DICTIONARY
	. I $D(ZERR) D  ; LAYGO ERROR
	. . W "ERROR ADDING "_ZC0CI_" TO CCR DICTIONARY",!
	. E  D  ;
	. . D CLEAN^DILF ; CLEAN UP
	. . S ZVARN=$O(^C0CDIC(170,"B",ZVAR,"")) ;FIND IEN OF VARIABLE
	. . W "ADDED ",ZVAR," TO CCR DICTIONARY, IEN:",ZVARN,!
	Q ZVARN
	;
UPDIE	; INTERNAL ROUTINE TO CALL UPDATE^DIE AND CHECK FOR ERRORS
	K ZERR
	D CLEAN^DILF
	D UPDATE^DIE("","C0CFDA","","ZERR")
	I $D(ZERR) S $EC=",U1,"
	K C0CFDA
	Q
	;
SETFDA(C0CSN,C0CSV)	; INTERNAL ROUTINE TO MAKE AN FDA ENTRY FOR FIELD C0CSN
	; TO SET TO VALUE C0CSV.
	; C0CFDA,C0CC,C0CZX ARE ASSUMED FROM THE CALLING ROUTINE
	; C0CSN,C0CSV ARE PASSED BY VALUE
	;
	N C0CSI,C0CSJ
	S C0CSI=$$ZFILE(C0CSN,"C0CC") ; FILE NUMBER
	S C0CSJ=$$ZFIELD(C0CSN,"C0CC") ; FIELD NUMBER
	S C0CFDA(C0CSI,C0CZX_",",C0CSJ)=C0CSV
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
