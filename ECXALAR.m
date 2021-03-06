ECXALAR	;ALB/TMD-LAR Extract Report of Untranslatable Results ;7/14/15  16:18
	;;3.0;DSS EXTRACTS;**46,51,112,132,136,149,154**;Dec 22, 1997;Build 13
	;
EN	; entry point
	N X,Y,DATE,ECRUN,ECXOPT,ECXDESC,ECXSAVE,ECXTL,ECTHLD,ECSD,ECSD1,ECSTART,ECED,ECEND,ECXERR,QFLG,PG,ECXPORT,RCNT ;149,154
	S QFLG=0,ECXTL="LAR"
	; get today's date
	D NOW^%DTC S DATE=X,Y=$E(%,1,12) D DD^%DT S ECRUN=$P(Y,"@") K %DT
	D SETUP^ECXLABR I ECFILE="" Q
	I '$D(ECNODE) S ECNODE=7
	I $P($G(^ECX(728,1,ECNODE+.1)),U,ECPIECE)]"" D  Q
	.W !!,$C(7),ECPACK," extract is already scheduled to run.  Try later",!!
	D BEGIN Q:QFLG
	S ECXPORT=$$EXPORT^ECXUTL1 Q:ECXPORT=-1  I $G(ECXPORT) D  Q  ;149 Section added
	.S RCNT=1
	.D PROCESS
	.S ^TMP($J,"ECXPORT",0)="PATIENT NAME^SSN^DATE/TIME COLLECTED^TEST CODE^TEST NAME^RESULT"
	.D EXPDISP^ECXUTL1
	.D AUDIT^ECXKILL
	S ECXDESC=ECXTL_" Extract Report of Untranslatable Results"
	S ECXSAVE("EC*")=""
	D EN^XUTMDEVQ("PROCESS^ECXALAR",ECXDESC,.ECXSAVE)
	I POP W !!,"No device selected...exiting.",! Q
	I IO'=IO(0) D ^%ZISC
	D HOME^%ZIS
	D AUDIT^ECXKILL
	Q
	;
BEGIN	; display report description
	W @IOF,!,"This report prints a listing of results that are not translatable i.e. have",!,"no entry in the Lab Results Translation File (#727.7)."
	W !!,"This report is a pre-extract type audit report and should be run prior to the",!,"generation of the actual extract.  Running this report has no effect on the",!,"actual extract."
	W !!,"**WARNING: This report can take a long time to process.  You are encouraged",!,"to queue this report for processing during the evening if possible.**" ;136
	W !!,"Enter the date range for which you would like to scan the ",ECXTL," Extract records.",!
	S DONE=0 F  S (ECED,ECSD)="" D  Q:QFLG!DONE
	.K %DT S %DT="AEX",%DT("A")="Starting with Date: ",%DT(0)=-DATE D ^%DT
	.I Y<0 S QFLG=1 Q
	.S ECSD=Y,ECSD1=ECSD-.1
	.D DD^%DT S ECSTART=Y
	.K %DT S %DT="AEX",%DT("A")="Ending with Date: ",%DT(0)=-DATE D ^%DT
	.I Y<0 S QFLG=1 Q
	.I Y<ECSD D  Q
	..W !!,"The ending date cannot be earlier than the starting date."
	..W !,"Please try again.",!!
	.I $E(Y,1,5)'=$E(ECSD,1,5) D  Q
	..W !!,"Beginning and ending dates must be in the same month and year."
	..W !,"Please try again.",!!
	.S ECED=Y
	.D DD^%DT S ECEND=Y
	.S DONE=1
	Q
	;
PROCESS	; entry point for queued report
	S ZTREQ="@"
	S $P(^ECX(728,1,ECNODE+.1),U,ECPIECE)="R"
	S ECXERR=0 D EN^ECXALAR2 S $P(^ECX(728,1,ECNODE+.1),U,ECPIECE)="" Q:ECXERR
	S QFLG=0 D PRINT
	Q
	;
PRINT	; process temp file and print report
	N X,CNT,LN,REC,ECXDFN,ECXSSN,ECXPNM,ECRS,ECTC,ECFMDT,ECDTM,ECXTNM
	U IO
	I $D(ZTQUEUED),$$S^%ZTLOAD S ZTSTOP=1 K ZTREQ Q
	S (PG,QFLG,GTOT)=0,$P(LN,"-",80)=""
	I '$G(ECXPORT) D HEADER Q:QFLG  ;149
	S COUNT=0,CNT="" F  S CNT=$O(^TMP($J,"ECXALAR2",CNT)) Q:CNT=""!QFLG  S REC=^(CNT) D
	.S ECXDFN=$P(REC,U),ECTC=$P(REC,U,4),ECRS=$P(REC,U,5)
	.S ECFMDT=$P(REC,U,2)_"."_$P(REC,U,3),ECDTM=$$FMTE^XLFDT(ECFMDT,2)
	.S (ECXPNM,ECXSSN)=""
	.K ECXPAT S OK=$$PAT^ECXUTL3(ECXDFN,,"1;",.ECXPAT)
	.I OK S ECXPNM=ECXPAT("NAME"),ECXSSN=ECXPAT("SSN")
	.S ECXTNM=$O(^ECX(727.29,"AC",+$G(ECTC),0)),ECXTNM=$P(^ECX(727.29,+$G(ECXTNM),0),U,3)
	.I $G(ECXPORT) S ^TMP($J,"ECXPORT",RCNT)=ECXPNM_U_ECXSSN_U_ECDTM_U_ECTC_U_ECXTNM_U_ECRS,RCNT=RCNT+1 Q  ;149
	.I $Y+3>IOSL D HEADER
	.W !,ECXPNM,?5,ECXSSN,?17,ECDTM,?32,$J(ECTC,4),?38,$E(ECXTNM,1,20),?60,$S($L(ECRS)>20:$E(ECRS,1,19)_"+",1:ECRS) ;154 Print result if 20 or less, otherwise print first 19 characters and +
	.S COUNT=COUNT+1
	I $G(ECXPORT) Q  ;149
	Q:QFLG
	I COUNT=0 W !!,?8,"No untranslatable results for this extract"
CLOSE	;
	I $E(IOST)="C",'QFLG D
	.S SS=22-$Y F JJ=1:1:SS W !
	.S DIR(0)="E" W ! D ^DIR K DIR
	Q
	;
HEADER	;header and page control
	N SS,JJ
	I $E(IOST)="C" D
	.S SS=22-$Y F JJ=1:1:SS W !
	.I PG>0 S DIR(0)="E" W ! D ^DIR K DIR S:'Y QFLG=1
	Q:QFLG
	W:$Y!($E(IOST)="C") @IOF S PG=PG+1
	W !,ECXTL_" Extract Untranslatable Results Audit Report",?71,"Page: "_PG
	W !,"Start Date: ",ECSTART
	W !,"End Date:   ",ECEND,?49,"Report Run Date:  "_ECRUN
	W !!,"Pat.",?5,"SSN",?17,"Date/Time",?32,"Test",?38,"Test Name",?60,"Result"
	W !,"Name",?17,"Collected",?32,"Code"
	W !,LN,!
	Q
	;
