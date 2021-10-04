LRRS12 ;SLC/DCM,BA/DALOI/FHS/DRH - INTERIM REPORT BY LOCATION (MANUAL QUEUE) ;2/19/91  11:39
 ;;5.2;LAB SERVICE;**1,283**;Sep 27, 1994
 ;from option LRRS
BEGIN ;
 K LRLLOC
 S LRPRTPG=0
 D:'$D(LRPARAM) ^LRPARAM
 G:$G(LREND) ^LRRK Q:$G(LREND)
 S:'$D(LRSINGLE) LRSINGLE=0
ASKPG I 'LRPRTPG D
 .S DIR(0)="Y",DIR("A")="Print address page",DIR("B")="NO"
 .D ^DIR K DIR
 .I Y S LRPRTPG=1
 D LOC
END ;
 D ^LRRK
 K LRLOCXY,LRX1,LRY1,OK,LRX13
 Q
LOC ;
 K LRLLOC
 S (LREND,LRSTOP)=0
 S (LRONETST,LRONESPC,LRLLOC,LRFLOC)=""
 S LRELOC="ZZZZZZZZ"
 S LRLAB=$S($D(LRLABKY):1,1:0)
 K DTOUT,DUOUT
 S LREND=0
 D DTRANG Q:$G(LREND)
 D CHKLOC Q:$G(LREND)
 Q
QUIT ;
 S LREND=1
 Q
DTRANG ;
 K LRX13
 S LREDT="T-7"
 D ^LRWU3
 S:($D(DUOUT))!($D(DTOUT)) LREND=1 Q:LREND
 ;I LRSDT=LREDT S X1=LREDT,X2=1 D C^%DTC S LREDT=X
 S LRSDT=LRSDT-.5
 I LREDT=LRSDT S LRX13=1
 S LRSWTCH=LRSDT,LRSDT=LREDT,LREDT=LRSWTCH K LRSWTCH
 ;I LRSDT=LREDT S X1=LREDT,X2=1 D C^%DTC S LREDT=X
 S LRODT=LRSDT
 S LRDT=LRODT,LRDTXX=LRODT
 S LRBDT=LRODT
 S LRSD=LRODT,LRLAST=LREDT
 ;S X1=LRLAST,X2=1 D C^%DTC S LRLAST=X
DTSINGL ;
 Q
 ;EDITED 1-18-94
CHKLOC ;
 K LRNGCHK
 D CHOOSE
 Q:$G(LREND)
 D @$S(LRLOC="S":"SELECT",LRLOC="R":"RANGE",1:"QUE")
 Q
CHOOSE ;
 N Y
 S LREND=0
 K DIR
 S DIR("A")="Please select one of the following"
 S DIR(0)="S^S:Selected Locations;R:A Range of locations;A:All locations"
 S DIR("?")="Enter the letter that cooresponds to what you want."
 D ^DIR
 S:($D(DUOUT))!($D(DTOUT)) LREND=1 Q:LREND
 S LRLOC=Y
 Q
QUER ;
 ;D QUE
 Q
NODATA ;
 S LRNOD=1
 W !,"No Reports for ",$$DTF^LRAFUNC1(LRODT),! Q
 Q
DIS ;
 N I
 F I=1:1:LRCNT W !,I,?4,LRLOCX(I) S I=I+1 Q:I>LRCNT!($G(LREND))  D
 .  W:$D(LRLOCX(I)) ?39," ",I,?44,LRLOCX(I)
 W ! Q
 Q
 Q
RANGE ;
 S (DTOUT,DUOUT)=""
 K LRLLOC1,LRLLOC
 S LRNGCHK=1
 N Y
 K DIC
 S DIC=44,DIC(0)="AEMQZ"
 S DIC("A")="Select Starting Location: "
 D ^DIC
 I $D(DUOUT)!($D(DTOUT))!(Y=-1) S LREND=1 Q:LREND
 S:Y'=-1 LRY7=$L($P(Y(0),U))
 I $D(LRY7) S LRY8=$E($P(Y(0),U),LRY7,LRY7) D
 .  S LRY8=$A(LRY8)
 .  S LRY8=$C(LRY8-1)
 .  S LRY7=LRY7-1
 .  S LRFLOC=$E($P(Y,"^",2),1,LRY7)_LRY8
 I '$D(LRFLOC) G RANGE
 S DIC("A")="Select Ending Location: "
 S (DTOUT,DUOUT)=""
ENDING D ^DIC
 I $D(DUOUT)!($D(DTOUT)) S LREND=1 Q:LREND
 I Y=-1 G END
 S:Y'=-1 LRELOC=$P(Y(0),U)_"Z"
 K LRY7,LRY8,LRLOCXY
 I +LRFLOC=0&(+LRELOC=0)&($A($E(LRFLOC,1,1))>$A($E(LRELOC,1,1))) D
 .  S LX8=1 D HELP QUIT
 I +LRFLOC>0&(+LRELOC>0)&(LRFLOC>LRELOC) S LX9=1 D HELP QUIT
 S LRX1=LRFLOC
 F  S LRX1=$O(^SC("B",LRX1)) Q:LRX1=""!(LRX1]LRELOC)  D
 .  S LRY1=$O(^SC("B",LRX1,"0")) S LRY1=$P(^SC(LRY1,0),U,2) Q:LRY1=""
 .  S LRLLOC(LRY1)=LRY1
 S OK=0,LRODT=LRDTXX-.5
 D QUE
 QUIT
SELECT ;
 K ^TMP("LR",$J)
 S LRSCRN=24
 N LRNOD,LRTAC
 S LRLLOC=""
 S LRDT=LRODT
 D READ
 S LRODT=LRDT D QUE
 Q
READ ;
 S OK=0
 K DIC
 S DIC=44,DIC(0)="QAEZNM"
 S DIC("S")="I $L($P(^(0),U,2))"
 S X1=LRODT,X2=-1 D C^%DTC S LRODT=X
 D ^DIC
 Q:Y<0
 S Y1=$P(Y(0),U,2)
 S LRLLOC(Y1)=Y1
 K DIC
 G READ
 Q
HELP ;
 W !!,"I cannot search a range of locations that are not in"
 W " sequential order"
 I $D(LX8) W !,"Please enter the starting and ending locations in" D
 .  W " ALPHABETICAL order" K LX8
 I $D(LX9) W !,"Please enter the starting and ending locations in" D
 .  W " NUMERICAL order" K LX9
 W !
 G RANGE
 Q
QUE S %ZIS="MQ",ZTSAVE("^TMP(""LR"",$J,")="",ZTRTN="DQ^LRRS13" D IO^LRWU
 Q
