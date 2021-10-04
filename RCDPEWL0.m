RCDPEWL0	;ALB/TMK/PJH - ELECTRONIC EOB WORKLIST ACTIONS ;Jun 06, 2014@19:11:19
	;;4.5;Accounts Receivable;**173,208,252,269,298**;Mar 20, 1995;Build 121
	;Per VA Directive 6402, this routine should not be modified.
	Q
	;
PARAMS(SOURCE)	; Retrieve/Edit/Save View Parameters for ERA Worklist
	; Input: SOURCE: "MO" - Menu Option / "CV" - Change View
	;Output: ^TMP("RCERA_PARAMS",$J,"RCPOST"): ERA Posting Status ("P":Posted/"U":Unposted)
	;        ^TMP("RCERA_PARAMS",$J,"RCAUTOP"): Auto-Posting Status ("A":Auto-Posting/"N":Non Auto-Posting/"B":Both)
	;        ^TMP("RCERA_PARAMS",$J,"RCMATCH"): ERA Matching Status ("M":Matched/"U":Unmatched)
	;        ^TMP("RCERA_PARAMS",$J,"RCTYPE"): ERA Claim Type ("M":Medical/"P":Pharmacy/"B":Both)
	;        ^TMP("RCERA_PARAMS",$J,"RCDT")p1: ERA Received EARILIST DATE (Range Limited Only)
	;        ^TMP("RCERA_PARAMS",$J,"RCDT")p2: ERA Received LATEST DATE (Range Limited Only)
	;        ^TMP("RCERA_PARAMS",$J,"RCPAYR")p1: All Payers/Range of Payers ("A": All/"R":Range of Payers)
	;        ^TMP("RCERA_PARAMS",$J,"RCPAYR")p2: START WITH PAYER (e.g.,'AET') (Range Limited Only)
	;        ^TMP("RCERA_PARAMS",$J,"RCPAYR")p3: GO TO PAYER (e.g.,'AETZ') (Range Limited Only)
	;        Or RCQUIT=1
	N DIR,DTOUT,DUOUT,RCAUTOPDF,RCDFR,RCDTO,RCERROR,RCMATCHD,RCPAYR,RCPAYRDF,RCPOSTDF,RCTYPEDF,RCXPAR,X,Y
	;
	S RCQUIT=0
	;
	; Date Range Selection
	I SOURCE="MO" D  I $G(RCQUIT) G PARAMSQ
	. K ^TMP("RCERA_PARAMS",$J) D DTR
	;
	; Retrieving user's saved parameters (If found, Quit)
	I SOURCE="MO" D  I $G(RCXPAR("ERA_POSTING_STATUS"))'="" G PARAMSQ
	. D GETLST^XPAR(.RCXPAR,"USR","RCDPE EDI LOCKBOX WORKLIST","I")
	. S ^TMP("RCERA_PARAMS",$J,"RCPOST")=$S($G(RCXPAR("ERA_POSTING_STATUS"))'="":RCXPAR("ERA_POSTING_STATUS"),1:"U")
	. S ^TMP("RCERA_PARAMS",$J,"RCAUTOP")=$S($G(RCXPAR("ERA_AUTO_POSTING"))'="":RCXPAR("ERA_AUTO_POSTING"),1:"B")
	. S ^TMP("RCERA_PARAMS",$J,"RCMATCH")=$S($G(RCXPAR("ERA-EFT_MATCH_STATUS"))'="":RCXPAR("ERA-EFT_MATCH_STATUS"),1:"B")
	. S ^TMP("RCERA_PARAMS",$J,"RCTYPE")=$S($G(RCXPAR("ERA_CLAIM_TYPE"))'="":RCXPAR("ERA_CLAIM_TYPE"),1:"B")
	. S ^TMP("RCERA_PARAMS",$J,"RCPAYR")=$S($G(RCXPAR("ALL_PAYERS/RANGE_OF_PAYERS"))'="":$TR(RCXPAR("ALL_PAYERS/RANGE_OF_PAYERS"),";","^"),1:"A")
	;
	W !!,"Select parameters for displaying the list of ERAs"
	;
	; ERA Posting Status (Posted/Unposted/Both) Selection
	S RCPOSTDF=$G(^TMP("RCERA_PARAMS",$J,"RCPOST"))
	K DIR S DIR(0)="SA^U:UNPOSTED;P:POSTED;B:BOTH",DIR("A")="ERA POSTING STATUS: (U)NPOSTED, (P)OSTED, OR (B)OTH: "
	S DIR("B")="U" S:RCPOSTDF'="" DIR("B")=RCPOSTDF
	W ! D ^DIR I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 G PARAMSQ
	S ^TMP("RCERA_PARAMS",$J,"RCPOST")=Y
	;
	; ERA Posting Method (Auto-Posting/Non Auto-Posting/Both) Selection
	S RCAUTOPDF=$G(^TMP("RCERA_PARAMS",$J,"RCAUTOP"))
	K DIR S DIR(0)="SA^A:AUTO-POSTING;N:NON AUTO-POSTING;B:BOTH"
	S DIR("A")="DISPLAY (A)UTO-POSTING, (N)ON AUTO-POSTING, OR (B)OTH: "
	S DIR("B")="B" S:RCAUTOPDF'="" DIR("B")=RCAUTOPDF
	W ! D ^DIR I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 G PARAMSQ
	S ^TMP("RCERA_PARAMS",$J,"RCAUTOP")=Y
	;
	; ERA-EFT Matching Status(Matched/Unmatched/Both) Selection
	S RCMATCHD=$G(^TMP("RCERA_PARAMS",$J,"RCMATCH"))
	K DIR S DIR(0)="SA^N:NOT MATCHED;M:MATCHED;B:BOTH"
	S DIR("A")="ERA-EFT MATCH STATUS: (N)OT MATCHED, (M)ATCHED, OR (B)OTH: "
	S DIR("B")="B" S:RCMATCHD'="" DIR("B")=RCMATCHD
	W ! D ^DIR I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 G PARAMSQ
	S ^TMP("RCERA_PARAMS",$J,"RCMATCH")=Y
	;
	; Claim Type (Medical/Pharmacy/Both) Selection
	S RCTYPEDF=$G(^TMP("RCERA_PARAMS",$J,"RCTYPE"))
	K DIR S DIR(0)="SA^M:MEDICAL;P:PHARMACY;B:BOTH"
	s DIR("A")="(M)EDICAL, (P)HARMACY, OR (B)OTH: "
	S DIR("B")="B" S:RCTYPEDF'="" DIR("B")=RCTYPEDF
	W ! D ^DIR I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 G PARAMSQ
	S ^TMP("RCERA_PARAMS",$J,"RCTYPE")=Y
	;
PAYR	; Payer Selection
	S RCPAYRDF=$G(^TMP("RCERA_PARAMS",$J,"RCPAYR"))
	K DIR S RCQUIT=0,DIR(0)="SA^A:ALL;R:RANGE",DIR("A")="(A)LL PAYERS, (R)ANGE OF PAYER NAMES: "
	S DIR("B")="ALL" S:$P(RCPAYRDF,"^")'="" DIR("B")=$P(RCPAYRDF,"^")
	W ! D ^DIR I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 G PARAMSQ
	S RCPAYR=Y I RCPAYR="A" S ^TMP("RCERA_PARAMS",$J,"RCPAYR")=Y
	I RCPAYR="R" D  I RCQUIT K ^TMP("RCERA_PARAMS",$J,"RCPAYR") G PAYR
	. W !,"Names you select here will be the payer names from the ERA, not the ins. file"
	. K DIR S DIR("?")="Enter a name from 1 to 30 characters in UPPER CASE."
	. S DIR(0)="FA^1:30^K:X'?.U X",DIR("A")="START WITH PAYER NAME: "
	. S:$P(RCPAYRDF,"^",2)'="" DIR("B")=$P(RCPAYRDF,"^",2)
	. W ! D ^DIR I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 Q
	. S RCPAYR("FROM")=Y
	. K DIR S DIR("?")="Enter a name from 1 to 30 characters in UPPER CASE."
	. S DIR(0)="FA^1:30^K:X'?.U X",DIR("A")="GO TO PAYER NAME: ",DIR("B")=$E(RCPAYR("FROM"),1,27)_"ZZZ"
	. S:$P(RCPAYRDF,"^",3)'="" DIR("B")=$P(RCPAYRDF,"^",3)
	. W ! D ^DIR I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 Q
	. S ^TMP("RCERA_PARAMS",$J,"RCPAYR")=RCPAYR_"^"_RCPAYR("FROM")_"^"_Y
	;
	; Option to save as User Preferred View
	K DIR W ! S DIR(0)="YA",DIR("B")="NO",DIR("A")="DO YOU WANT TO SAVE THIS AS YOUR PREFERRED VIEW (Y/N)? "
	D ^DIR
	I Y=1 D
	. D EN^XPAR(DUZ_";VA(200,","RCDPE EDI LOCKBOX WORKLIST","ERA_POSTING_STATUS",^TMP("RCERA_PARAMS",$J,"RCPOST"),.RCERROR)
	. D EN^XPAR(DUZ_";VA(200,","RCDPE EDI LOCKBOX WORKLIST","ERA_AUTO_POSTING",^TMP("RCERA_PARAMS",$J,"RCAUTOP"),.RCERROR)
	. D EN^XPAR(DUZ_";VA(200,","RCDPE EDI LOCKBOX WORKLIST","ERA-EFT_MATCH_STATUS",^TMP("RCERA_PARAMS",$J,"RCMATCH"),.RCERROR)
	. D EN^XPAR(DUZ_";VA(200,","RCDPE EDI LOCKBOX WORKLIST","ERA_CLAIM_TYPE",^TMP("RCERA_PARAMS",$J,"RCTYPE"),.RCERROR)
	. D EN^XPAR(DUZ_";VA(200,","RCDPE EDI LOCKBOX WORKLIST","ALL_PAYERS/RANGE_OF_PAYERS",$TR(^TMP("RCERA_PARAMS",$J,"RCPAYR"),"^",";"),.RCERROR)
	;
PARAMSQ	; Quit
	Q
	;
DTR	; Date Range Selection
	N DIR,DTOUT,DUOUT,Y,FROM,TO,RCDTRNG
	S ^TMP("RCERA_PARAMS",$J,"RCDT")="0^"_DT
	K DIR S DIR(0)="YA",DIR("A")="LIMIT THE SELECTION TO A DATE RANGE WHEN THE ERA WAS RECEIVED?: "
	S RCQUIT=0,DIR("B")="NO"
	W ! D ^DIR I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 Q
	I Y D  I $G(RCQUIT) G DTR
	. S FROM=$P($G(^TMP("RCERA_PARAMS",$J,"RCDT")),"^",1),TO=$P($G(^TMP("RCERA_PARAMS",$J,"RCDT")),"^",2)
	. W ! S RCDTRNG=$$DTRANGE(FROM,TO) I RCDTRNG="^" S RCQUIT=1 Q
	. S ^TMP("RCERA_PARAMS",$J,"RCDT")=RCDTRNG
	Q
	;
DTRANGE(DEFFROM,DEFTO)	; Asks for and returns a Date Range
	; Input: DEFFROM - Default FROM date
	;        DEFTO   - Default TO date
	;Output: From_Date^To_Date (YYYMMDD^YYYDDMM) or "^" (timeout or ^ entered)
	;
	N DIR,Y,DTOUT,DUOUT,RCDFR
	S RCQUIT=0 S DIR(0)="DAE^:"_DT_":E",DIR("A")="EARLIEST DATE: " S:($G(DEFFROM)) DIR("B")=$$FMTE^XLFDT(DEFFROM,2) D ^DIR
	I $D(DTOUT)!$D(DUOUT) Q "^"
	S RCDFR=Y
	K DIR S DIR(0)="DAE^"_RCDFR_":"_DT_":E",DIR("A")="LATEST DATE: " S:($G(DEFTO)) DIR("B")=$$FMTE^XLFDT(DEFTO,2) D ^DIR
	I $D(DTOUT)!$D(DUOUT) Q "^"
	Q (RCDFR_"^"_Y)
	;
FILTER(IEN344P4)	; Returns 1 if record in entry IEN344P4 in 344.4 passes
	; the edits for the worklist selection of ERAs
	; Parameters found in ^TMP("RCERA_PARAMS",$J)
	N OK,RCPOST,RCAUTOP,RCMATCH,RCTYPE,RCDFR,RCDTO,RCPAYFR,RCPAYTO,RCPAYR,RC0,RC4
	S OK=1,RC0=$G(^RCY(344.4,IEN344P4,0)),RC4=$G(^RCY(344.4,IEN344P4,4))
	;
	S RCMATCH=$G(^TMP("RCERA_PARAMS",$J,"RCMATCH")),RCPOST=$G(^TMP("RCERA_PARAMS",$J,"RCPOST"))
	S RCAUTOP=$G(^TMP("RCERA_PARAMS",$J,"RCAUTOP")),RCTYPE=$G(^TMP("RCERA_PARAMS",$J,"RCTYPE"))
	S RCDFR=+$P($G(^TMP("RCERA_PARAMS",$J,"RCDT")),U),RCDTO=+$P($G(^TMP("RCERA_PARAMS",$J,"RCDT")),U,2)
	S RCPAYR=$P($G(^TMP("RCERA_PARAMS",$J,"RCPAYR")),U),RCPAYFR=$P($G(^TMP("RCERA_PARAMS",$J,"RCPAYR")),U,2),RCPAYTO=$P($G(^TMP("RCERA_PARAMS",$J,"RCPAYR")),U,3)
	;
	; If receipt exists, scratchpad must exist
	;I $P(RC0,U,8),'$D(^RCY(344.49,+IEN344P4,0)) S OK=0 G FQ
	; Post status
	I $S(RCPOST="B":0,RCPOST="U":$P(RC0,U,14),1:'$P(RC0,U,14)) S OK=0 G FQ
	; Auto-Posting status
	I $S(RCAUTOP="B":0,RCAUTOP="A":($P(RC4,U,2)=""),1:($P(RC4,U,2)'="")) S OK=0 G FQ
	; Match status
	I $S(RCMATCH="B":0,RCMATCH="N":$P(RC0,U,9),1:'$P(RC0,U,9)) S OK=0 G FQ
	; Medical/Pharmacy Claim
	I $S(RCTYPE="B":0,RCTYPE="M":$$PHARM^RCDPEWLP(IEN344P4),1:'$$PHARM^RCDPEWLP(IEN344P4)) S OK=0 G FQ
	; dt rec'd range
	I $S(RCDFR=0:0,1:$P(RC0,U,7)\1<RCDFR) S OK=0 G FQ
	I $S(RCDTO=DT:0,1:$P(RC0,U,7)\1>RCDTO) S OK=0 G FQ
	; Payer name
	I RCPAYR'="A" D  G:'OK FQ
	. N Q
	. S Q=$$UP^RCDPEARL($P(RC0,U,6))
	. I $S(Q=RCPAYFR:1,Q=RCPAYTO:1,Q]RCPAYFR:RCPAYTO]Q,1:0) Q
	. S OK=0
	;
FQ	Q OK
	;
SPLIT	; Split line in ERA list
	; input - RCSCR = ien of 344.49 and 344.4
	N RCLINE,RCZ,RCDA,Q,Q0,Z,Z0,DIR,X,Y,CT,L,L1,RCONE,RCQUIT
	D FULL^VALM1
	I $S($P($G(^RCY(344.4,RCSCR,4)),U,2)]"":1,1:0) D NOEDIT^RCDPEWLP G SPLITQ   ;prca*4.5*298  auto-posted ERAs cannot enter Split/Edit action
	I $G(RCSCR("NOEDIT")) D NOEDIT^RCDPEWL G SPLITQ
	W !!,"SELECT THE ENTRY THAT HAS A LINE YOU NEED TO SPLIT/EDIT",!
	D SEL^RCDPEWL(.RCDA)
	S Z=+$O(RCDA(0)) G:'$G(RCDA(Z)) SPLITQ
	S RCLINE=+RCDA(Z),Z0=+$O(^TMP("RCDPE-EOB_WLDX",$J,Z_".999"),-1)
	S RCZ=Z F  S RCZ=$O(^TMP("RCDPE-EOB_WLDX",$J,RCZ)) Q:'RCZ!(RCZ\1'=Z)  D
	. S Q=$P($G(^TMP("RCDPE-EOB_WLDX",$J,RCZ)),U,2)
	. Q:'Q
	. S RCZ(RCZ)=Q
	. S Q0=0 F  S Q0=$O(^RCY(344.49,RCSCR,1,Q,1,Q0)) Q:'Q0  I "01"[$P($G(^(Q0,0)),U,2) K RCZ(RCZ) Q
	I '$O(RCZ(0)) D  G SPLITQ
	. S DIR(0)="EA",DIR("A",1)="THIS ENTRY HAS NO LINES AVAILABLE TO EDIT/SPLIT",DIR("A")="PRESS RETURN TO CONTINUE " W ! D ^DIR K DIR
	S RCQUIT=0
	I $P($G(^RCY(344.49,RCSCR,1,RCLINE,0)),U,13) D  G:RCQUIT SPLITQ
	. S DIR("A",1)="WARNING!  THIS LINE HAS ALREADY BEEN VERIFIED",DIR("A")="ARE YOU SURE YOU WANT TO CONTINUE?: ",DIR(0)="YA",DIR("B")="NO" W ! D ^DIR K DIR
	. I Y'=1 S RCQUIT=1
	S CT=0,CT=CT+1,DIR("?",CT)="Enter the line # that you want to split or edit:",RCONE=1
	S L=Z F  S L=$O(RCZ(L)) Q:'L  D
	. S L1=+$G(^TMP("RCDPE-EOB_WLDX",$J,L))
	. S CT=CT+1
	. S DIR("?",CT)=$G(^TMP("RCDPE-EOB_WL",$J,L1,0)),CT=CT+1,DIR("?",CT)=$G(^TMP("RCDPE-EOB_WL",$J,L1+1,0)) S RCONE(1)=$S(RCONE:L,1:"") S RCONE=0
	S DIR("?")=" ",Y=-1
	I $G(RCONE(1)) S Y=+RCONE(1) K DIR G:'Y SPLITQ
	I '$G(RCONE(1)) D  K DIR I $D(DTOUT)!$D(DUOUT)!(Y\1'=Z) G SPLITQ
	. F  S DIR(0)="NAO^"_(Z+.001)_":"_Z0_":3",DIR("A")="WHICH LINE OF ENTRY "_Z_" DO YOU WANT TO SPLIT/EDIT?: " S:$G(RCONE(1))'="" DIR("B")=RCONE(1) D ^DIR Q:'Y!$D(DUOUT)!$D(DTOUT)  D  Q:Y>0
	.. I '$D(^TMP("RCDPE-EOB_WLDX",$J,Y)) W !!,"LINE "_Y_" DOES NOT EXIST - TRY AGAIN",! S Y=-1 Q
	.. I '$D(RCZ(Y)) W !!,"LINE "_Y_" HAS BEEN USED IN A DISTRIBUTE ADJ ACTION AND CAN'T BE EDITED",! S Y=-1 Q
	.. S Q=+$O(^RCY(344.49,RCSCR,1,"B",Y,0))
	;
	K ^TMP("RCDPE_SPLIT_REBLD",$J)
	D SPLIT^RCDPEWL3(RCSCR,+Y)
	I $G(^TMP("RCDPE_SPLIT_REBLD",$J)) K ^TMP("RCDPE_SPLIT_REBLD",$J) D BLD^RCDPEWL1($G(^TMP($J,"RC_SORTPARM")))
	;
SPLITQ	S VALMBCK="R"
	Q
	;
PRTERA	; View/prt
	N DIC,X,Y,RCSCR
	S DIC="^RCY(344.4,",DIC(0)="AEMQ" D ^DIC
	Q:Y'>0
	S RCSCR=+Y
	D PRERA1
	Q
	;
PRERA	; RCSCR is assumed to be defined
	D FULL^VALM1 ; Protocol entry
PRERA1	; Option entry
	N %ZIS,ZTRTN,ZTSAVE,ZTDESC,POP,DIR,X,Y,RCERADET
	D EXCWARN^RCDPEWLP(RCSCR)
	S DIR("?",1)="INCLUDING EXPANDED DETAIL WILL SIGNIFICANTLY INCREASE THE SIZE OF THIS REPORT",DIR("?",2)="IF YOU CHOOSE TO INCLUDE IT, ALL PAYMENT DETAILS FOR EACH EEOB WILL BE"
	S DIR("?")="LISTED.  IF YOU WANT JUST SUMMARY DATA FOR EACH EEOB, DO NOT INCLUDE IT."
	S DIR(0)="YA",DIR("A")="DO YOU WANT TO INCLUDE EXPANDED EEOB DETAIL?: ",DIR("B")="NO" W ! D ^DIR K DIR
	I $D(DUOUT)!$D(DTOUT) G PRERAQ
	S RCERADET=+Y
	S %ZIS="QM" D ^%ZIS G:POP PRERAQ
	I $D(IO("Q")) D  G PRERAQ
	. S ZTRTN="VPERA^RCDPEWL0("_RCSCR_","_RCERADET_")",ZTDESC="AR - Print ERA From Worklist"
	. D ^%ZTLOAD
	. W !!,$S($D(ZTSK):"Your task # "_ZTSK_" has been queued.",1:"Unable to queue this job.")
	. K ZTSK,IO("Q") D HOME^%ZIS
	U IO
	D VPERA(RCSCR,RCERADET)
	Q
	;
VPERA(RCSCR,RCERADET)	; Queued entry
	; RCSCR = ien of entry in file 344.4
	; RCERADET = 1 if inclusion of all EOB details from file 361.1 is
	;  desired, 0 if not
	N Z,Z0,RCSTOP,RCZ,RCPG,RCDOT,RCDIQ,RCDIQ1,RCDIQ2,RCXM1,RC,RCSCR1,RC3611
	K ^TMP($J,"RC_SUMRAW"),^TMP($J,"RC_SUMOUT"),^TMP($J,"RC_SUMALL")
	S (RCSTOP,RCPG)=0,RCDOT="",$P(RCDOT,".",79)=""
	D GETS^DIQ(344.4,RCSCR_",","*","IEN","RCDIQ")
	D TXT0^RCDPEX31(RCSCR,.RCDIQ,.RCXM1,.RC) ; Get top level 0-node captioned flds
	I $O(^RCY(344.4,RCSCR,2,0)) S RC=RC+1,RCXM1(RC)="  **ERA LEVEL ADJUSTMENTS**"
	S RCSCR1=0 F  S RCSCR1=$O(^RCY(344.4,RCSCR,2,RCSCR1)) Q:'RCSCR1  D
	. K RCDIQ2
	. D GETS^DIQ(344.42,RCSCR1_","_RCSCR_",","*","IEN","RCDIQ2")
	. D TXT2^RCDPEX31(RCSCR,RCSCR1,.RCDIQ2,.RCXM1,.RC) ; Get top level ERA adjs
	S RCSCR1=0 F  S RCSCR1=$O(^RCY(344.4,RCSCR,1,RCSCR1)) Q:'RCSCR1  D
	. K RCDIQ1
	. D GETS^DIQ(344.41,RCSCR1_","_RCSCR_",","*","IE","RCDIQ1")  ;PRCA*4.5*298  need to retrieve all fields even if null  (changed "IEN" to "IE")
	. D TXT00^RCDPEX31(RCSCR,RCSCR1,.RCDIQ1,.RCXM1,.RC)
	. ;HIPAA 5010
	. N PNAME4
	. S PNAME4=$$PNM4^RCDPEWL1(RCSCR,RCSCR1)
	. I $L(PNAME4)<32 D
	. .S RC=RC+1,RCXM1(RC-1)=$E("PATIENT: "_PNAME4_$J("",41),1,41)_"CLAIM #: "_$$BILLREF^RCDPESR0(RCSCR,RCSCR1),RCXM1(RC)=" "
	. I $L(PNAME4)>31 D
	. .S RC=RC+1,RCXM1(RC-1)=$J("",41)_"CLAIM #: "_$$BILLREF^RCDPESR0(RCSCR,RCSCR1)
	. .S RC=RC+1,RCXM1(RC-1)=$E("PATIENT: "_PNAME4,1,78),RCXM1(RC)=" "
	. D PROV^RCDPEWLD(RCSCR,RCSCR1,.RCXM1,.RC)
	. S RC3611=$P($G(^RCY(344.4,RCSCR,1,RCSCR1,0)),U,2)
	. I RCERADET D
	.. I 'RC3611 D  Q
	... D DISP^RCDPESR0("^RCY(344.4,"_RCSCR_",1,"_RCSCR1_",1)","^TMP($J,""RC_SUMRAW"")",1,"^TMP($J,""RC_SUMOUT"")",75,1)
	..;
	.. E  D  ; Detail record is in 361.1
	... K ^TMP("PRCA_EOB",$J)
	... D GETEOB^IBCECSA6(RC3611,2)
	... I $O(^IBM(361.1,RC3611,"ERR",0)) D GETERR^RCDPEDS(RC3611,+$O(^TMP("PRCA_EOB",$J,RC3611," "),-1)) ; get filing errors
	... S Z=0 F  S Z=$O(^TMP("PRCA_EOB",$J,RC3611,Z)) Q:'Z  S RC=RC+1,^TMP($J,"RC_SUMOUT",RC)=$G(^TMP("PRCA_EOB",$J,RC3611,Z))
	... S RC=RC+2,^TMP($J,"RC_SUMOUT",RC-1)=" ",^TMP($J,"RC_SUMOUT",RC)=" "
	... K ^TMP("PRCA_EOB",$J)
	. I $D(RCDIQ1(344.41,RCSCR1_","_RCSCR_",",2)) D
	.. S RC=RC+1,RCXM1(RC)="  **EXCEPTION RESOLUTION LOG DATA**"
	.. S Z=0 F  S Z=$O(RCDIQ1(344.41,RCSCR1_","_RCSCR_",",2,Z)) Q:'Z  S RC=RC+1,RCXM1(RC)=RCDIQ1(344.41,RCSCR1_","_RCSCR_",",2,Z)
	. S RC=RC+1,RCXM1(RC)=" "
	. S Z0=+$O(^TMP($J,"RC_SUMALL"," "),-1)
	. S Z=0 F  S Z=$O(RCXM1(Z)) Q:'Z  S Z0=Z0+1,^TMP($J,"RC_SUMALL",Z0)=RCXM1(Z)
	. K RCXM1 S RC=0
	. S Z=0 F  S Z=$O(^TMP($J,"RC_SUMOUT",Z)) Q:'Z  S Z0=Z0+1,^TMP($J,"RC_SUMALL",Z0)=$G(^TMP($J,"RC_SUMOUT",Z))
	S RCSTOP=0,Z=""
	F  S Z=$O(^TMP($J,"RC_SUMALL",Z)) Q:'Z  D  Q:RCSTOP
	. I $D(ZTQUEUED),$$S^%ZTLOAD S (RCSTOP,ZTSTOP)=1 K ZTREQ I +$G(RCPG) W !!,"***TASK STOPPED BY USER***" Q
	. I 'RCPG!(($Y+5)>IOSL) D  I RCSTOP Q
	.. D:RCPG ASK(.RCSTOP) I RCSTOP Q
	.. D HDR(.RCPG)
	. W !,$G(^TMP($J,"RC_SUMALL",Z))
	;
	I 'RCSTOP,RCPG D ASK(.RCSTOP)
	;
	I $D(ZTQUEUED) S ZTREQ="@"
	I '$D(ZTQUEUED) D ^%ZISC
	;
PRERAQ	K ^TMP($J,"RC_SUMRAW"),^TMP($J,"RC_SUMOUT"),^TMP($J,"SUMALL")
	S VALMBCK="R"
	Q
	;
HDR(RCPG)	;Report hdr
	; RCPG = last page #
	I RCPG!($E(IOST,1,2)="C-") W @IOF,*13
	S RCPG=$G(RCPG)+1
	W !,?5,"EDI LOCKBOX WORKLIST - ERA DETAIL",?55,$$FMTE^XLFDT(DT,2),?70,"Page: ",RCPG,!,$TR($J("",IOM)," ","=")
	Q
	;
ASK(RCSTOP)	;
	I $E(IOST,1,2)'["C-" Q
	N DIR,DIROUT,DIRUT,DTOUT,DUOUT
	S DIR(0)="E" W ! D ^DIR
	I ($D(DIRUT))!($D(DUOUT)) S RCSTOP=1 Q
	Q
	;