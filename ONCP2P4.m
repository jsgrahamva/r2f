ONCP2P4	;HINES CIOFO/GWB - 1998 Prostate Cancer Study - Table IV ;6/1/98
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	K TABLE,HTABLE
	S TABLE("SURGERY")="S^ONCP2P4"
	S TABLE("NON CANCER-DIRECTED SURGERY")="NCS^ONCP2P4"
	S TABLE("CANCER-DIRECTED SURGERY")="CS^ONCP2P4"
	S TABLE("RADIATION THERAPY")="RT^ONCP2P4A"
	S TABLE("HORMONE THERAPY")="HOT^ONCP2P4A"
	S TABLE("CHEMOTHERAPY")="CT^ONCP2P4A"
	S HTABLE(1)="SURGERY"
	S HTABLE(2)="NON CANCER-DIRECTED SURGERY"
	S HTABLE(3)="CANCER-DIRECTED SURGERY"
	S HTABLE(4)="RADIATION THERAPY"
	S HTABLE(5)="HORMONE THERAPY"
	S HTABLE(6)="CHEMOTHERAPY"
	S CHOICES=6
	W @IOF D HEAD^ONCP2P0
	W !," TABLE IV - FIRST COURSE OF TREATMENT"
	W !," ------------------------------------"
	K DIQ,ONC S DIC="^ONCO(165.5,"
	S DR="23;49;50;51;51.2;53;53.2;54;54.2;58.1;58.2;58.3;58;59;74;138;139;140"
	S DA=ONCONUM,DIQ="ONC" D EN^DIQ1
	S DIE="^ONCO(165.5,",DA=ONCONUM
	S CDS=ONC(165.5,ONCONUM,58.2)
	S RAD=$P($G(^ONCO(165.5,ONCONUM,3)),U,6)
	S HOR=$P($G(^ONCO(165.5,ONCONUM,3)),U,16)
DFCT	W !," 33. DATE OF FIRST COURSE TREATMENT.: ",ONC(165.5,ONCONUM,49)
EMWW	S DR="685 34. EXPECTED MGT/WATCHFUL WAITING.." D ^DIE G:$D(Y) JUMP
S	W @IOF D HEAD^ONCP2P0
	W !," SURGERY",!
	W " -------"
NCS	W !," NON CANCER-DIRECTED SURGERY",!
DNCDS	W !," 35. DATE OF NON CA-DIRECTED SURGERY: ",ONC(165.5,ONCONUM,58.3)
NCDS	S NCDS=ONC(165.5,ONCONUM,58.1)
	S (NCDS1,NCDS2)="",LOS=$L(NCDS) I LOS<42 S NCDS1=NCDS G NCDS1
	S NOP=$L($E(NCDS,1,41)," ")
	S NCDS1=$P(NCDS," ",1,NOP-1),NCDS2=$P(NCDS," ",NOP,999)
NCDS1	W !," 36. NON CANCER-DIRECTED SURGERY....: ",NCDS1 W:NCDS2'="" !,?38,NCDS2
CS	W !," CANCER-DIRECTED SURGERY",!
DCDS	W !," 37. DATE OF CANCER-DIRECTED SURGERY: ",ONC(165.5,ONCONUM,50)
LSAS	I $E(CDS,1,2)="00" D  G SA
	.S $P(^ONCO(165.5,D0,"PRO2"),U,30)=88
	.W !," 38. LENGTH OF STAY AFTER SURGERY...: 88 NA"
	I $E(CDS,1,2)=99 D  G SA
	.S $P(^ONCO(165.5,D0,"PRO2"),U,30)=99
	.W !," 38. LENGTH OF STAY AFTER SURGERY...: 99 Unknown"
	S DR="686 38. LENGTH OF STAY AFTER SURGERY..." D ^DIE G:$D(Y) JUMP
SA	S SA=ONC(165.5,ONCONUM,74)
	S (SA1,SA2)="",LOS=$L(SA) I LOS<42 S SA1=SA G SA1
	S NOP=$L($E(SA,1,41)," "),SA1=$P(SA," ",1,NOP-1),SA2=$P(SA," ",NOP,999)
SA1	W !," 39. SURGICAL APPROACH..............: ",SA1 W:SA2'="" !,?38,SA2
TCDS	S (CDS1,CDS2)="",LOS=$L(CDS) I LOS<42 S CDS1=CDS G TCDS1
	S NOP=$L($E(CDS,1,41)," ")
	S CDS1=$P(CDS," ",1,NOP-1),CDS2=$P(CDS," ",NOP,999)
TCDS1	W !," 40. TYPE OF CANCER-DIRECTED SURGERY: ",CDS1 W:CDS2'="" !,?38,CDS2
SM	S SM=ONC(165.5,ONCONUM,59)
	S (SM1,SM2)="",LOS=$L(SM) I LOS<42 S SM1=SM G SM1
	S NOP=$L($E(SM,1,41)," "),SM1=$P(SM," ",1,NOP-1),SM2=$P(SM," ",NOP,999)
SM1	W !," 41. SURGICAL MARGINS...............: ",SM1 W:SM2'="" !,?38,SM2
SLNS	W !," 42. SCOPE OF LYMPH NODE SURGERY....: ",ONC(165.5,ONCONUM,138)
	I ($E(CDS,1,2)="00")!($E(CDS,1,2)=99) W ! K DIR S DIR(0)="E" D ^DIR G:$D(DIRUT) EXIT W @IOF D HEAD^ONCP2P0 G TLNS
	W !
