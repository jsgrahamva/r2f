MCAROAT ; GENERATED FROM 'MCAREP2' PRINT TEMPLATE (#1041) ; 09/19/10 ; (FILE 691.9, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(1041,"DXS")
 S I(0)="^MCAR(691.9,",J(0)=691.9
 D T Q:'DN  D N W ?0 W "----------------------------------ATRIAL STUDY----------------------------------"
 D T Q:'DN  D N W ?0 X DXS(1,9.2) S X=X_Y K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>7 Q:'DN  W ?7 W "PREMEDICATION:"
 S X=$G(^MCAR(691.9,D0,0)) D N:$X>22 Q:'DN  S DIWL=23,DIWR=52 S Y=$P(X,U,4) S X=Y D ^DIWP
 D 0^DIWW
 D ^DIWW
 D N:$X>7 Q:'DN  W ?7 S DIP(1)=$S($D(^MCAR(691.9,D0,0)):^(0),1:"") S X="ENTRY SITE: "_$S('$D(^MCAR(697,+$P(DIP(1),U,6),0)):"",1:$P(^(0),U,1)) K DIP K:DN Y W X
 D N:$X>42 Q:'DN  W ?42 X DXS(2,9) K DIP K:DN Y W X
 D N:$X>7 Q:'DN  W ?7 S DIP(1)=$S($D(^MCAR(691.9,D0,0)):^(0),1:"") S X="RECORDING SITE: "_$S('$D(^MCAR(693.5,+$P(DIP(1),U,7),0)):"",1:$P(^(0),U,1)) K DIP K:DN Y W X
 D N:$X>7 Q:'DN  W ?7 S DIP(1)=$S($D(^MCAR(691.9,D0,0)):^(0),1:"") S X="ATRIAL THRESHOLD (mA): "_$P(DIP(1),U,9) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>7 Q:'DN  W ?7 W "CONDUCTION TIMES"
 D N:$X>43 Q:'DN  W ?43 W "SINUS NODE FUNCTION STUDIES"
 D N:$X>9 Q:'DN  W ?9 S DIP(1)=$S($D(^MCAR(691.9,D0,0)):^(0),1:"") S X="PA (NL 20-40 MSEC): "_$P(DIP(1),U,10) K DIP K:DN Y W X
 D N:$X>45 Q:'DN  W ?45 S DIP(1)=$S($D(^MCAR(691.9,D0,2)):^(2),1:"") S X="SACT (NL 80 +/- 40 MSEC): "_$P(DIP(1),U,8) K DIP K:DN Y W X
 D N:$X>9 Q:'DN  W ?9 S DIP(1)=$S($D(^MCAR(691.9,D0,0)):^(0),1:"") S X="AH (NL 60-120 MSEC): "_$P(DIP(1),U,11) K DIP K:DN Y W X
 D N:$X>45 Q:'DN  W ?45 S DIP(1)=$S($D(^MCAR(691.9,D0,2)):^(2),1:"") S X="CSART (NL 260+/- 95 MSEC): "_$P(DIP(1),U,9) K DIP K:DN Y W X
 D N:$X>9 Q:'DN  W ?9 S DIP(1)=$S($D(^MCAR(691.9,D0,0)):^(0),1:"") S X="HV (NL 35-55 MSEC): "_$P(DIP(1),U,12) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>7 Q:'DN  W ?7 W "ATRIAL EXTRA STIMULUS TECHNIQUE    (VALUES BELOW IN MSEC)"
 S I(1)=1,J(1)=691.911 F D1=0:0 Q:$O(^MCAR(691.9,D0,1,D1))'>0  X:$D(DSC(691.911)) DSC(691.911) S D1=$O(^(D1)) Q:D1'>0  D:$X>66 T Q:'DN  D A1
 G A1R
