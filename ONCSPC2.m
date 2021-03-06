ONCSPC2	;HIRMFO/GWB - PCE Study of Soft Tissue Sarcoma Table II;6/19/96
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	K TABLE,HTABLE
	S TABLE("CLASS OF CASE")="COC"
	S TABLE("DIAGNOSTIC WORKUP")="DW"
	S TABLE("HISTOLOGIC WORKUP")="HW"
	S TABLE("BIOPSIES")="B"
	S TABLE("OUTSIDE CONFIRMATION OF BIOPSY")="OCOB"
	S TABLE("DATE OF INITIAL DIAGNOSIS")="DOID"
	S TABLE("PRIMARY SITE")="PS"
	S TABLE("SUBSITE")="S"
	S TABLE("HISTOLOGY/BEHAVIOR CODE")="H"
	S TABLE("GRADE")="G"
	S TABLE("ADDNL GRADE CODING SYSTEM")="AGCS"
	S TABLE("VALUE OF ADDNL CODING SYSTEM")="VOACS"
	S TABLE("DIAGNOSTIC CONFIRMATION")="DC"
	S HTABLE(1)="CLASS OF CASE"
	S HTABLE(2)="DIAGNOSTIC WORKUP"
	S HTABLE(3)="HISTOLOGIC WORKUP"
	S HTABLE(4)="BIOPSIES"
	S HTABLE(5)="OUTSIDE CONFIRMATION OF BIOPSY"
	S HTABLE(6)="DATE OF INITIAL DIAGNOSIS"
	S HTABLE(7)="PRIMARY SITE"
	S HTABLE(8)="SUBSITE"
	S HTABLE(9)="HISTOLOGY/BEHAVIOR CODE"
	S HTABLE(10)="GRADE"
	S HTABLE(11)="ADDNL GRADE CODING SYSTEM"
	S HTABLE(12)="VALUE OF ADDNL CODING SYSTEM"
	S HTABLE(13)="DIAGNOSTIC CONFIRMATION"
	S CHOICES=13
	K DIQ S DIC="^ONCO(165.5,",DR=".04;22;24;26",DA=ONCONUM,DIQ="ONC"
	D EN^DIQ1
	S Y=$P(^ONCO(165.5,ONCONUM,0),U,16) D DATEOT^ONCOPCE S DOID=Y
	W @IOF D HEAD^ONCSPC0
	W !?24,"TABLE II- INITIAL DIAGNOSIS/CANCER IDENTIFICATION",!
	S DIE="^ONCO(165.5,",DA=ONCONUM
COC	W !,"CLASS OF CLASS................:",ONC(165.5,ONCONUM,.04)
DW	W !!,"DIAGNOSTIC WORKUP:",!
	S DR="502  ANGIOGRAM OF PRIMARY........" D ^DIE G:$D(Y) JUMP
	S DR="503  BONE MARROW ASPIRATE/BIOPSY." D ^DIE G:$D(Y) JUMP
	S DR="504  BONE SCAN..................." D ^DIE G:$D(Y) JUMP
	S DR="505  CHEST X-RAY................." D ^DIE G:$D(Y) JUMP
	S DR="506  CT SCAN OF CHEST............" D ^DIE G:$D(Y) JUMP
	S DR="507  CT SCAN OF PRIMARY.........." D ^DIE G:$D(Y) JUMP
	S DR="508  LIVER FUNCTION STUDIES......" D ^DIE G:$D(Y) JUMP
	S DR="509  LYMPHANGIOGRAM.............." D ^DIE G:$D(Y) JUMP
	S DR="510  MRI OF PRIMARY.............." D ^DIE G:$D(Y) JUMP
	S DR="511  MRI OF OTHER................" D ^DIE G:$D(Y) JUMP
	S DR="512  SKELETAL X-RAY.............." D ^DIE G:$D(Y) JUMP
	S DR="513  SONOGRAM...................." D ^DIE G:$D(Y) JUMP
HW	W !!,"HISTOLOGIC WORKUP:",!
	S DR="514  CYTOGENETICS................" D ^DIE G:$D(Y) JUMP
	S DR="515  ELECTRON MICROSCOPY........." D ^DIE G:$D(Y) JUMP
	S DR="329  FLOW CYTOMETRY.............." D ^DIE G:$D(Y) JUMP
	S DR="516  IMMUNOHISTOCHEMISTRY........" D ^DIE G:$D(Y) JUMP
	S DR="517  IN SITU HYBRIDIZATION......." D ^DIE G:$D(Y) JUMP
B	W !!,"BIOPSIES:",!
	W !,"  TYPE                          HISTOLOGY/BEHAVIOR/GRADE",!
	S DR="528  FINE NEEDLE ASPIRATION......" D ^DIE G:$D(Y) JUMP
	S DR="529  CORE NEEDLE BIOPSY.........." D ^DIE G:$D(Y) JUMP
	S DR="530  INCISIONAL BIOPSY..........." D ^DIE G:$D(Y) JUMP
	S DR="531  EXCISIONAL BIOPSY..........." D ^DIE G:$D(Y) JUMP
	W !
OCOB	S DR="518OUTSIDE CONFIRMATION OF BIOPSY" D ^DIE G:$D(Y) JUMP
DOID	W !,"DATE OF INITIAL DIAGNOSIS.....: ",DOID
PS	W !,"PRIMARY SITE..................: ",TOPCOD
S	S DR="519SUBSITE" D ^DIE G:$D(Y) JUMP
H	W !,"HISTOLOGY/BEHAVIOR CODE.......: ",ONC(165.5,ONCONUM,22)
G	S DR="24GRADE........................." D ^DIE G:$D(Y) JUMP
AGCS	S DR="520ADDNL GRADE CODING SYSTEM....." D ^DIE G:$D(Y) JUMP
VOACS	S DR="521VALUE OF ADDNL CODING SYSTEM.." D ^DIE G:$D(Y) JUMP
DC	S DR="26DIAGNOSTIC CONFIRMATION......." D ^DIE G:$D(Y) JUMP
	W ! K DIR S DIR(0)="E" D ^DIR
	G EXIT
JUMP	;Jump to prompts
	S XX="" R !!,"GO TO: ",X:DTIME I (X="")!(X[U) S OUT="Y" G EXIT
	I X["?" D  G JUMP
	.W !,"CHOOSE FROM:" F I=1:1:CHOICES W !,?5,HTABLE(I)
	I '$D(TABLE(X)) S XX=X,X=$O(TABLE(X)) I ($P(X,XX,1)'="")!(X="") W *7,"??" D  G JUMP
	.W !,"CHOOSE FROM:" F I=1:1:CHOICES W !,?5,HTABLE(I)
	S X=TABLE(X)
	G @X
EXIT	K HTABLE,TABLE,CHOICES
	K DOID,HST,HSTCD,HSTNAM,PRINODE0,PRINODE2,TOPOG,TOPCD,SITE
	K DA,DIE,DIR,DIROUT,DIRUT,DR,DTOUT,DUOUT,X,XX,Y
	Q
