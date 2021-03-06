IBTRC	;ALB/AAS - CLAIMS TRACKING INSURANCE REVIEWS ; 27-JUN-1993
	;;2.0;INTEGRATED BILLING;**458**;21-MAR-94;Build 4
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;
%	;
EN	; -- main entry point for IBT COMMUNICATIONS EDITOR from menu's
	I '$D(DT) D DT^DICRW
	K XQORS,VALMEVL,IBTRN,IBTRND,IBCNT,DFN,IBTRC,IBTRV,IBTRD,IBCNS,IBCDFN,IBFASTXT,VALMQUIT,VA,VAIN,VAERR
	;I '$D(IBTRN) D EN^IBTRE Q
	D PAT^IBCNSM I $D(VALMQUIT) G ENQ
	D TRAC^IBTRV I $D(VALMQUIT) G ENQ
	I '$G(IBTRPRF) S IBTRPRF="12"
	D EN^VALM("IBT COMMUNICATIONS EDITOR")
ENQ	K XQORS,VALMEVL,IBTRN,IBTRND,IBCNT,DFN,IBTRC,IBTRV,IBTRD,IBCNS,IBCDFN,IBFASTXT,VALMQUIT,IBTRPRF,VA,VAIN,VAERR,X,Y,I,J,IBETYP
	K IBAMT,IBAPR,IBADG,IBDA,IBDGCR,IBDGCRU1,IBDV,IBETYP,IBETYPD,IBI,IBICD,IBLCNT,IBSEL,IBT,IBTEXT,IBTNOD,IBTSAV,VAUTD
	K IBAPEAL,IBCDFN,IBCNT,IBDEN,IBDENIAL,IBDENIAL,IBPARNT,IBPEN,IBPENAL,IBTCOD,IBTRDD,IBTRSV,IBTYPE,VAINDT,VA,VALMBCK,OFFSET,I1,I3,IBNEW,IBDENT,IBOE,Z1,T,SDCNT
	D KVAR^VADPT
	Q
	;
HDR	; -- header code
	D PID^VADPT N IBXR
	S VALMHDR(1)="Insurance Review Entries for: "_$$PT^IBTUTL1(DFN)
	S IBXR=$$ROIEVT^IBTRR1(IBTRN) I IBXR'="" S VALMHDR(1)=VALMHDR(1)_$J(" ",(60-$L(VALMHDR(1))))_"ROI: "_IBXR
	S VALMHDR(2)="                         for: "_$$EXPAND^IBTRE(356,.18,$P(IBTRND,"^",18))_" on "_$$DAT1^IBOUTL($P(IBTRND,"^",6),"2P")
	Q
	;
INIT	; -- init variables and list array
	S U="^",VALMCNT=0,VALMBG=1
	K ^TMP("IBTRC",$J),^TMP("IBTRCDX",$J)
	K I,X,XQORNOD,DA,DR,DIE,DNM,DQ
	S IBTRND=$G(^IBT(356,IBTRN,0))
	D BLD
	Q
	;
BLD	; -- Build list of Insurnace contacts
	K ^TMP("IBTRC",$J),^TMP("IBTRCDX",$J)
	N IBI,J,IBTRC,IBTRCD,IBTRCD1
	S VALMSG=$$MSG^IBTUTL3(DFN)
	S (IBTRC,IBCNT,VALMCNT)=0,IBI=""
	F  S IBI=$O(^IBT(356.2,"ATIDT",IBTRN,IBI)) Q:'IBI  S IBTRC=0 F  S IBTRC=$O(^IBT(356.2,"ATIDT",IBTRN,IBI,IBTRC)) Q:'IBTRC  D
	.S IBTRCD=$G(^IBT(356.2,+IBTRC,0))
	.S IBTRCD1=$G(^IBT(356.2,+IBTRC,1))
	.Q:'+$P(IBTRCD,"^",19)  ;quit if inactive
	.S IBCNT=IBCNT+1
	.S IBETYP=$G(^IBE(356.11,+$P(IBTRCD,"^",4),0))
	.W "."
	.S X=""
	.S X=$$SETFLD^VALM1(IBCNT,X,"NUMBER")
	.S X=$$SETFLD^VALM1($P($$DAT1^IBOUTL(+IBTRCD,"2P")," "),X,"DATE")
	.S X=$$SETFLD^VALM1($P($G(^DIC(36,+$P(IBTRCD,"^",8),0)),"^"),X,"INS CO")
	.S X=$$SETFLD^VALM1($$EXPAND^IBTRE(356.2,.11,$P(IBTRCD,"^",11)),X,"ACTION")
	.;
	.S X=$$SETFLD^VALM1($P(IBETYP,"^",3),X,"TYPE")
	.S X=$$SETFLD^VALM1($$AUTHN(IBTRC,10),X,"PRE-CERT")
	.I $P(IBTRCD,"^",13) S X=$$SETFLD^VALM1($J($$DAY^IBTUTL3($P(IBTRCD,"^",12),$P(IBTRCD,"^",13),IBTRN),3),X,"DAYS")
	.I $P($G(^IBE(356.7,+$P(IBTRCD,"^",11),0)),"^",3)=20 S X=$$SETFLD^VALM1($J($$DAY^IBTUTL3($P(IBTRCD,"^",15),$P(IBTRCD,"^",16),IBTRN),3),X,"DAYS")
	.I $P(IBTRCD1,"^",7)!($P(IBTRCD1,"^",8)) S X=$$SETFLD^VALM1("ALL",X,"DAYS")
	.S X=$$SETFLD^VALM1($P(IBTRCD,"^",6),X,"CONTACT")
	.S X=$$SETFLD^VALM1($P(IBTRCD,"^",7),X,"PHONE")
	.S X=$$SETFLD^VALM1($$CREFN(IBTRC,12),X,"REF NO")
	.I $P(IBETYP,"^",2)=60!($P(IBETYP,"^",2)=65) D APPEAL^IBTRC3
	.D SET(X)
	Q
	;
