RACTQE2 ; ;02/19/12
 D DE G BEGIN
DE S DIE="^RAO(75.1,",DIC=DIE,DP=75.1,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^RAO(75.1,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,5) S:%]"" DE(2)=% S %=$P(%Z,U,6) S:%]"" DE(10)=% S %=$P(%Z,U,18) S:%]"" DE(3)=% S %=$P(%Z,U,19) S:%]"" DE(6)=% S %=$P(%Z,U,22) S:%]"" DE(1)=% S %=$P(%Z,U,24) S:%]"" DE(8)=% S %=$P(%Z,U,26) S:%]"" DE(12)=%
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
BEGIN S DNM="RACTQE2",DQ=1
1 S DW="0;22",DV="P44'",DU="",DLB="REQUESTING LOCATION",DIFLD=22
 S DU="SC("
 S X=RALIFN
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X1 Q
2 S DW="0;5",DV="SX",DU="",DLB="REQUEST STATUS",DIFLD=5
 S DE(DW)="C2^RACTQE2"
 S DU="1:DISCONTINUED;2:COMPLETE;3:HOLD;5:PENDING;6:ACTIVE;8:SCHEDULED;11:UNRELEASED;"
 S X=$S($D(RAPKG):5,$$ORVR^RAORDU()=2.5:11,1:5)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C2 G C2S:$D(DE(2))[0 K DB
 S X=DE(2),DIC=DIE
 K ^RAO(75.1,"AS",+$P(^RAO(75.1,DA,0),U),X,DA)
 S X=DE(2),DIC=DIE
 ;
C2S S X="" G:DG(DQ)=X C2F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^RAO(75.1,"AS",+$P(^RAO(75.1,DA,0),U),X,DA)=""
 S X=DG(DQ),DIC=DIE
 D:$$ORVR^RAORDU()=2.5&((X=1)!(X=3)) CH^RADD2(DA,X)
C2F1 Q
X2 Q
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,DW="0;18",DV="D",DU="",DLB="LAST ACTIVITY DATE/TIME",DIFLD=18
 S DE(DW)="C3^RACTQE2"
 S X="NOW"
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
C3 G C3S:$D(DE(3))[0 K DB
 S X=DE(3),DIC=DIE
 K ^RAO(75.1,"AO",$E(X,1,30),DA)
C3S S X="" G:DG(DQ)=X C3F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^RAO(75.1,"AO",$E(X,1,30),DA)=""
C3F1 Q
X3 S %DT="TXR" D ^%DT S X=Y K:Y<1 X
 Q
 ;
4 D:$D(DG)>9 F^DIE17,DE S DQ=4,D=0 K DE(1) ;75
 S DIFLD=75,DGO="^RACTQE3",DC="4^75.12DA^T^",DV="75.12D",DW="0;1",DOW="STATUS CHANGE DATE/TIME",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 I $D(DSC(75.12))#2,$P(DSC(75.12),"I $D(^UTILITY(",1)="" X DSC(75.12) S D=$O(^(0)) S:D="" D=-1 G M4
 S D=$S($D(^RAO(75.1,DA,"T",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M4 I D>0 S DC=DC_D I $D(^RAO(75.1,DA,"T",+D,0)) S DE(4)=$P(^(0),U,1)
 S X="""NOW"""
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
R4 D DE
 G A
 ;
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 I '$D(RAMT) S RAMT="a"
 Q
6 S DW="0;19",DV="S",DU="",DLB="MODE OF TRANSPORT",DIFLD=19
 S DU="a:AMBULATORY;p:PORTABLE;s:STRETCHER;w:WHEEL CHAIR;"
 S X=$P(RAMT,"^")
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X6 Q
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 I '$D(RAIP) S RAIP="n"
 Q
8 S DW="0;24",DV="S",DU="",DLB="ISOLATION PROCEDURES",DIFLD=24
 S DU="y:YES;n:NO;"
 S X=RAIP
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X8 Q
9 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=9 D X9 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X9 I '$D(RARU) S RARU=9
 Q
10 S DW="0;6",DV="S",DU="",DLB="REQUEST URGENCY",DIFLD=6
 S DU="1:STAT;2:URGENT;9:ROUTINE;"
 S X=RARU
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X10 Q
11 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=11 D X11 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X11 S:$$ORVR^RAORDU()<3 Y="@80"
 Q
12 S DW="0;26",DV="S",DU="",DLB="NATURE OF (NEW) ORDER ACTIVITY",DIFLD=26
 S DU="w:WRITTEN;v:VERBAL;p:TELEPHONED;s:SERVICE CORRECTION;i:POLICY;e:PHYSICIAN ENTERED;"
 S Y="s"
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X12 Q
13 S DQ=14 ;@80
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 S RAFIN=1
 Q
15 S DQ=16 ;@99
16 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=16 D X16 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X16 K RAI,RAPRI,RAMOD,RAIMAG,RAREQLOC,RAMODPRO
 Q
17 G 0^DIE17
