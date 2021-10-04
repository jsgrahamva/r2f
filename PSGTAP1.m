PSGTAP1	;BIR/CML3-SEND PICK LIST TO ATC BY PATIENT/ADMIN TIME ;19 Nov 98 / 2:37 PM
	;;5.0;INPATIENT MEDICATIONS;**10,119,284**;16 DEC 97;Build 7
	;
S1	;
	W $C(48) F Q=1:1:75 R *X:$S(Q<15:1,1:5) G:X=49 S1 I X=48 Q
	E  S QUIT=1 Q
	W A F Q=1:1:75 R *X:$S(Q<15:1,1:5) G:X=49 S1 I X=48 Q
	S:'$T QUIT=1 Q
	;
S2	;
	W $C(48) F Q=1:1:75 R X:$S(Q<15:1,1:5) G:$A(X)=49 S2 I $A(X)=48 Q
	E  S QUIT=1 Q
	W A F Q=1:1:75 R X:$S(Q<15:1,1:5) G:$A(X)=49 S2 I $A(X)=48 Q
	S:'$T QUIT=1 Q
	Q
	;
S3	; *284 - Added ! to clear WR buffer for network channel
	W $C(48),! F Q=1:1:75 R *X:$S(Q<15:1,1:5) G:X=49 S3 I X=48 Q
	E  S QUIT=1 Q
	W A,! F Q=1:1:75 R *X:$S(Q<15:1,1:5) G:X=49 S3 I X=48 Q
	S:'$T QUIT=1 Q
	;
ENQ	;
	N ND,G,TM,W,R,P,ST,DD,ATCFF,DNUNIT,PSGTAG K ^TMP("PSGATC",$J)
	F  Q:$$LOCK^PSGPLUTL(PSGPLG,"PSGTAP")
	F  L +^PS(53.55,PSGPLG):1 Q:$T
	D NOW^%DTC S %=%_"0000000000000",PSGPLSD=$P(^PS(53.5,PSGPLG,0),"^",3),PSGPLED=$P(^(0),"^",4) I 'PSGPLSD!'PSGPLED S QUIT=0 G QUIT
	I PSGTAPR S ND=$P($G(^PS(53.55,PSGPLG,0)),"^",2) I ND,$O(^(1,0)) G RESTART
	I $D(^PS(53.55,PSGPLG)) S DIK="^PS(53.55,",DA=PSGPLG D ^DIK
	S (DINUM,X)=PSGPLG,DIC="^PS(53.55,",DIC(0)="L" K DD,DO D FILE^DICN I Y'>0 S QUIT=0 G QUIT
	S ATCFF=+$P($G(^PS(59.7,1,26)),"^",7)
	S ^PS(53.55,PSGPLG,1,0)="^53.56A",BLKS="                      ",G=PSGPLG,(DD,PSGORD,PSJJORD,ND,P,R,ST,TM,W)=""
	F  S TM=$O(^PS(53.5,"AC",G,TM)) Q:TM=""  F  S W=$O(^PS(53.5,"AC",G,TM,W)) Q:W=""  F  S R=$O(^PS(53.5,"AC",G,TM,W,R)) Q:R=""  F  S P=$O(^PS(53.5,"AC",G,TM,W,R,P)) Q:P=""  D
	.S (DFN,PSGP)=+$P(P,"^",2) D PID^VADPT S PND=$S($D(^DPT(PSGP,0)):^(0),1:0),PL=$E($S($D(^(.1)):^(.1),1:"N/F")_BLKS,1,12),PN=$E($P(PND,"^")_BLKS,1,20),PID=$E(VA("PID")_BLKS,1,12)
	.S ST="" F  S ST=$O(^PS(53.5,"AC",G,TM,W,R,P,ST)) Q:ST=""  Q:"Z"[ST  F  S PSGORD=$O(^PS(53.5,"AC",G,TM,W,R,P,ST,PSGORD)) Q:PSGORD=""  S ON=+$G(^PS(53.5,G,1,PSGP,1,$P(PSGORD,"^",2),0)),DD="" D
	..F  S DD=$O(^PS(53.5,"AC",G,TM,W,R,P,ST,PSGORD,DD)) Q:DD=""  S D=+$P(DD,"^",2),C=$G(^PS(53.5,G,1,PSGP,1,$P(PSGORD,"^",2),1,D,0)),O=$P(C,"^"),C=$S($P(C,"^",3)]"":+$P(C,"^",3),1:$P(C,"^",2)) I C>0,C?1.3N D
	...S DN=$G(^PS(55,PSGP,5,ON,1,D,0))
	...S DNUNIT=$P(DN,"^",2) I DNUNIT#1,ATCFF,+DNUNIT S DNUNIT=(DNUNIT\1)+1
	...I DN,'(DNUNIT#1),$S('$P(DN,"^",3):1,1:DT<$P(DN,"^",3)) S A=$P($G(^PSDRUG(+DN,8.5)),"^",2) I A]"",$D(^(212,"AC",PSGPLWG)) S A=$E(A_BLKS,1,15),C=$S(DNUNIT:DNUNIT,1:1),C=$E("000",1,3-$L(C))_C D OS
	;
