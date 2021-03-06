PSDPLOG2	;BIR/JPW  -Inspector's Log (cont'd) ;2 Aug 94
	;;3.0;CONTROLLED SUBSTANCES;**73**;13 Feb 97;Build 8
PRINT	;print inspector's log by naou, drug and green sheet #
	S (PG,PSDOUT,NAOU)=0 D NOW^%DTC S Y=+$E(%,1,12) X ^DD("DD") S RPDT=Y
	K LN S $P(LN,"-",132)="" I '$D(^TMP("PSDLOG",$J)) D HDR W !!,?45,"****  NO PENDING NARCOTIC ORDERS FOR INSPECTION  ****",! G DONE
	S NAOU="" F  S NAOU=$O(^TMP("PSDLOG",$J,NAOU)) Q:NAOU=""!(PSDOUT)  D HDR Q:PSDOUT  W !,?2,"=> NAOU: ",NAOU,! S LNUM=$Y D  Q:PSDOUT  D PRT
	.I ASKN D LOOP2 Q
	.S PSDRN="" F  S PSDRN=$O(^TMP("PSDLOG",$J,NAOU,PSDRN)) Q:PSDRN=""!(PSDOUT)  D  Q:PSDOUT
	..I $Y+8>IOSL D PRT,HDR Q:PSDOUT  W !,?2,"=> NAOU: ",NAOU,! S LNUM=$Y
	..S NUM="" F  S NUM=$O(^TMP("PSDLOG",$J,NAOU,PSDRN,NUM)) Q:NUM=""!(PSDOUT)  F PSDCNT=0:0 S PSDCNT=$O(^TMP("PSDLOG",$J,NAOU,PSDRN,NUM,PSDCNT)) Q:'PSDCNT!(PSDOUT)  D  Q:PSDOUT
	...I $Y+8>IOSL D PRT,HDR Q:PSDOUT  W !,?2,"=> NAOU: ",NAOU,! S LNUM=$Y
	...S NODE=$G(^TMP("PSDLOG",$J,NAOU,PSDRN,NUM,PSDCNT))
	...W !,$P(NODE,"^",4),?2,$S(ASK="N":PSDRN,1:NUM),?13,$S(ASK="D":PSDRN,1:NUM),$$SCH($P(NODE,"^",6)),?65,$P(NODE,"^",2),?72,$J($P(NODE,"^"),6),?91,$P(NODE,"^",3),?104,"____________",?118,"____________",!
	...S LNUM=$Y
DONE	I $E(IOST)'="C" W @IOF
	I $E(IOST,1,2)="C-",'PSDOUT W ! K DIR,DIRUT S DIR(0)="EA",DIR("A")="END OF REPORT!  Press <RET> to return to the menu" D ^DIR K DIR
END	K %,%DT,%H,%I,%ZIS,ALL,ANS,ASK,ASKN,CNT,COMM,DA,DIC,DIE,DIR,DIROUT,DIRUT,DIWF,DIWL,DIWR,DR,DTOUT,DUOUT,EXP,EXPD,JJ,LN,LNUM,LOOP,LOT,MFG,NAOU,NODE,NODE3,NUM
	K OK,ORD,ORDN,PG,PSD,PSDA,PSDCNT,PSDDT,PSDG,PSDIO,PSDOK,PSDN,PSDNA,PSDOUT,PSDR,PSDRN,PSDSD,PSDST,PSDT,PSDTR,QTY,REQD,REQDT,RPDT,RQTY
	K SEL,STAT,STATN,TEXT,TYP,TYPN,X,Y,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
	K ^TMP("PSDLOG",$J) D ^%ZISC
	S:$D(ZTQUEUED) ZTREQ="@"
	Q
HDR	;header for log
	I $E(IOST,1,2)="C-",PG W ! K DA,DIR S DIR(0)="E" D ^DIR K DIR I 'Y S PSDOUT=1 Q
	S PG=PG+1 W:$Y @IOF W !,?42,"Inspector's Log for Controlled Substances",?120,"Page: ",PG,!,?52,RPDT,!
	W !,?67,"DATE",?80,"QTY"
	W !,"DISP #",?13,"DRUG",?65,"DISPENSED",?78,"DISPENSED",?91,"EXP DATE",?104,"QTY ON HAND",?118,"NAME/DATE"
	W !,LN,!
	Q
LOOP2	;print inv typ loop
	S TYPN="" F  S TYPN=$O(^TMP("PSDLOG",$J,NAOU,TYPN)) Q:TYPN=""!(PSDOUT)  W !,?4,"=> INVENTORY TYPE: ",$S($E(TYPN,1,2)="ZZ":$E(TYPN,3,99),1:TYPN),! S LNUM=$Y D
	.S PSDRN="" F  S PSDRN=$O(^TMP("PSDLOG",$J,NAOU,TYPN,PSDRN)) Q:PSDRN=""!(PSDOUT)  D  Q:PSDOUT
	..I $Y+8>IOSL D PRT,HDR Q:PSDOUT  W !,?2,"=> NAOU: ",NAOU,! W:ASKN !,?4,"=> INVENTORY TYPE: ",$S($E(TYPN,1,2)="ZZ":$E(TYPN,3,99),1:TYPN),! S LNUM=$Y
	..S NUM="" F  S NUM=$O(^TMP("PSDLOG",$J,NAOU,TYPN,PSDRN,NUM)) Q:NUM=""!(PSDOUT)  F PSDCNT=0:0 S PSDCNT=$O(^TMP("PSDLOG",$J,NAOU,TYPN,PSDRN,NUM,PSDCNT)) Q:'PSDCNT!(PSDOUT)  D  Q:PSDOUT
	...I $Y+8>IOSL D PRT,HDR Q:PSDOUT  W !,?2,"=> NAOU: ",NAOU,! W:ASKN !,?4,"=> INVENTORY TYPE: ",TYPN,! S LNUM=$Y
	...S NODE=$G(^TMP("PSDLOG",$J,NAOU,TYPN,PSDRN,NUM,PSDCNT))
	...W !,$P(NODE,"^",4),?2,$S(ASK="N":PSDRN,1:NUM),?13,$S(ASK="D":PSDRN,1:NUM),$$SCH($P(NODE,"^",6)),?65,$P(NODE,"^",2),?72,$J($P(NODE,"^"),6),?91,$P(NODE,"^",3),?104,"____________",?118,"____________",!
	...S LNUM=$Y
	Q
PRT	;
	I LNUM<IOSL-7 F JJ=LNUM:1:IOSL-7 W !
	W LN,!,"*  - Transferred to another NAOU but not yet received",!,"** - Filled not yet received",!,"#  - Returned to Stock",!
	Q
SCH(X)	;schedule conversion
	N DEA
	S DEA=+$P($G(^PSDRUG(X,0)),"^",3)
	Q:+DEA<1 ""
	Q " (Schedule "_$P("I^II^III^IV^V","^",DEA)_")"