TLNS	W !," 43. TYPE OF LYMPH NODE SURGERY:",!
	I $E(CDS,1,2)="00" D  G:$D(DIRUT) EXIT G SORS
	.S $P(^ONCO(165.5,D0,"PRO2"),U,31)=8
	.S $P(^ONCO(165.5,D0,"PRO2"),U,32)=8
	.W !,"     LAPAROSCOPIC...................: NA"
	.W !,"     OPEN...........................: NA"
	I $E(CDS,1,2)=99 D  G:$D(DIRUT) EXIT G SORS
	.S $P(^ONCO(165.5,D0,"PRO2"),U,31)=9
	.S $P(^ONCO(165.5,D0,"PRO2"),U,32)=9
	.W !,"     LAPAROSCOPIC...................: Unknown"
	.W !,"     OPEN...........................: Unknown"
	S DR="687     LAPAROSCOPIC..................." D ^DIE G:$D(Y) JUMP
	S DR="688     OPEN..........................." D ^DIE G:$D(Y) JUMP
SORS	S SORS=ONC(165.5,ONCONUM,139)
	S (SORS1,SORS2)="",LOS=$L(SORS) I LOS<42 S SORS1=SORS G SORS1
	S NOP=$L($E(SORS,1,41)," ")
	S SORS1=$P(SORS," ",1,NOP-1),SORS2=$P(SORS," ",NOP,999)
SORS1	W !!," 44. SURGERY OF OTHER REGIONAL SITE(S), DISTANT SITE(S),"
	W !,"     OR DISTANT LYMPH NODE(S).......: ",SORS1 W:SORS2'="" !,?38,SORS2
NLNR	W !," 45. NUMBER OF LYMPH NODES REMOVED..: ",ONC(165.5,ONCONUM,140)
RR	W !," 46. RECONSTRUCTION/RESTORATION.....: ",ONC(165.5,ONCONUM,23)
CFSFCT	W !!," 47. COMPLICATIONS FOLLOWING SURGICAL FIRST COURSE OF TREATMENT:",!
	I $E(CDS,1,2)="00" D  G:$D(DIRUT) EXIT G PRTC
	.S $P(^ONCO(165.5,D0,"PRO2"),U,33)=8
	.S $P(^ONCO(165.5,D0,"PRO2"),U,34)=8
	.S $P(^ONCO(165.5,D0,"PRO2"),U,35)=8
	.S $P(^ONCO(165.5,D0,"THY1"),U,42)=8
	.W !,"     PERMANENT RECTAL INJURY........: NA, no surgery"
	.W !,"     THROMBOEMBOLISM................: NA, no surgery"
	.W !,"     URETHRAL STRICTURE.............: NA, no surgery"
	.W ! K DIR S DIR(0)="E" D ^DIR Q:$D(DIRUT)  W @IOF D HEAD^ONCP2P0
	.W !!," 48. POSTOPERATIVE DEATH W/I 30 DAYS: NA, no surgery"
	I $E(CDS,1,2)=99 D  G:$D(DIRUT) EXIT G PRTC
	.S $P(^ONCO(165.5,D0,"PRO2"),U,33)=9
	.S $P(^ONCO(165.5,D0,"PRO2"),U,34)=9
	.S $P(^ONCO(165.5,D0,"PRO2"),U,35)=9
	.S $P(^ONCO(165.5,D0,"THY1"),U,42)=9
	.W !,"     PERMANENT RECTAL INJURY........: Unknown"
	.W !,"     THROMBOEMBOLISM................: Unknown"
	.W !,"     URETHRAL STRICTURE.............: Unknown"
	.W ! K DIR S DIR(0)="E" D ^DIR Q:$D(DIRUT)  W @IOF D HEAD^ONCP2P0
	.W !!," 48. POSTOPERATIVE DEATH W/I 30 DAYS: Unknown"
	S DR="689     PERMANENT RECTAL INJURY........" D ^DIE G:$D(Y) JUMP
	S DR="690     THROMBOEMBOLISM................" D ^DIE G:$D(Y) JUMP
	S DR="691     URETHRAL STRICTURE............." D ^DIE G:$D(Y) JUMP
PDWTD	S DR="441 48. POSTOPERATIVE DEATH W/I 3O DAYS" D ^DIE G:$D(Y) JUMP
PRTC	W ! K DIR S DIR(0)="E" D ^DIR G:$D(DIRUT) EXIT
	G RT^ONCP2P4A
JUMP	;Jump to prompts
	S XX="" R !!," GO TO ITEM: ",X:DTIME I (X="")!(X[U) S OUT="Y" G EXIT
	I X["?" D  G JUMP
	.W !," CHOOSE FROM:" F I=1:1:CHOICES W !," ",HTABLE(I)
	I '$D(TABLE(X)) S:X?1.2N X=X_"." S XX=X,X=$O(TABLE(X)) I ($P(X,XX,1)'="")!(X="") W *7,"??" D  G JUMP
	.W !," CHOOSE FROM:" F I=1:1:CHOICES W !," ",HTABLE(I)
	S X=TABLE(X)
	G @X
EXIT	S:$D(DIRUT) OUT="Y"
	K CHOICES,PIECE,HTABLE,TABLE
	K CDS,CDSOT,LOS,NCDS,NCDSOT,NOP,SURG,SURG1,SURG2,SURGDT,SA,SA1,SA2
	K SM,SM1,SM2,SOORS,SOORS1,SOORS2
	K DA,DIE,DIR,DIROUT,DIRUT,DR,DTOUT,DUOUT,X,XX,Y
	Q
