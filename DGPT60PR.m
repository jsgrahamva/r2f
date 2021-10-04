DGPT60PR	;ALB/MTC/ADL,HIOFO/FT - Edit procedure codes.  In ICD0 Procedures, current, gender ok ;2/19/15 4:31pm
	;;5.3;Registration;**510,870,850,884**;Aug 13, 1993;Build 31
	;;ADL;Update for CSV project;;Mar. 24, 2003
	;
	; ICDEX APIs - #5747
	; ICDXCODE APIs - #5699
	;
EN	;called from DGPT601
LOOP	;
	S DGPTPRFL=0
	F DGPTL3=1:1:$S(DGPTFMT=3:25,1:5) S DGPTERC=0 D CHKPRC I DGPTERC D ERR
EXIT	;
	K DGPTOP,DGPTOP1,DGPTL3,DGPTL4,DGPTPP,DGPTPRFL,X,X1,X2
	Q
CHKPRC	;check if the procedure code exists in file 80.1
	N SYS,EFFDATE,IMPDATE,DGPTDAT
	D EFFDATE^DGPTIC10($G(PTF))
	S SYS=$$SYS^ICDEX("PROC",EFFDATE)
	S DGPTERC=0,DGPTOP=(@("DGPTPC"_DGPTL3)),DGPTOP=$P(DGPTOP," ",1) Q:DGPTOP=""
	S DGPTERC=604+DGPTL3
	I SYS=2 F DGPTL4=1:1:$L(DGPTOP) S DGPTOP1=$E(DGPTOP,1,DGPTL4)_"."_$E(DGPTOP,DGPTL4+1,$L(DGPTOP)) I +$$CODEN^ICDEX(DGPTOP1,80.1)>0 S DGPTERC=0 D GEN Q
	I SYS=31 S DGPTOP1=DGPTOP I +$$CODEN^ICDEX(DGPTOP1,80.1)>0 S DGPTERC=0 D GEN Q
	Q
GEN	;check gender of patient
	N SYS,EFFDATE,IMPDATE,DGPTDAT
	D EFFDATE^DGPTIC10($G(PTF))
	;DG*5.3*850
	S DGPTPP=+$$CODEN^ICDEX(DGPTOP1,80.1) I DGPTPP<1 S DGPTERC=604+DGPTL3 Q
	S DGPTTMP=$$ICDDATA^ICDXCODE("PROC",DGPTPP,EFFDATE)
	I DGPTTMP<1!('$P(DGPTTMP,U,10)) S DGPTERC=604+DGPTL3 Q
	;I $P(DGPTTMP,U,11)]""&(DGPTGEN'=$P(DGPTTMP,U,11)) S DGPTERC=651 Q
CURR	;check status and inactive date
	S DGPTTMP=$$ICDDATA^ICDXCODE("PROC",DGPTPP,EFFDATE)  ;use date of procedure if defined, else today
	I ($P(DGPTTMP,U,10)=0)&($E(DGPTPDTS,1,7)>$P(DGPTTMP,U,12)) S DGPTERC=604+DGPTL3 Q
SAVE	;
	S @("DGPTPC"_DGPTL3)=DGPTOP1
ARRAY	;array is used in DGPTAEE for error display in List Manager interface
	S DGPTPRAR(DGPTPDTS)=$S($D(DGPTPRAR(DGPTPDTS)):DGPTPRAR(DGPTPDTS)_U_DGPTPP,1:DGPTPP_U)
	Q
ERR	;
	D WRTERR^DGPTAE(DGPTERC,NODE,SEQ)
	Q
