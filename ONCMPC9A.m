ONCMPC9A	;HINES CIOFO/GWB - 1999 Melanoma Study - print ;2/18/99
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
III	S TABLE="TABLE III - EXTENT AND STAGE OF DISEASE"
	I IOST'?1"C".E W ! I ($Y'<(LIN-4)) D HEAD^ONCMPC0
	W !?4,TABLE,!?4,"---------------------------------------" D P Q:EX=U
	K LINE S $P(LINE,"-",51)="-"
	W !,"23. SIZE OF TUMOR (mm)..............: ",ONC(165.5,IE,1132) D P Q:EX=U
	W !,"24. REGIONAL NODES EXAMINED.........: ",ONC(165.5,IE,33) D P Q:EX=U
	W !,"25. REGIONAL NODES POSITIVE.........: ",ONC(165.5,IE,32) D P Q:EX=U
	W !,"26. EXTRANODAL EXTENSION............: ",ONC(165.5,IE,1110) D P Q:EX=U
	W !!,"    SATELLITE NODULES OF SKIN OR SUBCUTANEOUS TISSUE",!
	W !,"27. MICROSATELLITOSIS...............: ",ONC(165.5,IE,1111) D P Q:EX=U
	W !,"28. NUMBER OF SATELLITE NODULES.....: ",ONC(165.5,IE,1112) D P Q:EX=U
	W !,"29. LOCATION OF IN-TRANSIT NODULES..: ",ONC(165.5,IE,1113) D P Q:EX=U
	W !,"30. BRESLOW'S THICKNESS.............: ",ONC(165.5,IE,1114) D P Q:EX=U
	W !,"31. CLARK'S LEVEL OF INVASION.......: ",ONC(165.5,IE,1115) D P Q:EX=U
	W !,"32. ANGIOLYMPHATIC INVASION.........: ",ONC(165.5,IE,1116) D P Q:EX=U
	W !,"33. PERINEURAL INVASION.............: ",ONC(165.5,IE,1117) D P Q:EX=U
	W !,"34. GENERAL SUMMARY STAGE...........: ",ONC(165.5,IE,35) D P Q:EX=U
ACS	W !!,"35. AJCC CLINICAL STAGE (cTNM):" D P Q:EX=U
	W !,"     T-CODE.........................: ",ONC(165.5,IE,37.1) D P Q:EX=U
	W !,"     N-CODE.........................: ",ONC(165.5,IE,37.2) D P Q:EX=U
	W !,"     M-CODE.........................: ",ONC(165.5,IE,37.3) D P Q:EX=U
	W !,"     AJCC STAGE.....................: ",ONC(165.5,IE,38) D P Q:EX=U
	W ! D P Q:EX=U
	W !,"36. ULCERATION......................: ",ONC(165.5,IE,1118) D P Q:EX=U
	W !,"37. CLINICALLY AMELANOTIC...........: ",ONC(165.5,IE,1119) D P Q:EX=U
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCMPC0 W !?4,TABLE_" (continued)",!?4,LINE G APS
	I IOST'?1"C".E W !
APS	W !,"38. AJCC PATHOLOGIC STAGE (pTNM):" D P Q:EX=U
	W !,"     T-CODE.........................: ",ONC(165.5,IE,85) D P Q:EX=U
	W !,"     N-CODE.........................: ",ONC(165.5,IE,86) D P Q:EX=U
	W !,"     M-CODE.........................: ",ONC(165.5,IE,87)
	W !,"     AJCC STAGE.....................: ",ONC(165.5,IE,88)
	W ! D P Q:EX=U
SB	W !,"39. STAGED BY:" D P Q:EX=U
	W !,"     CLINICAL STAGE.................: ",ONC(165.5,IE,19) D P Q:EX=U
	W !,"     PATHOLOGIC STAGE...............: ",ONC(165.5,IE,89) D P Q:EX=U
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCMPC0 G IV
	D P Q:EX=U
