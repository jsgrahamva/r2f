ONCOSSA4	;WASH ISC/SRR,MLH-PLOT SURVIVAL SURVES ;11/1/93  12:33
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
PLOT	;plot survival curves
	;in:  CASES,HEADER,LEN,NGRPS,NMORT,NPG,XCRT,^TMP($J
	;use: GRP
	;out: NPG
	;do:  TOF^ONCOSSA3
	D TOF^ONCOSSA3 Q:ONCOEX  W $P(HEADER,U,1),"Survival Curve",$S(NGRPS>1:"s",1:"")
	W ?IOM-30,$P(HEADER,U,2),NPG I NMORT=0 W !!,"NO deaths!",! Q
	N IX,LMORT,LN,N,NLN,NX,P,XADJ,XSCL,XSIZ,YSIZ
	I IOM<120 S NLN=20,XSIZ=60
	E  S NLN=50,XSIZ=120
	S XSCL=0,YSIZ=100/NLN,LMORT=""
	F GRP=1:1:NGRPS S N=CASES(GRP) D:N CPLT
	S X="1;.01^3;.025^6;.05^12;.1^30;.25^60;.5^120;1",XSCL=XSCL/LEN
	I XSCL>120 S XSCL=XSCL-1/120+1\1
	E  F GRP=1:1:99 S Y=$P(X,U,GRP) Q:Y=""  I XSCL'>+Y S XSCL=$P(Y,";",2) Q
	S:XSIZ=60 XSCL=XSCL+XSCL S XADJ=XSCL*LEN
	F GRP=1:1:NGRPS S:$D(INS(GRP)) INTS(GRP)=INTS(GRP)\XADJ
	F LN=0:1:NLN-1 D PLIN
	W !?7,"0 |" F X=1:1:XSIZ W $S(X#10=0:"+",1:"-")
	W !,"  ",$P(LEN,U,3),":",?8 S Y=$S(XSCL<.1:2,XSCL<.5:1,1:0)
	F X=0:10:XSIZ W $J(X*XSCL,3,Y),"       "
	Q
	;
CPLT	;compute plot coordinates
	S P=100,(IX(GRP),Z)=0
	F X=-1:0 S X=$O(^TMP($J,"KM",GRP,X)) Q:X=""  D CP1 S Z=X
	S INTS(GRP)=Z S:Z>XSCL XSCL=Z S LMORT=LMORT_$D(^TMP($J,"KM",GRP,Z,1))
	Q
CP1	;compute Psurv
	I '$D(^TMP($J,"KM",GRP,X,1)) S N=N-^(0) Q
	S Y=^TMP($J,"KM",GRP,X,1) F %=1:1:Y S N=N-1,P=P*N/(N+1)
	S N=N-(+$G(^TMP($J,"KM",GRP,X,0))),Y=100-P\YSIZ S:Y&'$D(^TMP($J,"PLT",GRP,Y)) ^(Y)=X
	Q
	;
PLIN	;plot a line
	N C
	F GRP=1:1:NGRPS D:CASES(GRP) PL1
	S Y="" F C=0:1:XSIZ S Y=Y_$S($D(C(C)):C(C),1:" ") Q:$O(C(C))=""
	I LN#4=0 W !?5,$J(NLN-LN/NLN*100,3)," +",Y
	E  W !?9,"|",Y
	Q
PL1	;setup line in C(
	S X=$O(^TMP($J,"PLT",GRP,LN)),Z=$S(X="":INTS(GRP),1:^(X)\XADJ),NX(GRP)=Z
	F C=IX(GRP):1:Z S C(C)=$S($D(C(C)):"*",1:$C(GRP+64))
	I X=""&'$E(LMORT,GRP) S CASES(GRP)=0
	E  S IX(GRP)=NX(GRP)
	Q
