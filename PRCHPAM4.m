PRCHPAM4	;WISC/DJM-PRINT AMENDMENT, ROUTINE #3 ;6/29/00  12:21
V	;;5.1;IFCAP;**180**;Oct 20, 2000;Build 5
	;Per VHA Directive 2004-038, this routine should not be modified.
	;
	;PRC*5.1*180 Add Amend to Delivery date display (98-7)
	;
E25	;Edit MAIL INVOICE TO PRINT
	N CHANGE,OLD,MIT,LCNT,DATA,SITE
	S CHANGE=0 D LCNT^PRCHPAM5(.LCNT)
	F  S CHANGE=$O(^PRC(443.6,PRCHPO,6,PRCHAM,3,"AC",AMEND,.04,CHANGE)) Q:CHANGE'>0  D
	.S SITE=$P($G(^PRC(443.6,PRCHPO,23)),U,7),SITE=$S($G(SITE)]"":SITE,1:$P($P(^PRC(443.6,PRCHPO,0),U),"-"))
	.S OLD=^PRC(443.6,PRCHPO,6,PRCHAM,3,CHANGE,1,1,0),OLD=$P($S($D(^PRC(411,SITE,4,OLD,0)):^(0),1:""),U)
	.S MIT=$P(^PRC(443.6,PRCHPO,12),U,6),MIT=$P($S($D(^PRC(411,SITE,4,MIT,0)):^(0),1:""),U)
	.D LINE^PRCHPAM5(.LCNT,2) S DATA="MAIL INVOICE to "_OLD_" has been  **AMENDED**  to become MAIL INVOICE to "_MIT
	.D DATA^PRCHPAM5(.LCNT,DATA),LCNT1^PRCHPAM5(LCNT)
	Q
E26	;Edit METHOD OF PAYMENT PRINT
	N CHANGE,MOP,OLD,LCNT,DATA
	S CHANGE=0 D LCNT^PRCHPAM5(.LCNT)
	F  S CHANGE=$O(^PRC(443.6,PRCHPO,6,PRCHAM,3,"AC",AMEND,.02,CHANGE)) Q:CHANGE'>0  D
	.S OLD=^PRC(443.6,PRCHPO,6,PRCHAM,3,CHANGE,1,1,0),OLD=$P(^PRCD(442.5,OLD,0),U)
	.S MOP=$P(^PRC(443.6,PRCHPO,0),U,2),MOP=$P(^PRCD(442.5,MOP,0),U)
	.D LINE^PRCHPAM5(.LCNT,2) S DATA="METHOD of PAYMENT of "_OLD D DATA^PRCHPAM5(.LCNT,DATA)
	.S DATA="has been changed to "_MOP D DATA^PRCHPAM5(.LCNT,DATA),LCNT1^PRCHPAM5(LCNT)
	Q
E27	;ADMINISTRATIVE CERTIFICATION Add PRINT
	N CHANGE,CHANGES,AC,VAL,LCNT,DATA
	S CHANGE=0 D LCNT^PRCHPAM5(.LCNT)
	F  S CHANGE=$O(^PRC(443.6,PRCHPO,6,PRCHAM,3,"AC",AMEND,.01,CHANGE)) Q:CHANGE'>0  D
	.S CHANGES=^PRC(443.6,PRCHPO,6,PRCHAM,3,CHANGE,0)
	.S AC=$P(CHANGES,U,4),VAL=$G(^PRC(443.6,PRCHPO,15,AC,0)) Q:VAL=""
	.S AC=$P(VAL,U),VAL=$P($G(^PRC(442.7,+VAL,0)),U,2)
	.D LINE^PRCHPAM5(.LCNT,2) S DATA="ADMINISTRATIVE CERTIFICATION "_AC_", "_VAL_", has been ADDED"
	.D DATA^PRCHPAM5(.LCNT,DATA),LCNT1^PRCHPAM5(LCNT)
	Q
