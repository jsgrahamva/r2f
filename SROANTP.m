SROANTP	;BIR/MAM - INCOMPLETE ASSESSMENTS (PRINTER) ;01/18/07
	;;3.0;Surgery;**32,50,100,142,153,160,182**;24 Jun 93;Build 49
	S SRPAGE=1,(SRSOUT,SRDFN)=0 D HDR Q:SRSOUT
	F  S SRSD=$O(^SRF("AC",SRSD)) Q:'SRSD!(SRSD>SRED)!SRSOUT  S SRTN=0 F  S SRTN=$O(^SRF("AC",SRSD,SRTN)) Q:'SRTN!SRSOUT  S SR("RA")=$G(^SRF(SRTN,"RA")) I $P(SR("RA"),"^")="I",$D(^SRF(SRTN,0)),$$MANDIV^SROUTL0(SRINSTP,SRTN) D SET
	Q
SET	; print assessments
	I $P(SR("RA"),"^",6)="N" Q
	I $Y+5>IOSL S SRPAGE=SRPAGE+1 D HDR I SRSOUT Q
	K SRCPTT S SRCPTT="NOT ENTERED"
	S SRA(0)=^SRF(SRTN,0),DFN=$P(SRA(0),"^") N I D DEM^VADPT S SRANM=VADM(1),SRASSN=VA("PID") K VADM
	S X=^SRF(SRTN,"OP"),SROPER=$P(X,"^")
	I $O(^SRF(SRTN,13,0)) S SROTHER=0 F  S SROTHER=$O(^SRF(SRTN,13,SROTHER)) Q:'SROTHER  D OTHER
	S X=$P($G(^SRF(SRTN,"RA")),"^",2) I X="C" S SROPER="* "_SROPER
	K SROPS,MM,MMM S:$L(SROPER)<81 SROPS(1)=SROPER I $L(SROPER)>80 S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
	S SRSS=$P(SRA(0),"^",4),SRSS=$S(SRSS:$P(^SRO(137.45,SRSS,0),"^"),1:"SPECIALTY NOT ENTERED")
	S TYPE=$P(SR("RA"),"^",2) I SRSS="SPECIALTY NOT ENTERED",TYPE="C" S SRSS="N/A"
	D TECH^SROPRIN
	S Y=$P(SRA(0),"^",9) D D^DIQ S SRDT=$P(Y,"@")
	S (SRDOC,Y)=$P($G(^SRF(SRTN,.1)),"^",4),C=$P(^DD(130,.14,0),"^",2) D:Y'="" Y^DIQ I $L(Y)>23 S Z=$P(Y,",")_","_$E($P(Y,",",2))_".",Y=Z
	S SRDOC=Y
	W !,SRTN,?20,SRANM_" "_VA("PID"),?67,$P(SRSS,"("),?107,SRTECH,!,SRDT,?20,SROPS(1),?107,SRDOC I $D(SROPS(2)) W !,?20,SROPS(2) I $D(SROPS(3)) W !,?20,SROPS(3) I $D(SROPS(4)) W !,?20,SROPS(4)
	N I,SRPROC,SRL S SRL=100 D CPTS^SROAUTL0 W !,?20,"CPT Codes: "
	F I=1:1 Q:'$D(SRPROC(I))  W:I=1 ?31,SRPROC(I) W:I'=1 !,?31,SRPROC(I)
	W ! F LINE=1:1:132 W "-"
	Q
OTHER	; other operations
	S SRLONG=1 I $L(SROPER)+$L($P(^SRF(SRTN,13,SROTHER,0),"^"))>165 S SRLONG=0,SROTHER=999,SROPERS=" ..."
	I SRLONG S SROPERS=$P(^SRF(SRTN,13,SROTHER,0),"^")
	S SROPER=SROPER_$S(SROPERS'=" ...":", "_SROPERS,1:SROPERS)
	Q
LOOP	; break procedures
	S SROPS(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<81  S SROPS(M)=SROPS(M)_MM_" ",SROPER=MMM
	Q
HDR	; print heading
	I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
	W:$Y @IOF W !,?53,"INCOMPLETE RISK ASSESSMENTS",?120,"PAGE "_SRPAGE,!,?(132-$L(SRINST)\2),SRINST,!,?58,"SURGERY SERVICE",?100,"DATE REVIEWED:"
	W !,?(132-$L(SRFRTO)\2),SRFRTO,?100,"REVIEWED BY:"
	W !!,"ASSESSMENT #",?20,"PATIENT",?67,"SURGICAL SPECIALTY",?107,"ANESTHESIA TECHNIQUE",!,"OPERATION DATE",?20,"OPERATIVE PROCEDURE(S)",?107,"PRIMARY SURGEON",! F LINE=1:1:132 W "="
	Q
