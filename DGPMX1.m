DGPMX1 ; GENERATED FROM 'DGPM ADMIT' INPUT TEMPLATE(#446), FILE 405;07/12/15
 D DE G BEGIN
DE S DIE="^DGPM(",DIC=DIE,DP=405,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^DGPM(DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,1) S:%]"" DE(2)=% S %=$P(%Z,U,4) S:%]"" DE(13)=% S %=$P(%Z,U,5) S:%]"" DE(16)=% S %=$P(%Z,U,6) S:%]"" DE(21)=% S %=$P(%Z,U,7) S:%]"" DE(22)=% S %=$P(%Z,U,10) S:%]"" DE(17)=% S %=$P(%Z,U,11) S:%]"" DE(10)=%
 I  S %=$P(%Z,U,12) S:%]"" DE(5)=%
 I $D(^("DIR")) S %Z=^("DIR") S %=$P(%Z,U,1) S:%]"" DE(4)=%
 I $D(^("ODS")) S %Z=^("ODS") S %=$P(%Z,U,1) S:%]"" DE(26)=%
 I $D(^("PTF")) S %Z=^("PTF") S %=$P(%Z,U,4) S:%]"" DE(7)=%
 I $D(^("USR")) S %Z=^("USR") S %=$P(%Z,U,3) S:%]"" DE(29)=% S %=$P(%Z,U,4) S:%]"" DE(31)=%
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
BEGIN S DNM="DGPMX1",DQ=1
 N DIEZTMP,DIEZAR,DIEZRXR,DIIENS,DIXR K DIEFIRE,DIEBADK S DIEZTMP=$$GETTMP^DIKC1("DIEZ")
 M DIEZAR=^DIE(446,"AR") S DICRREC="TRIG^DIE17"
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIIENS=DA_",",DIEZ=446,U="^"
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 S:$S(DGPMN:1,DGPMY=+^DGPM(DA,0):1,1:0) Y=41
 Q
