IBTRDD	;ALB/AAS - CLAIMS TRACKING, EXPANDED APPEALS - DENIALS ;02-JUL-1993
	;;2.0;INTEGRATED BILLING;**458,461**;21-MAR-94;Build 58
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;
%	;
EN	; -- main entry point for IBT EXPAND/EDIT DENIALS
	I '$D(DT) D DT^DICRW
	K XQORS,VALMEVL
	I '$G(IBTRC) G EN^IBTRD
	D EN^VALM("IBT EXPAND/EDIT DENIALS")
	Q
	;
HDR	; -- header code
	D PID^VADPT N IBXR
	S VALMHDR(1)="Expanded Appeal/Denial for: "_$$PT^IBTUTL1(DFN)
	S IBXR=$$ROIEVT^IBTRR1(IBTRN) I IBXR'="" S VALMHDR(1)=VALMHDR(1)_$J(" ",(60-$L(VALMHDR(1))))_"ROI: "_IBXR
	S VALMHDR(2)="                       for: "_$$EXPAND^IBTRE(356,.18,$P(IBTRND,"^",18))_" on "_$$DAT1^IBOUTL($P(IBTRND,"^",6),2)
	Q
	;
INIT	; -- init variables and list array
	N IBTRCD,IBTRCD1,IBTRN,IBTRND,DFN
	K VALMQUIT
	S VALMCNT=0,VALMBG=1
	D BLD,HDR
	Q
	;
BLD	; -- build display
	K ^TMP("IBTRDD",$J),^TMP("IBTRDDX",$J)
	D KILL^VALM10()
	S IBTRCD=$G(^IBT(356.2,+IBTRC,0)),IBTRCD1=$G(^(1))
	S IBTRN=$P(IBTRCD,"^",2),DFN=$P(IBTRCD,"^",5)
	S IBTRND=$G(^IBT(356,+IBTRN,0))
	F I=1:1:30 D BLANK^IBTRED(.I)
	S VALMCNT=30
	S VAINDT=$P(IBTRND,U,6)
	S VA200="" D INP^VADPT
	D ACTION^IBTRCD,VISIT,CLIN,INS,USER,APADD,COMM,CONT
	Q
	;
COMM	; -- comment display
	N OFFEST,START
	S START=31,OFFSET=2
	D COM1^IBTRCD0
	Q
	;
CONT	; -- contact info display
	N OFFEST,START
	S START=23,OFFSET=45
	D CON1^IBTRCD0
	Q
	;
HIST	; --history display
	N OFFEST,START
	S START=31,OFFSET=2
	;
	Q
	;
CLIN	; -- clinical data display
	N OFFSET,START
	S START=9,OFFSET=2
	D CLIN1^IBTRED0
	Q
	;
APADD	; -- Appeals Address Display
	N OFFSET,START
	S START=9,OFFSET=45
	D AP1^IBTRCD0
	Q
	;
USER	; -- User display
	N OFFSET,START
	S START=23,OFFSET=2
	D USER1^IBTRCD0
	Q
	;
INS	; -- Ins. Co. Display
	N OFFSET,START,IBCDFND,IBPHONE
	S START=17,OFFSET=2
	D ENINS^IBTRCD0
	Q
	;
VISIT	; -- Visit information
	N OFFSET,START,VAIN,VAINDT,IBETYP
	;S VAINDT=+IBTRCD+.24
	;D INP^VADPT
	S START=1,OFFSET=2
	S IBETYP=$G(^IBE(356.6,+$P(IBTRND,"^",18),0))
	D VISIT^IBTRED
	I $D(VAIN(11)) D SET^IBCNSP(START+5,OFFSET,"     Attending: "_$P(VAIN(11),"^",2))
	Q
	;
HELP	; -- help code
	S X="?" D DISP^XQORM1 W !!
	Q
	;
EXIT	; -- exit code
	K VALMQUIT,IBTRC,IBTRCD,IBTRCD1
	K ^TMP("IBTRDD",$J),^TMP("IBTRDDX",$J)
	D CLEAN^VALM10,FULL^VALM1
	Q
