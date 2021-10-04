ONCNPC8	;Hines OIFO/GWB - PCE Study of Non-Hodgkin's Lymphoma ;05/30/0
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	;Print
	K IOP,%ZIS S %ZIS="MQ" W ! D ^%ZIS K %ZIS,IOP G:POP KILL
	I $D(IO("Q")) S ONCOLST="ONCONUM^ONCOPA^PATNAM^SPACES^TOPNAM^SSN^TOPTAB^TOPCOD^DASHES^SITTAB^SITEGP" D TASK G KILL
	U IO D PRT D ^%ZISC K %ZIS,IOP G KILL
PRT	S PG=0,EX="",LIN=$S(IOST?1"C".E:IOSL-2,1:IOSL-6),IEN=ONCONUM,LINE=""
	D NOW^%DTC S ONDATE=%,Y=ONDATE X ^DD("DD") S ONDATE=$P(Y,":",1,2)
	K DIQ S DIC="^ONCO(160,",DR="9;15",DA=ONCOPA,DIQ="ONC" D EN^DIQ1
	S DR=".04;.05;.06;.1;.12;3;4;9;18;19;20;22;26;38;50;51;51.2;58.2;70;71;71.4;81;82;88;89;313;421;504;505;506;512;514;516;563;800:899"
	S DIC="^ONCO(165.5,",DA=ONCONUM,DIQ="ONC" D EN^DIQ1
I	S TABLE="TABLE I - GENERAL INFORMATION"
	D HDR
	W !," 1. INSTITUTION ID NUMBER...........: H6",$$IIN^ONCFUNC D P Q:EX=U
	W !!?4,TABLE,!?4,"-----------------------------"
	S D0=ONCOPA D DOB1^ONCOES S Y=X D DATEOT^ONCOPCE S DOB=Y
	W !," 2. ACCESSION NUMBER................: ",ONC(165.5,IEN,.05) D P Q:EX=U
	W !," 3. SEQUENCE NUMBER.................: ",ONC(165.5,IEN,.06) D P Q:EX=U
	W !," 4. POSTAL CODE AT DIAGNOSIS........: ",ONC(165.5,IEN,9) D P Q:EX=U
	W !," 5. DATE OF BIRTH...................: ",DOB D P Q:EX=U
	W !," 6. AGE AT DIAGNOSIS................: ",ONC(165.5,IEN,4) D P Q:EX=U
	W !," 7. RACE............................: ",ONC(165.5,IEN,.12) D P Q:EX=U
	W !," 8. SPANISH ORIGIN..................: ",ONC(160,ONCOPA,9) D P Q:EX=U
	W !," 9. SEX.............................: ",ONC(165.5,IEN,.1) D P Q:EX=U
	W !,"10. PRIMARY PAYER AT DIAGNOSIS......: ",ONC(165.5,IEN,18)
	S LINE="-----------------------------------------"
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HDR W !?4,TABLE_" (continued)",!?4,LINE G FHC
	W ! D P Q:EX=U
FHC	W !,"11. FAMILY HISTORY OF CANCER:" D P Q:EX=U
	W !,"      LEUKEMIA......................: ",ONC(165.5,IEN,800) D P Q:EX=U
	W !,"      NON-HODGKIN'S LYMPHOMA........: ",ONC(165.5,IEN,801) D P Q:EX=U
	W !,"      HODGKIN'S LYMPHOMA............: ",ONC(165.5,IEN,802) D P Q:EX=U
	W !,"      OTHER CANCER..................: ",ONC(165.5,IEN,313) D P Q:EX=U
	W ! D P Q:EX=U
PHAC	W !,"12. PERSONAL HISTORY OF ANY CANCER:" D P Q:EX=U
	W !,"      1ST PRIMARY SITE..............: ",ONC(165.5,IEN,803) D P Q:EX=U
	W !,"      1ST PRIMARY HISTOLOGY.........: ",ONC(165.5,IEN,804) D P Q:EX=U
	W !,"      2ND PRIMARY SITE..............: ",ONC(165.5,IEN,805) D P Q:EX=U
	W !,"      2ND PRIMARY HISTOLOGY.........: ",ONC(165.5,IEN,806)
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HDR W !?4,TABLE_" (continued)",!?4,LINE G PC
	W ! D P Q:EX=U