A1 ;
 D N:$X>9 Q:'DN  W ?9 S DIP(1)=$S($D(^MCAR(691.9,D0,1,D1,0)):^(0),1:"") S X="DRIVE CYCLE LENGTH: "_$P(DIP(1),U,1) K DIP K:DN Y W X
 D N:$X>11 Q:'DN  W ?11 S DIP(1)=$S($D(^MCAR(691.9,D0,1,D1,0)):^(0),1:"") S X="AERP: "_$P(DIP(1),U,2) K DIP K:DN Y W X
 D N:$X>31 Q:'DN  W ?31 S DIP(1)=$S($D(^MCAR(691.9,D0,1,D1,0)):^(0),1:"") S X="AVERP: "_$P(DIP(1),U,5) K DIP K:DN Y W X
 D N:$X>51 Q:'DN  W ?51 S DIP(1)=$S($D(^MCAR(691.9,D0,1,D1,0)):^(0),1:"") S X="HPERP: "_$P(DIP(1),U,8) K DIP K:DN Y W X
 D N:$X>11 Q:'DN  W ?11 S DIP(1)=$S($D(^MCAR(691.9,D0,1,D1,0)):^(0),1:"") S X="AFRP: "_$P(DIP(1),U,3) K DIP K:DN Y W X
 D N:$X>31 Q:'DN  W ?31 S DIP(1)=$S($D(^MCAR(691.9,D0,1,D1,0)):^(0),1:"") S X="AVFRP: "_$P(DIP(1),U,6) K DIP K:DN Y W X
 D N:$X>51 Q:'DN  W ?51 S DIP(1)=$S($D(^MCAR(691.9,D0,1,D1,0)):^(0),1:"") S X="HPFRP: "_$P(DIP(1),U,9) K DIP K:DN Y W X
 D N:$X>11 Q:'DN  W ?11 S DIP(1)=$S($D(^MCAR(691.9,D0,1,D1,0)):^(0),1:"") S X="ARRP: "_$P(DIP(1),U,4) K DIP K:DN Y W X
 D N:$X>31 Q:'DN  W ?31 S DIP(1)=$S($D(^MCAR(691.9,D0,1,D1,0)):^(0),1:"") S X="AVRRP: "_$P(DIP(1),U,7) K DIP K:DN Y W X
 D N:$X>51 Q:'DN  W ?51 S DIP(1)=$S($D(^MCAR(691.9,D0,1,D1,0)):^(0),1:"") S X="HPRRP: "_$P(DIP(1),U,10) K DIP K:DN Y W X
 Q
A1R ;
 D T Q:'DN  D N D N:$X>7 Q:'DN  W ?7 W "INCREMENTAL ATRIAL PACING"
 D N:$X>9 Q:'DN  W ?9 S DIP(1)=$S($D(^MCAR(691.9,D0,2)):^(2),1:"") S X="MAXIMUM 1:1 CONDUCTION: "_$P(DIP(1),U,1) K DIP K:DN Y W X
 D N:$X>9 Q:'DN  W ?9 S DIP(1)=$S($D(^MCAR(691.9,D0,2)):^(2),1:"") S X="WENCKE CYCLE LENGTH: "_$P(DIP(1),U,2) K DIP K:DN Y W X
 D N:$X>9 Q:'DN  W ?9 X DXS(3,9) K DIP K:DN Y W X
 D T Q:'DN  D N D N:$X>7 Q:'DN  W ?7 W "TACHYCARDIA WINDOW: "
 S X=$G(^MCAR(691.9,D0,2)) S DIWL=30,DIWR=77 S Y=$P(X,U,4) S X=Y D ^DIWP
 D 0^DIWW
 D ^DIWW
 D N:$X>19 Q:'DN  W ?19 S DIP(1)=$S($D(^MCAR(691.9,D0,2)):^(2),1:"") S X="RATE: "_$P(DIP(1),U,5) K DIP K:DN Y W X
 D N:$X>19 Q:'DN  W ?19 W "MORPHOLOGY: "
 S X=$G(^MCAR(691.9,D0,2)) S Y=$P(X,U,6) W:Y]"" $S($D(DXS(8,Y)):DXS(8,Y),1:Y)
 S I(1)=3,J(1)=691.921 F D1=0:0 Q:$O(^MCAR(691.9,D0,3,D1))'>0  X:$D(DSC(691.921)) DSC(691.921) S D1=$O(^(D1)) Q:D1'>0  D:$X>33 T Q:'DN  D B1
 G B1R
