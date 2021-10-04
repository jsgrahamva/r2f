IBTRVD	;ALB/AAS - CLAIMS TRACKING - EXPANDED REVIEW SCREEN;02-JUL-1993
	;;2.0;INTEGRATED BILLING;**266,458**;21-MAR-94;Build 4
	;;Per VHA Directive 2004-038, this routine should not be modified.
%	;
EN	; -- main entry point for IBT EXPAND/EDIT REVIEW from menus
	K XQORS,VALMEVL,IBTRV,IBTRN,DFN,IBTRC,IBTRD
	I '$D(IBTRV) G ^IBTRV
	D EN^VALM("IBT EXPAND/EDIT REVIEW")
	Q
	;
HDR	; -- header code
	D PID^VADPT N IBXR
	S VALMHDR(1)="Expanded Review for: "_$$PT^IBTUTL1(DFN)
	S IBXR=$$ROIEVT^IBTRR1(IBTRN) I IBXR'="" S VALMHDR(1)=VALMHDR(1)_$J(" ",(60-$L(VALMHDR(1))))_"ROI: "_IBXR
	S VALMHDR(2)="                for: "_$P($G(^IBE(356.11,+$P(IBTRVD,"^",22),0)),"^")_" on "_$$DAT1^IBOUTL(+IBTRVD)
	Q
	;
INIT	; -- init variables and list array
	N IBTRND,IBTRVD,IBTRVD1,IBTRTP,VAIN,VAINDT
	K VALMQUIT
	S VALMCNT=0,VALMBG=1
	D BLD,HDR
	Q
	;
BLD	; -- build dispaly
	K ^TMP("IBTRVD",$J),^TMP("IBTRVDDX",$J)
	S IBTRND=$G(^IBT(356,IBTRN,0))
	S IBTRVD=$G(^IBT(356.1,+IBTRV,0))
	S IBTRVD1=$G(^IBT(356.1,+IBTRV,1))
	S IBTRTP=$$TRTP^IBTRV(IBTRV)
	F I=1:1:28 D BLANK^IBTRED(.I)
	D KILL^VALM10()
	S VALMCNT=28
	D ^IBTRVD0,COMMENT,CLIN
	Q
	;
	;
CLIN	; -- Clinical info plus DRG/los information
	N OFFSET,START,DGPM,IBDT,IBDR
	S START=17,OFFSET=45
	;D SET^IBCNSP(START,OFFSET," Clinical Information ",IORVON,IORVOFF)
	D CLIN1^IBTRED0
	Q:$$TRTP^IBTRE1(IBTRN)>1
	S DGPM=+$P(^IBT(356,IBTRN,0),"^",5)
	S IBDT=0 F  S IBDT=$O(^IBT(356.93,"AMVD",+DGPM,IBDT)) Q:'IBDT  S IBDR=$O(^IBT(356.93,"AMVD",+DGPM,IBDT,0))
	S IBDR=$G(^IBT(356.93,+$G(IBDR),0))
	D SET^IBCNSP(START+6,OFFSET,"   Interim DRG: "_$S(+IBDR:+IBDR_" - "_$$DRGTD^IBACSV(+IBDR,$P(IBDR,"^",3))_" on "_$$DAT1^IBOUTL($P(IBDR,"^",3)),1:""))
	D SET^IBCNSP(START+7,OFFSET," Estimate ALOS: "_$S(+IBDR:$J($P(IBDR,"^",4),6,1),1:""))
	D SET^IBCNSP(START+8,OFFSET,"Days Remaining: "_$S(+IBDR:$J($P(IBDR,"^",5),6),1:""))
	Q
	;
COMMENT	; -- Display Comment
	N OFFSET,START,I,IBLCNT
	S START=27,OFFSET=2
	D SET^IBCNSP(START,OFFSET," Review Comments ",IORVON,IORVOFF)
	S (IBLCNT,IBI)=0 F  S IBI=$O(^IBT(356.1,IBTRV,11,IBI)) Q:IBI<1  D
	.S IBLCNT=IBLCNT+1
	.D SET^IBCNSP(START+IBLCNT,OFFSET,"  "_$E($G(^IBT(356.1,IBTRV,11,IBI,0)),1,80))
	Q
	;
HELP	; -- help code
	S X="?" D DISP^XQORM1 W !!
	Q
	;
EXIT	; -- exit code
	K VALMQUIT,IBTRV
	D CLEAN^VALM10,FULL^VALM1
	Q
