DGRPTX7 ; ;08/22/16
 D DE G BEGIN
DE S DIE="^DPT(",DIC=DIE,DP=2,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^DPT(DA,""))=""
 I $D(^(.21)) S %Z=^(.21) S %=$P(%Z,U,6) S:%]"" DE(1)=% S %=$P(%Z,U,7) S:%]"" DE(2)=% S %=$P(%Z,U,9) S:%]"" DE(4)=% S %=$P(%Z,U,11) S:%]"" DE(5)=%
 I $D(^(.22)) S %Z=^(.22) S %=$P(%Z,U,1) S:%]"" DE(23)=% S %=$P(%Z,U,7) S:%]"" DE(3)=%
 I $D(^(.32)) S %Z=^(.32) S %=$P(%Z,U,5) S:%]"" DE(27)=% S %=$P(%Z,U,8) S:%]"" DE(28)=%
 I $D(^(.33)) S %Z=^(.33) S %=$P(%Z,U,1) S:%]"" DE(13)=% S %=$P(%Z,U,2) S:%]"" DE(15)=% S %=$P(%Z,U,3) S:%]"" DE(16)=% S %=$P(%Z,U,4) S:%]"" DE(18)=% S %=$P(%Z,U,5) S:%]"" DE(20)=% S %=$P(%Z,U,6) S:%]"" DE(21)=% S %=$P(%Z,U,7) S:%]"" DE(22)=%
 I  S %=$P(%Z,U,9) S:%]"" DE(24)=% S %=$P(%Z,U,10) S:%]"" DE(8)=% S %=$P(%Z,U,11) S:%]"" DE(25)=%
 I $D(^(.52)) S %Z=^(.52) S %=$P(%Z,U,5) S:%]"" DE(29)=%
 I $D(^(.53)) S %Z=^(.53) S %=$P(%Z,U,1) S:%]"" DE(31)=%
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
BEGIN S DNM="DGRPTX7",DQ=1
1 D:$D(DG)>9 F^DIE17,DE S DQ=1,DW=".21;6",DV="FX",DU="",DLB="K-CITY",DIFLD=.216
 S DE(DW)="C1^DGRPTX7",DE(DW,"INDEX")=1
 G RE
