MCOBGA ; GENERATED FROM 'MCARGIBRPR' PRINT TEMPLATE (#1026) ; 09/19/10 ; (FILE 699, MARGIN=80)
 G BEGIN
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1)
 S DISTP=DISTP+1,DILCT=DILCT+1 D:'(DISTP#100) CSTP^DIO2
 Q
DT I $G(DUZ("LANG"))>1,Y W $$OUT^DIALOGU(Y,"DD") Q
 I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1 S DISTP=$G(DISTP),DILCT=$G(DILCT)
 I $D(DXS)<9 M DXS=^DIPT(1026,"DXS")
 S I(0)="^MCAR(699,",J(0)=699
 W ?0 W "APPT DATE/TIME: "
 S X=$G(^MCAR(699,D0,0)) D N:$X>16 Q:'DN  W ?16 S Y=$P(X,U,1) D DT
 D N:$X>39 Q:'DN  W ?39 W "MEDICAL PATIENT: "
 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^MCAR(690,Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^DPT(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "INDICATED THERAPY: "
 S I(1)=2,J(1)=699.17 F D1=0:0 Q:$O(^MCAR(699,D0,2,D1))'>0  X:$D(DSC(699.17)) DSC(699.17) S D1=$O(^(D1)) Q:D1'>0  D:$X>25 T Q:'DN  D A1
 G A1R
A1 ;
 S X=$G(^MCAR(699,D0,2,D1,0)) S DIWL=26,DIWR=80 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(699.6,Y,0))#2:$P(^(0),U),1:Y) S X=Y D ^DIWP
 D 0^DIWW
 D ^DIWW
 Q
A1R ;
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "SIGNS AND SYMPTOMS: "
 S I(1)=3,J(1)=699.18 F D1=0:0 Q:$O(^MCAR(699,D0,3,D1))'>0  X:$D(DSC(699.18)) DSC(699.18) S D1=$O(^(D1)) Q:D1'>0  D:$X>26 T Q:'DN  D B1
 G B1R
B1 ;
 S X=$G(^MCAR(699,D0,3,D1,0)) D T Q:'DN  S DIWL=5,DIWR=59 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(695.5,Y,0))#2:$P(^(0),U),1:Y) S X=Y D ^DIWP
 D 0^DIWW
 D ^DIWW
 Q
B1R ;
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "DISEASE FOLLOWUP: "
 S I(1)=5,J(1)=699.35 F D1=0:0 Q:$O(^MCAR(699,D0,5,D1))'>0  X:$D(DSC(699.35)) DSC(699.35) S D1=$O(^(D1)) Q:D1'>0  D:$X>24 T Q:'DN  D C1
 G C1R
C1 ;
 S X=$G(^MCAR(699,D0,5,D1,0)) S DIWL=25,DIWR=79 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(699.84,Y,0))#2:$P(^(0),U),1:Y) S X=Y D ^DIWP
 D 0^DIWW
 D ^DIWW
 Q
C1R ;
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "FOLLOWUP DEVICE OR THERAPY: "
 S I(1)=6,J(1)=699.36 F D1=0:0 Q:$O(^MCAR(699,D0,6,D1))'>0  X:$D(DSC(699.36)) DSC(699.36) S D1=$O(^(D1)) Q:D1'>0  D:$X>34 T Q:'DN  D D1
 G D1R
D1 ;
 S X=$G(^MCAR(699,D0,6,D1,0)) D T Q:'DN  S DIWL=5,DIWR=59 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(699.85,Y,0))#2:$P(^(0),U),1:Y) S X=Y D ^DIWP
 D 0^DIWW
 D ^DIWW
 Q
D1R ;
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "SURVEILLANCE: "
 S I(1)=7,J(1)=699.37 F D1=0:0 Q:$O(^MCAR(699,D0,7,D1))'>0  X:$D(DSC(699.37)) DSC(699.37) S D1=$O(^(D1)) Q:D1'>0  D:$X>20 T Q:'DN  D E1
 G E1R
