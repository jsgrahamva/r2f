DGX5FD7 ; ;11/08/15
 D DE G BEGIN
DE S DIE="^DGPT(D0,""M"",",DIC=DIE,DP=45.02,DL=2,DIEL=1,DU="" K DG,DE,DB Q:$O(^DGPT(D0,"M",DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,26) S:%]"" DE(61)=%,DE(64)=% S %=$P(%Z,U,27) S:%]"" DE(67)=% S %=$P(%Z,U,31) S:%]"" DE(55)=%,DE(58)=%
 I $D(^(81)) S %Z=^(81) S %=$P(%Z,U,14) S:%]"" DE(1)=% S %=$P(%Z,U,15) S:%]"" DE(11)=%
 I $D(^(82)) S %Z=^(82) S %=$P(%Z,U,24) S:%]"" DE(4)=% S %=$P(%Z,U,25) S:%]"" DE(14)=%
 I $D(^(300)) S %Z=^(300) S %=$P(%Z,U,2) S:%]"" DE(23)=% S %=$P(%Z,U,3) S:%]"" DE(27)=% S %=$P(%Z,U,4) S:%]"" DE(32)=%,DE(36)=% S %=$P(%Z,U,5) S:%]"" DE(40)=% S %=$P(%Z,U,6) S:%]"" DE(44)=% S %=$P(%Z,U,7) S:%]"" DE(48)=%
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
BEGIN S DNM="DGX5FD7",DQ=1
1 S DW="81;14",DV="*P80'X",DU="",DLB="ICD 24",DIFLD=81.14
 S DE(DW)="C1^DGX5FD7",DE(DW,"INDEX")=1
 S DU="ICD9("
 G RE
C1 G C1S:$D(DE(1))[0 K DB
 S X=DE(1),DIC=DIE
 K ^DGPT(DA(1),"M","AC",$E(X,1,30),DA)
 S X=DE(1),DIC=DIE
 K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^DGPT(D0,"M",D1,82)):^(82),1:"") S X=$P(Y(1),U,24),X=X S DIU=X K Y S X="" X ^DD(45.02,81.14,1,2,2.4)
 S X=DE(1),DIC=DIE
 X "N X S X=""DGRUDD01"" X ^%ZOSF(""TEST"") Q:'$T  N DG1 S DG1=+$P(^DGPT(DA(1),0),""^"",1) D:(DG1>0) ADGRU^DGRUDD01(DG1)"
C1S S X="" G:DG(DQ)=X C1F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^DGPT(DA(1),"M","AC",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^DGPT(D0,"M",D1,82)):^(82),1:"") S X=$P(Y(1),U,24),X=X S DIU=X K Y S X="" X ^DD(45.02,81.14,1,2,1.4)
 S X=DG(DQ),DIC=DIE
 X "N X S X=""DGRUDD01"" X ^%ZOSF(""TEST"") Q:'$T  N DG1 S DG1=+$P(^DGPT(DA(1),0),""^"",1) D:(DG1>0) ADGRU^DGRUDD01(DG1)"
C1F1 S DIEZRXR(45.02,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1217 S DIEZRXR(45.02,DIXR)=""
 Q
X1 N K D GETAPI^DGICDGT("DG PTF","DIAG",$G(DA(1)),"EN",81)
 Q
 ;
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 S DGXX=X
 Q
3 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=3 D X3 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X3 I DGXX="" S Y="@261"
 Q
4 D:$D(DG)>9 F^DIE17,DE S DQ=4,DW="82;24",DV="SX",DU="",DLB="POA FOR ICD 24",DIFLD=82.24
 S DU="Y:Present on Admission;N:Not Present on Admission;U:Insufficient Docum to Present on Admission;W:Can't Determine if Present on Admission;"
 G RE
X4 I X]"",$G(DA),$G(DA(1)) K:'$$POA501^DGPTFUT1(X,DA(1),DA,81,14) X
 Q
 ;
5 S DQ=6 ;@261
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 S X=DGXX
 Q
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 I X K DGPTIT S DGNFLD="@270",Y="@8000",DGPTIT(X_$C(59)_"ICD9(")=""
 Q
8 S DQ=9 ;@270
9 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=9 D X9 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X9 I DGADD,$P(DGHOLD1,U,15)]"" S Y="@280"
 Q
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 S DGNFLD="@280"
 Q
11 S DW="81;15",DV="*P80'X",DU="",DLB="ICD 25",DIFLD=81.15
 S DE(DW)="C11^DGX5FD7",DE(DW,"INDEX")=1
 S DU="ICD9("
 G RE
