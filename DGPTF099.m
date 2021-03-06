DGPTF099	;ALB/MTC,HIOFO/FT - TRANSMIT DELETE PTF MASTER RECORD ;5/20/15 5:19pm
	;;5.3;Registration;**884**;Aug 13, 1993;Build 31
	;
	; VATRAN - #1011
	; XMD - #10070
	; VASITE - #10112
	; ^DPT - #10035
	; %ZIS - #10086
	; XLFSTR - #10104
	;
EN	;099 Transmission [DG PTF 099 TRANSMISSION]
	D INIT G QUIT:DGOUT W !!
	S DIR(0)="Y",DIR("B")="NO",DIR("A")="Do you wish to send a free-form 099"
	D ^DIR K DIR G QUIT:$D(DTOUT)!($D(DUOUT))
	I Y W ! D EN1^DGPTF09X G ENQ
ASK	W !! S DIC("A")="Enter 099 "_$P(DGRTY0,U)_" record: ",DIC="^DGP(45.84,",DIC(0)="AEQMZ",DIC("S")="I $D(^DGP(45.83,""C"",+Y)),$D(^DGPT(+Y,0)),$P(^(0),U,11)="_+DGRTY D ^DIC K DIC G QUIT:X=""!(X[U),NOT:Y'>0 S DGA=+Y
	I DGRTY=2 S DGPTIFN=DGA D CHK^DGPTFDEL G QUIT:'DGPTIFN
	S DIC="^DGPT(",X=DGA,DIC(0)="NME" W ! D ^DIC
	S VATNAME="PTF125" D ^VATRAN G QUIT:VATERR
OK	W !,"REOPEN & TRANSMIT 099" S %=2 D YN^DICN
	I '% W !!?15,"Enter <RET> to exit routine",!?10,"Enter 'Y' for YES to REOPEN & TRANSMIT",! G OK
	G ASK:%=2,QUIT:%'=1 S (DA,DGD)=+$O(^DGP(45.83,"C",DGA,0))
	I $D(^DGP(45.83,DGD,"P",DGA,0)),'$P(^(0),U,2) G NOTRAN
	S DIK="^DGP(45.83,DGD,""P"",",DA(1)=DGD,DA=DGA D ^DIK
	I '$O(^DGP(45.83,DGD,"P",0)) S DIK="^DGP(45.83,",DA=DGD D ^DIK
	D BUL,LOG W !,"****** 099 TRANSACTION SENT ******"
	S DGPTIFN=DGA D OPEN^DGPTFDEL
ENQ	G EN
	;
BUL	;
	S DGINFO=^DGPT(DGA,0),SSN=$P(^DPT(+DGINFO,0),U,9),DGADM=$P($P(DGINFO,U,2),".",1),DGXX="",$P(DGXX," ",241)=""
	S DGHEAD="N099"_$S($E(SSN,10)="P":"P",1:" ")_$E(SSN,1,9)
	S DGHEAD=DGHEAD_$E(DGADM,4,5)_$E(DGADM,6,7)_$E(DGADM,2,3)_$E($P($P(DGINFO,U,2),".",2)_"0000",1,4)
	S DGHEAD=DGHEAD_$J($P(DGINFO,U,3),3)_$E($P(DGINFO,U,5)_"   ",1,3),^UTILITY($J,"T099",1,1,1,0)=$E(DGHEAD_DGXX,1,240)
	S ^UTILITY($J,"T099",1,1,2,0)=$$REPEAT^XLFSTR(" ",144)
TRAN	;
	K XMY D ROUTER^DGPTFTR S XMSUB="PTF 099",XMTEXT="^UTILITY("_$J_",""T099"",1,1," D ^XMD
	Q
LOG	;-- ptf transaction request log
	S DIC="^DGP(45.87,",DIC(0)="L" K DO,DD D NOW^%DTC S X=% D FILE^DICN K DIC,DO
	G LOGQ:Y<0 S DA=+Y
	S DIE="^DGP(45.87,",DR=".02////"_DUZ_";.04////N099;.05////"_SSN_";.06////"_$P(DGINFO,"^",2)_";.03////"_XMZ_";.08////"_$E($P($$SITE^VASITE,U,3)_"     ",1,6)_";.07////"_$J($P(DGINFO,U,3),3)_$E($P(DGINFO,U,5)_"   ",1,3)
	D ^DIE
	K DIE,DR
LOGQ	Q
	;
QUIT	;
	L -^DGP(45.83)
	K DIE,DR,^UTILITY($J),DA,DUOUT,DTOUT,DGOUT,DGA,DGA1,DFN,DGT,DGX,DFN,DGADM,DGD,DGHEAD,DGINFO,DGJ,DGXX,DIC,DIK,SSN,X,Y,%,XMDUZ,XMSUB,XMTEXT,XMY,XMZ,DGRTY,DGRTY0,DGPTIFN,DGPTFMT,VATNAME,VATERR,VAT,DGSDI Q
NOT	W !,"RECORD HAS NOT BEEN CLOSED YET!",! K DIC G ASK
NOTRAN	W !,"RECORD HAS NOT BEEN TRANSMITTED YET",! K DIC G ASK
	;
INIT	;
	D LO^DGUTL,HOME^%ZIS S DGOUT=0
	L +^DGP(45.83):5 I '$T W !,"Cannot transmit 099 while transmitting other records",! S DGOUT=1 G INITQ
	I '$D(DGRTY) S Y=1 D RTY^DGPTUTL
INITQ	Q
