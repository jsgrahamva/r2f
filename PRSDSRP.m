PRSDSRP ;HISC/GWB-STRENGTH REPORT PRINT ;8/23/93  14:28
 ;;4.0;PAID;**6**;Sep 21, 1995
ASKDEV S %ZIS="QM",%ZIS("B")="" D ^%ZIS G EXIT:POP
 I IOM<132 D ^%ZISC W !,*7,"Please select a right margin of at least 132.",! G ASKDEV
 I $D(IO("Q")) D  Q
 .S ZTRTN="START^PRSDSRP",ZTDESC="PAID STRENGTH REPORT"
 .D ^%ZTLOAD W:$D(ZTSK) !,"Request Queued!" D HOME^%ZIS K IO("Q") Q
START U IO D NOW^%DTC S Y=$J(%,"",4) D DD^%DT S PRNTDT=Y
 S $P(DASHES,"-",87)="-"
 S DASHES=DASHES_"|-------------------------|------------------"
 S PAGE=0,FIRST="1ST",PRTC=1,COMPDT=""
 S SN=$P($G(^XMB(1,1,"XUS")),"^",17)
 S SITE=$S(+SN>0:$P($G(^DIC(4,SN,0)),U,1),1:"")
 S:SITE'="" SITE=" FOR "_SITE
 S (CLGTL,FTPTL,PTPTL,PTPFTETL,FTTTL,PTTTL,PTTFTETL,INTTL,INTFTETL)=0
 S (TSRTL,TSRFTETL,SISTL,TOTTL,FTETOTTL,VARTL,LWOPTL,FEETL)=0
MCAY D INISB S CCORG="" F  S CCORG=$O(^PRSP(454.1,"B",CCORG)) Q:CCORG=""  S CCORGIEN=0,CCORGIEN=$O(^PRSP(454.1,"B",CCORG,CCORGIEN)) I $P(^PRSP(454.1,CCORGIEN,0),U,2)="Y",$D(^PRSP(454.1,CCORGIEN,1)),^PRSP(454.1,CCORGIEN,1)'="" D WRITE Q:PRTC=0
 G:PRTC=0 EXIT
 D WRITESB G:PRTC=0 EXIT
MCAN D INISB S CCORG="" F  S CCORG=$O(^PRSP(454.1,"B",CCORG)) Q:CCORG=""  S CCORGIEN=0,CCORGIEN=$O(^PRSP(454.1,"B",CCORG,CCORGIEN)) I $P(^PRSP(454.1,CCORGIEN,0),U,2)="N",$D(^PRSP(454.1,CCORGIEN,1)),^PRSP(454.1,CCORGIEN,1)'="" D WRITE Q:PRTC=0
 G:PRTC=0 EXIT
 D:TOTSB>0 WRITESB G:PRTC=0 EXIT
 W !,DASHES I $Y>(IOSL-4) D:$E(IOST,1)="C" PRTC G:PRTC=0 EXIT D HDR
 W !,?17,"TOTAL",?24,$J(CLGTL,7,2),?33,$J(FTPTL,4),?38,$J(PTPTL,4)
 W ?43,$J(PTPFTETL,7,2),?51,$J(FTTTL,4),?56,$J(PTTTL,4)
 W ?61,$J(PTTFTETL,7,2),?69,$J(INTTL,4),?74,$J(SISTL,4)
 W ?79,$J(INTFTETL,7,2),?87,"|",?90,$J(TOTTL,4),?97,$J(FTETOTTL,7,2)
 W ?105,$J(VARTL,7,2),?113,"|",?113,$J(TSRTL,3),?117,$J(TSRFTETL,7,2)
 W ?125,$J(LWOPTL,3),?129,$J(FEETL,3)
 W !,DASHES I $E(IOST,1)="C" D PRTC G:PRTC=0 EXIT
 D LEGEND^PRSDSRP2 D:$E(IOST,1)="C" PRTC G:PRTC=0 EXIT
 D ^PRSDSRP2
 D ^%ZISC
EXIT S:$D(ZTQUEUED) ZTREQ="@" D KILL^XUSCLEAN Q
INISB S (CLGSB,FTPSB,PTPSB,PTPFTESB,FTTSB,PTTSB,PTTFTESB,INTSB,INTFTESB)=0
 S (TSRSB,TSRFTESB,SISSB,TOTSB,FTETOTSB,VARSB,LWOPSB,FEESB)=0 Q
