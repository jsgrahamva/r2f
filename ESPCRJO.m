ESPCRJO ;DALISC/SED - CREATE DAILY OPERATIONS JOURNAL ;3/99
 ;;1.0;POLICE & SECURITY;**27,37,39**;Mar 31, 1994
EN ;
 D DT^DICRW
FAC K DIC
 S DIC("A")="Select Facility: ",DIC(0)="QAEMZ",DIC="^DG(40.8,"
 D ^DIC
 G:$D(DTOUT)!($D(DUOUT))!(+Y'>0) EXIT
 K DIC
 S:+Y>0 DIC("S")="I $P(^(0),U,2)="_+Y
 S ESPFAC=+Y
JOU S DIC(0)="QAEMZL",DIC="^ESP(916,",DLAYGO=916
 D ^DIC
 G:$D(DTOUT)!($D(DUOUT))!(X="") FAC
 I X?4N S X="" W !!,$C(7),"*********Must key a full date, (Month, Day, Year) ***********",! G JOU
 I Y<0 W !,$C(7),"DATE not found.  Please try again." G JOU
 K DIC
 S DA=+Y
 S DR="[ESP CREATE JOURNAL]",DIE="^ESP(916,"
 D ^DIE
EXIT K DIC,DIE,X,Y,DA
 Q
SET(NEWKEY,TYPE) ;PULL BADGE/RANK FOR SHIFT OFFICERS
 S HESPN=DA,DIC="^VA(200,",DA=NEWKEY,DR="910.1;910.2",DIQ(0)="E",DIQ="POLINF" D EN^DIQ1
 S:TYPE=1 SX=POLINF(200,DA,910.1,"E") S:TYPE=2 SX=POLINF(200,DA,910.2,"E")
 S DA=HESPN
 K DIC,DIQ,POLINF,HESPN
 Q SX
