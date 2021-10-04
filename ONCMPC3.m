ONCMPC3	;HIRMFO/GWB - 1999 Melanoma Study - Table III; 1/20/99
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	K TABLE,HTABLE
	S TABLE("23. SIZE OF TUMOR (MELANOMA)")="SOT"
	S TABLE("24. REGIONAL NODES EXAMINED")="RNE"
	S TABLE("25. REGIONAL NODES POSITIVE")="RNP"
	S TABLE("26. EXTRANODAL EXTENSION")="EE"
	S TABLE("27. MICROSATELLITOSIS")="M"
	S TABLE("28. NUMBER OF SATELLITE NODULES")="NOSN"
	S TABLE("29. LOCATION OF IN-TRANSIT NODULES")="LOIN"
	S TABLE("30. BRESLOW'S THICKNESS")="BT"
	S TABLE("31. CLARK'S LEVEL OF INVASION")="CLOI"
	S TABLE("32. ANGIOLYMPHATIC INVASION")="AI"
	S TABLE("33. PERINEURAL INVASION")="PI"
	S TABLE("34. GENERAL SUMMARY STAGE")="GSS"
	S TABLE("35. AJCC CLINICAL STAGE (cTNM)")="ACS"
	S TABLE("36. ULCERATION")="U"
	S TABLE("37. CLINICALLY AMELANOTIC")="CA"
	S TABLE("38. AJCC PATHOLOGIC STAGE (pTNM)")="APS"
	S TABLE("39. STAGED BY")="SB"
	S HTABLE(1)="23. SIZE OF TUMOR (MELANOMA)"
	S HTABLE(2)="24. REGIONAL NODES EXAMINED"
	S HTABLE(3)="25. REGIONAL NODES POSITIVE"
	S HTABLE(4)="26. EXTRANODAL EXTENSION"
	S HTABLE(5)="27. MICROSATELLITOSIS"
	S HTABLE(6)="28. NUMBER OF SATELLITE NODULES"
	S HTABLE(7)="29. LOCATION OF IN-TRANSIT NODULES"
	S HTABLE(8)="30. BRESLOW'S THICKNESS"
	S HTABLE(9)="31. CLARK'S LEVEL OF INVASION"
	S HTABLE(10)="32. ANGIOLYMPHATIC INVASION"
	S HTABLE(11)="33. PERINEURAL INVASION"
	S HTABLE(12)="34. GENERAL SUMMARY STAGE"
	S HTABLE(13)="35. AJCC CLINICAL STAGE (cTNM)"
	S HTABLE(14)="36. ULCERATION"
	S HTABLE(15)="37. CLINICALLY AMELANOTIC"
	S HTABLE(16)="38. AJCC PATHOLOGIC STAGE (pTNM)"
	S HTABLE(17)="39. STAGED BY"
	S CHOICES=17
	K DIQ S DIC="^ONCO(165.5,",DR="38;88",DA=ONCONUM,DIQ="ONC" D EN^DIQ1
	W @IOF D HEAD^ONCMPC0
	W !," TABLE III- EXTENT OF DISEASE AND AJCC STAGE"
	W !," -------------------------------------------"
	S DIE="^ONCO(165.5,",DA=ONCONUM
SOT	S DR="1132 23. SIZE OF TUMOR (MELANOMA)....." D ^DIE G:$D(Y) JUMP
RNE	S DR="33 24. REGIONAL NODES EXAMINED......" D ^DIE G:$D(Y) JUMP
RNP	S DR="32 25. REGIONAL NODES POSITIVE......" D ^DIE G:$D(Y) JUMP
EE	S DR="1110 26. EXTRANODAL EXTENSION........." D ^DIE G:$D(Y) JUMP
SNOSOST	W !!," SATELLITE NODULES OF SKIN OR SUBCUTANEOUS TISSUE",!
M	S DR="1111 27. MICROSATELLITOSIS............" D ^DIE G:$D(Y) JUMP
	I X=0 D  G LOIN
	.S $P(^ONCO(165.5,ONCONUM,"MEL1"),U,13)="00"
	.W !," 28. NUMBER OF SATELLITE NODES....: No satellite nodules"
	I X=8 D  G LOIN
	.S $P(^ONCO(165.5,ONCONUM,"MEL1"),U,13)=98
	.W !," 28. NUMBER OF SATELLITE NODES....: NA, non-cutaneous melanoma"
	I X=9 D  G LOIN
	.S $P(^ONCO(165.5,ONCONUM,"MEL1"),U,13)=99
	.W !," 28. NUMBER OF SATELLITE NODES....: Unknown"
