DGRPTX4 ; ;08/22/16
 D DE G BEGIN
DE S DIE="^DPT(",DIC=DIE,DP=2,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^DPT(DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,5) S:%]"" DE(6)=%
 I $D(^(.11)) S %Z=^(.11) S %=$P(%Z,U,5) S:%]"" DE(1)=% S %=$P(%Z,U,7) S:%]"" DE(2)=% S %=$P(%Z,U,16) S:%]"" DE(5)=%
 I $D(^(.13)) S %Z=^(.13) S %=$P(%Z,U,1) S:%]"" DE(3)=% S %=$P(%Z,U,2) S:%]"" DE(4)=%
 I $D(^(.21)) S %Z=^(.21) S %=$P(%Z,U,1) S:%]"" DE(7)=% S %=$P(%Z,U,2) S:%]"" DE(9)=% S %=$P(%Z,U,3) S:%]"" DE(13)=% S %=$P(%Z,U,4) S:%]"" DE(15)=% S %=$P(%Z,U,5) S:%]"" DE(17)=% S %=$P(%Z,U,10) S:%]"" DE(11)=%
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
BEGIN S DNM="DGRPTX4",DQ=1
1 D:$D(DG)>9 F^DIE17,DE S DQ=1,DW=".11;5",DV="*P5'a",DU="",DLB="STATE",DIFLD=.115
 S DE(DW)="C1^DGRPTX4",DE(DW,"INDEX")=1
 S DU="DIC(5,"
 G RE
C1 G C1S:$D(DE(1))[0 K DB
 S X=DE(1),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.11)):^(.11),1:""),Y=$P(Y(1),U,7) X:$D(^DD(2,.117,2)) ^(2) S X=Y S DIU=X K Y S X=DIV S X="" X ^DD(2,.115,1,1,2.4)
 S X=DE(1),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
 S X=DE(1),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(1),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.11)):^(.11),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=$$NOW^XLFDT S DIH=$G(^DPT(DIV(0),.11)),DIV=X S $P(^(.11),U,13)=DIV,DIH=2,DIG=.118 D ^DICR
 S X=DE(1),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DE(1),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".115;" D AVAFC^VAFCDD01(DA)
 S X=DE(1),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(1),DIIX=2_U_DIFLD D AUDIT^DIET
C1S S X="" G:DG(DQ)=X C1F1 K DB
 S X=DG(DQ),DIC=DIE
 ;
 S X=DG(DQ),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.11)):^(.11),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=$$NOW^XLFDT() S DIH=$G(^DPT(DIV(0),.11)),DIV=X S $P(^(.11),U,13)=DIV,DIH=2,DIG=.118 D ^DICR
 S X=DG(DQ),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".115;" D AVAFC^VAFCDD01(DA)
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 I $D(DE(1))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C1F1 N X,X1,X2 S DIXR=235 D C1X1(U) K X2 M X2=X D C1X1("O") K X1 M X1=X
 D
 . D FC^DGFCPROT(.DA,2,.115,"KILL",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 K X M X=X2 D
 . D FC^DGFCPROT(.DA,2,.115,"SET",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 G C1F2
C1X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.115,DION),$P($G(^DPT(DA,.11)),U,5))
 S X=$G(X(1))
 Q
