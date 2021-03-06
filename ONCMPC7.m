ONCMPC7	;HINES CIOFO/GWB - 1999 Melanoma Study - Table VII ;1/27/99
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	K TABLE,HTABLE
	S TABLE("83. COMPLETED BY")="CB"
	S TABLE("84. REVIEWED BY CANCER COMMITTEE")="RBCC"
	S HTABLE(1)="83. COMPLETED BY"
	S HTABLE(2)="84. REVIEWED BY CANCER COMMITTEE"
	S CHOICES=2
	W @IOF D HEAD^ONCMPC0
	W !," TABLE VII - OTHER INFORMATION"
	W !," -----------------------------"
CB	S DIE="^ONCO(165.5,",DA=ONCONUM
	S DR="81 83. COMPLETED BY.................." D ^DIE G:$D(Y) JUMP
RBCC	S DIE="^ONCO(165.5,",DA=ONCONUM
	S DR="82 84. REVIEWED BY CANCER COMMITTEE.." D ^DIE G:$D(Y) JUMP
	W ! K DIR S DIR(0)="E" D ^DIR S:$D(DIRUT) OUT="Y"
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
	K DA,DIE,DIR,DIROUT,DIRUT,DR,DTOUT,DUOUT,X,XX,Y
	Q
