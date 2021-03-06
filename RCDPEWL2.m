RCDPEWL2	;ALB/TMK/KML - ELECTRONIC EOB WORKLIST ACTIONS ; 7/7/10 6:43pm
	;;4.5;Accounts Receivable;**173,208,269,298**;Mar 20, 1995;Build 121
	;;Per VA Directive 6402, this routine should not be modified.
	; IA for call to OPTION^IBJTLA = 4121
	; IA for call to ASK^IBRREL = 306
	; IA call for EN1AR^IBECEA = 4047
	; IA call for MAIN^IBOHPT1 = 4048
	; IA for read access to ^IBM(361.1 = 4051
	Q
	;
VP(RCSCR,RCDAZ)	; View/Print EOB Detail data from file 361.1
	; RCSCR = ien of entry in file 344.4
	; RCDAZ = array subscripted by a sequential # and
	;   RCDAZ(n) = one of 3 formats
	;     ERA level adjustments
	;          ADJ^the ien of the adj in 344.42
	;     EOB exists in file 361.1:
	;          ien of line in 344.41^ien of 361.1
	;     EOB doesn't exist in 361.1:
	;          ien of line in 344.41^-1
	;
	N RCDA,%ZIS,ZTRTN,ZTSAVE,ZTDESC,POP
	; Ask device
	S %ZIS="QM" D ^%ZIS G:POP VPQ
	I $D(IO("Q")) D  G VPQ
	. S ZTRTN="VPOUT^RCDPEWL2",ZTDESC="AR - Print EEOB Detail from Worklist"
	. S ZTSAVE("RC*")=""
	. D ^%ZTLOAD
	. W !!,$S($D(ZTSK):"Your task number "_ZTSK_" has been queued.",1:"Unable to queue this job.")
	. K ZTSK,IO("Q") D HOME^%ZIS
	U IO
	;
VPOUT	; Entrypoint for queued job
	N Z,Z0,RCSTOP,RCPG,RCREF,RC3611,RCDASH,RCDT,RC1,RC3444,RCZ,RCZ0
	;
	K ^TMP("PRCA_EOB",$J),^TMP("PRCA_EOB1",$J)
	S RCDT=DT,(RCSTOP,RCPG)=0,RC3444=RCSCR,RCDASH="",$P(RCDASH,"-",71)=""
	I '$O(RCDAZ(0)) G VPQ
	S RCZ=0 F  S RCZ=$O(RCDAZ(RCZ)) Q:'RCZ  D
	. S RCREF=$P(RCDAZ(RCZ),U),RC3611=+$P(RCDAZ(RCZ),U,2)
	. K ^TMP("PRCA_EOB1",$J,RC3611)
	. ;
	. I $E(RCREF,1,3)["ADJ" D  Q
	.. ;Display ERA level adj
	.. S RCZ0=$G(^RCY(344.4,RCSCR,2,RC3611,0))
	.. S ^TMP("PRCA_EOB",$J,"ADJ",1)="ERA LEVEL ADJUSTMENT #"_RC3611
	.. S ^TMP("PRCA_EOB",$J,"ADJ",2)="   ADJUSTMENT REFERENCE #: "_$P(RCZ0,U)
	.. S ^TMP("PRCA_EOB",$J,"ADJ",3)="   ADJUSTMENT REASON CODE: "_$P(RCZ0,U,2)
	.. S ^TMP("PRCA_EOB",$J,"ADJ",4)="        ADJUSTMENT AMOUNT: "_$J(+$P(RCZ0,U,3),"",2)
	.. S ^TMP("PRCA_EOB",$J,"ADJ",5)=RCDASH
	. ;
	. I $P(RCDAZ(RCZ),U,2)'>0 D  Q
	.. ;Display formatted raw data - no EOB data in 361.1
	.. K ^TMP($J,"RC_SUMRAW")
	.. D DISP^RCDPESR0("^RCY(344.4,"_RCSCR_",1,"_+RCDAZ(RCZ)_",1)","^TMP($J,""RC_SUMRAW"")",1,"^TMP(""PRCA_EOB"",$J,0)")
	.. S ^TMP("PRCA_EOB1",$J,RC3611,1)="CLAIM #: "_$$BILLREF^RCDPESR0(RCSCR,+RCDAZ(RCZ))_"*** NOT IDENTIFIED IN A/R ****"_$S($P($G(^RCY(344.4,RCSCR,1,+RCDAZ(RCZ),0)),U,14):" (REVERSAL)",1:"")
	.. K ^TMP($J,"RC_SUMRAW")
	.. S ^TMP("PRCA_EOB",$J,+$O(^TMP("PRCA_EOB",$J,""),-1)+1)=RCDASH
	. ;
	. K ^TMP("PRCA_EOB1",$J,RC3611)
	. S ^TMP("PRCA_EOB1",$J,RC3611,1)="CLAIM #: "_$$BILLREF^RCDPESR0(RCSCR,+RCDAZ(RCZ))_$S($P($G(^RCY(344.4,RCSCR,1,+RCDAZ(RCZ),0)),U,14):" (REVERSAL)",1:"")
	. D GETEOB^IBCECSA6(RC3611,2)
	. I $O(^IBM(361.1,RC3611,"ERR",0)) D GETERR^RCDPEDS(RC3611,+$O(^TMP("PRCA_EOB",$J,RC3611," "),-1)) ; get filing errors
	. S ^TMP("PRCA_EOB",$J,+$O(^TMP("PRCA_EOB",$J,""),-1)+1)=RCDASH
	. ;
	S RC3611="" F  S RC3611=$O(^TMP("PRCA_EOB",$J,RC3611)) Q:RC3611=""!RCSTOP  D
	. S RC1=1
	. S Z0=0 F  S Z0=$O(^TMP("PRCA_EOB",$J,RC3611,Z0)) Q:'Z0  D  Q:RCSTOP
	.. I $D(ZTQUEUED),$$S^%ZTLOAD S (RCSTOP,ZTSTOP)=1 K ZTREQ I +$G(RCPG) W !,"***TASK STOPPED BY USER***" Q
	.. I 'RCPG!(($Y+5)>IOSL) D  I RCSTOP Q
	... D:RCPG ASK(.RCSTOP) I RCSTOP Q
	... D RHDR(RCSCR,RCDT,.RCPG)
	.. I RC1 W !!,$G(^TMP("PRCA_EOB1",$J,RC3611,1)) S RC1=0
	.. W !,$G(^TMP("PRCA_EOB",$J,RC3611,Z0))
	I 'RCSTOP,RCPG D ASK(.RCSTOP)
	;
	I $D(ZTQUEUED) S ZTREQ="@"
	I '$D(ZTQUEUED) D ^%ZISC
	;
VPQ	K ^TMP("PRCA_EOB",$J),^TMP("PRCA_EOB1",$J)
	S VALMBCK="R"
	Q
	;
TPJI	; Jump to Third Party Joint Inquiry for the claim
	D FULL^VALM1
	I $G(RCSCR("NOEDIT"))=2 D NOTAV G TPJIQ
	M ^TMP("RC_SAVE_TMP",$J)=^TMP($J)
	D OPTION^IBJTLA ; IA 4121
	D RESTMP^RCDPEWL6
	;
TPJIQ	S VALMBCK="R"
	Q
	;
FAP	; Jump to Full Account Profile
	D FULL^VALM1
	;
	I $G(RCSCR("NOEDIT"))=2 D NOTAV G FAPQ
	;
	M ^TMP("RC_SAVE_TMP",$J)=^TMP($J)
	D EN^PRCAAPR("ALL"),RET K DTOUT
	D RESTMP^RCDPEWL6
	;
FAPQ	S VALMBCK="R"
	Q
	;
RELHOLD	; Jump to Release Hold function
	N DIR,X,Y,RCDA,RCSCR
	D FULL^VALM1
	;
	I $G(RCSCR("NOEDIT"))=2 D NOTAV G RELHQ
	;
	M ^TMP("RC_SAVE_TMP",$J)=^TMP($J)
	D ^IBRREL,RET ; IA = 306
	D RESTMP^RCDPEWL6
	;
RELHQ	S VALMBCK="R"
	Q
	;
CMRPT	; Jump to claims matching report
	N DIR,X,Y,RCIBY
	D FULL^VALM1
	;
	I $G(RCSCR("NOEDIT"))=2 D NOTAV G CMQ
	;
	M ^TMP("RC_SAVE_TMP",$J)=^TMP($J)
	D ^RCDPRTP,RET
	D RESTMP^RCDPEWL6
	;
CMQ	S VALMBCK="R"
	Q
	;
CHGMNT	; Jump to charge maintenance
	N DIR,X,Y,RCSCR
	D FULL^VALM1
	;
	I $G(RCSCR("NOEDIT"))=2 D NOTAV G CHMQ
	;
	I $D(^XUSEC("PRCA EDI LOCKBOX CHARGES",DUZ)) D
	. M ^TMP("RC_SAVE_TMP",$J)=^TMP($J)
	. D EN1AR^IBECEA ; IA 4047
	. D RESTMP^RCDPEWL6
	E  D
	. S DIR(0)="EA",DIR("A",1)="YOU DO NOT HAVE THE KEY NEEDED TO ACCESS THIS OPTION.",DIR("A")="PRESS RETURN TO CONTINUE " W ! D ^DIR K DIR
	;
	S VALMBCK="R"
CHMQ	Q
	;
LSTHLD	; Jump to list current/on hold charges
	N DIR,X,Y,RCIBY
	D FULL^VALM1
	;
	I $G(RCSCR("NOEDIT"))=2 D NOTAV G LHQ
	;
	M ^TMP("RC_SAVE_TMP",$J)=^TMP($J)
	D MAIN^IBOHPT1,RET ; IA 4048
	D RESTMP^RCDPEWL6
	;
	S VALMBCK="R"
LHQ	Q
	;
REEST	; Jump to re-establish bill
	N PRC
	D FULL^VALM1
	;
	I $G(RCSCR("NOEDIT"))=2 D NOTAV G REESTQ
	;
	M ^TMP("RC_SAVE_TMP",$J)=^TMP($J)
	D ^PRCAWREA K DTOUT
	D RESTMP^RCDPEWL6
	D RET
	;
REESTQ	S VALMBCK="R"
	Q
	;
BILLCOM	; Jump to bill comment log
	D FULL^VALM1
	;
	I $G(RCSCR("NOEDIT"))=2 D NOTAV G BILLCOMQ
	;
	M ^TMP("RC_SAVE_TMP",$J)=^TMP($J)
	D ^PRCACM K DTOUT
	D RET
	D RESTMP^RCDPEWL6
	;
BILLCOMQ	S VALMBCK="R"
	Q
	;
ASK(RCSTOP)	;
	I $E(IOST,1,2)'["C-" Q
	N DIR,DIROUT,DIRUT,DTOUT,DUOUT
	S DIR(0)="E" W ! D ^DIR
	I ($D(DIRUT))!($D(DUOUT)) S RCSTOP=1 Q
	Q
	;
RHDR(RCSCR,RCDT,RCPG)	;Prints EOB detail report heading
	N Z
	S Z=$G(^RCY(344.4,RCSCR,0))
	I RCPG!($E(IOST,1,2)="C-") W @IOF,*13
	S RCPG=RCPG+1
	W !,?15,"EDI LOCKBOX EEOB DETAIL FROM WORKLIST",?55,$$FMTE^XLFDT(RCDT,2),?70,"Page: ",RCPG
	; HIPAA 5010 - TRACE # increased in length from 30 to 50 characters therefore it needs to be displayed on its own line
	W !!,$E(" ERA NUMBER: "_RCSCR_$J("",25),1,25)_"ERA DATE: "_$$FMTE^XLFDT($P(Z,U,4)),!,"INS COMPANY: "_$P(Z,U,6)_"/"_$P(Z,U,3)
	W !,"ERA TRACE #: "_$P(Z,U,2)
	W !,$TR($J("",IOM)," ","=")
	Q
	;
RET	; Pause before returning to list
	N DIR,X,Y
	S DIR(0)="EA",DIR("A")="RETURN TO CONTINUE" W ! D ^DIR K DIR
	Q
	;
NOWAY	; Msg for unidentified bill
	N DIR,X,Y
	S DIR(0)="EA",DIR("A",1)="THIS BILL IS NOT IDENTIFIED IN YOUR A/R",DIR("A")="THIS FUNCTION IS NOT AVAILABLE ... RETURN TO CONTINUE " W ! D ^DIR K DIR
	Q
	;
NOWAY1	; Msg for ERA level Adjustment 
	N DIR,X,Y
	S DIR(0)="EA",DIR("A",1)="THIS IS AN ERA LEVEL ADJUSTMENT - NO DATA EXISTS FOR IT IN YOUR AR",DIR("A")="PRESS ENTER TO CONTINUE" W ! D ^DIR K DIR
	Q
	;
SET1(RCIBY,RCDA,RCDA1,RC3444,RCREF)	; Set up variables for receipt/ERA
	S RCDA1=+RCIBY("IBEOB"),RCDA=+$P(RCIBY("IBEOB"),U,2),RC3444=+$P(RCIBY("IBEOB"),U,3),RCREF=+$P(RCIBY("IBEOB"),U,4)
	Q
	;
CHKFILE	; If the user leaves the split line screen without filing - double check
	; that they didn't want to file it.
	N DIR,X,Y
	D FULL^VALM1 W !!
	I $G(^TMP("RCDPE_EOB_SPLIT_OK",$J)),$O(RCSPLIT(0)) D
	. S DIR(0)="YA",DIR("B")="NO",DIR("A",1)="YOU HAVE NOT FILED THESE CHANGES",DIR("A")="DO YOU WANT TO FILE THEM BEFORE YOU EXIT?: " D ^DIR K DIR
	. I Y=1 D FILESP^RCDPEWL8
	K ^TMP($J,"RCDPE_SPLIT_FILE")
	Q
	;
EDITSP	; Action that edits the split lines
	; RCLINE,RCSCR must already exist
	N DA,RCEDIT,RCDONE,RCDEF,RCSAVE,RCSAVE1
	D FULL^VALM1
	;
	I $G(RCSCR("NOEDIT"))=2 D NOTAV G EDITQ
	;
	D SEL(.RCEDIT)
	G:'RCEDIT EDITQ
	S RCDONE=0
	M RCSAVE=RCSPLIT,RCSAVE1=RCDIR S RCDEF=$G(RCSPLIT(RCEDIT)),RCSPLIT=RCEDIT
	D EDIT^RCDPEWL3(RCSCR,RCLINE,.RCDIR,.RCSPLIT,RCDEF,.RCDONE)
	I '$D(RCSPLIT(RCSAVE)) K RCSPLIT M RCSPLIT=RCSAVE K RCDIR M RCDIR=RCSAVE1
	D INIT^RCDPEWL3
EDITQ	S VALMBCK="R"
	Q
	;
PREOB	; Print/View EOB detail
	N RCDA,RCDAZ,Z,Z0
	D FULL^VALM1
	D SEL^RCDPEWL(.RCDA)
	S RCDA=+$O(RCDA(0)),RCDA=$G(RCDA(RCDA))
	I RCDA="" G PREOBQ
	S RCDA=$P($G(^RCY(344.49,RCSCR,1,+RCDA,0)),U,9)
	F RCDAZ=1:1:$L(RCDA,",") S RCDAZ(RCDAZ)=$P(RCDA,",",RCDAZ)
	S Z=0 F  S Z=$O(RCDAZ(Z)) Q:'Z  D
	. ;
	. S Z0=RCDAZ(Z)
	. I $E(Z0,1,3)="ADJ" D  Q
	.. I $G(^RCY(344.4,RCSCR,2,+$P(Z0,"ADJ",2),0))'="" S RCDAZ(Z)="ADJ^"_+$P(Z0,"ADJ",2)
	. ;
	. S Z0=$G(^RCY(344.4,RCSCR,1,+Z0,0))
	. S RCDAZ(Z)=+Z0_U_$S($P(Z0,U,2):$P(Z0,U,2),1:-1) Q
	;
	D VP(RCSCR,.RCDAZ)
	;
PREOBQ	S VALMBCK="R"
	Q
	;
RESEARCH	; Invoke the research menu
	;
	K ^TMP($J,"RC_VALMBG")
	S ^TMP($J,"RC_VALMBG")=$G(VALMBG)
	D FULL^VALM1
	I $G(RCSCR("NOEDIT"))=2 D NOTAV G RQ
	;
	D EN^VALM("RCDPE EOB RESEARCH")
	;
RQ	K ^TMP($J,"RC_VALMBG")
	Q
	;
SEL(RCEDIT)	;
	N VALMY
	D EN^VALM2($G(XQORNOD(0)),"S")
	S RCEDIT=+$O(VALMY(0))
	Q
	;
EXIT	; Exits back to ERA menu actions from research
	S VALMBCK="Q"
	Q
	;
WL(RCRCPT)	; Entrypoint to the ERA Worklist from Receipt Processing
	;RCRCPT = ien of entry in file 344
	N DIR,X,Y,Z
	D FULL^VALM1
	; if not at ERA summary level (344.4,.08), get a receipt match using the cross-reference at the ERA detail (RECEIPT (344.41, .25) 
	S Z=$S($O(^RCY(344.4,"AREC",RCRCPT,0)):+$O(^RCY(344.4,"AREC",RCRCPT,0)),1:+$O(^RCY(344.4,"H",RCRCPT,0)))
	I 'Z D  G WLQ
	. S DIR("A")="THIS RECEIPT IS NOT ASSOCIATED WITH AN ERA RECORD - PRESS RETURN TO CONTINUE ",DIR(0)="EA" W ! D ^DIR K DIR
	;
	I '$D(^RCY(344.49,Z,0)) D  G WLQ
	. S DIR("A")="NO ERA WORKLIST SCRATCHPAD EXISTS FOR THIS ERA - PRESS RETURN TO CONTINUE ",DIR(0)="EA" W ! D ^DIR K DIR
	;
	D DISP^RCDPEWL(Z,2)
	;
WLQ	S VALMBCK="R"
	Q
	;
NOTAV	; Display not available msg
	N DIR,X,Y
	;
	S DIR(0)="EA",DIR("A")="THIS ACTION NOT CURRENTLY AVAILABLE - PRESS RETURN TO CONTINUE " W ! D ^DIR K DIR
	S VALMBCK="R"
	Q
	;
