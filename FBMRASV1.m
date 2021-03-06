FBMRASV1	;AISC/CMR-Server Routine for MRA Messages Cont'd;4/1/93 ; 8/28/09 12:02pm
	;;3.5;FEE BASIS;**111**;JAN 30, 1995;Build 17
	;;Per VHA Directive 2004-038, this routine should not be modified.
CHANGE	;Process Austin Change Record
	;if fbinc=fbinc1 then transaction was to update fms vendor file, nothing needs to be repointed, and since it is not a duplicate, vendor should not be deleted.
	I FBSTN'=FBSN D
	.N EC S (FBICN,FBOUT)=0,FBERR=1,EC="" D
	..F  S FBICN=$O(^FBAAV("C",FBVID,FBICN)) Q:'FBICN!(FBOUT)  D
	...Q:$P($G(^FBAAV(FBICN,"ADEL")),"^")="Y"
	...S EC="" I FBRT=4 Q:$P(^FBAAV(FBICN,0),U,7)'=3  Q:$P(^FBAAV(FBICN,0),U,10)'=FBCHAIN
	...I FBRT=1 Q:$P($G(^FBAAV(FBICN,0)),U,7)=3
	...I $E(FBVNAME,1,5)'=$E($P($G(^FBAAV(FBICN,"AMS")),U),1,5),'+$P($G(^FBAAV(FBICN,"ADEL")),U,4) S EC=4 Q
	...S FBCNT=FBCNT+1,FBOUT=1,FBERR=0 D FILEV^FBMRASVR
	.I FBERR S:EC']"" EC=4.1 D ER^FBMRASV2(EC,FBJ,.FBER) S FBERR=0
	Q:FBSTN'=FBSN
	I FBSTN=FBSN D GET^FBMRASVR D:FBMRA']"" ER^FBMRASV2(5,FBJ,.FBER) Q:FBMRA']""  S FBICN1=FBICN,FBICN=$P(FBMRA,"^",6) I 'FBICN K FBICN1 Q
	S FBCNT=FBCNT+1 D FILEV^FBMRASVR,DELMRA^FBMRASVR I FBICN']""!(FBICN=FBICN1) K FBICN1 Q
