RTCR ; GENERATED FROM 'RT NEW RECORD' INPUT TEMPLATE(#877), FILE 190;09/19/10
 D DE G BEGIN
DE S DIE="^RT(",DIC=DIE,DP=190,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^RT(DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,3) S:%]"" DE(2)=% S %=$P(%Z,U,5) S:%]"" DE(3)=% S %=$P(%Z,U,6) S:%]"" DE(4)=%,DE(20)=% S %=$P(%Z,U,7) S:%]"" DE(5)=% S %=$P(%Z,U,12) S:%]"" DE(6)=%,DE(18)=%
 I $D(^("CL")) S %Z=^("CL") S %=$P(%Z,U,5) S:%]"" DE(7)=%,DE(21)=% S %=$P(%Z,U,6) S:%]"" DE(8)=% S %=$P(%Z,U,7) S:%]"" DE(9)=% S %=$P(%Z,U,8) S:%]"" DE(10)=% S %=$P(%Z,U,14) S:%]"" DE(23)=% S %=$P(%Z,U,15) S:%]"" DE(11)=%
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
BEGIN S DNM="RTCR",DQ=1
 N DIEZTMP,DIEZAR,DIEZRXR,DIIENS,DIXR K DIEFIRE,DIEBADK S DIEZTMP=$$GETTMP^DIKC1("DIEZ")
 M DIEZAR=^DIE(877,"AR") S DICRREC="TRIG^DIE17"
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIIENS=DA_",",DIEZ=877,U="^"
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 S RTSEMI=$C(59) D DUZ^RTPSET
 Q
2 S DW="0;3",DV="RP195.2'I",DU="",DLB="TYPE OF RECORD",DIFLD=3
 S DE(DW)="C2^RTCR"
 S DU="DIC(195.2,"
 S X=+RTTY
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C2 G C2S:$D(DE(2))[0 K DB
 S X=DE(2),DIC=DIE
 ;
 S X=DE(2),DIC=DIE
 K ^RT("AT",X,$P(^RT(DA,0),U),DA)
C2S S X="" G:DG(DQ)=X C2F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^RT(D0,0)):^(0),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y X ^DD(190,3,1,1,1.1) X ^DD(190,3,1,1,1.4)
 S X=DG(DQ),DIC=DIE
 S ^RT("AT",X,$P(^RT(DA,0),U),DA)=""
