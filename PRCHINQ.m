PRCHINQ	;WISC/AKS-Add/Edit Surrogate Users and inquire Card Info ;6/8/96  13:38
	;;5.1;IFCAP;**18,117,126,157,183**;Oct 20, 2000;Build 4
	;Per VHA Directive 2004-038, this routine should not be modified.
	;
	;PRC*5.1*183 Text added to inform user that surrogates lookup/add will
	;            only show those having access to FCP linked to PCard.
	;
	QUIT
	;
INQ	;Display purchase card information and allow add/editting of users
	;
	N PRCHDA
	S PRCF("X")="S" D ^PRCFSITE Q:'$D(PRC("SITE"))!($G(X)="^")   ;PRC*5.1*183  SITE setup
	S DIC="^PRC(440.5,",DIC(0)="AEQM"
	S DIC("S")="I $P(^PRC(440.5,+Y,0),U,8)=DUZ"
	D ^DIC W !
	S (PRCHDA,DA)=+Y,DR="0:49" D EN^DIQ,EN^DDIOL("REPLACEMENT CHARGE CARD NUMBER: "_$P($G(^PRC(440.5,DA,50)),"^")):$P($G(^PRC(440.5,DA,50)),"^")]"" G:Y=-1 EXIT
	S %A="Would you like to add/delete a surrogate",%B="",%=2
	D ^PRCFYN G:%<1!(%=2) EXIT
	;PRC*5.1*183
	W !!,?25,"*** ATTENTION ***"
	W !,?5,"Adding a new surrogate will now check surrogate name entered"
	W !,?5,"for valid access to the Fund Control Point linked to the PCard."
	W !,?5,"It will be possible to enter a name search and not find any"
	W !,?5,"due to an invalid name entry or user name with no access to"
	W !,?5,"Purchase Card FCP.",!
	;
MORE	;PRC*5.1*183  New surrogate logic
	S DA(1)=PRCHDA,DIC="^PRC(440.5,"_DA(1)_",1,",DIC(0)="AEQL"
	S DIC("S")="I +Y'=$P(^PRC(440.5,DA(1),0),U,8)"
	D ^DIC K DIC
	G:$D(DUOUT)!$D(DTOUT) EXIT G EXIT:Y'>0  S DA=+Y
	I $P(Y,U,3)'=1 D
	. W !!?5,"Would you like to delete this surrogate user" S %=2 D YN^DICN
	. Q:%<1!(%=2)
	. S DA=+Y,DIK="^PRC(440.5,"_DA(1)_",1,"
	. D ^DIK K Y,DA,DIK
Q	S %A="Would you like to add/delete another surrogate",%B="",%=2
	D ^PRCFYN G:%<1!(%=2) EXIT G MORE
	;
STAT	;Amendment/Adjustment statuses from the dd, called from field #50, sub-
	;field #9 of file #443.6
	N MOPPC S MOPPC=0
	I $P($G(^PRC(443.6,PRCHPO,0)),U,2)=25 S MOPPC=1
	S DIC("S")="S Z1=$P(^(0),U,2) I $S(Z1=21:1,Z1=23:1,Z1=26:1,Z1=29:1,Z1=31:1,Z1=34:1,Z1=41:1,Z1=44:1,Z1=47:1,Z1=49:1,1:0)"
	S:MOPPC DIC("S")="S Z1=$P(^(0),U,2) I $S(Z1=21:1,Z1=23:1,Z1=26:1,Z1=29:1,Z1=31:1,Z1=34:1,Z1=44:1,Z1=47:1,Z1=49:1,1:0)"
	;I $G(PRCHAUTH)=1 S DIC("S")="S Z1=$P(^(0),U,2) I $S(Z1=21:1,Z1=23:1,Z1=26:1,Z1=29:1,Z1=31:1,Z1=34:1,Z1=41:1,Z1=44:1,Z1=47:1,Z1=49:1,Z1=51:1,1:0)"
	I $G(PRCHAUTH)=1 D
	. S DIC("S")="S Z1=$P(^(0),U,2) I $S(Z1=23:1,Z1=26:1,Z1=31:1,1:0)"
	. S PRCHOLD=$P($G(^PRC(443.6,PRCHPO,7)),U)
	. I $P($G(^PRCD(442.3,PRCHOLD,0)),"(")="Paid " D
	. . S DIC("S")="S Z1=$P(^(0),U,2) I $S(Z1=29:1,Z1=34:1,Z1=38:1,1:0)"
	. I $P($G(^PRCD(442.3,PRCHOLD,0)),"(")="Partial Payment " D
	. . S DIC("S")="S Z1=$P(^(0),U,2) I $S(Z1=44:1,Z1=47:1,Z1=49:1,1:0)"
	D ^DIC K DIC,PRCHOLD,MOPPC S DIC=DIE,X=+Y K:Y<0 X
	QUIT
EXIT	;Kill variables and quit
	K Y,%A,%B,%,DIC
	QUIT
STAT1	;Called from field #50, subfield #9, file #443.6
	N MOPPC S MOPPC=0
	I $P($G(^PRC(443.6,PRCHPO,0)),U,2)=25 S MOPPC=1
	S DIC("S")="S Z1=$P(^(0),U,2) I $S(Z1=21:1,Z1=23:1,Z1=26:1,Z1=29:1,Z1=31:1,Z1=34:1,Z1=41:1,Z1=44:1,Z1=47:1,Z1=49:1,1:0)"
	S:MOPPC DIC("S")="S Z1=$P(^(0),U,2) I $S(Z1=21:1,Z1=23:1,Z1=26:1,Z1=29:1,Z1=31:1,Z1=34:1,Z1=44:1,Z1=47:1,Z1=49:1,1:0)"
	;I $G(PRCHAUTH)=1 S DIC("S")="S Z1=$P(^(0),U,2) I $S(Z1=21:1,Z1=23:1,Z1=26:1,Z1=29:1,Z1=31:1,Z1=34:1,Z1=41:1,Z1=44:1,Z1=47:1,Z1=49:1,Z1=51:1,1:0)"
	I $G(PRCHAUTH)=1 D
	. S DIC("S")="S Z1=$P(^(0),U,2) I $S(Z1=23:1,Z1=26:1,Z1=31:1,1:0)"
	. S PRCHOLD=$P($G(^PRC(443.6,PRCHPO,7)),U)
	. I $P($G(^PRCD(442.3,PRCHOLD,0)),"(")="Paid " D
	. . S DIC("S")="S Z1=$P(^(0),U,2) I $S(Z1=29:1,Z1=34:1,Z1=38:1,1:0)"
	. I $P($G(^PRCD(442.3,PRCHOLD,0)),"(")="Partial Payment " D
	. . S DIC("S")="S Z1=$P(^(0),U,2) I $S(Z1=44:1,Z1=47:1,Z1=49:1,1:0)"
	K PRCHOLD,MOPPC
	QUIT
PAID	;To check if there is any payment made for this PO
	;PRC*5.1*157 in addition to "Paid" status check, check added to insure there are no reconciliation charges linked to order that should prevent PO cancelling.
	I $G(PRCHAUTH)=1!($P(^PRC(442,PRCHPO,0),U,2)=25) D
	. S PRCHOLD=$P($G(^PRC(443.6,PRCHPO,7)),U)
	. I $P($G(^PRCD(442.3,PRCHOLD,0)),"(")="Paid " S PAID=1
	. I $P($G(^PRCD(442.3,PRCHOLD,0)),"(")="Partial Payment " S PAID=1
	. I $G(PAID)'=1,$O(^PRCH(440.6,"PO",PRCHPO,0)) S PAID=1
	QUIT
