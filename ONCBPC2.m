ONCBPC2	;HIRMFO/GWB - PCE Study of Cancers of the Urinary Bladder Table II;6/19/96
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	K TABLE,HTABLE
	S TABLE("CLINICAL DETECTION")="CLI"
	S TABLE("ONSET OF SYMPTOMS")="ONS"
	S TABLE("DURATION OF SYMPTOMS BEFORE DIAGNOSIS")="DUR"
	S TABLE("DIAGNOSTIC PROCEDURES")="DIA"
	S TABLE("DATE OF INITIAL DIAGNOSIS")="DAT"
	S TABLE("SPECIALTY MAKING DIAGNOSIS")="SPE"
	S TABLE("PRIMARY SITE (ICD-O-2)")="PRI"
	S TABLE("HISTOLOGY (ICD-O-2)")="HIS"
	S TABLE("GRADE")="GRA"
	S HTABLE(1)="CLINICAL DETECTION"
	S HTABLE(2)="ONSET OF SYMPTOMS"
	S HTABLE(3)="DURATION OF SYMPTOMS BEFORE DIAGNOSIS"
	S HTABLE(4)="DIAGNOSTIC PROCEDURES"
	S HTABLE(5)="DATE OF INITIAL DIAGNOSIS"
	S HTABLE(6)="SPECIALTY MAKING DIAGNOSIS"
	S HTABLE(7)="PRIMARY SITE (ICD-O-2)"
	S HTABLE(8)="HISTOLOGY (ICD-O-2)"
	S HTABLE(9)="GRADE"
	S CHOICES=9
	S PRINODE0=^ONCO(165.5,ONCONUM,0)
	S PRINODE2=$G(^ONCO(165.5,ONCONUM,2))
	S DATEDIA=$P(PRINODE0,U,16),Y=DATEDIA D DATEOT^ONCOPCE S DATEDIA=Y
	S TOPOG=$P(PRINODE2,U,1),(TOPCD,SITE)=""
	I TOPOG'="" S TOPCD=$P(^ONCO(164,TOPOG,0),U,2),SITE=$P(^ONCO(164,TOPOG,0),U,1)
	S HST=$P(PRINODE2,U,3),(HSTCD,HSTNAM)=""
	I HST'="" S HSTCD=$P(^ONCO(164.1,HST,0),U,2),HSTNAM=$P(^ONCO(164.1,HST,0),U,1)
	W @IOF D HEAD^ONCBPC0 W !?24,"TABLE II- DIAGNOSTIC INFORMATION",!
CLI	W !,"CLINICAL DETECTION:",!
	S DIE="^ONCO(165.5,",DA=ONCONUM
	S DR="317  GROSS HEMATURIA................" D ^DIE G:$D(Y) JUMP
	S DR="318  MICROSCOPIC HEMATURIA.........." D ^DIE G:$D(Y) JUMP
	S DR="319  URINARY FREQUENCY.............." D ^DIE G:$D(Y) JUMP
	S DR="320  BLADDER IRRITABILITY..........." D ^DIE G:$D(Y) JUMP
	S DR="321  DYSURIA........................" D ^DIE G:$D(Y) JUMP
	S DR="322  OTHER.........................." D ^DIE G:$D(Y) JUMP
	W !
ONS	S DR="323ONSET OF SYMPTOMS................" D ^DIE G:$D(Y) JUMP
DUR	W !!,"DURATION OF SYMPTOMS (months) BEFORE DIAGNOSIS:",!
	S DR="324  GROSS HEMATURIA................" D ^DIE G:$D(Y) JUMP
	S DR="325  DYSURIA........................" D ^DIE G:$D(Y) JUMP
DIA	W !!,"DIAGNOSTIC PROCEDURES:",!
	S DR="326  BIMANUAL EXAMINATION OF BLADDER" D ^DIE G:$D(Y) JUMP
	S DR="327  CYSTOSCOPY WITH BIOPSY........." D ^DIE G:$D(Y) JUMP
	S DR="328  CYSTOSCOPY WITHOUT BIOPSY......" D ^DIE G:$D(Y) JUMP
	S DR="329  FLOW CYTOMETRY................." D ^DIE G:$D(Y) JUMP
	S DR="330  INTRAVENOUS PYELOGRAM.........." D ^DIE G:$D(Y) JUMP
	S DR="331  URINE CYTOLOGY................." D ^DIE G:$D(Y) JUMP
	S DR="332  URINALYSIS....................." D ^DIE G:$D(Y) JUMP
	S DR="333  OTHER.........................." D ^DIE G:$D(Y) JUMP
	W !
DAT	W !,"DATE OF INITIAL DIAGNOSIS........: ",DATEDIA
SPE	S DR="334SPECIALTY MAKING DIAGNOSIS......." D ^DIE G:$D(Y) JUMP
PRI	W !,"PRIMARY SITE (ICD-O-2)...........: ",TOPCD,"  ",SITE
HIS	W !,"HISTOLOGY (ICD-O-2)..............: ",HSTCD," ",HSTNAM
GRA	S DR="24GRADE............................" D ^DIE G:$D(Y) JUMP
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
	K DATEDIA,HST,HSTCD,HSTNAM,PRINODE0,PRINODE2,TOPOG,TOPCD,SITE
	K DA,DIE,DIR,DIROUT,DIRUT,DR,DTOUT,DUOUT,X,XX,Y
	Q