C1F2 Q
X1 S DIC("S")="I $P(^DIC(5,Y,0),U,6)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW=".11;7",DV="NJ3,0XOa",DU="",DLB="COUNTY",DIFLD=.117
 S DQ(2,2)="S Y(0)=Y Q:Y']""""  S Z0=$S($D(^DPT(D0,.11)):+$P(^(.11),""^"",5),1:"""") Q:'Z0  S Y=$P($S($D(^DIC(5,Z0,1,Y,0)):^(0),1:""""),""^"",3)"
 S DE(DW)="C2^DGRPTX4"
 G RE
C2 G C2S:$D(DE(2))[0 K DB
 S X=DE(2),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
 S X=DE(2),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(2),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DE(2),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".117;" D AVAFC^VAFCDD01(DA)
 S X=DE(2),DIIX=2_U_DIFLD D AUDIT^DIET
C2S S X="" G:DG(DQ)=X C2F1 K DB
 S X=DG(DQ),DIC=DIE
 S A1B2TAG="PAT" D ^A1B2XFR
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DG(DQ),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".117;" D AVAFC^VAFCDD01(DA)
 I $D(DE(2))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C2F1 Q
X2 S Z0=$S($D(^DPT(D0,.11)):+$P(^(.11),"^",5),1:0) K:'Z0 X Q:'Z0!'$D(^DIC(5,Z0,1,0))  S DIC="^DIC(5,Z0,1,",DIC(0)="QEM" D ^DIC S X=+Y K:Y'>0 X K Z0,DIC
 Q
 ;
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,DW=".13;1",DV="Fa",DU="",DLB="PHONE NUMBER [RESIDENCE]",DIFLD=.131
 S DE(DW)="C3^DGRPTX4"
 G RE
C3 G C3S:$D(DE(3))[0 K DB
 S X=DE(3),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(3),DIC=DIE
 K ^DPT("F",$E(X,1,30),DA)
 S X=DE(3),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.132)):^(.132),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y S X=DIV S X=$$NOW^XLFDT() S DIH=$G(^DPT(DIV(0),.132)),DIV=X S $P(^(.132),U,1)=DIV,DIH=2,DIG=.1321 D ^DICR
 S X=DE(3),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DE(3),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".131;" D AVAFC^VAFCDD01(DA)
 S X=DE(3),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(3),DIC=DIE
 X "N % S %=$E($TR(X,""ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()-_=+[]{}<>,./?:;'\|""),1,30) K:%'="""" ^DPT(""AZVWVOE"",%,DA)"
 S X=DE(3),DIIX=2_U_DIFLD D AUDIT^DIET
C3S S X="" G:DG(DQ)=X C3F1 K DB
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DG(DQ),DIC=DIE
 S ^DPT("F",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.132)):^(.132),1:"") S X=$P(Y(1),U,1),X=X S DIU=X K Y S X=DIV S X=$$NOW^XLFDT() S DIH=$G(^DPT(DIV(0),.132)),DIV=X S $P(^(.132),U,1)=DIV,DIH=2,DIG=.1321 D ^DICR
 S X=DG(DQ),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".131;" D AVAFC^VAFCDD01(DA)
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DG(DQ),DIC=DIE
 X "N % S %=$E($TR(X,""ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()-_=+[]{}<>,./?:;'\|""),1,30) S:%'="""" ^DPT(""AZVWVOE"",%,DA)="""""
 I $D(DE(3))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C3F1 Q
X3 K:$L(X)>20!($L(X)<4) X
 I $D(X),X'?.ANP K X
 Q
 ;
4 D:$D(DG)>9 F^DIE17,DE S DQ=4,DW=".13;2",DV="Fa",DU="",DLB="PHONE NUMBER [WORK]",DIFLD=.132
 S DE(DW)="C4^DGRPTX4"
 G RE
C4 G C4S:$D(DE(4))[0 K DB
 S X=DE(4),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(4),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DE(4),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".132;" D AVAFC^VAFCDD01(DA)
 S X=DE(4),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(4),DIIX=2_U_DIFLD D AUDIT^DIET
C4S S X="" G:DG(DQ)=X C4F1 K DB
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DG(DQ),DIC=DIE
 S IVMX=X,X="IVMPXFR" X ^%ZOSF("TEST") D:$T DPT^IVMPXFR S X=IVMX K IVMX
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".132;" D AVAFC^VAFCDD01(DA)
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 I $D(DE(4))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C4F1 Q
X4 K:$L(X)>20!($L(X)<4) X
 I $D(X),X'?.ANP K X
 Q
 ;
5 D:$D(DG)>9 F^DIE17,DE S DQ=5,DW=".11;16",DV="*S",DU="",DLB="BAD ADDRESS INDICATOR",DIFLD=.121
 S DE(DW)="C5^DGRPTX4",DE(DW,"INDEX")=1
 S DU="1:UNDELIVERABLE;2:HOMELESS;3:OTHER;4:ADDRESS NOT FOUND;"
 G RE
C5 G C5S:$D(DE(5))[0 K DB
 S X=DE(5),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(5),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.11)):^(.11),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=$$NOW^XLFDT() S DIH=$G(^DPT(DIV(0),.11)),DIV=X S $P(^(.11),U,13)=DIV,DIH=2,DIG=.118 D ^DICR
