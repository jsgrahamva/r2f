PSODSPL	;IHS/DSD/JCM - DISPLAY RX PROFILE TO SCREEN ;03/07/93 18:11
	;;7.0;OUTPATIENT PHARMACY;**132,251,375**;DEC 1997;Build 17
	; Input Variables: PSOSD(,
	; Optional Input Variables: PSOOPT
	;
	; display profiles needs PSOOPT=3 from new PSOOPT=4 from refill, 
	; or PSOOPT=0 from anywhere
	; PSOOPT=-1 to get numbered list but no refill/renew message
	;---------------------------------------------------------------
START	;
	I '$G(PSOSD) W $C(7),!!,"This patient has no prescriptions",! G END
	D EOJ,SHOW
END	D EOJ
	Q
	;-----------------------------------------------------------------
SHOW	;
	N PSODRUG,PSOSTA,PSODATA,PSOQFLG,PSOCT,PSOCNT
	S PSOPENFL=0
	S (PSOSTA,PSODRUG)="",(PSOCNT,PSOQFLG)=0
	D HD^PSODDPR2() Q:$G(PSODLQT)
	D HD F PSCNT=0:0 S PSOSTA=$O(PSOSD(PSOSTA)) Q:PSOSTA=""!($G(PSOQFLG))  D STA F PSOCT=0:0 S PSODRUG=$O(PSOSD(PSOSTA,PSODRUG)) Q:PSODRUG=""  Q:PSOCNT>1000!PSOQFLG  D
	.S PSODATA=PSOSD(PSOSTA,PSODRUG),PSOCNT=PSOCNT+1 I PSOSTA="PENDING" D PEN Q
	.I PSOSTA="ZNONVA" D  Q
	..W !,"  "_$P(PSODRUG,"^")_" "_$P(PSODATA,"^",6)_" "_$P(PSODATA,"^",8)
	..I ($L("  "_$P(PSODRUG,"^")_" "_$P(PSODATA,"^",6)_" "_$P(PSODATA,"^",8))+20)>70 W !
	..W ?50,"Date Documented: "_$E($P(PSODATA,"^",9),4,5)_"/"_$E($P(PSODATA,"^",9),6,7)_"/"_$E($P(PSODATA,"^",9),2,3)
	.S:'$D(^PSRX(+PSODATA,0)) PSOCNT=PSOCNT-1 D:$D(^(0)) DISPL Q:$G(PSODLQT)
	I PSOQFLG G SHOWX
	D HD^PSODDPR2() Q:$G(PSODLQT) 
	;K DIR S DIR(0)="EA",DIR("A")="Press RETURN to continue: " D ^DIR ;S:'$D(DFN) DFN=PSODFN D:'$G(INPAT) GMRA^PSODEM
SHOWX	W ! K DIRUT,DTOUT,DUOUT,DIROUT S PSOCNT=PSOCNT-1 ;K PSODRUG
	Q
	;
HD	;
	Q:$G(PSODLQT)
	I $Y+5>IOSL S (DX,DY)=0 X ^%ZOSF("XY") K DX,DY
	Q:$G(PSOPENFL)  K LINE
	W !!,?61,"ISSUE",?68,"LAST",?73,"REF DAY",!,?4,"RX #",?17,"DRUG",?54,"QTY",?58,"ST",?62,"DATE",?68,"FILL",?73,"REM",?77,"SUP" S $P(LINE,"-",80)="-" W !,LINE K LINE
	Q
DISPL	W ! I $G(PSOOPT) W $J(PSOCNT,2)
	S PSODQLZ=$L($P(PSODRUG,"^"))+$L($P(^PSRX(+PSODATA,0),"^",7))
	W ?3,$P(^PSRX(+PSODATA,0),"^")_$S($G(^PSRX(+PSODATA,"IB")):"$",1:"")
	S PSOQTLZ=57-$L($P(^PSRX(+PSODATA,0),"^",7)) I PSODQLZ<39 W ?17,$P(PSODRUG,"^"),?PSOQTLZ,$P(^PSRX(+PSODATA,0),"^",7)
	E  W ?17,$P(PSODRUG,"^")
	N PSOCMOP,STATL
	I $D(^PSDRUG("AQ",$P(^PSRX(+PSODATA,0),"^",6))) S PSOCMOP=">"
	N X S X="PSXOPUTL" X ^%ZOSF("TEST") K X I $T D
	.N DA S DA=+PSODATA D ^PSXOPUTL K DA
	.I $G(PSXZ(PSXZ("L")))=0!($G(PSXZ(PSXZ("L")))=2) S PSOCMOP="T"
	.K PSXZ
	S STA="A^N^R^H^N^S^^^^^^E^DC^^DP^DE^HP^P^"
	S STATL=$P(STA,"^",$P(PSODATA,"^",2)+1) D
	.I $G(^PSRX(+PSODATA,"DDSTA"))]"" S STATL="DD" Q
	.S STATL=$S($P($G(^PSRX(+PSODATA,7)),"^")=1:"DA",$P($G(^PSRX(+PSODATA,7)),"^")=2:"DF",1:STATL)
	W ?58,STATL W $G(PSOCMOP) K STA
	S PSOID=$P(^PSRX(+PSODATA,0),"^",13),PSOLF=+^(3) W ?61,$E(PSOID,4,5)_"-"_$E(PSOID,6,7)
	F PSOX=0:0 S PSOX=$O(^PSRX(+PSODATA,1,PSOX)) Q:'PSOX  I +^PSRX(+PSODATA,1,PSOX,0)=PSOLF,$P(^PSRX(+PSODATA,1,PSOX,0),"^",16) S PSOLF=PSOLF_"^R"
	I '$O(^PSRX(+PSODATA,1,0)),$P(^PSRX(+PSODATA,2),"^",15) S PSOLF=PSOLF_"^R"
	W ?67,$S(+PSOLF:$E(PSOLF,4,5)_"-"_$E(PSOLF,6,7),1:"  -  "),$P(PSOLF,"^",2)
	W ?74,$J($P(PSODATA,"^",6),2)
	W ?78,$J($P(PSODATA,"^",8),2)
	I PSODQLZ>38 S PSOQTLZ=PSOQTLZ-5 W !?PSOQTLZ,"Qty: ",$P(^PSRX(+PSODATA,0),"^",7)
	K PSODQLZ,PSOQTLZ,PSODATA,PSOID,PSOLF,PSOX
	;
