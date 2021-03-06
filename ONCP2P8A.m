ONCP2P8A	;HINES CIOFO/GWB - 1998 Prostate Cancer Study - print ;6/1/98
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
III	S TABLE="TABLE III - EXTENT AND STAGE OF DISEASE"
	I IOST'?1"C".E W ! I ($Y'<(LIN-4)) D HEAD^ONCP2P0
	W !?4,TABLE,!?4,"---------------------------------------" D P Q:EX=U
	W !,"27. SIZE OF TUMOR (mm)...............: ",ONC(165.5,IE,29) D P Q:EX=U
	W !,"28. REGIONAL NODES EXAMINED..........: ",ONC(165.5,IE,33) D P Q:EX=U
	W !,"29. REGIONAL NODES POSITIVE..........: ",ONC(165.5,IE,32) D P Q:EX=U
ACS	W !!,"30. AJCC CLINICAL STAGE (cTNM):" D P Q:EX=U
	W !,"     T-CODE..........................: ",ONC(165.5,IE,37.1) D P Q:EX=U
	W !,"     N-CODE..........................: ",ONC(165.5,IE,37.2) D P Q:EX=U
	W !,"     M-CODE..........................: ",ONC(165.5,IE,37.3) D P Q:EX=U
	W !,"     AJCC STAGE......................: ",ONC(165.5,IE,38) D P Q:EX=U
APS	W !!,"31. AJCC PATHOLOGIC STAGE (pTNM):" D P Q:EX=U
	W !,"     T-CODE..........................: ",ONC(165.5,IE,85) D P Q:EX=U
	W !,"     N-CODE..........................: ",ONC(165.5,IE,86) D P Q:EX=U
	W !,"     M-CODE..........................: ",ONC(165.5,IE,87)
	W !,"     AJCC STAGE......................: ",ONC(165.5,IE,88)
	K LINE S $P(LINE,"-",51)="-"
	I IOST?1"C".E K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCP2P0 W !?4,TABLE_" (continued)",!?4,LINE G SB
	W ! D P Q:EX=U
SB	W !,"32. STAGED BY:" D P Q:EX=U
	W !,"     CLINICAL STAGE..................: ",ONC(165.5,IE,19) D P Q:EX=U
	W !,"     PATHOLOGIC STAGE................: ",ONC(165.5,IE,89) D P Q:EX=U
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCP2P0 G IV
	D P Q:EX=U
IV	S TABLE="TABLE IV - FIRST COURSE OF TREATMENT"
	I IOST'?1"C".E W ! I ($Y'<(LIN-4)) D HEAD^ONCP2P0
	K LINE S $P(LINE,"-",36)="-"
	W !?4,TABLE,!?4,LINE D P Q:EX=U
	K LINE S $P(LINE,"-",48)="-"
	S D0=ONCONUM D DFC^ONCOCOM S DOFCT=Y
	W !,"33. DATE OF FIRST COURSE TREATMENT...: ",DOFCT D P Q:EX=U
	W !,"34. EXPECTED MGT/WATCHFUL WAITING....: ",ONC(165.5,IE,685) D P Q:EX=U
	W !!?4,"SURGERY",!?4,"-------" D P Q:EX=U
	W !?4,"NON CANCER-DIRECTED SURGERY",!?4,"---------------------------" D P Q:EX=U
	S NCDS=ONC(165.5,IE,58.1)
	S (NCDS1,NCDS2)="",LOS=$L(NCDS) I LOS<43 S NCDS1=NCDS G CDS
	S NOP=$L($E(NCDS,1,41)," ")
	S NCDS1=$P(NCDS," ",1,NOP-1),NCDS2=$P(NCDS," ",NOP,999)
CDS	S CDS=ONC(165.5,IE,58.2)
	S (CDS1,CDS2)="",LOS=$L(CDS) I LOS<43 S CDS1=CDS G S
	S NOP=$L($E(CDS,1,41)," ")
	S CDS1=$P(CDS," ",1,NOP-1),CDS2=$P(CDS," ",NOP,999)
