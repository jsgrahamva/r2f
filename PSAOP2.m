PSAOP2	;BIR/LTL-Outpatient Dispensing (All Drugs) ;7/23/97
	;;3.0;DRUG ACCOUNTABILITY/INVENTORY INTERFACE;**3,15,76**; 10/24/97;Build 1
	;This routine gathers outpatient dispensing for all drugs in a location
	;from the PRESCRIPTION file. If present, the last outpatient dispensing
	;date is used as a starting point. Otherwise the user selected date is
	;used.
	;
	;References to ^PSDRUG( are covered by IA #2095
	;References to ^PSRX( are covered by IA #254
	;
	D PSAWARN^PSAPSI I $D(PSAQUIT) K PSAQUIT Q
	D Q
	S $P(PSALN,"-",79)="-"
LOOK	D OP^PSADA
	G:'$G(PSALOC) Q W !,$G(PSALOCN)
	S DIR(0)="Y",DIR("A")="OK",DIR("B")="Yes",DIR("?")="Answering no will allow you to change Location." D ^DIR K DIR S:$D(DIRUT) PSAOUT=1 G:$D(DIRUT) Q I Y=0 K PSALOC D OP^PSADA G:'$G(PSALOC) Q
	I '$O(^PSD(58.8,+PSALOC,1,0)) W !!,"There are no drugs in ",PSALOCN,!! G Q
	D NOW^%DTC S PSADT=X,X="T-6000" D ^%DT S PSADT(1)=Y,(PSAPG,PSAOUT,PSADRUG)=0
	S DIR(0)="D^"_PSADT(1)_":"_PSADT_":AEX",DIR("A")="How far back would you like to collect",DIR("B")="T-6000"  D ^DIR K DIR S (PSADT(2),PSADT(22),PSAR,PSAP,PSAN)=Y,(PSADT(3),PSAR(1),PSAP(1),PSAN(1))=0 I Y<1 S PSAOUT=1 Q
	S (PSAOP,PSAS)=$P($G(^PSD(58.8,+PSALOC,0)),U,10)
	S DIR(0)="Y",DIR("A")="Would you like a report of daily dispensing totals",DIR("B")="Yes" D ^DIR K DIR S:$D(DIRUT) PSAOUT=1 G:$D(DIRUT) STOP
	I Y=1 S PSADAILY=1
DEV	K IO("Q") K %ZIS,IOP,POP S %ZIS="Q" I Y=1 W ! D ^%ZIS
	I $G(POP) W !,"NO DEVICE SELECTED OR ACTION TAKEN!" S PSAOUT=1 G Q
	I $D(IO("Q")) K ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTDTH,ZTSK S ZTRTN="LUP^PSAOP2",ZTDESC="Drug Acct-Daily Drug Dispensing Log",ZTSAVE("PSA*")="" D ^%ZTLOAD G Q
	;
LUP	;Starting point
	S PSADRUG=0 W @IOF
PROCESS	F PSAHOW="AL","AJ","AM","AN" S PSADT=PSADT(22)-.00001 D LOOP
	G DONE
	;
LOOP	;
	I $E(IOST)="C" W !,"Processing ",$S(PSAHOW="AL":"dispensing",PSAHOW="AJ":"returns",PSAHOW="AM":"partials",1:"returns")
	;
1	S PSADT=$O(^PSRX(PSAHOW,PSADT)) Q:PSADT'>0  K PSAIEN
2	S PSAIEN=$S('$D(PSAIEN):$O(^PSRX(PSAHOW,PSADT,0)),1:$O(^PSRX(PSAHOW,PSADT,PSAIEN))) G 1:PSAIEN'>0 K PSARX
3	S PSARX=$S('$D(PSARX):$O(^PSRX(PSAHOW,PSADT,PSAIEN,"")),1:$O(^PSRX(PSAHOW,PSADT,PSAIEN,PSARX))) G 2:PSARX="" W "."
	I $D(^PSRX("AR",PSADT,PSAIEN,PSARX)) G 3
	S PSADRUG=$P($G(^PSRX(PSAIEN,0)),"^",6) I $G(PSADRUG)="" G 3
	S PSADRUGN=$P($G(^PSDRUG(PSADRUG,0)),"^")
	I '$D(^PSD(58.8,PSALOC,1,PSADRUG)) G 3
	I $P($G(^PSRX(PSAIEN,2)),"^",9)'=PSAS G 3
	;
	S PSAQTY=$S(+PSARX:$P($G(^PSRX(PSAIEN,1,PSARX,0)),"^",4),1:$P($G(^PSRX(PSAIEN,0)),"^",7)) ;either refill or fill
	;
	I '$D(^TMP("PSA",$J,PSADRUGN,$E(PSADT,1,7))) S ^TMP("PSA",$J,PSADRUGN,$E(PSADT,1,7))=""
	S DATA=^TMP("PSA",$J,PSADRUGN,$E(PSADT,1,7))
	S $P(^TMP("PSA",$J,PSADRUGN,$E(PSADT,1,7)),"^",1)=$S(PSAHOW="AL":$P(DATA,"^")+PSAQTY,PSAHOW="AJ":$P(DATA,"^")-PSAQTY,PSAHOW="AM":$P(DATA,"^")+$P($G(^PSRX(PSAIEN,"P",PSARX,0)),"^",4),1:$P(DATA,"^")-$P($G(^PSRX(PSAIEN,"P",PSARX,0)),"^",4))
	;
	S $P(^TMP("PSA",$J,PSADRUGN,$E(PSADT,1,7)),"^",$S(PSAHOW="AL":2,PSAHOW="AJ":4,PSAHOW="AM":6,1:8))=PSAIEN
	S $P(^TMP("PSA",$J,PSADRUGN,$E(PSADT,1,7)),"^",$S(PSAHOW="AL":3,PSAHOW="AJ":5,PSAHOW="AM":7,1:9))=PSARX
	G 3
	;
DONE	;All dispensing data retrieved, print it.
	D HEADER
	S XX=0 F  S XX=$O(^PSD(58.88,PSALOC,1,XX)) Q:XX'>0  S XXX=$P($G(^PSDRUG,XX),"^") I '$D(^TMP("PSA",$J,XXX)) S ^TMP("PSA",$J,XXX)=0
	S PSADRUGN=0
4	S PSADRUGN=$O(^TMP("PSA",$J,PSADRUGN)) G STOP:PSADRUGN=""
	S PSADRUG=$O(^PSDRUG("B",PSADRUGN,0))
	I $Y>(IOSL+4) D HEADER G Q:$G(PSAOUT)=1
	I '$D(^TMP("PSA",$J,PSADRUGN)) W !,PSADRUGN,?36,"has not been dispensed since: " S Y=$S($P($G(^PSD(58.8,PSALOC,1,PSADRUG,6)),"^"):$P(^PSD(58.8,PSALOC,1,PSADRUG,6),"^"),1:PSADT(22)) X ^DD("DD") W Y,"." G 4
	W !,PSADRUGN
	K PNTDATA,PSADATE,PSATTLP,DAYS
5	S PSADATE=$S('$D(PSADATE):$O(^TMP("PSA",$J,PSADRUGN,0)),1:$O(^TMP("PSA",$J,PSADRUGN,PSADATE))) G PNTQ:PSADATE'>0 S DATA=^TMP("PSA",$J,PSADRUGN,PSADATE) S DAYS=$G(DAYS)+1
	S Y=PSADATE X ^DD("DD") S PRINTDT=Y
	S PSAQTY=$P(DATA,"^")
	;
	S PSAPRICE=$P($G(^PSDRUG(PSADRUG,660)),"^",6) ;Price per dispense Unit
	S PSADISPU=$P($G(^PSDRUG(PSADRUG,660)),"^",8) ;Dispense Unit
	;
	S Y=PSAQTY,X2=0 D COMMA^%DTC S PNTQTY=Y
	S TTLQTY=$G(TTLQTY)+PSAQTY ;total quantity
	S PSAPRICE(2)=$G(PSAPRICE(2))+(PSAPRICE*PSAQTY) ;Total Cost
	S Y=PSAPRICE,X2="3$" D COMMA^%DTC S PNTPRICE=Y
	S Y=PSAPRICE*PSAQTY,X2="3$" D COMMA^%DTC S PSAQP=Y
	I $D(PSADAILY) W !,$G(DAYS),?3,PRINTDT,?23,PNTQTY,?40,PNTPRICE,"/",PSADISPU,?63,PSAQP K PSAQP G 5
	G 5
	;
PNTQ	W !,PSALN,!,DAYS," DAY TOTALS: " S Y=TTLQTY,X2="2$" D COMMA^%DTC W Y S Y=PSAPRICE(2),X2="2$" D COMMA^%DTC W ?63,Y
	K TTLQTY,PSAPRICE,PSAQTY,PNTQTY
	G 4
	;
HEADER	I $E(IOST,1,2)'="P-",$G(PSAPG) S DIR(0)="E" D ^DIR K DIR I '+Y S PSAOUT=1 Q
	I $$S^%ZTLOAD S PSAOUT=1 Q
	W:$Y @IOF S PSAPG=$G(PSAPG)+1 W ?2,"DAILY DISPENSING TOTALS FOR ",$E($G(PSALOCN),1,30),?70,"PAGE: ",PSAPG,!,PSALN,!
	W "  DATE",?23,"TOTAL",?45,"$/DISP",?67,"TOTAL",!," DISPENSED",?23,"DISP",?46,"UNIT",?68,"COST",!,PSALN
	Q
Q	D ^%ZISC K PNTDATA,PNTDATE,PNTPRICE,PNTQTY,POP,PRINTDT,PSA,PSADAILY,PSADATE,PDADISPU,PSADR,PSADREC,PSADRUG,PSACNT,PSAPG,PSAOSIT
	K PSADRUGN,PSADT,PSAG,PSAHOW,PSAIEN,PSALN,PSALOC,PSALOCN,PSAN,PSAOP,PSAOUT,PSAP,PSAPRICE,PSAQ,PSAQTY,PSAR,PSAREC,PSARELDT,PSARX,PSAS,PSAT,PSATTLP,TTLQTY,^TMP("PSA",$J),^TMP($J)
	Q
STOP	W:$E(IOST)'="C" @IOF
	D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@" K IO("Q")
	I $D(^TMP("PSA",$J)) D
	.W !!,"Updating history and dispensing totals."
	.D ^PSAOP4
	G Q
