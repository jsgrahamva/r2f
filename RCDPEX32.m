RCDPEX32	;ALB/TMK - ELECTRONIC EOB EXCEPTION PROCESSING - FILE 344.4 ;Aug 14, 2014@16:27:32
	;;4.5;Accounts Receivable;**173,249,298**;Mar 20, 1995;Build 121
	;Per VA Directive 6402, this routine should not be modified.
	;
EDITNUM	; Edit invalid claim # to valid, refile EOB
	N RC,RC0,RCDA,RCXDA,RCXDA1,RCSAVE,RCEOB,RCWARN,Q,Q0,DA,DR,DIE,DIC,DIR,DTOUT,DIRUT,X,Y,RCBILL,RCCHG,RCSUSP,RCQUIT,RCDONE
	D FULL^VALM1
	D SEL^RCDPEX3(.RCDA)
	G:'$O(RCDA(0)) EDITNQ
	;
	S RC=0 F  S RC=$O(RCDA(RC)) Q:'RC  D  L -^RCY(344.4,RCXDA1,1,RCXDA,0)
	. S RCXDA1=+RCDA(RC),RCXDA=+$P(RCDA(RC),U,2),RCSAVE=""
	. I '$$LOCK^RCDPEX31(RCXDA1,RCXDA,1) D  Q
	.. S DIR(0)="EA",DIR("A",1)="**Selection #"_RC_" is being edited by another user - ... please try again later",DIR("A")="PRESS RETURN TO CONTINUE" D ^DIR K DIR
	. S RC0=$G(^RCY(344.4,RCXDA1,1,RCXDA,0))
	. I $P(RC0,U,5)="" D  Q
	.. S DIR(0)="EA",DIR("A",1)="The claim for selection #"_RC_" can't be edited as the bill # is not invalid",DIR("A")="PRESS RETURN TO CONTINUE" D ^DIR K DIR
	. I $P(RC0,U,9) D  Q
	.. S DIR(0)="EA",DIR("A",1)="The claim for selection #"_RC_" can't be edited as the claim has already",DIR("A")="been transferred to another site - PRESS RETURN TO CONTINUE" W ! D ^DIR K DIR
	. ;
	. I $D(^RCY(344.49,RCXDA1)) D
	.. N X
	.. S X=$G(^RCY(344,+$P($G(^RCY(344.49,RCXDA1,0)),U,2),0))
	.. W !!,*7,"Warning: EEOB Worklist entry #"_RCXDA1_$S($P(X,U)'="":" and receipt "_$P(X,U),1:"")_" exist for this EEOB"
	.. I X="" W !,"You should refresh the worklist entry to include the new claim #",!," before creating the receipt",!
	. I $P($G(^RCY(344.4,RCXDA1,0)),U,8) D
	.. W !,"Since the receipt for this EEOB ("_$P($G(^RCY(344,+$P($G(^RCY(344.4,RCXDA1,0)),U,8),0)),U)_") already exists"
	.. I '$P($G(^RCY(344,+$P($G(^RCY(344.4,RCXDA1,0)),U,8),0)),U,14) W !," and is closed, you will need to use link payment to apply the payment",!," to the correct account",! Q
	.. W !," you should edit the receipt and change the claim # so it posts to the",!," correct account",!
	. ;
	. I $P(RC0,U,17)="" S RCSAVE=$P(RC0,U,5)
	. W !,"Selection #: "_RC_$J("",5)_$P(RC0,U,5)
	. S (RCQUIT,RCDONE)=0
	. F  D  Q:RCQUIT!RCDONE
	.. K DIR
	.. S DIR("?",1)="Answer with ACCOUNTS RECEIVABLE BILL NO., or PATIENT, or DEBTOR, or"
	.. S DIR("?")="    TOP REFUND STATUS, or FMS TRANSMISSION DATE"
	.. S DIR(0)="FAO^1:15",DIR("A")="Select A/R Bill this EEOB is actually paying on: "
	.. D ^DIR I $D(DIRUT)!$D(DTOUT) S RCQUIT=1 Q
	.. S DIC="^PRCA(430,",DIC(0)="EM",DIC("S")="I $D(^DGCR(399,+Y,0))" W ! D ^DIC I X="^" S RCQUIT=1 Q
	.. S RCSUSP=X
	.. I '(Y>0) D  Q:RCQUIT
	... S DIR("A")="   THIS CLAIM WAS NOT FOUND IN YOUR AR.  DO YOU WANT TO CONTINUE?: "
	... S DIR("B")="NO",DIR(0)="YA" D ^DIR K DIR W ! I $D(DIRUT)!$D(DTOUT) S RCQUIT=1 Q
	... I Y=1 S RCBILL=0,RCBILL(1)=RCSUSP,RCWARN=0,RCDONE=1
	.. E  D
	... S RCBILL=+Y,RCBILL(1)=$P($G(^PRCA(430,RCBILL,0)),U),RCWARN=0,RCDONE=1
	. Q:RCQUIT
	. I $P($G(^RCY(344.4,RCXDA1,0)),U,14) S RCWARN=RCWARN+1,DIR("A",RCWARN+1)=$J("",4)_"THE RECEIPT FOR THIS EEOB HAS ALREADY BEEN POSTED."
	. I RCBILL>0,$P($G(^PRCA(430.3,+$P($G(^PRCA(430,RCBILL,0)),U,8),0)),U,3)'=102 S RCWARN=RCWARN+1,DIR("A",RCWARN+1)=$J("",4)_"THIS IS NOT AN ACTIVE ACCOUNTS RECEIVABLE."
	. I RCWARN>0 D  I Y'=1 Q
	.. S DIR("A",1)="** WARNING"_$S(RCWARN>1:"S",1:"")_":"
	.. S DIR("A",RCWARN+2)=" "
	.. S DIR(0)="YA",DIR("A")="ARE YOU SURE YOU WANT TO FILE THIS EEOB FOR CLAIM #: "_RCBILL(1)_"?: ",DIR("B")="NO" W ! D ^DIR K DIR
	.. ;
	. ; File EOB for new claim #
	. K ^TMP($J,"RCDP-EOB"),^TMP($J,"RCDPEOB","HDR")
	. S Q=0 F  S Q=$O(^RCY(344.4,RCXDA1,1,RCXDA,1,Q)) Q:'Q  S Q0=$G(^(Q,0)) D
	.. I $P(Q0,U)["835ERA" S ^TMP($J,"RCDPEOB","HDR")=Q0
	.. I $P(Q0,U,2)=$P(RC0,U,5) S $P(Q0,U,2)=RCBILL(1)
	.. S ^TMP($J,"RCDP-EOB",1,Q,0)=Q0
	. S ^TMP($J,"RCDP-EOB",1,.5,0)="835ERA"
	. S RCEOB=0 I RCBILL>0 S RCEOB=$$DUP^IBCEOB("^TMP("_$J_",""RCDP-EOB"",1)",RCBILL) ; IA 4042
	. K ^TMP($J,"RCDP-EOB",1,.5,0)
	. I RCEOB D  Q
	.. N RCWHY S RCWHY(1)="EEOB already found on file while trying to change claim # and filing into IB"
	.. D STORACT^RCDPEX31(RCXDA1,RCXDA,.RCWHY)
	.. S RCCHG=1,DA(1)=RCXDA1,DA=RCXDA D CHGED(.DA,RCEOB,RCSAVE,.RCBILL)
	.. S DIR(0)="E"
	.. S DIR("A",1)="EEOB detail is already on file for "_RCBILL(1)_" - Exception removed",DIR("A")="PRESS RETURN TO CONTINUE" D ^DIR K DIR
	. ;
	. ; Add stub rec to 361.1 if not there
	. I RCBILL>0 S RCEOB=+$$ADD3611^IBCEOB(+$P($G(^RCY(344.4,RCXDA1,0)),U,12),"","",RCBILL,1,"^TMP("_$J_",""RCDP-EOB"",1)") ; IA 4042
	. ;
	. I RCEOB<0 D  Q
	.. N RCWHY S RCWHY(1)="Error encountered trying to change claim # and file into IB"
	.. D STORACT^RCDPEX31(RCXDA1,RCXDA,.RCWHY)
	.. S DIR("A")="EA",DIR("A",1)="Error - EEOB detail not added to IB for bill "_RCBILL(1),DIR("A")="PRESS RETURN TO CONTINUE" D ^DIR K DIR
	. ;
	. ; Update EOB in file 361.1
	. ; Call needs ^TMP arrays: $J,"RCDPEOB","HDR" and $J,"RCDP-EOB"
	. I RCEOB>0 D
	.. D UPD3611^IBCEOB(RCEOB,1,1) ; IA 4042
	.. ; errors in ^TMP("RCDPERR-EOB",$J
	.. I $O(^TMP("RCDPERR-EOB",$J,0)) D
	... D ERRUPD^IBCEOB(RCEOB,"RCDPERR-EOB") ; Adds error msgs to IB file 361.1 ; IA 4042
	. ;
	. S RCCHG=1
	. N RCWHY S RCWHY(1)="EEOB claim # changed and filed into IB under new claim #"
	. D STORACT^RCDPEX31(RCXDA1,RCXDA,.RCWHY)
	. S DA(1)=RCXDA1,DA=RCXDA
	. D CHGED(.DA,RCEOB,RCSAVE,.RCBILL)
	. S DIE="^RCY(344.4,"_DA(1)_",1,",DR="1///@" D ^DIE
	. S DIR("A",1)="EEOB Filed. "_$S(RCBILL>0:"Its detail may be viewed using Third Party Joint Inquiry.",1:"")
	. S DIR("A")="PRESS RETURN TO CONTINUE ",DIR(0)="EA"
	. W ! D ^DIR K DIR
	. S VALMBG=1
	;
EDITNQ	I $G(RCCHG) D BLD^RCDPEX2
	K ^TMP($J,"RCDP-EOB"),^TMP($J,"RCDPEOB","HDR"),^TMP("RCDPERR-EOB",$J)
	S VALMBCK="R"
	Q
	;
CHGED(DA,RCEOB,RCSAVE,RCBILL)	;  Update Invalid Bill # for EOB
	; DA = DA and DA(1) to use for DIE call
	; RCEOB = the ien of the entry in file 361.1
	; RCSAVE = the free text of the original bill #
	; RCBILL = Array containing Bill Information
	N DIE,DR,X,Y,INVBILL
	S INVBILL="@" I +$G(RCBILL)=0 S INVBILL=$G(RCBILL(1))
	S DIE="^RCY(344.4,"_DA(1)_",1,",DR=".05///"_INVBILL_";.02////"_RCEOB_";.13////1"_$S(RCSAVE'="":";.17////"_RCSAVE,1:"")_";.07///@" D ^DIE
	Q
	;
EDITRXC	; Edit pharmacy comment - PRCA*4.5*298
	N DA,DIC,DIE,DIR,DR,Q,Q0,RC,RC0,RCBILL,RCDA,RCDSEL,RCEOB,RCSAVE,RCWARN,RCXDA,RCXDA1,X,Y
	D FULL^VALM1
	D SEL^RCDPEX3(.RCDA)
	;Only allow action if the selected exception has an ECME number
	S RCDSEL=$O(RCDA(0)) D:RCDSEL
	.N IENS,RCRXNO,RCRLSDT   ; IENS for FileMan, Rx number, Rx release date
	.S IENS=$P(RCDA(RCDSEL),U,2)_","_$P(RCDA(RCDSEL),U,1)_","
	.S RCRXNO=$$GET1^DIQ(344.41,IENS,.24) I RCRXNO=""  D  Q
	..W !,"Comment not allowed. This is not a pharmacy exception." D WAIT^VALM1
	.;
	.; IA #4701, RELEASE DATE for the prescription/fill
	.S RCRLSDT=$$RXRLDT^PSOBPSUT(RCRXNO)   ; get release date
	.I RCRLSDT]"" D  Q
	..W !!,"Release Date: "_$$FMTE^XLFDT(RCRLSDT)
	..W !,"Comment not allowed for Rx with Release Date." D WAIT^VALM1
	.;
	.;Display sequence and INVALID BILL NUMBER
	.W !,"Selection #: ",RCDSEL,"     ",$$GET1^DIQ(344.41,IENS,.05)
	.;Allow edit of pharmacy comment
	.S DIE="^RCY(344.4,"_$P(RCDA(RCDSEL),U,1)_",1,",DA=$P(RCDA(RCDSEL),U,2),DA(1)=$P(RCDA(RCDSEL),U,1),DR="9.01Comment" D ^DIE Q:$D(DUOUT)!$D(DTOUT)
	.D WAIT^VALM1,BLD^RCDPEX2
	;
	K ^TMP($J,"RCDP-EOB"),^TMP($J,"RCDPEOB","HDR"),^TMP("RCDPERR-EOB",$J)
	S VALMBCK="R"
	Q
	;