C11 G C11S:$D(DE(11))[0 K DB
 S X=DE(11),DIC=DIE
 K ^DGPT(DA(1),"M","AC",$E(X,1,30),DA)
 S X=DE(11),DIC=DIE
 K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^DGPT(D0,"M",D1,82)):^(82),1:"") S X=$P(Y(1),U,25),X=X S DIU=X K Y S X="" X ^DD(45.02,81.15,1,2,2.4)
 S X=DE(11),DIC=DIE
 X "N X S X=""DGRUDD01"" X ^%ZOSF(""TEST"") Q:'$T  N DG1 S DG1=+$P(^DGPT(DA(1),0),""^"",1) D:(DG1>0) ADGRU^DGRUDD01(DG1)"
C11S S X="" G:DG(DQ)=X C11F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^DGPT(DA(1),"M","AC",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA(1),DIV(0)=D0,D1=DA,DIV(1)=D1 S Y(1)=$S($D(^DGPT(D0,"M",D1,82)):^(82),1:"") S X=$P(Y(1),U,25),X=X S DIU=X K Y S X="" X ^DD(45.02,81.15,1,2,1.4)
 S X=DG(DQ),DIC=DIE
 X "N X S X=""DGRUDD01"" X ^%ZOSF(""TEST"") Q:'$T  N DG1 S DG1=+$P(^DGPT(DA(1),0),""^"",1) D:(DG1>0) ADGRU^DGRUDD01(DG1)"
C11F1 S DIEZRXR(45.02,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1218 S DIEZRXR(45.02,DIXR)=""
 Q
X11 N K D GETAPI^DGICDGT("DG PTF","DIAG",$G(DA(1)),"EN",81)
 Q
 ;
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 S DGXX=X
 Q
13 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=13 D X13 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X13 I DGXX="" S Y="@271"
 Q
14 D:$D(DG)>9 F^DIE17,DE S DQ=14,DW="82;25",DV="SX",DU="",DLB="POA FOR ICD 25",DIFLD=82.25
 S DU="Y:Present on Admission;N:Not Present on Admission;U:Insufficient Docum to Present on Admission;W:Can't Determine if Present on Admission;"
 G RE
X14 I X]"",$G(DA),$G(DA(1)) K:'$$POA501^DGPTFUT1(X,DA(1),DA,81,15) X
 Q
 ;
15 S DQ=16 ;@271
16 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=16 D X16 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X16 S X=DGXX
 Q
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 I X K DGPTIT S DGNFLD="@280",Y="@8000",DGPTIT(X_$C(59)_"ICD9(")=""
 Q
18 S DQ=19 ;@280
19 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=19 D X19 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X19 K DGNFLD,DGDUP,DGADD,DGXX,DGCODSYS S Y=""
 Q
20 S DQ=21 ;@8000
21 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=21 D X21 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X21 D SCAN^DGPTSCAN S:'$D(DGBPC) Y="@8990"
 Q
22 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=22 D X22 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X22 I '$D(DGBPC(2))!(DGDUP(2)) S Y="@8200"
 Q
23 S DW="300;2",DV="SX",DU="",DLB="SUICIDE/SELF INFLICT INDICATOR",DIFLD=300.02
 S DU="1:Attempted Suicide;2:Accomplished Suicide;3:Self Inflicted Injury;"
 G RE
X23 S DGFLAG=2 D 501^DGPTSC01 K:DGER X K DGER,DGFLAG Q
 Q
 ;
24 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=24 D X24 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X24 S:X]"" DGDUP(2)=1
 Q
25 S DQ=26 ;@8200
26 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=26 D X26 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X26 I '$D(DGBPC(3))!(DGDUP(3)) S Y="@8300"
 Q
27 S DW="300;3",DV="SX",DU="",DLB="LEGIONNAIRE'S DISEASE",DIFLD=300.03
 S DU="1:Yes;2:No;"
 G RE
X27 S DGFLAG=3 D 501^DGPTSC01 K:DGER X K DGER,DGFLAG Q
 Q
 ;
28 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=28 D X28 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X28 S:X]"" DGDUP(3)=1
 Q
29 S DQ=30 ;@8300
30 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=30 D X30 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X30 I '$D(DGBPC(4))!(DGDUP(4)) S Y="@8400"
 Q
31 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=31 D X31 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X31 D DRUG^DGPTSC01 I $D(DGTX) S Y="@8350"
 Q
32 S DW="300;4",DV="P45.61'X",DU="",DLB="SUBSTANCE ABUSE",DIFLD=300.04
 S DU="DIC(45.61,"
 G RE
X32 S DGFLAG=4 D 501^DGPTSC01 K:DGER X K DGER,DGFLAG
 Q
 ;
33 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=33 D X33 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X33 S:X]"" DGDUP(4)=1
 Q
34 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=34 D X34 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X34 S Y="@8400"
 Q
35 S DQ=36 ;@8350
36 S DW="300;4",DV="P45.61'X",DU="",DLB="SUBSTANCE ABUSE",DIFLD=300.04
 S DU="DIC(45.61,"
 S X=DGTX
 S Y=X
 G Y
