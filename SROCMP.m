SROCMP	;BIR/MAM - PERIOPERATIVE OCCURRENCES ;05/15/06
	;;3.0;Surgery;**22,26,29,38,50,143,153,175**;24 Jun 93;Build 6
BEG	U IO S SRSOUT=0,PAGE=1 K ^TMP("SR",$J) S Y=DT X ^DD("DD") S SRPRINT="DATE PRINTED: "_Y,SRSDT=SRSD-.0001,SREDT=SRED+.9999
	N SRFRTO S Y=SRSD X ^DD("DD") S SRFRTO="FROM: "_Y_"  TO: ",Y=SRED X ^DD("DD") S SRFRTO=SRFRTO_Y
	F  S SRSDT=$O(^SRF("AC",SRSDT)) Q:SRSDT>SREDT!('SRSDT)!(SRSOUT)  S SRTN=0 F  S SRTN=$O(^SRF("AC",SRSDT,SRTN)) Q:'SRTN!(SRSOUT)  D
	.I $O(^SRF(SRTN,10,0))!$O(^SRF(SRTN,16,0)),(SRBOTH1="B"),$D(^SRF(SRTN,0)),$$MANDIV^SROUTL0(SRINSTP,SRTN) D UTIL Q
	.I $O(^SRF(SRTN,10,0)),(SRBOTH1="I"),$D(^SRF(SRTN,0)),$$MANDIV^SROUTL0(SRINSTP,SRTN) D UTIL Q
	.I $O(^SRF(SRTN,16,0)),(SRBOTH1="P"),$D(^SRF(SRTN,0)),$$MANDIV^SROUTL0(SRINSTP,SRTN) D UTIL
	S (SRSS,SRHDR)=0 F  S SRSS=$O(^TMP("SR",$J,SRSS)) Q:SRSS=""!(SRSOUT)  D HDR^SROCMP2 S SRSDATE=0 F  S SRSDATE=$O(^TMP("SR",$J,SRSS,SRSDATE)) Q:'SRSDATE!(SRSOUT)  D MORE
	G:SRSOUT END
	I '$D(^TMP("SR",$J)) D HDR^SROCMP2 G:SRSOUT END W !!,"There are no "_$S(SRBOTH1="I":"intraoperative",SRBOTH1="P":"postoperative",SRBOTH1="B":"perioperative",1:"")_" occurrences recorded for the selected date range."
	F I=$Y:1:IOSL-9 W !
	S X="" D FOOT^SROCMP2
	I SRBOTH S SRSOUT=0 D BEG^SROMORT S SRSOUT=1
END	W:$E(IOST)="P" @IOF I $D(ZTQUEUED) K ^TMP("SR",$J) Q:$G(ZTSTOP)  S ZTREQ="@" Q
	D ^%ZISC,^SRSKILL K SRTN W @IOF
	Q
MORE	S SRTN=0 F  S SRTN=$O(^TMP("SR",$J,SRSS,SRSDATE,SRTN)) Q:'SRTN  D SET
	Q
ATT	N SRDIV,SRY S SRY=$P($G(^SRF(SRTN,.1)),"^",13) I SRY D
	.S Y=SRY,C=$P(^DD(130,.164,0),"^",2) D Y^DIQ S SRSS=Y
	I SRY="" S SRDIV=$$SITE^SROUTL0(SRTN) I SRDIV,'$P(^SRO(133,SRDIV,0),"^",19) D
	.S SRY=$P($G(^SRF(SRTN,.1)),"^",4) I SRY D
	..S Y=SRY,C=$P(^DD(130,.14,0),"^",2) D Y^DIQ S SRSS=Y
	S:'SRY SRY="ZZ" I SRSP,'$D(SRSP(SRY)) Q
	S:'SRY SRSS="ATTENDING SURGEON NOT ENTERED"
	S ^TMP("SR",$J,SRSS,SRSDT,SRTN)=""
	Q
UTIL	; set ^TMP
	I SRSEL=1 D  Q
	.S Y=$P(^SRF(SRTN,0),"^",4) S:'Y Y="ZZ" I SRSP,'$D(SRSP(Y)) Q
	.S SRSS=$S(Y:$P(^SRO(137.45,Y,0),"^"),1:"SURGICAL SPECIALTY NOT ENTERED")
	.S ^TMP("SR",$J,SRSS,SRSDT,SRTN)=""
	I SRSEL=2 D ATT Q 
	I SRSEL=3 S SRJ=$S(SRBOTH1="I":10,SRBOTH1="P":16,1:"10,16") F SRI=1:1:$L(SRJ,",") S SROCC=0 F  S SROCC=$O(^SRF(SRTN,$P(SRJ,",",SRI),SROCC)) Q:'SROCC  S Y=$P(^SRF(SRTN,$P(SRJ,",",SRI),SROCC,0),"^",2) D:Y
	.I SRSP,'$D(SRSP(Y)) Q
	.S SRSS=$S(Y:$P(^SRO(136.5,Y,0),"^"),1:"OCCURRENCE CATEGORY NOT ENTERED")
	.S ^TMP("SR",$J,SRSS,SRSDT,SRTN)=""
	Q
SET	; set variables to print
	K SRC S DFN=$P(^SRF(SRTN,0),"^") D DEM^VADPT S SRNM=VADM(1),SRSSN=VA("PID"),Y=$P(^SRF(SRTN,0),"^",9) D D^DIQ S SROD=$E(Y,1,18)
OPS	S SROPER=$P(^SRF(SRTN,"OP"),"^"),OPER=0 F  S OPER=$O(^SRF(SRTN,13,OPER)) Q:OPER=""  D OTHER
	K SRP,Z S:$L(SROPER)<50 SRP(1)=SROPER I $L(SROPER)>49 S SROPER=SROPER_"  " F M=1:1 D OPER Q:Z=""
	S SRATT="",Y=$P($G(^SRF(SRTN,.1)),"^",13) I Y S C=$P(^DD(130,.164,0),"^",2) D Y^DIQ S SRATT=Y
	I SRATT="" S SRDIV=$$SITE^SROUTL0(SRTN) I SRDIV,'$P(^SRO(133,SRDIV,0),"^",19) D
	.S Y=$P($G(^SRF(SRTN,.1)),"^",4),C=$P(^DD(130,.14,0),"^",2) D Y^DIQ S SRATT=Y
	I SRATT="" S SRATT="ATTENDING SURGEON NOT ENTERED"
	S Y=$P(^SRF(SRTN,0),"^",4),SRSPEC=$S(Y:$P(^SRO(137.45,Y,0),"^"),1:"SURGICAL SPECIALTY NOT ENTERED")
COMP	; perioperative occurrences
	S (SRFG,SRIC,SRPC)=0
	I SRBOTH1'="P" F  S SRIC=$O(^SRF(SRTN,10,SRIC)) Q:SRIC=""  D
	.S SRFG=SRFG+1,SRC(SRFG)=$P(^SRF(SRTN,10,SRIC,0),"^")_"^"_$P(^(0),"^",6)_"^^"_$S($D(^SRF(SRTN,10,SRIC,2)):$P(^(2),"^"),1:"")_"^10^"_SRIC
	I SRBOTH1'="I" S SRPC=0 F  S SRPC=$O(^SRF(SRTN,16,SRPC)) Q:SRPC=""  D
	.S SRFG=SRFG+1,SRC(SRFG)=$P(^SRF(SRTN,16,SRPC,0),"^")_$S(SRBOTH1="B":" *",1:" ")_"^"_$P(^(0),"^",6)_"^"_$P(^(0),"^",7)_"^"_$S($D(^SRF(SRTN,16,SRPC,2)):$P(^(2),"^"),1:"")_"^16^"_SRPC
	.I $P(^SRF(SRTN,16,SRPC,0),"^",2)=3 S SRC(SRFG)=SRC(SRFG)_"^"_$P(^SRF(SRTN,16,SRPC,0),"^",4)
PRINT	; print perioperative occurrence information
	I $Y+10>IOSL D HDR^SROCMP2 I SRSOUT Q
	S SRHDR=1 W !!,SRNM,?29,$S(SRSEL=2:SRSPEC,1:SRATT) S SRC=$O(SRC(0)) W ?80,$P(SRC(SRC),"^") D DATE W ?129,$P(SRC(SRC),"^",2)
	I SRSEL=3 D PRNT3 Q
	W !,VA("PID"),?29,SRP(1),?80,$P(SRC(SRC),"^",4)
	W !,SROD W:$D(SRP(2)) ?29,SRP(2) D TEXT W:$D(SRP(3))!SRT ! W:$D(SRP(3)) ?29,SRP(3) D:SRT WP
SRC	I SRC F  S SRC=$O(SRC(SRC)) Q:'SRC!SRSOUT  D
	.I $Y+10>IOSL D HDR^SROCMP2 I SRSOUT Q
	.W !,?80,$P(SRC(SRC),"^") D DATE W ?129,$P(SRC(SRC),"^",2),!,?80,$P(SRC(SRC),"^",4),! D TEXT I SRT W ! D WP
	Q
PRNT3	W !,VA("PID"),?29,SRSPEC,?80,$P(SRC(SRC),"^",4)
	W !,SROD W ?29,SRP(1) D TEXT W:$D(SRP(2))!SRT ! W:$D(SRP(2)) ?29,SRP(2) D:SRT WP
	D SRC
	Q
WP	; print perioperative occurrence comments
	K ^UTILITY($J,"W") S CM=0 F  S CM=$O(^SRF(SRTN,SRX,SRY,1,CM)) Q:'CM  S X=^SRF(SRTN,SRX,SRY,1,CM,0),DIWL=81,DIWR=132 D ^DIWP
	I $D(^UTILITY($J,"W")) F J=1:1:^UTILITY($J,"W",81) D
	.I $Y+7>IOSL D HDR^SROCMP2 W ! I SRSOUT Q
	.W ?81,^UTILITY($J,"W",81,J,0),!
	Q
TEXT	; check for comments
	S SRT=0,SRX=$P(SRC(SRC),"^",5),SRY=$P(SRC(SRC),"^",6) I $O(^SRF(SRTN,SRX,SRY,1,0)) S SRT=1 I SRT W ?80,">>> Comments:"
	Q
OTHER	; other operations
	S SRLONG=1 I $L(SROPER)+$L($P(^SRF(SRTN,13,OPER,0),"^"))>250 S SRLONG=0,OPER=999,SROPERS=" ..."
	I SRLONG S SROPERS=$P(^SRF(SRTN,13,OPER,0),"^")
	S SROPER=SROPER_$S(SROPERS=" ...":SROPERS,1:", "_SROPERS)
	Q
OPER	; break procedure if greater than 50 characters
	S SRP(M)="" F LOOP=1:1 S Z=$P(SROPER," ") Q:Z=""  Q:$L(SRP(M))+$L(Z)'<50  S SRP(M)=SRP(M)_Z_" ",SROPER=$P(SROPER," ",2,200)
	Q
DATE	N SRSEP
	S X=$P(SRC(SRC),"^",7) I X S SRSEP=$S(X=2:"SEPSIS",X=3:"SEPTIC SHOCK",1:"SIRS") W " /"_SRSEP
	I $P(SRC(SRC),"^",3)'="" S SRDT=$P(SRC(SRC),"^",3) I SRDT W "  ("_$E(SRDT,4,5)_"/"_$E(SRDT,6,7)_"/"_$E(SRDT,2,3)_")"
	Q
