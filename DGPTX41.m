DGPTX41 ; ;11/08/15
 D DE G BEGIN
DE S DIE="^DGPT(D0,""S"",",DIC=DIE,DP=45.01,DL=2,DIEL=1,DU="" K DG,DE,DB Q:$O(^DGPT(D0,"S",DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,1) S:%]"" DE(5)=% S %=$P(%Z,U,3) S:%]"" DE(6)=% S %=$P(%Z,U,4) S:%]"" DE(7)=% S %=$P(%Z,U,5) S:%]"" DE(8)=% S %=$P(%Z,U,6) S:%]"" DE(9)=% S %=$P(%Z,U,7) S:%]"" DE(10)=% S %=$P(%Z,U,8) S:%]"" DE(15)=%
 I  S %=$P(%Z,U,9) S:%]"" DE(20)=% S %=$P(%Z,U,10) S:%]"" DE(25)=% S %=$P(%Z,U,11) S:%]"" DE(30)=% S %=$P(%Z,U,12) S:%]"" DE(35)=%
 I $D(^(300)) S %Z=^(300) S %=$P(%Z,U,1) S:%]"" DE(42)=%
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
BEGIN S DNM="DGPTX41",DQ=1
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 K DGPTIT S DGHOLD=$S($D(^DGPT(DGPTF,"S",DGSUR,0)):^(0),1:"")
 Q
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 S:'$D(DGADD) DGADD=0
 Q
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 D X3 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X3 S:DGADD Y="@2"
 Q
4 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=4 D X4 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X4 S:DGJUMP'[1 (DGNFLD,Y)="@2"
 Q
5 S DW="0;1",DV="MDX",DU="",DLB="SURGERY/PROCEDURE DATE",DIFLD=.01
 S DE(DW)="C5^DGPTX41",DE(DW,"INDEX")=1
 G RE
