DGPTEXPR	;ALB/MTC - PTF Expanded Code List ;14 MAY 91
	;;5.3;Registration;**850**;Aug 13, 1993;Build 171
	;;MAS 5.1;
	;
EN	; -- entry point for Expanded Code List (ICD-10 Remediation)
	N CAT,CODE
	D INIT G:DGOUT ENQ
	W @IOF,!,"PTF Expanded Code List   "
	;
	S PG=1,L="",DIC="^DIC(45.89,"
	;
	D CODESET G:CODESET<1 ENQ
	;
	S CAT("START")=$$STARTCAT(CODESET)
	I $D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT))!(CAT("START")="") G ENQ
	;
	S CAT("FINISH")=$$FINALCAT(CODESET,CAT("START"))
	I $D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT))!(CAT("FINISH")="") G ENQ
	;
	S CODE("START")=$$STARTCOD(CODESET)
	I $D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT))!(CODE("START")="") G ENQ
	;
	S CODE("FINISH")=$$FINALCOD(CODESET,CODE("START"))
	I $D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT))!(CODE("FINISH")="") G ENQ
	;
	S:CAT("START")="FIRST" CAT("START")=""
	S:CAT("FINISH")="LAST" CAT("FINISH")=""
	S:CODE("START")="FIRST" CODE("START")=""
	S:CODE("FINISH")="LAST" CODE("FINISH")=""
	;
	I CODESET=9 D
	. S FLDS="[DGPT EXPANDED CODE LIST]"
	. S BY="[DGPT EXPANDED CODE SORT ICD-9]"
	. S FR="ICD-10-CM,"_CAT("START")_","_CODE("START")
	. S TO="ICD-10-PCS,"_CAT("FINISH")_","_CODE("FINISH")
	;
	I CODESET=10 D
	. S FLDS="[DGPT EXPANDED CODE LIST-10]"
	. S BY="[DGPT EXPANDED CODE SORT ICD-10]"
	. S FR="ICD-9 PROC,"_CAT("START")_","_CODE("START")
	. S TO="ICD-9-CM,"_CAT("FINISH")_","_CODE("FINISH")
	;
	D EN1^DIP
	; 
ENQ	; -- exit point
	K X,Y,L,DIC,FLDS,BY,FR,PG,FROM,TO,DTOUT,DUOUT,DIRUT,DIROUT,LIST,VERSION,CODESET,DGOUT,DGQUIT,CAT,CODE
	Q
STARTCAT(CSET)	; -- Start Code Set
	N X,Y,VAL,DIR
	S VAL=""
	S DIR("?",1)="Answer with PTF EXPANDED CODE CATEGORY NAME"
	S DIR("?")="   Select FIRST to select all CATEGORY names"
	S LIST="FI:FIRST;DI:DIALYSIS TYPE;KI:KIDNEY TRANSPLANT STATUS;LE:LEGIONNAIRE'S DISEASE;PS:PSYCHIATRY AXIS CLASSIFICATION;SUB:SUBSTANCE ABUSE;SUI:SUICIDE INDICATOR"
	S DIR("A")="START WITH CATEGORY: "
	S DIR("B")="FIRST"
	S DIR(0)="SAO^"_LIST
	D ^DIR
	S VAL=$G(Y(0))
	Q VAL
	;
FINALCAT(CSET,STRT)	; -- Start Code Set
	N X,Y,VAL,DIR
	I STRT="FIRST" Q "LAST"
	S VAL=""
FC	; - Re-ask
	S LIST="LA:LAST;DI:DIALYSIS TYPE;KI:KIDNEY TRANSPLANT STATUS;LE:LEGIONNAIRE'S DISEASE;PS:PSYCHIATRY AXIS CLASSIFICATION;SUB:SUBSTANCE ABUSE;SUI:SUICIDE INDICATOR"
	S DIR("?",1)="Answer with PTF EXPANDED CODE CATEGORY NAME"
	S DIR("?")="   Select LAST to select all CATEGORY names after "_STRT
	S DIR("A")="GO TO CATEGORY: "
	S DIR("B")="LAST"
	S DIR(0)="SAO^"_LIST
	D ^DIR
	S VAL=$G(Y(0))
	I VAL'="LAST",(VAL'=STRT),(VAL']STRT) W !,"Go To value must equal or follow the Start With value",*7,! G FC
	Q VAL
	;
STARTCOD(CSET)	; -- Start Code Set
	N VAL,D,DIC,DIR,DGX1,DGX2,REASK,VP
	S VAL=""
R1	;
	R !,"   START WITH DIAGNOSIS/PROCEDURE CODE: FIRST// ",Y:DTIME S:'$T Y="^",DTOUT=""
	I Y="?" D HELP1 G R1
	I Y["??" D HELP1,LIST(CSET,.CAT) G R1
	I Y="" S Y="FIRST"
	;
	I $D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT)) Q "-1"
	I $G(Y)="FIRST" Q Y
	;
	S X=$G(Y)