C1 G C1S:$D(DE(1))[0 K DB
 S X=DE(1),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
C1S S X="" G:DG(DQ)=X C1F1 K DB
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
C1F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=602 S DIEZRXR(2,DIXR)=""
 Q
X1 K:$L(X)>30!($L(X)<3) X I $D(X) S DFN=DA D K1^DGLOCK2
 I $D(X),X'?.ANP K X
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW=".21;7",DV="P5'X",DU="",DLB="K-STATE",DIFLD=.217
 S DE(DW)="C2^DGRPTX7",DE(DW,"INDEX")=1
 S DU="DIC(5,"
 G RE
C2 G C2S:$D(DE(2))[0 K DB
 S X=DE(2),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
C2S S X="" G:DG(DQ)=X C2F1 K DB
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
C2F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=602 S DIEZRXR(2,DIXR)=""
 Q
X2 I $D(X) S DFN=DA D K1^DGLOCK2
 Q
 ;
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,DW=".22;7",DV="FOX",DU="",DLB="K-ZIP+4",DIFLD=.2207
 S DQ(3,2)="S Y(0)=Y D ZIPOUT^VAFADDR"
 S DE(DW)="C3^DGRPTX7",DE(DW,"INDEX")=1
 G RE
C3 G C3S:$D(DE(3))[0 K DB
 S X=DE(3),DIC=DIE
 D KILL^DGREGDD1(DA,.218,.21,8,$E(X,1,5))
C3S S X="" G:DG(DQ)=X C3F1 K DB
 S X=DG(DQ),DIC=DIE
 D SET^DGREGDD1(DA,.218,.21,8,$E(X,1,5))
C3F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=602 S DIEZRXR(2,DIXR)=""
 Q
X3 K:X[""""!($A(X)=45) X I $D(X) S DFN=DA D K1^DGLOCK2 I $D(X) K:$L(X)>15!($L(X)<5) X I $D(X) D ZIPIN^VAFADDR
 I $D(X),X'?.ANP K X
 Q
 ;
4 D:$D(DG)>9 F^DIE17,DE S DQ=4,DW=".21;9",DV="FXa",DU="",DLB="K-PHONE NUMBER",DIFLD=.219
 S DE(DW)="C4^DGRPTX7",DE(DW,"INDEX")=1
 G RE
C4 G C4S:$D(DE(4))[0 K DB
 S X=DE(4),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".219;" D AVAFC^VAFCDD01(DA)
 S X=DE(4),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(4),DIIX=2_U_DIFLD D AUDIT^DIET
C4S S X="" G:DG(DQ)=X C4F1 K DB
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".219;" D AVAFC^VAFCDD01(DA)
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 I $D(DE(4))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C4F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=602 S DIEZRXR(2,DIXR)=""
 Q
X4 K:$L(X)>20!($L(X)<4) X I $D(X) S DFN=DA D K1^DGLOCK2
 I $D(X),X'?.ANP K X
 Q
 ;
5 D:$D(DG)>9 F^DIE17,DE S DQ=5,DW=".21;11",DV="F",DU="",DLB="K-WORK PHONE NUMBER",DIFLD=.21011
 S DE(DW)="C5^DGRPTX7",DE(DW,"INDEX")=1
 G RE
C5 G C5S:$D(DE(5))[0 K DB
C5S S X="" G:DG(DQ)=X C5F1 K DB
C5F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=602 S DIEZRXR(2,DIXR)=""
 Q
X5 K:$L(X)>20!($L(X)<4) X
 I $D(X),X'?.ANP K X
 Q
 ;
6 S DQ=7 ;@30
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 I $S('$D(^DPT(DFN,.21)):1,$P(^(.21),U,1)="":1,1:0) S Y=.331
 Q
8 D:$D(DG)>9 F^DIE17,DE S DQ=8,DW=".33;10",DV="RSX",DU="",DLB="E-EMER. CONTACT SAME AS NOK?",DIFLD=.3305
 S DE(DW)="C8^DGRPTX7",DE(DW,"INDEX")=1
 S DU="Y:YES;N:NO;"
 S Y="NO"
 G Y
C8 G C8S:$D(DE(8))[0 K DB
C8S S X="" G:DG(DQ)=X C8F1 K DB
C8F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=604 S DIEZRXR(2,DIXR)=""
 Q
X8 I $D(X),X="Y" D K1^DGLOCK2
 Q
 ;
9 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=9 D X9 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X9 I X'="Y" S Y=.331
 Q
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 S X=$S($D(^DPT(DA,.21)):^(.21),1:"") S:X'="" ^(.33)=$P(X_"^^^^^^^^^^^",U,1,9)_U_$P(^(.33),U,10)_U_$P(X,U,11)
 Q
11 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=11 D X11 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X11 S:$D(^DPT(DFN,.22)) $P(^(.22),U,1)=$P(^(.22),U,7)
 Q
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 S Y=.33011
 Q
13 D:$D(DG)>9 F^DIE17,DE S DQ=13,DW=".33;1",DV="F",DU="",DLB="E-NAME",DIFLD=.331
 S DE(DW)="C13^DGRPTX7",DE(DW,"INDEX")=1
 G RE
C13 G C13S:$D(DE(13))[0 K DB
 S X=DE(13),DIC=DIE
 X "S DGXRF=.331 D ^DGDDC Q"
C13S S X="" G:DG(DQ)=X C13F1 K DB
 S X=DG(DQ),DIC=DIE
 ;
C13F1 N X,X1,X2 S DIXR=595 D C13X1(U) K X2 M X2=X D C13X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1 D DELCOMP^XLFNAME2(2,.DA,.331,1.07) Q
 K X M X=X2 I $G(X(1))]"" D
 . I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1,DG20NAME=X D NARY^XLFNAME7(.DG20NAME),UPDCOMP^XLFNAME2(2,.DA,.331,.DG20NAME,1.07,+$P($G(^DPT(DA,"NAME")),U,7),"CL35") K DG20NAME Q
 G C13F2
C13X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.331,DION),$P($G(^DPT(DA,.33)),U,1))
 S X=$G(X(1))
 Q
C13F2 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=604 S DIEZRXR(2,DIXR)=""
 Q
X13 K:$L(X)>35!($L(X)<3) X I $D(X) S DG20NAME=X,(X,DG20NAME)=$$FORMAT^XLFNAME7(.DG20NAME,3,35) K:'$L(X) X,DG20NAME
 I $D(X),X'?.ANP K X
 Q
 ;
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 S:X="" Y="@40"
 Q
15 D:$D(DG)>9 F^DIE17,DE S DQ=15,DW=".33;2",DV="FX",DU="",DLB="E-RELATIONSHIP TO PATIENT",DIFLD=.332
 S DE(DW)="C15^DGRPTX7",DE(DW,"INDEX")=1
 G RE
C15 G C15S:$D(DE(15))[0 K DB
C15S S X="" G:DG(DQ)=X C15F1 K DB
C15F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=604 S DIEZRXR(2,DIXR)=""
 Q
X15 K:$L(X)>30!($L(X)<2) X I $D(X) S DFN=DA D E1^DGLOCK2
 I $D(X),X'?.ANP K X
 Q
 ;
16 D:$D(DG)>9 F^DIE17,DE S DQ=16,DW=".33;3",DV="FX",DU="",DLB="E-STREET ADDRESS [LINE 1]",DIFLD=.333
 S DE(DW)="C16^DGRPTX7",DE(DW,"INDEX")=1
 G RE
C16 G C16S:$D(DE(16))[0 K DB
 S X=DE(16),DIC=DIE
 X "S DGXRF=.333 D ^DGDDC Q"
C16S S X="" G:DG(DQ)=X C16F1 K DB
 S X=DG(DQ),DIC=DIE
 ;
C16F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=604 S DIEZRXR(2,DIXR)=""
 Q
X16 K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3) X I $D(X) S DFN=DA D E1^DGLOCK2
 I $D(X),X'?.ANP K X
 Q
 ;
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 S:X="" Y=.336
 Q
18 D:$D(DG)>9 F^DIE17,DE S DQ=18,DW=".33;4",DV="FX",DU="",DLB="E-STREET ADDRESS [LINE 2]",DIFLD=.334
 S DE(DW)="C18^DGRPTX7",DE(DW,"INDEX")=1
 G RE
C18 G C18S:$D(DE(18))[0 K DB
 S X=DE(18),DIC=DIE
 X "S DGXRF=.334 D ^DGDDC Q"
C18S S X="" G:DG(DQ)=X C18F1 K DB
 S X=DG(DQ),DIC=DIE
 ;
C18F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=604 S DIEZRXR(2,DIXR)=""
 Q
X18 K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3) X I $D(X) S DFN=DA D E1^DGLOCK2
 I $D(X),X'?.ANP K X
 Q
 ;
19 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=19 D X19 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X19 S:X="" Y=.336
 Q
20 D:$D(DG)>9 F^DIE17,DE S DQ=20,DW=".33;5",DV="FX",DU="",DLB="E-STREET ADDRESS [LINE 3]",DIFLD=.335
 S DE(DW)="C20^DGRPTX7",DE(DW,"INDEX")=1
 G RE
C20 G C20S:$D(DE(20))[0 K DB
C20S S X="" G:DG(DQ)=X C20F1 K DB
C20F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=604 S DIEZRXR(2,DIXR)=""
 Q
X20 K:$L(X)>30!($L(X)<3) X I $D(X) S DFN=DA D E1^DGLOCK2
 I $D(X),X'?.ANP K X
 Q
 ;
21 D:$D(DG)>9 F^DIE17,DE S DQ=21,DW=".33;6",DV="FX",DU="",DLB="E-CITY",DIFLD=.336
 S DE(DW)="C21^DGRPTX7",DE(DW,"INDEX")=1
 G RE
C21 G C21S:$D(DE(21))[0 K DB
C21S S X="" G:DG(DQ)=X C21F1 K DB
C21F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=604 S DIEZRXR(2,DIXR)=""
 Q
X21 K:$L(X)>30!($L(X)<3) X I $D(X) S DFN=DA D E1^DGLOCK2
 I $D(X),X'?.ANP K X
 Q
 ;
22 D:$D(DG)>9 F^DIE17,DE S DQ=22,DW=".33;7",DV="P5'X",DU="",DLB="E-STATE",DIFLD=.337
 S DE(DW)="C22^DGRPTX7",DE(DW,"INDEX")=1
 S DU="DIC(5,"
 G RE
C22 G C22S:$D(DE(22))[0 K DB
C22S S X="" G:DG(DQ)=X C22F1 K DB
C22F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=604 S DIEZRXR(2,DIXR)=""
 Q
X22 I $D(X) S DFN=DA D E1^DGLOCK2
 Q
 ;
23 D:$D(DG)>9 F^DIE17,DE S DQ=23,DW=".22;1",DV="FOX",DU="",DLB="E-ZIP+4",DIFLD=.2201
 S DQ(23,2)="S Y(0)=Y D ZIPOUT^VAFADDR"
 S DE(DW)="C23^DGRPTX7",DE(DW,"INDEX")=1
 G RE
C23 G C23S:$D(DE(23))[0 K DB
 S X=DE(23),DIC=DIE
 D KILL^DGREGDD1(DA,.338,.33,8,$E(X,1,5))
C23S S X="" G:DG(DQ)=X C23F1 K DB
 S X=DG(DQ),DIC=DIE
 D SET^DGREGDD1(DA,.338,.33,8,$E(X,1,5))
C23F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=604 S DIEZRXR(2,DIXR)=""
 Q
X23 K:X[""""!($A(X)=45) X I $D(X) S DFN=DA D E1^DGLOCK2 I $D(X) K:$L(X)>15!($L(X)<5) X I $D(X) D ZIPIN^VAFADDR
 I $D(X),X'?.ANP K X
 Q
 ;
24 D:$D(DG)>9 F^DIE17,DE S DQ=24,DW=".33;9",DV="FX",DU="",DLB="E-PHONE NUMBER",DIFLD=.339
 S DE(DW)="C24^DGRPTX7",DE(DW,"INDEX")=1
 G RE
C24 G C24S:$D(DE(24))[0 K DB
C24S S X="" G:DG(DQ)=X C24F1 K DB
C24F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=604 S DIEZRXR(2,DIXR)=""
 Q
X24 K:$L(X)>20!($L(X)<3) X I $D(X) S DFN=DA D E1^DGLOCK2
 I $D(X),X'?.ANP K X
 Q
 ;
25 D:$D(DG)>9 F^DIE17,DE S DQ=25,DW=".33;11",DV="F",DU="",DLB="E-WORK PHONE NUMBER",DIFLD=.33011
 S DE(DW)="C25^DGRPTX7",DE(DW,"INDEX")=1
 G RE
C25 G C25S:$D(DE(25))[0 K DB
C25S S X="" G:DG(DQ)=X C25F1 K DB
C25F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=604 S DIEZRXR(2,DIXR)=""
 Q
X25 K:$L(X)>20!($L(X)<4) X
 I $D(X),X'?.ANP K X
 Q
 ;
26 S DQ=27 ;@40
27 D:$D(DG)>9 F^DIE17,DE S DQ=27,DW=".32;5",DV="P23'X",DU="",DLB="SERVICE BRANCH [LAST]",DIFLD=.325
 S DE(DW)="C27^DGRPTX7",DE(DW,"INDEX")=1
 S DU="DIC(23,"
 G RE
C27 G C27S:$D(DE(27))[0 K DB
 S X=DE(27),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
 S X=DE(27),DIC=DIE
 I $P($G(^DPT(DA,.321)),U,14)]"" D FVP^DGRPMS
 S X=DE(27),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(27),DIC=DIE
 X "S DGXRF=.325 D ^DGDDC Q"
C27S S X="" G:DG(DQ)=X C27F1 K DB
 S X=DG(DQ),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
 S X=DG(DQ),DIC=DIE
 ;
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DG(DQ),DIC=DIE
 ;
C27F1 N X,X1,X2 S DIXR=408 D C27X1(U) K X2 M X2=X D C27X1("O") K X1 M X1=X
 D
 . N DIEXARR M DIEXARR=X S DIEZCOND=1
 . S X=X2(1)=""
 . S DIEZCOND=$G(X) K X M X=DIEXARR Q:'DIEZCOND
 . D DELMSE^DGRPMS(DA,1)
 G C27F2
C27X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.325,DION),$P($G(^DPT(DA,.32)),U,5))
 S X=$G(X(1))
 Q
C27F2 Q
X27 S DFN=DA K:X=$O(^DIC(23,"B","B.E.C.","")) X I $D(X) D SV^DGLOCK S DGCOMBR=$G(Y) Q
 Q
 ;
28 D:$D(DG)>9 F^DIE17,DE S DQ=28,DW=".32;8",DV="FX",DU="",DLB="SERVICE NUMBER [LAST]",DIFLD=.328
 S DE(DW)="C28^DGRPTX7"
 G RE
C28 G C28S:$D(DE(28))[0 K DB
 S X=DE(28),DIC=DIE
 D EVENT^IVMPLOG(DA)
C28S S X="" G:DG(DQ)=X C28F1 K DB
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
C28F1 Q
X28 S DFN=DA D SV^DGLOCK I $D(X) S:X?1"SS".E L=$S($D(^DPT(DA,0)):$P(^(0),U,9),1:X) W:X?1"SS".E "  ",L S:X?1"SS".E X=L K:$L(X)>15!($L(X)<1)!'(X?.N) X
 I $D(X),X'?.ANP K X
 Q
 ;
29 D:$D(DG)>9 F^DIE17,DE S DQ=29,DW=".52;5",DV="RSX",DU="",DLB="POW STATUS INDICATED?",DIFLD=.525
 S DE(DW)="C29^DGRPTX7",DE(DW,"INDEX")=1
 S DU="Y:YES;N:NO;U:UNKNOWN;"
 G RE
C29 G C29S:$D(DE(29))[0 K DB
 D ^DGRPTX8
C29S S X="" G:DG(DQ)=X C29F1 K DB
 D ^DGRPTX9
C29F1 N X,X1,X2 S DIXR=646 D C29X1(U) K X2 M X2=X D C29X1("O") K X1 M X1=X
 D
 . D FC^DGFCPROT(.DA,2,.525,"KILL",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 K X M X=X2 D
 . D FC^DGFCPROT(.DA,2,.525,"SET",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 G C29F2
C29X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.525,DION),$P($G(^DPT(DA,.52)),U,5))
 S X=$G(X(1))
 Q
C29F2 Q
X29 S DFN=DA D POWV^DGLOCK I $D(X) D SV^DGLOCK
 Q
 ;
30 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=30 D X30 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X30 I $P($G(^DPT(DFN,.53)),U)]"" S Y="@53"
 Q
31 D:$D(DG)>9 F^DIE17,DE S DQ=31,DW=".53;1",DV="SX",DU="",DLB="CURRENT PH INDICATOR",DIFLD=.531
 S DE(DW)="C31^DGRPTX7"
 S DU="Y:YES;N:NO;"
 G RE
C31 G C31S:$D(DE(31))[0 K DB
 D ^DGRPTX10
C31S S X="" G:DG(DQ)=X C31F1 K DB
 D ^DGRPTX11
C31F1 Q
X31 S DFN=DA D VET^DGLOCK
 Q
 ;
32 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=32 D X32 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X32 I X="Y" S Y="@532",DGPHMULT=1
 Q
33 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=33 D X33 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X33 I X="N" S Y="@533",DGPHMULT=1
 Q
34 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=34 D X34 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X34 S:X="" Y="@53"
 Q
35 S DQ=36 ;@532
36 D:$D(DG)>9 F^DIE17 G ^DGRPTX12