C2F1 Q
X2 Q
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,DW="0;5",DV="*P190'I",DU="",DLB="PARENT RECORD",DIFLD=5
 S DE(DW)="C3^RTCR"
 S DU="RT("
 S X=RTPAR
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C3 G C3S:$D(DE(3))[0 K DB
 S X=DE(3),DIC=DIE
 K ^RT("P",$E(X,1,30),DA)
C3S S X="" G:DG(DQ)=X C3F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^RT("P",$E(X,1,30),DA)=""
C3F1 Q
X3 Q
4 D:$D(DG)>9 F^DIE17,DE S DQ=4,DW="0;6",DV="R*P195.9'X",DU="",DLB="HOME LOCATION",DIFLD=6
 S DE(DW)="C4^RTCR"
 S DU="RTV(195.9,"
 S X=$P(RTINIT,U,2)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C4 G C4S:$D(DE(4))[0 K DB
 S X=DE(4),DIC=DIE
 K ^RT("AH",$E(X,1,30),DA)
 S X=DE(4),DIC=DIE
 ;
C4S S X="" G:DG(DQ)=X C4F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^RT("AH",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 X "Q:'$D(^RT(DA,""CL""))  Q:X=$P(^(""CL""),""^"",5)!('$P(^(""CL""),""^"",6))  S ^RT(""AC"",+$P(^(""CL""),""^"",6),DA)="""""
C4F1 Q
X4 Q
5 D:$D(DG)>9 F^DIE17,DE S DQ=5,DW="0;7",DV="RNJ2,0I",DU="",DLB="VOLUME NUMBER",DIFLD=7
 S X=RTVOL
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X5 Q
6 S DW="0;12",DV="F",DU="",DLB="CONTENT DESCRIPTOR",DIFLD=12
 S X=$S($D(RTACCN):RTACCN,1:"")
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X6 Q
7 S DW="CL;5",DV="R*P195.9X",DU="",DLB="CURRENT BORROWER/FILE ROOM",DIFLD=105
 S DE(DW)="C7^RTCR"
 S DU="RTV(195.9,"
 S X=$P(RTINIT,U,5)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C7 G C7S:$D(DE(7))[0 K DB
 S X=DE(7),DIC=DIE
 K ^RT("ABOR",$E(X,1,30),DA)
 S X=DE(7),DIC=DIE
 ;
C7S S X="" G:DG(DQ)=X C7F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^RT("ABOR",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 X "Q:'$D(^RT(DA,""CL""))!('$D(^(0)))  Q:X=$P(^(0),""^"",6)!('$P(^(""CL""),""^"",6))  S ^RT(""AC"",+$P(^(""CL""),""^"",6),DA)="""""
C7F1 Q
X7 Q
8 D:$D(DG)>9 F^DIE17,DE S DQ=8,DW="CL;6",DV="D",DU="",DLB="DATE/TIME CHARGED TO BORROWER",DIFLD=106
 S DE(DW)="C8^RTCR"
 S X=RTNOW
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C8 G C8S:$D(DE(8))[0 K DB
 S X=DE(8),DIC=DIE
 K ^RT("AC",X,DA)
C8S S X="" G:DG(DQ)=X C8F1 K DB
 S X=DG(DQ),DIC=DIE
 X "Q:'$D(^RT(DA,""CL""))!('$D(^(0)))  Q:$P(^(0),""^"",6)=$P(^(""CL""),""^"",5)  S ^RT(""AC"",X,DA)="""""
C8F1 Q
X8 Q
9 D:$D(DG)>9 F^DIE17,DE S DQ=9,DW="CL;7",DV="P200'",DU="",DLB="USER THAT CHARGED RECORD",DIFLD=107
 S DU="VA(200,"
 S X=RTDUZ
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X9 Q
10 S DW="CL;8",DV="*P195.3'",DU="",DLB="TYPE OF MOVEMENT",DIFLD=108
 S DU="DIC(195.3,"
 S X=+$O(^DIC(195.3,"AA",+RTAPL,$S('$D(RTRANEW):"INITIAL CREATION",1:"TRANSFER CREATE INITIAL"),0))
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X10 Q
11 S DW="CL;15",DV="S",DU="",DLB="LAST TIME SELECTED BY BARCODE?",DIFLD=115
 S DU="y:YES;n:NO;"
 S X="n"
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X11 Q
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 S:'$D(RTSHOW) Y="@999"
 Q
13 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=13 D X13 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X13 W !!,$P($P(RTTY,U),RTSEMI,2)," Creation:"
 Q
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 S L=$L($P($P(RTTY,U),RTSEMI,2))+10 W ! F I=1:1:L W "-"
 Q
15 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=15 D X15 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X15 I $D(RTRANEW) S Y="@5"
 Q
16 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=16 D X16 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X16 I $P(RTTY,U,16)'="y" S Y="@10"
 Q
17 S DQ=18 ;@5
18 S DW="0;12",DV="F",DU="",DLB="CONTENT DESCRIPTOR",DIFLD=12
 G RE
X18 K:$L(X)>20!($L(X)<2) X
 I $D(X),X'?.ANP K X
 Q
 ;
19 S DQ=20 ;@10
20 S DW="0;6",DV="R*P195.9'X",DU="",DLB="HOME LOCATION",DIFLD=6
 S DE(DW)="C20^RTCR"
 S DU="RTV(195.9,"
 G RE
C20 G C20S:$D(DE(20))[0 K DB
 S X=DE(20),DIC=DIE
 K ^RT("AH",$E(X,1,30),DA)
 S X=DE(20),DIC=DIE
 ;
C20S S X="" G:DG(DQ)=X C20F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^RT("AH",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 X "Q:'$D(^RT(DA,""CL""))  Q:X=$P(^(""CL""),""^"",5)!('$P(^(""CL""),""^"",6))  S ^RT(""AC"",+$P(^(""CL""),""^"",6),DA)="""""
C20F1 Q
X20 S DIC("V")="I $P(Y(0),U,4)=""L""",DIC("S")="I $D(D0),$D(^DIC(195.2,""AF"",Y,+$P(^RT(D0,0),U,3))) D DICS^RTDPA31" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
21 D:$D(DG)>9 F^DIE17,DE S DQ=21,DW="CL;5",DV="R*P195.9X",DU="",DLB="CURRENT BORROWER/FILE ROOM",DIFLD=105
 S DE(DW)="C21^RTCR"
 S DU="RTV(195.9,"
 G RE
C21 G C21S:$D(DE(21))[0 K DB
 S X=DE(21),DIC=DIE
 K ^RT("ABOR",$E(X,1,30),DA)
 S X=DE(21),DIC=DIE
 ;
C21S S X="" G:DG(DQ)=X C21F1 K DB
 D ^RTCR1
C21F1 Q
X21 D REC^RTDPA31 S DIC("S")="I $D(D0),$P(^RT(D0,0),U,4)=$P(^RTV(195.9,Y,0),U,3) D DICS^RTDPA31" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
22 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=22 D X22 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X22 I X S:$D(RTB) RTZB=RTB S RTB=X,RTPCE=3 D ATT^RTDPA3 K RTPCE,RTB S:$D(RTZB) RTB=RTZB K RTZB K:Y Y S:$D(Y) Y="@20"
 Q
23 D:$D(DG)>9 F^DIE17,DE S DQ=23,DW="CL;14",DV="*P195.9X",DU="",DLB="ASSOCIATED BORROWER",DIFLD=114
 S DU="RTV(195.9,"
 G RE
X23 D REC^RTDPA31 S DIC("S")="I $D(D0),$P(^RT(D0,0),U,4)=$P(^RTV(195.9,Y,0),U,3) D DICS^RTDPA31" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
24 S DQ=25 ;@20
25 S DQ=26 ;@999
26 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=26 D X26 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X26 K L,RTSEMI,RTDUZ
 Q
27 G 0^DIE17