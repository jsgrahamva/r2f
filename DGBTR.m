DGBTR	;ALB/LM - BENEFICIARY TRAVEL RE-PRINT; 1/30/89@8:00 ;4/26/91  14:32
	;;1.0;Beneficiary Travel;**20**;September 25, 2001;Build 185
	;
	Q
DISPLAY	;display the selected claim
	N DGBTCMTY,NOLINE
	D QUIT^DGBTEND
	S DGBTR=1 D ASK I $G(DFN)="" D QUIT Q
	I '$D(DGBTDT) D QUIT
	S DGBTCMTY=$$GET1^DIQ(392,DGBTDT,56)
	D CLMTYP(.DGBTCMTY)
	I $G(DGBTCMTY)="S" S NOLINE=0 K DGBTSP D SCREEN^DGBTCDSP D QUIT,DISPLAY Q
	I '$D(DGBTDT) D QUIT Q
	I '$D(^DGBT(392,DGBTDT,0)) D QUIT Q
	S VADAT("W")=DGBTDT
	D ^VADATE
	S DGBTDTE=VADATE("E"),IOP=""
	D ^%ZIS
	D SCREEN^DGBTCD
	D QUIT
	D DISPLAY Q
	;
REPRINT	;
	N DGBTDLTR
	S DGBTR=0 D ASK
	I '$D(DGBTDT) D QUIT Q
	S DGBTDLTR=$$GET1^DIQ(392,DGBTDT,45.2,"I")
	I DGBTDLTR=1 W !!,"CLAIM WAS DENIED. NO VOUCHER FOR THIS CLAIM",!! D QUIT D REPRINT Q
	I '$D(^DGBT(392,DGBTDT,0)) D QUIT Q
	I '$D(MONTOT) N MONTOT D 
	.N TOTRIPS,ONEWAY,RT,MONTHDED,WAIVER,WTYPE,TTRIPS,TDED,DGBTDTI,RDVMSG,DGBTRET,DGBTRDV,TFIEN
	.S DGBTDTI=DGBTA
	.D MONTOT^DGBT1(.TOTRIPS,.ONEWAY,.RT,.MONTHDED,.WAIVER,.WTYPE,.TTRIPS,.TDED)
	D START^DGBTCR
	D QUIT Q
	;
ASK	;
	S DIC="^DPT(",DIC(0)="AEQMZ" D ^DIC
	I Y<1 D QUIT Q
	S DFN=+Y
	I '$D(^DGBT(392,"C",DFN)) W !!,"There are no computer entries on file for this patient.",! D ASK Q
	D 6^VADPT
	K ^UTILITY($J,"DGBT")
	W:'DGBTR !!,"Only claims with ACCOUNT TYPE of ALL OTHER or C&P are listed as choices.",! D LIST Q
	Q
	;
LIST	;list the patients claim by newest claim first
	;
	N DGBTDCLM
	S X="",(DGBTC,DGBTCH)=0
	F I=0:0 S I=$O(^DGBT(392,"AI",DFN,I)) Q:'I  S J=^(I) I $S(DGBTR:1,$D(^DGBT(392,"ACTP",4,J)):1,$D(^DGBT(392,"ACTP",5,J)):1,1:0) S DGBTC=DGBTC+1,^UTILITY($J,"DGBT",DGBTC,I)=9999999.99999-I
	I '$D(^UTILITY($J,"DGBT"))!'$D(^DGBT(392,"C",DFN)) W !,"There are no computer entries on file for this patient with these account types.",! D ASK Q
	I $D(^UTILITY($J,"DGBT")) W !,"Select Claim DATE/TIME: ",!
	;F I=0:0 S I=$O(^UTILITY($J,"DGBT",I)) Q:'I!(DGBTCH)!(X["^")  D  I K#5=0 D CHOZ G QUIT:$D(DTOUT) Q:DGBTCH
	F I=0:0 S I=$O(^UTILITY($J,"DGBT",I)) D CHOZLAST Q:'I!(DGBTCH)!(X["^")  D  G QUIT:$D(DTOUT)!($D(DUOUT)) Q:DGBTCH
	.F J=0:0 S J=$O(^UTILITY($J,"DGBT",I,J)) Q:'J  Q:DGBTCH  D
	..S K=I,VADAT("W")=^(J)
	..D ^VADATE S DGBTDCLM=$$GET1^DIQ(392,VADAT("W"),45,"I")
	..W !?5,I,".",?10,VADATE("E")_$S($G(DGBTDCLM)'="":" (D)",1:"") D:K#5=0 CHOZ Q:DGBTCH  I $D(DTOUT)!($D(DUOUT)) Q  ;D QUIT Q
	I DGBTCH S DGBTA=$O(^UTILITY($J,"DGBT",X,0)),DGBTA=^UTILITY($J,"DGBT",X,DGBTA) S (DGBTDT,VADAT("W"))=DGBTA D ^VADATE S DGBTDCLM=$$GET1^DIQ(392,VADAT("W"),45,"I") W "  ",VADATE("E")_$S($G(DGBTDCLM)'="":" (D)",1:"")
	I 'DGBTCH D ASK
	Q
	;
CHOZ	;
	Q:DGBTCH
	I K'=DGBTC S DIR("A",1)="",DIR("A",2)="Type '^' to Stop, or" S DIR("?")="^D HELP^DGBTR"
	S DIR("A")="Choose 1-"_$S(K=1:"",1:K)_": ",DIR(0)="NOA^1:"_K  D ^DIR K DIR S:$D(DTOUT) DTOUT=1 I Y,$D(^UTILITY($J,"DGBT",Y)) S DGBTCH=1 Q
	Q
CHOZLAST	;
	Q:I
	Q:DGBTCH
	D CHOZ
	Q
QUIT	K DIC,DTOUT,X,VA,VADAT,VADATE,DGBTDT,DFN,VAEL,VADM,VAPA,DFN,DGBTA,DGBTC,DGBTCH,DGBTDTE,DGBTR,I,J,K,Y,DGBTFCTY,DGBTMR,DGBTTCTY,VAERR,DGBTCNU,DGBTVAR
	K DEDUCT,DTOTAL,ONEWAY,RTRIP,MDATA,PDATA,DGVAR,DGPGM,DGBTACCT,CDAT,EMONTH,EDATE
	Q
	; 
HELP	W !!,"ANSWER WITH NUMERIC CHOICE.  BECAUSE ENTRIES ARE STORED BY DATE.TIME.SECONDS,",!,"YOU MUST ENTER A NUMERIC CHOICE."
	Q
	;
CLMTYP(DGBTCMTY)	;this will return the claim type from ^DGBT(392,IEN,0) field #56. If equal null then mileage claim, if equal "S", special mode claim
	S DGBTCMTY=$$GET1^DIQ(392,DGBTDT,56,"I")
	S DGBTCMTY=$S($G(DGBTCMTY)="S":DGBTCMTY,1:"M")
	Q
	;
