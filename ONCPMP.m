ONCPMP	;Hines OIFO/GWB - PROSTATE Performance Measures ;09/26/11
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	;
	N DIE,DNT,I,X,Y
	S DIE="^ONCO(165.5,",DA=ONCONUM
	S DNT=$P($G(^ONCO(165.5,ONCONUM,2.1)),U,11)
	I DNT'="" D
	.S:$P($G(^ONCO(165.5,ONCONUM,"PM")),U,25)="" $P(^ONCO(165.5,ONCONUM,"PM"),U,25)=0
	.S:$P($G(^ONCO(165.5,ONCONUM,"PM")),U,27)="" $P(^ONCO(165.5,ONCONUM,"PM"),U,27)=0
	.S:$P($G(^ONCO(165.5,ONCONUM,"BLA2")),U,41)="" $P(^ONCO(165.5,ONCONUM,"BLA2"),U,41)=0
	K DIR D HEAD
	S DR=""
	S DR(1,165.5,1)="275"
	S DR(1,165.5,2)="276"
	S DR(1,165.5,3)="277"
	S DR(1,165.5,4)="278"
	S DR(1,165.5,5)="382"
	D ^DIE
	W !
	K DIR S DIR(0)="E" D ^DIR S:$D(DIRUT) OUT="Y"
	Q
	;
HEAD	;PCE header
	W @IOF
	W DASHES,!
	W ?1,PATNAM,?SITTAB,SITEGP
	W !
	W ?1,SSN,?TOPTAB,TOPNAM," ",TOPCOD
	W !,DASHES
	S HDL=$L("Performance Measures for Cancer of the Prostate")
	S TAB=(80-HDL)\2,TAB=TAB-1
	W !,?TAB,"Performance Measures for Cancer of the Prostate"
	W !,DASHES
	N DI,DIC,DR,DA,DIQ,ONC
	S DA=ONCONUM
	S DIC="^ONCO(165.5,"
	S DR="275:278;382"
	S DIQ="ONC" D EN^DIQ1
	F I=275,276,277,278,382 S X=ONC(165.5,ONCONUM,I) D UCASE S ONC(165.5,ONCONUM,I)=X
	W !," Risk of recurrence............: ",ONC(165.5,ONCONUM,275)
	W !," Androgen Deprivation Therapy..: ",ONC(165.5,ONCONUM,276)
	W !," Date ADT initiated............: ",ONC(165.5,ONCONUM,277)
	W !," Non-ADT Chemotherapy..........: ",ONC(165.5,ONCONUM,278)
	W !," Reason Chemotherapy Stopped...: ",ONC(165.5,ONCONUM,382)
	W !,DASHES
	Q
	;
UCASE	;Mixed case to uppercase conversion
	S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
	Q
	;
EXIT	;Kill variables and exit
	K HDL,ONCONUM,OUT,TAB
	K DIC,DIR,DIROUT,DIRUT,DLAYGO,DTOUT,DUOUT,X,Y
	Q
	;
CLEANUP	;Cleanup
	K DASHES,PATNAM,SITEGP,SITTAB,SSN,TOPCOD,TOPNAM,TOPTAB
	Q
