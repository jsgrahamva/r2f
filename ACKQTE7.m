ACKQTE7 ; ;03/04/12
 D DE G BEGIN
DE S DIE="^ACK(509850.6,",DIC=DIE,DP=509850.6,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^ACK(509850.6,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,7) S:%]"" DE(43)=%
 I $D(^(2)) S %Z=^(2) S %=$P(%Z,U,3) S:%]"" DE(21)=% S %=$P(%Z,U,4) S:%]"" DE(27)=%
 I $D(^(4)) S %Z=^(4) S %=$P(%Z,U,17) S:%]"" DE(48)=% S %=$P(%Z,U,18) S:%]"" DE(49)=% S %=$P(%Z,U,24) S:%]"" DE(50)=%
 K %Z Q
 ;
W W !?DL+DL-2,DLB_": "
 Q
O D W W Y W:$X>45 !?9
 I $L(Y)>19,'DV,DV'["I",(DV["F"!(DV["K")) G RW^DIR2
 W:Y]"" "// " I 'DV,DV["I",$D(DE(DQ))#2 S X="" W "  (No Editing)" Q
TR R X:DTIME E  S (DTOUT,X)=U W $C(7)
 Q
A K DQ(DQ) S DQ=DQ+1
B G @DQ
RE G PR:$D(DE(DQ)) D W,TR
N I X="" G NKEY:$D(^DD("KEY","F",DP,DIFLD)),A:DV'["R",X:'DV,X:D'>0,A
RD G QS:X?."?" I X["^" D D G ^DIE17
 I X="@" D D G Z^DIE2
 I X=" ",DV["d",DV'["P",$D(^DISV(DUZ,"DIE",DLB)) S X=^(DLB) I DV'["D",DV'["S" W "  "_X
T G M^DIE17:DV,^DIE3:DV["V",P:DV'["S" X:$D(^DD(DP,DIFLD,12.1)) ^(12.1) I X?.ANP D SET I 'DDER X:$D(DIC("S")) DIC("S") I  W:'$D(DB(DQ)) "  "_% G V
 K DDER G X
P I DV["P" S DIC=U_DU,DIC(0)=$E("EN",$D(DB(DQ))+1)_"M"_$E("L",DV'["'") S:DIC(0)["L" DLAYGO=+$P(DV,"P",2) G:DV["*" AST^DIED D NOSCR^DIED S X=+Y,DIC=DIE G X:X<0
 G V:DV'["N" D D I $L($P(X,"."))>24 K X G Z
 I $P(DQ(DQ),U,5)'["$",X?.1"-".N.1".".N,$P(DQ(DQ),U,5,99)["+X'=X" S X=+X
V D @("X"_DQ) K YS
Z K DIC("S"),DLAYGO I $D(X),X'=U D:$G(DE(DW,"INDEX")) SAVEVALS G:'$$KEYCHK UNIQFERR^DIE17 S DG(DW)=X S:DV["d" ^DISV(DUZ,"DIE",DLB)=X G A
X W:'$D(ZTQUEUED) $C(7),"??" I $D(DB(DQ)) G Z^DIE17
 S X="?BAD"
QS S DZ=X D D,QQ^DIEQ G B
D S D=DIFLD,DQ(DQ)=DLB_U_DV_U_DU_U_DW_U_$P($T(@("X"_DQ))," ",2,99) Q
Y I '$D(DE(DQ)) D O G RD:"@"'[X,A:DV'["R"&(X="@"),X:X="@" S X=Y G N
PR S DG=DV,Y=DE(DQ),X=DU I $D(DQ(DQ,2)) X DQ(DQ,2) G RP
R I DG["P",@("$D(^"_X_"0))") S X=+$P(^(0),U,2) G RP:'$D(^(Y,0)) S Y=$P(^(0),U),X=$P(^DD(X,.01,0),U,3),DG=$P(^(0),U,2) G R
 I DG["V",+Y,$P(Y,";",2)["(",$D(@(U_$P(Y,";",2)_"0)")) S X=+$P(^(0),U,2) G RP:'$D(^(+Y,0)) S Y=$P(^(0),U) I $D(^DD(+X,.01,0)) S DG=$P(^(0),U,2),X=$P(^(0),U,3) G R
 X:DG["D" ^DD("DD") I DG["S" S %=$P($P(";"_X,";"_Y_":",2),";") S:%]"" Y=%
RP D O I X="" S X=DE(DQ) G A:'DV,A:DC<2,N^DIE17
I I DV'["I",DV'["#" G RD
 D E^DIE0 G RD:$D(X),PR
 Q
SET N DIR S DIR(0)="SV"_$E("o",$D(DB(DQ)))_U_DU,DIR("V")=1
 I $D(DB(DQ)),'$D(DIQUIET) N DIQUIET S DIQUIET=1
 D ^DIR I 'DDER S %=Y(0),X=Y
 Q
SAVEVALS S @DIEZTMP@("V",DP,DIIENS,DIFLD,"O")=$G(DE(DQ)) S:$D(^("F"))[0 ^("F")=$G(DE(DQ))
 I $D(DE(DW,"4/")) S @DIEZTMP@("V",DP,DIIENS,DIFLD,"4/")=""
 E  K @DIEZTMP@("V",DP,DIIENS,DIFLD,"4/")
 Q
NKEY W:'$D(ZTQUEUED) "??  Required key field" S X="?BAD" G QS
KEYCHK() Q:$G(DE(DW,"KEY"))="" 1 Q @DE(DW,"KEY")
BEGIN S DNM="ACKQTE7",DQ=1
1 S D=0 K DE(1) ;101
 S Y="MEDICAL HISTORY^W^^0;1^Q",DG="101",DC="^509850.6101" D DIEN^DIWE K DE(1) G A
 ;
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 I $D(DIRUT) S Y="@999"
 Q
3 S DQ=4 ;@290
4 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=4 D X4 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X4 I ACKCP'=1 S Y="@320"
 Q
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 S ACKQHLP="^509850.6^102" D ^ACKQHLP
 Q
6 S D=0 K DE(1) ;102
 S Y="PHYSICAL EXAMINATION^W^^0;1^Q",DG="102",DC="^509850.6102" D DIEN^DIWE K DE(1) G A
 ;
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 I $D(DIRUT) S Y="@999"
 Q
8 S DQ=9 ;@300
9 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=9 D X9 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X9 I ACKCP'=1 S Y="@320"
 Q
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 S ACKQHLP="^509850.6^103" D ^ACKQHLP
 Q
11 S D=0 K DE(1) ;103
 S Y="DIAGNOSTIC AND CLINICAL TESTS^W^^0;1^Q",DG="103",DC="^509850.6103" D DIEN^DIWE K DE(1) G A
 ;
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 I $D(DIRUT) S Y="@999"
 Q
13 S DQ=14 ;@310
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 I ACKCP'=1 S Y="@320"
 Q
15 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=15 D X15 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X15 S ACKQHLP="^509850.6^104" D ^ACKQHLP
 Q
16 S D=0 K DE(1) ;104
 S Y="DIAGNOSIS^W^^0;1^Q",DG="104",DC="^509850.6104" D DIEN^DIWE K DE(1) G A
 ;
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 I $D(DIRUT) S Y="@999"
 Q
18 S DQ=19 ;@320
19 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=19 D X19 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X19 D PROVDIS^ACKQUTL4
 Q
20 S DQ=21 ;@325
21 S DW="2;3",DV="*P509850.3'd",DU="",DLB="PRIMARY PROVIDER",DIFLD=6
 S DE(DW)="C21^ACKQTE7"
 S DU="ACK(509850.3,"
 G RE
C21 G C21S:$D(DE(21))[0 K DB
 S X=DE(21),DIC=DIE
 K ^ACK(509850.6,"ST",X,DA)
 S X=DE(21),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
C21S S X="" G:DG(DQ)=X C21F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^ACK(509850.6,"ST",X,DA)=1
 S X=DG(DQ),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
C21F1 Q
X21 S DIC("S")="I $D(ACKVD),'$$STACT^ACKQUTL(+Y,ACKVD)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
22 S DQ=23 ;@330
23 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=23 D X23 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X23 I $$GET1^DIQ(509850.6,ACKVIEN_",",6)="" W !,"A Primary Provider MUST be entered for this Visit !!",! S Y="@325"
 Q
24 D:$D(DG)>9 F^DIE17,DE S DQ=24,D=0 K DE(1) ;2.7
 S DIFLD=2.7,DGO="^ACKQTE8",DC="1^509850.66PA^2.7^",DV="509850.66M*P509850.3'X",DW="0;1",DOW="SECONDARY PROVIDER",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 S DU="ACK(509850.3,"
 G RE:D I $D(DSC(509850.66))#2,$P(DSC(509850.66),"I $D(^UTILITY(",1)="" X DSC(509850.66) S D=$O(^(0)) S:D="" D=-1 G M24
 S D=$S($D(^ACK(509850.6,DA,2.7,0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M24 I D>0 S DC=DC_D I $D(^ACK(509850.6,DA,2.7,+D,0)) S DE(24)=$P(^(0),U,1)
 G RE
R24 D DE
 S D=$S($D(^ACK(509850.6,DA,2.7,0)):$P(^(0),U,3,4),1:1) G 24+1
 ;
25 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=25 D X25 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X25 I $$GET1^DIQ(509850.6,ACKVIEN_",",6)="" W !,"A Primary Provider MUST be entered for this Visit !!",! S Y="@325"
 Q
26 S DQ=27 ;@340
27 S DW="2;4",DV="*P509850.3'd",DU="",DLB="STUDENT",DIFLD=7
 S DE(DW)="C27^ACKQTE7"
 S DU="ACK(509850.3,"
 G RE
C27 G C27S:$D(DE(27))[0 K DB
 S X=DE(27),DIC=DIE
 K ^ACK(509850.6,"ST",X,DA)
 S X=DE(27),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
C27S S X="" G:DG(DQ)=X C27F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^ACK(509850.6,"ST",X,DA)=3
 S X=DG(DQ),DIC=DIE
 X "D SEND^ACKQUTL5(DA)"
C27F1 Q
X27 S DIC("S")="I $D(ACKVD),$$STACT^ACKQUTL(+Y,ACKVD)=-2" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
28 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=28 D X28 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X28 I $$GET1^DIQ(509850.6,ACKVIEN_",",6)="" W !,"A Primary Provider MUST be entered for this Visit !!",! S Y="@325"
 Q
29 S DQ=30 ;@350
30 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=30 D X30 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X30 I ACKEVENT S Y="@372"
 Q
31 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=31 D X31 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X31 D CPTDIS^ACKQUTL4
 Q
32 D:$D(DG)>9 F^DIE17,DE S DQ=32,D=0 K DE(1) ;10
 S DIFLD=10,DGO="^ACKQTE9",DC="6^509850.61PA^3^",DV="509850.61M*P509850.4'X",DW="0;1",DOW="PROCEDURE CODE",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 S DU="ACK(509850.4,"
 G RE:D I $D(DSC(509850.61))#2,$P(DSC(509850.61),"I $D(^UTILITY(",1)="" X DSC(509850.61) S D=$O(^(0)) S:D="" D=-1 G M32
 S D=$S($D(^ACK(509850.6,DA,3,0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M32 I D>0 S DC=DC_D I $D(^ACK(509850.6,DA,3,+D,0)) S DE(32)=$P(^(0),U,1)
 G RE
R32 D DE
 S D=$S($D(^ACK(509850.6,DA,3,0)):$P(^(0),U,3,4),1:1) G 32+1
 ;
33 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=33 D X33 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X33 I ACKEVENT S Y="@372"
 Q
34 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=34 D X34 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X34 I '$O(^ACK(509850.6,ACKVIEN,3,0)) W !!,$C(7),"You must enter at least one PROCEDURE CODE !!" S Y="@350"
 Q
35 S DQ=36 ;@370
36 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=36 D X36 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X36 I 'ACKEVENT S Y="@378"
 Q
37 S DQ=38 ;@372
38 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=38 D X38 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X38 D EVNTDIS^ACKQUTL5
 Q
39 S D=0 K DE(1) ;15
 S DIFLD=15,DGO="^ACKQTE10",DC="4^509850.615PA^7^",DV="509850.615M*P725'X",DW="0;1",DOW="EVENT CAPTURE PROCEDURE",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 S DU="EC(725,"
 G RE:D I $D(DSC(509850.615))#2,$P(DSC(509850.615),"I $D(^UTILITY(",1)="" X DSC(509850.615) S D=$O(^(0)) S:D="" D=-1 G M39
 S D=$S($D(^ACK(509850.6,DA,7,0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M39 I D>0 S DC=DC_D I $D(^ACK(509850.6,DA,7,+D,0)) S DE(39)=$P(^(0),U,1)
 G RE
R39 D DE
 S D=$S($D(^ACK(509850.6,DA,7,0)):$P(^(0),U,3,4),1:1) G 39+1
 ;
40 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=40 D X40 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X40 I 'ACKEVENT S Y="@378"
 Q
41 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=41 D X41 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X41 I '$O(^ACK(509850.6,ACKVIEN,7,0)) W !!,$C(7),"You must enter at least one EC PROCEDURE CODE !!" S Y="@372"
 Q
42 S DQ=43 ;@378
43 S DW="0;7",DV="RNJ3,0",DU="",DLB="TIME SPENT (minutes)",DIFLD=.07
 G RE
X43 K:+X'=X!(X>999)!(X<0)!(X?.E1"."1N.N) X
 Q
 ;
44 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=44 D X44 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X44 I ACKCP'=1!($P($G(^ACK(509850.6,ACKVIEN,4)),U,17)]"") S Y="@999"
 Q
45 S DQ=46 ;@380
46 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=46 D X46 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X46 S ACKMODE=1 D SIG^ACKQCP
 Q
47 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=47 D X47 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X47 S:'$D(ACKSIG) Y="@999"
 Q
48 S DW="4;17",DV="F",DU="",DLB="SIGNATURE",DIFLD=4.17
 S DE(DW)="C48^ACKQTE7"
 S X=ACKSIG
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C48 G C48S:$D(DE(48))[0 K DB
 S X=DE(48),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^ACK(509850.6,D0,0)):^(0),1:"") S X=$P(Y(1),U,9),X=X S DIU=X K Y S X=DIV D TRIGCP^ACKQUTL X ^DD(509850.6,4.17,1,1,2.4)
C48S S X="" G:DG(DQ)=X C48F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^ACK(509850.6,D0,0)):^(0),1:"") S X=$P(Y(1),U,9),X=X S DIU=X K Y S X=DIV D TRIGCP^ACKQUTL X ^DD(509850.6,4.17,1,1,1.4)
C48F1 Q
X48 Q
49 D:$D(DG)>9 F^DIE17,DE S DQ=49,DW="4;18",DV="D",DU="",DLB="DATE SIGNED",DIFLD=4.18
 S X=DT
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X49 Q
50 S DW="4;24",DV="F",DU="",DLB="COMPLETER TITLE",DIFLD=4.24
 S X=ACKTITL
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X50 Q
51 S DQ=52 ;@999
52 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=52 D X52 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X52 W !
 Q
53 G 0^DIE17