SC	; Re-ask
	S DIC("A")="   START WITH DIAGNOSIS/PROCEDURE CODE: "
	S DIC="^DIC(45.89,"
	S DIC(0)=$S($G(REASK):"AEQZ",1:"EQZ")
	S DGX1=$S(CSET=9:1,1:30)
	S DGX2=$S(CSET=9:2,1:31)
	S DIC("S")="I $P(^(0),U,5)="_DGX1_"!($P(^(0),U,5)="_DGX2_")"
	S D="ACODE"
	D IX^DIC
	I $D(DTOUT)!($D(DUOUT)) Q ""
	I Y<1 K X S REASK=1 G SC
	S VP=$P($G(^DIC(45.89,+Y,0)),U,2)
	S VAL=$$CODEC^ICDEX($S(VP["ICD9":80,VP["ICD0":80.1,1:80),+VP)
	Q VAL
	;
FINALCOD(CSET,STRT)	; -- Start Code Set
	N VAL,D,DIC,DIR,DGX1,DGX2,REASK,VP
	I STRT="FIRST" Q "LAST"
	S VAL=""
	;
R2	;
	R !,"   GO TO DIAGNOSIS/PROCEDURE CODE: LAST// ",Y:DTIME S:'$T Y="^",DTOUT=""
	I Y="?" D HELP1 G R2
	I Y["??" D HELP1,LIST(CSET,.CAT) G R2
	I Y="" S Y="LAST"
	;
	I $D(DTOUT)!($D(DUOUT))!($D(DIRUT))!($D(DIROUT)) Q "-1"
	I $G(Y)="LAST" Q Y
	;
	S X=$G(Y)
FCCC	; Re-ask
	S DIC("A")="   GO TO DIAGNOSIS/PROCEDURE CODE: "
	S DIC="^DIC(45.89,"
	S DIC(0)=$S($G(REASK):"AEQZ",1:"EQZ")
	S DGX1=$S(CSET=9:1,1:30)
	S DGX2=$S(CSET=9:2,1:31)
	S DIC("S")="I $P(^(0),U,5)="_DGX1_"!($P(^(0),U,5)="_DGX2_")"
	S D="ACODE"
	D IX^DIC
	I $D(DTOUT)!($D(DUOUT)) Q ""
	I Y<1 K X S REASK=1 G FCCC
	S VP=$P($G(^DIC(45.89,+Y,0)),U,2)
	S VAL=$$CODEC^ICDEX($S(VP["ICD9":80,VP["ICD0":80.1,1:80),+VP)
	I VAL'="LAST",(VAL'=STRT),(VAL']STRT) W !,"Go To value must equal or follow the Start With value",*7,! K X S REASK=1 G FCCC
	Q VAL
	;
INIT	;
	S DGOUT=0
	D LO^DGUTL,HOME^%ZIS
	Q
	;
CODESET	; -ask which codeset
	;Select ICD Code Set (9,10):
	N DIR,X,Y,IMPDATE,DTOUT,DUOUT,DIRUT,DIROUT
	S IMPDATE=$P($$IMPDATE^DGPTIC10("10D"),U,1)
	;
	S DIR(0)="SA^9:ICD-9;10:ICD-10"
	S DIR("A")="Select ICD Code Set (9,10): "
	S DIR("B")=$S(DT<IMPDATE:9,1:10)
	S DIR("L")=""
	D ^DIR
	I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT) S Y=-1
	S CODESET=Y
	Q
	;
HELP1	; -- Code help text
	W !!,"TO  IN SEQUENCE, STARTING FROM A CERTAIN DIAGNOSIS/PROCEDURE CODE, "
	W !,"     TYPE THAT DIAGNOSIS/PROCEDURE CODE"
	W !,"     OR ENTER '@' TO INCLUDE NULL DIAGNOSIS/PROCEDURE CODE VALUES"
	W !,"    OR ENTER 'FIRST' TO START FROM THE FIRST VALUE"
	Q
	;
LIST(CSET,CAT)	; -- List available codes
	N I,J,ZZ,ENTRY,IEN,VESION,CNT,DGQUIT,STRT,FNSH,IENCAT,OK
	W !,"   Choose from:",!
	S ENTRY="",CNT=1
	S STRT=$G(CAT("START")),FNSH=$G(CAT("FINISH"))
	I STRT="FIRST" S STRT="A"
	I FNSH="LAST" S FNSH="ZZZ"
	F I=0:0 S ENTRY=$O(^DIC(45.89,"ACODE",ENTRY)) Q:ENTRY=""!($D(DGQUIT))  D
	. S IEN=0
	. F J=0:0 S IEN=$O(^DIC(45.89,"ACODE",ENTRY,IEN)) Q:IEN=""!($D(DGQUIT))  D
	.. S IENCAT=$P($G(^DIC(45.88,+$P($G(^DIC(45.89,IEN,0)),U,1),0)),U,1)
	.. S VERSION=$P($G(^DIC(45.89,IEN,0)),U,5)
	.. S OK=0 I (IENCAT=STRT)!(IENCAT=FNSH) S OK=1
	.. I 'OK&((IENCAT']STRT)!(IENCAT]FNSH)) Q
	.. ;
	.. I CSET=9 I (VERSION=1)!(VERSION=2) W ?3,ENTRY,?15,IENCAT,! S CNT=CNT+1
	.. I CSET=10 I (VERSION=30)!(VERSION=31) W ?3,ENTRY,?15,IENCAT,! S CNT=CNT+1
	.. I '(CNT#18) R "   '^' TO STOP: ",ZZ:$G(DTIME,300) S:'$T DGQUIT=1 S:ZZ["^" DGQUIT=1 W:ZZ="" $C(13),$J("",15),$C(13)
	.. Q
	Q
