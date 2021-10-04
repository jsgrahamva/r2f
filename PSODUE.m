PSODUE ;BHAM ISC/JRR - DUE BUILD A QUESTIONNAIRE ; 11/17/92 10:20
 ;;7.0;OUTPATIENT PHARMACY;**268**;DEC 1997;Build 9
 Q
BUILD ;Build/Edit a DUE Survey Questionnaire
B2 S DIC="^PS(50.073,",DIC(0)="AEQLM",DLAYGO=50.073 D ^DIC K DIC G:Y<1 EXITB
 S (DA,PSODUEL)=+Y,DIE=50.073,DR="[PSOD DUE BUILD QUESTIONNAIRE]" L +^PS(50.073,PSODUEL):$S(+$G(^DD("DILOCKTM"))>0:+^DD("DILOCKTM"),1:3) I '$T W !,"Entry is being edited by another user. Try Later!",! G B2
 D ^DIE L -^PS(50.073,PSODUEL) K PSODUEL,PSRC
 G B2
EXITB K DIC,DIE,DA,DR,PSLOCK,PSQTYP,PSQUEST,X,Y
 QUIT
 ;
PRINT ;Batch print a Due Questionnaire
 S DIC="^PS(50.073,",DIC(0)="QEAM" D ^DIC K DIC
 G:Y=-1 EXITP
 S PSOQAIR=+Y
 S DIR(0)="NO^1:999",DIR("A")="NUMBER OF COPIES",DIR("?")="Enter the number of copies of this DUE Questionnaire to print" D ^DIR K DIR
 G:Y<1 EXITP
 S PSQCNT=Y
 K %ZIS,ZTDTH,ZTSAVE,IOP,ZTSK S PSOION=ION,%ZIS="QM" D ^%ZIS K %ZIS I POP S IOP=PSOION D ^%ZIS K IOP,PSOION G EXITP
 K PSOION I $D(IO("Q")) S ZTDESC="Print Due Questionnaires",ZTRTN="START^PSODUE" S ZTSAVE("PSQCNT")="",ZTSAVE("PSOQAIR")="",ZTSAVE("ZTREQ")="@" D ^%ZTLOAD W:$D(ZTSK) "queued..." K ZTSK,IO("Q") G EXITP
 ;
START ;Start here when print is queued
 U IO
 F PSI=1:1:PSQCNT S PSOQ=PSOQAIR D OUT
EXITP D ^%ZISC
 K DUOUT,DTOUT,PSDASH,PSQ,PSQA,PSQCNT,PSIGN,PSOQAIR,PSOQN,PSOQM,PSTXT,PSWRAP,PSQNUM
 K POP,TAB,DIRUT,DIROUT,PSLOCK,PSQUEST,PSQTYP,PSOQL,PSMARG,PSI,X,Y
 QUIT
 ;
OUT S PSOQM=$P(^PS(50.073,PSOQ,0),"^")
 W @IOF,?(IOM\2-($L(PSOQM)\2)-4),"*** ",PSOQM," ***",!
 W !,"DRUG: __________________________"
 S X="RX #: ______________" D X
 S X="PROVIDER: ______________________" D X
 S X="PATIENT: _______________________" D X
 S X="SECTION: _______________________" D X
 S X="SEQ. # __________________" D X
 D QOUT^PSODACT
 K PSDASH,PSOQM,PSOQ
 Q
X W:(IOM-$X)<($L(X)+4) !! S TAB=$S($X:$X+3,1:0) W ?(TAB),X
