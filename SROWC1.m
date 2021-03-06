SROWC1	;BIR/ADM - WOUND CLASSIFICATION REPORT (CONT.) ;12/16/2010
	;;3.0;Surgery;**50,95,175**;24 Jun 93;Build 6
	U IO N SRFRTO S Y=SRSD X ^DD("DD") S SRFRTO="FROM: "_Y_"  TO: ",Y=SRED X ^DD("DD") S SRFRTO=SRFRTO_Y,SRSD=SRSD-.0001,SRED=SRED+.9999,Y=DT X ^DD("DD") S SRPRINT="DATE PRINTED: "_Y
	I SRFLG=2 G ^SROWC2
	I SRFLG=3 G ^SROWC3
	S (SRHDR,SRSOUT,SRSS,SRCT)=0 K ^TMP("SR",$J),^TMP("SRT",$J),^TMP("SRTN",$J)
	I 'SRSP D ALL G WC
	I SRSP D SPEC G WC
	Q
ALL	F  S SRSS=$O(^SRO(137.45,SRSS)) Q:'SRSS  S ^TMP("SR",$J,SRSS)="0^0^0^0^0"
	S ^TMP("SR",$J,"ZZ")="0^0^0^0^0"
	Q
SPEC	F  S SRSS=$O(SRSP(SRSS)) Q:'SRSS  S ^TMP("SR",$J,SRSS)="0^0^0^0^0"
	Q
WC	S ^TMP("SRT",$J)="0^0^0^0^0^0",SRCOMP=0
	F  S SRSD=$O(^SRF("AC",SRSD)) Q:'SRSD!(SRSD>SRED)  S SROP=0 F  S SROP=$O(^SRF("AC",SRSD,SROP)) Q:'SROP  I $D(^SRF(SROP,0)),$$MANDIV^SROUTL0(SRINSTP,SROP) D UTIL
	D HDR S SRSS="" F  S SRSS=$O(^TMP("SR",$J,SRSS)) Q:SRSS=""!(SRSOUT)  S SRCT=SRCT+1 D PRINT
	D TOTAL,END
	Q
UTIL	; set ^TMP
	Q:$P($G(^SRF(SROP,30)),"^")'=""
	Q:$P($G(^SRF(SROP,.2)),"^",12)=""
	S SRSS=$P(^SRF(SROP,0),"^",4) S:SRSS="" SRSS="ZZ" I SRSP,'$D(SRSP(SRSS)) Q
	S SRWC=$P($G(^SRF(SROP,"1.0")),"^",8),SRP=$S(SRWC="C":1,SRWC="CC":2,SRWC="D":3,SRWC="I":4,1:5)
	S $P(^TMP("SR",$J,SRSS),"^",SRP)=$P(^TMP("SR",$J,SRSS),"^",SRP)+1 S:SRP=5 ^TMP("SRTN",$J,SRSS,SRSD,SROP)=""
	S $P(^TMP("SRT",$J),"^",SRP)=$P(^TMP("SRT",$J),"^",SRP)+1,$P(^TMP("SRT",$J),"^",6)=$P(^TMP("SRT",$J),"^",6)+1
	I SRP=1 S (SRC,SRIN)=0 F  S SRC=$O(^SRF(SROP,16,SRC)) Q:'SRC  S SRCAT=$P(^SRF(SROP,16,SRC,0),"^",2) D
	.I SRCAT=1!(SRCAT=2)!(SRCAT=35) S SRIN=1 Q
	.I $P($G(^SRF(SROP,"RA")),"^",2)="C",SRCAT=23!(SRCAT=25) S SRIN=1
	I SRP=1,SRIN S SRCOMP=SRCOMP+1
	Q
PRINT	; print info
	I $Y+5>IOSL D HDR I SRSOUT Q
	S SRSPEC=$S(SRSS:$P(^SRO(137.45,SRSS,0),"^"),1:"NO SPECIALTY ENTERED")
	S Y=^TMP("SR",$J,SRSS),SRC=$P(Y,"^"),SRCC=$P(Y,"^",2),SRD=$P(Y,"^",3),SRI=$P(Y,"^",4),SRZZ=$P(Y,"^",5)
	I 'SRSP,'(SRC+SRCC+SRD+SRI+SRZZ) Q
	W !,$P(SRSPEC,"("),?21,$J(SRC,5),?33,$J(SRCC,5),?47,$J(SRD,5),?61,$J(SRI,5),?73,$J(SRZZ,5)
	Q
TOTAL	; print totals
	Q:SRSOUT  I $Y+8>IOSL D HDR I SRSOUT Q
	S Y=^TMP("SRT",$J),SRC=$P(Y,"^"),SRCC=$P(Y,"^",2),SRD=$P(Y,"^",3),SRI=$P(Y,"^",4),SRZZ=$P(Y,"^",5),SRT=$P(Y,"^",6)
	I SRCT>1 W !!,"SUB TOTAL:",?21,$J(SRC,5),?33,$J(SRCC,5),?47,$J(SRD,5),?61,$J(SRI,5),?73,$J(SRZZ,5)
	W !!,"TOTAL:    ",SRT S:SRC=0 SRC=1 W !!,"CLEAN WOUND INFECTION RATE: ",$J((SRCOMP/SRC*100),5,1),"%"
	Q
HDR	; print heading
	I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
	I $E(IOST)'="P" D HDR1 Q
	W:$Y @IOF W !,?(80-$L(SRINST)\2),SRINST,!,?32,"SURGICAL SERVICE",!,?26,"WOUND CLASSIFICATION REPORT",!,?(80-$L(SRFRTO)\2),SRFRTO,!,?(80-$L(SRPRINT)\2),SRPRINT
	W !,?21,"REVIEWED BY:",?45,"DATE REVIEWED:",!
	W !,?34,"CLEAN",?72,"NO CLASS",!,"SURGICAL SERVICE",?22,"CLEAN",?31,"CONTAMINATED",?46,"CONTAMINATED",?61,"INFECTED",?73,"ENTERED"
	W ! F LINE=1:1:80 W "="
	W ! Q
HDR1	; print heading to screen
	I SRHDR W !!,"Press RETURN to continue, or '^' to quit:  " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
	W @IOF,!,?26,"WOUND CLASSIFICATION REPORT",!,?(80-$L(SRFRTO)\2),SRFRTO
	W ! F LINE=1:1:80 W "-"
	W !!,?34,"CLEAN",?72,"NO CLASS",!,"SURGICAL SERVICE",?22,"CLEAN",?31,"CONTAMINATED",?46,"CONTAMINATED",?61,"INFECTED",?73,"ENTERED"
	S SRHDR=1 W !
	Q
END	W:$E(IOST)="P" @IOF K ^TMP("SRT",$J),^TMP("SRTN",$J) I $D(ZTQUEUED) K ^TMP("SR",$J) Q:$G(ZTSTOP)  S ZTREQ="@" Q
	I 'SRSOUT,$E(IOST)'="P" W !!,"Press RETURN to continue  " R X:DTIME
	D ^%ZISC,^SRSKILL W @IOF
	Q