EOF	I $Y+5>IOSL,$O(PSOSD(PSOSTA,PSODRUG))]"" K DIR S DIR(0)="E" D ^DIR K DIR S:$D(DUOUT)!$G(DTOUT)!($G(DIRUT)) PSOHI=PSOCNT,PSODLQT=1,PSOQFLG=1 K DIRUT,DTOUT,DUOUT,DIROUT D:'PSOQFLG HD,STA
	;
	Q
STA	;
	Q:$G(PSOQFLG)!($G(PSODLQT))
	I PSOSTA="ZNONVA" S ZSTA=PSOSTA,PSOSTA="Non-VA MEDS (Not dispensed by VA)"
	S STR=($L(PSOSTA)+IOM/2)-$L(PSOSTA),STP=IOM-(STR+$L(PSOSTA)) W ! F I=1:1:STR W "-"
	W PSOSTA F I=1:1:STP W "-"
	I $G(ZSTA)]"" W "-" S PSOSTA=ZSTA K ZSTA
	Q
EOJ	;
	K PSOHI,PSOQFLG,PSODATA,PSOID,PSOLF,PSOCNT,PSOLO1,PSOPENFL
	Q
PEN	;
	N PSCMOPR S PSCMOPR=0 I $P($G(PSODATA),"^",11),$D(^PSDRUG("AQ",$P(PSODATA,"^",11))) S PSCMOPR=1
	W ! I $G(PSOOPT) W $J(PSOCNT,2)
	S PSOPENFL=1
	S PSODQLZ=$L($P(PSODRUG,"^")),PSOQTLZ=$L($P(PSODATA,"^",8))
	W ?3,$P(PSODRUG,"^") I +$G(PSODQLZ)>37 W !
	;W ?49,"ISDT: ",$S('$P(PSODATA,"^",9):"     ",1:$E($P(PSODATA,"^",9),4,5)_"-"_$E($P(PSODATA,"^",9),6,7))_"  QTY: "_$S(PSOQTLZ=1:"  ",PSOQTLZ=2:" ",1:"")_$P(PSODATA,"^",8)_"  REF: "_$J($P(PSODATA,"^",6),2)
	W ?42,"QTY: ",$P(PSODATA,"^",8),?59,"ISDT: ",$S('$P(PSODATA,"^",9):"     ",1:$E($P(PSODATA,"^",9),4,5)_"-"_$E($P(PSODATA,"^",9),6,7))_$S($G(PSCMOPR):"> ",1:"  ")_"REF: "_$J($P(PSODATA,"^",6),2)
	K PSODATA,PSOID,PSOLF,PSODQLZ,PSOQTLZ D EOF
	Q
