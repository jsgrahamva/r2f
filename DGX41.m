DGX41 ; ;11/08/15
 D DE G BEGIN
DE S DIE="^DGPT(D0,""S"",",DIC=DIE,DP=45.01,DL=2,DIEL=1,DU="" K DG,DE,DB Q:$O(^DGPT(D0,"S",DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,1) S:%]"" DE(6)=% S %=$P(%Z,U,3) S:%]"" DE(7)=% S %=$P(%Z,U,4) S:%]"" DE(8)=% S %=$P(%Z,U,5) S:%]"" DE(9)=% S %=$P(%Z,U,6) S:%]"" DE(10)=% S %=$P(%Z,U,7) S:%]"" DE(11)=% S %=$P(%Z,U,8) S:%]"" DE(16)=%
 I  S %=$P(%Z,U,9) S:%]"" DE(21)=% S %=$P(%Z,U,10) S:%]"" DE(26)=% S %=$P(%Z,U,11) S:%]"" DE(31)=% S %=$P(%Z,U,12) S:%]"" DE(36)=% S %=$P(%Z,U,13) S:%]"" DE(41)=% S %=$P(%Z,U,14) S:%]"" DE(46)=%
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
BEGIN S DNM="DGX41",DQ=1
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 K DGPTIT S DGHOLD=$G(^DGPT(DGPTF,"S",DGSUR,0)) S:DGHOLD]"" DGHOLD1=$G(^(1))
 Q
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 S DIE("NO^")="BACKOUTOK"
 Q
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 D X3 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X3 S:'$D(DGADD) DGADD=0
 Q
4 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=4 D X4 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X4 S:DGADD Y="@2"
 Q
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 S:DGJUMP'[1 (DGNFLD,Y)="@2"
 Q
6 S DW="0;1",DV="MDX",DU="",DLB="SURGERY/PROCEDURE DATE",DIFLD=.01
 S DE(DW)="C6^DGX41",DE(DW,"INDEX")=1
 G RE
