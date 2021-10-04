ONCCPC5	;HIRMFO/GWB - PCE Study of Colorectal Cancer - Table V;3/28/97
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	K TABLE,HTABLE S OUT=""
	S TABLE("WERE OTHER REFERRALS MADE")="WORM"
	S HTABLE(1)="WERE OTHER REFERRALS MADE"
	S CHOICES=1
	W @IOF D HEAD^ONCCPC0
	W !?27,"TABLE V - QUALITY OF LIFE"
	W !?27,"-------------------------"
WORM	W !,"WERE OTHER REFERRALS MADE:",!
	S DIE="^ONCO(165.5,",DA=ONCONUM
	S DR="796  NUTRITIONAL CONSULTATION" D ^DIE G:$D(Y) JUMP
	S DR="797  OCCUPATIONAL THERAPY...." D ^DIE G:$D(Y) JUMP
	S DR="563  PHYSICAL THERAPY........" D ^DIE G:$D(Y) JUMP
	S DR="798  OSTOMY CONSULTATION....." D ^DIE G:$D(Y) JUMP
	S DR="799  PSYCHOSOCIAL............" D ^DIE G:$D(Y) JUMP
	W ! K DIR S DIR(0)="E" D ^DIR Q:(Y=0)!(Y="")
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
	K DA,DIE,DIR,DIROUT,DIRUT,DR,DTOUT,DUOUT,X,XX,Y
	Q