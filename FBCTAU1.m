FBCTAU1 ; ;09/13/15
 D DE G BEGIN
DE S DIE="^FBAAA(D0,1,",DIC=DIE,DP=161.01,DL=2,DIEL=1,DU="" K DG,DE,DB Q:$O(^FBAAA(D0,1,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,1) S:%]"" DE(4)=%,DE(13)=% S %=$P(%Z,U,2) S:%]"" DE(19)=% S %=$P(%Z,U,3) S:%]"" DE(24)=% S %=$P(%Z,U,5) S:%]"" DE(26)=% S %=$P(%Z,U,7) S:%]"" DE(39)=% S %=$P(%Z,U,13) S:%]"" DE(47)=%
 I  S %=$P(%Z,U,18) S:%]"" DE(46)=% S %=$P(%Z,U,21) S:%]"" DE(27)=%
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
BEGIN S DNM="FBCTAU1",DQ=1
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 S FBAOLD=^FBAAA(DA(1),1,DA,0),FBAALT=$S($P(FBAOLD,"^",13)=2:"Y",$P(FBAOLD,"^",13)=3:"Y",1:""),FBPRG=$P(FBAOLD,"^",3)
 Q
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 I FBPRG,FBPRG'=2 W !!,*7,"You are only allowed to edit an outpatient authorization using this option.",!! S Y=""
 Q
3 S DQ=4 ;@1
4 S DW="0;1",DV="DX",DU="",DLB="FROM DATE",DIFLD=.01
 S DE(DW)="C4^FBCTAU1",DE(DW,"INDEX")=1
 G RE
C4 G C4S:$D(DE(4))[0 K DB
 S X=DE(4),DIC=DIE
 K:$P(^FBAAA(DA(1),1,DA,0),U,20)]"" ^FBAAA("AIC",DA(1),-X,$P(^FBAAA(DA(1),1,DA,0),U,20),DA)
 S X=DE(4),DIC=DIE
 K ^FBAAA("ATST",$E(X,1,30),DA(1),DA)
 S X=DE(4),DIC=DIE
 K ^FBAAA(DA(1),1,"B",$E(X,1,30),DA)
 S X=DE(4),DIC=DIE
 D:'$D(DIU(0)) EVENT^IVMPLOG(DA(1))
