LRGEN1	;SLC/RWF-GENERAL DATA DISPLAY ;2/19/91  10:35
	;;5.2;LAB SERVICE;**201,221,438**;Sep 27, 1994;Build 18
DQ	;dequeued from LRGEN
	N LRPDT,LRPTF,LRPAGE
	S LRPDT=$$FMTE^XLFDT($$NOW^XLFDT,"5MZ")
	S LRPRTF="Report Range  [ "_$$FMTE^XLFDT($P(LRSDT,"."),"5MZ")_" - "_$$FMTE^XLFDT(9999999-$P(LREDT,"."),"5MZ")_" ]"
	K LRNOTE,LRSV S (LRPAGE,LRNOTE,LREND)=0,LRIOM=80
	S:'$G(LRIDT) LRIDT=1 W:$E(IOST,1,2)="C-" @IOF
	S $P(LRDASH,"-",(LRIOM-1))="",$P(LREQUAL,"=",(LRIOM-1))=""
	S LRWPL=IOSL-(3*LRIX)/LRIX
	S:$D(ZTQUEUED) ZTREQ="@" U IO
	S LRCW=LRCW-3,LRDPF=$P(^LR(LRDFN,0),U,2),DFN=$P(^(0),U,3)
	S LREDT=$$AEDT(LRDFN,LRSUB,LRIDT,LREDT,LRTP)
	D DT^LRX,PT^LRX,HEAD
	F  D NX Q:LREND!(LRIDT<1)!(LRIDT>LREDT)
	D WRTLN
	K LRDASH,LREQUAL,LRAGE,LRRB,LRTREAT,LRUNKNOW,SEX,AGE,LRLAST,LRIOM
	D KVAR^VADPT
	Q
WRTLN	W ! W:$E(IOST,1,2)="P-" @IOF D ^%ZISC Q
AEDT(LRD,LRS,LRI,LRE,LRT)	;return Actual End DaTe
	   ;(DFN,SUB{e.g.: "CH"},entered start date,entered end date,type)
	   N LREA,LRX,LRZ,LRN,LRR S (LREA,LRX)=LRI
	   F  S LRX=$O(^LR(LRD,LRS,LRX)) Q:LRX<1!(LRX>LRE)  D
	   . S LRZ=$S($D(^LR(LRD,LRS,LRX,0)):^(0),1:"") Q:'$P(LRZ,U,3)  I LRT,LRT'=$P(LRZ,U,5) Q
	   . S LRN=1,LRR=0 F  S LRR=+$O(LRND(LRR)) Q:LRR<1  S:$D(^LR(LRD,LRS,LRX,LRND(LRR))) LRN=0
	   . Q:LRN  S LREA=LRX
	   Q LREA  ;return last qualifying LRIDT
NX	I LRY'<LRWPL D BOT:LRSC=LRIX,HEAD:'LREND Q:LREND  I LRSC>1,LRSUB(LRSC)=LRSUB(LRSC-1) D NSET Q
	I LRIDT>1,$S(+$O(^LR(LRDFN,LRSUB,LRIDT))<1:1,+$O(^(LRIDT))>LREDT:1,1:0),LRSC<LRIX S LRY=LRWPL Q
	S:LRIDT>1 LRIDT=+$O(^LR(LRDFN,LRSUB,LRIDT)) I LRIDT<1!(LRIDT>LREDT) D  Q
	. I LRSC>1,LRSUB(LRSC)=LRSUB(LRSC-1) D NSET
	. S LRY=LRWPL D BOT,LAST
	S Z=$S($D(^LR(LRDFN,LRSUB,LRIDT,0)):^(0),1:"") Q:'$P(Z,U,3)  I LRTP,LRTP'=$P(Z,U,5) Q
	S LRNOP=1,II=0 F  S II=+$O(LRND(II)) Q:II<1  S:$D(^LR(LRDFN,LRSUB,LRIDT,LRND(II))) LRNOP=0
	Q:LRNOP  I $D(LRSUB(LRSC+1)),LRSUB(LRSC+1)=LRSUB(LRSC) S LRSV(LRY)=LRIDT
	D LRPR
	Q
NSET	S LRSSP=0 F  S LRSSP=+$O(LRSV(LRSSP)) Q:LRSSP<1  S LRIDT=LRSV(LRSSP),Z=^LR(LRDFN,LRSUB,LRIDT,0) D LRPR
	S LRIDT=LRIDT(LRSC-1),LRY=LRWPL
	Q
