DGPTXC ; GENERATED FROM 'DG PTF CREATE PTF ENTRY' INPUT TEMPLATE(#443), FILE 45;09/03/15
 D DE G BEGIN
DE S DIE="^DGPT(",DIC=DIE,DP=45,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^DGPT(DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,2) S:%]"" DE(1)=% S %=$P(%Z,U,4) S:%]"" DE(2)=% S %=$P(%Z,U,6) S:%]"" DE(3)=% S %=$P(%Z,U,11) S:%]"" DE(5)=%
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
BEGIN S DNM="DGPTXC",DQ=1
 N DIEZTMP,DIEZAR,DIEZRXR,DIIENS,DIXR K DIEFIRE,DIEBADK S DIEZTMP=$$GETTMP^DIKC1("DIEZ")
 M DIEZAR=^DIE(443,"AR") S DICRREC="TRIG^DIE17"
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIIENS=DA_",",DIEZ=443,U="^"
1 S DW="0;2",DV="RDX",DU="",DLB="ADMISSION DATE",DIFLD=2
 S DE(DW)="C1^DGPTXC",DE(DW,"INDEX")=1
 S X=$P(DGPTDATA,U,2)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C1 G C1S:$D(DE(1))[0 K DB
 S X=DE(1),DIC=DIE
 S L=+^DGPT(DA,0) I L>0 K ^DGPT("AAD",L,X,DA)
 S X=DE(1),DIC=DIE
 K ^DGPT("AF",$E(X,1,30),DA)
 S X=DE(1),DIC=DIE
 K ^DGPT("AADA",X,DA)
 S X=DE(1),DIC=DIE
 I $P(^DGPT(DA,0),U,4),$P(^(0),U) K ^DGPT("AFEE",$P(^DGPT(DA,0),U),$E(X,1,30),DA)
C1S S X="" G:DG(DQ)=X C1F1 K DB
 S X=DG(DQ),DIC=DIE
 S L=+^DGPT(DA,0) I L>0 S ^DGPT("AAD",L,X,DA)=""
 S X=DG(DQ),DIC=DIE
 S ^DGPT("AF",$E(X,1,30),DA)=""
 S X=DG(DQ),DIC=DIE
 S L=$S($D(^DGPT(DA,70)):+^(70),1:0) I L'?7N.E S ^DGPT("AADA",X,DA)=""
 S X=DG(DQ),DIC=DIE
 I $P(^DGPT(DA,0),U,4),$P(^(0),U) S ^DGPT("AFEE",$P(^DGPT(DA,0),U),$E(X,1,30),DA)=""
C1F1 S DIEZRXR(45,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=28,29,30,31,32,33,34,35,36,37,400,401,402,403,404 S DIEZRXR(45,DIXR)=""
 Q
X1 Q
2 D:$D(DG)>9 F^DIE17,DE S DQ=2,DW="0;4",DV="S",DU="",DLB="FEE BASIS",DIFLD=4
 S DE(DW)="C2^DGPTXC"
 S DU="1:FEE BASIS;"
 S X=$P(DGPTDATA,U,3)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C2 G C2S:$D(DE(2))[0 K DB
 S X=DE(2),DIC=DIE
 I $P(^DGPT(DA,0),U),$P(^(0),U,2) K ^DGPT("AFEE",$P(^DGPT(DA,0),U),$P(^DGPT(DA,0),U,2),DA)
C2S S X="" G:DG(DQ)=X C2F1 K DB
 S X=DG(DQ),DIC=DIE
 I $P(^DGPT(DA,0),U),$P(^(0),U,2) S ^DGPT("AFEE",$P(^DGPT(DA,0),U),$P(^DGPT(DA,0),U,2),DA)=""
C2F1 Q
X2 Q
3 D:$D(DG)>9 F^DIE17,DE S DQ=3,DW="0;6",DV="S",DU="",DLB="STATUS",DIFLD=6
 S DE(DW)="C3^DGPTXC"
 S DU="0:Open;1:Closed;2:Released;3:Transmitted;"
 S X=0
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C3 G C3S:$D(DE(3))[0 K DB
 S X=DE(3),DIC=DIE
 K ^DGPT("AS",$E(X,1,30),DA)
C3S S X="" G:DG(DQ)=X C3F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^DGPT("AS",$E(X,1,30),DA)=""
C3F1 Q
X3 Q
4 D:$D(DG)>9 F^DIE17,DE S DQ=4,D=0 K DE(1) ;50
 S DIFLD=50,DGO="^DGPTXC1",DC="37^45.02AI^M^",DV="45.02MNJ6,1X",DW="0;1",DOW="MOVEMENT RECORD",DLB=$P($$EZBLD^DIALOG(8042,DOW),": ") S:D DC=DC_D
 G RE:D I $D(DSC(45.02))#2,$P(DSC(45.02),"I $D(^UTILITY(",1)="" X DSC(45.02) S D=$O(^(0)) S:D="" D=-1 G M4
 S D=$S($D(^DGPT(DA,"M",0)):$P(^(0),U,3,4),$O(^(0))'="":$O(^(0)),1:-1)
M4 I D>0 S DC=DC_D I $D(^DGPT(DA,"M",+D,0)) S DE(4)=$P(^(0),U,1)
 S X=1
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
R4 D DE
 G A
 ;
5 S DW="0;11",DV="RS",DU="",DLB="TYPE OF RECORD",DIFLD=11
 S DE(DW)="C5^DGPTXC",DE(DW,"INDEX")=1
 S DU="1:PTF;2:CENSUS;"
 S X=$S('$D(DGRTY):1,'DGRTY:1,1:+DGRTY)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
C5 G C5S:$D(DE(5))[0 K DB
C5S S X="" G:DG(DQ)=X C5F1 K DB
C5F1 S DIEZRXR(45,DIIENS)=$$OREF^DILF($NA(@$$CREF^DILF(DIE)))
 F DIXR=28,29,30,31,32,33,34,35,36,37,400,401,402,403,404 S DIEZRXR(45,DIXR)=""
 Q
X5 Q
6 G 0^DIE17
