C0CDIC	  ; CCDCCR/GPL - CCR Dictionary utilities; 6/1/08
	;;1.2;CCD/CCR GENERATION UTILITIES;;Oct 30, 2012;Build 3
	;Copyright 2008 George Lilly & Sam Habiel.  
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
	W "This is the CCR Dictionary Utility Library ",!
	W !
	Q
	;
DIC2CSV	;OUTPUT THE CCR DICTIONARY TO A CSV FILE
	;
	N ZI
	S ZI=""
	S G1=$NA(^TMP($J,"C0CCSV",1))
	S G1A=$NA(@G1@("V"))
	S G2=$NA(^TMP($J,"C0CCSV",2))
	D GETN2^C0CRNF(G1,170) ; GET THE MATRIX
	F  S ZI=$O(@G1A@(ZI)) Q:ZI=""  D  ;FOR EACH ROW IN THE MATRIX
	. I $G(@G1A@(ZI,"MAPPING METHOD",1))'="" D  ;
	. . W @G1A@(ZI,"MAPPING METHOD",1),!
	. . ;K @G1A@(ZI,"MAPPING METHOD")
	. ;W !,ZI,$G(@G1A@(ZI,"MAPPING METHOD",1))
	D RNF2CSV^C0CRNF(G2,G1,"VN") ; PREPARE THE CVS FILE
	K @G1
	D FILEOUT^C0CRNF(G2,"FILE_"_170_".csv")
	K @G2
	Q
	;
GVARS(C0CVARS,C0CT)	; Get the CCR variables from the CCR template
	; and return them in C0CVARS, which is passed by name
	; FIRST PIECE OF C0CVARS(x) IS THE VARIABLE NAME, SECOND PIECE
	; IS THE LINE NUMBER OF THE VARIABLE IN THE TEMPLATE
	; C0CT IS RETURNED AS THE CCR TEMPLATE
	N C0CTVARS ; ARRAY FOR THE TEMPLATE AND ARRAY FOR THE VARS
	D LOAD^GPLCCR0(C0CT) ; LOAD THE CCR TEMPLATE
	D XVARS^GPLXPATH("C0CTVARS",C0CT) ; PULL OUT THE VARS
	N C0CI,C0CX
	S @C0CVARS@(0)=C0CTVARS(0) ; SAME COUNT
	F C0CI=1:1:C0CTVARS(0) D  ; FOR EVERY LINE IN THE ARRAY
	. S C0CX=C0CTVARS(C0CI) ; THE VARIABLE - 3 PIECES, FIRST ONE NULL
	. S @C0CVARS@(C0CI)=$P(C0CX,"^",2)_"^"_$P(C0CX,"^",3) ; VAR NAME^LINE NUMBER
	;D PARY^GPLXPATH("C0CVARS")
	Q
	;
GXPATH(C0CPVARS,C0CPT)	; LOAD THE CCR TEMPLATE INTO C0CPT, PULL OUT VARIABLES
	; AND THE XPATH TO THE VARIABLES INTO C0CPVARS
	; BY INDEXING THE TEMPLATE C0CT AND MATCHING THE XPATH TO THE VARIABLE
	; BOTH ARE PASSED BY NAME
	; C0CPVARS(x) IS VAR^LINENUM^XPATH SORTED BY LINENUM
	; C0CPVARS(0) IS NUMBER OF VARIABLES
	; C0CPT(0) IS NUMBER OF LINES IN THE TEMPLATE
	D GVARS(C0CPVARS,C0CPT) ; GET THE VARIABLES AND LINE NUMBERS
	;N C0CTVARS ; HASH TABLE FOR VARIABLE BY LINE NUMBER
	D HASHV ; PUT THE VARIABLES IN A LINE NUMBER HASH FOR MATCHING TO XPATHS
	; NOW GO GET THE XPATH INDEXES
	D INDEX^GPLXPATH(C0CPT) ; ADD THE XPATH INDEXES TO THE TEMPLATE ARRAY
	S C0CI="" ; GOING TO LOOP THROUGH THE WHOLE ARRAY LOOKING AT XPATHS
	F  S C0CI=$O(@C0CPT@(C0CI)) Q:C0CI=""  D  ; VISIT EVERY LINE
	. I +C0CI'=0 Q  ; SKIP EVERYTHING BUT THE XPATH INDEX
	. I C0CI=0 Q  ; SKIP THE ZERO NODE
	. S C0CX=@C0CPT@(C0CI) ; PULL OUT THE LINE NUMBERS X^Y
	. S C0CY=$P(C0CX,"^",1) ; STARTING LINE NUMBER
	. S C0CZ=$P(C0CX,"^",2) ; ENDING LINE NUMBER
	. I C0CY=C0CZ D  ; THIS IS AN XPATH END NODE, HAS A VARIABLE (WE HOPE)
	. . ; W "FOUND ",C0CI,!
	. . I $D(C0CTVARS(C0CY)) D  ; IF THERE IS A VARIABLE THERE
	. . . S $P(C0CTVARS(C0CY),"^",3)=C0CI ; INSERT THE XPATH FOR THE VAR
	D SORTV ; SORT THE ARRAY BY LINE NUMBER
	Q
	;