S	W !,"35. DATE OF NON CA-DIRECTED SURGERY..: ",ONC(165.5,IE,58.3) D P Q:EX=U
	W !,"36. NON CANCER-DIRECTED SURGERY......: ",NCDS1 W:NCDS2'="" !,?39,NCDS2 D P Q:EX=U
	W !!?4,"CANCER-DIRECTED SURGERY",!?4,"-----------------------" D P Q:EX=U
	W !,"37. DATE OF CANCER-DIRECTED SURGERY..: ",ONC(165.5,IE,50) D P Q:EX=U
	W !,"38. LENGTH OF STAY AFTER SURGERY.....: ",ONC(165.5,IE,686) D P Q:EX=U
	W !,"39. SURGICAL APPROACH................: ",ONC(165.5,IE,74) D P Q:EX=U
	W !,"40. TYPE OF CANCER-DIRECTED SURGERY..: ",CDS1 W:CDS2'="" !,?39,CDS2
	S SM=ONC(165.5,IE,59)
	S (SM1,SM2)="",LOS=$L(SM) I LOS<43 S SM1=SM G SM
	S NOP=$L($E(SM,1,41)," "),SM1=$P(SM," ",1,NOP-1),SM2=$P(SM," ",NOP,999)
SM	W !,"41. SURGICAL MARGINS.................: ",SM1 W:SM2'="" !,?39,SM2 D P Q:EX=U
	W !,"42. SCOPE OF LYMPH NODE SURGERY......: ",ONC(165.5,IE,138) D P Q:EX=U
	W !!,"43. TYPE OF LYMPH NODE SURGERY:" D P Q:EX=U
	W !,"     LAPAROSCOPIC....................: ",ONC(165.5,IE,687) D P Q:EX=U
	W !,"     OPEN............................: ",ONC(165.5,IE,688) D P Q:EX=U
	S SORS=ONC(165.5,ONCONUM,139)
	S (SORS1,SORS2)="",LOS=$L(SORS) I LOS<43 S SORS1=SORS G SORS
	S NOP=$L($E(SORS,1,41)," ")
	S SORS1=$P(SORS," ",1,NOP-1),SORS2=$P(SORS," ",NOP,999)
SORS	W !!,"44. SURGERY OF OTHER REGIONAL SITE(S), DISTANT SITE(S),"
	W !,"    OR DISTANT LYMPH NODE(S).........: ",SORS1 W:SORS2'="" !,?39,SORS2 D P Q:EX=U
	W !,"45. NUMBER OF LYMPH NODES REMOVED....: ",ONC(165.5,IE,140) D P Q:EX=U
	W !,"46. RECONSTRUCTION/RESTORATION.......: ",ONC(165.5,IE,23) D P Q:EX=U
	W !!,"47. COMPLICATIONS FOLLOWING SURGICAL FIRST COURSE OF TREATMENT:" D P Q:EX=U
	W !,"     PERMANENT RECTAL INJURY.........: ",ONC(165.5,IE,689) D P Q:EX=U
	W !,"     THROMBOEMBOLISM.................: ",ONC(165.5,IE,690) D P Q:EX=U
	W !,"     URETHRAL STRICTURE..............: ",ONC(165.5,IE,691) D P Q:EX=U
	W !!,"48. POSTOPERATIVE DEATH W/I 30 DAYS..: ",ONC(165.5,IE,441)
R	W !!?4,"RADIATION THERAPY",!?4,"-----------------" D P Q:EX=U
	W !,"49. DATE RADIATION STARTED...........: ",ONC(165.5,IE,51) D P Q:EX=U
	W !,"50. RADIATION THERAPY................: ",ONC(165.5,IE,51.2) D P Q:EX=U
	W !,"51. RADIATION FACILITY...............: ",ONC(165.5,IE,692) D P Q:EX=U
	W !!,"52. INTERSTITIAL RADIATION/BRACHYTHERAPY ADMINISTERED:" D P Q:EX=U
	W !,"     GOLD 198........................: ",ONC(165.5,IE,628) D P Q:EX=U
	W !,"     IODINE 125......................: ",ONC(165.5,IE,627) D P Q:EX=U
	W !,"     IRIDIUM 192.....................: ",ONC(165.5,IE,630) D P Q:EX=U
	W !,"     OTHER INTERSTITIAL, NOS.........: ",ONC(165.5,IE,631) D P Q:EX=U
	W !,"     PALLADIUM 103...................: ",ONC(165.5,IE,629) D P Q:EX=U
	W !!,"53. ROUTE OF INTERSTITIAL RADIATION/"
	W !,"    BRACHYTHERAPY ADMINISTERED.......: ",ONC(165.5,IE,693) D P Q:EX=U
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCP2P0 W !?4,TABLE_" (continued)",!?4,LINE G ERA
	W ! D P Q:EX=U
