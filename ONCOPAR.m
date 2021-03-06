ONCOPAR	;Hines OIFO/GWB - [ANN *..Annual Reports ...] ;03/03/00
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
HEAD	;HEADER
	W @IOF,!!!?10,ONCO
	Q
ANN	;Select year
	K DIR S YR=$E(DT,1)+17_$E(DT,2,3)
	W ! S DIR("A")=" Select year",DIR("B")=YR-1,DIR(0)="F^4:4" D ^DIR
	Q:$D(DIRUT)
	G ANN:Y'?1.N,ANN:Y>YR S YR=Y,FR=Y-.1,TO=Y W !! Q
	;
AAR	;[AAR Annual ACOS Accession Register (80c)]
	D ANN G EX:Y[U
	S BY="@#ACCESSION YEAR,ACC/SEQ NUMBER",FLDS="[ONCO ANNUAL ACCREG80]",L=0
	D PRT655
	Q
	;
API	;ANNUAL PATIENT INDEX
	S ONCO="ANNUAL Patient Index - ACOS Required (132col)" D HEAD W !! D ANN G EX:$D(DIRUT)
	S BY="#@ACCESSION YEAR,@PATIENT NAME",FLDS="[ONCO ANNUAL PATIENT INDX]",L=0
	D PRT655
	Q
	;
ACL	;ANNUAL BY CLASS OF CASE PATIENT REGISTER
	S ONCO="ANNUAL Patient List by Class of Case (80c)" D HEAD W !! D ANN G EX:$D(DIRUT)
	S BY="@ACCESSION YEAR,+#@CLASS CATEGORY,+CLASS OF CASE,@PATIENT NAME",FLDS="[ONCO ANNUAL CLASS/PATIENT]",L=0
	D PRT655
	Q
	;
AST	;ANNUAL ANALYTIC SITE/ICDO-TOPOGRAPHY/ICDO-MORPHOLOGY
	S ONCO="ANNUAL Site/Gp Listing by ICDO-Topography/Histology" D HEAD W !! D ANN G EX:$D(DIRUT)
	I YR<2001 S BY="@ACCESSION YEAR,+@CLASS CATEGORY,#SITE/GP;S1;C20,+PRIMARY SITE;C12,+HISTOLOGY (ICD-O-2);C9"
	I YR>2000 S BY="@ACCESSION YEAR,+@CLASS CATEGORY,#SITE/GP;S1;C20,+PRIMARY SITE;C12,+HISTOLOGY (ICD-O-3);C9"
	S FLDS="[ONCO ANNUAL SITE/ICDT/ICDM]",L=0
	D PRT655
	Q
	;
APS	;ANNUAL SITE/GP INDEX
	S ONCO="ANNUAL Site/GP Index by ICDO-Topography (132)" D HEAD W !!
	S BY="@ACCESSION YEAR,@CLASS CATEGORY,#@SITE/GP",(FR,TO)="?,,?",FLDS="[ONCO ANNUAL SITE/GP]"
	D PRT655
	Q
	;
SST	;Site/Stage/Treatment
	S BY="[ONCO ANNUAL SITE/STAGE/TX]" G PRT655
	;
TST	;ICDO Topography/Stage/Treatment
	S BY="[ONCO ANNUAL ICDO/STAGE/TX]" G PRT655
	;
HIS	;Histology/Site/Icdo
	S BY="[ONCO ANNUAL HIST/SITE/ICDO]",FLDS="[ONCO ANNUAL PATIENT INFO]" G PRT655
SDX	;STATUS/SITE/GP/DX-AGE GP
	W @IOF,!!!?10,"Annual report - sorted first by Accession year",!?10,"Then by Class Category (Non-analytic/Analytic)"
	W !?10,"Then by Status, Site/GP, and Diagnosis Age Gp.",!!!,?15,"Enter four digit ACCESSION YEAR,",!?15,"for Class category: either 'A'"
	W !?15,"for Analytic, or first to last.",!!!
	S BY="[ONCO ANN/ANAL/STA/SITE/DX AGE]",FLDS="[ONCO PRIMARY INFORMATION]"
	G PRT655
	;
CPR	;PRINT CUSTOM REPORTS
	W @IOF
	W !,"    You may create custom FileMan reports for the following files."
	W !,"    See the VA FileMan User Manual for detailed instructions."
	D SEL^ONCOSO G EX:$D(DIRUT)
	W !!," CREATE CUSTOM REPORT for "_ONCOF_" file",! S L=1,DIASKHD="" D EN1^DIP G EX
	;
CDD1	;[CDD1 Print Condensed DD--Oncology Patient file]
	S DIC="^ONCO(160,",DIFORMAT="CONDENSED" D EN^DID G EX
	;
CDD2	;[CDD2 Print Condensed DD--Oncology Primary file]
	S DIC="^ONCO(165.5,",DIFORMAT="CONDENSED" D EN^DID G EX
	;
PRT60	;setup for print from #160
	S DIC="^ONCO(160,",L=0 D EN1^DIP G EX
PRT655	;setup for print from #165.5
	S DIC="^ONCO(165.5,",L=0 D EN1^DIP G EX
PRT65	;setup for print from #165
	S DIC="^ONCO(165,",L=0 D EN1^DIP G EX
	;
KIL	K DIC,DIR,DN,DXS,BY,DIOT,FR,L,TO,YR,ONCOF,ONCO,ONCON,ONCOX,%DT,F,O,W
	K GL,P,TD,%ZISOS,PD0,TX,ONCO,B,%DTF,T,XX,%T,M,ONCOYR
	Q
EX	;Kill and Exit
	D KIL D ^%ZISC S IOP=ION D ^%ZIS
	Q