B1 ;
 D T Q:'DN  D N D N:$X>7 Q:'DN  W ?7 X DXS(4,9) K DIP K:DN Y W X
 D N:$X>9 Q:'DN  W ?9 W "CONDUCTION: "
 S X=$G(^MCAR(691.9,D0,3,D1,0)) S Y=$P(X,U,2) W:Y]"" $S($D(DXS(9,Y)):DXS(9,Y),1:Y)
 D N:$X>44 Q:'DN  W ?44 W "ARRHYTHMIA: "
 S I(2)=1,J(2)=691.9212 F D2=0:0 Q:$O(^MCAR(691.9,D0,3,D1,1,D2))'>0  X:$D(DSC(691.9212)) DSC(691.9212) S D2=$O(^(D2)) Q:D2'>0  D:$X>58 T Q:'DN  D A2
 G A2R
A2 ;
 S X=$G(^MCAR(691.9,D0,3,D1,1,D2,0)) D N:$X>56 Q:'DN  W ?56 S Y=$P(X,U,1) W:Y]"" $S($D(DXS(10,Y)):DXS(10,Y),1:Y)
 Q
A2R ;
 D N:$X>9 Q:'DN  W ?9 W "SHORTEST R-R A FIB:"
 S X=$G(^MCAR(691.9,D0,3,D1,2)) S Y=$P(X,U,1) W:Y]"" $J(Y,4,0)
 D N:$X>44 Q:'DN  W ?44 W "SHORTEST R-R POST ISPUREL:"
 S Y=$P(X,U,2) W:Y]"" $J(Y,4,0)
 D N:$X>9 Q:'DN  W ?9 W "LOCATION OF TRACT: "
 W ?30 S Y=$P(X,U,3) W:Y]"" $S($D(DXS(11,Y)):DXS(11,Y),1:Y)
 D N:$X>9 Q:'DN  W ?9 S DIP(1)=$S($D(^MCAR(691.9,D0,3,D1,2)):^(2),1:"") S X="V-A TIME: "_$P(DIP(1),U,4) K DIP K:DN Y W X
 D N:$X>9 Q:'DN  W ?9 W "ANTEGRADE ERP"
 D N:$X>44 Q:'DN  W ?44 W "RETROGRADE ERP"
 D N:$X>11 Q:'DN  W ?11 S DIP(1)=$S($D(^MCAR(691.9,D0,3,D1,2)):^(2),1:"") S X="BYPASS TRACT: "_$P(DIP(1),U,5) K DIP K:DN Y W X
 D N:$X>46 Q:'DN  W ?46 S DIP(1)=$S($D(^MCAR(691.9,D0,3,D1,2)):^(2),1:"") S X="BYPASS TRACT: "_$P(DIP(1),U,7) K DIP K:DN Y W X
 D N:$X>11 Q:'DN  W ?11 S DIP(1)=$S($D(^MCAR(691.9,D0,3,D1,2)):^(2),1:"") S X="BYPASS ISUPREL: "_$P(DIP(1),U,6) K DIP K:DN Y W X
 D N:$X>46 Q:'DN  W ?46 S DIP(1)=$S($D(^MCAR(691.9,D0,3,D1,2)):^(2),1:"") S X="BYPASS ISUPREL: "_$P(DIP(1),U,8) K DIP K:DN Y W X
 Q
B1R ;
 S I(1)=7,J(1)=691.93 F D1=0:0 Q:$O(^MCAR(691.9,D0,7,D1))'>0  X:$D(DSC(691.93)) DSC(691.93) S D1=$O(^(D1)) Q:D1'>0  D:$X>57 T Q:'DN  D C1
 G C1R
