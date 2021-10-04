PSDPWK1 ;BIR/JPW-Print Pharm Disp. Worksheet (cont'd) ; 17 Oct 93
 ;;3.0; CONTROLLED SUBSTANCES ;;13 Feb 97
START ;compile data
 K ^TMP("PSDWK",$J),^TMP("PSDWKT",$J) S PRT=0
 I $D(PSDG) F PSD=0:0 S PSD=$O(PSDG(PSD)) Q:'PSD  F PSDN=0:0 S PSDN=$O(^PSI(58.2,PSD,3,PSDN)) Q:'PSDN  I $D(^PSD(58.8,PSDN,0)),$P(^(0),"^",4)=+PSDS S NAOU(PSDN)="",CNT=CNT+1
 F JJ=0:0 S JJ=$O(^PSD(58.85,"AW",+PSDS,JJ)) Q:'JJ  S JJDA=+$O(^PSD(58.85,"AW",+PSDS,JJ,0)) I JJDA D:$D(ALL)!($D(NAOU(+$P($G(^PSD(58.85,JJDA,0)),U,3))))
 .K ^PSD(58.85,"AW",+PSDS,JJ,JJDA) S:$D(^PSD(58.85,JJDA,2)) ^PSD(58.85,JJDA,2)=""
 F PSD=0:0 S PSD=$O(^PSD(58.85,"AE",+PSDS,PSD)) Q:'PSD  I $D(^PSD(58.85,PSD,0)) S PSDN=+$P(^(0),"^",3) I $D(ALL)!$D(NAOU(PSDN)) D
 .Q:+$P(^PSD(58.85,PSD,0),"^",7)>2
 .S PSDNA=$S($P($G(^PSD(58.8,PSDN,0)),"^")]"":$P(^(0),"^"),1:"ZZ/"_PSDN)
 .S PSDR=+$P(^PSD(58.85,PSD,0),"^",4),PSDRN=$S($P($G(^PSDRUG(PSDR,0)),"^")]"":$P(^(0),"^"),1:"ZZ/"_PSDR) S:'$D(^TMP("PSDWKT",$J,PSDRN,PSDNA)) ^TMP("PSDWKT",$J,PSDRN,PSDNA)=0
 .S QTY=$P(^PSD(58.85,PSD,0),"^",6) S ^TMP("PSDWKT",$J,PSDRN,PSDNA)=^TMP("PSDWKT",$J,PSDRN,PSDNA)+QTY
 .S ORD=+$P(^PSD(58.85,PSD,0),"^",12),ORDN=$S($P($G(^VA(200,ORD,0)),"^")]"":$P(^(0),"^"),1:"UNKNOWN")
 .S COMM=$S($D(^PSD(58.85,PSD,1,0)):1,1:0)
 .I (CNT=1)!(ANS="N") S ^TMP("PSDWK",$J,PSDNA,PSDRN,PSD)=QTY_"^"_ORDN_"^"_COMM
 .I ANS="D",CNT'=1 S ^TMP("PSDWK",$J,PSDRN,PSDNA,PSD)=QTY_"^"_ORDN_"^"_COMM
 S JJ="" F  S JJ=$O(^TMP("PSDWK",$J,JJ)) Q:JJ=""  S JJ1="" F  S JJ1=$O(^TMP("PSDWK",$J,JJ,JJ1)) Q:JJ1=""  F JJDA=0:0 S JJDA=$O(^TMP("PSDWK",$J,JJ,JJ1,JJDA)) Q:'JJDA  D
 .S PRT=PRT+1 K DA,DIE,DR S DIE=58.85,DA=JJDA,DR="13////"_PRT D ^DIE K DA,DIE,DR
 G:'$D(ZTQUEUED) PRINT^PSDPWK2
PRTQUE ;queues print after compile
 K ZTSAVE,ZTIO S ZTIO=PSDIO,ZTRTN="PRINT^PSDPWK2",ZTDESC="Print Worksheet for CS PHARM",ZTDTH=$H
 S (ZTSAVE("^TMP(""PSDWK"",$J,"),ZTSAVE("^TMP(""PSDWKT"",$J,"),ZTSAVE("PSDS*"),ZTSAVE("ANS"),ZTSAVE("CNT"),ZTSAVE("SUM"))=""
 D ^%ZTLOAD K ^TMP("PSDWK",$J),^TMP("PSDWKT",$J),ZTSK
END K %,%H,%I,%ZIS,ALL,ANS,C,CNT,COMM,DA,DIC,DIR,DIROUT,DIRUT,DTOUT,DUOUT,DUOUT,IO("Q"),JJ,JJ1,JJDA,LOOP,LOOP2,NAOU,NODE
 K OK,ORD,ORDN,PG,POP,PRT,PSD,PSDCPY,PSDEV,PSDG,PSDIO,PSDN,PSDNA,PSDOUT,PSDR,PSDRN,PSDS,PSDSN,PSDT,PSDSN
 K QTY,SEL,SUM,X,Y,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK,^TMP("PSDWK",$J),^TMP("PSDWKT",$J) D ^%ZISC
 S:$D(ZTQUEUED) ZTREQ="@"
 Q