IV	S TABLE="TABLE IV - FIRST COURSE OF TREATMENT"
	I IOST'?1"C".E W ! I ($Y'<(LIN-4)) D HEAD^ONCMPC0
	K LINE S $P(LINE,"-",36)="-"
	W !?4,TABLE,!?4,LINE D P Q:EX=U
	K LINE S $P(LINE,"-",48)="-"
	S D0=ONCONUM D DFC^ONCOCOM S DOFCT=Y
	W !,"40. PROTOCOL ELIGIBILITY STATUS.....: ",ONC(165.5,IE,346) D P Q:EX=U
	W !,"41. PROTOCOL PARTICIPATION..........: ",ONC(165.5,IE,560) D P Q:EX=U
	W !,"42. DATE OF FIRST COURSE TREATMENT..: ",DOFCT D P Q:EX=U
	W !!?4,"SURGERY",!?4,"-------" D P Q:EX=U
	W !?4,"NON CANCER-DIRECTED SURGERY",!?4,"---------------------------" D P Q:EX=U
	S NCDS=ONC(165.5,IE,58.1)
	S (NCDS1,NCDS2)="",LOS=$L(NCDS) I LOS<44 S NCDS1=NCDS G NCDS
	S NOP=$L($E(NCDS,1,42)," ")
	S NCDS1=$P(NCDS," ",1,NOP-1),NCDS2=$P(NCDS," ",NOP,999)
NCDS	S CDS=ONC(165.5,IE,58.2)
	S (CDS1,CDS2)="",LOS=$L(CDS) I LOS<44 S CDS1=CDS G S
	S NOP=$L($E(CDS,1,42)," ")
	S CDS1=$P(CDS," ",1,NOP-1),CDS2=$P(CDS," ",NOP,999)
S	W !,"43. DATE OF NON CA-DIRECTED SURGERY.: ",ONC(165.5,IE,58.3) D P Q:EX=U
	W !,"44. NON CANCER-DIRECTED SURGERY.....: ",NCDS1 W:NCDS2'="" !,?38,NCDS2 D P Q:EX=U
	W !,"45. TYPE OF BIOSPY..................: ",ONC(165.5,IE,1109) D P Q:EX=U
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCMPC0 W !?4,TABLE_" (continued)",!?4,LINE G CDS
	W ! D P Q:EX=U
CDS	W !?4,"CANCER-DIRECTED SURGERY",!?4,"-----------------------" D P Q:EX=U
	W !,"46. DATE OF CANCER-DIRECTED SURGERY.: ",ONC(165.5,IE,50) D P Q:EX=U
	W !,"47. SURGICAL APPROACH...............: ",ONC(165.5,IE,74) D P Q:EX=U
	W !,"48. SURGERY OF PRIMARY SITE.........: ",CDS1 W:CDS2'="" !,?38,CDS2
	S SM=ONC(165.5,IE,59)
	S (SM1,SM2)="",LOS=$L(SM) I LOS<44 S SM1=SM G SM
	S NOP=$L($E(SM,1,42)," "),SM1=$P(SM," ",1,NOP-1),SM2=$P(SM," ",NOP,999)
SM	W !,"49. SURGICAL MARGINS................: ",SM1 W:SM2'="" !,?38,SM2 D P Q:EX=U
	W !,"50. DISTANCE FROM TUMOR TO EDGE OF"
	W !,"    SPECIMEN........................: ",ONC(165.5,IE,1120) D P Q:EX=U
	W !,"51. SCOPE OF LYMPH NODE SURGERY.....: ",ONC(165.5,IE,138) D P Q:EX=U
	W !,"52. NUMBER OF LYMPH NODES REMOVED...: ",ONC(165.5,IE,140) D P Q:EX=U
	S SORS=ONC(165.5,ONCONUM,139)
	S (SORS1,SORS2)="",LOS=$L(SORS) I LOS<44 S SORS1=SORS G SORS
	S NOP=$L($E(SORS,1,42)," ")
	S SORS1=$P(SORS," ",1,NOP-1),SORS2=$P(SORS," ",NOP,999)