ERA	W !,"54. EXTERNAL RADIATION ADMINISTERED:"
	W !,"     DISTANT METASTATIC SITES........: ",ONC(165.5,IE,636) D P Q:EX=U
	W !,"     PROSTATE & PELVIC NODES.........: ",ONC(165.5,IE,634) D P Q:EX=U
	W !,"     PROSTATE & PARA-AORTIC NODES....: ",ONC(165.5,IE,635) D P Q:EX=U
	W !,"     PROSTATE REGION ONLY............: ",ONC(165.5,IE,633) D P Q:EX=U
	W !,"     OTHER EXTERNAL SITES, NOS.......: ",ONC(165.5,IE,637) D P Q:EX=U
	W !!,"55. TYPE OF EXTERNAL RADIATION"
	W !,"    ADMINISTRATION...................: ",ONC(165.5,IE,694) D P Q:EX=U
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCP2P0 W !?4,TABLE_" (continued)",!?4,LINE G TERDIB
	W ! D P Q:EX=U
TERDIB	W !,"56. TOTAL EXTERNAL RAD DOSE (cGy) INCLUDING BOOST:"
	W !,"     PROSTATE........................: ",ONC(165.5,IE,638) D P Q:EX=U
	W !,"     PELVIC NODES....................: ",ONC(165.5,IE,639) D P Q:EX=U
	W !,"     PARA-AORTIC NODES...............: ",ONC(165.5,IE,640) D P Q:EX=U
	W !!,"57. COMPLICATIONS FOLLOWING RADIATION FIRST COURSE OF TREATMENT:"
	W !,"     ACUTE GASTROINTESTINAL..........: ",ONC(165.5,IE,695) D P Q:EX=U
	W !,"     ACUTE GASTROURINARY.............: ",ONC(165.5,IE,696) D P Q:EX=U
	W !,"     ANORECTAL.......................: ",ONC(165.5,IE,697) D P Q:EX=U
	W !,"     CHRONIC REQUIRING SURGERY OR"
	W !,"     PROLONGED HOSPITALIZATION.......: ",ONC(165.5,IE,698) D P Q:EX=U
	W !,"     URETHRAL OR BLADDER.............: ",ONC(165.5,IE,699) D P Q:EX=U
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCP2P0 W !?4,TABLE_" (continued)",!?4,LINE G H
	W ! D P Q:EX=U
H	W !,"    HORMONE THERAPY"
	W !,"    ---------------"
	W !,"58. DATE OF ORCHIECTOMY.............: ",ONC(165.5,IE,699.1) D P Q:EX=U
	W !,"59. DATE EXOGENOUS HT BEGAN.........: ",ONC(165.5,IE,54) D P Q:EX=U
	W !,"60. HORMONE THERAPY.................: ",ONC(165.5,IE,54.2) D P Q:EX=U
	W !!,"61. EXOGENOUS HORMONE AGENTS ADMINISTERED:"
	W !,"     ANTIANDROGENS...................: ",ONC(165.5,IE,644) D P Q:EX=U
	W !,"     ESTROGENS.......................: ",ONC(165.5,IE,643) D P Q:EX=U
	W !,"     LUTEINIZING HORMONES............: ",ONC(165.5,IE,646) D P Q:EX=U
	W !,"     PROGESTATIONAL AGENTS...........: ",ONC(165.5,IE,645) D P Q:EX=U
	W !,"     OTHER...........................: ",ONC(165.5,IE,648) D P Q:EX=U
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCP2P0 W !?4,TABLE_" (continued)",!?4,LINE G C
	W ! D P Q:EX=U
C	W !?4,"CHEMOTHERAPY",!?4,"------------" D P Q:EX=U
	W !,"62. DATE CHEMOTHERAPY STARTED........: ",ONC(165.5,IE,53) D P Q:EX=U
	W !,"63. CHEMOTHERAPY.....................: ",ONC(165.5,IE,53.2) D P Q:EX=U
	I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR Q:'Y  D HEAD^ONCP2P0 G V
	D P Q:EX=U
V	D ^ONCP2P8B
KILL	;Kill Variables and Exit
	K %,DIR,DIROUT,DIRUT,DTOUT,DUOUT,FILN,ONCOBL,EX,TXT,X,Y
	Q
P	;Display Data
	I ($Y'<(LIN-1)) D  Q:EX=U  W !?4,TABLE_" (continued)",!?4,LINE
	.I IOST?1"C".E W ! K DIR S DIR(0)="E" D ^DIR I 'Y S EX=U Q
	.D HEAD^ONCP2P0 Q
	Q
