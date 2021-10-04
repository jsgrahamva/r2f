PSOCPPRE	;BIR/SAB - enhanced dup drug checker for copy orders ;09/21/06 11:34am
	;;7.0;OUTPATIENT PHARMACY;**251,375,387**;DEC 1997;Build 13
	;External references PSOL and PSOUL^PSSLOCK supported by DBIA 2789
	;External references to ^ORRDI1 controlled subscription supported by DBIA 4659
	;External references to ^XTMP("ORRDI" supported by DBIA 4660
	;External references to ^PSSHRQ2 supported by DBIA 5369
	S LIST="PSOPEP",$P(PSONULN,"-",79)="-",(STA,DNM)="" N PSODLQT
	F  S STA=$O(PSOSD(STA)) Q:STA=""  F  S DNM=$O(PSOSD(STA,DNM)) Q:DNM=""  D  Q:$G(PSORX("DFLG"))
	.I STA="PENDING" D ^PSODDPR1 Q
	.I STA="ZNONVA" D NVA^PSODDPR1 Q
	.D:PSODRUG("NAME")=$P(DNM,"^")&('$D(^XUSEC("PSORPH",DUZ)))  Q:$G(PSORX("DFLG"))
	..I $P($G(PSOPAR),"^",16) D DUP^PSODDPRE Q:$G(PSORX("DFLG"))
	..I $P(PSOPAR,"^",2),'$P($G(PSOPAR),"^",16) D DUP^PSODDPRE Q:$G(PSORX("DFLG"))
	..I '$P(PSOPAR,"^",2),'$P($G(PSOPAR),"^",16) D DUP^PSODDPRE Q:$G(PSORX("DFLG"))
	.D:PSODRUG("NAME")=$P(DNM,"^")&($D(^XUSEC("PSORPH",DUZ))) DUP^PSODDPRE
	Q:$G(PSORX("DFLG"))
	D HD^PSODDPR2():(($Y+5)'>IOSL)
	D REMOTE
	Q
OBX	S LIST="PSOPEPS"
	K ^TMP($J,"DD"),^TMP($J,"DC"),^TMP($J,"DI"),PSODLQT,DTOUT,DUOUT,DIRUT,PSODOSD
	K HZVA,ZVA,ZORS,ZZDGDG,ON,DRG,SV,DGI,PSORX("INTERVENE"),DIR,ZTHER,IT
	K DIR I $P(^TMP($J,LIST,"OUT",0),"^")=-1 G EXIT
	K ^TMP($J,LIST,"IN","PING"),^TMP($J,LIST,"OUT","DRUGDRUG"),^TMP($J,LIST,"OUT","THERAPY")
	W !,"Now Processing Enhanced Order Checks!  Please wait...",! H 2
	D FDB^PSODDPRE S PDRG=PSODRUG("IEN"),DO=0 D REMOTE^PSODDPR4
	D IN^PSSHRQ2(LIST)    ;if patient has meds
	;
	K DIR
	I $P(^TMP($J,LIST,"OUT",0),"^")=-1 D DATACK^PSODDPRE G EXIT
	D ^PSODDPR2 ;if order checks returned
	;
EXIT	;
	I $G(PSODLQT)!$G(PSORX("DFLG")) S PSODOSD=1
	D ^PSOBUILD K CAN,DA,DIR,DNM,DUPRX0,ISSD,J,LSTFL,MSG,PHYS,PSOCLC,PSONULN,REA,RFLS,RX0,RX2,RXREC,ST,Y,ZZ,ACT,PSOCLOZ,PSOLR,PSOLDT,PSOCD,SIG
	K ^TMP($J,LIST,"IN","PING"),^TMP($J,LIST,"OUT","DRUGDRUG"),^TMP($J,LIST,"OUT","THERAPY"),^TMP($J,"PSOPEPS"),^TMP($J,"PSORDI")
	K DO,LIST,DNM,PSONULN,PSORX("DFLG"),RXRECCOP,STA,Y,PSODLQT
	K HZVA,ZVA,ZORS,ZZDGDG,ON,DRG,SV,DGI,PSORX("INTERVENE"),DIR,ZTHER,IT
	S VALMBCK="R"
	Q
ULRX	;
	I '$G(RXRECCOP) Q
	D PSOUL^PSSLOCK(RXRECCOP)
	Q
	;
REMOTE	;
	I $T(HAVEHDR^ORRDI1)']"" Q
	I '$$HAVEHDR^ORRDI1 Q
	I $D(^XTMP("ORRDI","OUTAGE INFO","DOWN")) G REMOTE2
	D HD^PSODDPR2():(($Y+5)'>IOSL)
	W !!,"Now doing remote order checks. Please wait...",!
	D REMOTE^PSOORRDI(PSODFN,PSODRUG("IEN"))
	D HD^PSODDPR2():(($Y+5)'>IOSL)
	I '$D(^XUSEC("PSORPH",DUZ)),$P(PSOPAR,"^",2),$G(PSOTECCK) G REMOTE2
	I $D(^TMP($J,"DD")) D DUP^PSOORRD2
REMOTE2	;
	K ^TMP($J,"DD"),^TMP($J,"DC"),^TMP($J,"DI")
	Q