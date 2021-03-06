SROSPC1	;B'HAM ISC/MAM - CASES W/O SPECIMENS ; [ 07/27/98   2:33 PM ]
	;;3.0;Surgery;**50,182**;24 Jun 93;Build 49
	S (SRSOUT,TOTAL)=0,PAGE=1,SRSDATE=SRSD-.0001,SREDT=SRED+.9999 D HDR
	F  S SRSDATE=$O(^SRF("AC",SRSDATE)) Q:'SRSDATE!(SRSDATE>SREDT)!SRSOUT  S SRTN=0 F  S SRTN=$O(^SRF("AC",SRSDATE,SRTN)) Q:'SRTN!SRSOUT  I $D(^SRF(SRTN,0)),$$MANDIV^SROUTL0(SRINSTP,SRTN) D SET
	Q:SRSOUT  I $Y+5>IOSL D PAGE I SRSOUT Q
	W !!,"TOTAL CASES WITHOUT SPECIMENS: ",TOTAL
	Q
SET	; case information
	I $P($G(^SRF(SRTN,30)),"^")'="" Q
	S X=$P(^SRF(SRTN,0),"^",4),SRSS=$S(X:$P(^SRO(137.45,X,0),"^"),1:"SPECIALTY NOT ENTERED")
	I '$D(^SRF(SRTN,.2)) Q
	I $P(^SRF(SRTN,.2),"^",12)="" Q
	I $O(^SRF(SRTN,9,0)) Q
	I $Y+7>IOSL D PAGE I SRSOUT Q
	S DFN=$P(^SRF(SRTN,0),"^") D DEM^VADPT S SROD=$E(SRSDATE,4,5)_"/"_$E(SRSDATE,6,7)_"/"_$E(SRSDATE,2,3)
	S SRDIAG=$S($D(^SRF(SRTN,34)):$P(^(34),"^"),1:"DIAGNOSIS NOT ENTERED"),SR(.1)=$S($D(^SRF(SRTN,.1)):^(.1),1:""),SRSUR=$P(SR(.1),"^",4),SRATT=$P(SR(.1),"^",13)
	I SRSUR S SRSUR=$P(^VA(200,SRSUR,0),"^") I $L(SRSUR)>20 S SRSUR=$P(SRSUR,",")_","_$E($P(SRSUR,",",2))
	I SRATT S SRATT=$P(^VA(200,SRATT,0),"^") I $L(SRATT)>20 S SRATT=$P(SRATT,",")_","_$E($P(SRATT,",",2))
OPS	S SROPER=$P(^SRF(SRTN,"OP"),"^"),OPER=0 F I=0:0 S OPER=$O(^SRF(SRTN,13,OPER)) Q:OPER=""  D OTHER
	K SROP,MM,MMM S:$L(SROPER)<50 SROP(1)=SROPER I $L(SROPER)>49 S SROPER=SROPER_"  " S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
	W !,SROD,?20,VADM(1),?55,SRSS,?110,SRSUR,!,SRTN,?20,VA("PID"),?55,SRDIAG,?110,SRATT,!,?55,SROP(1) I $D(SROP(2)) W !,?55,SROP(2) I $D(SROP(3)) W !,?55,SROP(3) I $D(SROP(4)) W !,?55,SROP(4)
	S TOTAL=TOTAL+1 W !
	Q
PAGE	I $E(IOST)="P" D HDR Q
	W !!,"Press RETURN to continue, or '^' to quit:  " R X:DTIME I '$T!(X="^") S SRSOUT=1 Q
	I X["?" W !!,"Press RETURN to continue listing cases, or '^' to exit from this option." G PAGE
HDR	; print heading
	I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
	I $Y W @IOF
	W !,?(132-$L(SRINST)\2),SRINST,?120,"PAGE ",PAGE,!,?58,"SURGICAL SERVICE",?100,"REVIEWED BY: ",!,?55,"CASES WITHOUT SPECIMENS",?100,"DATE REVIEWED: "
	W !,?(132-$L(SRFRTO)\2),SRFRTO,?100,SRPRINT
	W !!,"DATE",?20,"PATIENT",?55,"SURGICAL SPECIALTY",?110,"PRIMARY SURGEON",!,"CASE #",?20,"PATIENT ID",?55,"POSTOPERATIVE DIAGNOSIS",?110,"ATTENDING SURGEON",!,?55,"OPERATIVE PROCEDURE"
	W ! F LINE=1:1:132 W "="
	S PAGE=PAGE+1
	Q
OTHER	; other operations
	S SRLONG=1 I $L(SROPER)+$L($P(^SRF(SRTN,13,OPER,0),"^"))>240 S SRLONG=0,OPER=999,SROPERS=" ..."
	I SRLONG S SROPERS=$P(^SRF(SRTN,13,OPER,0),"^")
	S SROPER=SROPER_$S(SROPERS=" ...":SROPERS,1:", "_SROPERS)
	Q
LOOP	; break procedure if greater than 50 characters
	S SROP(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROP(M))+$L(MM)'<50  S SROP(M)=SROP(M)_MM_" ",SROPER=MMM
	Q
