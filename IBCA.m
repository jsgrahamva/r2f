IBCA	;ALB/MRL - ADD NEW BILLING RECORD ;01 JUN 88 12:00
	;;2.0;INTEGRATED BILLING;**43,80,109,106,137,312,461**;21-MAR-94;Build 58
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;
	;MAP TO DGCRA
	;
	N IBSWINFO S IBSWINFO=$$SWSTAT^IBBAPI()                   ;IB*2.0*312
	;
	D Q1 S IBCABRT=0,IOP="HOME" D ^%ZIS K IOP I $S('$D(DFN):1,'$D(^DPT(DFN,0)):1,1:0) S IBCABRT=1 G NREC
	I $S('$D(^IBE(350.9,1,1)):1,'$P(^(1),U,14):1,1:0) S IBCABRT=4 G NREC
	S PRCASV("SER")=$P(^IBE(350.9,1,1),U,14)
	S PRCASV("SITE")=+$P($$SITE^VASITE,"^",3) I PRCASV("SITE")<1 S IBCABRT=5 G NREC
	S IBNWBL="",IBQUIT=0 I '$D(DUZ(0)) S IBCABRT=2 G NREC
	I $S($D(DLAYGO):2\1-(DLAYGO\1),1:1),DUZ(0)'="@",$D(^DIC(399,0,"LAYGO")) S DLAYGO=399
	;I $S($D(DLAYGO):2\1-(DLAYGO\1),1:1),DUZ(0)'="@",$D(^DIC(399,0,"LAYGO")) F I=1:1 I DUZ(0)[$E(^("LAYGO"),I) Q:I'>$L(^("LAYGO"))  S IBCABRT=3 G NREC
	;
CHKID	D DEM^VADPT S DGDIR0="399,.04^399,.05^399,.06^399,155^399,151^399,152",DGDIRA="LOCATION OF CARE^EVENT INFORMATION SOURCE^TIMEFRAME^IS THIS A SENSITIVE RECORD?^STATEMENT COVERS FROM^STATEMENT COVERS TO"
	S DGDIRB="1^^^NO"
	F IBI=1:1:4 S:$P(DGDIRB,"^",IBI)]"" DIR("B")=$P(DGDIRB,"^",IBI) S DIR(0)=$P(DGDIR0,"^",IBI),DIR("A")="   BILLING "_$P(DGDIRA,"^",IBI) D READ G:IBQUIT NREC K DIR
	S DIC="^DGCR(399.3,",DIC(0)="AEQMZ",DIC("A")="   BILLING RATE TYPE:  ",DIC("S")="I '$P(^(0),U,3)" D ^DIC K DIC G NREC:Y'>0 S IBIDS(.07)=+Y,IBIDS(.11)=$P(^DGCR(399.3,+Y,0),"^",7)
	;
OP	G IP:IBIDS(.05)'>2 S %DT="EAX",%DT(0)="-NOW",%DT("A")="   BILLING OUTPATIENT EVENT DATE:  " D ^%DT I Y'>0 G NREC
	;S X=Y D APPT^IBCU3
	; Do NOT PROCESS on VistA if Y >= Switch Eff Date          ;CCR-930
	I +IBSWINFO,(Y+1)>$P(IBSWINFO,"^",2) S IBCABRT=7 G NREC    ;IB*2.0*312
	;
	S X=$$APPT^IBCU3(Y,DFN,1)
	S IBIDS(.03)=+Y X ^DD("DD") S DIR("B")=Y G CEOC
	;
IP	D DISPAD^IBCA0 G:'$D(IBIDS(.03)) NREC
	; Do NOT PROCESS on VistA if Date = Switch Eff Date        ;CCR-930*312
	I +IBSWINFO,(IBIDS(.03)+1)>$P(IBSWINFO,"^",2) S IBCABRT=7 G NREC   ;P312
	;
	I $D(IBDSDT) K:'IBDSDT IBDSDT S:$D(IBDSDT) IBDSDT=$P(IBDSDT,".")
	S Y=$P(IBIDS(.03),".") X ^DD("DD") S DIR("B")=Y
	;
