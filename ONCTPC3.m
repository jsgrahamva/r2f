ONCTPC3	;HIRMFO/GWB - PCE Study of Thyroid Cancer Table III;6/19/96
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	K TABLE,HTABLE
	S TABLE("SIZE OF TUMOR")="SOT"
	S TABLE("MULTIFOCAL")="M"
	S TABLE("REGIONAL NODES EXAMINED")="RNE"
	S TABLE("REGIONAL NODES POSITIVE")="RNP"
	S TABLE("LOCATION OF POSITIVE NODES")="LOPN"
	S TABLE("SITES OF DISTANT METASTASIS")="SODM"
	S TABLE("AJCC CLINICAL STAGE (cTNM)")="ACS"
	S TABLE("AJCC PATHOLOGIC STAGE (pTNM)")="APS"
	S TABLE("STAGED BY")="SB"
	S HTABLE(1)="SIZE OF TUMOR"
	S HTABLE(2)="MULTIFOCAL"
	S HTABLE(3)="REGIONAL NODES EXAMINED"
	S HTABLE(4)="REGIONAL NODES POSITIVE"
	S HTABLE(5)="LOCATION OF POSITIVE NODES"
	S HTABLE(6)="SITES OF DISTANT METASTASIS"
	S HTABLE(7)="AJCC CLINICAL STAGE (cTNM)"
	S HTABLE(8)="AJCC PATHOLOGIC STAGE (pTNM)"
	S HTABLE(9)="STAGED BY"
	S CHOICES=9
	W @IOF D HEAD^ONCTPC0
	W !?18,"TABLE III- EXTENT OF DISEASE AND AJCC STAGE",!
	S DIE="^ONCO(165.5,",DA=ONCONUM
SOT	S DR="29SIZE OF TUMOR.................." D ^DIE G:$D(Y) JUMP
M	S DR="433MULTIFOCAL....................." D ^DIE G:$D(Y) JUMP
RNE	S DR="33REGIONAL NODES EXAMINED........" D ^DIE G:$D(Y) JUMP
RNP	S DR="32REGIONAL NODES POSITIVE........" D ^DIE G:$D(Y) JUMP
LOPN	S DR="434LOCATION OF POSITIVE NODES....." D ^DIE G:$D(Y) JUMP
SODM	W !!,"SITES OF DISTANT METASTASIS:",!
	S DR="34  SITE OF DISTANT METASTASIS #1" D ^DIE G:$D(Y) JUMP
	I X=0 D  G ACS
	.S $P(^ONCO(165.5,ONCONUM,2),U,15)=0
	.W !,"  SITE OF DISTANT METASTASIS #2: None"
	.S $P(^ONCO(165.5,ONCONUM,2),U,16)=0
	.W !,"  SITE OF DISTANT METASTASIS #3: None"
	S DR="34.1  SITE OF DISTANT METASTASIS #2" D ^DIE G:$D(Y) JUMP
	I X=0 D  G ACS
	.S $P(^ONCO(165.5,ONCONUM,2),U,16)=0
	.W !,"  SITE OF DISTANT METASTASIS #3: None"
	S DR="34.2  SITE OF DISTANT METASTASIS #3" D ^DIE G:$D(Y) JUMP
ACS	W !!,"AJCC CLINICAL STAGE (cTNM):",!
	S DR="37.1  T-CODE......................." D ^DIE G:$D(Y) JUMP
	D CN1^ONCOTN,CN2^ONCOTN
	S DR="37.2  N-CODE......................." D ^DIE G:$D(Y) JUMP
	S DR="37.3  M-CODE......................." D ^DIE G:$D(Y) JUMP
	I '$D(SKAJCC) D CN1^ONCOTN
	S STGIND="C" D ES^ONCOTN
	;S DR="38  AJCC STAGE..................." D ^DIE G:$D(Y) JUMP
APS	W !!,"AJCC PATHOLOGIC STAGE (pTNM):",!
	S DR="85  T-CODE......................." D ^DIE G:$D(Y) JUMP
	D CN3^ONCOTN,CN4^ONCOTN
	S DR="86  N-CODE......................." D ^DIE G:$D(Y) JUMP
	S DR="87  M-CODE......................." D ^DIE G:$D(Y) JUMP
	I '$D(SKAJCC) D CN3^ONCOTN
	S STGIND="P" D ES^ONCOTN
	;S DR="88  AJCC STAGE..................." D ^DIE G:$D(Y) JUMP
SB	W !,"STAGED BY:",!
	S DR="19CLINICAL STAGE.................." D ^DIE G:$D(Y) JUMP
	S DR="89PATHOLOGIC STAGE................" D ^DIE G:$D(Y) JUMP
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
	K DA,DIE,DIR,DIROUT,DIRUT,DR,DTOUT,DUOUT,X,XX,Y
	Q