E28	;ADMINISTRATIVE CERTIFICATION Delete PRINT
	N CHANGE,CHANGES,AC,OLD,LCNT,DATA
	S CHANGE=0 D LCNT^PRCHPAM5(.LCNT)
	F  S CHANGE=$O(^PRC(443.6,PRCHPO,6,PRCHAM,3,"AC",AMEND,.01,CHANGE)) Q:CHANGE'>0  D
	.S CHANGES=^PRC(443.6,PRCHPO,6,PRCHAM,3,CHANGE,0),OLD=^PRC(443.6,PRCHPO,6,PRCHAM,3,CHANGE,1,1,0)
	.S AC=$P(CHANGES,U,4),OLD=$S(OLD>0:$P($G(^PRC(442.7,+OLD,0)),U,2),1:""),OLD=$S(OLD]"":", "_OLD_",",1:"")
	.D LINE^PRCHPAM5(.LCNT,2) S DATA="ADMINISTRATIVE CERTIFICATION "_AC_OLD D DATA^PRCHPAM5(.LCNT,DATA)
	.S DATA="has been DELETED"
	.D DATA^PRCHPAM5(.LCNT,DATA),LCNT1^PRCHPAM5(LCNT)
	Q
E29	;EST. SHIPPING Edit PRINT
	N CHANGE,OLD,EST,LCNT,DATA,OBOC,OBOC1,FLAG
	S CHANGE=0 D LCNT^PRCHPAM5(.LCNT)
	F  S CHANGE=$O(^PRC(443.6,PRCHPO,6,PRCHAM,3,"AC",AMEND,13,CHANGE)) Q:CHANGE'>0  D
	.S OLD=^PRC(443.6,PRCHPO,6,PRCHAM,3,CHANGE,1,1,0),OLD=$FN(OLD,"-",2)
	.S EST=$P(^PRC(443.6,PRCHPO,0),U,13),EST=$FN(EST,"-",2)
	.S (OBOC1,FLAG)=0 K OBOC
	.F  S OBOC1=$O(^PRC(443.6,PRCHPO,6,PRCHAM,3,"AC",AMEND,13.05,OBOC1)) Q:OBOC1'>0  D  Q:FLAG=1
	..S OBOC=+(^PRC(443.6,PRCHPO,6,PRCHAM,3,OBOC1,1,1,0)),FLAG=1 Q
	.I '$D(OBOC) S OBOC=+$P($G(^PRC(443.6,PRCHPO,23)),U)
	.D LINE^PRCHPAM5(.LCNT,2)
	.I OLD'>0 D
	..S DATA="**ADDED THROUGH AMENDMENT**" D DATA^PRCHPAM5(.LCNT,DATA)
	..S DATA="Estimated Shipping and/or Handling of $"_EST_" has been added" D DATA^PRCHPAM5(.LCNT,DATA)
	..S DATA="BOC: "_+$P($G(^PRC(443.6,PRCHPO,23)),U) D DATA^PRCHPAM5(.LCNT,DATA)
	..Q
	.I OLD>0 D
	..S DATA="Estimated Shipping and/or Handling of $"_OLD_" has been changed" D DATA^PRCHPAM5(.LCNT,DATA) S DATA="to $"_EST D DATA^PRCHPAM5(.LCNT,DATA)
	..S DATA="BOC: "_OBOC_" has been changed to: "+$P($G(^PRC(443.6,PRCHPO,23)),U) D DATA^PRCHPAM5(.LCNT,DATA)
	..Q
	.D LCNT1^PRCHPAM5(LCNT)
	.Q
	Q
E98	;
	;Edit DELIVERY DATE           ;PRC*5.1*180 Display of Delivery Date amend
	N CHANGE,DDATE,OLD,LCNT,DATA
	S CHANGE=0 D LCNT^PRCHPAM5(.LCNT)
	F  S CHANGE=$O(^PRC(443.6,PRCHPO,6,PRCHAM,3,"AC",AMEND,7,CHANGE)) Q:CHANGE'>0  D
	.S OLD=^PRC(443.6,PRCHPO,6,PRCHAM,3,CHANGE,1,1,0)
	.S DDATE=$P(^PRC(443.6,PRCHPO,0),U,10)
	.D LINE^PRCHPAM5(.LCNT,2) S DATA="DELIVERY DATE "_$$FMTE^XLFDT(OLD)_" has been changed to "_$$FMTE^XLFDT(DDATE) D DATA^PRCHPAM5(.LCNT,DATA),LCNT1^PRCHPAM5(LCNT)
	Q
