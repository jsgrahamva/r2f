ONCMPC6	;HINES CIOFO/GWB - 1999 Melanoma Study - Table VI ;1/27/99
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	K TABLE,HTABLE
	S TABLE("80. DATE OF LAST CONTACT OR DEATH")="DOLCOD"
	S TABLE("81. VITAL STATUS")="VS"
	S TABLE("82. CANCER STATUS")="CS"
	S HTABLE(1)="80. DATE OF LAST CONTACT OR DEATH"
	S HTABLE(2)="81. VITAL STATUS"
	S HTABLE(3)="82. CANCER STATUS"
	S CHOICES=3
	W @IOF D HEAD^ONCMPC0
	W !," TABLE VI - STATUS AT LAST CONTACT"
	W !," ---------------------------------"
DOLCOD	S DLC="" I $D(^ONCO(160,ONCOPA,"F","B")) S DLC=$O(^ONCO(160,ONCOPA,"F","B",""),-1)
	I DLC'="" S Y=DLC D DATEOT^ONCOPCE S DLC=Y
	W !," 80. DATE OF LAST CONTACT OR DEATH.: ",DLC
VS	S DIE="^ONCO(160,",DA=ONCONUM
	S DR="15 81. VITAL STATUS.................." D ^DIE G:$D(Y) JUMP
	I X=1 S $P(^ONCO(165.5,ONCONUM,7),U,14)=0
CS	S CS="" I $D(^ONCO(165.5,ONCONUM,"TS","AA")) D
	.S CSDAT=$O(^ONCO(165.5,ONCONUM,"TS","AA",""))
	.S CSIEN=$O(^ONCO(165.5,ONCONUM,"TS","AA",CSDAT,""))
	.S CSPNT=$P(^ONCO(165.5,ONCONUM,"TS",CSIEN,0),U,2)
	.S:CSPNT'="" CS=$P(^ONCO(164.42,CSPNT,0),U,1)
	W !," 82. CANCER STATUS.................: ",CS
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
	K CS,CSDAT,CSIEN,CSPNT,DLC
	K DA,DIE,DIR,DIROUT,DIRUT,DR,DTOUT,DUOUT,X,XX,Y
	Q
