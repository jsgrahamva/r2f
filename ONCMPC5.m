ONCMPC5	;HINES CIOFO/GWB - 199 Melanoma Study - Table VI ; 01/27/99
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	K TABLE,HTABLE
	S TABLE("77. DATE OF FIRST RECURRENCE")="DOFR"
	S TABLE("78. TYPE OF FIRST RECURRENCE")="TOFR"
	S TABLE("79. OTHER TYPE OF FIRST RECURRENCE")="OTOFR"
	S HTABLE(1)="77. TYPE OF FIRST RECURRENCE"
	S HTABLE(2)="78. DATE OF FIRST RECURRENCE"
	S HTABLE(3)="79. OTHER TYPE OF FIRST RECURRENCE"
	S CHOICES=3
	W @IOF D HEAD^ONCMPC0
	W !," TABLE V - FIRST RECURRENCE"
	W !," --------------------------"
	S DIC="^ONCO(165.5,",DR="70",DA=ONCONUM,DIQ="ONCO" D EN^DIQ1
	S DIE="^ONCO(165.5,",DA=ONCONUM
DOFR	S DR="70 77. DATE OF FIRST RECURRENCE......" D ^DIE G:$D(Y) JUMP
TOFR	S DR="71 78. TYPE OF FIRST RECURRENCE......" D ^DIE G:$D(Y) JUMP
OTOFR	S DR="71.4 79. OTHER TYPE OF 1ST RECURRENCE.." D ^DIE G:$D(Y) JUMP
PRTC	W ! K DIR S DIR(0)="E" D ^DIR S:$D(DIRUT) OUT="Y"
	G EXIT
JUMP	;Jump to prompts
	S XX="" R !!," GO TO ITEM NUMBER: ",X:DTIME I (X="")!(X[U) S OUT="Y" G EXIT
	I X["?" D  G JUMP
	.W !," CHOOSE FROM:" F I=1:1:CHOICES W !,?5,HTABLE(I)
	I '$D(TABLE(X)) S:X?1.2N X=X_"." S XX=X,X=$O(TABLE(X)) I ($P(X,XX,1)'="")!(X="") W *7,"??" D  G JUMP
	.W !," CHOOSE FROM:" F I=1:1:CHOICES W !,?5,HTABLE(I)
	S X=TABLE(X)
	G @X
EXIT	K CHOICES,HTABLE,TABLE
	K PIECE
	K DA,DIE,DIR,DIROUT,DIRUT,DR,DTOUT,DUOUT,X,XX,Y
	Q
