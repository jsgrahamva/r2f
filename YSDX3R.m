YSDX3R	;SLC/DJP - Print of Diagnosis for the Mental Health Medical Record ;12/13/93 16:02
	;;5.01;MENTAL HEALTH;**107**;Dec 30, 1994;Build 23
	;
	; Called from the top by MENU option YSDIAGP-DX
	;D RECORD^YSDX0001("YSDX3R^YSDX3R") ;Used for testing.  Inactivated in YSDX0001...
	;
ENTRY	;
	;D RECORD^YSDX0001("ENTRY^YSDX3R") ;Used for testing.  Inactivated in YSDX0001...
	W @IOF W !!?IOM-$L("PRINT OF DIAGNOSIS")\2,"PRINT OF DIAGNOSIS",!!
	D ^YSLRP I YSTOUT!YSUOUT!(YSDFN'>0) G END
	I '$D(^YSD(627.8,"AC",YSDFN)) W !!?10,"No diagnosis on file for ",YSNM G END
QUES1	;
	W !!,"SORT BY (D)IAGNOSIS or (C)HRONOLOGICALLY?  D// " R A:DTIME S YSTOUT='$T,YSUOUT=A["^" I YSTOUT!YSUOUT G END
	S A=$E(A) S:A="" A="D" I A["?" W !!,"You may list diagnoses sequentially or by date.",!! G QUES1
	I "DdCc"'[A W " ?",! G QUES1
QUES2	;
	;D RECORD^YSDX0001("QUES2^YSDX3R") ;Used for testing.  Inactivated in YSDX0001...
	S %=0 F  Q:$G(%)  W !,"LIST ONLY ACTIVE DIAGNOSIS" S %=1 D
	.D YN^DICN I '% W !!,"You may list only active diagnoses or both active and inactive diagnoses.",!
	S:%=2 YSTY="ALL" I %=-1 G END
	S:'$D(YSTY) YSTY="ACT"
DEVICE	;
	;D RECORD^YSDX0001("DEVICE^YSDX3R") ;Used for testing.  Inactivated in YSDX0001...
	K IOP S %ZIS="Q" D ^%ZIS I POP G END
	I $D(IO("Q")) S ZTRTN="ENPR^YSDX3R",(ZTSAVE("A"),ZTSAVE("YS*"))="",ZTDESC="YS DX PT" D ^%ZTLOAD G END
ENPR	;Entry to core of print program.
	;D RECORD^YSDX0001("ENPR^YSDX3R") ;Used for testing.  Inactivated in YSDX0001...
	S YSFHDR="DIAGNOSIS LIST",YSFHDR(1)="W !!,""DSM/ICD TITLE"" X YSFHDR(2),YSFHDR(3)",YSFHDR(2)="I YSTY=""ACT"" W ?25,""**** Only Active Diagnosis ****""",YSFHDR(3)="W !,""STATUS"",?10,""DATE""" S YSPP=0
PR	;  Called from YSDX3RU
	;D RECORD^YSDX0001("PR^YSDX3R") ;Used for testing.  Inactivated in YSDX0001...
	U IO D:'$D(YSNOFORM) ENHD^YSFORM S Y1=0,YST=$S(IOST?1"P".E:1,1:0),YSSL=$S(YST:8,1:3),YSLFT=0
	D DXLS^YSDX3RUA G:YSTOUT!YSUOUT END D DX^YSDX3RU:"Dd"[A,CHR^YSDX3RU:"Cc"[A I YSTOUT!YSUOUT G END
	D AX4^YSDX3RUA G:YSTOUT!YSUOUT END D AX5^YSDX3RUA
	S YSCON=0 D:'$D(YSFFS) FINISH^YSDX3RU
END	;
	;D RECORD^YSDX0001("END^YSDX3R") ;Used for testing.  Inactivated in YSDX0001...
	I $G(ZTSK) S ZTREQ="@"
	D KVAR^VADPT,^%ZISC
	K A,A1,A2,A3,A4,A5,A6,A7,A8,A9,G,G1,G2,G3,G4,G5,G6,G7,G8,G9
	K G10,G11,J,K,L,L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,M,W,X,Y,Y1
	K YSAX4,YSD3FLG,YSDIFLG,YSDXNN,YSDXN,YSML,YSMOD,YSDXDT
	K TOTSET,SUBSET,YSDFN,YSAUTH,YSCD,YSCOND,YSDOB,YSDTM,YSDXS
	K YSFHDR,YSFTR,YSGAF,YSLC,YSLFT,YSNM,YSPP,YSPS,YSSL,YSSSN
	K YSSTOP,YST,YSTM,YSTOP1,YSTOP2,YSTY,YSAGE,YSDUZ,YSSEX,YSQT
	K Z,Z1,YSLCN,YSCON,DIWR,DIWL,DIWF,YSFFS
	QUIT
	;
EOR	;YSDX3R - Print Diagnosis for Medical Record ;12/6/90 11:19