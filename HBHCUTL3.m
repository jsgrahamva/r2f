HBHCUTL3	;LR VAMC(IRMS)/MJT - HBHC Utility module, Entry points:  PSEUDO, PCEMSG, DX, DX80, CPT, MFHS, MFH, DATE3, DATE6, DATE3L, & DATE6L ;Jan 2000
	;;1.0;HOSPITAL BASED HOME CARE;**6,8,10,15,16,14,24,25**;NOV 01, 1993;Build 45
	;
	; This routine references the following supported ICRs:
	; 5747    $$CODEC^ICDEX
	; 5747    $$VSTD^ICDEX
	; 5679    $$IMPDATE^LEXU
	;
	;******************************************************************************
	;******************************************************************************
	;                       --- ROUTINE MODIFICATION LOG ---
	;        
	;PKG/PATCH    DATE        DEVELOPER    MODIFICATION
	;-----------  ----------  -----------  ----------------------------------------
	;HBH*1.0*25   APR  2012   K GUPTA      Support for ICD-10 Coding System
	;******************************************************************************
	;******************************************************************************
	;
PSEUDO	; Print pseudo SSN message
	W $C(7),!!,"Patient visit records with pseudo social security numbers (SSNs) exist.",!,"Print the 'Pseudo Social Security Number Report' located on the HBHC Reports"
	W !,"Menu to obtain a list of patients with invalid SSNs.  HBHC must determine",!,"what corrective action is appropriate to eliminate these records from the",!,"HBHC Information System.",!! H 5
	Q
PCEMSG	; Print PCE correction of errors message
	W !!,"Note:  Please use Appointment Management to Correct Visit Errors.  Run",!?7,"Edit Form Errors Data option when corrections are complete."
	Q
DX	; Diagnosis (DX) info, HBHCDFN must be defined prior to call, returns code plus text in local array HBHCDX
	N HBHCDXCODE,HBHCDXDESC
	K HBHCDX S $P(HBHCSP8," ",9)="",HBHCI=0
	F  S HBHCI=$O(^HBHC(632,HBHCDFN,3,HBHCI)) Q:HBHCI'>0  D
	. S HBHCICDP=$P(^HBHC(632,HBHCDFN,3,HBHCI,0),U)
	. S HBHCDXCODE=$$CODEC^ICDEX(80,HBHCICDP)
	. S HBHCDXDESC=$$VSTD^ICDEX(HBHCICDP)
	. S HBHCDX(HBHCI)=HBHCDXCODE_$E(HBHCSP8,1,(10-$L(HBHCDXCODE)))_HBHCDXDESC  ;add minimum of 2 spaces between code and desc
	K HBHCI,HBHCICDP
	Q
DX80	; Print DX info in 80 column format, HBHCDX( array must be defined prior to call
	S (HBHCFLG,HBHCI)=0 F  S HBHCI=$O(HBHCDX(HBHCI)) Q:HBHCI'>0  W ! W:HBHCFLG=0 "Diagnosis:   " W:HBHCFLG=1 ?13  W HBHCDX(HBHCI) S HBHCFLG=1
	K HBHCDX,HBHCFLG,HBHCI
	Q
CPT	; CPT code info, HBHCDFN must be defined prior to call, returns code plus text in local array HBHCCPTA
	K HBHCCPTA S $P(HBHCSP3," ",4)="",HBHCI=0 F  S HBHCI=$O(^HBHC(632,HBHCDFN,2,HBHCI)) Q:HBHCI'>0  S HBHCCPT=$$CPT^ICPTCOD(^HBHC(632,HBHCDFN,2,HBHCI,0)),HBHCCPTA(HBHCI)=$P(HBHCCPT,U,2)_HBHCSP3_$P(HBHCCPT,U,3) D CPTMOD
	K HBHCCPT,HBHCI,HBHCJ,HBHCMOD,HBHCSP3
	Q
CPTMOD	; Process CPT Modifier code plus text into local array HBHCCPTA(HBHCCPT,HBHCJ)
	S HBHCJ=0 F  S HBHCJ=$O(^HBHC(632,HBHCDFN,2,HBHCI,1,HBHCJ)) Q:HBHCJ'>0  S HBHCMOD=$$MOD^ICPTMOD($P(^HBHC(632,HBHCDFN,2,HBHCI,1,HBHCJ,0),U),"I"),HBHCCPTA(HBHCI,HBHCJ)=$P(HBHCMOD,U,2)_HBHCSP3_$P(HBHCMOD,U,3)
	Q
MFHS	; Set Medical Foster Home (MFH) Site variable if Sanctioned site
	S:$P($G(^HBHC(631.9,1,0)),U,9)]"" HBHCMFHS=1
	Q
MFH	; Prompt for HBPC or MFH population inclusion on report; set Medical Foster Home Report variable: HBHCMFHR
	K DIR S DIR(0)="SB^H:Home Based Primary Care (HBPC);M:Medical Foster Home (MFH)",DIR("A")="Include HBPC or MFH census",DIR("?")="Include HBPC (H), or MFH (M) population on report" D ^DIR
	S:Y="M" HBHCMFHR=1
	Q