HASHV	; INTERNAL ROUTINE TO PUT VARIABLE NAMES IN A LINE NUMBER HASH
	;N C0CI,C0CTVARS,C0CX,C0CY
	F C0CI=1:1:@C0CPVARS@(0) D  ; FOR THE ENTIRE ARRAY
	. S C0CX=$P(@C0CPVARS@(C0CI),"^",2) ; LINE NUMBER
	. S C0CY=$P(@C0CPVARS@(C0CI),"^",1) ; VARIABLE NAME
	. S C0CTVARS(C0CX)=C0CY ; BUILD HASH OF VARIABLES BY LINE NUMBER
	Q
	;
SORTV	; INTERNAL ROUTINE TO OUTPUT VARIABLES (AND XPATHS) IN LINE NUMBER ORDER
	;N C0CV2 ; SCRACTH SPACE FOR BUILDING SORTED ARRAY
	S C0CI="" ;
	F  S C0CI=$O(C0CTVARS(C0CI)) Q:C0CI=""  D  ; BY LINE NUMBER
	. S C0CX=C0CTVARS(C0CI) ;VARIABLE NAME
	. S $P(C0CX,"^",2)=C0CI ; LINE NUMBER IS SECOND PIECE
	. D PUSH^GPLXPATH("C0C2",C0CX) ; PUT ONTO ARRAY
	K @C0CPVARS
	M @C0CPVARS=C0C2
	Q
	;
