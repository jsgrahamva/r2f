SROPLIS	;B'HAM ISC/MAM - LIST OF OPERATIONS ; [ 09/22/98  11:36 AM ]
	;;3.0;Surgery;**77,50,182**;24 Jun 93;Build 49
	S SRQ=0 W @IOF,!,"List of Operations",!
DATE	D DATE^SROUTL(.SRSD,.SRED,.SRQ) G:SRQ END
	S SRD=SRSD-.0001
	K IOP,%ZIS,POP,IO("Q") S %ZIS("A")="Print the Report on which Device: ",%ZIS="QM" W !!,"This report is designed to use a 132 column format.",! D ^%ZIS G:POP END
	I $D(IO("Q")) K IO("Q") S ZTDESC="LIST OF OPERATIONS",ZTRTN="EN^SROPLIS",(ZTSAVE("SRD"),ZTSAVE("SRED"),ZTSAVE("SRSD"),ZTSAVE("SRSITE*"))="",%ZIS="QM" D ^%ZTLOAD G END
EN	; entry when queued
	G ^SROPLIST
HDR	; print heading
	I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRQ=1 Q
	W:$Y @IOF W !,?(132-$L(SRINST)\2),SRINST,?120,"PAGE ",PAGE,!,?58,"SURGICAL SERVICE",?100,"REVIEWED BY: ",!,?57,"LIST OF OPERATIONS",?100,"DATE REVIEWED: "
	W !,?(132-$L(SRFRTO)\2),SRFRTO,?100,SRPRINT
	W !!,"DATE",?13,"PATIENT",?38,"SERVICE",?90,"PRIMARY SURGEON",?114,"ANESTHESIA TECH",!,"CASE #",?15,"ID#",?38,"OPERATION(S)",?90,"1ST ASSISTANT",!,?13,"PRIORITY",?90,"2ND ASSISTANT" W ! F I=1:1:IOM W "="
	S PAGE=PAGE+1
	Q
END	I 'SRQ,($E(IOST)'="P") W !!,"Press RETURN to continue  " R X:DTIME
	W ! D ^SRSKILL K SRTN D ^%ZISC W @IOF
	Q
