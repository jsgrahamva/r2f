ORUS1	; slc/KCM - Select Items from List ; 12/4/09 4:59pm
	;;3.0;ORDER ENTRY/RESULTS REPORTING;**322**;Dec 17, 1997 ;Build 15
	;
	;DJE/VM *322 added Q:ORMOR to avoid processing of "+" index
	;EN F I=0:0 D INIT R X:DTIME S:'$T X="^" S:X["^"&(X'="^^") DUOUT=1 S:'$L(X) X=ORDFLT S:X["^^" DIROUT=1 S:X["^" Y=-1 Q:'$L(X)!(X["^")!(+$G(ORNOSEL)=1&(X'["?")&(ORUS(0)'["O"))  D CHK Q:ORQUIT  Q:ORBACK  Q:(ORTOT+ORT9)>0  W:ORSEL'["?" $C(7)," ??"
EN	F I=0:0 D  Q:'$L(X)!(X["^")!(+$G(ORNOSEL)=1&(X'["?")&(ORUS(0)'["O"))  D CHK Q:ORQUIT  Q:ORBACK  Q:ORMOR  Q:(ORTOT+ORT9)>0  W:ORSEL'["?" $C(7)," ??"
	. D INIT R X:DTIME S:'$T X="^" S:X["^"&(X'="^^") DUOUT=1 S:'$L(X) X=ORDFLT S:X["^^" DIROUT=1 S:X["^" Y=-1
	Q:ORQUIT  Q:ORBACK  K Y("B"),OR9Y("B") Q:'$L(X)!(X["^")
	S:Y>0 (Y,Y(0))=ORTOT
	W "    " S ORTTAB=$X,J=1 I Y>0 K ^DISV(DUZ,ORUS) D SDISV S ^DISV(DUZ,ORUS,0)=X,I=0 F J=1:1 S I=$O(Y(I)) Q:I=""  S X=$P(Y(I),"^",3),^DISV(DUZ,ORUS)=+Y(I),^DISV(DUZ,ORUS,J)=X W:($X+$L(X))>(IOM-4) !?ORTTAB W X,"   "
	I OR9Y S I=0 F J=J:1 S I=$O(OR9Y(I)) Q:I=""  S X=$P(OR9Y(I),"^"),^DISV(DUZ,ORUS,J)=X W:($X+$L(X))>(IOM-4) !?ORTTAB W X,"   "
	Q
CHK	;
	I X="+",'$D(OR9("+")) W !,"   THIS IS THE END OF THE LIST" S ORSEL="?" Q  ;DJE/VM *322 replace 999 with +
	S ORSEL=X,Y=0 ;DJE/VM *322 removed S:X="+" X=999
	I X["?" D EN^ORUS3 Q
	I X="-" S ORBACK=1,P=$S(P=0:0,1:P-1) Q
	I X="+" S ORMOR=1,P=P+1 Q  ;DJE/VM *322 avoid processing just go to the next page.
	I X=" " D SPAC Q:+$G(ORTOT)>0
	S X=$$UPPER^ORU(X)
	I ORUS(0)["S",X[",",$D(ORUS("ALT")),ORTOT+ORT9'>0,$L(ORSEL) X ORUS("ALT") S:$T ORQUIT=1 Q
	I ORUS(0)["S",X[","!(X["-")!(X["'") D SING Q
	F ORSEQ=1:1:$L(ORSEL,",") Q:ORERR  S X=$P(ORSEL,",",ORSEQ) D SET D:X["-" RNG Q:ORERR  S W=X F K=1:1:$L(W,",") S ORWRK=$P(W,",",K) D EAT I $L(ORWRK) D LOOK^ORUS4 Q:ORERR  D PROC^ORUS2 Q:ORERR
	I $L(ORUS(0),"^")=2,(ORTOT>+$P(ORUS(0),"^",2)) S ORERR=1 W "  ONLY "_+$P(ORUS(0),"^",2)_" ITEMS ALLOWED"
	S:ORERR (ORTOT,ORT9)=0
	I $D(ORUS("ALT")),ORTOT+ORT9'>0,$L(ORSEL) X ORUS("ALT") S:$T ORQUIT=1 Q
	Q
SET	S (ORERR,ORSUB)=0 S:$E(X)["'" ORSUB=1,X=$P(X,"'",2) S:$E(X)["*" X=$P(X,"*",2),X=$S(X["=":X_"*",1:X_"=*") S ORPC=X,ORFLG=$P(X,"=",2),X=$P(X,"=") S:$L(ORFLG) ORFLG="="_ORFLG
	Q
SPAC	S ORERR=1 Q:'$D(^DISV(DUZ,ORUS,0))  D SDISV Q:^DISV(DUZ,ORUS,0)'=X
	S ORSEQ=0 F I=0:0 S ORSEQ=$O(^DISV(DUZ,ORUS,ORSEQ)) Q:ORSEQ'>0  S (X,ORWRK)=^(ORSEQ) D SET,LOOK^ORUS4,PROC^ORUS2
	S ORERR=0 Q
SDISV	S X=$S($D(ORUS("L")):ORUS("L"),1:"")_"^"_$S($D(ORUS("S")):ORUS("S"),1:"")_"^"_$S(ORUS(0)["S":1,1:0) ;_"^"_$S(ORUS(0)["A":1,1:0)
	Q
RNG	Q:X["E"  I X'?.N1"-".N!($P(X,"-",1)'<$P(X,"-",2)) S ORERR=1 Q
	S W="" F J=$P(X,"-",1):1:$P(X,"-",2) S W=W_J_"," I $L(W)>245 W $C(7),"   RANGE OF NUMBERS TOO LARGE." S ORERR=1,ORSEL="?" Q
	S X=W
	Q
SING	W $C(7)," -- ONLY ONE SELECTION ALLOWED." S ORSEL="?" Q
EAT	F I=0:0 Q:$E(ORWRK)]" "  Q:'$L(ORWRK)  S ORWRK=$E(ORWRK,2,999)
	F I=0:0 Q:$E(ORWRK,$L(ORWRK))]" "  Q:'$L(ORWRK)  S ORWRK=$E(ORWRK,1,$L(ORWRK)-1)
	F J=1:1:$L(ORWRK) I $A(ORWRK,J)'>31 S ORWRK="" Q
	Q
INIT	K Y,OR9Y,ORSEL S (Y,OR9Y,ORBACK,ORERR,ORQUIT,ORTOT,ORT9)=0
	S ORPRMT=$S($D(ORUS("A")):ORUS("A"),+ORFN:"Select "_ORFNM_": ",1:"Select Item: ")
	S ORDFLT=$S($D(ORUS("B")):ORUS("B"),1:""),ORMOR=0
	W !!,ORPRMT,$S($L(ORDFLT):ORDFLT_"// ",1:"")
	Q