PC	W !,"13. PRE-EXISTING CONDITIONS:" D P Q:EX=U
	W !,"      ORGAN TRANSPLANT..............: ",ONC(165.5,IEN,807) D P Q:EX=U
	W !,"      HIV POSITIVE..................: ",ONC(165.5,IEN,808) D P Q:EX=U
	W !,"      CROHN'S DIS/ULCERATIVE COLITIS: ",ONC(165.5,IEN,809) D P Q:EX=U
	W !,"      HASHIMOTO'S THYROIDITIS.......: ",ONC(165.5,IEN,810) D P Q:EX=U
	W !,"      SYSTEMIC LUPUS ERYTHEMATOSUS..: ",ONC(165.5,IEN,811) D P Q:EX=U
	W !,"      RHEUMATOID ARTHRITIS/SJOGREN'S: ",ONC(165.5,IEN,812) D P Q:EX=U
	W !,"      PNEUMOCYSTIS CARINII..........: ",ONC(165.5,IEN,813) D P Q:EX=U
	W !,"      CMV INFECTION.................: ",ONC(165.5,IEN,814) D P Q:EX=U
	W !,"      TUBERCULOSIS..................: ",ONC(165.5,IEN,815) D P Q:EX=U
	W !,"      MYCOBACTERIUM AVIUM...........: ",ONC(165.5,IEN,816) D P Q:EX=U
	W !,"      OTHER PARASITIC INFECTIONS....: ",ONC(165.5,IEN,817) D P Q:EX=U
	W !,"      OTHER CONGENITAL DISEASES.....: ",ONC(165.5,IEN,818) D P Q:EX=U
	W !,"      OPPORTUNISTIC DISEASE.........: ",ONC(165.5,IEN,819)
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HDR W !?4,TABLE_" (continued)",!?4,LINE G PCRT
	W ! D P Q:EX=U
PCRT	W !,"14. PREVIOUS CHEMOTHERAPY/RADIATION THERAPY:" D P Q:EX=U
	W !,"      CHEMOTHERAPY..................: ",ONC(165.5,IEN,820) D P Q:EX=U
	W !,"      RADIATION THERAPY.............: ",ONC(165.5,IEN,821) D P Q:EX=U
	W ! D P Q:EX=U
	W !,"15. AIDS RISK CATEGORY..............: ",ONC(165.5,IEN,822)
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HDR G II
	D P Q:EX=U
II	D ^ONCNPC8A
KILL	;Kill Variables and Exit
	K CDS,CDSOT,CS,CSDAT,CSIEN,CSPNT,DLC,DOB,DOIT,FIL,LIN,LOS,NCDS,LINE
	K NCDSIEN,NCDSOT,ONC,ONDATE,PG,SURG,SURG1,SURG2,SURGDT,TABLE,OSP
	K %,DIR,DIROUT,DIRUT,DTOUT,DUOUT,X,Y
	Q
P	;Print
	I ($Y'<(LIN-1)) D  Q:EX=U  W !?4,TABLE_" (continued)",!?4,LINE
	.I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR I 'Y S EX=U Q
	.D HDR Q
	Q
TASK	;Queue a task
	K IO("Q"),ZTUCI,ZTDTH,ZTIO,ZTSAVE
	S ZTRTN="PRT^ONCNPC8",ZTREQ="@",ZTSAVE("ZTREQ")=""
	S ZTDESC="Print Non-Hodgkin's Lymphoma PCE"
	F V2=1:1 S V1=$P(ONCOLST,"^",V2) Q:V1=""  S ZTSAVE(V1)=""
	D ^%ZTLOAD D ^%ZISC U IO W !,"Request Queued",!
	K V1,V2,ONCOLST,ZTSK Q
HDR	;Header
	W @IOF S PG=PG+1 N BLANKS S $P(BLANKS," ",SITTAB-$L(PATNAM)-4)=" "
	W " ",PATNAM,BLANKS,SITEGP,!,?1,SSN,?TOPTAB-3,TOPNAM," ",TOPCOD
	W $S($L(PG)=2:" ",1:"  "),PG,!,DASHES
	W !?19,"PCE Study of Non-Hodgkin's Lymphoma"
	W ?62,ONDATE,!,DASHES
	Q