C5S S X="" G:DG(DQ)=X C5F1 K DB
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.11)):^(.11),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=$$NOW^XLFDT() S DIH=$G(^DPT(DIV(0),.11)),DIV=X S $P(^(.11),U,13)=DIV,DIH=2,DIG=.118 D ^DICR
C5F1 N X,X1,X2 S DIXR=784 D C5X1(U) K X2 M X2=X D C5X1("O") K X1 M X1=X
 D
 . D FC^DGFCPROT(.DA,2,.121,"KILL",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 K X M X=X2 D
 . D FC^DGFCPROT(.DA,2,.121,"SET",$H,$G(DUZ),.X,.X1,.X2,$G(XQY0)) Q
 G C5F2
C5X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.121,DION),$P($G(^DPT(DA,.11)),U,16))
 S X=$G(X(1))
 Q
C5F2 Q
X5 Q
6 D:$D(DG)>9 F^DIE17,DE S DQ=6,DW="0;5",DV="RP11'a",DU="",DLB="MARITAL STATUS",DIFLD=.05
 S DE(DW)="C6^DGRPTX4"
 S DU="DIC(11,"
 G RE
C6 G C6S:$D(DE(6))[0 K DB
 S X=DE(6),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".05;" D AVAFC^VAFCDD01(DA)
 S X=DE(6),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(6),DIC=DIE
 D EVENT^IVMPLOG(DA)
 S X=DE(6),DIIX=2_U_DIFLD D AUDIT^DIET
C6S S X="" G:DG(DQ)=X C6F1 K DB
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".05;" D AVAFC^VAFCDD01(DA)
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
 I $D(DE(6))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C6F1 Q
X6 Q
7 D:$D(DG)>9 F^DIE17,DE S DQ=7,DW=".21;1",DV="Fa",DU="",DLB="K-NAME OF PRIMARY NOK",DIFLD=.211
 S DE(DW)="C7^DGRPTX4",DE(DW,"INDEX")=1
 G RE
C7 G C7S:$D(DE(7))[0 K DB
 S X=DE(7),DIC=DIE
 X "S DGXRF=.211 D ^DGDDC Q"
 S X=DE(7),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".211;" D AVAFC^VAFCDD01(DA)
 S X=DE(7),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 S X=DE(7),DIIX=2_U_DIFLD D AUDIT^DIET
C7S S X="" G:DG(DQ)=X C7F1 K DB
 S X=DG(DQ),DIC=DIE
 ;
 S X=DG(DQ),DIC=DIE
 I ($T(AVAFC^VAFCDD01)'="") S VAFCF=".211;" D AVAFC^VAFCDD01(DA)
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
 I $D(DE(7))'[0!(^DD(DP,DIFLD,"AUDIT")'="e") S X=DG(DQ),DIIX=3_U_DIFLD D AUDIT^DIET
C7F1 N X,X1,X2 S DIXR=590 D C7X1(U) K X2 M X2=X D C7X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1 D DELCOMP^XLFNAME2(2,.DA,.211,1.02) Q
 K X M X=X2 I $G(X(1))]"" D
 . I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1,DG20NAME=X D NARY^XLFNAME7(.DG20NAME),UPDCOMP^XLFNAME2(2,.DA,.211,.DG20NAME,1.02,+$P($G(^DPT(DA,"NAME")),U,2),"CL35") K DG20NAME Q
 G C7F2
C7X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.211,DION),$P($G(^DPT(DA,.21)),U,1))
 S X=$G(X(1))
 Q
C7F2 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=602 S DIEZRXR(2,DIXR)=""
 Q
X7 K:$L(X)>35!($L(X)<3) X I $D(X) S DG20NAME=X,(X,DG20NAME)=$$FORMAT^XLFNAME7(.DG20NAME,3,35) K:'$L(X) X,DG20NAME
 I $D(X),X'?.ANP K X
 Q
 ;
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 S:X="" Y="@30"
 Q