C1 ;
 D T Q:'DN  D N D N:$X>27 Q:'DN  W ?27 X DXS(5,9) K DIP K:DN Y W X
 D N:$X>7 Q:'DN  W ?7 X DXS(6,9.2) S X=X_Y K DIP K:DN Y W X
 D N:$X>9 Q:'DN  W ?9 S DIP(1)=$S($D(^MCAR(691.9,D0,7,D1,0)):^(0),1:"") S X="ATRIAL CYCLE LENGTH (MSEC): "_$P(DIP(1),U,3) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 S DIP(1)=$S($D(^MCAR(691.9,D0,7,D1,0)):^(0),1:"") S X="VENT CYCLE LENGTH (MSEC): "_$P(DIP(1),U,4) K DIP K:DN Y W X
 D N:$X>9 Q:'DN  W ?9 S DIP(1)=$S($D(^MCAR(691.9,D0,7,D1,0)):^(0),1:"") S X="QRS DURATION: "_$P(DIP(1),U,5) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 S DIP(1)=$S($D(^MCAR(691.9,D0,7,D1,0)):^(0),1:"") S X="QRS AXIS: "_$P(DIP(1),U,6) K DIP K:DN Y W X
 D N:$X>9 Q:'DN  W ?9 S DIP(1)=$S($D(^MCAR(691.9,D0,7,D1,0)):^(0),1:"") S X="QT: "_$P(DIP(1),U,8) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 X $P(^DD(691.93,8,0),U,5,99) S DIP(2)=X S X="QTC: ",DIP(1)=X S X=DIP(2),DIP(3)=X S X=3,DIP(4)=X S X=0,X=$J(DIP(3),DIP(4),X) S Y=X,X=DIP(1),X=X_Y K DIP K:DN Y W X
 D N:$X>9 Q:'DN  W ?9 W "RYHTHM: "
 S DICMX="D L^DIWP" S DIWL=20,DIWR=78 X DXS(7,9.4) S X=$S('$D(^MCAR(693.3,+$P(DIP(103),U,1),0)):"",1:$P(^(0),U,1)) S D0=I(0,0) S D1=I(1,0) S D2=I(2,0) K DIP K:DN Y
 D 0^DIWW
 D ^DIWW
 D N:$X>9 Q:'DN  W ?9 W "INTERPRETATION: "
 S X=$G(^MCAR(691.9,D0,7,D1,0)) D N:$X>27 Q:'DN  S DIWL=28,DIWR=77 S Y=$P(X,U,10) S X=Y D ^DIWP
 D 0^DIWW
 D ^DIWW
 Q
C1R ;
 D T Q:'DN  D N D N:$X>7 Q:'DN  W ?7 W "COMMENTS: "
 S I(1)=5,J(1)=691.923 F D1=0:0 Q:$O(^MCAR(691.9,D0,5,D1))'>0  S D1=$O(^(D1)) D:$X>19 T Q:'DN  D D1
 G D1R
D1 ;
 S X=$G(^MCAR(691.9,D0,5,D1,0)) S DIWL=20,DIWR=79 D ^DIWP
 Q
D1R ;
 D 0^DIWW
 D ^DIWW
 S I(1)=4,J(1)=691.922 F D1=0:0 Q:$O(^MCAR(691.9,D0,4,D1))'>0  X:$D(DSC(691.922)) DSC(691.922) S D1=$O(^(D1)) Q:D1'>0  D:$X>81 NX^DIWW D E1
 G E1R
E1 ;
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "DISCHARGE DATE: "
 S X=$G(^MCAR(691.9,D0,4,D1,0)) W ?22 S Y=$P(X,U,1) D DT
 D N:$X>7 Q:'DN  W ?7 W "MEDICATIONS ON DISCHARGE: "
 W ?0,$E($P(X,U,2),1,40)
 Q
E1R ;
 K Y K DIWF
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