C6 G C6S:$D(DE(6))[0 K DB
C6S S X="" G:DG(DQ)=X C6F1 K DB
C6F1 S DIEZRXR(45.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1181,1182,1183,1184,1185,1250,1251,1252,1253,1254,1255,1256,1257,1258,1259,1260,1261,1262,1263,1264,1265,1266,1267,1268,1269 S DIEZRXR(45.01,DIXR)=""
 Q
X6 S %DT="ETX" D ^%DT S X=+Y K:Y<1 X I $D(X) X $S(X<$P(^DGPT(DA(1),0),U,2):"W !,""Not before admission"" K X",X>($S($D(^(70)):$S(+^(70):+^(70),1:9999999),1:9999999)):"W !,""Not after discharge"" K X",1:"")
 Q
 ;
7 D:$D(DG)>9 F^DIE17,DE S DQ=7,DW="0;3",DV="RP45.3'",DU="",DLB="SURGICAL SPECIALTY",DIFLD=3
 S DU="DIC(45.3,"
 G RE
X7 Q
8 S DW="0;4",DV="S",DU="",DLB="CATEGORY OF CHIEF SURG",DIFLD=4
 S DU="V:VA TEAM;M:MIXED VA&NON-VA;N:NON VA;1:STAFF,FT;2:STAFF, PT;3:CONSULTANT;4:ATTENDING;5:FEE BASIS;6:RESIDENT;7:OTHER(INCLUDES INTERNS);"
 G RE
X8 Q
9 S DW="0;5",DV="S",DU="",DLB="CATEGORY OF FIRST ASSISTANT",DIFLD=5
 S DU="1:STAFF, FT;2:STAFF, PT;3:CONSULTANT;4:ATTENDING;5:FEE BASIS;6:RESIDENT;7:OTHER (INCLUDES INTERN);8:NO ASSISTANT;"
 G RE
X9 Q
10 S DW="0;6",DV="S",DU="",DLB="PRINCIPAL ANESTHETIC TECHNIQUE",DIFLD=6
 S DU="0:NONE;1:INHALATION(OPEN DROP);2:INHALATION(CIRCLE ABSORBER);3:INTRAVENOUS;4:INFILTRATION;5:FIELD BLOCK;6:NERVE BLOCK;7:SPINAL;8:EPIDURAL;9:TOPICAL;R:RECTAL;X:OTHER;"
 G RE
X10 Q
11 S DW="0;7",DV="S",DU="",DLB="SOURCE OF PAYMENT",DIFLD=7
 S DU="1:CONTRACT;2:SHARING;"
 G RE
X11 Q
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 S:DGJUMP'[2 Y=0
 Q
13 S DQ=14 ;@2
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 S DGNFLD="@30"
 Q
15 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=15 D X15 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X15 I DGADD,$P(DGHOLD,U,8)]"" S Y="@30"
 Q
16 S DW="0;8",DV="*P80.1'X",DU="",DLB="OPERATION CODE 1",DIFLD=8
 S DE(DW)="C16^DGX41",DE(DW,"INDEX")=1
 S DU="ICD0("
 G RE
C16 G C16S:$D(DE(16))[0 K DB
C16S S X="" G:DG(DQ)=X C16F1 K DB
C16F1 N X,X1,X2 S DIXR=1270 D C16X1(U) K X2 M X2=X D C16X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . K ^DGPT(DA(1),"S","AO",X,DA)
 K X M X=X2 I $G(X(1))]"" D
 . S ^DGPT(DA(1),"S","AO",X,DA)=""
 G C16F2
C16X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",45.01,DIIENS,8,DION),$P($G(^DGPT(DA(1),"S",DA,0)),U,8))
 S X=$G(X(1))
 Q
C16F2 S DIEZRXR(45.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1181 S DIEZRXR(45.01,DIXR)=""
 Q
X16 N DGIT S DGIT=8 D GETAPI^DGICDGT("DG PTF","PROC",$G(DA(1)),"EN1")
 Q
 ;
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 I X K DGPTIT S DGNFLD="@30",Y="@800",DGPTIT(X_$C(59)_"ICD0(")=""
 Q
18 S DQ=19 ;@30
19 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=19 D X19 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X19 S DGNFLD="@40"
 Q
20 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=20 D X20 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X20 I DGADD,$P(DGHOLD,U,9)]"" S Y="@40"
 Q
21 D:$D(DG)>9 F^DIE17,DE S DQ=21,DW="0;9",DV="*P80.1'X",DU="",DLB="OPERATION CODE 2",DIFLD=9
 S DE(DW)="C21^DGX41",DE(DW,"INDEX")=1
 S DU="ICD0("
 G RE
C21 G C21S:$D(DE(21))[0 K DB
C21S S X="" G:DG(DQ)=X C21F1 K DB
C21F1 N X,X1,X2 S DIXR=1281 D C21X1(U) K X2 M X2=X D C21X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . K ^DGPT(DA(1),"S","AO",X,DA)
 K X M X=X2 I $G(X(1))]"" D
 . S ^DGPT(DA(1),"S","AO",X,DA)=""
 G C21F2
C21X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",45.01,DIIENS,9,DION),$P($G(^DGPT(DA(1),"S",DA,0)),U,9))
 S X=$G(X(1))
 Q
C21F2 S DIEZRXR(45.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1182 S DIEZRXR(45.01,DIXR)=""
 Q
X21 N DGIT S DGIT=8 D GETAPI^DGICDGT("DG PTF","PROC",$G(DA(1)),"EN1")
 Q
 ;
22 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=22 D X22 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X22 I X K DGPTIT S DGNFLD="@40",Y="@800",DGPTIT(X_$C(59)_"ICD0(")=""
 Q
23 S DQ=24 ;@40
24 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=24 D X24 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X24 S DGNFLD="@50"
 Q
25 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=25 D X25 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X25 I DGADD,$P(DGHOLD,U,10)]"" S Y="@50"
 Q
26 D:$D(DG)>9 F^DIE17,DE S DQ=26,DW="0;10",DV="*P80.1'X",DU="",DLB="OPERATION CODE 3",DIFLD=10
 S DE(DW)="C26^DGX41",DE(DW,"INDEX")=1
 S DU="ICD0("
 G RE
C26 G C26S:$D(DE(26))[0 K DB
C26S S X="" G:DG(DQ)=X C26F1 K DB
C26F1 N X,X1,X2 S DIXR=1288 D C26X1(U) K X2 M X2=X D C26X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . K ^DGPT(DA(1),"S","AO",X,DA)
 K X M X=X2 I $G(X(1))]"" D
 . S ^DGPT(DA(1),"S","AO",X,DA)=""
 G C26F2
C26X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",45.01,DIIENS,10,DION),$P($G(^DGPT(DA(1),"S",DA,0)),U,10))
 S X=$G(X(1))
 Q
C26F2 S DIEZRXR(45.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1183 S DIEZRXR(45.01,DIXR)=""
 Q
X26 N DGIT S DGIT=8 D GETAPI^DGICDGT("DG PTF","PROC",$G(DA(1)),"EN1")
 Q
 ;
27 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=27 D X27 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X27 I X K DGPTIT S DGNFLD="@50",Y="@800",DGPTIT(X_$C(59)_"ICD0(")=""
 Q
28 S DQ=29 ;@50
29 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=29 D X29 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X29 S DGNFLD="@60"
 Q
30 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=30 D X30 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X30 I DGADD,$P(DGHOLD,U,11)]"" S Y="@60"
 Q
31 D:$D(DG)>9 F^DIE17,DE S DQ=31,DW="0;11",DV="*P80.1'X",DU="",DLB="OPERATION CODE 4",DIFLD=11
 S DE(DW)="C31^DGX41",DE(DW,"INDEX")=1
 S DU="ICD0("
 G RE
C31 G C31S:$D(DE(31))[0 K DB
C31S S X="" G:DG(DQ)=X C31F1 K DB
C31F1 N X,X1,X2 S DIXR=1289 D C31X1(U) K X2 M X2=X D C31X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . K ^DGPT(DA(1),"S","AO",X,DA)
 K X M X=X2 I $G(X(1))]"" D
 . S ^DGPT(DA(1),"S","AO",X,DA)=""
 G C31F2
C31X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",45.01,DIIENS,11,DION),$P($G(^DGPT(DA(1),"S",DA,0)),U,11))
 S X=$G(X(1))
 Q
C31F2 S DIEZRXR(45.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1184 S DIEZRXR(45.01,DIXR)=""
 Q
X31 N DGIT S DGIT=8 D GETAPI^DGICDGT("DG PTF","PROC",$G(DA(1)),"EN1")
 Q
 ;
32 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=32 D X32 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X32 I X K DGPTIT S DGNFLD="@60",Y="@800",DGPTIT(X_$C(59)_"ICD0(")=""
 Q
33 S DQ=34 ;@60
34 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=34 D X34 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X34 S DGNFLD="@70"
 Q
35 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=35 D X35 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X35 I DGADD,$P(DGHOLD,U,12)]"" S Y="@70"
 Q
36 D:$D(DG)>9 F^DIE17,DE S DQ=36,DW="0;12",DV="*P80.1'X",DU="",DLB="OPERATION CODE 5",DIFLD=12
 S DE(DW)="C36^DGX41",DE(DW,"INDEX")=1
 S DU="ICD0("
 G RE
C36 G C36S:$D(DE(36))[0 K DB
C36S S X="" G:DG(DQ)=X C36F1 K DB
C36F1 N X,X1,X2 S DIXR=1290 D C36X1(U) K X2 M X2=X D C36X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . K ^DGPT(DA(1),"S","AO",X,DA)
 K X M X=X2 I $G(X(1))]"" D
 . S ^DGPT(DA(1),"S","AO",X,DA)=""
 G C36F2
C36X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",45.01,DIIENS,12,DION),$P($G(^DGPT(DA(1),"S",DA,0)),U,12))
 S X=$G(X(1))
 Q
C36F2 S DIEZRXR(45.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1185 S DIEZRXR(45.01,DIXR)=""
 Q
X36 N DGIT S DGIT=8 D GETAPI^DGICDGT("DG PTF","PROC",$G(DA(1)),"EN1")
 Q
 ;
37 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=37 D X37 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X37 I X K DGPTIT S DGNFLD="@70",Y="@800",DGPTIT(X_$C(59)_"ICD0(")=""
 Q
38 S DQ=39 ;@70
39 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=39 D X39 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X39 S DGNFLD="@80"
 Q
40 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=40 D X40 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X40 I DGADD,$P(DGHOLD,U,13)]"" S Y="@80"
 Q
41 D:$D(DG)>9 F^DIE17,DE S DQ=41,DW="0;13",DV="*P80.1'X",DU="",DLB="OPERATION CODE 6",DIFLD=13
 S DE(DW)="C41^DGX41",DE(DW,"INDEX")=1
 S DU="ICD0("
 G RE
C41 G C41S:$D(DE(41))[0 K DB
C41S S X="" G:DG(DQ)=X C41F1 K DB
C41F1 N X,X1,X2 S DIXR=1291 D C41X1(U) K X2 M X2=X D C41X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . K ^DGPT(DA(1),"S","AO",X,DA)
 K X M X=X2 I $G(X(1))]"" D
 . S ^DGPT(DA(1),"S","AO",X,DA)=""
 G C41F2
C41X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",45.01,DIIENS,13,DION),$P($G(^DGPT(DA(1),"S",DA,0)),U,13))
 S X=$G(X(1))
 Q
C41F2 S DIEZRXR(45.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1266 S DIEZRXR(45.01,DIXR)=""
 Q
X41 N DGIT S DGIT=8 D GETAPI^DGICDGT("DGPTF","PROC",$G(DA(1)),"EN1")
 Q
 ;
42 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=42 D X42 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X42 I X K DGPTIT S DGNFLD="@80",Y="@800",DGPTIT(X_$C(59)_"ICD0(")=""
 Q
43 S DQ=44 ;@80
44 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=44 D X44 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X44 S DGNFLD="@90"
 Q
45 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=45 D X45 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X45 I DGADD,$P(DGHOLD,U,14)]"" S Y="@90"
 Q
46 D:$D(DG)>9 F^DIE17,DE S DQ=46,DW="0;14",DV="*P80.1'X",DU="",DLB="OPERATION CODE 7",DIFLD=14
 S DE(DW)="C46^DGX41",DE(DW,"INDEX")=1
 S DU="ICD0("
 G RE
C46 G C46S:$D(DE(46))[0 K DB
C46S S X="" G:DG(DQ)=X C46F1 K DB
C46F1 N X,X1,X2 S DIXR=1292 D C46X1(U) K X2 M X2=X D C46X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . K ^DGPT(DA(1),"S","AO",X,DA)
 K X M X=X2 I $G(X(1))]"" D
 . S ^DGPT(DA(1),"S","AO",X,DA)=""
 G C46F2
C46X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",45.01,DIIENS,14,DION),$P($G(^DGPT(DA(1),"S",DA,0)),U,14))
 S X=$G(X(1))
 Q
C46F2 S DIEZRXR(45.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1267 S DIEZRXR(45.01,DIXR)=""
 Q
X46 N DGIT S DGIT=8 D GETAPI^DGICDGT("DGPTF","PROC",$G(DA(1)),"EN1")
 Q
 ;
47 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=47 D X47 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X47 I X K DGPTIT S DGNFLD="@90",Y="@800",DGPTIT(X_$C(59)_"ICD0(")=""
 Q
48 S DQ=49 ;@90
49 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=49 D X49 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X49 S DGNFLD="@100"
 Q
50 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=50 D X50 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X50 I DGADD,$P(DGHOLD,U,15)]"" S Y="@100"
 Q
51 D:$D(DG)>9 F^DIE17 G ^DGX42