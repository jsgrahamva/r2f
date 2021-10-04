RMPRSE1 ;PHX/RFM-SEARCH FILE 660 ENTRIES FOR ITEM HISTORY ;8/29/1994
 ;;3.0;PROSTHETICS;**20,57,77,90**;Feb 09, 1996
 ;RVD 3/17/03 patch #77 - allow queing to p-message.  IO to ION.
 ;                      - use RMPR("STA") instead of $$STA^RMPRUTIL.
 ;
EN N ITEM,RMPRARR,RMPRI D HOME^%ZIS,DIV4^RMPRSIT G:$D(X) EXIT1 S DIC="^RMPR(661,",DIC(0)="AEQM" F ITEM=1:1 S DIC("A")="Select ITEM "_ITEM_": " D ^DIC G:$D(DTOUT)!(X["^")!(X=""&(ITEM=1)) EXIT1 Q:X=""  D
 .I $D(RMPRI(+Y)) W $C(7)," ??",?40,"..Duplicate Item" S ITEM=ITEM-1 Q
 .S RMPRARR(ITEM)=+Y,RMPRI(+Y)=""
 S RMPRCOUN=0 W !! S %DT("A")="Beginning Date: ",%DT="AEPX",%DT("B")="T-30" D ^%DT S RMPRBDT=Y G:Y<0 EXIT1
ENDATE S %DT("A")="Ending Date: ",%DT="AEX",%DT("B")="TODAY" D ^%DT G:Y<0 EXIT1 I RMPRBDT>Y W !,$C(7),"Invalid Date Range Selection!!" G ENDATE
 G:Y<0 EXIT S RMPREDT=Y,Y=RMPRBDT D DD^%DT S RMPRX=Y,Y=RMPREDT D DD^%DT S RMPRY=Y
 S %ZIS="MQ" K IOP D ^%ZIS G:POP EXIT
 I '$D(IO("Q")) U IO G PRINT
 K IO("Q") S ZTDESC="SEARCH FOR RECALLED ITEM",ZTRTN="PRINT^RMPRSE1",ZTIO=ION,ZTSAVE("RMPRBDT")="",ZTSAVE("RMPREDT")="",ZTSAVE("RMPRI(")="",ZTSAVE("RMPRX")="",ZTSAVE("RMPRY")="",ZTSAVE("RMPR(""STA"")")="",ZTSAVE("RMPRARR(")=""
 D ^%ZTLOAD W:$D(ZTSK) !,"REQUEST QUEUED!" H 1 G EXIT1
PRINT ;ENTRY POINT FOR PRINTING REPORT
 S PAGE=1,(RMPRCOUN,RP,QTYT,COSTT)=0 I IOST["C-" D WAIT^DICD
PRI S RQ=0 F  S RQ=$O(RMPRARR(RQ)) Q:RQ=""!($D(KILL))  S RO=$P(RMPRARR(RQ),U),RO=RO-1 D PRI1
 G EXIT
PRI1 F  S RO=$O(^RMPR(660,"AD",RO)) D:RO=""!(RO'=$P(RMPRARR(RQ),U)) REST Q:RO=""!(RO'=$P(RMPRARR(RQ),U))!($D(KILL))  K ENDD F  S RP=$O(^RMPR(660,"AD",RO,RP)) Q:RP=""!($D(KILL))  D CK
 Q
EXIT ;EXIT FROM REPORT HERE
 I RMPRCOUN>0,$D(RMPREDT),'$D(KILL) W !!?32,"END OF REPORT"
 I $E(IOST)["C"&($Y<22),'$D(ENDD) F  W ! Q:$Y>20
 I $D(RMPREDT),$E(IOST)["C",'$D(RMPRFLL),'$D(KILL),'$D(DUOUT),'$D(DTOUT),'$D(ENDD) K DIR S DIR(0)="E" D ^DIR
EXIT1 K RMPRARR,%DT,GOTO,QTYT,ITEM,KILL,ENDD,RQ,RP,RO,ITEM,RMPRI,COSTT,DIC,DIR,PAGE,RO,RMPRCOUN,RMPRSE,RMPRBDT,RMPREDT,RMPRX,RMPRY D ^%ZISC
 Q
CK Q:'$D(^RMPR(660,RP,0))
 I $P(^RMPR(660,RP,0),U,10)'=RMPR("STA") Q
 I ($P(^(0),U,4)="X")!('$P(^(0),U,6))!($P(^(0),U,3)<RMPRBDT)!($P(^(0),U,3)>RMPREDT)  Q  I '$D(^PRC(441,$P(^RMPR(661,$P(^(0),U,6),0),U))) Q
 I $P(RMPRARR(RQ),U)=$P(^RMPR(660,RP,0),U,6) D CON
 Q
CON I $Y>(IOSL-6),PAGE=1,'RMPRCOUN W @IOF
 D HEAD S RMPRCOUN=RMPRCOUN+1
 S Y=$P(^RMPR(660,RP,0),U,3) D DD^%DT W !,Y,?15,$E($P(^DPT($P(^RMPR(660,RP,0),U,2),0),U,1),1,13),?30,$E($P(^DPT($P(^RMPR(660,RP,0),U,2),0),U,9),6,9)
 W:$P(^RMPR(660,RP,0),U,9)'="" ?36,$E($P(^PRC(440,$P(^RMPR(660,RP,0),U,9),0),U,1),1,35)
 W !,"SERIAL NBR:",?12,$E($P(^RMPR(660,RP,0),U,11),1,12),?25,"QTY: ",$J($P(^(0),U,7),4),?38,"TOTAL COST: ",$J($FN($P(^(0),U,16),"P",2),8) S QTYT=QTYT+$P(^(0),U,7),COSTT=COSTT+$P(^(0),U,16)
 W ?60,$S($P(^RMPR(660,RP,0),U,4)="I":"INITIAL ISSUE",$P(^(0),U,4)="R":"REPLACEMENT",$P(^(0),U,4)="S":"SPARE",$P(^(0),U,4)="X":"REPAIR",$P(^(0),U,4)="5":"RENTAL",1:"UNK"),!,"INITIATOR: "
 I $P(^RMPR(660,RP,0),U,27),$D(^VA(200,$P(^(0),U,27),0)) W ?15,$P(^(0),U),!
 I $E(IOST)["C"&($Y>(IOSL-6)) S DIR(0)="E" D ^DIR S:Y<1 KILL=1 Q:Y<1  K DIR W @IOF D HEAD Q
 I $Y>(IOSL-6) W @IOF D HEAD
 Q
HEAD I $Y<2!(PAGE=1) W !,"ITEM HISTORY:",?15,$E($P(^PRC(441,$P(^RMPR(661,$P(^RMPR(660,RP,0),U,6),0),U,1),0),U,2),1,39),?63,"STA ",RMPR("STA"),?72,"PAGE ",PAGE S PAGE=PAGE+1
 I  W !!,"REQUEST DATE",?15,"PATIENT NAME",?30,"SSN",?36,"VENDOR" S Y=RMPRBDT D DD^%DT W ?55,Y,"-" S Y=RMPREDT D DD^%DT W Y
 Q
REST D:'RMPRCOUN NONE Q:$D(KILL)!('RMPRCOUN)  W !,"TOTAL DOLLARS SPENT ON THIS ITEM: ","$"_$J($FN(COSTT,"P",2),9),?45,"TOTAL QUANTITY ISSUED: ",$J(QTYT,4) I $O(RMPRARR(RQ)),$E(IOST)["C" W ! K DIR S DIR(0)="E" D ^DIR S:Y<1 KILL=1 W:'$D(KILL) @IOF
 I $E(IOST)'["C",$O(RMPRARR(RQ)) W @IOF
 S (COSTT,QTYT,RMPRCOUN)="" Q
NONE W @IOF,!!,"No Item History for this date range for:",!,$P(^PRC(441,$P(^RMPR(661,$P(RMPRARR(RQ),U),0),U),0),U,2) I $E(IOST)["C" K DIR S DIR(0)="E" W !!!! D ^DIR S:Y<1 KILL=1 S ENDD=1
 Q
