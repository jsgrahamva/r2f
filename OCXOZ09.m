OCXOZ09	;SLC/RJS,CLA - Order Check Scan ;AUG 4,2015 at 21:54
	;;3.0;ORDER ENTRY/RESULTS REPORTING;**32,221,243**;Dec 17,1997;Build 242
	;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
	;
	; ***************************************************************
	; ** Warning: This routine is automatically generated by the   **
	; ** Rule Compiler (^OCXOCMP) and ANY changes to this routine  **
	; ** will be lost the next time the rule compiler executes.    **
	; ***************************************************************
	;
	Q
	;
CHK188	; Look through the current environment for valid Event/Elements for this patient.
	;  Called from CHK58+19^OCXOZ05.
	;
	Q:$G(OCXOERR)
	;
	;    Local CHK188 Variables
	; OCXDF(2) ----> Data Field: FILLER (FREE TEXT)
	; OCXDF(40) ---> Data Field: ORDER MODE (FREE TEXT)
	; OCXDF(47) ---> Data Field: OI LOCAL TEXT (FREE TEXT)
	;
	;      Local Extrinsic Functions
	; CLIST( -----------> STRING CONTAINS ONE OF A LIST OF VALUES
	; EQTERM( ----------> EQUALS TERM OPERATOR
	;
	I $$EQTERM(OCXDF(47),"ANGIOGRAM (PERIPHERAL)") S OCXDF(40)=$G(OCXPSM) I $L(OCXDF(40)),(OCXDF(40)="SESSION") D CHK192
	I $$CLIST(OCXDF(47),"GLUCOPHAGE,METFORMIN") S OCXDF(40)=$G(OCXPSM) I $L(OCXDF(40)),(OCXDF(40)="SELECT") S OCXDF(2)=$P($G(OCXPSD),"|",2) I $L(OCXDF(2)) D CHK280^OCXOZ0B
	Q
	;
CHK192	; Look through the current environment for valid Event/Elements for this patient.
	;  Called from CHK188+14.
	;
	Q:$G(OCXOERR)
	;
	;    Local CHK192 Variables
	; OCXDF(68) ---> Data Field: MISSING ANGIOGRAM, CATH PERIF LAB TESTS (FREE TEXT)
	;
	;      Local Extrinsic Functions
	; FILE(DFN,65, -----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: SESSION ORDER FOR ANGIOGRAM)
	; MTSTF( -----------> MISSING TESTS DURING SESSION
	;
	S OCXDF(68)=$$MTSTF("PROTHROMBIN TIME,PARTIAL THROMBOPLASTIN TIME") I $L(OCXDF(68)),($L(OCXDF(68))>0) S OCXOERR=$$FILE(DFN,65,"68") Q:OCXOERR 
	Q
	;
CHK196	; Look through the current environment for valid Event/Elements for this patient.
	;  Called from CHK163+19^OCXOZ07.
	;
	Q:$G(OCXOERR)
	;
	;    Local CHK196 Variables
	; OCXDF(2) ----> Data Field: FILLER (FREE TEXT)
	; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
	; OCXDF(67) ---> Data Field: CONTRAST MEDIA CODE (FREE TEXT)
	; OCXDF(73) ---> Data Field: ORDERABLE ITEM IEN (NUMERIC)
	;
	;      Local Extrinsic Functions
	; CLIST( -----------> STRING CONTAINS ONE OF A LIST OF VALUES
	;
	S OCXDF(2)=$P($G(OCXPSD),"|",2) I $L(OCXDF(2)) D CHK198
	S OCXDF(73)=$P($G(OCXPSD),"|",1) I $L(OCXDF(73)) S OCXDF(67)=$$CM^ORQQRA(OCXDF(73)) I $L(OCXDF(67)),$$CLIST(OCXDF(67),"M,I,N") S OCXDF(37)=$G(DFN) I $L(OCXDF(37)) D CHK458^OCXOZ0E
	Q
	;
CHK198	; Look through the current environment for valid Event/Elements for this patient.
	;  Called from CHK196+14.
	;
	Q:$G(OCXOERR)
	;
	;    Local CHK198 Variables
	; OCXDF(2) ----> Data Field: FILLER (FREE TEXT)
	;
	I (OCXDF(2)="RA") D CHK199
	I ($E(OCXDF(2),1,2)="PS") D CHK360^OCXOZ0C
	Q
	;
CHK199	; Look through the current environment for valid Event/Elements for this patient.
	;  Called from CHK198+8.
	;
	Q:$G(OCXOERR)
	;
	;    Local CHK199 Variables
	; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
	; OCXDF(73) ---> Data Field: ORDERABLE ITEM IEN (NUMERIC)
	;
	S OCXDF(37)=$G(DFN) I $L(OCXDF(37)) D CHK201
	S OCXDF(73)=$P($G(OCXPSD),"|",1) I $L(OCXDF(73)) D CHK236^OCXOZ0A
	Q
	;
CHK201	; Look through the current environment for valid Event/Elements for this patient.
	;  Called from CHK199+9.
	;
	Q:$G(OCXOERR)
	;
	;    Local CHK201 Variables
	; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
	; OCXDF(65) ---> Data Field: CONTRAST MEDIA ALLERGY FLAG (BOOLEAN)
	; OCXDF(67) ---> Data Field: CONTRAST MEDIA CODE (FREE TEXT)
	; OCXDF(69) ---> Data Field: RECENT BARIUM STUDY FLAG (BOOLEAN)
	; OCXDF(73) ---> Data Field: ORDERABLE ITEM IEN (NUMERIC)
	;
	;      Local Extrinsic Functions
	; RECBAR( ----------> RECENT BARIUM STUDY
	;
	S OCXDF(65)=$$ORCHK^GMRAOR(OCXDF(37),"CM","") I $L(OCXDF(65)),(OCXDF(65)) S OCXDF(73)=$P($G(OCXPSD),"|",1) I $L(OCXDF(73)) S OCXDF(67)=$$CM^ORQQRA(OCXDF(73)) D CHK207
	S OCXDF(69)=$P($$RECBAR(OCXDF(37),48),"^",1) I $L(OCXDF(69)),(OCXDF(69)) S OCXDF(73)=$P($G(OCXPSD),"|",1) I $L(OCXDF(73)) S OCXDF(67)=$$CM^ORQQRA(OCXDF(73)) D CHK217
	Q
	;
CHK207	; Look through the current environment for valid Event/Elements for this patient.
	;  Called from CHK201+15.
	;
	Q:$G(OCXOERR)
	;
	;    Local CHK207 Variables
	; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
	; OCXDF(66) ---> Data Field: CONTRAST MEDIA CODE TRANSLATION (FREE TEXT)
	; OCXDF(67) ---> Data Field: CONTRAST MEDIA CODE (FREE TEXT)
	; OCXDF(159) --> Data Field: ALLERGY CONTRAST MEDIA LOCATION (FREE TEXT)
	;
	;      Local Extrinsic Functions
	; CLIST( -----------> STRING CONTAINS ONE OF A LIST OF VALUES
	; CONTRANS( --------> CONTRAST MEDIA CODE TRANSLATION
	;
	I $L(OCXDF(67)),$$CLIST(OCXDF(67),"M,I,N,L,C,G,B") S OCXDF(66)=$$CONTRANS(OCXDF(67)),OCXDF(159)=$P($$ORCHK^GMRAOR(OCXDF(37),"CM","",1),"^",2) D CHK211
	Q
	;
CHK211	; Look through the current environment for valid Event/Elements for this patient.
	;  Called from CHK207+15.
	;
	Q:$G(OCXOERR)
	;
	;      Local Extrinsic Functions
	; FILE(DFN,66, -----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: CONTRAST MEDIA ALLERGY)
	;
	S OCXOERR=$$FILE(DFN,66,"66,159") Q:OCXOERR 
	Q
	;
CHK217	; Look through the current environment for valid Event/Elements for this patient.
	;  Called from CHK201+16.
	;
	Q:$G(OCXOERR)
	;
	;    Local CHK217 Variables
	; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
	; OCXDF(67) ---> Data Field: CONTRAST MEDIA CODE (FREE TEXT)
	; OCXDF(70) ---> Data Field: RECENT BARIUM STUDY TEXT (FREE TEXT)
	; OCXDF(121) --> Data Field: RECENT BARIUM STUDY ORDER STATUS (FREE TEXT)
	;
	;      Local Extrinsic Functions
	; FILE(DFN,67, -----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: RECENT BARIUM STUDY ORDERED)
	; RECBAR( ----------> RECENT BARIUM STUDY
	; RECBARST( --------> RECENT BARIUM ORDER STATUS
	;
	I $L(OCXDF(67)),(OCXDF(67)["B") S OCXDF(70)=$P($$RECBAR(OCXDF(37),48),"^",3),OCXDF(121)=$P($$RECBARST(OCXDF(37),48),"^",2),OCXOERR=$$FILE(DFN,67,"70,121") Q:OCXOERR 
	Q
	;
CLIST(DATA,LIST)	;   DOES THE DATA FIELD CONTAIN AN ELEMENT IN THE LIST
	;
	N PC F PC=1:1:$L(LIST,","),0 I PC,$L($P(LIST,",",PC)),(DATA[$P(LIST,",",PC)) Q
	Q ''PC
	;
CONTRANS(OCXC)	;  Compiler Function: CONTRAST MEDIA CODE TRANSLATION
	;
	N OCXX
	Q:'$L($G(OCXC)) "" S OCXX=$S((OCXC["B"):"Barium",1:"")
	I (OCXC["G") S:$L(OCXX) OCXX=OCXX_" and/or " S OCXX=OCXX_"Gastrografin"
	I (OCXC["I") S:$L(OCXX) OCXX=OCXX_" and/or " S OCXX=OCXX_"Ionic Iodinated"
	I (OCXC["N") S:$L(OCXX) OCXX=OCXX_" and/or " S OCXX=OCXX_"Non-ionic Iodinated"
	I (OCXC["L") S:$L(OCXX) OCXX=OCXX_" and/or " S OCXX=OCXX_"Gadolinium"
	I (OCXC["C") S:$L(OCXX) OCXX=OCXX_" and/or " S OCXX=OCXX_"Cholecystographic"
	I (OCXC["M") S:$L(OCXX) OCXX=OCXX_" and/or " S OCXX=OCXX_"Unspecified contrast media"
	Q OCXX
	;
EQTERM(DATA,TERM)	;  Compiler Function: EQUALS TERM OPERATOR
	;
	N OCXF,OCXL
	;
	S OCXL="",OCXF=$$TERMLKUP(TERM,.OCXL)
	Q:'OCXF 0
	I ($D(OCXL(DATA))!$D(OCXL("B",DATA))) Q 1
	Q 0
	;
FILE(DFN,OCXELE,OCXDFL)	;     This Local Extrinsic Function logs a validated event/element.
	;
	N OCXTIMN,OCXTIML,OCXTIMT1,OCXTIMT2,OCXDATA,OCXPC,OCXPC,OCXVAL,OCXSUB,OCXDFI
	S DFN=+$G(DFN),OCXELE=+$G(OCXELE)
	;
	Q:'DFN 1 Q:'OCXELE 1 K OCXDATA
	;
	S OCXDATA(DFN,OCXELE)=1
	F OCXPC=1:1:$L(OCXDFL,",") S OCXDFI=$P(OCXDFL,",",OCXPC) I OCXDFI D
	.S OCXVAL=$G(OCXDF(+OCXDFI)),OCXDATA(DFN,OCXELE,+OCXDFI)=OCXVAL
	;
	M ^TMP("OCXCHK",$J,DFN)=OCXDATA(DFN)
	;
	Q 0
	;
MTSTF(OILIST)	;  Compiler Function: MISSING TESTS DURING SESSION
	;
	N OCXPC,OCXOI,OCXOUT S OCXOUT=""
	F OCXPC=1:1:$L(OILIST,",") S OCXOI=$P(OILIST,",",OCXPC) I $L(OCXOI) D
	.N OCXL,OCXF,OCXD0
	.S OCXL="",OCXF=$$TERMLKUP(OCXOI,.OCXL)
	.S OCXD0=0 F  S OCXD0=$O(OCXL(OCXD0)) Q:'OCXD0  Q:$$OISESS^ORKCHK2(+OCXD0)
	.Q:OCXD0
	.S:$L(OCXOUT) OCXOUT=OCXOUT_", " S OCXOUT=OCXOUT_OCXOI
	Q OCXOUT
	;
RECBAR(DFN,HOURS)	;  Compiler Function: RECENT BARIUM STUDY
	;
	Q:'$G(DFN) 0 Q:'$G(HOURS) 0 N OUT S OUT=$$RECENTBA^ORKRA(DFN,HOURS) Q:'$L(OUT) 0 Q 1_U_OUT
	;  
	;
RECBARST(DFN,HOURS)	   ;  Compiler Function: RECENT BARIUM ORDER STATUS
	;
	Q:'$G(DFN) 0 Q:'$G(HOURS) 0
	N ORDER S ORDER=$P($$RECENTBA^ORKRA(DFN,HOURS),U) Q:'$L(ORDER) 0
	N STATUS S STATUS=$P($$STATUS^ORQOR2(ORDER),U,2) Q:'$L(STATUS) 0
	Q 1_U_STATUS
	;
TERMLKUP(OCXTERM,OCXLIST)	;
	Q $$TERM^OCXOZ01(OCXTERM,.OCXLIST)
	;
