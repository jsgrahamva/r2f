LRMIVER1	;DALOI/STAFF - MICRO CHART COPY APPROVAL CONT. ;12/19/12  10:41
	;;5.2;LAB SERVICE;**295,350,427**;Sep 27, 1994;Build 33
	;
	;from LRMIVER
	;
APPROVE	I '$O(^LRO(68,"AVS",LRAA,0)) W !,"No data." Q
	F I=0:0 W !!,"Do you wish to review the data as the (W)ards will see it, as the (L)ab",!,"will see it, or (N)ot review the data?  N// " R X:DTIME S:'$T X=U S:'$L(X) X="N" Q:X[U!("WLN"[X&($L(X)=1))  D INFO^LRMINEW
	Q:X[U  I X="N" D ACCEPT Q
	S:X="W" LRWRDVEW="" F I=0:0 W !,"Do you want to queue the data to print and approve it later" S %=1 D YN^DICN Q:%  W !,"Answer 'Y'es or 'N'o"
	Q:%<1  S ZTRTN="DQ^LRMIVER1" I %=1 S %ZIS="QM",%ZIS("B")="",IOP="Q"
	D IO^LRWU
	Q
	;
DQ	;
	N LRMLTRPT ;multi report flag for RPT^LRMIPSZ1
	S LRMLTRPT=1
	S:$D(ZTQUEUED) ZTREQ="@" U IO
	S LREND=0,LRSB=0 K ^TMP($J) S LRAD=0 F I=0:0 S LRAD=+$O(^LRO(68,"AVS",LRAA,LRAD)) Q:LRAD<1  D SORT Q:LREND
	S LRONESPC="",LRONETST="" D PRINT
	Q
	;
SORT	S LRAN=0 F  S LRAN=+$O(^LRO(68,"AVS",LRAA,LRAD,LRAN)) Q:LRAN<1  D S1
	Q
	;
S1	S LRDFN=+^LRO(68,"AVS",LRAA,LRAD,LRAN),LRIDT=$P(^(LRAN),U,2)
	I $D(^LR(LRDFN,"MI",LRIDT,0)) S LRVLOC=$S($L($P(^(0),U,8)):$P(^(0),U,8),1:0),^TMP($J,LRVLOC,LRDFN,LRIDT)=^(0)
	S ^TMP($J,LRVLOC,LRDFN,LRIDT,1)=LRAD
	Q
	;
PRINT	S LRVLOC="" F LRLCNT=0:0 S LRVLOC=$O(^TMP($J,LRVLOC)) Q:LRVLOC=""  S LRLTR=$E(LRVLOC,1,4) W @IOF D ^LRLTR:$E(IOST,1,2)'="C-",P1 Q:LREND
	Q
	;
P1	S LRDFN=0 F  S LRDFN=+$O(^TMP($J,LRVLOC,LRDFN)) Q:LRDFN<1  D P2 Q:LREND
	Q
	;
P2	S LRIDT=0 F  S LRIDT=+$O(^TMP($J,LRVLOC,LRDFN,LRIDT)) Q:LRIDT<1  D P3 Q:LREND
	Q
	;
P3	S LRWLSAVE=LRAA,LRLLT=^TMP($J,LRVLOC,LRDFN,LRIDT),LRACC=$P(LRLLT,U,6),LRAD=$E(LRLLT)_$P(LRACC," ",2)_"0000",X=$P(LRACC," "),DIC=68,DIC(0)="M"
	D ^DIC S LRAA=+Y,LRAN=$P(LRACC," ",3),LRCMNT=$S($D(^LR(LRDFN,"MI",LRIDT,99)):^(99),1:""),LRPG=0 D EN^LRMIPSZ1 S LRAA=LRWLSAVE Q:LREND
	Q
	;
ACCEPT	W !!,"Indicate those you wish to exclude from verification." D LRAN^LRMIUT
	S LRAN=0 F  S LRAN=+$O(LRAN(LRAN)) Q:LRAN<1  S LRAD=0 F  S LRAD=+$O(^LRO(68,"AVS",LRAA,LRAD)) Q:LRAD<1  K ^LRO(68,"AVS",LRAA,LRAD,LRAN)
	F  W !,"Ready to approve" S %=2 D YN^DICN Q:%  W !,"Answer 'Y'es or 'N'o"
	Q:%'=1  W !
	S LRAD=0 F  S LRAD=+$O(^LRO(68,"AVS",LRAA,LRAD)) Q:LRAD<1  D LRAD
	K LRWRDVEW,LRAD,LRAN,LRTK,Z
	Q
	;
LRAD	S LRAN=0 F  S LRAN=+$O(^LRO(68,"AVS",LRAA,LRAD,LRAN)) Q:LRAN<1  D STUFF
	Q
	;
STUFF	;
	S LRDFN=+^LRO(68,"AVS",LRAA,LRAD,LRAN),LRIDT=$P(^(LRAN),U,2)
	D UPDATE^LRPXRM(LRDFN,"MI",LRIDT)
	I $D(^LRO(68,LRAA,1,LRAD,1,LRAN,0)) D
	. S LRODT=$P(^LRO(68,LRAA,1,LRAD,1,LRAN,0),U,4),LRSN=$P(^(0),U,5),LRLLOC=$P(^(0),U,7)
	. S DFN=$P(^LR(LRDFN,0),U,3),LRDPF=$P(^(0),U,2),LRCDT=9999999-LRIDT
	. D PT^LRX S Y=DT D VT^LRMIUT1
	S ^LR(LRDFN,"MI",LRIDT,0)=$P(^LR(LRDFN,"MI",LRIDT,0),U,1,2)_U_LRNT_U_DUZ_U_$P(^(0),U,5,99)
	S LRSET=1,II=0
	F  S II=+$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,II)) Q:'II  I $P(^(II,0),U,5)="" S LRSET=0,LRTS=II
	;F  S II=+$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,II)) Q:I<1  I '$L($P(^(II,0),U,5)) S LRSET=0,LRTS=II
	S:LRSET $P(^LRO(68,LRAA,1,LRAD,1,LRAN,3),U,4)=LRNT W "."
	F II=1,5,8,11,16 I $D(^LR(LRDFN,"MI",LRIDT,II)),$P(^(II),U) D 
	. K ^LRO(68,LRAA,1,LRAD,"AC",II,LRAN)
	. S LRSB=II
	;
	I $G(LRSS)="" S LRSS="MI"
	D SETRL^LRVERA(LRDFN,LRSS,LRIDT,DUZ(2))
	;
	; If this accession originated via a LEDI order then return results to the collecting site.
	D LEDI^LRVR0
	Q
