PRCPRTR1	;WISC/RFJ-transaction register report (print) ;07 Sep 91
	;;5.1;IFCAP;**24,142**;Oct 20, 2000;Build 5
	;Per VHA Directive 2004-038, this routine should not be modified.
	Q
	;
	;
PRINT	;print report from tmp global
	N DATA,ITEMDA,MONTH,NOW,NOWDT,NSN,PAGE,PRCPFLAG,SALEUNIT,SCREEN,PRCPDT,HDSW
	D NOW^%DTC S (Y,NOWDT)=% D DD^%DT S NOW=Y,PAGE=0
	S HDSW=0,U="^",PAGE=0,ITEMDA="",SCREEN=$$SCRPAUSE^PRCPUREP U IO
P1	S ITEMDA=$O(^TMP($J,"PRCPRTRA",ITEMDA)),PRCPDT=0 G 9:ITEMDA=""!($D(PRCPFLAG)) S:'$D(ALLITEMS) PAGE=0
P2	S PRCPDT=$O(^TMP($J,"PRCPRTRA",ITEMDA,PRCPDT)) G P1:PRCPDT=""!$D(PRCPFLAG)
	S Y=PRCPDT D DD^%DT S MONTH=Y
	I $D(ALLITEMS),PAGE=0 D H
	D  G 9:$G(PRCPFLAG),P2
	. I '$D(ALLITEMS) D H Q:$G(PRCPFLAG)
	. S DATA=^TMP($J,"PRCPRTRA",ITEMDA,PRCPDT),NSN=$P(DATA,U),DATA=$P(DATA,U,2,99)
	. W !!,$S(NSN=" ":"** NO NSN **",1:NSN)
	. W ?19,$P(DATA,"^")
	. W ?49,"[#",ITEMDA,"]"
	. W ?59,"U/I: ",$P(DATA,"^",2)
	. W ! W:PRCP("DPTYPE")="W" ?9,"QTY NON-ISS: ",+$P(DATA,"^",5)
	. W ?28,"DUE-IN: ",+$P(DATA,"^",3)
	. W ?44,"DUE-OUT: ",+$P(DATA,"^",4)
	. W !?23,"ISSUABLE + NONISSUABLE OPEN BALANCE:",$J($P(DATA,"^",6),9),$J($P(DATA,"^",7),12,2)
	. I $Y>(IOSL-6) D H Q:$G(PRCPFLAG)
	. S DATE=0
	. F  S DATE=$O(^TMP($J,"PRCPRTRA",ITEMDA,PRCPDT,DATE)) Q:'DATE!($G(PRCPFLAG))  D
	. . S TRX=0
	. . F  S TRX=$O(^TMP($J,"PRCPRTRA",ITEMDA,PRCPDT,DATE,TRX)) Q:'TRX!($G(PRCPFLAG))  D
	. . . S D=^TMP($J,"PRCPRTRA",ITEMDA,PRCPDT,DATE,TRX)
	. . . S SALEUNIT="" I $P(D,"^",6) S SALEUNIT=$J($P(D,"^",5)/$P(D,"^",6),0,3)
	. . . W !,$P(D,"^"),?9,$E(DATE,6,7),?13,$P(D,"^",2),?33,$J($P(D,"^",3),8),$J(SALEUNIT,10),$J($P(D,"^",5),10),$J($P(D,"^",6),7),$J($P(D,"^",4),12)
	. . . W:$G(^PRCP(445.2,TRX,1))'="" !,$P(^(1),"^")
	. . . I $Y>(IOSL-6) D H Q:$G(PRCPFLAG)
	. I $D(PRCPFLAG) Q
	. I $Y>(IOSL-5) D H Q:$G(PRCPFLAG)
	. I $G(ZTQUEUED),$$S^%ZTLOAD S PRCPFLAG=1 W !?10,"<<< TASKMANAGER JOB TERMINATED BY USER >>>" Q
	. W !?43,"CLOSING BALANCE:",$J($P(DATA,"^",8),9),$J($P(DATA,"^",9),12,2)
	. S %=$G(^TMP($J,"PRCPRTRA",ITEMDA,PRCPDT,"BAL"))
	. I %'="" W !?28,"*** CURRENT INVENTORY BALANCES:",$J($P(%,"^"),9),$J($P(%,"^",2),12,2)
	. I $Y>(IOSL-6) D H
9	I $G(PRCPFLAG) G Q
	I $Y>(IOSL-7),'$D(PRCPFLAG)  D H Q:$G(PRCPFLAG)
	I '$D(PRCPFLAG) W ! F %=1:1:5 W !,$P($T(ABBREV+%),";",3)
	I '$D(PRCPFLAG) D END^PRCPUREP
Q	D ^%ZISC K ^TMP($J,"PRCPITEMS"),^TMP($J,"PRCPRTRA")
	Q
	;
H	S PAGE=PAGE+1,%=NOW_"  PAGE "_PAGE
	I SCREEN D:PAGE>1!HDSW P^PRCPUREP Q:$G(PRCPFLAG)  W @IOF
	I 'SCREEN,(PAGE=1!$D(ALLITEMS)) W @IOF
	I 'SCREEN,PAGE>1,'$D(ALLITEMS) S X="",$P(X," ",81)="" W !,X,!,X K X
	W !,"TRANSACTION REGISTER FOR ",$E(PRCP("IN"),1,15),?(80-$L(%)),%
	W !,"  FOR THE MONTH OF ",MONTH
	I $G(PRCPSUMM) W ?47,"ONLY ITEMS OUT OF BALANCE PRINTED"
	W !,"NSN",?19,"DESCRIPTION",?49,"[#MI]"
	S %="",$P(%,"-",81)="",HDSW=1
	W !,"TRANSID",?9,"DT",?13,"TRANS./P.O."
	W:PRCP("DPTYPE")="P" "/to:INV.PT."
	W ?38,"U/I",?43,"SELLUNIT",?55,"SELL $",?65,"QTY",?75,"INV $",!,%
	I 'SCREEN S $Y=9
	Q
	;
ABBREV	;;display abbreviations
	;;TRANSACTION TYPE (TT) ABBREVIATIONS:   U = USAGE
	;;  R = RECEIVING                        A = MANUAL ADJUSTMENT
	;;  D = DISTRIBUTION (REGULAR ISSUES)    S = ASSEMBLE SETS
	;;  C = DISTRIBUTION (CALL-IN)           P = PHYSICAL COUNT
	;;  E = DISTRIBUTION (EMERGENCY)         Q = QTY ADJ TO SUPPLY STATION
