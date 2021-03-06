PRCE58P3	;WISC/SAW,LDB/BGJ-CONTROL POINT ACTIVITY 1358 PRINOUT CON'T ;6/17/11  17:53
V	;;5.1;IFCAP;**158,168**;Oct 20, 2000;Build 3
	 ;Per VHA Directive 2004-038, this routine should not be modified.
	;
	;PRC*5.1*168 will remove leading zeros when transactions compile into 
	;            temp global ^TMP("PRCSR") to insure correct sort for 1358
	;            having more than 999 transactions
	;
	S Z=$S($D(PRCSPO):PRC("SITE")_"-"_PRCSPO,1:0) G OB:$D(PRCSOB)
	I 'Z!('$D(^PRC(424,"AD",Z))) W !,"Daily Record entries have not yet been entered for this request.",!,"The total committed cost of this request is $" W:$D(TRNODE(4)) $J($P(TRNODE(4),U),0,2) D UL^PRCE58P2 G P
PO	D HDR1 S PRCSX=0 D OB S (CET,ET,AT,UT)="" D PO1
	W !!,?7,"TOTALS",?29,"$"
	;Display of dollar amounts staggered if any amount $1 million or more
	D
	. I ET>999999.99!(AT>999999.99)!(CET>999999.99) D  Q
	. . W $J(ET,9,2),?51,"$",$J(CET,9,2),?69,"$",$J((PRCSOT-UT),9,2) W !,?40,"$",$J(AT,9,2)
	. W $J(ET,9,2),?40,"$",$J(AT,9,2),?51,"$",$J(CET,9,2),?69,"$",$J((PRCSOT-UT),9,2)
	K PRCSX,PRCSOT,UT,CT,AT,ET,CAT,CET,PRCSR,PRCSX,PRCSXX,J,JJ,TRNODE
	D P
	Q
PO1	I $D(TRNODE(10)) S PRCSY=$P(TRNODE(10),U,3) I PRCSY K PO D PO^PRCH58OB(PRCSY,.PO) D:$D(PO(0)) PO11
	Q
PO11	;;;PRC*5.1*168 will remove leading zeros in TX# in next line
	K ^TMP("PRCSR",$J) D HDR S CET=0 F  S PRCSX=$O(^PRC(424,"C",PRCSY,PRCSX)) Q:PRCSX'>0  I $D(^PRC(424,PRCSX,0)),"^AU^L^"[("^"_$P(^(0),U,3)_"^") S Z1=^(0) I Z1 S ^TMP("PRCSR",$J,+$P($P(Z1,U),"-",3),PRCSX)=Z1
	S PRCSXX="" F  S PRCSXX=$O(^TMP("PRCSR",$J,PRCSXX)) Q:PRCSXX=""  D PO12
	K ^TMP("PRCSR",$J) Q
PO12	S PRCSX=0 F JJ=1:1 S PRCSX=$O(^TMP("PRCSR",$J,PRCSXX,PRCSX)) Q:PRCSX'>0  S Z1=^TMP("PRCSR",$J,PRCSXX,PRCSX),Y=$P(Z1,U,7) D T D:IOSL-$Y<6 NEWP^PRCE58P2,HDR D PO2
	K A,E Q
	;
PO2	W !,Y,?7,$E("0000",1,4-$L(PRCSXX))_PRCSXX,?12,$P(Z1,U,10),?29,"$"   ;PRC*5.1*168 will zero pad TX# for print
	S E=$P(Z1,U,12),A=$P(Z1,U,5),UT=UT+$P(Z1,U,4),AT=AT+A,ET=ET+E,CET=CET+E
	;Display of dollar amounts staggered if any amount $1 million or more
	D
	. I E>999999.99!(A>999999.99)!(CET>999999.99)!(Z1>999999.99) D  Q
	. . W $J(E,9,2),?51,"$",$J(CET,9,2) W ! W:$D(PRCSA)&($G(^PRC(424,PRCSX,1))'="") ?12,^(1) W ?40,"$",$J(A,9,2),?62,"$",$J($P(Z1,U,4),9,2)
	. W $J(E,9,2),?40,"$",$J(A,9,2),?51,"$",$J(CET,9,2),?62,"$",$J($P(Z1,U,4),9,2) I $D(PRCSA),$G(^PRC(424,PRCSX,1))'="" W !,?12,^(1)
	I $D(^PRC(424.1,"C",PRCSX)),$D(PRCSA1),PRCSA1=1 S I=0 F  S I=$O(^PRC(424.1,"C",PRCSX,I)) Q:'I  I $D(^PRC(424.1,I,0)),$P(^(0),U,11)="P" D
	. I IOSL-$Y<6 D NEWP^PRCE58P2,HDR
	. W ! S Y=$P(^PRC(424.1,I,0),U,4) D T W Y,?7,$P($P(^(0),U),"-",3,4) W !,?12,$P(^(0),U,8),?29,"$",$J(($P(^(0),U,3)/-1),9,2)
	. I IOSL-$Y<6 D NEWP^PRCE58P2,HDR
	. I $D(PRCSA2),PRCSA2=1,$D(^PRC(424.1,I,1)) W !,?12,^(1)
	W ! Q
P	W !!,"VA FORM 4-1358a-ADP (NOV 1987)",! Q
OB	;PRINT ONLY OBLIGATIONS
	I '$D(^PRC(424,"AD",Z)) G OB1
	S (PRCSOT,X1,UT)="" F I=1:1 S X1=$O(^PRC(424,"AF",Z,X1)) Q:X1'>0  I $D(^PRC(424,X1,0)) S Z1=^(0),PRCSOT=PRCSOT+$P(^(0),U,6) D:IOSL-$Y<3 NEWP^PRCSP11,HDR1 S ZDA=DA D DR1 S DA=ZDA K ZDA D NODE^PRCS58OB(DA,.TRNODE)
	D UL^PRCE58P2 Q:$D(PRCSX)
OB1	W !!,"The following 1358 obligation/adjustment request is ready for processing:"
	S X=$P(TRNODE(0),U,1,2) W !,"TRANSACTION NUMBER: ",$P(X,U),?40,"TYPE: ",$S($P(X,U,2)="O":"OBLIGATION",1:"ADJUSTMENT"),?60,"AMOUNT: $",$J($P(TRNODE(4),U,8),0,2) D UL^PRCE58P2 G P
DR1	S Y=$P(Z1,U,7) D T W !,Y,?7,$P($P(Z1,U),"-",3)
	S DA=$P(Z1,U,15) I DA D NODE^PRCS58OB(DA,.TRNODE) W ?13,$P($G(TRNODE(0)),U)
	W ?36,"$",$J($P(Z1,U,6),9,2) W:$D(PRCSX) ?56,"$",$J(PRCSOT,9,2) Q
HDR	W !,"AUTHORIZATION & ORDER RECORD",?62,"LIQUIDATION RECORD"
	W !!,?30,"AUTH.",?41,"AUTH.",?53,"CUMULATIVE",?74,"UNLIQ",!,"DATE",?7,"SEQ#",?14,"REFERENCE",?30,"AMOUNT",?41,"BALANCE",?53,"AUTH. AMT.",?64,"LIQUID",?74,"BAL" D UL^PRCE58P2 Q
HDR1	W !,"ESTIMATED OBLIGATION RECAP",!,"DATE",?7,"REF#",?13,"CPA#",?37,"AMOUNT",?57,"BALANCE" Q
T	S Y=$E(Y,4,5)_"/"_$E(Y,6,7) Q
