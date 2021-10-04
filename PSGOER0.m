PSGOER0	;BIR/CML3-EDIT FIELDS FOR RENEWAL ;05 May 98 / 10:58 AM
	;;5.0; INPATIENT MEDICATIONS ;**11,45,47,50,63,64,70,69,58,80,110,127,136,181**;16 DEC 97;Build 190
	;
	; Reference to ^PS(55 is supported by DBIA 2191.
	; Reference to ^VA(200 is supported by DBIA 10060.
	; Reference to ^DD(55.06 is supported by DBIA 2253.
	; Reference to ^%DT is supported by DBIA 10003.
	; Reference to ^DIC is supported by DBIA 10006.
	;
DATE(PSGP,PSGORD,PSGDT)	;
	K PSGFOK,PSJNOO S F1=55.06,PSGWLL=+$G(^PS(55,PSGP,5.1)),PSGOER0=$G(^PS(55,PSGP,5,+PSGORD,0)),PSGPDRG=+$G(^(.2)),PSGOER2=$G(^(2))
	NEW XX S XX=$$ACTIVE^PSJORREN(PSGP,PSGORD) S:+XX=2 PSGPDRG=$P(XX,U,2)
	I '+XX W !,"No active Orderable Item was found.",! G DONE
	S (PSGNEDFD,PSGOERDP)=$P($$GTNEDFD^PSGOE7("U",PSGPDRG),U)
	S PSGSCH=$P(PSGOER2,"^"),PSGST=$P(PSGOER0,"^",7),PSGS0Y=$P(PSGOER2,"^",5),PSGS0XT=$P(PSGOER2,"^",6)
	S PSGOEPR=+$P(PSGOER0,"^",2),(PSGOPR,PSGPR)=$S($P(PSJSYSU,";",2):DUZ,1:+PSGOEPR)
	I $G(PSJSPEED) S PSGPR=$S($P(ND,"^",2):$P(ND,"^",2),1:+PSGOEPR)
	S PSGOSD=+$P(PSGOER2,"^",2) S PSGOFD=+$P(PSGOER2,"^",4),PSGPRN=$P($G(^VA(200,PSGPR,0)),"^"),PSGPRI=$S($P(PSJSYSU,";",2):0,1:$P($G(^("PS")),"^",4)),PSGRO=0 S:PSGPRI PSGPRI=PSGPRI'>DT I PSGPRI S (PSGOPR,PSGPR,PSGPRN)=""
	S PSGRNSD=$S($G(PSGLI):PSGLI,1:$G(PSGDT))
	S PSGSD=$G(PSGOSD)
	I PSGSD="" S PSJREN=1,PSGSD=$$ENSD^PSGNE3($S(PSGST["P":"PRN",1:$P(PSGOER2,U)),PSGS0Y,PSGDT,PSGOSD) S:PSGOSD>PSGSD PSGSD=PSGOSD K PSJREN
	S PSGSDN=$$ENDD^PSGMI(PSGSD)
10	;
	;W !,"START DATE/TIME: "_PSGSDN
O25	;
	N PSGSD,PSGNEFD S PSGSD=PSGDT
	D ENWALL^PSGNE3(PSGSD,0,PSGP)
	S:'$G(PSGDT) PSGDT=$$DATE2^PSJUTL2($$NOW^XLFDT)
	N PSGNESD S PSGNESD=PSGDT D ENFD^PSGNE3(PSGNESD) I $G(PSGNEFD) S (Y,PSGFD)=PSGNEFD
	S PSGFOK(10)="" I PSGST="O" S PSGFD=$$ENOSD^PSJDCU(PSJSYSW0,PSGRNSD,PSGP) I PSGFD]"" S Y=PSGRNSD,X=0 G 1
D25	K DUR,DURMIN N PKGFLG S PKGFLG=$S(PSGORD["U":5,PSGORD["V":"IV",PSGORD["P":"P",1:"") I PKGFLG]"" S DUR=$$GETDUR^PSJLIVMD(PSGP,+$G(PSGORD),PKGFLG,1) I DUR]"" D
	.S DURMIN=($$DURMIN^PSJLIVMD(DUR)\1) I DURMIN>1 S Y=$$FMADD^XLFDT(PSGRNSD,,,DURMIN) I Y>PSGRNSD S PSGFD=Y,X=0
	I $P($G(PSGOER2),"^",4)>PSGFD S Y=$P(PSGOER2,"^",4)
	I $G(DUR)]"",($G(PSGORD)'["P") S DURMIN=$$DURMIN^PSJLIVMD(DUR)\1 S Y=$$FMADD^XLFDT(PSGDT,,,DURMIN)
	S:X&$P(PSJSYSW0,"^",7) $P(Y,".",2)=$P(PSJSYSW0,"^",7) S PSGFD=+Y,PSGFDN=$$ENDD^PSGMI(PSGFD)
25	W !,"STOP DATE/TIME: "_PSGFDN_"// " R X:DTIME I X="^"!'$T W:'$T $C(7) S:'$T X="^" S PSGRO=1,COMQUIT=1 G DONE
	I X="" W "   "_PSGFDN G W25
	I $E(X)="^" D FF G:Y>0 @Y G 25
	S PSGF2=25 I X="@"!(X?1."?") W:X="@" $C(7),"  (Required)" S:X="@" X="?" D ENHLP^PSGOEM(55.06,25)
	I X=+X,X>0,X'>2000000 G 25:'$$ENDL^PSGDL(PSGSCH,X) K PSGDLS S PSGDL=X,ND2=PSGOER2,$P(ND2,"^",2)=PSGRNSD W " ...dose limit..." D ENGO^PSGDL
	K %DT S %DT="ERTX" D ^%DT K %DT G:Y'>0 25 S PSGFD=+Y,PSGFDN=$$ENDD^PSGMI(PSGFD)
W25	I PSGFD<PSGDT W $C(7),!!?13,"*** WARNING! THE STOP DATE ENTERED IS IN THE PAST! ***",!
	I PSGFD<PSGSD W $C(7),!!?3,"*** The STOP date must be AFTER the START date. ***" G 25
	S PSGFOK(25)=""
	;Display Expected First Dose;BHW;PSJ*5*136
	D EFDNEW^PSJUTL
	I $G(PSGONF),(+$G(PSGODDD(1))'<+$G(PSGONF)) S PSGFOK(1)="" Q
1	; provider
	G:+PSJSYSU<3&$P(PSJSYSU,";",2) CHKDD S PSGF2=1
A1	;
	W !,"PROVIDER: ",$S(PSGPR:PSGPRN_"// ",1:"") R X:DTIME I X="^"!'$T W:'$T $C(7) S:'$T X="^" S PSGRO=1,COMQUIT=1 G DONE
	I $S(X="":'PSGPR,1:X="@") W $C(7),"  (Required)" S X="?" D ENHLP^PSGOEM(55.06,1) G A1
	I X="",PSGPR S X=PSGPRN I PSGPR'=PSGPRN,$D(^VA(200,PSGPR,"PS")) W "    "_$P(^("PS"),"^",2)_"    "_$P(^("PS"),"^",3) S PSGFOK(1)="" G OC55
	I X?1."?" D ENHLP^PSGOEM(55.06,1)
	I $E(X)="^" D FF G:Y>0 @Y G A1
	K DIC S DIC="^VA(200,",DIC(0)="EMQZ",DIC("S")="S X(1)=$G(^(""PS"")) I X(1),$S('$P((X(1)),""^"",4):1,1:DT<$P((X(1)),""^"",4))" D ^DIC K DIC I Y'>0 G A1
	S PSGPR=+Y,PSGPRN=$P(Y(0,0),"^"),PSGFOK(1)=""
OC55	;
	;Order check for Speed finish is triggered from OC531^PSGOESF
	I $G(PSGORD)]"P",$G(PSJSPEED) Q
	D NEWOC55^PSGOER
	I $G(PSGORQF) S COMQUIT=1 G DONE
CHKDD	;
	G:$G(PSGRENEW) 106
	I PSGORD["P"!$$DDOK^PSGOE2("^PS(55,"_PSGP_",5,"_+PSGORD_",1,",PSGPDRG) G 106
	;I PSGORD["P"!'$$CHKDD^PSGOE2("^PS(55,"_PSGP_",5,"_+PSGORD_",") G 106
	I $P(PSJSYSU,";")'=3,'$P(PSJSYSP0,U,2) W !!,"This order's dispense drug is invalid, a pharmacist must renew this order." Q
	K ^PS(53.45,PSJSYSP,1),^(2)
	W !!,"THE DISPENSE DRUG IS MISSING FROM THIS ORDER."
	D ENDRG^PSGOEF1(+^PS(55,PSGP,5,+PSGORD,.2),0)
	I $G(DUOUT)!'$G(DRG) S COMQUIT=1 Q
106	; nature of order
	S PSJNOO=$$ENNOO^PSJUTL5("R") S:PSJNOO<0 COMQUIT=1
	S:PSJNOO'<0 PSGFOK(106)=""
DONE	;
	K F,F0,F1,PSGF2,F3,ND2,PSGDL,PSGDLS,PSGOROE1,PSGRO,SDT Q
FF	; "^" to another field
	K DIC S DIC="^DD(55.06,",DIC(0)="EQ",DIC("S")="I $D(PSGFOK(+Y))",X=$E(X,2,255) D ^DIC K DIC
	S Y=+Y Q