CEOC	S IBIDS(.27)="" I +$$BILLRATE^IBCRU3(IBIDS(.07),IBIDS(.05),IBIDS(.03),"RC") S IBIDS(.27)=1
	S IBIDS(.22)=$P($G(^IBE(350.9,1,1)),"^",25)
	I $G(IBIDS(.11))="i" N IBDTIN,IBCOVEXT S IBDTIN=$G(IBIDS(.03)),IBCOVEXT=1 W ! D DISPDT^IBCNS W !
	W ! S X=$P(IBIDS(.03),".") D EN3^IBCA3 W ! S IBQUIT=0 ;show other bills this date
	I IBIDS(.05)>2 S X=$$ADM^IBCU64(DFN,IBIDS(.03)) I +X W !,"Warning: Patient is an Inpatient on ",$$FMTE^XLFDT(IBIDS(.03),2),": ",$$FMTE^XLFDT(+X,2)," - " W:+$P(X,U,2) $$FMTE^XLFDT(+$P(X,U,2),2) W !
	I +$G(IBIDS(.08)),+$P($G(^DGPT(+IBIDS(.08),70)),"^",2),$G(^DIC(42.4,+$P(^(70),"^",2),0))'="",$P(^(0),"^",5)="" W !!,"Discharge bedsection of this PTF record is NOT billable!",!!!
	S IBI=5,DIR(0)="399,151",DIR("A")="   BILLING STATEMENT COVERS FROM" D READ G:IBQUIT NREC S DGX=IBIDS(151) D LASTDAY X ^DD("DD") S DIR("B")=Y
	S IBI=6,DIR(0)="399,152",DIR("A")="   BILLING STATEMENT COVERS TO" D READ G:IBQUIT NREC
	K %DT,DIR G ^IBCA1:'$O(^DGCR(399,"C",DFN,0)) S X=9999999-IBIDS(.03)
	F I=0:0 S I=$O(^DGCR(399,"APDT",DFN,I)) Q:'I  I $O(^DGCR(399,"APDT",DFN,I,0))=X,$D(^DGCR(399,+I,0)),$S('$D(^DGCR(399,I,"S")):1,$P(^("S"),"^",16)=1:0,1:1) S IBIDS(.17)=$P(^(0),"^",17) Q
	I $D(IBIDS(.17)) G CHKINQ
	I '$D(IBIDS(.17)),IBIDS(.05)<3 G CHKINQ
CEOC1	D CEOC1^IBCA0 Q:'$D(IBIDS)
CHKINQ	G ^IBCA1
	;
READ	D ^DIR I X?1"^"1.ANP W !?6,*7,"Sorry '^' not allowed!" G READ
	I $D(DIRUT) S IBQUIT=1 Q
	S IBIDS($P($P(DGDIR0,"^",IBI),",",2))=Y
	Q
	;
NREC	S IBYN=0 D SET W !?6,*7,"<",$S('$G(IBCABRT):"ABORTED",$P(IBCABRT(1),U,IBCABRT)]"":$P(IBCABRT(1),U,IBCABRT),1:"ABORTED"),", NO BILLING RECORD CREATED>" K IBIFN
Q1	K IBIDS,IB
Q	K %,%DT,D,IBCABRT,IBNWBL,IBQUIT,IBYN,DIRUT,DTOUT,DIROUT,DUOUT,PRCASV,X1,X2,IBI,IBJ,IBX,DGX,IBDSDT,IBDFN,IBID0,IBSET,IBI,DGDIRB,DGDIR0,DGDIRA,DIR,DIC,DLAYGO,I,X,Y Q
	Q
SET	S IBCABRT(1)="PATIENT INFORMATION LACKING^FILEMAN ACCESS UNDEFINED^"
	S IBCABRT(1)=IBCABRT(1)_"NO LAYGO ACCESS TO BILLING FILE^"
	S IBCABRT(1)=IBCABRT(1)_"MAS SERVICE PARAMETER UNKNOWN^"
	S IBCABRT(1)=IBCABRT(1)_"FACILITY UNDEFINED^"
	S IBCABRT(1)=IBCABRT(1)_"UNABLE TO CREATE ACCOUNTS RECEIVABLE ENTRY^"
	S IBCABRT(1)=IBCABRT(1)_"EPISODE CANNOT BE ON OR AFTER PFSS EFFECTIVE DATE"
	Q
	;
LASTDAY	;find last day of last month
	;  -set x to default last date
	S X1=DT,X2=-($E(DT,6,7)) D C^%DTC S Y=X
	K Y
	I $D(IBDSDT) D  G:$D(Y) LDQ
	. ;I $E(DGX,4,5)<10 S Y=$E(DGX,1,3)_"0930" S:IBDSDT<Y Y=IBDSDT Q  ;don't cross fy's
	. ;I $E(DGX,4,5)>9 S Y=$E(DGX,1,3)_"1231" S:IBDSDT<Y Y=IBDSDT Q  ;don't cross cy's
	. S Y=IBDSDT
	;
	I DGX>X S X=DT ;billing for this month
	;
	I IBIDS(.05)>2 N Z S Z=$$ICD10S^IBCU4(DGX,X) I +Z S X=$$FMADD^XLFDT(Z,-1)
	;
	;I $E(DGX,4,5)<10 S Y=$E(DGX,1,3)_"0930" S:X<Y Y=X G LDQ ; end of month, don't cross fy's
	;I $E(DGX,4,5)>9 S Y=$E(DGX,1,3)_"1231" S:X<Y Y=X G LDQ ; end of month, don't cross cy's
	I '$D(Y) S Y=X
LDQ	Q
