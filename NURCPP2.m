NURCPP2 ;HIRMFO/JH/RM-NURSING CARE PLAN DATA OUTPUT   part 2 ;4/29/93
 ;;4.0;NURSING SERVICE;;Apr 25, 1997
 G:'$O(NURSB("G",""))!($G(NURSLVD)&(NURSPLN="C")) ARG
 F NURSRTK=0:0 S NURSRTK=$O(NURSB("G",NURSRTK)) Q:NURSRTK'>0  D
 .   Q:'(NURSPLN="C"&$D(^GMR(124.3,GMRGPDA,1,"ALIST",NURSRTK))!(NURSPLN="A"&$D(^GMR(124.3,GMRGPDA,1,"B",NURSRTK))))
 .   S NURSB=$O(^GMR(124.3,GMRGPDA,1,"B",NURSRTK,0)) Q:NURSB'>0
 .   S GMRGXPRT=$S($P(NURSITHD,U,3)']"":$P($G(^GMRD(124.2,NURSRTK,0)),U,1),1:$P(NURSITHD,U,3))
 .   S GMRGXPRT(0)=$S($D(^GMR(124.3,GMRGPDA,1,NURSB,0)):$P(^(0),"^",2),1:""),GMRGXPRT(1)="^^0^^1" D EN1^GMRGRUT2 S GMRGPLN=GMRGXPRT,GMRGLEN=47 D FITLINE^GMRGRUT1
 .   F NURSE=0:0 Q:GMRGPLN(0)=""  S ^TMP($J,"NURSDATA",NURSO)="   "_GMRGPLN(0),NURSO=NURSO+1,^(NURSO)="",GMRGPLN=GMRGPLN(1),GMRGLEN=47 D FITLINE^GMRGRUT1
 .   F NURSG(1)=0:0 S NURSG(1)=$O(^TMP($J,"GMRGNAR",NURSRTK,NURSG(1))) Q:NURSG(1)'>0  S NURSC=$S('$D(^GMRD(124.2,+NURSG(1),0)):"",$P(^(0),"^",4)=NURSGOCK:1,1:0) D GLP1:'NURSC I NURSC S NURSA=0,NURSG=NURSG(1),NURSG(0)=NURSRTK D GOAL
 .   I $D(^GMR(124.3,GMRGPDA,1,NURSB,"ADD")),^("ADD")]"" S NURSADD=^("ADD"),NURSLGT=44 D FORMAT^NURCPP4
 .   S NURSO=NURSO+1,^TMP($J,"NURSDATA",NURSO)=""
 .   Q
ARG G:'$O(NURSB("I",""))!($G(NURSLVD)&(NURSPLN="C")) ARI
 F NURSRTK=0:0 S NURSRTK=$O(NURSB("I",NURSRTK)) Q:NURSRTK'>0  D
 .   Q:'(NURSPLN="C"&$D(^GMR(124.3,GMRGPDA,1,"ALIST",NURSRTK))!(NURSPLN="A"&$D(^GMR(124.3,GMRGPDA,1,"B",NURSRTK))))
 .   S NURSB=$O(^GMR(124.3,GMRGPDA,1,"B",NURSRTK,0)) Q:NURSB'>0
 .   S GMRGXPRT=$S($P(NURSITHD,U,4)']"":$P($G(^GMRD(124.2,NURSRTK,0)),U,1),1:$P(NURSITHD,U,4))
 .   S GMRGXPRT(0)=$S($D(^GMR(124.3,GMRGPDA,1,NURSB,0)):$P(^(0),"^",2),1:""),GMRGXPRT(1)="^^0^^1" D EN1^GMRGRUT2 S GMRGPLN=GMRGXPRT,GMRGLEN=47 D FITLINE^GMRGRUT1
 .   F NURSE=0:0 Q:GMRGPLN(0)=""  S ^TMP($J,"NURSDATA",NURSO)="   "_GMRGPLN(0),NURSO=NURSO+1,^(NURSO)="",GMRGPLN=GMRGPLN(1),GMRGLEN=47 D FITLINE^GMRGRUT1
 .   F NURSI(1)=0:0 S NURSI(1)=$O(^TMP($J,"GMRGNAR",NURSRTK,NURSI(1))) Q:NURSI(1)'>0  D AL1
 .   I $D(^GMR(124.3,GMRGPDA,1,NURSB,"ADD")),^("ADD")]"" S NURSLGT=44,NURSADD=^("ADD") D FORMAT^NURCPP4
 .   Q