LRPR	N LRSAMP
	S X=+Z,LRTN=$P(Z,U,5),LRSAMP="?" S:LRTN'="" LRSAMP=$S($D(^LAB(61,LRTN,0)):$E(^(0),1,3),1:"?")
	S LRDAT=$$FMTE^XLFDT(X,"5MZ")
	S T="      "
	S:X["." T=" "_$E(X_"00000",9,10)_":"_$E(X_"0000",11,12)_" "
	S LRFOOT=" "
	I $O(^LR(LRDFN,LRSUB,LRIDT,1,0))>0 D
	. S:'$D(LRNOTE(-1,LRIDT)) LRNOTE=$G(LRNOTE)+1,LRNOTE(LRNOTE)=LRIDT,LRNOTE(-1,LRIDT)=LRNOTE S LRFOOT=$C(LRNOTE(-1,LRIDT)+64)
	W !,LRFOOT," ",LRDAT S LRY=LRY+1
	W !,?13,LRSAMP,?20 S X=$D(^LR(LRDFN,LRSUB,LRIDT,0)),LRX=$X,LRY=LRY+1
	F I=S1:1:S2 D
	. S X=$S($D(^LR(LRDFN,LRSUB,LRIDT,LRND(I))):^(LRND(I)),1:""),LRFFLG=$P(X,U,2),X=$P(X,U)
	. W ?LRX,@$S(X'=""&$D(LRPR(I)):LRPR(I),1:"$J(X,LRCW)")," ",LRFFLG
	. S LRX=LRX+3+LRCW
	Q
HEAD	Q:'$G(LRIDT)!($G(LREND))
	S:'$G(LRY) LRY=2 S:'$D(LRPRTF) $P(LRPRTF," ",20)=""
	S $P(LRDASH,"-",(LRIOM-1))="",$P(LREQUAL,"=",(LRIOM-1))=""
	S LREND=0 I '$G(LRBOT) F  Q:LREND  D HD1 Q:'(LRIDT<1!(LRIDT>LREDT))  S LREND=1 F II=1:1:LRIX I LRIDT(II)>0,LRIDT(II)<LREDT S LREND=0 Q
	Q:$G(LREND)
	S:'$D(LRPDT) LRPDT=$$FMTE^XLFDT($$NOW^XLFDT,"5MZ")
	I $G(LRSC)=1 D
	. S LRPAGE=$G(LRPAGE)+1,LRY=2 W @IOF
	. W !,"WORK COPY: ",PNM,"  ",SSN,"  Age:",AGE," ",?50,"Prt Date:",LRPDT
	. W !,$$CJ^XLFSTR(LRPRTF_"     Pg:"_LRPAGE,LRIOM) S LRY=LRY+1
	S X=9999999-$O(^LR(LRDFN,"CH",LRIDT)) W !! W:'$L($G(LRHDR(LRSC,1))) ?13,"SPEC" W ?20,LRHDR(LRSC) S LRY=LRY+2
	I $L(LRHDR(LRSC,2)) W !,$S($D(LRTHER):" Ther.",1:"  Ref")," Range",?17,LRHDR(LRSC,2) S LRY=LRY+1
	I $L(LRHDR(LRSC,1)) W !,?13,"SPEC",?20,LRHDR(LRSC,1) S LRY=LRY+1
	W !,LREQUAL S LRY=LRY+1
	Q
HD1	Q:$G(LREND)
	S LRIDT(LRSC)=LRIDT,LRSC=$S(LRSC<LRIX:LRSC+1,1:1),LRIDT=$G(LRIDT(LRSC)) Q:'LRIDT  S S1=LRIX(LRSC)+1,S2=LRIX(LRSC+1)
	I LRSC=1 K LRNOTE,LRSV S LRNOTE=0
	I LRSUB'=LRSUB(LRSC) S LRSUB=LRSUB(LRSC) K LRSV
	Q
LAST	Q:$G(LRLAST)  W !,$$CJ^XLFSTR("[  *** End Of Report ***  ]",LRIOM),!
	S LREND=1,LRLAST=1 D B2
	Q
BOT	;D KEYCOM^LRX:$E(IOST,1,2)'="C-"
	I $E(IOST,1,2)'="C-" D
	. W !,LREQUAL
	. W !!,"  ------------------------------  COMMENTS  ------------------------------"
	. W !,"  Key:  'L' = reference Low,  'H' = reference Hi, '*' = critical range"
	N II
	W !,LRDASH
	I $G(LRNOTE) F II=1:1:LRNOTE  S LRIDT1=LRNOTE(II) D
	. ;I LRY'<LRWPL D B1 Q:$G(LREND)  S LRBOT=1 D HEAD K LRBOT
	. W !,$C(II+64) S J=0 F  S J=$O(^LR(LRDFN,LRSUB,LRIDT1,1,J)) Q:J<1  D
	. . W ?5,^(J,0) W:$O(^LR(LRDFN,LRSUB,LRIDT1,1,J)) !
	K LRNOTE S LRNOTE=0
	S LREND=$S(+$O(^LR(LRDFN,LRSUB,LRIDT))<1:1,+$O(^(LRIDT))>LREDT:1,1:0) I LREND D LAST Q
B1	W !,"WORK COPY - DO NOT FILE   ",PNM,?60,SSN S LRY=2
	I $E(IOST,1,2)="C-" W !?20," PRESS '^' TO STOP REPORT " R X:DTIME S:X="" X=1 S LREND=".^"[X Q:$G(LREND)
	Q
B2	;Return to menu
	I $E(IOST,1,2)="C-" W !?20," PRESS 'Enter' TO RETURN TO THE MENU " R X:DTIME
	Q