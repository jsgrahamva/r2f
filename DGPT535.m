DGPT535	;ALB/MTC,HIOFO/FT - Process 535 transmission ;7/8/15 1:49pm
	;;5.3;Registration;**64,164,729,884**;Aug 13, 1993;Build 31
	;
	;no external references
	;
EN	;
	S DGPTSTR=^TMP("AEDIT",$J,NODE,SEQ),DGPTEDFL=0
	S DGPTTDT=$E(DGPTSTR,31,40),(X,DGPTTDTS)=$$FMDT^DGPT101($E(DGPTTDT,1,6))_"."_$E(DGPTTDT,7,10) S %DT="XT" D ^%DT I Y<0 S DGPTERC=505 D ERR G:DGPTEDFL EXIT G SET
	D DD^%DT S DGPTTDT=$E(Y,5,6)_"-"_$E(Y,1,3)_"-"_$E(Y,9,12)_" "_$S($P(Y,"@",2)]"":$E($P(Y,"@",2),1,5),1:"00:00")
SET	;
	S DGPTTLR=$E(DGPTSTR,41,46),DGPTTLC=$E(DGPTSTR,47,48),DGPTTSR=$E(DGPTSTR,49,54),DGPTTSC=$E(DGPTSTR,55,56),DGPTTLD=$E(DGPTSTR,57,59),DGPTTPD=$E(DGPTSTR,60,62),DGPTXX=$E(DGPTSTR,63,71)
DTE	;
	S DGPTTDDS=$$FMDT^DGPT101($E(DGPTSTR,31,36))_"."_$E(DGPTSTR,37,40)
	I (DGPTTDDS'>DGPTDTS)!(DGPTTDDS'<DGPTDDS) S DGPTERC=540 D ERR G:DGPTEDFL EXIT
TSPEC	;
	N DGPTTSC1
	I DGPTTSC'?2AN S DGPTERC=506 D ERR G:DGPTEDFL EXIT
	S DGPTSP1=$E(DGPTTSC,1),DGPTSP2=$E(DGPTTSC,2),DGPTERC=0
	D CHECK^DGPTAE02 I DGPTERC S DGPTERC=506 D ERR G:DGPTEDFL EXIT G LSPEC
	;-- Active treating specialty edit check
	I $E(DGPTTSC,1)=0!($E(DGPTTSC,1)=" ") S DGPTTSC=$E(DGPTTSC,2)
	; DGPTTSC  := ptf code (alpha-numeric) value (file:42.4,field:7)
	; DGPTTSC1 := dinum value (file:42.4,field:.001)
	S DGPTTSC1=+$O(^DIC(42.4,"C",DGPTTSC,0))
	;-- If not active treat spec, set 535 flag to print error msg during
	;-- PTF close-out error display at WRER^DGPTAEE
	;I '$$ACTIVE^DGACT(42.4,DGPTTSC1,DGPTTDTS) S DGPTERC=506,DGPTSER(DGPTTDTS_535)=1 D ERR G:DGPTEDFL EXIT
LSPEC	;
	N DGPTTLC1
	I DGPTTLC'?2AN S DGPTERC=506 D ERR G:DGPTEDFL EXIT
	S DGPTSP1=$E(DGPTTLC,1),DGPTSP2=$E(DGPTTLC,2),DGPTERC=0
	D CHECK^DGPTAE02 I DGPTERC S DGPTERC=506 D ERR G:DGPTEDFL EXIT G LVPAS
	;-- Active treating specialty edit check
	I $E(DGPTTLC,1)=0!($E(DGPTTLC,1)=" ") S DGPTTLC=$E(DGPTTLC,2)
	; DGPTTLC  := ptf code (alpha-nemeric) value (file:42.4,field:7)
	; DGPTTLC1 := dinum value (file:42.4,field:.001)
	S DGPTTLC1=+$O(^DIC(42.4,"C",DGPTTLC,0))
	;-- If not active treat spec, set 535 flag to print error msg during
	;-- PTF close-out error display at WRER^DGPTAEE
	;I '$$ACTIVE^DGACT(42.4,DGPTTLC1,DGPTTDTS) S DGPTERC=506,DGPTSER(DGPTTDTS_5351)=1 D ERR G:DGPTEDFL EXIT
LVPAS	;
	I DGPTTLD'?1.3N&(DGPTTLD'="   ") S DGPTERC=507 D ERR G:DGPTEDFL EXIT
	I DGPTTPD'?1.3N&(DGPTTPD'="   ") S DGPTERC=508 D ERR G:DGPTEDFL EXIT
	S DGPTERC=0 S X1=DGPTTDTS D 535^DGPTAE03 D:DGPTERC ERR G:DGPTEDFL EXIT
ALLGD	;
	W "."
	;
EXIT	;
	K DGPTTDT,DGPTTLR,DGPTTLC,DGPTTSR,DGPTTSC,DGPTTLD,DGPTTPD,DGPTSTR
	K DGPTLO1,DGPTLO2,DGPTS1,DGPTS2,DGPTTDTS,DGPTTDDS,DGPTXX,X,X1,Y
	Q
ERR	;
	D WRTERR^DGPTAE(DGPTERC,NODE,SEQ)
	Q