DATE3	; Calc 3 mo date based on month only for use by MFH Inspection or Training e-mail processing
	S HBHCMO=+$E(DT,4,5),HBHCDATE=3_$S(HBHCMO>9:$E(DT,2,3),1:($E(DT,2,3)-1))_$S(HBHCMO=10:"01",HBHCMO=11:"02",HBHCMO=12:"03",HBHCMO=1:"04",HBHCMO=2:"05",HBHCMO=3:"06",HBHCMO=4:"07",HBHCMO=5:"08",HBHCMO=6:"09",1:HBHCMO+3)_"01" D CHECK
	; Following line produces the correct date; keep for testing purposes
	;F HBHCMO=1:1:12 S HBHCDATE=3_$S(HBHCMO>9:$E(DT,2,3),1:($E(DT,2,3)-1))_$S(HBHCMO=10:"01",HBHCMO=11:"02",HBHCMO=12:"03",HBHCMO=1:"04",HBHCMO=2:"05",HBHCMO=3:"06",HBHCMO=4:"07",HBHCMO=5:"08",HBHCMO=6:"09",1:HBHCMO+3)_"01" D CHECK
	Q
DATE6	; Calc 6 mo date based on month only for use by MFH Inspection or Training report processing
	S HBHCMO=+$E(DT,4,5),HBHCDATE=3_$S(HBHCMO>6:$E(DT,2,3),1:($E(DT,2,3)-1))_$S(HBHCMO=7:"01",HBHCMO=8:"02",HBHCMO=9:"03",HBHCMO=10:"04",HBHCMO=11:"05",HBHCMO=12:"06",HBHCMO=1:"07",HBHCMO=2:"08",HBHCMO=3:"09",1:HBHCMO+6)_"01" D CHECK
	Q
DATE3L	; Calc 3 mo date based on month only for use by MFH License Expiration e-mail processing
	S HBHCMO=+$E(DT,4,5),HBHCDATE=3_$S(HBHCMO>9:($E(DT,2,3)+1),1:($E(DT,2,3)))_$S(HBHCMO=10:"01",HBHCMO=11:"02",HBHCMO=12:"03",HBHCMO=1:"04",HBHCMO=2:"05",HBHCMO=3:"06",HBHCMO=4:"07",HBHCMO=5:"08",HBHCMO=6:"09",1:HBHCMO+3)_"01" D CHECK
	Q
DATE6L	; Calc 6 mo date based on month only for use by MFH License Expiration report processing
	S HBHCMO=+$E(DT,4,5),HBHCDATE=3_$S(HBHCMO>6:($E(DT,2,3)+1),1:($E(DT,2,3)))_$S(HBHCMO=7:"01",HBHCMO=8:"02",HBHCMO=9:"03",HBHCMO=10:"04",HBHCMO=11:"05",HBHCMO=12:"06",HBHCMO=1:"07",HBHCMO=2:"08",HBHCMO=3:"09",1:HBHCMO+6)_"01" D CHECK
	Q
CHECK	; Check length of HBHCDATE
	S:$L(HBHCDATE)=6 HBHCDATE=$E(HBHCDATE)_"0"_$E(HBHCDATE,2,6)
	Q
	;
	;Returns the text ICD-9/ICD-10/ICD based on date range
	;Input parameters:
	; HBHCBEG - Report beginning date
	; HBHCEND - Report ending date
	;Output values:
	; "ICD-9"  - if start and end dates are before ICD-10 implementation date
	; "ICD"    - if start and end dates spans across ICD-10 implementation date
	; "ICD-10" - if start and end dates are on or after ICD-10 implementation date
	;
ICDTEXT(HBHCBEG,HBHCEND)	;
	N HBHCICD10DT
	S HBHCICD10DT=$$IMPDATE^LEXU("10D")
	Q:(HBHCEND<HBHCICD10DT) "ICD-9"
	Q:(HBHCBEG>=HBHCICD10DT) "ICD-10"
	Q "ICD"
	;
	;Returns the text Coding System based on data range
	;Input parameters:
	; HBHCBEG - Report beginning date
	; HBHCEND - Report ending date
	;Output values:
	; ",1,"    - ICD-9 coding system if start and end dates are before ICD-10 implementation date
	; ",1,30," - ICD-9 and ICD-10 coding systems if start and end dates spans across ICD-10 implementation date
	; ",30,"   - ICD-10 coding system if start and end dates are on or after ICD-10 implementation date
	;
ICDCSYS(HBHCBEG,HBHCEND)	;
	N HBHCICD10DT,HBHCRET
	S HBHCRET=""
	S HBHCICD10DT=$$IMPDATE^LEXU("10D")
	S:(HBHCBEG<HBHCICD10DT) HBHCRET="1"  ;ICD-9
	S:(HBHCEND>=HBHCICD10DT) HBHCRET=HBHCRET_$S(HBHCRET]"":",",1:"")_"30"  ;ICD-10
	S:HBHCRET]"" HBHCRET=","_HBHCRET_","
	Q HBHCRET