2 S DW="0;1",DV="RDX",DU="",DLB="DATE/TIME",DIFLD=.01
 S DE(DW)="C2^DGPMX1"
 S X=DGPMY
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
C2 G C2S:$D(DE(2))[0 K DB
 S X=DE(2),DIC=DIE
 K ^DGPM("B",$E(X,1,30),DA)
 S X=DE(2),DIC=DIE
 S DGPMDDF=1 D ^DGPMDD2
 S X=DE(2),DIC=DIE
 ;
 S X=DE(2),DIC=DIE
 ;
 S X=DE(2),DIC=DIE
 ;
 S X=DE(2),DIC=DIE
 K:$P(^DGPM(DA,0),U,3) ^DGPM("ADFN"_$P(^(0),U,3),X,DA)
 S X=DE(2),DIC=DIE
 S Y=$P(^DGPM(DA,0),U,2) I Y,Y'=4,Y'=5,X,X<DT S DGHNYT=$S(Y=1:2,Y=2:5,Y=3:8,1:14) D ^DGPMGLC
 S X=DE(2),DIC=DIE
 I "^1^3^"[("^"_$P(^DGPM(DA,0),"^",2)_"^") S A1B2TAG="ADM" D ^A1B2XFR
C2S S X="" G:DG(DQ)=X C2F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^DGPM("B",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 S DGPMDDF=1 D ^DGPMDD1
 S X=DG(DQ),DIC=DIE
 X ^DD(405,.01,1,3,1.3) I X S X=DIV X ^DD(405,.01,1,3,89.2) S X=$P(Y(101),U,1) S D0=I(0,0) S DIU=X K Y S X=DIV S X=DIV X ^DD(405,.01,1,3,1.4)
 S X=DG(DQ),DIC=DIE
 S:$P(^DGPM(DA,0),U,22)="" $P(^(0),U,22)=0
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X=$S('$D(^DGPM(+$P(^DGPM(DA,0),U,24),0)):0,1:X'=+^(0)) I X S X=DIV S Y(1)=$S($D(^DGPM(D0,0)):^(0),1:"") S X=$P(Y(1),U,24),X=X S DIU=X K Y S X="" X ^DD(405,.01,1,5,1.4)
 S X=DG(DQ),DIC=DIE
 S:$P(^DGPM(DA,0),U,3) ^DGPM("ADFN"_$P(^(0),U,3),X,DA)=""
 S X=DG(DQ),DIC=DIE
 S Y=$P(^DGPM(DA,0),U,2) I Y,Y'=4,Y'=5,X,X<DT S DGHNYT=$S(Y=1:$S($D(DGIDX):3,1:1),Y=2:$S($D(DGIDX):6,1:4),Y=3:$S($D(DGIDX):9,1:7),1:15) D ^DGPMGLC K DGIDX
 S X=DG(DQ),DIC=DIE
 I "^1^3^"[("^"_$P(^DGPM(DA,0),"^",2)_"^") S A1B2TAG="ADM" D ^A1B2XFR
C2F1 Q
X2 S %DT="ST" D ^%DT K %DT S X=Y K:Y<1 X I $D(X),'$D(DGPMT) W !?3,*7,"USE BED CONTROL MOVEMENT OPTIONS!" K X
 Q
 ;
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 G A
4 D:$D(DG)>9 F^DIE17,DE S DQ=4,DW="DIR;1",DV="SXR",DU="",DLB="DOES THE PATIENT WISH TO BE EXCLUDED FROM THE FACILITY DIRECTORY?",DIFLD=41
 S DE(DW)="C4^DGPMX1"
 S DU="0:NO;1:YES;"
 G RE
C4 G C4S:$D(DE(4))[0 K DB
 S X=DE(4),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGPM(D0,"DIR")):^("DIR"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" S DIH=$G(^DGPM(DIV(0),"DIR")),DIV=X S $P(^("DIR"),U,2)=DIV,DIH=405,DIG=42 D ^DICR
 S X=DE(4),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGPM(D0,"DIR")):^("DIR"),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" S DIH=$G(^DGPM(DIV(0),"DIR")),DIV=X S $P(^("DIR"),U,3)=DIV,DIH=405,DIG=43 D ^DICR
 S X=DE(4),DIC=DIE
 S DGPMDDF=41,DGPMDDT=0 D ^DGPMDDCN
C4S S X="" G:DG(DQ)=X C4F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGPM(D0,"DIR")):^("DIR"),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X=DIV N %I,%H,% D NOW^%DTC S X=% X ^DD(405,41,1,1,1.4)
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGPM(D0,"DIR")):^("DIR"),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X=DIV S X=$G(DUZ) S DIH=$G(^DGPM(DIV(0),"DIR")),DIV=X S $P(^("DIR"),U,3)=DIV,DIH=405,DIG=43 D ^DICR
 S X=DG(DQ),DIC=DIE
 S DGPMDDF=41,DGPMDDT=1 D ^DGPMDDCN
C4F1 Q
X4 I $D(X),'$D(DGPMT) D EN^DDIOL("USE BED CONTROL MOVEMENT OPTIONS!",,"!") K X
 Q
 ;
5 D:$D(DG)>9 F^DIE17,DE S DQ=5,DW="0;12",DV="R*P43.4'",DU="",DLB="ADMITTING REGULATION",DIFLD=.12
 S DU="DIC(43.4,"
 G RE
X5 S DIC("S")="I '$P(^(0),""^"",4)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 G A
7 S DW="PTF;4",DV="P35.2'",DU="",DLB="ADMITTING CATEGORY",DIFLD=54
 S DU="DG(35.2,"
 S X=$$ADCAT^DGSAUTL($P(^DGPM(DA,0),U,12))
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X7 Q
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 I $S('$D(^DPT(DFN,.3)):1,$P(^(.3),"^",1)'="Y":1,1:0) S Y="@11"
 Q
9 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=9 G A
10 S DW="0;11",DV="S",DU="",DLB="ADMITTED FOR SC CONDITION?",DIFLD=.11
 S DU="1:YES;0:NO;"
 G RE
X10 Q
11 S DQ=12 ;@11
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 S ^DISV(DUZ,"^DG(405.1,")=$S($D(^DISV(DUZ,"DGPM1")):^("DGPM1"),1:"")
 Q
13 S DW="0;4",DV="R*P405.1'X",DU="",DLB="TYPE OF ADMISSION",DIFLD=.04
 S DE(DW)="C13^DGPMX1"
 S DU="DG(405.1,"
 G RE
C13 G C13S:$D(DE(13))[0 K DB
 S X=DE(13),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGPM(D0,0)):^(0),1:"") S X=$P(Y(1),U,18),X=X S DIU=X K Y S X="" S DIH=$G(^DGPM(DIV(0),0)),DIV=X S $P(^(0),U,18)=DIV,DIH=405,DIG=.18 D ^DICR
C13S S X="" G:DG(DQ)=X C13F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGPM(D0,0)):^(0),1:"") S X=$P(Y(1),U,18),X=X S DIU=X K Y S X=DIV S X=$S($D(^DG(405.1,X,0)):$P(^(0),"^",3),1:"") X ^DD(405,.04,1,1,1.4)
C13F1 Q
X13 S DIC("S")="I $D(DGPMT),($P(^(0),""^"",2)=DGPMT),$P(^(0),""^"",4) S DGER=0,DGPMTYP=$P(^(0),""^"",3) D:DGPMT<4!(DGPMT=6)!(DGPMT=5) @(""DICS^DGPMV3""_DGPMT) I 'DGER" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 S ^DISV(DUZ,"DGPM1")=$S($D(^DISV(DUZ,"^DG(405.1,")):^("^DG(405.1,"),1:"")
 Q
15 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=15 D X15 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X15 I $P(^DGPM(DA,0),"^",18)'=9 S Y=.1
 Q
16 D:$D(DG)>9 F^DIE17,DE S DQ=16,DW="0;5",DV="RP4'X",DU="",DLB="TRANSFER FACILITY",DIFLD=.05
 S DE(DW)="C16^DGPMX1"
 S DU="DIC(4,"
 G RE
