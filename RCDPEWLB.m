RCDPEWLB	;ALB/TMK - EEOB WORKLIST BATCH PROCESSING ;Jun 06, 2014@19:11:19
	;;4.5;Accounts Receivable;**208,298**;Mar 20, 1995;Build 121
	;Per VA Directive 6402, this routine should not be modified.
	;
SETBATCH(RCERA)	; Set up batches for a worklist entry RCERA
	; Returns ^TMP($J,"BATCHES",batch criteria code,start param data)=
	;              batch #^end param data
	; Ask to split the ERA
	; prca*4.5*298 per requirements, keep code for creating/maintaining batches but remove from execution
	Q  ;prca*4.5*298 
	N DIR,DTOUT,DUOUT,RCBAT,RCNAMES,RCNUM,RCS,RCSEL,RCY,RCZ,X,Y,Z,Z0
	K ^TMP($J,"BATCHES")
	S RCNUM=+$$CTEEOB(RCERA)
	Q:RCNUM'>1
	S DIR("A",1)="THERE ARE APPROXIMATELY "_RCNUM_" EEOBS IN THIS ERA",DIR("A")="DO YOU WANT TO SPLIT THIS ERA INTO BATCHES?: ",DIR(0)="YA",DIR("B")=$S(RCNUM>30:"YES",1:"NO") W ! D ^DIR K DIR
	I Y'=1 Q
	;
	S DIR("A",1)="YOU MAY USE ANY ONE OF THE FOLLOWING CRITERIA TO SPLIT THE ERA INTO BATCHES: ",DIR("A",2)=" ",DIR("A",3)=$J("",10)_"1 - BY MAX # OF EEOBs TO INCLUDE IN A BATCH"
	S DIR("A",4)=$J("",10)_"2 - BY RANGES OF PATIENT LAST NAME",DIR("A",5)=$J("",10)_"3 - BY EEOB PAYMENT STATUS (FULL/PARTIAL/NO PAY)"
	S DIR("A",6)=$J("",10)_"4 - BY CO-PAY AND NON-COPAY FOR THE DATE OF SERVICE",DIR("A",7)=" "
	S DIR(0)="SAO^1:MAX #;2:LAST NAME;3:PAY STATUS;4:CO-PAY STATUS",DIR("A")="CRITERIA SELECTION: "
	W !! D ^DIR K DIR
	Q:$D(DUOUT)!$D(DTOUT)!(Y="")
	S RCBAT=0,RCSEL=Y,^TMP($J,"BATCHES")=RCSEL
	S DIR(0)="YA",DIR("A")="DO YOU WANT TO NAME YOUR OWN BATCHES?: ",DIR("B")="NO" W ! D ^DIR K DIR
	Q:$D(DUOUT)!$D(DTOUT)
	S RCNAMES=+Y
	I RCSEL=1 D
	. W ! S DIR(0)="NA^1:"_RCNUM,DIR("A")="MAX # OF EEOBS TO INCLUDE IN A BATCH: ",DIR("?")="ENTER A NUMBER FROM 1 TO "_RCNUM D ^DIR K DIR
	. I $D(DTOUT)!$D(DUOUT) Q
	. S RCY=Y
	. F RCZ=1:1:RCNUM\RCY+$S(RCNUM#RCY:1,1:0) S RCS=((RCZ-1)*RCY)+1 D NEWBAT(RCERA,1,"",RCS_U_(RCS+RCY-1),.RCBAT,RCNAMES) S ^TMP($J,"BATCHES",1,RCS)=RCBAT_U_(RCS+RCY-1)
	;
	I RCSEL=2 D
	. N RCNMF,RCQUIT,RCDONE
	. S RCNMF="A",(RCQUIT,RCDONE)=0
	. F  D  Q:RCQUIT!RCDONE
	.. W !!,"START FROM LAST NAME BEGINNING WITH: ",RCNMF
	.. S DIR("?")="ENTER A LETTER IN UPPERCASE"
	.. S DIR(0)="FA^1:1^K:X'?.U X",DIR("A")="INCLUDE THROUGH LAST NAME BEGINNING WITH: " D ^DIR K DIR
	.. I $D(DTOUT)!$D(DUOUT) S RCQUIT=1 Q
	.. S RCY=Y,RCSEL("NAME",RCNMF)=Y_"ZZZ"
	.. I $A(RCY)=90 S RCDONE=1 Q
	.. S RCNMF=$A(RCY)+1,RCNMF=$C(RCNMF)
	. Q:RCQUIT
	. S Z="" F  S Z=$O(RCSEL("NAME",Z)) Q:Z=""  D NEWBAT(RCERA,2,"",Z_U_RCSEL("NAME",Z),.RCBAT,RCNAMES) S ^TMP($J,"BATCHES",2,Z)=RCBAT_U_RCSEL("NAME",Z)
	;
	I RCSEL=3 D
	. F Y=1:1:3 D NEWBAT(RCERA,3,$P("FULL PAYMENT^PARTIAL PAYMENT^NO PAYMENT",U,Y),Y,.RCBAT,RCNAMES) S ^TMP($J,"BATCHES",3,Y)=RCBAT
	;
	I RCSEL=4 D
	. F Y=1,2 D NEWBAT(RCERA,RCSEL,$P("CO-PAY EXISTS^NO CO-PAY EXISTS",U,Y),Y,.RCBAT,RCNAMES) S ^TMP($J,"BATCHES",4,Y)=RCBAT
	;
	S DIR(0)="EA",DIR("A")=RCBAT_" BATCHES CREATED.  PRESS RETURN TO CONTINUE " W ! D ^DIR K DIR
	Q
	;
NEWBAT(RCERA,RCSEL,RCDAT,RCVAL,RCBAT,RCNAMES)	; Add a new batch at the top level entry
	; RCERA = the ien of the entry in file 344.49
	; RCSEL = the # of the selection criteria selected
	; RCDAT = the default 'name' of the batch based on the criteria used
	; RCVAL = the start value^the end value
	; RCBAT = if passed by reference, returned as the next batch #
	; RCNAMES = 1 if user wants to name each batch, 0 to accept default
	;
	; prca*4.5*298 per requirements, keep code related to creating/maintaining batches but remove from execution
	Q  ;prca*4.5*298 
	N DA,DD,DIC,DLAYGO,DO,DR,X,Y
	S RCBAT=RCBAT+1
	S DA(1)=RCERA,DIC="^RCY(344.49,"_DA(1)_",3,",DLAYGO=344.493,DIC(0)="L",X=RCBAT
	I $G(RCNAMES) W !!,"**BATCH #: "_RCBAT
	S DIC("DR")=".03////0;.04////"_DUZ_";.05////0;.06////"_RCSEL_";.07////"_$P(RCVAL,U)_$S($P(RCVAL,U,2)'="":";.08////"_$P(RCVAL,U,2),1:"")
	S DIC("DR")=DIC("DR")_";.02R//"_$S(RCNAMES:"",1:"//")_$S(RCSEL=1:"BATCH #: "_RCBAT,RCSEL=2:"LAST NAME FROM "_$P(RCVAL,U)_" - "_$P(RCVAL,U,2),1:RCDAT)
	D FILE^DICN K DLAYGO,DIC,DD,DO W !
	Q
	;
GETBATCH(RCZ0)	; Returns the batch # to be assigned to the data in RCZ0
	; RCZ0 = 0-node of the entry in file 344.41 to be assigned to a batch
	N BNUM,Z,Z0
	S BNUM=""
	I $G(^TMP($J,"BATCHES"))=1 D  ; Max #
	. N CT
	. S CT=+$G(^TMP($J,"BATCHES","CT"))+1
	. S ^TMP($J,"BATCHES","CT")=CT
	. S Z=+$O(^TMP($J,"BATCHES",1,CT+1),-1),BNUM=+$G(^TMP($J,"BATCHES",1,Z)) S:'BNUM BNUM=1
	;
	I $G(^TMP($J,"BATCHES"))=2 D  ; last name
	. S Z=$P(RCZ0,U,15)
	. I $P(RCZ0,U,2) S Z0=$P($G(^DGCR(399,+$G(^IBM(361.1,+$P(RCZ0,U,2),0)),0)),U,2),Z0=$P($G(^DPT(Z0,0)),U) I Z0'="" S Z=Z0
	. S Z0=$A($E(Z))-1,Z0=$C(Z0),Z0=$O(^TMP($J,"BATCHES",2,Z0),-1)
	. S BNUM=$S(Z0="":1,1:+$G(^TMP($J,"BATCHES",2,Z0))) S:'BNUM BNUM=1
	;
	I $G(^TMP($J,"BATCHES"))=3 D  ; payment amount
	. S Z=+$P(RCZ0,U,3)
	. I Z'>0!'$P(RCZ0,U,2) S BNUM=3 Q  ; 0-PAY/ADJUSTMENT/UNKNOWN CLAIM
	. I +$P($G(^IBM(361.1,+$P(RCZ0,U,2))),U,4)'>+Z S BNUM=1 Q  ; FULL PAY
	. S BNUM=2 ; PARTIAL PAY
	;
	I $G(^TMP($J,"BATCHES"))=4 D  ; Co-pay/not
	. S BNUM=2
	. Q:'$P(RCZ0,U,2)
	. I $$COPAY^RCDPEWL1(+$G(^IBM(361.1,+$P(RCZ0,U,2),0))) S BNUM=1
	;
	Q BNUM
	;
EDIT(RCERA,RCB,ABORT)	; Edit name and posting status of an existing batch
	; RCERA = the ien of the worklist entry
	; RCB = the ien of the current batch
	; RCABORT = if passed by reference, returned as 1 if user aborts
	;
	; prca*4.5*298 per requirements, keep code related to creating/maintaining batches but remove from execution
	Q  ;prca*4.5*298 
	N DA,DIE,DR,X,Y
	D FULL^VALM1
	S ABORT=0
	S DA(1)=RCERA,DA=RCB,DIE="^RCY(344.49,"_DA(1)_",3,",DR=".02;.03" D ^DIE I $D(Y) S ABORT=1
	K VALMHDR ; Used to rebuild the header
	S VALMBCK="R"
	Q
	;
MARKALL(RCERA)	; Mark all batches as ready to post
	;  prca*4.5*298 per requirements, keep code related to creating/maintaining batches but remove from execution
	Q  ;prca*4.5*298 
	N DIR,X,Y,Z,RCT,DA,DIE,DR
	D FULL^VALM1
	S VALMBCK="R"
	I $G(^TMP("RCBATCH_SELECTED",$J)) D NOBATCH^RCDPEWL S VALMBCK="R" Q
	I '$O(^RCY(344.49,RCERA,3,0)) D NOTSET^RCDPEWLC Q
	S DIR(0)="YA",DIR("A",1)="THIS ACTION WILL MARK ALL BATCHES FOR THIS ERA AS READY TO POST",DIR("A")="ARE YOU SURE YOU WANT TO DO THIS?: ",DIR("B")="NO" W ! D ^DIR K DIR
	S RCT=0
	I Y D
	. S Z=0 F  S Z=$O(^RCY(344.49,RCERA,3,Z)) Q:'Z  I '$P($G(^(Z,0)),U,3) S RCT=RCT+1,DA(1)=RCERA,DA=Z,DIE="^RCY(344.49,"_DA(1)_",3,",DR=".03////1" D ^DIE
	. W !!,RCT," BATCHES CHANGED TO READY TO POST",!,"ALL BATCHES ARE NOW READY TO POST"
	. S DIR(0)="EA",DIR("A")="PRESS RETURN TO CONTINUE " W ! D ^DIR K DIR
	. K VALMHDR
	Q
	;
EDITALL(RCERA)	; Edit all batches
	; prca*4.5*298 per requirements, keep code related to creating/maintaining batches but remove from execution
	Q  ;prca*4.5*298 
	N Z,RCQUIT
	D FULL^VALM1
	S VALMBCK="R"
	W !
	I '$O(^RCY(344.49,RCERA,3,0)) D NOTSET^RCDPEWLC Q
	S (RCQUIT,Z)=0 F  S Z=$O(^RCY(344.49,RCERA,3,Z)) Q:'Z  W !!,"BATCH #: "_+$G(^(Z,0)) D EDIT(RCERA,Z,.RCQUIT) Q:RCQUIT
	Q
	;
REBATCH(RCERA)	; Allow to recreate batches
	;  prca*4.5*298 per requirements, keep code related to creating/maintaining batches but remove from execution
	Q  ;prca*4.5*298 
	N DA,DIE,DIK,DIR,DR,RCLINE,RCQUIT,X,Y,Z,Z0
	D FULL^VALM1
	I $G(^TMP("RCBATCH_SELECTED",$J)) D NOBATCH^RCDPEWL G REBQ
	;
	I '$O(^RCY(344.49,RCERA,3,0)) W !!," ***** THIS ERA CURRENTLY HAS NO BATCHES DEFINED *****"
	;
	S RCQUIT=0
	I $O(^RCY(344.49,RCERA,3,0)) D  G:RCQUIT REBQ
	. S DIR(0)="YA",DIR("B")="NO",DIR("A",1)="THIS ACTION REMOVES ALL BATCH REFERENCES.  THE BATCHES CAN THEN BE REBUILT.",DIR("A")="ARE YOU SURE YOU WANT TO CONTINUE?: " W ! D ^DIR K DIR
	. I Y'=1 S RCQUIT=1 Q
	. S Z=0 F  S Z=$O(^RCY(344.49,RCERA,3,Z)) Q:'Z  S DA(1)=RCERA,DIK="^RCY(344.49,"_DA(1)_",3,",DA=Z D ^DIK
	;
	K ^TMP($J,"BATCHES")
	D SETBATCH(RCERA)
	S Z=0 F  S Z=$O(^RCY(344.49,RCERA,1,Z)) Q:'Z  S Z0=$G(^(Z,0)) I +Z0'["." D
	. S RCLINE=$G(^RCY(344.4,RCERA,1,+$P(Z0,U,9),0)),DA(1)=RCERA,DIE="^RCY(344.49,"_DA(1)_",1,",DA=Z,DR=".14///"_$S(RCLINE="":"@",1:"/"_$$GETBATCH^RCDPEWLB(RCLINE)) D ^DIE
	K ^TMP($J,"BATCHES")
REBQ	S VALMBCK="R"
	Q
	;
CTEEOB(RCERA)	; Returns the approx # of EEOBs in ERA ien RCERA (file 344.4)
	N RCNUM,Z
	S (RCNUM,Z)=0 F  S Z=$O(^RCY(344.4,RCERA,1,Z)) Q:'Z  I $P($G(^(Z,0)),U,3)'<0 S RCNUM=RCNUM+1
	Q RCNUM
	;