9 D:$D(DG)>9 F^DIE17,DE S DQ=9,DW=".21;2",DV="FX",DU="",DLB="K-RELATIONSHIP TO PATIENT",DIFLD=.212
 S DE(DW)="C9^DGRPTX4",DE(DW,"INDEX")=1
 G RE
C9 G C9S:$D(DE(9))[0 K DB
 S X=DE(9),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
C9S S X="" G:DG(DQ)=X C9F1 K DB
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
C9F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=602 S DIEZRXR(2,DIXR)=""
 Q
X9 K:$L(X)>30!($L(X)<1) X I $D(X) S DFN=DA D K1^DGLOCK2
 I $D(X),X'?.ANP K X
 Q
 ;
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 G A
11 D:$D(DG)>9 F^DIE17,DE S DQ=11,DW=".21;10",DV="RSX",DU="",DLB="K-ADDRESS SAME AS PATIENT'S?",DIFLD=.2125
 S DE(DW)="C11^DGRPTX4",DE(DW,"INDEX")=1
 S DU="Y:YES;N:NO;"
 S Y="NO"
 G Y
C11 G C11S:$D(DE(11))[0 K DB
C11S S X="" G:DG(DQ)=X C11F1 K DB
C11F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=602 S DIEZRXR(2,DIXR)=""
 Q
X11 I $D(X),X="Y" S DFN=DA D K1^DGLOCK2
 Q
 ;
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 I X="Y" S DGADD=".21" D AD^DGRPE S Y=.21011
 Q
13 D:$D(DG)>9 F^DIE17,DE S DQ=13,DW=".21;3",DV="FX",DU="",DLB="K-STREET ADDRESS [LINE 1]",DIFLD=.213
 S DE(DW)="C13^DGRPTX4",DE(DW,"INDEX")=1
 G RE
C13 G C13S:$D(DE(13))[0 K DB
 S X=DE(13),DIC=DIE
 X "S DGXRF=.213 D ^DGDDC Q"
 S X=DE(13),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
C13S S X="" G:DG(DQ)=X C13F1 K DB
 S X=DG(DQ),DIC=DIE
 ;
 S X=DG(DQ),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
C13F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=602 S DIEZRXR(2,DIXR)=""
 Q
X13 K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3) X I $D(X) S DFN=DA D K1^DGLOCK2
 I $D(X),X'?.ANP K X
 Q
 ;
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 S:X="" Y=.216
 Q
15 D:$D(DG)>9 F^DIE17,DE S DQ=15,DW=".21;4",DV="FX",DU="",DLB="K-STREET ADDRESS [LINE 2]",DIFLD=.214
 S DE(DW)="C15^DGRPTX4",DE(DW,"INDEX")=1
 G RE
C15 G C15S:$D(DE(15))[0 K DB
 S X=DE(15),DIC=DIE
 X "S DGXRF=.214 D ^DGDDC Q"
 S X=DE(15),DIC=DIE
 D:($T(ADGRU^DGRUDD01)'="") ADGRU^DGRUDD01(DA)
C15S S X="" G:DG(DQ)=X C15F1 K DB
 D ^DGRPTX5
C15F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=602 S DIEZRXR(2,DIXR)=""
 Q
X15 K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3) X I $D(X) S DFN=DA D K1^DGLOCK2
 I $D(X),X'?.ANP K X
 Q
 ;
16 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=16 D X16 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X16 S:X="" Y=.216
 Q
17 D:$D(DG)>9 F^DIE17,DE S DQ=17,DW=".21;5",DV="FX",DU="",DLB="K-STREET ADDRESS [LINE 3]",DIFLD=.215
 S DE(DW)="C17^DGRPTX4",DE(DW,"INDEX")=1
 G RE
C17 G C17S:$D(DE(17))[0 K DB
C17S S X="" G:DG(DQ)=X C17F1 K DB
 D ^DGRPTX6
C17F1 S DIEZRXR(2,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=602 S DIEZRXR(2,DIXR)=""
 Q
X17 K:$L(X)>30!($L(X)<3) X I $D(X) S DFN=DA D K1^DGLOCK2
 I $D(X),X'?.ANP K X
 Q
 ;
18 D:$D(DG)>9 F^DIE17 G ^DGRPTX7