SET	; write ^TMP global to ACT file
	S ND=0,(X,Y)="^TMP(""PSGATC"","_$J,X=X_")"
	F  S X=$Q(@X) Q:X'[Y  S ND=ND+1,^PS(53.55,PSGPLG,1,ND,0)=$G(@X)
	S QUIT=$O(^PS(53.55,PSGPLG,1,0)) G:'QUIT QUIT S ^(0)="^53.56A^"_ND_"^"_ND,ND=0
	;
RESTART	;
	X ^%ZOSF("LABOFF") S QUIT=0
	F  S ND=$O(^PS(53.55,PSGPLG,1,ND)) Q:'ND  S A=$G(^(ND,0)) I A]"" S A=$C(50)_$C(52)_$P(A,"^")_$C(53)_$C(54)_$P(A,"^",2)_$C(55)_$C(13) S PSGTAG=$S(IOT="CHAN":"S3",'PSGSPD:"S1",1:"S2") D @PSGTAG Q:QUIT  S $P(^PS(53.55,PSGPLG,0),"^",2)=ND
	;
QUIT	;
	K ^TMP("PSGATC",$J)
	I 'QUIT S DIK="^PS(53.55,",DA=PSGPLG D ^DIK K DIK
	L -^PS(53.55,PSGPLG)
	D UNLOCK^PSGPLUTL(PSGPLG,"PSGTAP") D ^%ZISC
	Q
	;
OS	; order record set
	S ND2=$G(^PS(55,PSGP,5,ON,2)),SD=$P(ND2,U,2) I $S($P(SD,".")>$P(^PS(53.5,PSGPLG,0),"^",4):1,$P(ND2,U)["PRN":1,1:0) Q
	S FD=$P($P(ND2,U,4),"."),T=$P(ND2,U,6),PST=$P(^PS(55,PSGP,5,ON,0),"^",7)
	S QST=$S(PST="C"!(PST="O"):PST,PST="OC":"OA",PST="P":"OP",$P(ND2,U)["PRN":"OR",1:"CR")
	;S:PST="OC" PSGMAR("ZZZ")="999"
	D:PST'="OC" DTS
	Q:'$D(PSGMAR)
	I $P(ND2,U,6)="D",$P(ND2,U,5)="" S $P(ND2,U,5)=$E($P($P(ND2,U,2),".",2)_"0000",1,4)
	S X="" F  S X=$O(PSGMAR(X)) Q:X=""  D
	.S ^TMP("PSGATC",$J,TM,W,R,PN_"^"_PSGP,X,QST,PSGORD,DD)=PN_PID_PL_"BAT"_A_"1 ^"_C_$E($E(X,4,5)_$E(X,6,7)_$E(X,2,3)_$P(X,".",2)_"000",1,10)
	K PSGMAR Q
	;
DTS	;
	S PSGPLO=ON,PSGMFOR="",PSGPLS=PSGPLSD,PSGPLF=PSGPLED D ^PSJPL0
	K PSGPLO,PSGPLS,PSGPLF
	Q