ARI Q
 ;
AL1 ;
 S NURSC=$S('$D(^GMRD(124.2,+NURSI(1),0)):"",$P(^(0),"^",4)=NURSINCK:1,1:0) D ILP1^NURCPP4:'NURSC I NURSC S NURSA=0,NURSI=NURSI(1),NURSI(0)=NURSRTK D INTER^NURCPP4
 Q
GLP1 ;
 S NURSA(0)=$S($D(^TMP($J,"GMRGNAR",NURSRTK,NURSG(1),0)):^(0),1:""),NURSA=$P(NURSA(0),"^"),NURSA(1)=+$P(NURSA(0),"^",3)
 F NURSK=1:1:$P(NURSA(0),"^",2) S ^TMP($J,"NURSDATA",NURSO)="     "_^TMP($J,"GMRGNAR",NURSRTK,NURSG(1),NURSK),NURSO=NURSO+1
 F NURSG=0:0 S NURSG=$O(^TMP($J,"GMRGNAR",NURSG(1),NURSG)) Q:NURSG'>0  S NURSG(0)=NURSG(1) D GOAL
 S NURSA(0)=+$O(^GMR(124.3,GMRGPDA,1,"B",NURSA(1),0)) I $D(^GMR(124.3,GMRGPDA,1,NURSA(0),"ADD")),^("ADD")]"" S NURSADD=^("ADD"),NURSLGT=44-(NURSA*3) D FORMAT^NURCPP4
 S NURSO=NURSO+1,^TMP($J,"NURSDATA",NURSO)=""
 Q
GOAL ; CHECK FOR GOAL GOAL/EXPECTED OUTCOME TARGET DATE
 S NURST(0)=1,^TMP($J,"NURSDATA",NURSO)=$E(NURSSS,1,NURSA*3+5)_"-"_$S($D(^TMP($J,"GMRGNAR",NURSG(0),NURSG,NURST(0))):^(NURST(0)),1:"")
 F NURST(1)=0:0 S NURST(1)=$O(^TMP($J,"NURSDATE",NURSG,NURST(1))) Q:NURST(1)'>0  F NURST=0:0 S NURST=$O(^TMP($J,"NURSDATE",NURSG,NURST(1),NURST)) Q:NURST'>0  D GOAL1
 I $D(^TMP($J,"NURSDATA",NURSO)),^(NURSO)'="" S NURSO=NURSO+1,^(NURSO)=""
 F NURST=NURST(0):0 S NURST=$O(^TMP($J,"GMRGNAR",NURSG(0),NURSG,NURST)) Q:NURST'>0  S ^TMP($J,"NURSDATA",NURSO)=$E(NURSSS,1,NURSA*3+6)_^TMP($J,"GMRGNAR",NURSG(0),NURSG,NURST),NURSO=NURSO+1,^TMP($J,"NURSDATA",NURSO)=""
 Q
 ;
GOAL1 ;
 S X=$S($D(^TMP($J,"NURSDATE",NURSG,NURST(1),NURST)):^(NURST),1:"")
 S Y=$P(X,"^",2) S:Y'="" Y=$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3) S NURSTAT=$S($L($P(X,"^",4)):"("_$P(X,"^",4)_")"_$E(" ",1,2-$L($P(X,"^",4))),1:"    ")
 S NURSRN=$E($S($D(^VA(200,+$P(X,"^",3),0)):$P($P(^(0),"^"),","),1:"")_"          ",1,10)
 S X=^TMP($J,"NURSDATA",NURSO),^(NURSO)=X_$E(NURSSS,1,57-$L(X))_NURSH3_Y_NURSTAT_NURSRN,NURSO=NURSO+1,X=""
 S:$S('$D(^TMP($J,"GMRGNAR",NURSG(0),NURSG,NURST(0)+1)):0,$E(^(NURST(0)+1))'=" ":1,1:0) NURST(0)=NURST(0)+1,X=$E(NURSSS,1,NURSA*3+6)_^(NURST(0)) S ^TMP($J,"NURSDATA",NURSO)=X
 Q
