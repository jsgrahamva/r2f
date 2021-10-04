PSJEXP ;BIR/CML3,KKA-MEDICATION EXPIRATION NOTICES ;13 FEB 96 / 10:04 AM
 ;;5.0; INPATIENT MEDICATIONS ;**111**;16 DEC 97
 ;
 ;Reference to ^PS(55 supported by DBIA #2191.
 ;
 N OUT,PSJNEW,PSGPTMP,PPAGE S PSJNEW=1
 D ENCV^PSGSETU I $D(XQUIT) Q
 K %DT,DIC S (PSGP,WD,WG)=0,PSGSSH="EXP" S PSGPTMP=0,PPAGE=1 D ^PSGSEL G:"^"[PSGSS DONE D @PSGSS G:+Y'>0 DONE
 I PSGSS="W" S PSJSEL("W")=WD D ADMTM^PSJPDIR
 I PSGSS="C" S PSJSEL("C")="C"
 S %DT="ETX",D="start" D DT G:Y'>0 DONE S (%DT(0),PSGEXPS)=+Y,D="stop" D DT K %DT G:Y'>0 DONE S:'$P(PSGEXPS,".",2) PSGEXPS=PSGEXPS+.0001 S PSGEXPF=Y+$S($P(Y,".",2):0,1:.24)
 D LIST^PSJEXP0 G:$D(OUT) DONE
 K ZTDTH,ZTSAVE S PSGTIR="ENQ^PSJEXP",ZTDESC="INPATIENT STOP ORDER NOTICES" F X="PSJMSG","WG","WD","PSGP","PSGOP","PSGDT","PSGEXPS","PSGEXPF","PSGSS","CHOICE","PSGPTMP","PPAGE","PSJSEL(" S ZTSAVE(X)=""
 D ENDEV^PSGTI I POP!$D(ZTSK) W:POP !?3,"No device selected for report run." G DONE
 W:$E(IOST)'="P" !,"...this may take a few minutes...",!?25,"...you really should QUEUE this report, if possible..."
ENQ D NOW^%DTC S PSGDT=%,SD=$$EN^PSGCT(PSGEXPS,-1),FD=PSGEXPF F X="PSGEXPS","PSGEXPF" S @X=$$ENDTC^PSGMI(@X)
 K ^TMP("PSG",$J) D @("L"_PSGSS),^PSJEXP0
DONE D ^%ZISC D ENKV^PSGSETU K %,^TMP("PSG",$J),ADCNT,AM,CHOICE,CNT,D,DFN,DO,DOB,DRG,DRGI,DRGN,DRGT,DTOUT,DUOUT,FD,FSTFLG,GMRAREC,IR,JJ,LNCNT,MR,PSJMSG,ND,ND3,ND4,NF,ON,OPI,PRIMD,P,PSIVUP,PSJORIFN
 K PSJACNWP,PSJAD,PSJJORD,PSJPAD,PSJPAGE,PSJPDOB,PSJPDX,PSJPRB,PSJPSEX,PSJPTD,PSJPWD,PSJPWDN,PSJPWT,PSJSEL,PSJSOL,SLS,Y1
 K POP,PPN,PR,PSGDT,PSGEXPF,PSGEXPS,PSGOD,PSGP,PSGSS,PSGSSH,PSGTIR,PSEX,PSJOPC,PST,Q,RF,SCH,SD,SD1,SD1IV,SEX,SI,SM,SNDFLG,SOLCNT,SSN,ST,STD,TEAM,TEMPTM,TM,VA,WCNT,WD,WDN,WG,WRD,WS,WT,X,XQUIT,Y
 Q
LC ;
 S STDTE=0 F  S STDTE=$O(^PS(55,"AIVC",STDTE)) Q:'STDTE  S CLINIC=0 F  S CLINIC=$O(^PS(55,"AIVC",STDTE,CLINIC)) Q:'CLINIC  D
 . S JDFN=0 F  S JDFN=$O(^PS(55,"AIVC",STDTE,CLINIC,JDFN)) Q:'JDFN  S PSGP=JDFN D LP
 S STDTE=0 F  S STDTE=$O(^PS(55,"AUDC",STDTE)) Q:'STDTE  S CLINIC=0 F  S CLINIC=$O(^PS(55,"AUDC",STDTE,CLINIC)) Q:'CLINIC  D
 . S JDFN=0 F  S JDFN=$O(^PS(55,"AUDC",STDTE,CLINIC,JDFN)) Q:'JDFN  S PSGP=JDFN D LP
 Q
 ;
LG F WD=0:0 S WD=$O(^PS(57.5,"AC",WG,WD)) Q:'WD  D LW
 Q
LW I $D(^DIC(42,WD,0)),$P(^(0),"^")]"" S WDN=$P(^(0),"^")
 E  Q
 F PSGP=0:0 S PSGP=$O(^DPT("CN",WDN,PSGP)) Q:'PSGP  D LP
 Q
LL S CL="" F  S CL=$O(^PS(57.8,"AD",CG,CL)) Q:CL=""  D LC
 Q
C ;
 K DIR S DIR(0)="FAO",DIR("A")="Select CLINIC: "
 S DIR("?")="^D CDIC^PSGVBW" W ! D ^DIR
CDIC ;
 K DIC S DIC="^SC(",DIC(0)="QEMIZ" D ^DIC K DIC S:+Y>0 CL=+Y
 W:X["?" !!,"Enter the clinic you want to use to select patients for processing.",!
 Q
L ;
 K DIR S DIR(0)="FAO",DIR("A")="Select CLINIC GROUP: "
 S DIR("?")="^D LDIC^PSGVBW" W ! D ^DIR
LDIC ;
 K DIC S DIC="^PS(57.8,",DIC(0)="QEMI" D ^DIC K DIC S:+Y>0 CG=+Y
 W:X["?" !!,"Enter the name of the clinic group you want to use to select patients for processing."
 Q
LP N PSJACNWP S PSJACNWP=1 D ^PSJAC,ENUNM^PSGOU Q:'$O(^PS(55,PSGP,5,"AUS",SD))
 S PPN=$E($P(PSGP(0),"^"),1,12)_"^"_PSGP S:PSJPRB="" PSJPRB="zz"
 S TM=$O(PSJSEL("TM","")),TM=$S(TM="":"ZZ",PSJPRB="":"zz",$D(^PS(57.7,+PSJPWD,1,+$O(^PS(57.7,"AWRT",+PSJPWD,PSJPRB,0)),0)):$P(^(0),"^"),1:"zz")
 S TEMPTM=$O(^PS(57.7,+PSJPWD,1,"B",TM,0))
 Q:$D(PSJSEL("TM"))&('$D(PSJSEL("TM","ALL")))&('$D(PSJSEL("TM",+TEMPTM)))
 D:CHOICE'="IV" GS D:CHOICE'="UD" GSIV
 Q
GS F PST="C","P","R" F SD1=SD:0 S SD1=$O(^PS(55,PSGP,5,"AU",PST,SD1)) Q:'SD1!(SD1>FD)  F PSJJORD=0:0 S PSJJORD=$O(^PS(55,PSGP,5,"AU",PST,SD1,PSJJORD)) Q:'PSJJORD  I $D(^PS(55,PSGP,5,PSJJORD,0)),$P(^(0),U,9)'["D",$P(^(0),U,27)'["R" D ARSET
 I $D(^TMP("PSG",$J,$E(TM,1,10),$E(PSJPWDN,1,10),$E(PSJPRB,1,12),PPN)) S ^(PPN)=TM_"^"_PSJPWDN_"^"_PSJPRB_"^"_$P(PSGP(0),"^")_"^"_$P(PSJPSEX,"^",2)_"^"_$P(PSJPDOB,"^",2)_";"_PSJPAGE_"^"_VA("PID")_"^"_PSJPDX_"^"_PSJPWT
 ;naked reference below refers to the full global references to ^TMP on the line above
 I  S ^(PPN)=^(PPN)_"^"_$P(PSJPAD,"^",2)_"^"_$P(PSJPTD,"^",2)
 Q
GSIV S PST="C"
 S SD1IV=SD F  S SD1IV=$O(^PS(55,PSGP,"IV","AIS",SD1IV)) Q:'SD1IV!(SD1IV>FD)  F PSJJORD=0:0 S PSJJORD=$O(^PS(55,PSGP,"IV","AIS",SD1IV,PSJJORD)) Q:'PSJJORD  D
 .I $D(^PS(55,PSGP,"IV",PSJJORD,0)),$P(^(0),U,17)'["D",$P(^PS(55,PSGP,"IV",PSJJORD,2),U,9)'["R" D ARSETIV
 I $D(^TMP("PSG",$J,$E(TM,1,10),$E(PSJPWDN,1,10),$E(PSJPRB,1,12),PPN)) S ^(PPN)=TM_"^"_PSJPWDN_"^"_PSJPRB_"^"_$P(PSGP(0),"^")_"^"_$P(PSJPSEX,"^",2)_"^"_$P(PSJPDOB,"^",2)_";"_PSJPAGE_"^"_VA("PID")_"^"_PSJPDX_"^"_PSJPWT
 ;naked reference below refers to the full global references to ^TMP on the line above
 I  S ^(PPN)=^(PPN)_"^"_$P(PSJPAD,"^",2)_"^"_$P(PSJPTD,"^",2)
 Q
ARSET S ND=$G(^PS(55,PSGP,5,PSJJORD,0)),PR=$P(ND,"^",2),ST=$P(ND,"^",9),MR=$P(ND,"^",3),PR=$$ENNPN^PSGMI(PR)
 S MR=$$ENMRN^PSGMI(MR) S X=$$NFWS^PSJUTL1(PSGP,PSJJORD_"U",PSJPWD),SM=$S('$P(X,U,3):0,$P(X,U,4):1,1:2)
 S ND=$G(^PS(55,PSGP,5,PSJJORD,2)),DRG=$G(^(.2)),SCH=$P(ND,"^"),STD=$P(ND,"^",2)\1,DO=$P(DRG,"^",2) I DO]"",$E(DO,$L(DO))'=" " S DO=DO_" "
 N X,PSG
 D DRGDISP^PSJLMUT1(PSGP,PSJJORD_"U",15,0,.PSG,1)
 S DRG=PSG(1) I $G(PSJPWDN)="" S PSJPWDN="UNKNOWN"
 S ^TMP("PSG",$J,$E(TM,1,10),$E(PSJPWDN,1,10),$E(PSJPRB,1,12),PPN,SD1,PST,$S(DRG'="NOT FOUND":$E(DRG,1,15),1:"zz")_"^"_PSJJORD)=DRG_"^"_STD_"^"_DO_MR_" "_SCH_"^"_ST_"^"_PR_"^^^"_SM Q
 ;
ARSETIV N X,ON55 S DFN=PSGP,ON=PSJJORD D GT55^PSIVORFB
 S DRG=$S($G(DRG("AD",1))]"":$P(DRG("AD",1),U,2),1:$P($G(DRG("SOL",1)),U,2)),STD=P(2)\1,MR=$P(P("MR"),U,2),SCH=P(9),IR=P(8),ST=P(17),PR=$P(P(6),U,2)
 I $G(PSJPWDN)="" S PSJPWDN="UNKNOWN"
 S ^TMP("PSG",$J,$E(TM,1,10),$E(PSJPWDN,1,10),$E(PSJPRB,1,12),PPN,SD1IV,PST,$S(DRG'="NOT FOUND":$E(DRG,1,15),1:"zz")_"^"_PSJJORD_"V")=DRG_"^"_STD_"^"_MR_" "_SCH_" "_IR_"^"_ST_"^"_PR Q
 ;
G S DIC="^PS(57.5,",DIC(0)="AEIMQZ" W ! D ^DIC K DIC W ! S:X="^OTHER" PSJMSG="^OTHER",PSGSS="C",Y(0,0)=2,Y=2 S WG=+Y S:+Y>0 PSJMSG=Y(0,0) Q
W S DIC="^DIC(42,",DIC(0)="AEIMQZ",DIC("A")="Select WARD: " W ! D ^DIC K DIC S WD=+Y S:+Y>0 PSJMSG=Y(0,0) Q
P D ENP^PSGGAO S Y=PSGP S:PSGP>0 PSJMSG=$P(PSGP(0),"^") Q
DT S Y=-1 F  W !!,"Enter ",D," date: " R X:DTIME W:'$T $C(7) S:'$T X="^" D DTM:X?1."?",^%DT:"^"'[X I Y>0!("^"[X) W:Y<0 !,"No ",D," date chosen for notices run." Q
 Q
DTM W !!?2,"Enter the ",D," date of the range of dates to find orders about to expire.",!,"The start date and stop date may be the  same." W:D="stop" "  The stop date may not come before the start date." W ! Q