E1 ;
 S X=$G(^MCAR(699,D0,7,D1,0)) S DIWL=21,DIWR=75 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(699.86,Y,0))#2:$P(^(0),U),1:Y) S X=Y D ^DIWP
 D 0^DIWW
 D ^DIWW
 Q
E1R ;
 D N:$X>4 Q:'DN  W ?4 S DIP(1)=$S($D(^MCAR(699,D0,31)):^(31),1:"") S X="PROTOCOL: "_$P(DIP(1),U,1) K DIP K:DN Y W X
 D N:$X>4 Q:'DN  W ?4 S DIP(1)=$S($D(^MCAR(699,D0,31)):^(31),1:"") S X="EGD SIMPLE PRIMARY EXAM: "_$P(DIP(1),U,2) K DIP K:DN Y W X
 D N:$X>4 Q:'DN  W ?4 S DIP(1)=$S($D(^MCAR(699,D0,31)):^(31),1:"") S X="LAB OR XRAY: "_$P(DIP(1),U,3) K DIP K:DN Y W X
 D N:$X>4 Q:'DN  W ?4 S DIP(1)=$S($D(^MCAR(699,D0,32)):^(32),1:"") S X="OCCULT BLOOD: "_$P(DIP(1),U,1) K DIP K:DN Y W X
 D N:$X>4 Q:'DN  W ?4 S DIP(1)=$S($D(^MCAR(699,D0,32)):^(32),1:"") S X="SPECIMEN COLLECTION: "_$P(DIP(1),U,2) K DIP K:DN Y W X
 D N:$X>2 Q:'DN  W ?2 W "COMMENT: "
 S X=$G(^MCAR(699,D0,0)) D T Q:'DN  S DIWL=13,DIWR=80 S Y=$P(X,U,6) S X=Y D ^DIWP
 D 0^DIWW
 D ^DIWW
 D N:$X>1 Q:'DN  W ?1 W "ENDOSCOPIST: "
 S X=$G(^MCAR(699,D0,0)) D N:$X>15 Q:'DN  W ?15 S Y=$P(X,U,8) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 D N:$X>44 Q:'DN  W ?44 W "FELLOW: "
 S X=$G(^MCAR(699,D0,200)) S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 W ?54 D:MCARGNAM="COL" COL^MCARGS K DIP K:DN Y
 W ?65 D:MCARGNAM="LAP" LAP^MCARGS K DIP K:DN Y
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "SUMMARY: "
 S X=$G(^MCAR(699,D0,.2)) S Y=$P(X,U,1) W:Y]"" $S($D(DXS(7,Y)):DXS(7,Y),1:Y)
 D T Q:'DN  D N D N:$X>2 Q:'DN  W ?2 W "LOCATION: "
 S I(1)=30,J(1)=699.01 F D1=0:0 Q:$O(^MCAR(699,D0,30,D1))'>0  X:$D(DSC(699.01)) DSC(699.01) S D1=$O(^(D1)) Q:D1'>0  D:$X>14 T Q:'DN  D F1
 G F1R
