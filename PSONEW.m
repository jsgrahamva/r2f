PSONEW	;BIR/SAB-new rx order main driver ;2:17 PM  7 Sep 2015
	;;7.0;OUTPATIENT PHARMACY;**11,27,32,46,94,130,268,225,251,379,390,417,313,WVEHR,LOCAL**;DEC 1997;Build 4
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
	;External references L and UL^PSSLOCK supported by DBIA 2789
	;External reference to ^VA(200 supported by DBIA 224
	;External reference to ^XUSEC supported by DBIA 10076
	;External reference to ^ORX1 supported by DBIA 2186
	;External reference to ^ORX2 supported by DBIA 867
	;External reference to ^TIUEDIT supported by DBIA 2410
	;External reference to SAVEOC4^OROCAPI1 supported by DBIA 5729
	;External reference to ^ORD(100.05, supported by DBIA 5731
	;---------------------------------------------------------------
OERR	;backdoor new rx for v7
	K PSOREEDT,COPY,SPEED,PSOEDIT,DUR,DRET,PSOTITRX,PSOMTFLG N PSOCKCON,PSODAOC
	S PSOPLCK=$$L^PSSLOCK(PSODFN,0) I '$G(PSOPLCK) D LOCK^PSOORCPY S VALMSG=$S($P($G(PSOPLCK),"^",2)'="":$P($G(PSOPLCK),"^",2)_" is working on this patient.",1:"Another person is entering orders for this patient.") K PSOPLCK S VALMBCK="" Q
	K PSOPLCK S X=PSODFN_";DPT(" D LK^ORX2 I 'Y S VALMSG="Another person is entering orders for this patient.",VALMBCK="" D UL^PSSLOCK(PSODFN) Q
AGAIN	N VALMCNT K PSODRUG,PSOCOU,PSOCOUU,PSONOOR,PSORX("FN"),PSORX("DFLG"),PSOQUIT,POERR S PSORX("DFLG")=0
	W ! D HLDHDR^PSOLMUTL S (PSONEW("QFLG"),PSONEW("DFLG"),PSOQUIT)=0,PSOFROM="NEW",PSONOEDT=1
	K ORD D FULL^VALM1,^PSONEW1 ; Continue order entry
	I PSONEW("QFLG") G END
	I PSONEW("DFLG") W !,$C(7),"RX DELETED",! S:$G(POERR) POERR("DFLG")=1,VALMBCK="Q" G END
	D:$P($G(PSOPAR),"^",7)=1 AUTO^PSONRXN I $P($G(PSOPAR),"^",7)'=1 S PSOX=PSONEW("RX #") D CHECK^PSONRXN
	I PSONEW("DFLG")!PSONEW("QFLG") D DEL S:$G(POERR) POERR("DFLG")=1,VALMBCK="R" G END
	D NOOR I PSONEW("DFLG") D DEL G END
	D ^PSONEW2 I PSONEW("DFLG") D DEL S:$G(POERR) POERR("DFLG")=1,VALMBCK="R" G END ; Asks if correct
	G:$G(PSORX("FN")) END
	D EN^PSON52(.PSONEW) ; Files entry in File 52
	D NPSOSD^PSOUTIL(.PSONEW) ; Adds newly added rx to PSOSD array
	S VALMBCK="R"
	;
	; - Possible Titration prescription
	I $G(PSONEW("IRXN")) D MARK^PSOOTMRX(PSONEW("IRXN"),0)
	;
END	D EOJ ; Clean up
	I '$G(PSORX("FN")) W ! K DIR,DIRUT,DUOUT,DTOUT S DIR(0)="Y",DIR("B")="YES",DIR("A")="Another New Order for "_PSORX("NAME") D ^DIR K DIR,DIRUT,DUOUT,DTOUT I Y K PSONEW,PSDRUG,ORD G AGAIN
	D ^PSOBUILD,BLD^PSOORUT1 S X=PSODFN_";DPT(" D ULK^ORX2 D UL^PSSLOCK(PSODFN)
	D RV^PSOORFL
	S VALMBCK="R" K PSORX("FN") Q
	;----------------------------------------------------------------
DEL	;
	W !,$C(7),"RX DELETED",!
	I $P($G(PSOPAR),"^",7)=1 D
	. S DIE="^PS(59,",DA=PSOSITE,PSOY=$O(PSONEW("OLD LAST RX#",""))
	. S PSOX=PSONEW("OLD LAST RX#",PSOY)
	. L +^PS(59,+PSOSITE,PSOY):$S(+$G(^DD("DILOCKTM"))>0:+^DD("DILOCKTM"),1:3)
	. S DR=$S(PSOY=8:"2003////"_PSOX,PSOY=3:"1002.1////"_PSOX,1:"2003////"_PSOX)
	. D:PSOX<$P(^PS(59,+PSOSITE,PSOY),"^",3) ^DIE K DIE,X,Y
	. L -^PS(59,+PSOSITE,PSOY)
	. K PSOX,PSOY Q
EOJ	;
	I $D(PSONEW("RX #")) L -^PSRX("B",PSONEW("RX #")) ; +Lock set in PSONRXN
	K PSONOEDT,PSONEW,PSODRUG,ANQDATA,LSI,C,MAX,MIN,NDF,REF,SIG,SER,PSOFLAG,PSOHI,PSOLO,PSONOOR,PSOCOUU,PSOCOU,PSORX("EDIT")
	D CLEAN^PSOVER1
	K ^TMP("PSORXDC",$J),RORD,ACOM,ACNT,CRIT,DEF,F1,GG,I1,IEN,INDT,LAST,MSG,NIEN,STA,DUR,DRET,PSOPRC
	S (ZRXN,RXN)=$O(^TMP("PSORXN",$J,0)) I RXN D
	.S RXN1=^TMP("PSORXN",$J,RXN) D EN^PSOHLSN1(RXN,$P(RXN1,"^"),$P(RXN1,"^",2),"",$P(RXN1,"^",3))
	.I $P(^PSRX(RXN,"STA"),"^")=5 D EN^PSOHLSN1(RXN,"SC","ZS","")
	.;saves drug allergy order chks pso*7*390
	.I +$G(^TMP("PSODAOC",$J,1,0)) D
	..S RXN=ZRXN,PSODAOC="Rx Backdoor "_$S($P(^PSRX(RXN,"STA"),"^")=4:"NON-VERIFIED ",1:"")_"NEW Order Acceptance_OP"
	..D DAOC
	K ZRXN,RXN,RXN1,^TMP("PSORXN",$J),^TMP("PSODAOC",$J),RET,PSODAOC
	I $G(PSONOTE) D FULL^VALM1,MAIN^TIUEDIT(3,.TIUDA,PSODFN,"","","","",1)
	K PSONOTE,PSOCKCON
	;W !! K DIR S DIR(0)="E",DIR("?")="Press Return to continue",DIR("A")="Press Return to Continue" D ^DIR K DIR,DTOUT,DUOUT
	Q
NOOR	;asks nature of order
	N PSONOODF
	S PSONOODF=0
	I $G(OR0) D  G NOORX ;front door
	.S PSOI=$S($G(PSOSIGFL):1,$G(PSODRUG("OI"))'=$P(OR0,"^",8):1,1:0) I 'PSOI S PSONOOR="" D:$D(^XUSEC("PSORPH",DUZ)) COUN Q  ;NoO $P(OR0,"^",7)
	.S PSONOODF=1
	.D DIR I $D(DIRUT) S PSONEW("DFLG")=1 Q
	.S PSONOOR=Y D:$D(^XUSEC("PSORPH",DUZ)) COUN K DIR,DTOUT,DTOUT,DIRUT
	;backdoor order
	D DIR I $D(DIRUT) S PSONEW("DFLG")=1,VALMBCK="Q" Q
	S PSONOOR=Y K DIK,DA,DIE,DR,PSOI,DIR,DUOUT,DTOUT,DIRUT
	G:'$D(^XUSEC("PSORPH",DUZ)) NOORX
COUN	;patient counseling
	G:$G(PSORX("EDIT"))&('$G(PSOSIGFL)) NOORX K DIR,DUOUT,DTOUT,DIRUT
	;Begin WorldVistA change
	;WAS;S DIR("B")="NO",DIR(0)="52,41" D ^DIR S PSOCOU=$S(Y:Y,1:0)
	I $G(PSOAFYN)'="Y" S DIR("B")="NO",DIR(0)="52,41" D ^DIR S PSOCOU=$S(Y:Y,1:0)
	I $G(PSOAFYN)="Y" S PSOCOU=0 ;vfam No Patient Counseling by AutoFinih
	;End WorldVistA change
	I $D(DIRUT)!('PSOCOU) S PSOCOUU=0 D:'$G(SPEED) PRONTE Q
	K:'$G(PSOCOU) PSOCOUU K DIR,DUOUT,DTOUT,DIRUT I Y S DIR(0)="52,42",DIR("B")="NO" D ^DIR S PSOCOUU=$S(Y:Y,1:0)
PRONTE	K PSONOTE,DIR,DIRUT,DUOUT
	I $T(MAIN^TIUEDIT)]"",'$G(SPEED) D  K DIR,DIRUT,DUOUT
	.;Begin WorldVistA change
	.;WAS;S DIR(0)="Y",DIR("B")="No",DIR("A")="Do you want to enter a Progress Note",DIR("A",1)="" D ^DIR K DIR
	.I $G(PSOAFYN)'="Y" S DIR(0)="Y",DIR("B")="No",DIR("A")="Do you want to enter a Progress Note",DIR("A",1)="" D ^DIR K DIR
	.I $G(PSOAFYN)="Y" S Y="0" ;vfam No Progress Notes in AutoFinish
	.;End WorldVistA change
	.S PSONOTE=+Y Q  ;I 'Y!($D(DIRUT)) Q
NOORX	K X,Y,DIR,DUOUT,DTOUT,DIRUT
	Q
DIR	;ask nature of order
	K DIR,DTOUT,DTOUT,DIRUT I $T(NA^ORX1)]""  D  Q
	.S PSONOOR=$$NA^ORX1($S($G(PSONOODF)!($G(PSONOBCK)):"S",1:"W"),0,"B","Nature of Order",0,"WPSDIVR"_$S(+$G(^VA(200,DUZ,"PS")):"E",1:""))
	.I +PSONOOR S (Y,PSONOOR)=$P(PSONOOR,"^",3) Q
	.S DIRUT=1 K PSONOOR
	I $D(PSONOOR) S DF=PSONOOR,PSONODF=$S(DF="E":"PROVIDER ENTERED",DF="V":"VERBAL",DF="P":"TELEPHONE",DF="D":"DUPLICATE",DF="S":"SERVICE CORRECTED",DF="I":"POLICY",DF="R":"SERVICE REJECTED",1:"WRITTEN")
	K DIR,DTOUT,DTOUT,DIRUT S DIR("A")="Nature of Order: ",DIR("B")=$S($D(PSONOOR):PSONODF,1:"WRITTEN")
	S DIR(0)="SA^W:WRITTEN;V:VERBAL;P:TELEPHONE;S:SERVICE CORRECTED;D:DUPLICATE;I:POLICY;R:SERVICE REJECTED"_$S(+$G(^VA(200,DUZ,"PS")):";E:PROVIDER ENTERED",1:"")
	D ^DIR K DF,PSONODF Q:$D(DIRUT)  S PSONOOR=Y
DIRX	Q
	;
NOORE(PSONEW)	;entry point for renew
	D NOOR I $D(DIRUT) S PSONEW("DFLG")=1 Q
	S PSONEW("NOO")=PSONOOR
	Q
DAOC	;stores drug allergies w/sign/symptoms
	Q:'$D(^TMP("PSODAOC",$J,1,0))
	N DA,OCCDT,ORN,ORL,Z,RET S OCCDT=$$NOW^XLFDT,ORN=$P(^PSRX(RXN,"OR1"),"^",2)
	S ORL(1,1)=ORN_"^"_PSODAOC_"^"_DUZ_"^"_OCCDT_"^3^"
	S ORL(1,2)="A Drug-Allergy Reaction exists for this medication and/or class"
	D SAVEOC^OROCAPI1(.ORL,.RET)
	S DA=$O(RET(1,0)) Q:'DA
	S $P(^ORD(100.05,DA,0),"^",2)=6
	S ^ORD(100.05,DA,4,0)="100.517PA^1^1"
	S ^ORD(100.05,DA,4,1,0)=^TMP("PSODAOC",$J,1,0)
	S ^ORD(100.05,DA,4,"B",$P(^TMP("PSODAOC",$J,1,0),"^"),1)=""
	;
	I $O(^TMP("PSODAOC",$J,1,0)) F I=0:0 S I=$O(^TMP("PSODAOC",$J,1,I)) Q:'I  D
	.S ^ORD(100.05,DA,4,1,1,0)="100.5173PA^"_I_"^"_I
	.S ^ORD(100.05,DA,4,1,1,I,0)=^TMP("PSODAOC",$J,1,I)
	.S ^ORD(100.05,DA,4,1,1,"B",^TMP("PSODAOC",$J,1,I),I)=""
	;
	I $O(^TMP("PSODAOC",$J,2,0)) S Z=0 F I=0:0 S I=$O(^TMP("PSODAOC",$J,2,I)) Q:'I  S Z=Z+1 D
	.S ^ORD(100.05,DA,4,1,2,0)="100.5174PA^"_Z_"^"_Z
	.S ^ORD(100.05,DA,4,1,2,Z,0)=^TMP("PSODAOC",$J,2,I)
	.S ^ORD(100.05,DA,4,1,2,"B",^TMP("PSODAOC",$J,2,I),Z)=""
	;
	I $O(^TMP("PSODAOC",$J,3,0)) F I=0:0 S I=$O(^TMP("PSODAOC",$J,3,I)) Q:'I  D
	.S ^ORD(100.05,DA,4,1,3,0)="100.5175PA^"_I_"^"_I
	.S ^ORD(100.05,DA,4,1,3,I,0)=^TMP("PSODAOC",$J,3,I)
	.S ^ORD(100.05,DA,4,1,3,"B",^TMP("PSODAOC",$J,3,I),I)=""
	K ^TMP("PSODAOC",$J)
	Q
