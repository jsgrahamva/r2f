ONCSPC5	;HIRMFO/GWB - PCE Study of Soft Tissue Sarcoma - Table V;7/22/96
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	K TABLE,HTABLE S OUT=""
	S TABLE("DATE OF FIRST RECURRENCE")="DOFR"
	S TABLE("TYPE OF FIRST RECURRENCE")="TOFR"
	S TABLE("OTHER TYPE OF FIRST RECURRENCE")="OTOFR"
	S TABLE("DISTANT SITE(S) OF RECURRENCE")="DSOFR"
	S TABLE("SUBSEQUENT TREATMENT FOR RECURRENCE OR PROGRESSION")="STFROP"
	S HTABLE(1)="DATE OF FIRST RECURRENCE"
	S HTABLE(2)="TYPE OF FIRST RECURRENCE"
	S HTABLE(3)="OTHER TYPE OF FIRST RECURRENCE"
	S HTABLE(4)="DISTANT SITE(S) OF RECURRENCE"
	S HTABLE(5)="SUBSEQUENT TREATMENT FOR RECURRENCE OR PROGRESSION"
	S CHOICES=5
	W @IOF D HEAD^ONCSPC0 W !?15,"TABLE V - FIRST RECURRENCE AND SUBSEQUENT TREATMENT",!
DOFR	S DIE="^ONCO(165.5,",DA=ONCONUM
	S DR="70DATE OF FIRST RECURRENCE......" D ^DIE G:$D(Y) JUMP
TOFR	S DIE="^ONCO(165.5,",DA=ONCONUM
	S DR="71TYPE OF FIRST RECURRENCE......" D ^DIE G:$D(Y) JUMP
OTOFR	S DIE="^ONCO(165.5,",DA=ONCONUM
	S DR="71.4OTHER TYPE OF FIRST RECURRENCE" D ^DIE G:$D(Y) JUMP
DSOFR	S DIE="^ONCO(165.5,",DA=ONCONUM
	W !!,"DISTANT SITE(S) OF RECURRENCE:",!
	S DR="71.1  RECURRENCE SITE 1..........." D ^DIE G:$D(Y) JUMP
	I X=0 D  G STFROP
	.S $P(^ONCO(165.5,ONCONUM,5),U,4)=0
	.W !,"  RECURRENCE SITE 2...........: None"
	.S $P(^ONCO(165.5,ONCONUM,5),U,5)=0
	.W !,"  RECURRENCE SITE 3...........: None"
	S DR="71.2  RECURRENCE SITE 2..........." D ^DIE G:$D(Y) JUMP
	I X=0 D  G STFROP
	.S $P(^ONCO(165.5,ONCONUM,5),U,5)=0
	.W !,"  RECURRENCE SITE 3...........: None"
	S DR="71.3  RECURRENCE SITE 3..........." D ^DIE G:$D(Y) JUMP
STFROP	W !!,"SUBSEQUENT TREATMENT FOR RECURRENCE OR PROGRESSION:"
	I '$D(^ONCO(165.5,ONCONUM,4,0)) W !!,"NO SUBSEQUENT TREATMENT" G DIR
	I $O(^ONCO(165.5,ONCONUM,4,0))="" W !!,"NO SUBSEQUENT TREATMENT" G DIR
	I $D(^ONCO(165.5,ONCONUM,4,0)) S SCTIEN=0 F CRSE=1:1 S SCTIEN=$O(^ONCO(165.5,ONCONUM,4,SCTIEN)) Q:(SCTIEN'>0)!(CRSE=4)!(OUT="Y")  D SS Q:$D(Y)
	G:OUT="Y" EXIT G DIR
SS	S ID=$P(^ONCO(165.5,ONCONUM,4,SCTIEN,0),U,1)
	S Y=ID D DATEOT^ONCOPCE S ID=Y
	S COURSE=$S(CRSE=1:"SECOND",CRSE=2:"THIRD",CRSE=3:"FOURTH",1:"")
	W !!,"  ",COURSE," COURSE:",!
	W !,"  DATE...........: ",ID
	S DIE="^ONCO(165.5,"_ONCONUM_",4,",DA(1)=ONCONUM,DA=SCTIEN
	S DR=".04  SURGERY........" D ^DIE G:$D(Y) JUMP
	S DR=".05  RADIATION......" D ^DIE G:$D(Y) JUMP
	S DR=".06  CHEMOTHERAPY..." D ^DIE G:$D(Y) JUMP
	S DR=".07  HORMONE THERAPY" D ^DIE G:$D(Y) JUMP
	S DR=".09  OTHER.........." D ^DIE G:$D(Y) JUMP
	Q
DIR	W ! K DIR S DIR(0)="E" D ^DIR
	G EXIT
JUMP	;Jump to prompts
	S XX="" R !!,"GO TO: ",X:DTIME I (X="")!(X[U) S OUT="Y" G EXIT
	I X["?" D  G JUMP
	.W !,"CHOOSE FROM:" F I=1:1:CHOICES W !,?5,HTABLE(I)
	I '$D(TABLE(X)) S XX=X,X=$O(TABLE(X)) I ($P(X,XX,1)'="")!(X="") W *7,"??" D  G JUMP
	.W !,"CHOOSE FROM:" F I=1:1:CHOICES W !,?5,HTABLE(I)
	S X=TABLE(X)
	G @X
EXIT	K CHOICES,HTABLE,TABLE
	K ID
	K DA,DIE,DIR,DIROUT,DIRUT,DR,DTOUT,DUOUT,X,XX,Y
	Q
