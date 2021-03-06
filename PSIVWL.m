PSIVWL	;BIR/RGY,PR-COMPILE AND PRT WARD LIST ;13 MAR 97 / 10:18 AM
	;;5.0;INPATIENT MEDICATIONS;**41,54,74,84,93,110,111,141,305**;16 DEC 97;Build 3
	;
	; Reference to ^PS(51.1 is supported by DBIA 2177
	; Reference to ^PS(55 is supported by DBIA 2191
	;
	K WRD W !!,"Run ward list for DATE: TODAY//" R X:DTIME S:'$T X="^" S:X="" X="T" G Q:X["^" K %DT S %DT="XE" D ^%DT G:Y<0 PSIVWL
	S PSIVDT=Y\1 I Y<DT D ENRSET^PSIVWL1 G PSIVWL
	D ^PSIVWL1 I '$D(PSIVOD)!('$D(PSIVCD)) G Q
	I PSIVPR'=ION D QUE G Q
DEQ	;
	N PSJOK
	D NOW^%DTC S Y=% L +^PS(55,"PSIVWL",PSIVSN):1 E  W:$Y @IOF W !!,"**** WARNING --- WARD LIST NOT RUN, LABEL RUN IN PROGRESS ****" G Q
	D:$D(XRTL) T0^%ZOSV S NOFLG=0
	S PSIVT="" D ENINIT^PSIVWL1 F PSIV1=0:0 S PSIVT=$O(PSIVOD(PSIVT)) Q:PSIVT=""  S PSIVDT1=PSIVOD(PSIVT)-.0001 F PSIV1=0:0 S PSIVDT1=$O(^PS(55,"AIV",PSIVDT1)) Q:'PSIVDT1  D MAN1
	I $D(XRTL) S XRTN="PSIVWL" D T1^%ZOSV
	D ENT^PSIVWL1
Q	L -^PS(55,"PSIVWL",PSIVSN) W:'$D(PSIVPR)&($Y) @IOF K MI,ON,NOFLG,PSCT,PSGCNT,PSGSA,PSIVMT,DIC,PSIVRUN,%DT,PSIVDT1,PSIVDT,PSIV,PSIVOD
	K PSIVCD,PSM,%T,D,DFN,I,P,PSIV1,VAERR,X,Y,Z,Z1,Z2,ZTSK S:$D(ZTQUEUED) ZTREQ="@"
	Q
SETP	S Y=^PS(55,DFN,"IV",ON,0) F X=1:1:23 S P(X)=$P(Y,"^",X)
	N A,PSJST
	S PSJST=$$ONE^PSJBCMA(DFN,ON,P(9))
	S PSJOK=1 I PSJST="O" S A=0 F  S A=$O(^PS(55,DFN,"IV",+ON,"LAB",A)) Q:A=""  I $P($G(^(A,0)),"^",3)=1 S PSJOK=0 Q
	Q
MAN1	F DFN=0:0 S DFN=$O(^PS(55,"AIV",PSIVDT1,DFN)) Q:'DFN  S PSIV("NME")=$P($G(^DPT(DFN,0)),U) D INP^VADPT F ON=0:0 S ON=$O(^PS(55,"AIV",PSIVDT1,DFN,ON)) Q:'ON  Q:NOFLG=1  D SETP I PSJOK D MAN3
	Q
MAN2	S ^PS(55,"PSIVWL",PSIVSN,$S($P(VAIN(4),U,2)]"":$P(VAIN(4),U,2),1:"Outpatient IV"),P(4)_PSIVOD(P(4)),DFN,ON)=$S($P(P(8),"@",2)'=0:PSGCNT,1:0)_"^"_PSGSA_"^"_$P(^PS(55,DFN,"IV",ON,0),"^",16)
	;naked reference on line below refers to full global reference to right of = sign
	S $P(^(0),"^",16)=$P(^PS(55,DFN,"IV",ON,0),"^",16)+PSGCNT Q
	Q
MAN3	;I P(4)=""!(P(4)'=PSIVT) S NOFLG=1 D NOW^%DTC S PSIVRUN=$E(%,1,12) K %,%I,%H D HDR^PSIVWL1 W !!,"****NO DATA FOUND FOR THIS REPORT!***" Q
	Q:P(4)=""!(P(4)'=PSIVT)
	Q:'$D(PSIVOD(P(4)))!("DPN"[P(17))!($S($D(^PS(55,DFN,"IV",ON,2)):PSIVSN'=$P(^(2),"^",2),1:0))
	I "OH"[P(17) S PSGSA="",PSGCNT=0 D MAN2 Q
	S CD=$S(PSIVCD(PSIVT)<P(3):PSIVCD(PSIVT),1:P(3)),OD=$S(P(2)>PSIVOD(PSIVT):P(2),1:PSIVOD(PSIVT)) D ENP3,MAN2 Q
QUE	S ZTIO=PSIVPR,ZTDESC="IV WARD LIST",ZTRTN="DEQ^PSIVWL",PSIVT="" F I=0:0 S PSIVT=$O(PSIVMT(PSIVT)) Q:PSIVT=""  S (ZTSAVE("PSIVCD("""_PSIVT_""")"),ZTSAVE("PSIVMT("""_PSIVT_""")"),ZTSAVE("PSIVOD("""_PSIVT_""")"))=""
	F X="PSIVSN","PSIVDT","PSIVSITE","PSJSYSW0","PSJSYSP0","PSJSYSU" S ZTSAVE(X)=""
	D ^%ZTLOAD W:$D(ZTSK) !,"Queued." Q
ENP3	;
	;Needs DFN,ON P-array, OD and CD
	Q:'P(2)!'P(3)  S PSIVMI=P(15),PSIVSD=P(2),PSGSA="",PSGCNT=0 S:PSIVMI>1440 P(11)=""
	I P(11) G:"AH"[P(4) QSP F X="STAT","ONCE","NOW","ONE-TIME","ONE TIME","ONETIME","1-TIME","1 TIME","1-TIME" I $S(X=P(9):1,1:(P(9)[X)),PSIVSD'<OD,PSIVSD'>CD S PSGSA=PSIVSD_" " G QSP
	I P(4)="P"!(P(5))!(P(23)="P"),P(11) D CHK,ENP4 G QSP
	G:P(11) QSP I PSIVMI,OD\1>(PSIVSD\1) S X1=OD,X2=PSIVSD D ^%DTC I X>1 S X=X-1,PSIVMIN=X*1440\PSIVMI*PSIVMI D ENT S PSIVSD=Y
	I PSIVSD'<OD,PSIVSD<CD S Y=PSIVSD,PSGSA=Y_" "
	I PSIVMI F X=0:0 S PSIVMIN=PSIVMI D ENT Q:Y>CD!(Y=CD&(CD=P(3)))  S PSIVSD=Y I Y'<OD,Y'>CD S:$L(PSGSA)+$L(Y)'>240 PSGSA=PSGSA_$S(PSGSA'="":"."_$P(Y,".",2),1:Y)_" "
QSP	S PSGCNT=$L(PSGSA," ")-1 K PSIVMI,OD,CD,PSIVSD S:P(7)=1!($G(P("NUMLBL"))=0) PSGCNT=0 Q  ;PSJ*5*141 Add P(7) check, *305
CHK	F Y=1:1 Q:$L(P(11))>240!($P(P(11),"-",Y)="")  S $P(P(11),"-",Y)=$P(P(11),"-",Y)_$E("0000",1,4-$L($P(P(11),"-",Y)))
	Q
ENP4	Q:PSIVSD>CD  S PSIVSD=OD\1 I $G(P(2)),PSIVSD<P(2) S PSIVSD=P(2)\1
	NEW ODCDWD,ADM,ADMSD,ADMTM,PSIVX,P9
	F X=OD,CD D DW^%DTC S ODCDWD=$G(ODCDWD)_$E(X,1,3)_U
	I +$O(^PS(51.1,"APPSJ",P(9),0)) S PSIVX=1 S P9=$P(P(9),"@") F X=1:1:$L(P9,"-") D  Q:'$G(PSIVX)
	. I '("MON,TUE,WED,THU,FRI,SAT,SUN,"[$P(P9,"-",X)) S PSIVX=0 Q
	. I ODCDWD[$E($P(P9,"-",X),1,2) D
	.. S ADMSD=$S($P(ODCDWD,"^")[$P(P9,"-",X):OD,1:CD)\1
	.. F ADM=1:1:$L(P(11),"-") S ADMTM=$P(P(11),"-",ADM) I OD'>(ADMSD_"."_ADMTM),(CD'<(ADMSD_"."_ADMTM)) S PSGSA=PSGSA_$S(PSGSA'="":"",1:ADMSD)_"."_ADMTM_" "
	.. ;F ADM=1:1:$L(P(11),"-") S ADMTM=$P(P(11),"-",ADM) I OD'>(ADMSD_"."_ADMTM),(CD'<(ADMSD_"."_ADMTM)) S PSGSA=PSGSA_$S(PSGSA'="":"",1:PSIVSD)_"."_ADMTM_" "
	Q:+$G(PSIVX)
	I '$D(^PS(51.1,"APPSJ",P(9))) S PSIVX=1,P9=$P(P(9),"@") F X=1:1:$L(P9,"-") D  Q:'$G(PSIVX)
	. I '(",MO,TU,WE,TH,FR,SA,SU,"[(","_$P(P9,"-",X)_",")) S PSIVX=0 Q
	. I ODCDWD[$E($P(P9,"-",X),1,2) D
	.. S ADMSD=$S($P(ODCDWD,"^")[$P(P9,"-",X):OD,1:CD)\1
	.. F ADM=1:1:$L(P(11),"-") S ADMTM=$P(P(11),"-",ADM) I OD'>(ADMSD_"."_ADMTM),(CD'<(ADMSD_"."_ADMTM)) S PSGSA=PSGSA_$S(PSGSA'="":"",1:ADMSD)_"."_ADMTM_" "
	.. ;F ADM=1:1:$L(P(11),"-") S ADMTM=$P(P(11),"-",ADM) I OD'>(ADMSD_"."_ADMTM),(CD'<(ADMSD_"."_ADMTM)) S PSGSA=PSGSA_$S(PSGSA'="":"",1:PSIVSD)_"."_ADMTM_" "
	Q:+$G(PSIVX)
	F Y=1:1 S (PSIVMI,MI)=$P(P(11),"-",Y),PSIVSD=+(PSIVSD\1_"."_MI) Q:PSIVSD>CD  X:MI="" "S X1=PSIVSD,X2=1 D C^%DTC S PSIVSD=X,Y=0" I MI,PSIVSD'<OD,PSIVSD'>CD,PSIVSD'=P(3),'P(7) S PSGSA=PSGSA_$S(PSGSA'="":"."_$P(PSIVSD,".",2),1:PSIVSD)_" "
	; INSTALL PRECEEDING LINE WITH VERSION 17.3 OF FILEMAN
	Q
ENT	;PSIVMIN=# of min. to add or sub, PSIVSD=date to add or sub from in FM format -- Answer ret. in 'Y'
	S X2=PSIVMIN\1440,HOUR=(PSIVMIN-(1440*X2))\60,MIN=(PSIVMIN-(1440*X2)-(60*HOUR))#$S(PSIVMIN<0:-60,1:60),X1=PSIVSD\1,HR=$E(PSIVSD,9,10),MI=$E(PSIVSD,11,12)
	S:$L(HR)=1 HR=HR_0 S:$L(MI)=1 MI=MI_0 S MI=MI+MIN S:MI>59 MI=MI-60,HR=HR+1
	S:MI<0 MI=MI+60,HR=HR-1 S HR=HR+HOUR S:HR>23 HR=HR-24,X2=X2+1 S:HR<0 HR=HR+24,X2=X2-1 S:HR+MI=0 X2=X2-1,HR=24,MI=0 S:HR<10 HR=0_HR S:MI<10 MI=0_MI S X=X1 D:X2 C^%DTC S X=$P(X,".") S Y=+(X_"."_HR_MI)
	; install with version 17.3 of fm
	K HR,MI,X1,X2,HOUR,MIN,PSIVMIN,O,MI Q