NOSN	S DR="1112 28. NUMBER OF SATELLITE NODULES.." D ^DIE G:$D(Y) JUMP
LOIN	S DR="1113 29. LOC OF IN-TRANSIT NODULES...." D ^DIE G:$D(Y) JUMP
BT	S BTST=$P($G(^ONCO(165.5,ONCONUM,2)),U,9),BTST=$J(BTST,0,0)
	S DR="1114 30. BRESLOW'S THICKNESS..........//"_BTST D ^DIE G:$D(Y) JUMP
CLOI	I TOPCOD="C44.9" D  G AI
	.S $P(^ONCO(165.5,ONCONUM,"MEL1"),U,16)=8
	.W !," 31. CLARK'S LEVEL OF INVASION....: NA, primary site unknown"
	S DR="1115 31. CLARK'S LEVEL OF INVASION...." D ^DIE G:$D(Y) JUMP
AI	I (TOPCOD="C44.9")!($E(TOPCOD,1,3)="C69") D  G PI
	.S $P(^ONCO(165.5,ONCONUM,"MEL1"),U,17)=8
	.W !," 32. ANGIOLYMPHATIC INVASION......: NA, site unknown or ocular"
	S DR="1116 32. ANGIOLYMPHATIC INVASION......" D ^DIE G:$D(Y) JUMP
PI	I (TOPCOD="C44.9")!($E(TOPCOD,1,3)="C69") D  G GSS
	.S $P(^ONCO(165.5,ONCONUM,"MEL1"),U,18)=8
	.W !," 33. PERINEURAL INVASION..........: NA, site unknown or ocular"
	S DR="1117 33. PERINEURAL INVASION.........." D ^DIE G:$D(Y) JUMP
GSS	S DR="35 34. GENERAL SUMMARY STAGE........" D ^DIE G:$D(Y) JUMP
ACS	W !!," 35. AJCC CLINICAL STAGE (cTNM):",!
CTCODE	S DR="37.1     T-CODE......................." D ^DIE G:$D(Y) JUMP
	D CN1^ONCOTN,CN2^ONCOTN
CNCODE	S DR="37.2     N-CODE......................." D ^DIE G:$D(Y) JUMP
CMCODE	S DR="37.3     M-CODE......................." D ^DIE G:$D(Y) JUMP
	I '$D(SKAJCC) D CN1^ONCOTN
	S STGIND="C" D ES^ONCOTN
U	I (TOPCOD="C44.9")!($E(TOPCOD,1,3)="C69") D  G CA
	.S $P(^ONCO(165.5,ONCONUM,"MEL1"),U,19)=8
	.W !," 36. ULCERATION,,,,,,,,,..........: NA, site unknown or ocular"
	S DR="1118 36. ULCERATION..................." D ^DIE G:$D(Y) JUMP
CA	I (TOPCOD="C44.9")!($E(TOPCOD,1,3)="C69") D  G APS
	.S $P(^ONCO(165.5,ONCONUM,"MEL1"),U,20)=8
	.W !," 37. CLINICALLY AMELANOTIC........: NA, site unknown or ocular"
	S DR="1119 37. CLINICALLY AMELANOTIC........" D ^DIE G:$D(Y) JUMP
APS	W !!," 38. AJCC PATHOLOGIC STAGE (pTNM):",!
PTCODE	S DR="85     T-CODE......................." D ^DIE G:$D(Y) JUMP
	D CN3^ONCOTN,CN4^ONCOTN
PNCODE	S DR="86     N-CODE......................." D ^DIE G:$D(Y) JUMP
PMCODE	S DR="87     M-CODE......................." D ^DIE G:$D(Y) JUMP
	I '$D(SKAJCC) D CN3^ONCOTN
	S STGIND="P" D ES^ONCOTN
SB	W !," 39. STAGED BY:",!
CSB	S DR="19     CLINICAL STAGE..............." D ^DIE G:$D(Y) JUMP
PSB	S DR="89     PATHOLOGIC STAGE............." D ^DIE G:$D(Y) JUMP
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
EXIT	K HTABLE,TABLE,CHOICES
	K DA,DIE,DIR,DIROUT,DIRUT,DR,DTOUT,DUOUT,X,XX,Y,BTST
	Q