SORS	W !,"53. SURGERY OF OTHER REGIONAL SITE(S), DISTANT SITE(S),"
	W !,"    OR DISTANT LYMPH NODE(S)........: ",SORS1 W:SORS2'="" !,?38,SORS2 D P Q:EX=U
	W !,"54. RECONSTRUCTION/RESTORATION......: ",ONC(165.5,IE,23) D P Q:EX=U
	W !,"55. SURGICAL CLOSURE................: ",ONC(165.5,IE,1121) D P Q:EX=U
	W !,"56. REASON FOR NO SURGERY...........: ",ONC(165.5,IE,58) D P Q:EX=U
	W !!?4,"SENTINEL NODES",!?4,"--------------" D P Q:EX=U
	W !,"57. PRE-OP LYMPHOSCINTIGRAPHY.......: ",ONC(165.5,IE,1122) D P Q:EX=U
	W !,"58. SENTINEL NODES DETECTED BY......: ",ONC(165.5,IE,1123) D P Q:EX=U
	W !,"59. SENTINEL NODE BIOPSY............: ",ONC(165.5,IE,943) D P Q:EX=U
	W !,"60. SENTINEL NODES EXAMINED.........: ",ONC(165.5,IE,1124) D P Q:EX=U
	W !,"61. SENTINEL NODES POSITIVE.........: ",ONC(165.5,IE,1125) D P Q:EX=U
	W !,"62. HOW WAS SENTINEL NODE"
	W !,"    PATHOLOGICALLY EXAMINED.........: ",ONC(165.5,IE,1126) D P Q:EX=U
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCMPC0 W !?4,TABLE_" (continued)",!?4,LINE G ISNP
	W ! D P Q:EX=U
ISNP	W !,"63. IF SENTINEL NODE(S) POSITIVE:"
	W !,"      WAS COMPLETE LYMPH NODE"
	W !,"      DISSECTION PERFORMED..........: ",ONC(165.5,IE,1127) D P Q:EX=U 
	W !,"      NUMBER OF BASINS DETECTED.....: ",ONC(165.5,IE,1128) D P Q:EX=U 
	W !,"      NUMBER OF BASINS POSITIVE.....: ",ONC(165.5,IE,1129) D P Q:EX=U 
	W ! D P Q:EX=U
R	W !?4,"RADIATION THERAPY",!?4,"-----------------" D P Q:EX=U
	W !,"64. DATE RADIATION STARTED..........: ",ONC(165.5,IE,51) D P Q:EX=U
	W !,"65. RADIATION THERAPY...............: ",ONC(165.5,IE,51.2) D P Q:EX=U
	W !,"66. REASON FOR NO RADIATION ........: ",ONC(165.5,IE,75) D P Q:EX=U
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCMPC0 W !?4,TABLE_" (continued)",!?4,LINE G C
	W ! D P Q:EX=U
C	W !?4,"CHEMOTHERAPY",!?4,"------------" D P Q:EX=U
	W !,"67. DATE CHEMOTHERAPY STARTED.......: ",ONC(165.5,IE,53) D P Q:EX=U
	W !,"68. CHEMOTHERAPY....................: ",ONC(165.5,IE,53.2) D P Q:EX=U
	W !,"69. INTRAVENOUS THERAPY.............: ",ONC(165.5,IE,1130) D P Q:EX=U
	W ! D P Q:EX=U
H	W !,"    HORMONE THERAPY"
	W !,"    ---------------"
	W !,"70. DATE HORMONE THERAPY STARTED....: ",ONC(165.5,IE,54) D P Q:EX=U
	W !,"71. HORMONE THERAPY.................: ",ONC(165.5,IE,54.2) D P Q:EX=U
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCMPC0 G V
	W ! D P Q:EX=U
V	D ^ONCMPC9B
KILL	;Kill Variables and Exit
	K %,DIR,DIROUT,DIRUT,DTOUT,DUOUT,FILN,ONCOBL,EX,TXT,X,Y
	Q
P	;Display Data
	I ($Y'<(LIN-1)) D  Q:EX=U  W !?4,TABLE_" (continued)",!?4,LINE
	.I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR I 'Y S EX=U Q
	.D HEAD^ONCMPC0 Q
	Q
