ONCP2P2	;HINES CIOFO/GWB - 1998 Prostate Cancer Study - Table II ;6/1/98
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	K TABLE,HTABLE
	S TABLE("10. CLASS OF CASE")="COC"
	S TABLE("11. SYMPTOMS PRESENT AT INITIAL DIAGNOSIS")="SPAID"
	S TABLE("12. INITIAL METHODS OF DIAGNOSIS")="IMOD"
	S TABLE("13. DIAGNOSTIC EVALUATION")="DE"
	S TABLE("14. RESULTS OF MOST RECENT PRE-TREATMENT PSA TEST")="ROPP"
	S TABLE("15. DATE OF INITIAL DIAGNOSIS")="DOID"
	S TABLE("16. PRIMARY SITE (ICD-O-2)")="PS"
	S TABLE("17. HISTOLOGY (ICD-O-2)")="HIST"
	S TABLE("18. BEHAVIOR CODE(ICD-O-2)")="BC"
	S TABLE("19. GRADE")="GRADE"
	S TABLE("20. BIOPSY PROCEDURE")="BP"
	S TABLE("21. GUIDANCE OF BIOPSY TO PRIMARY")="GOBTP"
	S TABLE("22. BIOPSY APPROACH FOR PRIMARY")="BAFP"
	S TABLE("23. BIOPSY OF OTHER THAN PRIMARY")="BOOTP"
	S TABLE("24. DIAGNOSTIC CONFIRMATION")="DC"
	S TABLE("25. GLEASON'S SCORE FOR BIOPSY, LOCAL RESECTION, OR SIMPLE PROSTATECTOMY")="GSFSP"
	S TABLE("26. GLEASON'S SCORE FOR RADICAL PROSTATECTOMY")="GSFRP"
	S HTABLE(1)="10. CLASS OF CASE"
	S HTABLE(2)="11. SYMPTOMS PRESENT AT INITIAL DIAGNOSIS"
	S HTABLE(3)="12. INITIAL METHODS OF DIAGNOSIS"
	S HTABLE(4)="13. DIAGNOSTIC EVALUATION"
	S HTABLE(5)="14. RESULTS OF MOST RECENT PRE-TREATMENT PSA TEST"
	S HTABLE(6)="15. DATE OF INITIAL DIAGNOSIS"
	S HTABLE(7)="16. PRIMARY SITE (ICD-O-2)"
	S HTABLE(8)="17. HISTOLOGY (ICD-O-2)"
	S HTABLE(9)="18. BEHAVIOR CODE (ICD-O-2)"
	S HTABLE(10)="19. GRADE"
	S HTABLE(11)="20. BIOPSY PROCEDURE"
	S HTABLE(12)="21. GUIDANCE OF BIOPSY TO PRIMARY"
	S HTABLE(13)="22. BIOPSY APPROACH FOR PRIMARY"
	S HTABLE(14)="23. BIOPSY OF OTHER THAN PRIMARY"
	S HTABLE(15)="24. DIAGNOSTIC CONFIRMATION"
	S HTABLE(16)="25. GLEASON'S SCORE FOR BIOPSY, LOCAL RESECTION, OR SIMPLE PROSTATECTOMY"
	S HTABLE(17)="26. GLEASON'S SCORE FOR RADICAL PROSTATECTOMY"
	S CHOICES=17
	K DIQ S DIC="^ONCO(165.5,",DR=".04;22;58.1;58.2",DA=ONCONUM,DIQ="ONC",DIQ(0)="IE"
	D EN^DIQ1
	S NCDS=$E(ONC(165.5,ONCONUM,58.1,"E"),1,2)
	S CDS=$E(ONC(165.5,ONCONUM,58.2,"E"),1,2)
	F SUB="02","03","04","05","06","07" S NCDS(SUB)=""
	F SUB=10,11,12,13,14,15,16,17,30,40 S CDS(SUB)=""
	S DIE="^ONCO(165.5,",DA=ONCONUM
	W @IOF D HEAD^ONCP2P0
	W !," TABLE II - INITIAL DIAGNOSIS"
	W !," ----------------------------"
COC	W !," 10. CLASS OF CASE................: ",ONC(165.5,ONCONUM,.04,"E")
SPAID	W !!," 11. SYMPTOMS PRESENT AT INITIAL DIAGNOSIS:",!
	S DR="658     HEMATURIA...................." D ^DIE G:$D(Y) JUMP
	S DR="659     LOWER BACK PAIN.............." D ^DIE G:$D(Y) JUMP
	S DR="660     TROUBLE URINATING............" D ^DIE G:$D(Y) JUMP