SET(X)	; -- set arrays
	S VALMCNT=VALMCNT+1
	S ^TMP("IBTRC",$J,VALMCNT,0)=X
	S ^TMP("IBTRC",$J,"IDX",VALMCNT,IBCNT)=""
	S ^TMP("IBTRCDX",$J,IBCNT)=VALMCNT_"^"_IBTRC
	Q
HELP	; -- help code
	S X="?" D DISP^XQORM1 W !!
	Q
	;
EXIT	; -- exit code
	K ^TMP("IBTRC",$J),^TMP("IBTRCDX",$J)
	K IBTRC
	D CLEAN^VALM10
	Q
	;
AUTHN(IBTRC,LNG)	; -- return autorization number (356.2, 2.02) - length and append *
	N X S X=$P($G(^IBT(356.2,+$G(IBTRC),2)),"^",2) I +$G(LNG),$L(X)>LNG S X=$E(X,1,(LNG-1))_"*"
	Q X
	;
CREFN(IBTRC,LNG)	; -- return call reference number (356.2, 2.01) - length and append *
	N X S X=$P($G(^IBT(356.2,+$G(IBTRC),2)),"^",1) I +$G(LNG),$L(X)>LNG S X=$E(X,1,(LNG-1))_"*"
	Q X
	;
	;
TYPE(IBTRC)	; -- compute default type of contact
	N TYPE,IBTRTP,IBTRN,IBSCHED
	S TYPE=""
	I '$P($G(^IBT(356.2,IBTRC,0)),"^",2) S TYPE=70 G TYPEQ ;no tracking id default is patient
	S IBTRN=$P($G(^IBT(356.2,IBTRC,0)),"^",2),IBTRTP=$$TRTP^IBTRE1(IBTRN)
	;
	; -- if from a review
	I $G(IBTRV) S TYPE=$$TRTP^IBTRV(IBTRV) G TYPEQ ; if from review use review type
	I IBTRTP>1 S TYPE=50 G TYPEQ ; outpatient
	S IBSCHED=$S($P($G(^DGPM(+$P($G(^IBT(356,IBTRN,0)),U,5),0)),U,25):10,1:20)
	I '$O(^IBT(356.2,"ATRTP",IBTRN,0)) S TYPE=IBSCHED G TYPEQ ; default for first is urgent admission
	S TYPE=30 ; default is continued stay
	;
TYPEQ	Q $P($G(^IBE(356.11,+$O(^IBE(356.11,"ACODE",+TYPE,0)),0)),"^")
	;
TCODE(IBTRC)	; -- return type code for entry
	Q $P($G(^IBE(356.11,+$P($G(^IBT(356.2,+$G(IBTRC),0)),"^",4),0)),"^",2)
	;
CONTCT(DA,Y)	; -- screen for type of contact
	; -- called by dic(s) on lookup of type of contact field in 356.2
	;
	;"I ($P(^(0),U,2)>60&('$P(^IBT(356.2,DA,0),U,2)))!($P(^(0),U,2))"
	N IBOK,TCODE S IBOK=1
	S TCODE=$P(^(0),U,2)
	I TCODE=85 S IBOK=0 G CONTQ ;insurance verification from ins menu only
	I TCODE=15 S IBOK=0 G CONTQ ;Admission review only for hosp reviews
	I '$P($G(^IBT(356.2,DA,0)),U,2),TCODE<70 S IBOK=0 G CONTQ ;no tracking id, only patient or other
	I TCODE=60,'$P($G(^IBT(356.2,DA,0)),U,18) S IBOK=0 G CONTQ ;appeals must have an associated parent denial
	S IBTRTP=$$TRTP^IBTRE1($P($G(^IBT(356.2,DA,0)),U,2))
	I IBTRTP>1,TCODE<50 S IBOK=0 ; not inpatient care, not inpt codes
CONTQ	Q IBOK
