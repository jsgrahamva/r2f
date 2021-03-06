IBOHDT1	;ALB/EMG  -  REPORT OF CHARGES ON HOLD > 60 DAYS-CONT ;FEB 18 1997
	;;2.0;INTEGRATED BILLING;**70,95,347,452**;21-MAR-94;Build 26
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;
REPORT	;
	N IBQUIT,IBPAGE,IBNOW,IBLINE,IBCRT,IBBOT,DFN,IBNAME,IBATYPE,IBN,X
	S IBCRT=0,IBBOT=6,IBQUIT=0 I $E(IOST,1,2)="C-" S IBCRT=1,IBBOT=4
	S IBLINE="",$P(IBLINE,"=",96)="||",IBLINE=IBLINE_$E(IBLINE,1,32)
	S IBNOW=$$FMTE^XLFDT($$NOW^XLFDT)
	I IBCRT W @IOF
LOOP	;
	S IBPAGE=1 D HEADER Q:IBQUIT
	S IBNAME="" F  S IBNAME=$O(^TMP($J,"HOLD",IBNAME)) Q:IBNAME=""  S DFN=0 F  S DFN=$O(^TMP($J,"HOLD",IBNAME,DFN)) Q:DFN=""  D PRNTPAT Q:IBQUIT  S IBATYPE="" F  S IBATYPE=$O(^TMP($J,"HOLD",IBNAME,DFN,IBATYPE)) Q:IBATYPE=""  D
	.S IBN=0 F  S IBN=$O(^TMP($J,"HOLD",IBNAME,DFN,IBATYPE,IBN)) Q:'IBN!(IBQUIT)  D
	..D PRNTCHG,PRNTBILL:'IBQUIT
	Q
PRNTBILL	; prints bills for a charge
	N IB,IB0,IBSTAT,IBCHG,IBPD,Y,I,IBT
	D:$Y-IBBOT+1>IOSL HEADER Q:IBQUIT
	S IB="" F I=1:1 S IB=$O(^TMP($J,"HOLD",IBNAME,DFN,IBATYPE,IBN,IB)) W:'IB&(I<2) ?90,"||",! D:$Y+IBBOT>IOSL HEADER Q:'IB!(IBQUIT)  D
	.W ?95,"||"
	.S IB0=$G(^DGCR(399,IB,0)) Q:IB0=""
	.W ?98,$P(IB0,"^",1) ; bill #
	.S IBSTAT=$$STA^PRCAFN(IB)
	.W:+IBSTAT>0 ?106,$E($P(IBSTAT,"^",2),1,3)
	.S IBT=$J((+^DGCR(399,IB,"U1")-$P(^("U1"),"^",2)),9,2)
	.W ?113,IBT ; total charges
	.S IBPD=$$TPR^PRCAFN(IB) S:IBPD<0 IBPD="" S IBPD=$J(IBPD,9,2) W ?122,IBPD,! D:$Y+IBBOT>IOSL HEADER
	Q
PRNTPAT	; prints patient data
	N VAERR,VADM,IBSSN D DEM^VADPT S:'VAERR IBNAME=$G(VADM(1)),IBSSN=VA("BID") ; pt id,brief
	D:$Y+IBBOT>IOSL HEADER Q:IBQUIT
	W $E(IBNAME,1,20),?22,IBSSN
	Q
PRNTCHG	; prints a charge
	N IBACT,IBTYPE,IBBILL,IBFR,IBTO,IBCHG,IBND,IBND1,IBDAY,IBOHDT,X1,X2
	N IBRX,IBRXN,IBRF,IBRDT,IBX,IENS,IBECME
	S IBND=$G(^IB(IBN,0))
	S IBND1=$G(^IB(IBN,1))
	S (IBRX,IBRXN,IBRF,IBRDT,IBX,IBECME)=0
	; action id
	S IBACT=+IBND
	; type
	S IBTYPE=$P(IBND,"^",3),IBTYPE=$P($G(^IBE(350.1,IBTYPE,0)),"^",1),IBTYPE=$S(IBTYPE["PSO NSC":"RXNSC",IBTYPE["PSO SC":"RX SC",1:$E(IBTYPE,4,7))
	; bill #
	; S IBBILL=$P($P(IBND,"^",11),"-",2)
	;
	; rx info
	I $P(IBND,"^",4)["52:" D
	. S IBRXN=$P($P(IBND,"^",4),":",2)                ; Rx ien
	. S IBRX=$P($P(IBND,"^",8),"-")                   ; external Rx#
	. S IBRF=$P($P(IBND,"^",4),":",3)                 ; fill# or 0 for original fill
	. S IBECME=$P($$CLAIM^BPSBUTL(+IBRXN,+IBRF),U,6)  ; ecme#  DBIA 4719
	. I IBRF S IENS=+IBRF,IBRDT=$$SUBFILE^IBRXUTL(+IBRXN,+IENS,52,.01)    ; refill date
	. I 'IBRF S IENS=+IBRXN,IBRDT=$$FILE^IBRXUTL(IENS,22)                 ; fill date
	. Q
	;
	S IBX=$$APPT^IBCU3(IBRDT,DFN)
	; from/fill date
	S IBFR=$$DAT1^IBOUTL($S(+IBRXN>0:IBRDT,1:$P(IBND,"^",14)))
	; to date
	S IBTO=$$DAT1^IBOUTL($S($P(IBND,"^",15)'="":$P(IBND,"^",15),1:$P(IBND1,"^",2)))
	; on hold date
	S IBOHDT=$$DAT1^IBOUTL($P(IBND1,"^",6))
	; number of days on hold
	S X1=DT,X2=$P(IBND1,"^",6) D ^%DTC S IBDAY=$J(X,7)
	; charge$
	S IBCHG=$J(+$P(IBND,"^",7),9,2)
	W ?29,IBACT,?39,IBTYPE W:IBRX>0 ?46,"Rx #: "_IBRX_$S(IBRF>0:"("_IBRF_")",1:""),?68,$S(IBECME:"ECME #: "_IBECME,1:""),?95,"||",!
	W:IBX=1 ?45,"*"
	W ?46,IBFR,?55,IBTO,?66,IBOHDT,?77,IBDAY,?86,IBCHG
	Q
HEADER	; writes the report header
	Q:IBQUIT
	I IBCRT,$Y>1 D  Q:IBQUIT
	.F  Q:$Y>(IOSL-3)  W !
	.N T R "    Press RETURN to continue",T:DTIME I '$T!(T["^") S IBQUIT=1 Q
	I IBPAGE>1 W !,@IOF
	W ?53,"CHARGES ON HOLD LONGER THAN "_IBNUM_" DAYS",?110,IBNOW,"  PAGE ",IBPAGE,!,"HELD CHARGES",?98,"CORRESPONDING THIRD PARTY BILLS",!,IBLINE
	W !,?46,"From/",?55,"To/",?66,"On Hold",?77,"# Days",?95,"||",?105,"AR"
	W !,"Name",?22,"Pt.ID",?29,"Act.ID",?39,"Type",?46,"Fill Dt",?55,"Rls Dt",?66,"Date",?77,"On Hold",?89,"Charge",?95,"||",?98,"Bill#",?105,"Status",?113,"Charge",?125,"Paid"
	W !,IBLINE,!
	W ?44,"'*' = outpt visit on same day as Rx fill date",?95,"||",!,IBLINE,!
	S IBPAGE=IBPAGE+1
	Q
