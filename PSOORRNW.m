PSOORRNW	;BIR/SAB-finish OP renew orders from OE/RR ;2:52 PM  7 Sep 2015
	;;7.0;OUTPATIENT PHARMACY;**11,27,51,46,71,94,130,131,146,206,225,384,386,408,WVEHR,LOCAL**;DEC 1997;Build 4
	;
	; Copyright 2015 WorldVistA.
	;
	; This program is free software: you can redistribute it and/or modify
	; it under the terms of the GNU Affero General Public License as
	; published by the Free Software Foundation, either version 3 of the
	; License, or (at your option) any later version.
	;
	; This program is distributed in the hope that it will be useful,
	; but WITHOUT ANY WARRANTY; without even the implied warranty of
	; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	; GNU Affero General Public License for more details.
	;
	; You should have received a copy of the GNU Affero General Public License
	; along with this program.  If not, see <http://www.gnu.org/licenses/>.
	;
	;External reference to ^PSDRUG supported by DBIA 221
	;External reference to ^PS(50.607 supported by DBIA 2221
	;External reference to ^PS(51.2 supported by DBIA 2226
	;External references PSOL and PSOUL^PSSLOCK supported by DBIA 2789
	S PSORENXX=$P($G(OR0),"^",21),PSOFROM="NEW" K PRC,PHI
	;Begin WorldVistA change
	I $G(PSOAFYN)'="Y" I $G(PSORENXX) D PSOL^PSSLOCK(PSORENXX) I '$G(PSOMSG) D  K DIR,PSOMSG W ! S DIR("A")="Press Return to continue",DIR(0)="E" D ^DIR K DIR W ! Q
	.;End WorldVistA change
	I $G(PSORENXX) D PSOL^PSSLOCK(PSORENXX) I '$G(PSOMSG) D  K DIR,PSOMSG W ! S DIR("A")="Press Return to continue",DIR(0)="E" D ^DIR K DIR W ! Q
	.I $P($G(PSOMSG),"^",2)'="" W $C(7),!!,$P(PSOMSG,"^",2) Q
	.W $C(7),!!,"Another person is editing Rx "_$P($G(^PSRX(PSORENXX,0)),"^")
	;Begin WorldVistA change
	;WAS;K PSOMSG N OI,VALMCNT K POERR("DFLG") D FULL^VALM1 S (PSORX("DFLG"),PSORENW("DFLG"))=0,(PSORNW("FILL DATE"),PSORENW("FILL DATE"))=DT
	I $G(PSOAFYN)="Y" I $G(PSORENXX) D PSOL^PSSLOCK(PSORENXX) ;vfah
	I $G(PSOAFYN)'="Y" K PSOMSG N OI,VALMCNT K POERR("DFLG") D FULL^VALM1 S (PSORX("DFLG"),PSORENW("DFLG"))=0,(PSORNW("FILL DATE"),PSORENW("FILL DATE"))=DT ;vfah
	I $G(PSOAFYN)="Y" K PSOMSG N OI,VALMCNT K POERR("DFLG") S (PSORX("DFLG"),PSORENW("DFLG"))=0,(PSORNW("FILL DATE"),PSORENW("FILL DATE"))=DT ;vfah
	;End WorldVistA change
	S Y=DT X ^DD("DD") S PSORX("FILL DATE")=Y K Y
	;
	;Begin WorldVistA change
	;WAS;W !!,"Now Renewing Rx # "_$P(^PSRX($P(OR0,"^",21),0),"^")_"   Drug: "_$P($G(^PSDRUG($P(^PSRX($P(OR0,"^",21),0),"^",6),0)),"^"),! H 2
	I $G(PSOAFYN)'="Y" W !!,"Now Renewing Rx # "_$P(^PSRX($P(OR0,"^",21),0),"^")_"   Drug: "_$P($G(^PSDRUG($P(^PSRX($P(OR0,"^",21),0),"^",6),0)),"^"),! H 2 ;vfah
	;End WorldistA change
	I $P($G(^PSRX($P(OR0,"^",21),"OR1")),"^",4) D  D PROCESSX^PSORENW0 D UL Q
	.W !!,"Cannot Renew Rx # "_$P(^PSRX($P(OR0,"^",21),0),"^"),!," Drug: "_$P($G(^PSDRUG($P(^PSRX($P(OR0,"^",21),0),"^",6),0)),"^")_"."
	.W !,"This Rx has already been RENEWED ("_$P(^PSRX($P(^PSRX($P(OR0,"^",21),"OR1"),"^",4),0),"^")_").",!
	.S ACOM="Duplicate Renewal Request. Order rejected by Pharmacy.",PSONOOR="D" D DE^PSOORFI2 K ACOM,POERR("COMM"),POERR("PLACER"),POERR("STAT")
	I '$G(PSOTPBFG) D DSPL^PSOTPCAN(ORD)
	S (PSORX("PROVIDER NAME"),PSORENW("PROVIDER NAME"))=$P(^VA(200,$P(OR0,"^",5),0),"^"),PSORENW("NOO")=$P(OR0,"^",7)
	S PSORENW("PROVIDER")=$P(OR0,"^",5),PSORENW("MAIL/WINDOW")=$S($P(OR0,"^",17)="M":"M",1:"W")
	K PSORENW("ADMINCLINIC") S:$P(OR0,"^",17)="C" PSORENW("ADMINCLINIC")=1
	;I $O(^PSRX($P(OR0,"^",21),"PRC",0)) F I=0:0 S I=$O(^PSRX($P(OR0,"^",21),"PRC",I)) Q:'I  S PRC(I)=^PSRX($P(OR0,"^",21),"PRC",I,0)
	K II F I=0:0 S I=$O(^PS(52.41,ORD,1,I)) Q:'I  S DOSE=$G(^PS(52.41,ORD,1,I,1)),DOSE1=$G(^(2)) D
	.S II=$G(II)+1
	.S PSORENW("DOSE",II)=$P(DOSE1,"^"),PSORENW("DOSE ORDERED",II)=$P(DOSE1,"^",2),PSORENW("UNITS",II)=$P(DOSE,"^",9),PSORENW("NOUN",II)=$P(DOSE,"^",5)
	.S:$P(DOSE,"^",9) UNITS=$P(^PS(50.607,$P(DOSE,"^",9),0),"^")
	.S PSORENW("VERB",II)=$P(DOSE,"^",10),PSORENW("ROUTE",II)=$P(DOSE,"^",8)
	.S ROUTE=$S($P(DOSE,"^",8):$$GET1^DIQ(^PS(51.2,$P(DOSE,"^",8),0),"^"),1:"") ;PSO*7*384
	.S PSORENW("SCHEDULE",II)=$P(DOSE,"^"),PSORENW("DURATION",II)=$P(DOSE,"^",2)
	.I $P(DOSE,"^",6)]"" S PSORENW("CONJUNCTION",II)=$S($P(DOSE,"^",6)="S":"T",$P(DOSE,"^",6)="X":"X",1:"A")
	S PSORENW("ENT")=+$G(II) K II,I
	F DR=1:1:PSORENW("ENT") I $G(PSORENW("DURATION",DR))]"" D
	.S DUR1=PSORENW("DURATION",DR)
	.S PSORENW("DURATION",DR)=$S($E(DUR1,1)'?.N:$E(DUR1,2,99)_$E(DUR1,1),1:DUR1)
	D ^PSORENW1,CHECK^PSORENW0 I PSORENW("DFLG") D KLIB^PSORENW1 D PROCESSX^PSORENW0 D UL Q
	D FILDATE^PSORENW0,DRUG^PSORENW0 I PSORENW("DFLG")!$G(PSORX("DFLG")) D KLIB^PSORENW1 D PROCESSX^PSORENW0 D UL Q
	D RXN^PSORENW0 I PSORENW("DFLG") D KLIB^PSORENW1 D PROCESSX^PSORENW0 D UL Q
	D STOP^PSORENW1,INIT^PSORENW3
	I $G(PSOORRNW) D
	.S PSORENW("ISSUE DATE")=$S(PSORENW("FILL DATE")>DT:DT,PSORENW("FILL DATE")<$E($P(OR0,"^",6),1,7):PSORENW("FILL DATE"),1:$E($P(OR0,"^",6),1,7))
	.S PSORENW("# OF REFILLS")=+$P(OR0,"^",11),PSOFDR=1
	.S PSORENW("CLERK CODE")=$P(OR0,"^",4),PSORX("CLERK CODE")=$P(^VA(200,$P(OR0,"^",4),0),"^")
	;D CHK
	S PSOFXRN=0,PSOFXRNX=1
	S PSORENW("POE")=$S($G(^PS(52.41,ORD,"POE"))=1:1,'$O(^PSRX($P(OR0,"^",21),6,0)):1,1:"")
	S PSORENW("PENDING ORDER")=ORD
	D EN^PSOORNE4(.PSORENW) K PSORENW,PSORX("FILL DATE")
	I '$G(PSOFXRN) D UL
	D KLIB^PSORENW1
	K PSOFXRN,PSOFXRNX
	Q
CHK	;check for valid # of refills
	I $G(PSODRUG("DEA"))]"" D
	.S PSOCS=0 K DIR,DIC,PSOX
	.F DEA=1:1 Q:$E(PSODRUG("DEA"),DEA)=""  I $E(+PSODRUG("DEA"),DEA)>1,$E(+PSODRUG("DEA"),DEA)<6 S $P(PSOCS,"^")=1 S:$E(+PSODRUG("DEA"),DEA)=2 $P(PSOCS,"^",2)=1
	.;PSO*7*206
	.S PSOMAX=$S(PSOCS:5,1:11) I PSODRUG("DEA")["A"&(PSODRUG("DEA")'["B")!(PSODRUG("DEA")["F")!(PSODRUG("DEA")[1)!(PSODRUG("DEA")[2) S PSOMAX=0
	E  S PSOMAX=$P(OR0,"^",11)
	S RXPT=+$P(PSORENW("RX0"),"^",3) I $G(^PS(53,RXPT,0))]"" D
	.S PSORENW("# OF REFILLS")=$S(+$P(OR0,"^",11)>+$P(^PS(53,RXPT,0),"^",4):+$P(^PS(53,RXPT,0),"^",4),1:+$P(OR0,"^",11)),PSOX=+$P(^PS(53,RXPT,0),"^",4)
	.S PSORENW("# OF REFILLS")=$S(PSORENW("# OF REFILLS")>PSOMAX:PSOMAX,1:PSORENW("# OF REFILLS"))
	.S PSOMAX=$S(PSOMAX>+$P(^PS(53,RXPT,0),"^",4):+$P(^PS(53,RXPT,0),"^",4),1:PSOMAX) K RXPT
	E  D
	. I $G(PSOMAX) S PSORENW("# OF REFILLS")=$S(+$P(OR0,"^",11)>PSOMAX:PSOMAX,1:+$P(OR0,"^",11))
	Q
	;
EDTPEN	;edit front door renews
	N VALMCNT S Y=$P(XQORNOD(0),"=",2) D EDTSEL^PSOORNE4
	Q
UL	I $G(PSORENXX) D PSOUL^PSSLOCK(PSORENXX)
	K PSORENXX
	Q