C5 G C5S:$D(DE(5))[0 K DB
C5S S X="" G:DG(DQ)=X C5F1 K DB
C5F1 S DIEZRXR(45.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1181,1182,1183,1184,1185,1250,1251,1252,1253,1254,1255,1256,1257,1258,1259,1260,1261,1262,1263,1264,1265,1266,1267,1268,1269 S DIEZRXR(45.01,DIXR)=""
 Q
X5 S %DT="ETX" D ^%DT S X=+Y K:Y<1 X I $D(X) X $S(X<$P(^DGPT(DA(1),0),U,2):"W !,""Not before admission"" K X",X>($S($D(^(70)):$S(+^(70):+^(70),1:9999999),1:9999999)):"W !,""Not after discharge"" K X",1:"")
 Q
 ;
6 D:$D(DG)>9 F^DIE17,DE S DQ=6,DW="0;3",DV="RP45.3'",DU="",DLB="SURGICAL SPECIALTY",DIFLD=3
 S DU="DIC(45.3,"
 G RE
X6 Q
7 S DW="0;4",DV="S",DU="",DLB="CATEGORY OF CHIEF SURG",DIFLD=4
 S DU="V:VA TEAM;M:MIXED VA&NON-VA;N:NON VA;1:STAFF,FT;2:STAFF, PT;3:CONSULTANT;4:ATTENDING;5:FEE BASIS;6:RESIDENT;7:OTHER(INCLUDES INTERNS);"
 G RE
X7 Q
8 S DW="0;5",DV="S",DU="",DLB="CATEGORY OF FIRST ASSISTANT",DIFLD=5
 S DU="1:STAFF, FT;2:STAFF, PT;3:CONSULTANT;4:ATTENDING;5:FEE BASIS;6:RESIDENT;7:OTHER (INCLUDES INTERN);8:NO ASSISTANT;"
 G RE
X8 Q
9 S DW="0;6",DV="S",DU="",DLB="PRINCIPAL ANESTHETIC TECHNIQUE",DIFLD=6
 S DU="0:NONE;1:INHALATION(OPEN DROP);2:INHALATION(CIRCLE ABSORBER);3:INTRAVENOUS;4:INFILTRATION;5:FIELD BLOCK;6:NERVE BLOCK;7:SPINAL;8:EPIDURAL;9:TOPICAL;R:RECTAL;X:OTHER;"
 G RE
X9 Q
10 S DW="0;7",DV="S",DU="",DLB="SOURCE OF PAYMENT",DIFLD=7
 S DU="1:CONTRACT;2:SHARING;"
 G RE
X10 Q
11 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=11 D X11 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X11 S:DGJUMP'[2 Y=0
 Q
12 S DQ=13 ;@2
13 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=13 D X13 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X13 S DGNFLD="@30"
 Q
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 I DGADD,$P(DGHOLD,U,8)]"" S Y="@30"
 Q
15 S DW="0;8",DV="*P80.1'X",DU="",DLB="OPERATION CODE 1",DIFLD=8
 S DE(DW)="C15^DGPTX41",DE(DW,"INDEX")=1
 S DU="ICD0("
 G RE
C15 G C15S:$D(DE(15))[0 K DB
C15S S X="" G:DG(DQ)=X C15F1 K DB
C15F1 N X,X1,X2 S DIXR=1270 D C15X1(U) K X2 M X2=X D C15X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . K ^DGPT(DA(1),"S","AO",X,DA)
 K X M X=X2 I $G(X(1))]"" D
 . S ^DGPT(DA(1),"S","AO",X,DA)=""
 G C15F2
C15X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",45.01,DIIENS,8,DION),$P($G(^DGPT(DA(1),"S",DA,0)),U,8))
 S X=$G(X(1))
 Q
C15F2 S DIEZRXR(45.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1181 S DIEZRXR(45.01,DIXR)=""
 Q
X15 N DGIT S DGIT=8 D GETAPI^DGICDGT("DG PTF","PROC",$G(DA(1)),"EN1")
 Q
 ;
16 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=16 D X16 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X16 I X K DGPTIT S DGNFLD="@30",Y="@800",DGPTIT(X_$C(59)_"ICD0(")=""
 Q
17 S DQ=18 ;@30
18 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=18 D X18 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X18 S DGNFLD="@40"
 Q
19 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=19 D X19 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X19 I DGADD,$P(DGHOLD,U,9)]"" S Y="@40"
 Q
20 D:$D(DG)>9 F^DIE17,DE S DQ=20,DW="0;9",DV="*P80.1'X",DU="",DLB="OPERATION CODE 2",DIFLD=9
 S DE(DW)="C20^DGPTX41",DE(DW,"INDEX")=1
 S DU="ICD0("
 G RE
C20 G C20S:$D(DE(20))[0 K DB
C20S S X="" G:DG(DQ)=X C20F1 K DB
C20F1 N X,X1,X2 S DIXR=1281 D C20X1(U) K X2 M X2=X D C20X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . K ^DGPT(DA(1),"S","AO",X,DA)
 K X M X=X2 I $G(X(1))]"" D
 . S ^DGPT(DA(1),"S","AO",X,DA)=""
 G C20F2
C20X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",45.01,DIIENS,9,DION),$P($G(^DGPT(DA(1),"S",DA,0)),U,9))
 S X=$G(X(1))
 Q
C20F2 S DIEZRXR(45.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1182 S DIEZRXR(45.01,DIXR)=""
 Q
X20 N DGIT S DGIT=8 D GETAPI^DGICDGT("DG PTF","PROC",$G(DA(1)),"EN1")
 Q
 ;
21 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=21 D X21 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X21 I X K DGPTIT S DGNFLD="@40",Y="@800",DGPTIT(X_$C(59)_"ICD0(")=""
 Q
22 S DQ=23 ;@40
23 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=23 D X23 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X23 S DGNFLD="@50"
 Q
24 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=24 D X24 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X24 I DGADD,$P(DGHOLD,U,10)]"" S Y="@50"
 Q
25 D:$D(DG)>9 F^DIE17,DE S DQ=25,DW="0;10",DV="*P80.1'X",DU="",DLB="OPERATION CODE 3",DIFLD=10
 S DE(DW)="C25^DGPTX41",DE(DW,"INDEX")=1
 S DU="ICD0("
 G RE
C25 G C25S:$D(DE(25))[0 K DB
C25S S X="" G:DG(DQ)=X C25F1 K DB
C25F1 N X,X1,X2 S DIXR=1288 D C25X1(U) K X2 M X2=X D C25X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . K ^DGPT(DA(1),"S","AO",X,DA)
 K X M X=X2 I $G(X(1))]"" D
 . S ^DGPT(DA(1),"S","AO",X,DA)=""
 G C25F2
C25X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",45.01,DIIENS,10,DION),$P($G(^DGPT(DA(1),"S",DA,0)),U,10))
 S X=$G(X(1))
 Q
C25F2 S DIEZRXR(45.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1183 S DIEZRXR(45.01,DIXR)=""
 Q
X25 N DGIT S DGIT=8 D GETAPI^DGICDGT("DG PTF","PROC",$G(DA(1)),"EN1")
 Q
 ;
26 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=26 D X26 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X26 I X K DGPTIT S DGNFLD="@50",Y="@800",DGPTIT(X_$C(59)_"ICD0(")=""
 Q
27 S DQ=28 ;@50
28 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=28 D X28 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X28 S DGNFLD="@60"
 Q
29 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=29 D X29 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X29 I DGADD,$P(DGHOLD,U,11)]"" S Y="@60"
 Q
30 D:$D(DG)>9 F^DIE17,DE S DQ=30,DW="0;11",DV="*P80.1'X",DU="",DLB="OPERATION CODE 4",DIFLD=11
 S DE(DW)="C30^DGPTX41",DE(DW,"INDEX")=1
 S DU="ICD0("
 G RE
C30 G C30S:$D(DE(30))[0 K DB
C30S S X="" G:DG(DQ)=X C30F1 K DB
C30F1 N X,X1,X2 S DIXR=1289 D C30X1(U) K X2 M X2=X D C30X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . K ^DGPT(DA(1),"S","AO",X,DA)
 K X M X=X2 I $G(X(1))]"" D
 . S ^DGPT(DA(1),"S","AO",X,DA)=""
 G C30F2
C30X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",45.01,DIIENS,11,DION),$P($G(^DGPT(DA(1),"S",DA,0)),U,11))
 S X=$G(X(1))
 Q
C30F2 S DIEZRXR(45.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1184 S DIEZRXR(45.01,DIXR)=""
 Q
X30 N DGIT S DGIT=8 D GETAPI^DGICDGT("DG PTF","PROC",$G(DA(1)),"EN1")
 Q
 ;
31 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=31 D X31 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X31 I X K DGPTIT S DGNFLD="@60",Y="@800",DGPTIT(X_$C(59)_"ICD0(")=""
 Q
32 S DQ=33 ;@60
33 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=33 D X33 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X33 S DGNFLD="@70"
 Q
34 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=34 D X34 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X34 I DGADD,$P(DGHOLD,U,12)]"" S Y="@70"
 Q
35 D:$D(DG)>9 F^DIE17,DE S DQ=35,DW="0;12",DV="*P80.1'X",DU="",DLB="OPERATION CODE 5",DIFLD=12
 S DE(DW)="C35^DGPTX41",DE(DW,"INDEX")=1
 S DU="ICD0("
 G RE
C35 G C35S:$D(DE(35))[0 K DB
C35S S X="" G:DG(DQ)=X C35F1 K DB
C35F1 N X,X1,X2 S DIXR=1290 D C35X1(U) K X2 M X2=X D C35X1("O") K X1 M X1=X
 I $G(X(1))]"" D
 . K ^DGPT(DA(1),"S","AO",X,DA)
 K X M X=X2 I $G(X(1))]"" D
 . S ^DGPT(DA(1),"S","AO",X,DA)=""
 G C35F2
