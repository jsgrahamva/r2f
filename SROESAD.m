SROESAD	;BIR/ADM - SURGERY E-SIG UTILITY ; [ 09/04/03  1:03 PM ]
	;;3.0; Surgery ;**100,173**;24 Jun 93;Build 8
	;
	;** NOTICE: This routine is part of an implementation of a nationally
	;**         controlled procedure.  Local modifications to this routine
	;**         are prohibited.
	;
	; Reference to MAKEADD^TIUSRVP supported by DBIA #3535
	; Reference to ES^TIUSROI supported by DBIA #3537
	;
	Q:'$D(SRNDOC(SRTN))&'$D(SRADOC(SRTN))  D DISPLAY I SRESNOT D NOAD Q
ASK	N SRSCOM W @IOF,! S DIR(0)="Y",DIR("A")="Do you want to add a comment for this case",DIR("B")="NO" D ^DIR K DIR S SRSCOM=Y I $D(DTOUT) D NOAD Q
	I $D(DUOUT) D SURE I 'SRESNOT G ASK
	I SRESNOT D NOAD Q
	I 'SRSCOM G SIG
	I SRSCOM W !! S DIR(0)="F^3:80",DIR("A")="Comment" D ^DIR K DIR I $D(DTOUT) S SRESNOT=1 Q
	I X=""!$D(DUOUT) G SIG
	D COM
REV2	; display addendum with comment for 2nd review
	D DISPLAY I SRESNOT D NOAD Q
SIG	; enter e-sig
	N SRNOW,SRSBN,SRSIG
	D SIG^XUSESIG I X1="" D NOAD Q
	S SRSBN=X1,SRNOW=$$NOW^XLFDT
	I $D(SRNDOC(SRTN)) D POSTN(SRTN,SRSBN,SRNOW) I SRESNOT=1 Q
	I $D(SRADOC(SRTN)) D POSTA(SRTN,SRSBN,SRNOW) I SRESNOT=1 Q
	W ! K DIR S DIR(0)="FOA",DIR("A")="Press RETURN to continue... " D ^DIR K DIR
	Q
NOAD	; no addendum created
	W !!,"No addendum created for case #"_SRTN_".  Original data will be restored.",!! S SRESNOT=1
	Q
COM	; add comment to end of addendum
	N SRCOM S SRCOM=X I $D(SRNDOC(SRTN)) S SRLN=$O(^TMP("SRNR",$J,SRTN,""),-1) I SRLN D
	.I ^TMP("SRNR",$J,SRTN,SRLN)'="" S SRLN=SRLN+1,^TMP("SRNR",$J,SRTN,SRLN)=""
	.S SRLN=SRLN+1,^TMP("SRNR",$J,SRTN,SRLN)="Addendum Comment: "_$S($L(SRCOM)<63:SRCOM,1:"")
	.I $L(SRCOM)>62 S SRLN=SRLN+1,^TMP("SRNR",$J,SRTN,SRLN)=SRCOM
	I $D(SRADOC(SRTN)) S SRLN=$O(^TMP("SRAR",$J,SRTN,""),-1) I SRLN D
	.I ^TMP("SRAR",$J,SRTN,SRLN)'="" S SRLN=SRLN+1,^TMP("SRAR",$J,SRTN,SRLN)=""
	.S SRLN=SRLN+1,^TMP("SRAR",$J,SRTN,SRLN)="Addendum Comment: "_$S($L(SRCOM)<63:SRCOM,1:"")
	.I $L(SRCOM)>62 S SRLN=SRLN+1,^TMP("SRAR",$J,SRTN,SRLN)=SRCOM
	S SRLN=$O(^TMP("SRADDEND",$J,SRTN,""),-1) I SRLN D
	.I ^TMP("SRADDEND",$J,SRTN,SRLN)'="" S SRLN=SRLN+1,^TMP("SRADDEND",$J,SRTN,SRLN)=""
	.S SRLN=SRLN+1,^TMP("SRADDEND",$J,SRTN,SRLN)="Addendum Comment: "_$S($L(SRCOM)<63:SRCOM,1:"")
	.I $L(SRCOM)>62 S SRLN=SRLN+1,^TMP("SRADDEND",$J,SRTN,SRLN)=SRCOM
	Q