C16 G C16S:$D(DE(16))[0 K DB
 S X=DE(16),DIC=DIE
 I $P(^DGPM(DA,0),"^",2)=3 S A1B2TAG="ADM" D ^A1B2XFR
C16S S X="" G:DG(DQ)=X C16F1 K DB
 S X=DG(DQ),DIC=DIE
 I $P(^DGPM(DA,0),"^",2)=3 S A1B2TAG="ADM" D ^A1B2XFR
C16F1 Q
X16 I '$D(DGPMT) W !?3,*7,"USE BED CONTROL MOVEMENT OPTIONS!" K X
 Q
 ;
17 D:$D(DG)>9 F^DIE17,DE S DQ=17,DW="0;10",DV="RFX",DU="",DLB="DIAGNOSIS [SHORT]",DIFLD=.1
 G RE
X17 K:$L(X)>30!($L(X)<3)!(X[";") X
 I $D(X),X'?.ANP K X
 Q
 ;
18 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=18 G A
19 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=19 G A
20 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=20 G A
21 S DW="0;6",DV="R*P42'X",DU="",DLB="WARD LOCATION",DIFLD=.06
 S DE(DW)="C21^DGPMX1"
 S DU="DIC(42,"
 G RE
C21 G C21S:$D(DE(21))[0 K DB
 S X=DE(21),DIC=DIE
 S DGPMDDF=6,DGPMDDT=0 D ^DGPMDDCN
 S X=DE(21),DIC=DIE
 ;
 S X=DE(21),DIC=DIE
 S Y=^DGPM(DA,0) I +Y,Y<DT,X'=$P(Y,U,6) S Y=$P(Y,U,2) I Y<3 S DGOWD=$S($D(^DIC(42,+X,0)):$P(^(0),U),1:"") K DGIDX
C21S S X="" G:DG(DQ)=X C21F1 K DB
 S X=DG(DQ),DIC=DIE
 S DGPMDDF=6,DGPMDDT=1 D ^DGPMDDCN
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGPM(D0,0)):^(0),1:"") S X=$P(Y(1),U,7),X=X S DIU=X K Y S X="" S DIH=$G(^DGPM(DIV(0),0)),DIV=X S $P(^(0),U,7)=DIV,DIH=405,DIG=.07 D ^DICR
 S X=DG(DQ),DIC=DIE
 S Y=^DGPM(DA,0) I +Y,Y<DT S Y=$P(Y,U,2) I Y<3,$D(DGOWD) S DGHNYT=$S(Y=1:10,1:12) D ^DGPMGLC K DGIDX
C21F1 Q
X21 S DIC("S")="I $S($D(^(""ORDER"")):^(""ORDER""),1:0)" D W^DGPMVDD I $D(X) D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X I $D(X) D WARD^DGPMVDD K:$D(DGOOS) X K DGOOS
 Q
 ;
22 D:$D(DG)>9 F^DIE17,DE S DQ=22,DW="0;7",DV="*P405.4'X",DU="",DLB="ROOM-BED",DIFLD=.07
 S DE(DW)="C22^DGPMX1"
 S DU="DG(405.4,"
 G RE
C22 G C22S:$D(DE(22))[0 K DB
 S X=DE(22),DIC=DIE
 S DGPMDDF=7,DGPMDDT=0 D ^DGPMDDCN
C22S S X="" G:DG(DQ)=X C22F1 K DB
 S X=DG(DQ),DIC=DIE
 S DGPMDDF=7,DGPMDDT=1 D ^DGPMDDCN
C22F1 Q
X22 K:'$D(DGPMT) X I $D(X) S DIC("S")="I $D(^DG(405.4,""W"",+$P(^DGPM(DA,0),""^"",6),+Y)) D OCC^DGPMRB I 'DGPMOC" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X I $D(X) D ROOM^DGPMVDD K:$D(DGOOS) X K DGOOS
 Q
 ;
23 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=23 G A
24 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=24 G A
25 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=25 D X25 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X25 D DFN^DGYZODS S:'DGODS Y="@12"
 Q
26 D:$D(DG)>9 F^DIE17,DE S DQ=26,DW="ODS;1",DV="S",DU="",DLB="ODS AT ADMISSION",DIFLD=11500.01
 S DU="1:YES;0:NO;"
 S Y="1"
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X26 Q
27 S DQ=28 ;@12
28 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=28 D X28 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X28 I DGPMP=^DGPM(DA,0) S Y=""
 Q
29 S DW="USR;3",DV="RP200'",DU="",DLB="LAST EDITED BY",DIFLD=102
 S DU="VA(200,"
 S X=DUZ
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X29 Q
30 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=30 G A
31 S DW="USR;4",DV="RD",DU="",DLB="LAST EDITED ON",DIFLD=103
 S %=$P($H,",",2),X=DT_(%\60#60/100+(%\3600)+(%#60/10000)/100)
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X31 S %DT="STX" D ^%DT S X=Y K:Y<1 X
 Q
 ;
32 G 0^DIE17