C35X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",45.01,DIIENS,12,DION),$P($G(^DGPT(DA(1),"S",DA,0)),U,12))
 S X=$G(X(1))
 Q
C35F2 S DIEZRXR(45.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1185 S DIEZRXR(45.01,DIXR)=""
 Q
X35 N DGIT S DGIT=8 D GETAPI^DGICDGT("DG PTF","PROC",$G(DA(1)),"EN1")
 Q
 ;
36 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=36 D X36 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X36 I X K DGPTIT S DGNFLD="@70",Y="@800",DGPTIT(X_$C(59)_"ICD0(")=""
 Q
37 S DQ=38 ;@70
38 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=38 D X38 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X38 K DGNFLD S Y=""
 Q
39 S DQ=40 ;@800
40 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=40 D X40 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X40 D SCAN^DGPTSCAN I '$D(DGBPC) S Y="@899"
 Q
41 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=41 D X41 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X41 I '$D(DGBPC(1)) S Y="@899"
 Q
42 D:$D(DG)>9 F^DIE17,DE S DQ=42,DW="300;1",DV="SX",DU="",DLB="KIDNEY SOURCE",DIFLD=300.01
 S DU="1:Live Donor;2:Cadaver;"
 G RE
X42 S DGFLAG=1 D 401^DGPTSC01 K:DGER X K DGER,DGFLAG
 Q
 ;
43 S DQ=44 ;@899
44 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=44 D X44 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X44 K DGPTIT S Y=DGNFLD
 Q
45 G 1^DIE17
