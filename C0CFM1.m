C0CFM1	  ; CCDCCR/GPL - CCR FILEMAN utilities; 12/6/08
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
	W "This is the CCR FILEMAN Utility Library ",!
	W !
	Q
	;
PUTRIM(DFN,ZWHICH)	;DFN IS PATIENT , WHICH IS ELEMENT TYPE
	;
	S C0CGLB=$NA(^TMP("GPLRIM","VARS",DFN))
	I '$D(ZWHICH) S ZWHICH="ALL"
	I ZWHICH'="ALL" D  ; SINGLE SECTION REQUESTED
	. S C0CVARS=$NA(@C0CGLB@(ZWHICH))
	. D PUTRIM1(DFN,ZWHICH,C0CVARS) ; IF ONE SECTION
	E  D  ; MULTIPLE SECTIONS
	. S C0CVARS=$NA(@C0CGLB)
	. S C0CI=""
	. F  S C0CI=$O(@C0CVARS@(C0CI)) Q:C0CI=""  D  ;FOR EACH SECTION
	. . S C0CVARSN=$NA(@C0CVARS@(C0CI)) ; GRAB ONE SECTION
	. . D PUTRIM1(DFN,C0CI,C0CVARSN)
	Q
	;
PUTRIM1(DFN,ZZTYP,ZVARS)	; PUT ONE SECTION OF VARIABLES INTO CCR ELEMENTS
	; ZVARS IS PASSED BY NAME AN HAS THE FORM @ZVARS@(1,"VAR1")="VAL1"
	S C0CX=0
	F  S C0CX=$O(@ZVARS@(C0CX)) Q:C0CX=""  D  ; FOR EACH OCCURANCE
	. W "ZOCC=",C0CX,!
	. S C0CV=$NA(@ZVARS@(C0CX)) ; VARIABLES FOR THIS OCCURANCE
	. D PUTELS(DFN,ZZTYP,C0CX,C0CV) ; PUT THEM TO THE CCR ELEMENTS FILE
	Q
	;