GET	; gather data for modified fields for addendum display before signing
	F SRS=1,2 F SRPRE="SRARAD","SRNRAD" S SRFLD="",SRSUB=SRPRE_SRS F  S SRFLD=$O(^TMP(SRSUB,$J,SRTN,130,SRFLD)) Q:SRFLD=""  D
	.I SRFLD[";W" S SRLN="" D  Q
	..F  S SRLN=$O(^TMP(SRSUB,$J,SRTN,130,SRFLD,SRLN)) Q:SRLN=""  S ^TMP("SRAD"_SRS,$J,SRTN,130,SRFLD,SRLN)=^TMP(SRSUB,$J,SRTN,130,SRFLD,SRLN)
	.S ^TMP("SRAD"_SRS,$J,SRTN,130,SRFLD)=^TMP(SRSUB,$J,SRTN,130,SRFLD)
	F SRS=1,2 F SRPRE="SRARAD","SRNRAD" S SRMULT="A",SRSUB=SRPRE_SRS F  S SRMULT=$O(^TMP(SRSUB,$J,SRTN,SRMULT)) Q:SRMULT=""  S SRE="" D
	.F  S SRE=$O(^TMP(SRSUB,$J,SRTN,SRMULT,SRE)) Q:'SRE  S SRE1="" F  S SRE1=$O(^TMP(SRSUB,$J,SRTN,SRMULT,SRE,SRE1)) Q:SRE1=""  S SRFLD="" F  S SRFLD=$O(^TMP(SRSUB,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)) Q:SRFLD=""  D
	..I SRFLD[";W" S SRLN="" D  Q
	...F  S SRLN=$O(^TMP(SRSUB,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN)) Q:SRLN=""  S ^TMP("SRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN)=^TMP(SRSUB,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN)
	..S ^TMP("SRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)=^TMP(SRSUB,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)
	F SRS=1,2 F SRPRE="SRARMULT","SRNRMULT" S SRMULT="A",SRSUB=SRPRE_SRS F  S SRMULT=$O(^TMP(SRSUB,$J,SRTN,SRMULT)) Q:SRMULT=""  S SRE="" D
	.F  S SRE=$O(^TMP(SRSUB,$J,SRTN,SRMULT,SRE)) Q:'SRE  S SRE1="" F  S SRE1=$O(^TMP(SRSUB,$J,SRTN,SRMULT,SRE,SRE1)) Q:SRE1=""  S SRFLD="" F  S SRFLD=$O(^TMP(SRSUB,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)) Q:SRFLD=""  D
	..I SRFLD[";W" S SRLN="" D  Q
	...F  S SRLN=$O(^TMP(SRSUB,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN)) Q:SRLN=""  S ^TMP("SRADM"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN)=^TMP(SRSUB,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN)
	..S ^TMP("SRADM"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)=^TMP(SRSUB,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)
	Q
DISPLAY	; display addenda to nurse/anesthesia report(s)
	S SRLN=0
	D HDR F  S SRLN=$O(^TMP("SRADDEND",$J,SRTN,SRLN)) Q:'SRLN  D  Q:SRESNOT
	.I $Y+4>IOSL D PAGE Q:SRESNOT  D HDR
	.W !,^TMP("SRADDEND",$J,SRTN,SRLN)
	D:'SRESNOT PAGE
	Q
PAGE	W ! K DIR S DIR(0)="E" D ^DIR K DIR I $D(DTOUT) S SRESNOT=1 Q
	I $D(DUOUT) D SURE
	Q
SURE	W ! S DIR("A",1)="No addendum will be created and the original data will be restored.",DIR("A")="Are you sure you want to exit",DIR("B")="NO",DIR(0)="Y" D ^DIR K DIR I Y!$D(DTOUT)!$D(DUOUT) S SRESNOT=1
	Q
HDR	; header for addendum display
	W @IOF,!,"Addendum for Case #"_SRTN_" - "_SRSDATE,!,"Patient: "_VADM(1)_" ("_VA("PID")_")",!
	F I=1:1:80 W "-"
	Q
POSTA(SRTN,SRSBN,SRNOW)	;post signed addendum to anesthesia report
	N SRADD,SRAY,SRTIU,SRMSGS
	S SRAY(1405)=SRTN_";SRF(",SRAY(1701)="Case #: "_SRTN
	F I=1:1 Q:'$D(^TMP("SRAR",$J,SRTN,I))  S SRAY("TEXT",I,0)=^TMP("SRAR",$J,SRTN,I)
	S SRTIU=$P($G(^SRF(SRTN,"TIU")),"^",4) Q:'SRTIU
	D MAKEADD^TIUSRVP(.SRADD,SRTIU,.SRAY,1) I +SRADD'>0 D  Q
	.S SRMSGS=$P($G(SRADD),U,2)
	.W !!!!,SRMSGS
	.D NOAD
	.Q
	S SRTIU=+SRADD K SRAY
	D ES^TIUSROI(SRTIU,DUZ)
	Q
POSTN(SRTN,SRSBN,SRNOW)	; post signed addendum
	N SRADD,SRAY,SRTIU,SRMSGS
	S SRAY(1405)=SRTN_";SRF(",SRAY(1701)="Case #: "_SRTN
	F I=1:1 Q:'$D(^TMP("SRNR",$J,SRTN,I))  S SRAY("TEXT",I,0)=^TMP("SRNR",$J,SRTN,I)
	S SRTIU=$P($G(^SRF(SRTN,"TIU")),"^",2) Q:'SRTIU
	D MAKEADD^TIUSRVP(.SRADD,SRTIU,.SRAY,1) I +SRADD'>0 D  Q
	.S SRMSGS=$P($G(SRADD),U,2)
	.W !!!!,SRMSGS
	.D NOAD
	.Q
	S SRTIU=+SRADD K SRAY
	D ES^TIUSROI(SRTIU,DUZ)
	Q