IMOD	W !!," 12. INITIAL METHOD OF DIAGNOSIS:",!
	S DR="661     CLINICAL DX WITH BONE LESION." D ^DIE G:$D(Y) JUMP
	S DR="662     CLINICAL DX BY RECTAL EXAM..." D ^DIE G:$D(Y) JUMP
	S DR="663     CYTOLOGY....................." D ^DIE G:$D(Y) JUMP
	S DR="664     DIGITAL TRANSRECTAL BIOPSY..." D ^DIE G:$D(Y) JUMP
	S DR="665     INCIDENTAL FINDING IN TURP                                                      FOR BENIGN DISEASE..........." D ^DIE G:$D(Y) JUMP
	S DR="666     NEEDLE BIOPSY, NOS..........." D ^DIE G:$D(Y) JUMP
	S DR="667     PERINEAL BIOPSY.............." D ^DIE G:$D(Y) JUMP
	S DR="668     PSA.........................." D ^DIE G:$D(Y) JUMP
	S DR="669     TRUS GUIDED BIOPSY..........." D ^DIE G:$D(Y) JUMP
	S DR="670     TURP, NOS...................." D ^DIE G:$D(Y) JUMP
DE	W !!," 13. DIAGNOSTIC EVALUATION:",!
	S DR="671     BONE MARROW ASPIRATION......." D ^DIE G:$D(Y) JUMP
	S DR="672     BONE SCAN...................." D ^DIE G:$D(Y) JUMP
	S DR="673     BONE X-RAY..................." D ^DIE G:$D(Y) JUMP
	S DR="674     CHEST X-RAY.................." D ^DIE G:$D(Y) JUMP
	S DR="675     CT SCAN OF ABDOMEN..........." D ^DIE G:$D(Y) JUMP
	S DR="676     CT SCAN OF PELVIS............" D ^DIE G:$D(Y) JUMP
	S DR="677     IVP.........................." D ^DIE G:$D(Y) JUMP
	S DR="678     MRI.........................." D ^DIE G:$D(Y) JUMP
	S DR="679     PELVIC LYMPH NODE DISSECTION." D ^DIE G:$D(Y) JUMP
	S DR="680     PCR.........................." D ^DIE G:$D(Y) JUMP
	S DR="681     PAP.........................." D ^DIE G:$D(Y) JUMP
	S DR="682     PSA.........................." D ^DIE G:$D(Y) JUMP
	S DR="683     ULTRASOUND OF ABDOMEN........" D ^DIE G:$D(Y) JUMP
	W !
ROPP	S DR="684 14. RESULTS OF MOST RECENT PRE-                                                     TREATMENT PSA TEST..........." D ^DIE G:$D(Y) JUMP
DOID	S DOID=$E(DATEDX,4,5)_"/"_$E(DATEDX,6,7)_"/"_(1700+$E(DATEDX,1,3))
	W !," 15. DATE OF INITIAL DIAGNOSIS....: ",DOID
PS	W !," 16. PRIMARY SITE (ICD-O-2).......: C61.9"
HIST	W !," 17. HISTOLOGY (ICD-O-2)..........: ",$E(ONC(165.5,ONCONUM,22,"I"),1,4)
BC	W !," 18. BEHAVIOR CODE (ICD-O-2)......: ",$E(ONC(165.5,ONCONUM,22,"I"),5)
GRADE	S DR="24 19. GRADE........................" D ^DIE G:$D(Y) JUMP
BP	S DR="141 20. BIOSPY PROCEDURE............." D ^DIE G:$D(Y) JUMP
	I $G(X)=1 D  G BOOTP
	.S $P(^ONCO(165.5,ONCONUM,2.1),U,15)=1
	.S $P(^ONCO(165.5,ONCONUM,2.1),U,18)=0
	.W !," 21. GUIDANCE OF BIOPSY TO PRIMARY: Not guided, no biopsy"
	.W !," 22. BIOPSY APPROACH FOR PRIMARY..: No biopsy"
	I $G(X)=6 D  G BOOTP
	.S $P(^ONCO(165.5,ONCONUM,2.1),U,15)=5
	.S $P(^ONCO(165.5,ONCONUM,2.1),U,18)=9
	.W !," 21. GUIDANCE OF BIOPSY TO PRIMARY: Unknown/death cert only"
	.W !," 22. BIOPSY APPROACH FOR PRIMARY..: Unknown/death cert only"