PUTELS(DFN,ZTYPE,ZOCC,ZVALS)	; PUT CCR VALUES INTO THE CCR ELEMENTS FILE
	; ^C0C(171.201,   DFN IS THE PATIENT IEN PASSED BY VALUE
	; ZTYPE IS THE NODE TYPE IE RESULTS,PROBLEMS PASSED BY VALUE
	; ZOCC IS THE OCCURANCE NUMBER IE PROBLEM NUMBER 1,2,3 ETC
	; ZVALS ARE THE VARIABLES AND VALUES PASSED BY NAME AND IN THE FORM
	; @ZVALS@("VAR1")="VALUE1" FOR ALL VARIABLES IN THIS ELEMENT
	; AND @ZVALS@("M",SUBOCCUR,"VAR2")="VALUE2" FOR SUB VARIABLES
	;
	S ZSRC=1 ; CCR SOURCE IS ASSUMED TO BE THIS EHR, WHICH IS ALWAYS SOURCE 1
	; PUT THIS IN PARAMETERS - SO SOURCE NUMBER FOR PROCESSING IN CONFIGURABLE
	N ZF,ZFV S ZF=171.201 S ZFV=171.2012
	S ZSUBF=171.20122 ;FILE AND SUBFILE NUMBERS
	N ZSFV S ZSFV=171.201221 ; SUBFILE VARIABLE FILE NUMBER
	N ZTYPN S ZTYPN=$O(^C0CDIC(170.101,"B",ZTYPE,""))
	W "ZTYPE: ",ZTYPE," ",ZTYPN,!
	N ZVARN ; IEN OF VARIABLE BEING PROCESSED
	;N C0CFDA ; FDA FOR CCR ELEMENT UPDATE
	S C0CFDA(ZF,"?+1,",.01)=DFN
	S C0CFDA(ZF,"?+1,",.02)=ZSRC
	S C0CFDA(ZF,"?+1,",.03)=ZTYPN
	S C0CFDA(ZF,"?+1,",.04)=ZOCC ;CREATE OCCURANCE
	K ZERR
	D UPDATE^DIE("","C0CFDA","","ZERR") ;ASSIGN RECORD NUMBER
	I $D(ZERR) S $EC=",U1,"
	K C0CFDA
	S ZD0=$O(^C0C(ZF,"C",DFN,ZSRC,ZTYPN,ZOCC,""))
	W "RECORD NUMBER: ",ZD0,!
	;B
	S ZCNT=0
	S ZC0CI="" ;
	F  S ZC0CI=$O(@ZVALS@(ZC0CI)) Q:ZC0CI=""  D  ;
	. I ZC0CI'="M" D  ; NOT A SUBVARIABLE
	. . S ZCNT=ZCNT+1 ;INCREMENT COUNT
	. . S ZVARN=$$VARPTR(ZC0CI,ZTYPE) ;GET THE POINTER TO THE VAR IN THE CCR DICT
	. . ; WILL ALLOW FOR LAYGO IF THE VARIABLE IS NOT FOUND
	. . S C0CFDA(ZFV,"?+"_ZCNT_","_ZD0_",",.01)=ZVARN
	. . S C0CFDA(ZFV,"?+"_ZCNT_","_ZD0_",",1)=@ZVALS@(ZC0CI)
	. . ;S C0CFDA(ZSFV,"+1,"_DFN_","_ZSRC_","_ZTYPN_","_ZOCC_",",.01)=ZVARN
	. . ;S C0CFDA(ZSFV,"+1,"_DFN_","_ZSRC_","_ZTYPN_","_ZOCC_",",1)=@ZVALS@(ZC0CI)
	;S GT1(170,"?+1,",.01)="ZZZ NEW MEDVEHICLETEXT"
	;S GT1(170,"?+1,",12)="DIR"
	;S GT1(171.201221,"?+1,1,5,1,",.01)="ZZZ NEW MEDVEHICLETEXT"
	;S GT1(171.201221,"+1,1,5,1,",1)="THIRD NEW MED DIRECTION TEXT"
	D CLEAN^DILF
	D UPDATE^DIE("","C0CFDA","","ZERR")
	Q
	;
VARPTR(ZVAR,ZTYP)	;EXTRINSIC WHICH RETURNS THE POINTER TO ZVAR IN THE
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
BLDTYPS	; ROUTINE TO POPULATE THE CCR NODE TYPES FILE (^C0CDIC(170.101,)
	; THE CCR DICTIONARY (^C0CDIC(170, ) HAS MOST OF WHAT'S NEEDED
	;
	N C0CDIC,C0CNODE ;
	S C0CDIC=$$FILEREF^C0CRNF(170) ; CLOSED FILE REFERENCE TO THE CCR DICTIONARY
	S C0CNODE=$$FILEREF^C0CRNF(170.101) ; CLOSED REF TO CCR NODE TYPE FILE
	Q
	;
FIXSEC	;FIX THE SECTION FIELD OF THE CCR DICTIONARY.. IT HAS BEEN REDEFINED
	; AS A POINTER TO CCR NODE TYPE INSTEAD OF BEING A SET
	; THE SET VALUES ARE PRESERVED IN ^KBAI("SECTION") TO FACILITATE THIS
	; CONVERSION
	;N C0CC,C0CI,C0CJ,C0CN,C0CZX
	D FIELDS^C0CRNF("C0CC",170)
	S C0CI=""
	F  S C0CI=$O(^KBAI("SECTION",C0CI)) Q:C0CI=""  D  ; EACH SECTION
	. S C0CZX=""
	. F  S C0CZX=$O(^KBAI("SECTION",C0CI,C0CZX)) Q:C0CZX=""  D  ; EACH VARIABLE
	. . W "SECTION ",C0CI," VAR ",C0CZX
	. . S C0CV=$O(^C0CDIC(170.101,"B",C0CI,""))
	. . W " TYPE: ",C0CV,!
	. . D SETFDA("SECTION",C0CV)
	. . ;ZWR C0CFDA
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