F1 ;
 S X=$G(^MCAR(699,D0,30,D1,0)) W ?14 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(697,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>2 Q:'DN  W ?2 W "DESCRIPTION: "
 D N:$X>16 Q:'DN  W ?16 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^MCAR(699.55,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 W ?16 X DXS(1,9) K DIP K:DN Y
 W ?27 K ZI,ZZ K DIP K:DN Y
 D N:$X>2 Q:'DN  W ?2 X DXS(2,9.2) S X=$S(DIP(2):DIP(3),DIP(4):X) K DIP K:DN Y W X
 S X=$G(^MCAR(699,D0,30,D1,0)) W ?0,$E($P(X,U,4),1,15)
 D N:$X>2 Q:'DN  W ?2 W "TECHNIQUE: "
 S I(2)=2,J(2)=699.15 F D2=0:0 Q:$O(^MCAR(699,D0,30,D1,2,D2))'>0  X:$D(DSC(699.15)) DSC(699.15) S D2=$O(^(D2)) Q:D2'>0  D:$X>15 T Q:'DN  D A2
 G A2R
A2 ;
 S X=$G(^MCAR(699,D0,30,D1,2,D2,0)) D N:$X>16 Q:'DN  W ?16 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(699.6,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,60)
 Q
A2R ;
 D N:$X>2 Q:'DN  W ?2 W "IMPRESSION: "
 S X=$G(^MCAR(699,D0,30,D1,0)) D N:$X>16 Q:'DN  W ?16 S Y=$P(X,U,6) S Y=$S(Y="":Y,$D(^MCAR(697.5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,50)
 W ?16 D TECH^MCARGS K DIP K:DN Y
 Q
F1R ;
 W ?27 X DXS(3,9) K DIP K:DN Y
 W ?38 X DXS(4,9) K DIP K:DN Y
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 X DXS(5,9) K DIP K:DN Y W X
 D N:$X>2 Q:'DN  W ?2 W "RESULTS: "
 S I(1)=16,J(1)=699.56 F D1=0:0 Q:$O(^MCAR(699,D0,16,D1))'>0  X:$D(DSC(699.56)) DSC(699.56) S D1=$O(^(D1)) Q:D1'>0  D:$X>13 T Q:'DN  D G1
 G G1R
G1 ;
 S X=$G(^MCAR(699,D0,16,D1,0)) D N:$X>11 Q:'DN  W ?11 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(699.81,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,60)
 Q
G1R ;
 D N:$X>2 Q:'DN  W ?2 W "COMPLICATIONS: "
 S I(1)=17,J(1)=699.58 F D1=0:0 Q:$O(^MCAR(699,D0,17,D1))'>0  X:$D(DSC(699.58)) DSC(699.58) S D1=$O(^(D1)) Q:D1'>0  D:$X>19 T Q:'DN  D H1
 G H1R
H1 ;
 S X=$G(^MCAR(699,D0,17,D1,0)) D N:$X>17 Q:'DN  W ?17 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(696.9,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,40)
 W ", "
 S Y=$P(X,U,2) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 Q
H1R ;
 S I(1)=25,J(1)=699.73 F D1=0:0 Q:$O(^MCAR(699,D0,25,D1))'>0  X:$D(DSC(699.73)) DSC(699.73) S D1=$O(^(D1)) Q:D1'>0  D:$X>17 T Q:'DN  D I1
 G I1R
I1 ;
 D N:$X>2 Q:'DN  W ?2 W "DISPOSITION: "
 S X=$G(^MCAR(699,D0,25,D1,0)) D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(9,Y)):DXS(9,Y),1:Y)
 D N:$X>12 Q:'DN  W ?12 W "DATE: "
 D N:$X>20 Q:'DN  W ?20 S Y=$P(X,U,2) D DT
 Q
I1R ;
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 X DXS(6,9) K DIP K:DN Y W X
 D N:$X>2 Q:'DN  W ?2 W "PRIMARY: "
 S X=$G(^MCAR(699,D0,204)) D N:$X>17 Q:'DN  W ?17 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(697.5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,50)
 S I(1)=27,J(1)=699.75 F D1=0:0 Q:$O(^MCAR(699,D0,27,D1))'>0  X:$D(DSC(699.75)) DSC(699.75) S D1=$O(^(D1)) Q:D1'>0  D:$X>17 T Q:'DN  D J1
 G J1R
J1 ;
 D N:$X>2 Q:'DN  W ?2 W "SECONDARY: "
 S X=$G(^MCAR(699,D0,27,D1,0)) D N:$X>17 Q:'DN  W ?17 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^MCAR(697.5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,50)
 Q
J1R ;
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "PROCEDURE SUMMARY: "
 S X=$G(^MCAR(699,D0,.2)) S DIWL=26,DIWR=80 S Y=$P(X,U,2) S X=Y D ^DIWP
 D 0^DIWW
 D ^DIWW
 D T Q:'DN  W ?2 S MCFILE=699 D DISP^MCMAG K DIP K:DN Y
 W ?13 K MCFILE K DIP K:DN Y
 K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!