PRCSP124 ;SF-ISC/LJP-2237 CON'T - DISTRIBUTION LIST ;4/21/93  08:55
V ;;5.1;IFCAP;;Oct 20, 2000
 ;Per VHA Directive 10-93-142, this routine should not be modified.
LST K ^UTILITY($J,"W"),P(0) S DIWL=3,DIWR=80,DIWF="N",P(1)=0,PRCSPG=""
 F I=1:1 S P(1)=$O(^PRCS(410,DA,"IT",P(1))) Q:P(1)'>0  I $D(^PRCS(410,DA,"IT",P(1),0)),$D(^PRCS(410,DA,"IT",P(1),2,0)),$P(^(0),"^",4)>0 S:'$D(P(0)) (P(0),PRCSPG)=1 D HDR:P(0)=1 D HDR1,LST1 S P(0)=P(0)+1
 D WRT:$D(^UTILITY($J,"W",DIWL))
 Q
LST1 Q:'$D(^PRCS(410,DA,"IT",+P(1),0))  S Z=^(0),(PRCSIN,PRCSQTY,P("PR"),P("PR1"))=""
 S PRCSIN=$P(Z,U),PRCSQTY=$P(Z,U,2),PRCSDES="" S:$D(^PRCS(410,DA,"IT",P(1),1,1,0)) PRCSDES=$E(^(0),1,10)
 S P("PR1")="",P("PR")=$P(Z,U,5) I $D(^PRC(441,+P("PR"),1,0)) S P("PR1")=0 S P("PR1")=$O(^PRC(441,P("PR"),1,P("PR1"),0)) I P("PR1")'="" S PRCSDES=$E(P("PR1"),1,10)
 S:PRCSDES="" PRCSDES="**NONE**" S X=PRCSIN_"|TAB(6)|"_$J(P("PR"),4)_"|TAB(12)|"_PRCSDES_"|TAB(26)|"_$J(PRCSQTY,4) D DIWP^PRCUTL($G(DA))
 D DS,DS1 Q
DS K PRCSDS S PRCSDS=0,PRCSDSD="",PRCSLNT=""
 F J=1:1 S PRCSDS=$O(^PRCS(410,DA,"IT",P(1),2,PRCSDS)) Q:PRCSDS'>0  I $D(^(PRCSDS,0)),$P(^(0),U,2),$D(^PRCS(410.6,+$P(^(0),U,2),0)) S PRCSDSD=$P(^(0),U,2) I PRCSDSD'="" S PRCSDS(PRCSDSD,J)=^(0)
 Q
DS1 S PRCSDSD=0
 F K=1:1 S PRCSDSD=$O(PRCSDS(PRCSDSD)) Q:PRCSDSD'>0  S PRCSLN=0 F M=1:1 S PRCSLN=$O(PRCSDS(PRCSDSD,PRCSLN)) Q:PRCSLN'>0  D DS2
 Q
DS2 S PRCSLNT=PRCSDS(PRCSDSD,PRCSLN),X="|TAB(32)|"_$E($P(PRCSLNT,U,2),4,5)_"-"_$E($P(PRCSLNT,U,2),6,7)_"-"_$E($P(PRCSLNT,U,2),2,3)
 S XX=X_"|TAB(42)|"_$J($P(PRCSLNT,U,4),4)_"|TAB(49)|"_$S($D(^PRCS(410.4,+$P(PRCSLNT,U,5),0)):$E($P(^(0),U),1,10),1:"**NONE**")_"|TAB(60)|"_$S($D(^PRCS(410.8,+$P(PRCSLNT,U,3),0)):$E($P(^(0),U),1,10),1:"**NONE**")
 S X=XX D DIWP^PRCUTL($G(DA)) Q
HDR W:$Y>0 @IOF W ?31,$P(^PRCS(410,DA,0),U),!,L,!?16,"REQUEST, TURN-IN, AND RECEIPT FOR PROPERTY OR SERVICES",!,L,!!,"MULTIPLE DELIVERY DISTRIBUTION LIST",?50,"PAGE: "_$S($D(PRCSPG):PRCSPG,1:""),! Q
HDR1 S X="" D DIWP^PRCUTL($G(DA)) S X="ITEM PR#   DESCRIPTION    QTY  DATE      QTY    SCP        LOCATION" D DIWP^PRCUTL($G(DA)) Q
HDR2 W !,"MULTIPLE DELIVERY DISTRIBUTION LIST",?50,"PAGE: ",$S($D(PRCSPG):PRCSPG,1:"") Q  ;,!,"ITEM# PR#  DESCRIPTION    QTY  DATE       QTY     SCP         LOCATION",! Q
WRT I '$D(^UTILITY($J,"W",DIWL)) S ^(DIWL)=1,^(DIWL,1,0)="***NO DESCRIPTION***"
 S PRCSILP=0 F N=1:1 S PRCSILP=$O(^UTILITY($J,"W",DIWL,PRCSILP)) Q:PRCSILP'>0  W ?3,^UTILITY($J,"W",DIWL,PRCSILP,0),! S:IOSL-$Y<2 PRCSPG=PRCSPG+1 D:IOSL-$Y<2 HDR Q:Z1=U
 Q
 S Z=^UTILITY($J,"W",DIWL)
 I Z>1 F J=1:1:(Z-1) W ?3,^UTILITY($J,"W",DIWL) Q:DIWL'>0  D:IOSL-$Y<2 HDR Q:Z1=U  W !
 I Z>1 W ?3,^UTILITY($J,"W",DIWL,Z,0) D:IOSL-$Y<2 HDR Q:Z1=U  W !
 I Z<2 W ?3,^UTILITY($J,"W",DIWL,1,0) D:IOSL-$Y<2 HDR Q:Z1=U  W !
