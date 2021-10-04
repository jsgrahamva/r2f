ONCMPC9	;Hines OIFO/GWB - 1999 Melanoma Study ;2/17/99
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	;Print
	K IOP,%ZIS S %ZIS="MQ" W ! D ^%ZIS K %ZIS,IOP G:POP KILL
	I $D(IO("Q")) S ONCOLST="ONCONUM^ONCOPA^PATNAM^SPACES^TOPNAM^SSN^TOPTAB^TOPCOD^DASHES^SITTAB^SITEGP" D TASK G KILL
	U IO D PRT D ^%ZISC K %ZIS,IOP G KILL
PRT	S PG=0,EX="",LIN=$S(IOST?1"C".E:IOSL-2,1:IOSL-4),IE=ONCONUM
	D NOW^%DTC S ONDATE=%,Y=ONDATE X ^DD("DD") S ONDATE=$P(Y,":",1,2)
	K DIQ S DIC="^ONCO(160,",DR="9;10;15",DA=ONCOPA,DIQ="ONC" D EN^DIQ1
	S DR=".04;.05;.06;.12;1;3;9;18;19;20;23;24;26;28;29;32;33;35;37.1;37.2;37.3;38;50;51;51.2;53;53.2;54;54.2;55;55.2;57;57.2;58;58.1;58.2;58.3;59;70;71;71.4;74;75;81;82;85:89;138;139;140;346;384:386;559;560;791;884;943;1100:1132"
	S DIC="^ONCO(165.5,",DA=ONCONUM,DIQ="ONC" D EN^DIQ1
	S HIST=$P($G(^ONCO(165.5,ONCONUM,2)),U,3)
	K LINE S $P(LINE,"-",40)="-"
I	S TABLE="TABLE I - GENERAL INFORMATION"
	D HEAD^ONCMPC0
	W !," 1. INSTITUTION ID NUMBER...........: ",$$IIN^ONCFUNC D P Q:EX=U
	W !!?4,TABLE,!?4,"-----------------------------"
	S D0=ONCOPA D DOB1^ONCOES S Y=X D DATEOT^ONCOPCE S DOB=Y
	W !," 2. ACCESSION NUMBER................: ",ONC(165.5,IE,.05) D P Q:EX=U
	W !," 3. SEQUENCE NUMBER.................: ",ONC(165.5,IE,.06) D P Q:EX=U
	W !," 4. POSTAL CODE AT DIAGNOSIS........: ",ONC(165.5,IE,9) D P Q:EX=U
	W !," 5. DATE OF BIRTH...................: ",DOB D P Q:EX=U
	W !," 6. RACE............................: ",ONC(165.5,IE,.12) D P Q:EX=U
	W !," 7. SPANISH ORIGIN..................: ",ONC(160,ONCOPA,9) D P Q:EX=U
	W !," 8. SEX.............................: ",ONC(160,ONCOPA,10) D P Q:EX=U
	W !," 9. PRIMARY PAYER AT DIAGNOSIS......: ",ONC(165.5,IE,18) D P Q:EX=U
	K LINE S $P(LINE,"-",41)="-"
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCMPC0 W !?4,TABLE_" (continued)",!?4,LINE G PHOM
PHOM	W !,"10. PERSONAL HISTORY OF MELANOMA....: ",ONC(165.5,IE,1100) D P Q:EX=U
	W !!,"11. PERSONAL HISTORY OF OTHER CA....: ",ONC(165.5,IE,1101) D P Q:EX=U
	W !,"     1ST SITE CODE..................: ",ONC(165.5,IE,1102) D P Q:EX=U
	W !,"     DATE DIAGNOSED.................: ",ONC(165.5,IE,1103) D P Q:EX=U
	W !,"     2ND SITE CODE..................: ",ONC(165.5,IE,1104) D P Q:EX=U
	W !,"     DATE DIAGNOSED.................: ",ONC(165.5,IE,1105) D P Q:EX=U
	W !!,"    PREGNANCY AND HORMONES",!
	W !,"12. PREGNANCY AT INITIAL DX.........: ",ONC(165.5,IE,1106) D P Q:EX=U
	W !,"13. EXOGENOUS HORMONES..............: ",ONC(165.5,IE,1107) D P Q:EX=U
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCMPC0 G II
	D P Q:EX=U
II	S TABLE="TABLE II - INITIAL DIAGNOSIS"
	I IOST'?1"C".E W ! I ($Y'<(LIN-4)) D HEAD^ONCMPC0
	W !?4,TABLE,!?4,"----------------------------" D P Q:EX=U
	W !,"14. CLASS OF CASE...................: ",ONC(165.5,IE,.04) D P Q:EX=U
	W !,"15. DATE OF INITIAL DIAGNOSIS.......: ",ONC(165.5,IE,3) D P Q:EX=U
	W !,"16. PRIMARY SITE (ICD-O-2)..........: ",TOPCOD," ",ONC(165.5,IE,20) D P Q:EX=U
	W !,"17. LOC OF DISEASE PRESENTATION.....: ",ONC(165.5,IE,1108) D P Q:EX=U
	W !,"18. LATERALITY......................: ",ONC(165.5,IE,28) D P Q:EX=U
	W !,"19. HISTOLOGY (ICD-O-2).............: ",$E(HIST,1,4) D P Q:EX=U
	W !,"20. BEHAVIOR CODE (ICD-O-2).........: ",$E(HIST,5) D P Q:EX=U
	W !,"21. GRADE...........................: ",ONC(165.5,IE,24) D P Q:EX=U
	W !,"22. DIAGNOSTIC CONFIRMATION.........: ",ONC(165.5,IE,26)
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCMPC0 G III
	D P Q:EX=U
III	D ^ONCMPC9A
KILL	;Kill Variables and Exit
	K CDS,CDSOT,CS,CSDAT,CSIEN,CSPNT,DLC,DOB,DOIT,FIL,LIN,LOS,NCDS,HIST
	K NCDSIEN,NCDSOT,ONC,ONDATE,PG,SURG,SURG1,SURG2,SURGDT,TABLE
	K %,DIR,DIROUT,DIRUT,DTOUT,DUOUT,X,Y,OSP,IIN
	Q
P	;Print
	I ($Y'<(LIN-1)) D  Q:EX=U  W !?4,TABLE_" (continued)",!?4,LINE
	.I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR I 'Y S EX=U Q
	.D HEAD^ONCMPC0 Q
	Q
TASK	;Queue a task
	K IO("Q"),ZTUCI,ZTDTH,ZTIO,ZTSAVE
	S ZTRTN="PRT^ONCMPC9",ZTREQ="@",ZTSAVE("ZTREQ")=""
	S ZTDESC="Print Melanoma PCE"
	F V2=1:1 S V1=$P(ONCOLST,"^",V2) Q:V1=""  S ZTSAVE(V1)=""
	D ^%ZTLOAD D ^%ZISC U IO W !,"Request Queued",!
	K V1,V2,ONCOLST,ZTSK Q
HDR	;Header
	W @IOF S PG=PG+1 N BLANKS S $P(BLANKS," ",SITTAB-$L(PATNAM)-4)=" "
	W !," ",PATNAM,BLANKS,SITEGP,!,?1,SSN,?TOPTAB-3,TOPNAM," ",TOPCOD
	W $S($L(PG)=2:" ",1:"  "),PG,!,DASHES
	W !," 1999 Patient Care Evaluation Study of Melanoma"
	W ?62,ONDATE,!,DASHES
	Q
