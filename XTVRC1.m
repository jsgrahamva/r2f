XTVRC1	;ISCSF/JLI - SAVE AND COMPARE ROUTINES ;8/11/10
	;;7.3;TOOLKIT;**127**; Apr 25, 1995;Build 4
	;;Per VHA Directive 2004-038, this routine should not be modified.
	K ^TMP($J)
	K ^TMP($J) X ^%ZOSF("RSEL") G:$O(^UTILITY($J,""))="" KILL S %X="^UTILITY($J,",%Y="^TMP($J," D %XY^%RCR K ^UTILITY($J)
ASK	R !!?5,"Do you want to QUEUE this job? YES// ",X:DTIME W ! G:'$T!(X[U) KILL S:X="" X="Y" S X=$E(X) I "YyNn"'[X W $C(7),"  ??",!,"ANSWER 'YES' OR 'NO'",! G ASK
	I "Yy"[X S ZTIO="",ZTRTN="DQ^XTVRC1",ZTDESC="XTVRC1-RECORD ROUTINE CHANGES",ZTSAVE("^TMP($J,")="" D ^%ZTLOAD K ZTIO,ZTRTN,ZTDESC,ZTSAVE,^TMP($J) G KILL
DQ	;
	S X="N",%DT="T" D ^%DT S XTVTIM=Y
	S XTROU=0 F XTIROU=0:0 S XTROU=$O(^TMP($J,XTROU)) Q:XTROU=""  D LCHEK I L D LOOP
KILL	K XTVTIM,XTROU,XTIROU,XCNP,DIF,%,%DT,%Y,%GO,%H,%N,%UCN,DA,DLAYGO,I,J,L,X,Y,DIC,^TMP($J)
	Q
	;
LCHEK	;
	S L=$L(XTROU) I L<6 S L=1 Q
	S XX=$E(XTROU,L-3,L) I XX?1"INIT"!(XX?1"INIS")!(XX?1"INI"1N) S L=0 K XX Q
	I XX?1"IN"2NU!(XX?1"I"1N2NU) S L=0 K XX Q
	S XX=$E(XTROU,L-4,L) I XX?1"INI"2NU!(XX?1"IN"1N2NU)!(XX?1"INIT"2NU)!(XX?1"INI"1N2NU) S L=0 K XX Q
	S L=1 K XX
	Q
	;
LOOP	;
	N X S X=$G(XTROU) X ^%ZOSF("TEST") Q:'$T  ;p127 check routine if it isn't existed
	I XTROU'?1(1A,1"%").7AN Q  ;p127 check routine name
	K ^TMP($J,0) S X=XTROU,XCNP=0,DIF="^TMP($J,0," X ^%ZOSF("LOAD")
	I '$D(^XTV(8991,"B",XTROU)) S X=""""_XTROU_"""",DIC(0)="XL",DIC=8991,DLAYGO=8991 D ^DIC Q:Y'>0
	S DA=$O(^XTV(8991,"B",XTROU,0)) Q:DA'>0
	S I=0 F J=0:0 S J=$O(^XTV(8991,DA,1,J)) Q:J'>0  S I=J
	I I>0 D CHK I I=0 Q
	S XTLL=I,X=XTVTIM,DIC="^XTV(8991,"_DA_",1,",DIC("P")=8991.01,DIC(0)="L",DLAYGO=8991,DA(1)=DA S:'$D(@(DIC_"0)")) @(DIC_"0)")="^8991.01" D ^DIC S DA=+Y Q:DA'>0
	S DIC="^XTV(8991,"_DA(1)_",1,"_DA_",1,"
	F I=0:0 S I=$O(^TMP($J,0,I)) Q:I'>0  S @(DIC_I_",0)")=^(I,0),K=I
	S ^XTV(8991,DA(1),1,DA,1,0)="^8991.11^"_K_"^"_K
	I XTLL>0 S I=XTLL D CHKA
	K DA,DIC,I,J,XTJJ,XTJL,K,XTKK,L,XTL1,XTLL,M,P,V,X,Y
	Q
	;
CHK	;
	S DIC="^XTV(8991,"_DA_",1,"_I_",1,"
	F J=0:0 S J=$O(^TMP($J,0,J)) Q:J'>0  Q:'$D(@(DIC_J_",0)"))  Q:^(0)'=^TMP($J,0,J,0)
	I J'>0 S I=0 Q
	Q
	;
CHKA	;
	S DIC="^XTV(8991,"_DA(1)_",1,"_I_",1,"
	S L=1 F J=0:0 S J=$O(^TMP($J,0,J)) Q:J'>0  Q:'$D(@(DIC_L_",0)"))  S M=0 S:^(0)'=^TMP($J,0,J,0) M=1 D:M CHK1 I 'M K @(DIC_L_",0)") S L=L+1
	I J'>0 F J=0:0 Q:'$D(@(DIC_L_",0)"))  D LDEL
	I J>0 F J=J-1:0 S J=$O(^TMP($J,0,J)) Q:J'>0  D JADD
	S L=0 F J=0:0 S J=$O(^XTV(8991,DA,1,I,1,J)) Q:J'>0  S L(0)=J,L=L+1
	I L>0 S ^XTV(8991,DA,1,I,1,0)="^8991.11^"_L(0)_"^"_L
	Q
	;
CHK1	;
	S XTDONE=0
	F XTJJ=J:0 S XTJJ=$O(^TMP($J,0,XTJJ)) Q:XTJJ'>0  I ^(XTJJ,0)=@(DIC_L_",0)") D CHK2 Q
	I 'XTDONE D LDEL S J=J-1
	K XTDONE
	Q
	;
CHK2	;
	F XTLL=L+1:1 Q:'$D(@(DIC_XTLL_",0)"))!(XTDONE>2)  F XTJL=J:0 S XTJL=$O(^TMP($J,0,XTJL)) Q:XTJL'>0!(XTJL'<XTJJ)  S XTDONE=$S(^(XTJL,0)=@(DIC_XTLL_",0)"):XTDONE+1,1:0) I XTDONE D CHK3 Q:XTDONE>2  Q:'$D(@(DIC_XTLL_",0)"))
	I 'XTDONE D JADD
	S XTDONE='XTDONE
	Q
	;
CHK3	;
	F XTKK=0:0 S XTLL=XTLL+1,XTJL=XTJL+1 S XTDONE=$S('$D(^TMP($J,0,XTJL,0))!'$D(@(DIC_XTLL_",0)")):0,^TMP($J,0,XTJL,0)=@(DIC_XTLL_",0)"):XTDONE+1,1:0) Q:'XTDONE!(XTDONE>2)
	Q
	;
JADD	;
	S XTLL=0 F XTJJ=0:0 S XTJJ=$O(@(DIC_L_",""INS"","_XTJJ_")")) Q:XTJJ'>0  S XTLL=XTJJ
	S XTJJ=XTLL+1,@(DIC_L_",""INS"","_XTJJ_",0)")=^TMP($J,0,J,0)
	S @(DIC_L_",""INS"",0)")="^8991.12^"_XTJJ_"^"_XTJJ
	Q
	;
LDEL	;
	S @(DIC_L_",""DEL"")")=@(DIC_L_",0)") S @(DIC_L_",0)")="" S L=L+1
	Q