C4S S X="" G:DG(DQ)=X C4F1 K DB
 S X=DG(DQ),DIC=DIE
 S:$P(^FBAAA(DA(1),1,DA,0),U,20)]"" ^FBAAA("AIC",DA(1),-X,$P(^FBAAA(DA(1),1,DA,0),U,20),DA)=""
 S X=DG(DQ),DIC=DIE
 S ^FBAAA("ATST",$E(X,1,30),DA(1),DA)=""
 S X=DG(DQ),DIC=DIE
 S ^FBAAA(DA(1),1,"B",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 D:'$D(DIU(0)) EVENT^IVMPLOG(DA(1))
C4F1 S DIEZRXR(161.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1193 S DIEZRXR(161.01,DIXR)=""
 Q
X4 S %DT="EX" D ^%DT S X=Y K:Y<1 X
 Q
 ;
5 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=5 D X5 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X5 S FBTODT=X
 Q
6 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=6 D X6 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X6 S DOB=$P(^DPT(DFN,0),"^",3)
 Q
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 D NOW^%DTC
 Q
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 S NOW=X
 Q
9 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=9 D X9 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X9 S X=FBTODT
 Q
10 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=10 D X10 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X10 I $$FMDIFF^XLFDT(NOW,DOB,1)<365 S Y="@3"
 Q
11 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=11 D X11 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X11 I $P(FBAOLD,U,2)']"" S Y="@2"
 Q
12 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=12 D X12 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X12 I FBTODT'>$P(FBAOLD,U,2) S Y="@2"
 Q
13 D:$D(DG)>9 F^DIE17,DE S DQ=13,DW="0;1",DV="DX",DU="",DLB="FROM DATE",DIFLD=.01
 S DE(DW)="C13^FBCTAU1",DE(DW,"INDEX")=1
 S X=+FBAOLD
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C13 G C13S:$D(DE(13))[0 K DB
 S X=DE(13),DIC=DIE
 K:$P(^FBAAA(DA(1),1,DA,0),U,20)]"" ^FBAAA("AIC",DA(1),-X,$P(^FBAAA(DA(1),1,DA,0),U,20),DA)
 S X=DE(13),DIC=DIE
 K ^FBAAA("ATST",$E(X,1,30),DA(1),DA)
 S X=DE(13),DIC=DIE
 K ^FBAAA(DA(1),1,"B",$E(X,1,30),DA)
 S X=DE(13),DIC=DIE
 D:'$D(DIU(0)) EVENT^IVMPLOG(DA(1))
C13S S X="" G:DG(DQ)=X C13F1 K DB
 S X=DG(DQ),DIC=DIE
 S:$P(^FBAAA(DA(1),1,DA,0),U,20)]"" ^FBAAA("AIC",DA(1),-X,$P(^FBAAA(DA(1),1,DA,0),U,20),DA)=""
 S X=DG(DQ),DIC=DIE
 S ^FBAAA("ATST",$E(X,1,30),DA(1),DA)=""
 S X=DG(DQ),DIC=DIE
 S ^FBAAA(DA(1),1,"B",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 D:'$D(DIU(0)) EVENT^IVMPLOG(DA(1))
C13F1 S DIEZRXR(161.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1193 S DIEZRXR(161.01,DIXR)=""
 Q
X13 Q
14 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=14 D X14 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X14 W !,*7,"From Date cannot be later than the To Date!"
 Q
15 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=15 D X15 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X15 S Y="@1"
 Q
16 S DQ=17 ;@2
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 S:'$D(FBAADDYS) FBAADDYS=0 S X1=FBTODT,X2=FBAADDYS D C^%DTC S FBAAX=X
 Q
18 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=18 D X18 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X18 S FBD1=DA
 Q
19 D:$D(DG)>9 F^DIE17,DE S DQ=19,DW="0;2",DV="RDX",DU="",DLB="TO DATE",DIFLD=.02
 S DE(DW)="C19^FBCTAU1",DE(DW,"INDEX")=1
 S X=$E(FBAAX,4,5)_"-"_$E(FBAAX,6,7)_"-"_($E(FBAAX,1,3)+1700)
 S Y=X
 G Y
C19 G C19S:$D(DE(19))[0 K DB
 S X=DE(19),DIC=DIE
 ;
C19S S X="" G:DG(DQ)=X C19F1 K DB
 S X=DG(DQ),DIC=DIE
 D:'$D(DIU(0)) EVENT^IVMPLOG(DA(1)),ENRLLMNT^FBGMT2(DA(1))
C19F1 S DIEZRXR(161.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1193 S DIEZRXR(161.01,DIXR)=""
 Q
X19 S %DT="EX" D ^%DT S X=Y K:Y<1 X I $D(X),$P(^FBAAA(DA(1),1,DA,0),U,1)>X K X W !!,"To Date cannot be earlier than From Date!",!
 Q
 ;
20 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=20 D X20 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X20 S FBFRDT=DE(19)
 Q
21 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=21 D X21 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X21 I $$FMDIFF^XLFDT(NOW,DOB,1)<365 S Y="@6"
 Q
22 S DQ=23 ;@7
23 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=23 D X23 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X23 I $P(^FBAAA(DA(1),1,DA,0),"^",7)]"" K DIE("NO^")
 Q
24 D:$D(DG)>9 F^DIE17,DE S DQ=24,DW="0;3",DV="RP161.8'",DU="",DLB="FEE PROGRAM",DIFLD=.03
 S DE(DW)="C24^FBCTAU1"
 S DU="FBAA(161.8,"
 S X=$S(FBPRG:FBPRG,1:2)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C24 G C24S:$D(DE(24))[0 K DB
 S X=DE(24),DIC=DIE
 ;
C24S S X="" G:DG(DQ)=X C24F1 K DB
 S X=DG(DQ),DIC=DIE
 D:'$D(DIU(0)) EVENT^IVMPLOG(DA(1))
C24F1 Q
X24 Q
25 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=25 D X25 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X25 S FBTYPE=$S(FBPRG:FBPRG,1:2)
 Q
26 D:$D(DG)>9 F^DIE17,DE S DQ=26,DW="0;5",DV="RP4'",DU="",DLB="PRIMARY SERVICE FACILITY",DIFLD=101
 S DU="DIC(4,"
 G RE
X26 Q
27 S DW="0;21",DV="*P200'",DU="",DLB="REFERRING PROVIDER",DIFLD=104
 S DU="VA(200,"
 G RE
X27 S DIC("S")="I $$PROVIDER^FBAAAUT(+Y)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
28 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=28 D X28 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X28 I $G(X) W !,"REFERRING PROVIDER NPI: ",$$REFNPI^FBCH78(X)
 Q
29 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=29 D X29 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X29 S Y="@4"
 Q
30 S DQ=31 ;@3
31 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=31 D X31 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X31 I FBTODT'<DOB&(FBTODT'>$$FMADD^XLFDT(DOB,7)) S Y="@2"
 Q
32 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=32 D X32 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X32 W !,*7,"This is a Newborn, From Date must be between DOB and DOB+7"
 Q
33 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=33 D X33 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X33 S Y="@1"
 Q
34 S DQ=35 ;@6
35 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=35 D X35 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X35 I FBFRDT'<DOB&(FBFRDT'>$$FMADD^XLFDT(DOB,7)) S Y="@7"
 Q
36 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=36 D X36 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X36 W !,*7,"This is a Newborn, TO Date must be between DOB and DOB+7"
 Q
37 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=37 D X37 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X37 S Y="@2"
 Q
38 S DQ=39 ;@4
39 S DW="0;7",DV="R*P161.82'",DU="",DLB="PURPOSE OF VISIT CODE",DIFLD=.07
 S DE(DW)="C39^FBCTAU1",DE(DW,"INDEX")=1
 S DU="FBAA(161.82,"
 G RE
C39 G C39S:$D(DE(39))[0 K DB
C39S S X="" G:DG(DQ)=X C39F1 K DB
C39F1 S DIEZRXR(161.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1193 S DIEZRXR(161.01,DIXR)=""
 Q
X39 S DIC("S")="I $S('$G(^(""I"")):1,DT'>^(""I""):1,1:0),$S('$D(FBTYPE):1,$P(^(0),U,2)=FBTYPE:1,1:0)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
40 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=40 D X40 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X40 S:$$EXTPV^FBAAUTL5(X)'=55 Y="@5"
 Q
41 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=41 D X41 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X41 S:$P($$GETSTAT^DGMSTAPI(DA(1)),U,2)="Y" Y="@5"
 Q
42 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=42 D X42 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X42 S DIE("NO^")=""
 Q
43 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=43 D X43 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X43 W !,$C(7),"MST POV can't be selected because veteran's MST status is not YES."
 Q
44 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=44 D X44 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X44 S Y="@4"
 Q
45 S DQ=46 ;@5
46 D:$D(DG)>9 F^DIE17,DE S DQ=46,DW="0;18",DV="S",DU="",DLB="PATIENT TYPE CODE",DIFLD=.065
 S DU="00:SURGICAL;10:MEDICAL;60:HOME NURSING SERVICE;85:PSYCHIATRIC-CONTRACT;86:PSYCHIATRIC;95:NEUROLOGICAL-CONTRACT;96:NEUROLOGICAL;"
 G RE
X46 Q
47 S DW="0;13",DV="R*S",DU="",DLB="TREATMENT TYPE CODE",DIFLD=.095
 S DE(DW)="C47^FBCTAU1",DE(DW,"INDEX")=1
 S DU="1:SHORT TERM FEE STATUS;2:HOME NURSING SERVICES;3:I.D. CARD STATUS;4:STATE HOME;"
 G RE
C47 G C47S:$D(DE(47))[0 K DB
 S X=DE(47),DIC=DIE
 ;
C47S S X="" G:DG(DQ)=X C47F1 K DB
 S X=DG(DQ),DIC=DIE
 D:'$D(DIU(0)) EVENT^IVMPLOG(DA(1))
C47F1 S DIEZRXR(161.01,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=1193 S DIEZRXR(161.01,DIXR)=""
 Q
X47 Q
48 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=48 D X48 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X48 S FBAATT=X
 Q
49 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=49 D X49 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X49 S FBAALT=$S(X=2:"Y",X=3:"Y",1:"")
 Q
50 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=50 D X50 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X50 K DIE("NO^")
 Q
51 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=51 D X51 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X51 S ICDSYS=10,IMPDATE=$$IMPDATE^FBCSV1("10D")
 Q
52 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=52 D X52 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X52 S EDATE=+FBAOLD
 Q
53 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=53 D X53 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X53 S:EDATE<IMPDATE ICDSYS=9
 Q
54 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=54 D X54 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X54 I ICDSYS=10,FBAATT=3 S Y="@10"
 Q
55 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=55 D X55 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X55 S:ICDSYS=9 Y="@9"
 Q
56 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=56 D X56 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X56 S FBDFN=DFN
 Q
57 S DQ=58 ;@8
58 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=58 D X58 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X58 S XX1=-1 S XX1=$$ASKICD10^FBASF("  ICD DIAGNOSIS","")
 Q
59 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=59 D X59 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X59 I XX1<0 W !,"     ICD Diagnosis is required" S Y="@8"
 Q
60 D:$D(DG)>9 F^DIE17 G ^FBCTAU2