LOAD	; LOAD VARIABLE NAMES AND XPATH IN ^C0CDIC(170
	; INITIAL LOAD OF THE CCR DICTIONARY
	;
	N C0CDIC,C0CARY,C0CXML,C0CFDA,C0CI
	S C0CDIC="^C0CDIC(170," ; ROOT OF THE CCR DICTIONARY
	D GXPATH("C0CARY","C0CXML") ; FETCH THE VARIABLES AND XPATH INTO C0CARY
	; C0CXML WILL CONTAIN THE TEMPLATE - NOT NEEDED FOR LOAD
	D PARY^GPLXPATH("C0CARY") ;TEST
	F C0CI=1:1:C0CARY(0) D  ; LOAD EACH VARIABLE
	. S C0CFDA(170,"+"_C0CI_",",.01)=$P(C0CARY(C0CI),"^",1) ; VAR NAME
	. S C0CFDA(170,"+"_C0CI_",",2)=$P(C0CARY(C0CI),"^",3) ; XPATH
	. D UPDATE^DIE("","C0CFDA")
	. I $D(^TMP("DIERR",$J)) U $P BREAK
	. W "LOADING:",C0CI," ",C0CARY(C0CI),!
	Q
	;
INIT	; INITIALIZE CCR DICTIONARY BASED ON VARIABLE NAMES
	;
	; CHEAT SHEET FOR VARIABLE NAMES IN ^C0CDIC(170.xx,
	; THIS IS WHAT WILL BE IN C0CA FOR EACH DICTIONARY ENTRY
	;G1("CODING")="170^8"
	;G1("DATA ELEMENT")="170^7"
	;G1("DESCRIPTION")="170^3"
	;G1("ID")="170^1"
	;G1("M","170^8","CODING")="170.08^.01"
	;G1("MAPPING METHOD")="170.08^1"
	;G1("SECTION")="170^10"
	;G1("SOURCE")="170^4"
	;G1("STATUS")="170^9"
	;G1("TYPE")="170^6"
	;G1("VARIABLE")="170^.01"
	;G1("XPATH")="170^2"
	;
	N C0CZA,C0CZX,C0CN,C0CSTAT
	S C0CZX=0
	S C0CSTAT=0 ; INIT STATUS SET FLAG
	F  S C0CZX=$O(^C0CDIC(170,C0CZX)) Q:+C0CZX=0  D  ; FOR EACH DICT ENTRY
	. ;W C0CZX,!
	. K C0CA,C0CN ; CLEAR OUT THE LAST ONE
	. D GETN1^C0CRNF("C0CA",170,C0CZX,"","ALL") ; GET VARIABLE HASH
	. ;ZWR C0CA B ;
	. S C0CN=$$ZVALUE("VARIABLE") ;NAME OF THE VARIABLE
	. W "VARIABLE: ",C0CN,!
	. I $E(C0CN,1,5)="ACTOR" D SETFDA("SECTION","ACTORS") ;
	. I $E(C0CN,1,6)="SOCIAL" D  ;
	. . D SETFDA("SECTION","SOC") ;
	. . D SETFDA("STATUS","X") ;SOCIAL HISTORY NOT IMPLEMENTED
	. . S C0CSTAT=1
	. I $E(C0CN,1,6)="FAMILY" D  ;
	. . D SETFDA("SECTION","FAM") ;
	. . D SETFDA("STATUS","X") ;FAMILY HISTORY NOT IMPLEMENTED
	. . S C0CSTAT=1
	. ;D SETFDA("TYPE","") ;CORRECT FOR TYPE ERRORS
	. I $E(C0CN,1,5)="ALERT" D SETFDA("SECTION","ALERTS")
	. I $E(C0CN,1,5)="VITAL" D SETFDA("SECTION","VITALS")
	. I $E(C0CN,1,7)="PROBLEM" D SETFDA("SECTION","PROBLEMS")
	. I $E(C0CN,1,10)="RESULTTEST" D SETFDA("SECTION","TEST")
	. E  I $E(C0CN,1,6)="RESULT" D SETFDA("SECTION","LABS")
	. I C0CN["CODEVALUE" D SETFDA("TYPE","CD") ;CODES
	. I C0CN["CODEVERSION" D SETFDA("TYPE","CV") ; CODE VERSION
	. I C0CN["CODINGSYSTEM" D SETFDA("TYPE","CS") ;CODING SYSTEM
	. I $$ZVALUE("STATUS")=""!'C0CSTAT D SETFDA("STATUS","N") ;BLANK STATUS TO N
	. I $$ZVALUE("XPATH")["/Medication/Directions/" D  ; MEDS DIRECTIONS VAR
	. . D SETFDA("SECTION","DIR") ; SPECIAL SECTION FOR DIRECTIONS
	. E  I $$ZVALUE("XPATH")["/Medications/Medication/" D  ; ALL OTHER MEDS
	. . D SETFDA("SECTION","MEDS") ; A MEDS VAR
	. I $E(C0CN,($L(C0CN)-1),$L(C0CN))="ID" D SETFDA("TYPE","ID") ;CATCH THE IDS
	. I C0CN["DATETIME" D SETFDA("TYPE","DT") ; DATE/TIME VARIABLE
	. W "VARIABLE: ",C0CZX," ",C0CA("VARIABLE"),!
	. ;ZWR C0CFDA
	. I $D(C0CFDA) D  ; WE HAVE CHANGES ON THIS VARIABLE
	. . ;ZWR C0CFDA
	. . D UPDATE^DIE("","C0CFDA(C0CZX)")
	. . I $D(^TMP("DIERR",$J)) U $P BREAK
	. . D CLEAN^DILF ; CLEAN UP
	. ;ZWR C0CFDA
	Q
	;
SETFDA(C0CSN,C0CSV)	; INTERNAL ROUTINE TO MAKE AN FDA ENTRY FOR FIELD C0CSN
	; TO SET TO VALUE C0CSV.
	; C0CFDA,C0CA,C0CZX ARE ASSUMED FROM THE CALLING ROUTINE
	; C0CSN,C0CSV ARE PASSED BY VALUE
	;
	N C0CSI,C0CSJ
	S C0CSI=$$ZFILE(C0CSN,"C0CA") ; FILE NUMBER
	S C0CSJ=$$ZFIELD(C0CSN,"C0CA") ; FIELD NUMBER
	S C0CFDA(C0CZX,C0CSI,C0CZX_",",C0CSJ)=C0CSV
	Q
ZFILE(ZFN,ZTAB)	; EXTRINSIC TO RETURN FILE NUMBER FOR FIELD NAME PASSED
	; BY VALUE IN ZFN. FILE NUMBER IS PIECE 1 OF C0CA(ZFN)
	; IF ZTAB IS NULL, IT DEFAULTS TO C0CA
	I '$D(ZTAB) S ZTAB="C0CA"
	Q $P(@ZTAB@(ZFN),"^",1)
ZFIELD(ZFN,ZTAB)	;EXTRINSIC TO RETURN FIELD NUMBER FOR FIELD NAME PASSED
	; BY VALUE IN ZFN. FILE NUMBER IS PIECE 2 OF C0CA(ZFN)
	; IF ZTAB IS NULL, IT DEFAULTS TO C0CA
	I '$D(ZTAB) S ZTAB="C0CA"
	Q $P(@ZTAB@(ZFN),"^",2)
ZVALUE(ZFN,ZTAB)	;EXTRINSIC TO RETURN VALUE FOR FIELD NAME PASSED
	; BY VALUE IN ZFN. FILE NUMBER IS PIECE 3 OF C0CA(ZFN)
	; IF ZTAB IS NULL, IT DEFAULTS TO C0CA
	I '$D(ZTAB) S ZTAB="C0CA"
	Q $P(@ZTAB@(ZFN),"^",3)
	;