REPOINT	;Re-point pointers to appropriate vendor entry.
	N DFN,DAT
	I $D(^FBAAA("ACV",FBICN1)) S K=0 F  S K=$O(^FBAAA("ACV",FBICN1,K)) Q:'K  S FBJ=0 F  S FBJ=$O(^FBAAA("ACV",FBICN1,K,FBJ)) Q:'FBJ  S DIE="^FBAAA(K,1,",DA=FBJ,DA(1)=K,DR=".04////^S X=FBICN" D ^DIE K DIE
	I $D(^FBAA(161.21,"C",FBICN1)) S FBJ=0 F  S FBJ=$O(^FBAA(161.21,"C",FBICN1,FBJ)) Q:'FBJ  S DIE="^FBAA(161.21,",DA=FBJ,DR=".04////^S X=FBICN" D ^DIE K DIE
	I $D(^FBAAC("AB",FBICN1)) S FBK=0 F  S FBK=$O(^FBAAC("AB",FBICN1,FBK)) Q:'FBK  D
	.F  L +^FBAAC(FBK):$G(DILOCKTM,3) Q:$T  W:'$D(ZTQUEUED) "Another user is editing this entry.",!
	.S FBOGN=0
	.I '$D(^FBAAC(FBK,1,FBICN,0)) S DIC="^FBAAC(FBK,1,",DA(1)=FBK,(X,DINUM)=FBICN,DIC(0)="" D FILE^DICN
	.F  S FBOGN=$O(^FBAAC(FBK,1,FBICN1,1,FBOGN)) Q:'FBOGN  K DD,DO S DIC="^FBAAC(FBK,1,FBICN,1,",DA(1)=FBICN,DA(2)=FBK,DIC(0)="",DIC("P")="162.02DA",X=$P(^FBAAC(FBK,1,FBICN1,1,FBOGN,0),"^") D FILE^DICN I +$P(Y,U,3) S FBNGN=+Y D
	..S %X="^FBAAC(FBK,1,FBICN1,1,FBOGN,",%Y="^FBAAC(FBK,1,FBICN,1,FBNGN," D %XY^%RCR
	..S DIK="^FBAAC(FBK,1,FBICN,1,",DA(2)=FBK,DA(1)=FBICN,DA=FBNGN D IX1^DIK K DIK
	.S DIK="^FBAAC(FBK,1,",DA(1)=FBK,DA=FBICN1 D ^DIK K DIK L -^FBAAC(FBK)
	I $D(^FBAA(162.1,"AN",FBICN1)) S FBJ=0 F  S FBJ=$O(^FBAA(162.1,"AN",FBICN1,FBJ)) Q:'FBJ  S DIE="^FBAA(162.1,",DA=FBJ,DR="3////^S X=FBICN" D
	.D LOCK^FBUCUTL(DIE,DA,1) I FBLOCK D ^DIE L -^FBAA(162.1,DA)
	.K DIE,FBLOCK
	I $D(^FBAA(162.2,"C",FBICN1)) S FBJ=0 D
	.F  S FBJ=$O(^FBAA(162.2,"C",FBICN1,FBJ)) Q:'FBJ  S DIE="^FBAA(162.2,",DA=FBJ,DR="1////^S X=FBICN" D
	..D LOCK^FBUCUTL(DIE,DA,1) I FBLOCK D ^DIE L -^FBAA(162.2,DA)
	..K FBLOCK S DIE="^FBAA(161.5," D LOCK^FBUCUTL(DIE,DA,1) I FBLOCK D ^DIE L -^FBAA(161.5,DA)
	..K DIE,FBLOCK
	I $D(^FBAACNH("AH",FBICN1)) S FBJ=0 F  S FBJ=$O(^FBAACNH("AH",FBICN1,FBJ)) Q:'FBJ  S DIE="^FBAACNH(",DA=FBJ,DR="8////^S X=FBICN" D
	.D LOCK^FBUCUTL(DIE,DA,1) I FBLOCK D  L -^FBAACNH(DA)
	..D ^DIE
	..I $D(^FBAACNH(DA,0)) S DAT=$P(^FBAACNH(DA,0),U),DFN=$P(^FBAACNH(DA,0),U,2) D
	...I $D(^FBAACNH("AG",DFN,FBICN1,DAT,DA)) D
	....K ^FBAACNH("AG",DFN,FBICN1,DAT,DA)
	....S ^FBAACNH("AG",DFN,FBICN,DAT,DA)=""
	.K DIE,FBLOCK
	I $D(^FB7078("C",FBICN1_";FBAAV(")) S FBJ=0 D
	.F  S FBJ=$O(^FB7078("C",FBICN1_";FBAAV(",FBJ)) Q:'FBJ  S DIE="^FB7078(",DA=FBJ,FBTMP=FBICN_";FBAAV(",DR="1////^S X=FBTMP" D
	..D LOCK^FBUCUTL(DIE,DA,1) I FBLOCK D ^DIE L -^FB7078(DA)
	..K DIE,FBLOCK,FBTMP
	I $D(^FBAAI("C",FBICN1)) S FBJ=0 F  S FBJ=$O(^FBAAI("C",FBICN1,FBJ)) Q:'FBJ  S DIE="^FBAAI(",DA=FBJ,DR="2////^S X=FBICN" D
	.D LOCK^FBUCUTL(DIE,DA,1) I FBLOCK D ^DIE L -^FBAAI(DA)
	.K DIE,FBLOCK
	I $D(^FB583("C",FBICN1)) S FBJ=0,FBCHK=";FBAAV(" F  S FBJ=$O(^FB583("C",FBICN1,FBJ)) Q:'FBJ  S DIE="^FB583(",DA=FBJ,DR="1////^S X=FBICN" S:$P($G(^FB583(FBJ,0)),"^",23)=(FBICN1_FBCHK) DR=DR_";23////^S X=FBICN_FBCHK" D
	.D LOCK^FBUCUTL(DIE,DA,1) I FBLOCK D ^DIE L -^FB583(DA)
	.K DIE,FBLOCK
	;Delete second vendor from vendor file.
	K DIC,DA
	S DIK="^FBAAV(",DA=FBICN1 D ^DIK K DIK,FBICN1
	Q