X36 S DGFLAG=4 D 501^DGPTSC01 K:DGER X K DGER,DGFLAG
 Q
 ;
37 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=37 D X37 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X37 S:X]"" DGDUP(4)=1
 Q
38 S DQ=39 ;@8400
39 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=39 D X39 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X39 I '$D(DGBPC(5))!(DGDUP(5)) S Y="@8500"
 Q
40 S DW="300;5",DV="SX",DU="",DLB="PSYCHIATRY CLASS. SEVERITY",DIFLD=300.05
 S DU="0:INADEQUATE INFO OR NO CHANGE;1:NONE;2:MILD;3:MODERATE;4:SEVERE;5:EXTREME;6:CATASTROPHIC;"
 G RE
X40 S DGFLAG=5 D 501^DGPTSC01 K:DGER X K DGER,DGFLAG
 Q
 ;
41 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=41 D X41 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X41 S:X]"" DGDUP(5)=1
 Q
42 S DQ=43 ;@8500
43 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=43 D X43 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X43 I '$D(DGBPC(6))!(DGDUP(6)) S Y="@8600"
 Q
44 S DW="300;6",DV="NJ2,0X",DU="",DLB="CURRENT PSYCH CLASS ASSESS",DIFLD=300.06
 G RE
X44 S DGFLAG=6 D 501^DGPTSC01 S:DGER X="" K DGFLAG,DGER K:+X'=X!(X>90)!(X<1)!(X?.E1"."1N.N) X
 Q
 ;
45 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=45 D X45 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X45 S:X]"" DGDUP(6)=1
 Q
46 S DQ=47 ;@8600
47 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=47 D X47 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X47 I '$D(DGBPC(7))!(DGDUP(7)) S Y="@8990"
 Q
48 S DW="300;7",DV="NJ2,0X",DU="",DLB="HIGH LEVEL PSYCH CLASS",DIFLD=300.07
 G RE
X48 S DGFLAG=7 D 501^DGPTSC01 S:DGER X="" K DGER,DGFLAG K:+X'=X!(X>90)!(X<1)!(X?.E1"."1N.N) X
 Q
 ;
49 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=49 D X49 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X49 S:X]"" DGDUP(7)=1
 Q
50 S DQ=51 ;@8990
51 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=51 D X51 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X51 K DGPTIT S Y=DGNFLD
 Q
52 S DQ=53 ;@9000
53 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=53 D X53 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X53 K DGEXQ D CHQUES^DGPTSPQ I '$D(DGEXQ) S Y="@9999"
 Q
54 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=54 D X54 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X54 I '$D(DGEXQ(6)) S Y="@9040"
 Q
55 S DW="0;31",DV="S",DU="",DLB="WAS TREATMENT RELATED TO COMBAT?",DIFLD=31
 S DU="Y:YES;N:NO;"
 S Y="YES"
 G Y
X55 Q
56 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=56 D X56 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X56 S Y="@9050"
 Q
57 S DQ=58 ;@9040
58 S DW="0;31",DV="S",DU="",DLB="POTENTIALLY RELATED TO COMBAT",DIFLD=31
 S DU="Y:YES;N:NO;"
 S Y="@"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X58 Q
59 S DQ=60 ;@9050
60 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=60 D X60 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X60 I '$D(DGEXQ(1)) S Y="@9100"
 Q
61 S DW="0;26",DV="SX",DU="",DLB="WAS TREATMENT RELATED TO AGENT ORANGE EXPOSURE?",DIFLD=26
 S DU="Y:YES;N:NO;"
 G RE
X61 S DGFLAG=1 D 501^DGPTSPQ K:DGER X K DGER,DGFLAG
 Q
 ;
62 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=62 D X62 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X62 S Y="@9150"
 Q
63 S DQ=64 ;@9100
64 S DW="0;26",DV="SX",DU="",DLB="TREATED FOR AO CONDITION",DIFLD=26
 S DU="Y:YES;N:NO;"
 S Y="@"
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
X64 S DGFLAG=1 D 501^DGPTSPQ K:DGER X K DGER,DGFLAG
 Q
 ;
65 S DQ=66 ;@9150
66 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=66 D X66 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X66 I '$D(DGEXQ(2)) S Y="@9200"
 Q
67 S DW="0;27",DV="SX",DU="",DLB="WAS TREATMENT RELATED TO IONIZING RADIATION EXPOSURE?",DIFLD=27
 S DU="Y:YES;N:NO;"
 G RE
X67 S DGFLAG=2 D 501^DGPTSPQ K:DGER X K DGER,DGFLAG
 Q
 ;
68 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=68 D X68 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X68 S Y="@9250"
 Q
69 S DQ=70 ;@9200
70 D:$D(DG)>9 F^DIE17 G ^DGX5FD8
