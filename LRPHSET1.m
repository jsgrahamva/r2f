LRPHSET1	;SLC/CJS-COLLECTION LIST TO ACCESSIONS ;8/11/97
	;;5.2;LAB SERVICE;**121,191,221,240,423**;Sep 27, 1994;Build 2
	Q
EN	;from LRPHSET
	K ^LRO(69,DT,1,"AD") S $P(^LAB(69.9,1,5),"^",10,12)=1_"^"_$H_"^"_$S($D(DUZ):DUZ,1:"")
	S LRDFN=0 F  S LRDFN=$O(^LRO(69,DT,1,"AA",LRDFN)) Q:LRDFN<1  K T D S6
	S LRLOC="",LRCOUNT=0,LRDUZ(2)=$S($D(DUZ(2)):DUZ(2),1:"") F LRPH=0:0 S LRLOC=$O(^LRO(69,DT,1,"AD",LRLOC)) Q:LRLOC=""  D S4
	S $P(^LAB(69.9,1,5),"^",10)=0
	G END
S4	K DIC S D="C",X=LRLOC,DIC(0)="Z",DIC=44 D IX^DIC S LRDUZ(2)=$S(Y<1:DUZ(2),1:$S($P(Y(0),U,4):$P(Y(0),U,4),1:DUZ(2)))
	S LRDFN=0 F  S LRDFN=$O(^LRO(69,DT,1,"AD",LRLOC,LRDFN)) Q:LRDFN<1  D S4A
	Q
S4A	S LRSN=0 F  S LRSN=$O(^LRO(69,DT,1,"AD",LRLOC,LRDFN,LRSN)) Q:LRSN<1  D:$D(^LRO(69,DT,1,LRSN,1)) S4C D:'($D(^LRO(69,DT,1,LRSN,1))#2)&($D(^(0))) S4B
	Q
S4B	S X=^LRO(69,DT,1,LRSN,0) I $P(X,U,4)="LC",LRDFN=+X,$P(X,U,8)'>LRDTI S:$$GOT(DT,LRSN) LRCOUNT=LRCOUNT+1 D S5
	Q
S4C	I $P(^LRO(69,DT,1,LRSN,1),U)'>LRDTI S X=^(0) I $P(X,U,4)="LC",LRDFN=+X,$P(X,U,8)'>LRDTI D S5
	Q
S5	S ^LRO(69,DT,1,"AC",LRLOC,LRSN)=1,LRSCR=$S($D(^LRO(69,DT,1,LRSN,1)):$P(^(1),U,3,99),1:""),^(1)=LRDTI_"^1^"_LRSCR,LRTJ=$P(^(0),U,3,4)_"^"_DT,LRSAMP=$P(LRTJ,U,1)
	S LRSPEC=$P(^LAB(62,LRSAMP,0),U,2),I=$O(^LRO(69,DT,1,LRSN,6,0)) K LRSPCDSC S:I LRSPCDSC=^(I,0)
	I $D(^LRO(69,DT,1,LRSN,1)),'$L($P(^(1),U,4)),$D(^(3)) S LRLLOC=$P(^LRO(69,DT,1,LRSN,0),U,7),LROLLOC=$P(^(0),U,9) D REUP^LRPHSET2
	D OLD^LRORDST K LRTJ Q
S6	S T="",LRSN=0 F  S LRSN=$O(^LRO(69,DT,1,"AA",LRDFN,LRSN)) Q:LRSN<1  D S6A
	S LRSAMP=0 F  S LRSAMP=$O(T(LRSAMP)) Q:LRSAMP<1  S LRSTEP=0 D S7^LRPHSET2 S LRSTEP=1 D S7^LRPHSET2
	Q
S6A	I '$S($D(^LRO(69,DT,1,LRSN,0)):$L($P(^(0),U,2)),1:0) Q
	Q:$P(^LRO(69,DT,1,LRSN,0),U,4)'="LC"  Q:$P(^(0),U,8)>LRDTI  I $D(^(1)),$L($P(^(1),U,4)) Q
	Q:'$D(^LRO(69,DT,1,LRSN,2,0))  Q:'$$GOT(DT,LRSN)
	S LRSAMP=$P(^LRO(69,DT,1,LRSN,0),U,3),LRLLOC=$E($P(^(0),U,7),1,30),LROLLOC=$P(^(0),U,9)
	S X=^LR(LRDFN,0),LRDPF=$P(X,U,2) I LRDPF=2,$D(^DPT(+$P(X,U,3),.1)) S LRLLOC=^(.1) D DPT^LRWU S $P(^LRO(69,DT,1,LRSN,0),U,7)=$S($L(LRLLOC):LRLLOC,1:"UNKNOWN")
	S:'$L(LRLLOC) LRLLOC="UNKNOWN" Q:LRSAMP<1  S ^LRO(69,DT,1,"AD",LRLLOC,LRDFN,LRSN)=""
	S I=0 F  S I=$O(^LRO(69,DT,1,LRSN,2,I)) Q:I<1  S X=^(I,0) I '$P(X,"^",6),'$P(X,"^",11) S T(LRSAMP,+X,LRSN)=I_U_$P(X,U,2)
	Q
END	Q  ;BACK TO LRPHSET
GOT(ODT,SN)	;See if all tests have been canceled
	N I S GOT=0
	I $D(^LRO(69,ODT,1,SN)) S I=0 F  S I=$O(^LRO(69,ODT,1,SN,2,I)) Q:I<1  I $D(^(I,0)),'$P(^(0),"^",11) S GOT=1 Q
	Q GOT
