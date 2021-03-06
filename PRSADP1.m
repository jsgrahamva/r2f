PRSADP1	; HISC/REL,WIRMFO/JAH - Display Employee T&A Data ;AUG 07, 1997
	;;4.0;PAID;**22,114,126,132**;Sep 21, 1995;Build 13
	;;Per VHA Directive 2004-038, this routine should not be modified.
	W:$E(IOST,1,2)="C-" @IOF W !?26,"VA TIME & ATTENDANCE SYSTEM"
	W !?23,"EMPLOYEE TIME AND ATTENDANCE DATA" D HDR
	W !!,?7,"Date",?17,"TW",?21,"Scheduled Tour",?46,"Tour Exceptions"
	W !?2,"------------------------------------------------------------------------",!
F0	; Display Frames
	N Y8
	K Y1,Y2 S Y1=$G(^PRST(458,PPI,"E",DFN,"D",DAY,1)),Y2=$G(^(2)),Y3=$G(^(3)),Y4=$G(^(4)),TC=$P($G(^(0)),"^",2),Y8=$G(^(8))
	I Y1="" S Y1=$S(TC=1:"Day Off",TC=2:"Day Tour",TC=3!(TC=4):"Intermittent",1:"")
	I " 1 3 4 "'[TC,$P($G(^PRST(458,PPI,"E",DFN,"D",DAY,10)),"^",1)="" S Y2(1)="Unposted"
	I TC=3,$P($G(^PRST(458,PPI,"E",DFN,"D",DAY,10)),"^",4)=1 S Y2(1)="Day Worked"
	W !?2,DTE S (L3,L4)=0 I Y1="",Y2="" S Y31="" G EX
	D S1
	F K=1:1 Q:'$D(Y1(K))&'$D(Y2(K))  W:K>1 ! W:K=1 ?17,$P($$TWE^PRSATE0(DFN,PPI,DAY),U,5) W:$D(Y1(K)) ?21,Y1(K) W:$D(Y2(K)) ?45,$P(Y2(K),"^",1),?63,$P(Y2(K),"^",2)
	W:Y3'="" !?10,Y3
EX	Q
F1	; Display Pay period for Certification
	K Y1,Y2 S Y1=$G(^PRST(458,PPI,"E",DFN,"D",DAY,1)),Y2=$G(^(2)),Y3=$G(^(3)),Y4=$G(^(4)),TC=$P($G(^(0)),"^",2),Y8=$G(^(8))
	I Y1="" S Y1=$S(TC=1:"Day Off",TC=2:"Day Tour",TC=3!(TC=4):"Intermittent",1:"")
	I " 1 3 4 "'[TC,$P($G(^PRST(458,PPI,"E",DFN,"D",DAY,10)),"^",1)="" S Y2(1)="Unposted"
	I TC=3,$P($G(^PRST(458,PPI,"E",DFN,"D",DAY,10)),"^",4)=1 S Y2(1)="Day Worked"
	W:'$D(PRSNTD) !?2,DTE W:$G(^PRST(458,PPI,"E",DFN,"D",DAY,8))]"" ?16,$P(^(8),U) S (L3,L4)=0 I Y1="",Y2="" S Y31="" G EX
	D S1
	Q
S1	; Set Schedule Array
	S Y31=""
	F L1=1:3:19 S A1=$P(Y1,"^",L1) Q:A1=""  D
	.S L3=L3+1,Y1(L3)=A1 S:$P(Y1,"^",L1+1)'="" Y1(L3)=Y1(L3)_"-"_$P(Y1,"^",L1+1)
	.S:Y31'="" Y31=Y31_", " S Y31=Y31_Y1(L3)
	.I $P(Y1,"^",L1+2)'="" S L3=L3+1,Y1(L3)="  "_$P($G(^PRST(457.2,+$P(Y1,"^",L1+2),0)),"^",1)
	.I  S Y31=Y31_" "_$P($G(^PRST(457.2,+$P(Y1,"^",L1+2),0)),"^",6)
	.Q
	G:Y4="" S2
	F L1=1:3:19 S A1=$P(Y4,"^",L1) Q:A1=""  D
	.S L3=L3+1,Y1(L3)=A1 S:$P(Y4,"^",L1+1)'="" Y1(L3)=Y1(L3)_"-"_$P(Y4,"^",L1+1)
	.S:Y31'="" Y31=Y31_", " S Y31=Y31_Y1(L3)
	.I $P(Y4,"^",L1+2)'="" S L3=L3+1,Y1(L3)="  "_$P($G(^PRST(457.2,+$P(Y4,"^",L1+2),0)),"^",1)
	.I  S Y31=Y31_" "_$P($G(^PRST(457.2,+$P(Y1,"^",L1+2),0)),"^",6)
	.Q
S2	; Set Worked Array
	QUIT:$D(PRSNTD)
	F L1=1:4:25 D  I A1="" G S8
	.S A1=$P(Y2,"^",L1+2) Q:A1=""  S L4=L4+1
	.S A2=$P(Y2,"^",L1) I A2'="" S Y2(L4)=A2_"-"_$P(Y2,"^",L1+1)
	.S K=$O(^PRST(457.3,"B",A1,0)) S $P(Y2(L4),"^",2)=A1_" "_$P($G(^PRST(457.3,+K,0)),"^",2)
	.I $P(Y2,"^",L1+3)'="" S L4=L4+1,Y2(L4)="  "_$P($G(^PRST(457.4,+$P(Y2,"^",L1+3),0)),"^",1)
	.QUIT
	QUIT
	;
S8	;get telework hours of node 8
	F L1=2,3,4 I $P($G(Y8),U,L1) S L4=L4+1,Y2(L4)=$J($P(Y8,U,L1),0,2)_$$DAYHR()_" - Telework "_$P("REG^MED^Ad Hoc",U,L1-1)
	QUIT
DAYHR()	;return text for telework days or hours based on tour type
	;
	Q $S($G(TC)=2!($G(TC)=3):" Day",1:" Hours")
	;
HDR	; Display Employee Data
	N A
	S A=$$TWE^PRSATE0(DFN,$S($G(PPE)]"":PPI,1:"")),C0=^PRSPC(DFN,0) W !!,$P(C0,"^",1) W:$G(PPE)="" ?30,"Telework Indicator: ",$S($P(A,U)]"":$P(A,U),1:"None") S X=$P(C0,"^",9)
	I '$G(PRSTLV)!($G(PRSTLV)=1) W ?65,"XXX-XX-",$E(X,6,9)
	I $G(PRSTLV)=2!($G(PRSTLV)=3) W ?65,$E(X),"XX-XX-",$E(X,6,9)
	I $G(PRSTLV)=7 W ?65,$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,9)
	W !!,"Station: ",$P(C0,"^",7),?30,"Normal Hours: ",$J($P(C0,"^",16),3),?65,"Duty Basis:",?77,$P(C0,"^",10)
	W !,"T&L:     ",$P(C0,"^",8),?30,"Pay Plan:",?46,$P(C0,"^",21),?65,"Comp/Flex:",?77,$S(PPE'="":$P($G(^PRST(458,PPI,"E",DFN,0)),"^",6),1:$P($G(^PRSPC(DFN,1)),"^",7))
	W ! W:PPE'="" "Pay Per: ",PPE,?30,"Telework Indicator: ",$S($P(A,U,3)]"":$P(A,U,3),$P(A,U)]""&($G(PPE)=""):$P(A,U),1:"None"),?65,"FLSA:",?77,$P(C0,"^",12) Q