WRITE I FIRST="1ST" S Y=$P(^PRSP(454.1,CCORGIEN,0),U,3) D DD^%DT S COMPDT=Y D HDR S FIRST=""
 S ZERO=^PRSP(454.1,CCORGIEN,0),ONE=^PRSP(454.1,CCORGIEN,1)
 S CLG=$P(ZERO,U,4)
 S FTP=$P(ONE,U,1),FTT=$P(ONE,U,2),PTP=$P(ONE,U,3),PTPFTE=$P(ONE,U,4)
 S PTT=$P(ONE,U,5),PTTFTE=$P(ONE,U,6),INT=$P(ONE,U,7),INTFTE=$P(ONE,U,8)
 S TSR=$P(ONE,U,9),TSRFTE=$P(ONE,U,10),SIS=$P(ONE,U,11),TOT=$P(ONE,U,12)
 S FTETOT=$P(ONE,U,13),VAR=$P(ONE,U,14),LWOP=$P(ONE,U,15)
 S FEE=$P(ONE,U,16)
 S CLGSB=CLGSB+CLG,FTPSB=FTPSB+FTP,PTPSB=PTPSB+PTP
 S PTPFTESB=PTPFTESB+PTPFTE,FTTSB=FTTSB+FTT,PTTSB=PTTSB+PTT
 S PTTFTESB=PTTFTESB+PTTFTE,INTSB=INTSB+INT,INTFTESB=INTFTESB+INTFTE
 S TSRSB=TSRSB+TSR,TSRFTESB=TSRFTESB+TSRFTE,SISSB=SISSB+SIS
 S TOTSB=TOTSB+TOT,FTETOTSB=FTETOTSB+FTETOT,VARSB=VARSB+VAR
 S LWOPSB=LWOPSB+LWOP,FEESB=FEESB+FEE
 W !,$P(^PRSP(454.1,CCORGIEN,0),U,1)
 I $P(^PRSP(454.1,CCORGIEN,0),U,1)="NURSING" D ^PRSDSRP1 Q:PRTC=0
 W ?24,$J(CLG,7,2),?33,$J(FTP,4),?38,$J(PTP,4),?43,$J(PTPFTE,7,2)
 W ?51,$J(FTT,4),?56,$J(PTT,4),?61,$J(PTTFTE,7,2),?69,$J(INT,4)
 W ?74,$J(SIS,4),?79,$J(INTFTE,7,2),?87,"|",?90,$J(TOT,4)
 W ?97,$J(FTETOT,7,2),?105,$J(VAR,7,2),?113,"|",?113,$J(TSR,3)
 W ?117,$J(TSRFTE,7,2),?125,$J(LWOP,3),?129,$J(FEE,3)
 W !,DASHES I $Y>(IOSL-4) D:$E(IOST,1)="C" PRTC Q:PRTC=0  D HDR
 Q
WRITESB W !,?14,"SUBTOTAL",?24,$J(CLGSB,7,2),?33,$J(FTPSB,4),?38,$J(PTPSB,4)
 W ?43,$J(PTPFTESB,7,2),?51,$J(FTTSB,4),?56,$J(PTTSB,4)
 W ?61,$J(PTTFTESB,7,2),?69,$J(INTSB,4),?74,$J(SISSB,4)
 W ?79,$J(INTFTESB,7,2),?87,"|",?90,$J(TOTSB,4),?97,$J(FTETOTSB,7,2)
 W ?105,$J(VARSB,7,2),?113,"|",?113,$J(TSRSB,3),?117,$J(TSRFTESB,7,2)
 W ?125,$J(LWOPSB,3),?129,$J(FEESB,3)
 I $Y>(IOSL-2) D:$E(IOST,1)="C" PRTC Q:PRTC=0  D HDR
 W !,DASHES I $Y>(IOSL-2) D:$E(IOST,1)="C" PRTC Q:PRTC=0  D HDR
 S CLGTL=CLGTL+CLGSB,FTPTL=FTPTL+FTPSB,PTPTL=PTPTL+PTPSB
 S PTPFTETL=PTPFTETL+PTPFTESB,FTTTL=FTTTL+FTTSB,PTTTL=PTTTL+PTTSB
 S PTTFTETL=PTTFTETL+PTTFTESB,INTTL=INTTL+INTSB
 S INTFTETL=INTFTETL+INTFTESB,TSRTL=TSRTL+TSRSB
 S TSRFTETL=TSRFTETL+TSRFTESB,SISTL=SISTL+SISSB,TOTTL=TOTTL+TOTSB
 S FTETOTTL=FTETOTTL+FTETOTSB,VARTL=VARTL+VARSB,LWOPTL=LWOPTL+LWOPSB
 S FEETL=FEETL+FEESB Q
HDR W:$Y>0 @IOF S PAGE=PAGE+1
 W !,"STRENGTH REPORT",SITE,?96,"COMPILATION DATE: ",COMPDT
 W !,"PAGE: ",PAGE,?102,"PRINT DATE: ",PRNTDT,!
 W !,?80,"SISFTE"
 W !,"SERVICE NAME",?24,"CEILING",?34,"FTP",?39,"PTP",?44,"PTPFTE"
 W ?52,"FTT",?57,"PTT",?62,"PTTFTE",?70,"INT",?75,"SIS",?80,"INTFTE"
 W ?87,"|",?91,"TOT",?98,"FTETOT",?109,"VAR",?113,"|TSR",?118,"TSRFTE"
 W ?125,"LWP",?129,"FEE"
 W !,DASHES,!,DASHES
 Q
PRTC W ! K DIR,DIRUT,DIROUT,DTOUT,DUOUT S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR S PRTC=Y S:$D(DIRUT) PRTC=0
 Q
