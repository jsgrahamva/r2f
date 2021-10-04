PRCHSF1	;WISC/DJM-UPDATES OR PLACES BOCS & AMOUNTS INTO PO FILE AFTER AMENDMENT ;2/16/95  3:42 PM
V	;;5.1;IFCAP;**120**;Oct 20, 2000;Build 27
	;Per VHA Directive 2004-038, this routine should not be modified.
	;AMENDED PO
	;UPDATES TOTAL $ AMOUNTS
	;CALLED FROM 443.6 COPY ROUTINE 'PRCHAMYB'
	Q:$P(^PRC(442,DA,7),U,1)=45  L +^PRC(442,DA):1 I '$T W !," P.O. is being edited by another person !",$C(7) Q
	S U="^",X=^PRC(442,DA,0),PRCHS("EST")=+$P(X,U,13),PRCHS("CP")=+$P(X,U,3),PRCHS("SITE")=+X I $D(^PRC(420,PRCHS("SITE"),1,PRCHS("CP"),0)),$P(^(0),U,12) S PRCHS("SP")=$P(^(0),U,12)
	S I=0 F  S I=$O(^PRC(442,DA,2,I)) Q:I=""!(I'>0)  S PRCHS=I,PRCHS("N")=^(PRCHS,0),PRCHS("N2")=$G(^(2)),PRCHS("NS")=+$P(PRCHS("N"),U,4) D L
	S (CNT,J)=0 F  S J=$O(PRCHS("A",J)) Q:J=""!(J<0)  D LI2
	S (PRCHS("TOT"),PRCHS("NET"),M,PRCHS)=0
	S BOCSHP=$G(^PRC(442,DA,23)),PRCHS(991)=+BOCSHP_"^"_PRCHS("EST") K BOCSHP
	F  S M=$O(PRCHS(M)) Q:M=""!(M'>0)  I M'=991 S PRCHS("TOT")=PRCHS("TOT")+$P(PRCHS(M),U,2)
	S PO=PRCHPO,PRC("BBFY")=$$BBFY^PRCFFU5(PRCHPO)
	N PARAM K PRCHMO S PARAM=PRCHS("CP")_"^"_PRC("FY")_"^"_PRCFA("BBFY")
	S PRCHMO=$$ACC^PRC0C(PRC("SITE"),PARAM)
	S PRCHS("G/N")=$P(PRCHMO,U,12) K PRCHMO
	I $D(PRCHS("G/N")) D:PRCHS("G/N")="G" LABEL,NET,UPDTN D:PRCHS("G/N")="N" NET,UPDTN,LABEL
	G ^PRCHSF2
NET	;APPLY PROMPT PAY DISCNT ONLY TO NET FUNDS, & REFLECT NET AMT ON 0 NODE
	D TM S PTM=0 F  S PTM=$O(PRCHS(PTM)) Q:(PTM="")!(PTM'>0)  I $P(PRCHS(PTM),U,2) I PTM'=991 S X=$P(PRCHS(PTM),U,2),$P(PRCHS(PTM),U,2)=(X-$J(X*PRCHS("T"),0,2)),PRCHS("NET")=PRCHS("NET")+$P(PRCHS(PTM),U,2)
	Q
	;
UPDTN	;UPDATE ZERO NODE, CHECK MESSAGE, ELECTRONIC SIGNATURE ETC.
	S PRCHS("NET")=PRCHS("NET")+PRCHS("EST"),PRCHS("TOT")=PRCHS("TOT")+PRCHS("EST"),$P(^PRC(442,DA,0),U,6,9)="^^^"
	S $P(^PRC(442,DA,0),U,15,16)=PRCHS("TOT")_"^"_PRCHS("NET")
	;NOW UPDATE THE 'AMOUNT CHANGED' FIELD
	;PRCHTOTQ = THE TOTAL AMOUNT OF THE PO BEFORE THIS UPDATE
	;PRCHTOTQ IS SET IN ROUTINE 'PRCHAMYA'
	S PRCHS("TOTN")=PRCHS("TOT")-PRCHTOTQ,$P(^PRC(442,PRCHPO,6,PRCHAM,0),U,3)=PRCHS("TOTN"),MESSAGE=""
	D RECODE^PRCHES6(PRCHPO,PRCHAM,.MESSAGE)
	S MESS1=MESSAGE,MESSAGE=1
	;PRC*5.1*120 added check (AUTOOBLG set in PRCHSWCH) to also skip record recode if EDI or All/DELIVERY ORDER auto obligated order
	I $G(PRCHS("SP"))'=2,$P(^PRC(442,DA,0),U,2)'=25,$G(AUTOOBLG)'=1 D RECODE^PRCHES7(PRCHPO,PRCHAM,.MESSAGE)
	I MESS1'=1!(MESSAGE'=1) W !,"An error has occurred while recoding an ESIG."
	Q
LABEL	;
	S (CTR,I)=0 F  S I=$O(PRCHS(I)) Q:I'>0  D IT
	Q
	;
IT	N DA S:$D(DA(1)) PRCHDA1=DA(1) S DA(1)=PRCHPO
	S BOC=$P(PRCHS(I),U),AMT=$P(PRCHS(I),U,2),DA=0
IT1	;LOOK FOR BOC
	;IF FOUND
	; 1, SEE IF FMS LINE NUMBER=991 & I FROM PRCHS(I)=991
	;    A, IF SO, ENTER AMT AND QUIT
	; 2, SEE IF FMS LINE NUMBER'=991 & I '=991
	;    A, IF SO, ENTER AMT AND QUIT
	S DA=$O(^PRC(442,DA(1),22,"B",+BOC,DA)),FLAGOK=""
	I DA>0 D  G:FLAGOK="" IT1 Q
	.S UPDT=$G(^PRC(442,DA(1),22,DA,0)),LINO=$P(UPDT,U,3)
	.I LINO=991,(I=991) S $P(UPDT,U,2)=AMT,^PRC(442,DA(1),22,DA,0)=UPDT,FLAGOK=1 Q
	.I LINO'=991,(I'=991) S $P(UPDT,U,2)=AMT,^PRC(442,DA(1),22,DA,0)=UPDT,FLAGOK=1 Q
	.Q
	;IF YOU ARRIVED HERE & I=991 YOU NEED TO FIND THE IEN IN NODE 22
	;THAT HAS AN FMS LINE NUMBER = 991.
	;WHEN FOUND ENTER BOC & AMT FROM LINE IT+1 AND QUIT.
	I I=991 D  Q:FLAGOK=1
	.S DA=0 F  S DA=$O(^PRC(442,DA(1),22,DA)) Q:DA'>0  D  Q:FLAGOK=1
	..S UPDT=$G(^PRC(442,DA(1),22,DA,0)),LINO=$P(UPDT,U,3)
	..I LINO=991 S $P(UPDT,U)=BOC,$P(UPDT,U,2)=AMT,^PRC(442,DA(1),22,DA,0)=UPDT,FLAGOK=1 Q
	.Q
	S DIC="^PRC(442,"_DA(1)_",22,",DIC(0)="L",X=+BOC K DD,DO D FILE^DICN I Y'>0 W !," ERROR " Q
	N DA S DIE=DIC,DA=+Y
	S LAST=LAST+1
	S DR="1////^S X=AMT;2////^S X=LAST" D ^DIE K X,Y,DIE,DIC
	S:$D(PRCHDA1) DA(1)=PRCHDA1 K PRCHDA1
	Q
	;
L	S:'$D(PRCHS("A",PRCHS("NS"))) PRCHS("A",PRCHS("NS"))="" S LICOST=+$P(PRCHS("N2"),U,1),PRCHS("A",PRCHS("NS"))=+(PRCHS("A",PRCHS("NS")))+LICOST-$P(PRCHS("N2"),U,6)
	Q
	;
LI2	S CNT=CNT+1 S PRCHS(CNT)=J_U_PRCHS("A",J) K PRCHS("A",J)
	Q
	;
TM	;
	S PRCHS("T")=0,I=0 F  S I=$O(^PRC(442,DA,5,I)) Q:'I  S X=^(I,0) I +X>0 S I(100-X)=+X
	S:$O(I(0)) PRCHS("T")=I($O(I(0))),PRCHS("T")=PRCHS("T")/100 K I Q
	Q