GOBTP	S DR="142 21. GUIDANCE OF BIOSPY TO PRIMARY" D ^DIE G:$D(Y) JUMP
BAFP	S DR="145 22. BIOSPY APPROACH FOR PRIMARY.." D ^DIE G:$D(Y) JUMP
BOOTP	S DR="146 23. BIOSPY OF OTHER THAN PRIMARY." D ^DIE G:$D(Y) JUMP
DC	S DR="26 24. DIAGNOSTIC CONFIRMATION......" D ^DIE G:$D(Y) JUMP
GSFSP	W !," 25. GLEASON'S SCORE FOR BIOPSY, LOCAL RESECTION, OR SIMPLE PROSTATECTOMY:",!
	I NCDS'="",$D(NCDS(NCDS)) G PP25
	I CDS'="",$D(CDS(CDS)) G PP25
	E  D  G GSFRP
	.W !,"     Surgery codes not 02 through 40",!
	.K DR S DR=""
	.S DR(1,165.5,1)="623.1///9"
	.S DR(1,165.5,2)="623.2///9"
	.S DR(1,165.5,3)="623///99"
	.D ^DIE
	.W !,"     PREDOMINENT (PRIMARY) PATTERN: 9"
	.W !,"     LESSER (SECONDARY) PATTERN...: 9"
	.W !,"     GLEASON SCORE................: 99 Unknown, not reported, or NA"
PP25	S DR="623.1     PREDOMINENT (PRIMARY) PATTERN" D ^DIE G:$D(Y) JUMP
	I $P($G(^ONCO(165.5,ONCONUM,"PRO2")),U,43)=0 D  G GS25
	.S DR="623.2///0" D ^DIE
	.W !,"     LESSER (SECONDARY) PATTERN...: 0"
	I $P($G(^ONCO(165.5,ONCONUM,"PRO2")),U,43)=9 D  G GSFRP
	.S DR="623///99;623.2///9" D ^DIE
	.W !,"     LESSER (SECONDARY) PATTERN...: 9"
	.W !,"     GLEASON SCORE................: 99 Unknown, not reported, or NA"
LP25	S DR="623.2     LESSER (SECONDARY) PATTERN..." D ^DIE G:$D(Y) JUMP
	S PP=$P($G(^ONCO(165.5,D0,"PRO2")),U,43)
	S LP=$P($G(^ONCO(165.5,D0,"PRO2")),U,44)
	I PP>0,PP<6,(X=0)!(X=9) W *7,"??" G LP25
	I ((PP>0)&(PP<6))&((LP>0)&(LP<6)) S GS=PP+LP S:$L(GS)=1 GS="0"_GS D  G GSFRP
	.S DR="623///"_GS D ^DIE
	.W !,"     GLEASON SCORE................: ",GS
GS25	S DR="623     GLEASON SCORE................" D ^DIE G:$D(Y) JUMP
GSFRP	W !!," 26. GLEASON'S SCORE FOR RADICAL PROSTATECTOMY:",!
	I (CDS=50)!(CDS=70) G PP26
	E  D  G PRTC
	.W !,"     Surgery codes not 50 through 70",!
	.K DR S DR=""
	.S DR(1,165.5,1)="623.4///9"
	.S DR(1,165.5,2)="623.5///9"
	.S DR(1,165.5,3)="623.3///99"
	.D ^DIE
	.W !,"     PREDOMINENT (PRIMARY) PATTERN: 9"
	.W !,"     LESSER (SECONDARY) PATTERN...: 9"
	.W !,"     GLEASON SCORE................: 99 Unknown, not reported, or NA"
PP26	S DR="623.4     PREDOMINENT (PRIMARY) PATTERN" D ^DIE G:$D(Y) JUMP
	I $P($G(^ONCO(165.5,ONCONUM,"PRO2")),U,46)=0 D  G GS26
	.S DR="623.5///0" D ^DIE
	.W !,"     LESSER (SECONDARY) PATTERN...: 0"
	I $P($G(^ONCO(165.5,ONCONUM,"PRO2")),U,46)=9 D  G PRTC
	.S DR="623.3///99;623.5///9" D ^DIE
	.W !,"     LESSER (SECONDARY) PATTERN...: 9"
	.W !,"     GLEASON SCORE................: 99 Unknown, not reported, or NA"
LP26	S DR="623.5     LESSER (SECONDARY) PATTERN..." D ^DIE G:$D(Y) JUMP
	S PP=$P($G(^ONCO(165.5,D0,"PRO2")),U,46)
	S LP=$P($G(^ONCO(165.5,D0,"PRO2")),U,47)
	I PP>0,PP<6,(X=0)!(X=9) W *7,"??" G LP26
	I ((PP>0)&(PP<6))&((LP>0)&(LP<6)) S GS=PP+LP S:$L(GS)=1 GS="0"_GS D  G PRTC
	.S DR="623.3///"_GS D ^DIE
	.W !,"     GLEASON SCORE................: ",GS
GS26	S DR="623.3     GLEASON SCORE................" D ^DIE G:$D(Y) JUMP
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
	K DOID,NCDS,CDS,PP,LP,GS,PIECE
	K DA,DIE,DIR,DIROUT,DIRUT,DR,DTOUT,DUOUT,X,XX,Y
	Q