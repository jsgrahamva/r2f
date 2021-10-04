PSJCOMR	;BIR/CML3-RENEW A COMPLEX ORDER SERIES ;07 MAR 96 / 1:23 PM
	;;5.0;INPATIENT MEDICATIONS;**110,127,136,157,181,268**;16 DEC 97;Build 9
	;
	; Reference to ^PS(55 supported by DBIA 2191.
	; Reference to ^PSSLOCK is supported by DBIA 2789.
	; Reference to NOW^%DTC is supported by DBIA 10000.
	; Reference to ^DIR is supported by DBIA 10026.
	;
	; renew a complex order series
	Q:'PSJCOM  K COMQUIT,PSGORQF
	W !!,"This order is part of a complex order. If you "_$S($P(PSJSYSP0,"^",3):"RENEW",1:"MARK")_" this order the",!,"following orders will be "_$S($P(PSJSYSP0,"^",3):"RENEWED",1:"MARKED")_" too." D CMPLX^PSJCOM1(PSGP,PSJCOM,PSGORD)
	W !! K DIR S DIR(0)="Y",DIR("A")=$S($P(PSJSYSP0,"^",3):"RENEW THIS COMPLEX ORDER SERIES",1:"MARK THIS COMPLEX ORDER SERIES FOR RENEWAL"),DIR("B")="YES"
	S DIR("?")="Answer 'YES' to "_$S($P(PSJSYSP0,"^",3):"renew this complex order series",1:"mark this complex order series for renewal")_".  Answer 'NO' (or '^') to stop now." D ^DIR K DIR
	I 'Y N DIR D ABORT G DONE
	I '$D(DIRUT),Y D NEW S PSGCANFL=1 D DONE Q
	I '$D(DIRUT),PSJSYSU I $P(PSGND4,"^",15),$P(PSGND4,"^",16) D UNMARK,DONE Q
	D DONE,ABORT^PSGOEE
	Q
	;
UNMARK	;  
	W !!,"THIS COMPLEX ORDER SERIES HAS BEEN 'MARKED FOR RENEWAL'.",! K DIR S DIR(0)="Y",DIR("A")="DO YOU WANT TO 'UNMARK IT'",DIR("B")="NO"
	S DIR("?",1)="  Answer 'YES' to unmark this complex order series.  Answer 'NO' (or '^') to leave the complex",DIR("?")="order series marked.  (An answer is required.)" D ^DIR
	I 'Y N DIR D ABORT^PSGOEE G DONE
	N PSGORD,XX,X S XX=0,X="" F  S XX=$O(^PS(55,"ACX",PSJCOM,XX)) Q:'XX  F  S X=$O(^PS(55,"ACX",PSJCOM,XX,X)) Q:X=""  S PSGORD=X D
	.S PSGND4=$G(^PS(55,PSGP,5,+PSGORD,4))
	.S DA(1)=PSGP,DA=+PSGORD,PSGAL("C")=21180+PSJSYSU D ^PSGAL5 S $P(PSGND4,"^",15,17)="^^",^PS(55,PSGP,5,DA,4)=PSGND4 W "...DONE!"
	;
DONE	;
	K %DT,DA,DIE,DIR,DR,FDSD,PSGAL,PSGALR,PSGDL,PSGDLS,PSGFD,PSGFOK,PSGND4,PSGOEE,PSGOER0,PSGOER1,PSGOER2,PSGOERDP,PSGOPR,PSGOSD,PSGPOSA,PSGPOSD,PSGPR,PSGPX,PSGRD,PSGSD,PSGTOL,PSGTOO,PSGUOW,PSGWLL,RF Q
	;
NEW	; get info, write record
	K ^TMP("PSJCOMR",$J)
	N DUOUT,PSGORD,TMPP,TMPO,PS55ACX,TMPDUZ,TMPOE,COMQUIT S TMPP=0 K PS55ACX M PS55ACX(55,"ACX",PSJCOM)=^PS(55,"ACX",PSJCOM)
	F  S TMPP=$O(PS55ACX(55,"ACX",PSJCOM,TMPP)) Q:'TMPP!$G(COMQUIT)  D
	. S TMPO=0 F  S TMPO=$O(PS55ACX(55,"ACX",PSJCOM,TMPP,TMPO)) Q:TMPO=""!$G(COMQUIT)  S PSGORD=TMPO D:PSGORD["U" NEWUD  I PSGORD["V" D NEWIV
	I $G(COMQUIT)!$G(DUOUT)  W !!,"By not verifying all the orders, none of the orders will be verified." D PAUSE^VALM1 Q
	I '$G(COMQUIT)&'$G(DUOUT) S TMPOE=0 F  S TMPOE=$O(^PS(55,"ACX",PSJCOM,TMPOE)) Q:TMPOE=""  S TMPO=0 F  S TMPO=$O(^PS(55,"ACX",PSJCOM,TMPOE,TMPO)) Q:'TMPO!$G(COMQUIT)  S PSGORD=TMPO D
	. K VSTRING S VSTRING=$G(^TMP("PSJCOMR",$J,PSJCOM,TMPO)) I PSGORD'=$P(VSTRING,"^",2) S COMQUIT=1 Q
	. S PSGP=$P(VSTRING,"^"),PSGDT=$P(VSTRING,"^",3),PSGOEPR=$P(VSTRING,"^",4),PSGOFD=$P(VSTRING,"^",5),PSGFD=$P(VSTRING,"^",6),PSJNOO=$P(VSTRING,"^",7),TMPDUZ=$P(VSTRING,"^",8)
	. D:PSGORD["U" FILEUD D:PSGORD["V" FILEIV
	K ^TMP("PSJCOMR",$J),VSTRING
	Q
NEWUD	N PSJABT,PSGDRG,PSJREN,X,XX,PSGORDP,UDSTRING S PSGDRG=$P($G(^PS(55,PSGP,5,+PSGORD,1,1,0)),"^"),PSJREN=1
	;D OC55
	Q:$D(PSGORQF)  ; quit if not to continue
	D NOW^%DTC S PSGDT=%,PSGND4=$G(^PS(55,PSGP,5,+PSGORD,4)) I '$P(PSJSYSP0,"^",3) D MARK Q
	S PSGWLL=$S('$P(PSJSYSW0,"^",4):0,1:+$G(^PS(55,PSGP,5.1))),PSGOEE="R" K PSGOEOS
	K ^PS(53.45,PSJSYSP,1),^(2) D MOVE(3,1),MOVE(1,2)
	D DATE^PSGOER0(PSGP,PSGORD,PSGDT) I '$D(PSGFOK(106)) D DONE,ABORT^PSGOEE S VALMBCK="R" Q
	W !!,"...updating order..." N PSGOEAV S PSGOEAV=+PSJSYSU,PSGOORD=PSGORD,PSGOER1=$G(^PS(55,PSGP,5,+PSGORD,.2)),PSGSI=$G(^(6)) W "."
	S PSGMR=$P(PSGOER0,"^",3),PSGSM=$P(PSGOER0,"^",5),PSGHSM=$P(PSGOER0,"^",6)
	S PSGMRN=$$ENMRN^PSGMI(PSGMR),PSGPDRGN=$$ENPDN^PSGMI(PSGPDRG),PSGDO=$P(PSGOER1,"^",2),PSGSCH=$P(PSGOER2,"^")
	S PSGS0Y=$P(PSGOER2,"^",5),PSGS0XT=$P(PSGOER2,"^",6),PSGNESD=PSGSD,PSGNEFD=PSGFD
	S:PSJPWD'=$P(PSGOER2,U,10) PSGS0Y=$$ENRNAT^PSGOU($P(PSGOER2,U,10),+PSJPWD,PSGSCH,PSGS0Y)
	S UDSTRING=PSGP_"^"_PSGORD_"^"_PSGDT_"^"_PSGOEPR_"^"_PSGOFD_"^"_PSGFD_"^"_PSJNOO F II=1:1:$L(UDSTRING,"^") I $P(UDSTRING,"^",II)="" K UDSTRING
	I '$D(UDSTRING) S COMQUIT=1 Q
	S:$G(DUZ) UDSTRING=UDSTRING_"^"_DUZ D TEMP(UDSTRING)
	Q
	;
FILEUD	;
	;Changed the reference to the type "O" for order numbers previously in v4.5
	N X,PSJORD,PSGOERDP,PSGOREAS,PSGRZERO S PSJORD=PSGORD K PSJPREX
	;Make sure Admin times for parent don't carry to children;BHW;PSJ*5*136
	S X=$$LS^PSSLOCK(PSGP,PSGORD)  S PSGRTWO=^PS(55,+$G(PSGP),5,+PSGORD,2) S PSGRZERO="^PS(55,"_PSGP_",5,"_+PSGORD_",0)",PSGOREAS=$P(@(PSGRZERO),"^",24) D
	. S (PSGAT,PSGS0Y)=$P(PSGRTWO,"^",5)
	. S $P(@PSGRZERO,"^",24)="R" D UPDREN^PSGOER(PSGORD,PSGDT,PSGOEPR,PSGOFD,PSJNOO,$G(TMPDUZ)),UPDRENOE^PSGOER(PSGP,PSGORD) S $P(@PSGRZERO,"^",24)=PSGOREAS
	I +$G(PSJSYSU)=3,$G(PSJCOM) D CMPLX2^PSJCOM1(PSGP,PSJCOM,PSGORD) I $G(PSGPXN) S PSJPREX=1
	W !!,"...updating order..." K DA S DA(1)=PSGP,DA=+PSGORD,PSGAL("C")=PSJSYSU*10+18000 D ^PSGAL5 W "."
	I '$G(PSGOERDP),$P(PSJSYSW0,"^",4) I $G(PSGFD),$G(PSGWLL),(PSGFD'<PSGWLL) S $P(^PS(55,PSGP,5.1),"^")=+PSGFD
	; ** This is where the Automated Dispensing Machine hook is called. Do NOT DELETE or change location **
	D RENEW^PSJADM
	; ** END of INTERFACE Hook **
	D UNL^PSSLOCK(PSGP,PSGORD)
	W ".DONE!" S VALMBCK="Q"
	Q
	;
MARK	;
	I $P(PSGND4,"^",15),$P(PSGND4,"^",16) W $C(7),!!?3,"...THIS ORDER IS ALREADY MARKED FOR RENEWAL!..." Q
	K DA S $P(PSGND4,"^",15,17)="1^"_DUZ_"^"_PSGDT,^PS(55,PSGP,5,+PSGORD,4)=PSGND4,PSGAL("C")=13180,DA(1)=PSGP,DA=+PSGORD W "." D ^PSGAL5
	I $D(PSJSYSO) S PSGORD=+PSGORD_"A",PSGPOSA="R",PSGPOSD=PSGDT D ENPOS^PSGVDS
	Q
MOVE(X,Y)	; Move comments/dispense drugs from 55 to 53.45.
	S Q=0 F  S Q=$O(^PS(55,PSGP,5,+PSGORD,X,Q)) Q:'Q  S ^PS(53.45,PSJSYSP,Y,Q,0)=$G(^(Q,0))
	S:Q ^PS(53.45,Y,0)="^53.450"_Y_"P^"_Q_U_Q
	Q
OC55	;* Order checks for Speed finish and regular finish
	N INTERVEN,PSJDDI,PSJIREQ,PSJRXREQ,PSJPDRG,PSJDD,PSJALLGY
	S Y=1,(PSJIREQ,PSJRXREQ,INTERVEN,X)=""
	F PSGDDI=0:0 S PSGDDI=$O(^PS(55,PSGP,5,+PSGORD,1,PSGDDI)) Q:'PSGDDI  D
	. S PSJDD=+$G(^PS(55,PSGP,5,+PSGORD,1,PSGDDI,0))
	. S PSJALLGY(PSJDD)=""
	K PSGORQF D ENDDC^PSGSICHK(PSGP,PSJDD)
	Q
	;
RIV	; Renew order.
	Q:'PSJCOM  N PSGORD,TMPP,TMPO S (TMPP,TMPO)=0 K PS55ACX M PS55ACX(55,"ACX",PSJCOM)=^PS(55,"ACX",PSJCOM)
	F  S TMPP=$O(PS55ACX(55,"ACX",PSJCOM,TMPP)) Q:'TMPP  S TMPO=0 F  S TMPO=$O(PS55ACX(55,"ACX",PSJCOM,TMPP,TMPO)) Q:TMPO=""  D
	. S PSGORD=TMPO D:PSGORD["U" NEWUD  D:PSGORD["V" NEWIV
	Q
NEWIV	;Renew complex IV orders
	N X,XX
	I P(17)="D",P(12) N ERR D RI W:$G(ERR)=1 $C(7),"  Order unchanged." Q:$G(ERR)<2
	K PSGORQF S PSIVRNFG=1 D ORDCHK^PSJLIFN K PSIVRNFG Q:$G(PSGORQF)  W !
	I $G(PSGORD)["V" S ON55=PSGORD S P("OLDON")=$P(^PS(55,DFN,"IV",+PSGORD,2),"^",5) S:'P("OLDON") P("OLDON")=ON55
	;
R1	N PSIVND0,PSIVND2,PSIVREAS,PSIVOFD,IVSTRING,P2,PSJBKDR S PSJBKDR=1
	S P("NEWON")=ON55,(PSIVOK,EDIT)="25^1",P2=P(2) S P(2)=$$DATE^PSJUTL2 D EDIT^PSIVEDT S P(2)=P2 I X="^" D RD Q
	S:+VAIN(4)'=$P($G(^PS(55,DFN,"IV",+P("OLDON"),2)),U,10) P(11)=$$ENRNAT^PSGOU($P($G(^PS(55,DFN,"IV",+P("OLDON"),2)),U,10),+VAIN(4),P(9),P(11))
	S PSIVCHG=2
	D OK G:X["N" R1 I X=U D RD Q
	S P(17)="A",P("RES")="R",P("FRES")="" D:'$D(PSJIVORF) ORPARM^PSIVOREN I PSJIVORF D  Q:'$D(P("NAT"))
	.D NATURE^PSIVOREN I '$D(P("NAT")) D RD S COMQUIT=1 Q
	.S ON=ON55 ;D SET^PSIVORFE
	S P(16)="",PSJORIFN="",PSIVACT=1,P("21FLG")="",PSIVOFD=$P($G(^PS(55,DFN,"IV",+PSGORD,0)),"^",3)
	S IVSTRING=DFN_"^"_ON55_"^"_$$DATE^PSJUTL2()_"^"_+$G(P(6))_"^"_PSIVOFD_"^"_P(3)_"^"_P("NAT") F II=1:1:$L(IVSTRING,"^") I $P(IVSTRING,"^",II)="" K IVSTRING
	I '$D(IVSTRING) S COMQUIT=1 Q
	S:$G(DUZ) IVSTRING=IVSTRING_"^"_DUZ D TEMP(IVSTRING)
	Q
	;
FILEIV	;
	N X,ON,ON55,PSJORD,P,PSIVTMP,PSIVZERO,OREAS
	S X=$$LS^PSSLOCK(DFN,+PSGORD_"V") S PSIVZERO="^PS(55,"_DFN_",""IV"","_+PSGORD_",0)" S PSIVTMP0=$G(@PSIVZERO) Q:'PSIVTMP0
	S PSIVTMP2="^PS(55,"_DFN_",""IV"","_+PSGORD_",2)",OREAS=$P(PSIVTMP2,"^",8),$P(@PSIVTMP2,"^",8)="R"
	F I=1:1:$L(PSIVTMP0,"^") S P(I)=$P(PSIVTMP0,"^",I)
	S (ON,ON55,PSJORD)=PSGORD,P(3)=PSGFD,P(6)=PSGOEPR,P("NAT")=PSJNOO,PSIVOFD=PSGOFD D RUPDATE^PSIVOREN(DFN,ON55,P(2))
	Q:'PSJIVORF
	D EN1^PSJHL2(DFN,"SN",+ON55_"V","ORDER RENEWED")
	S OD=P(2) D EN^PSIVORE
	D VF1^PSJLIACT("","",0),UNL^PSSLOCK(DFN,+ON55_"V") S $P(@PSIVTMP2,"^",8)=OREAS
	D ENLBL^PSIVOPT(2,DUZ,DFN,3,+ON55,"R")
	Q
	;
TEMP(VARS)	;
	Q:'PSJCOM  S ^TMP("PSJCOMR",$J,PSJCOM,PSGORD)=VARS
	Q
	;
RD	; Delete for renew.
	D DEL55^PSIVORE2 S (ON55,P("PON"))=P("OLDON") D GT55^PSIVORFB
	Q
	;
OK	;Print example label, run order through checker, ask if it is ok.
	S P16=0,PSIVEXAM=1,(PSIVNOL,PSIVCT)=1 D GTOT^PSIVUTL(P(4)) I ($G(P("PD"))="") D GTPD^PSIVORE2
	D ^PSIVCHK I $D(DUOUT) S X="^" Q
	I ERR=1 S X="N" Q
	W ! D ^PSIVORLB K PSIVEXAM S Y=P(2) W !,"Start date: " X ^DD("DD") W $P(Y,"@")," ",$P(Y,"@",2),?30," Stop date: " S Y=P(3) X ^DD("DD") W $P(Y,"@")," ",$P(Y,"@",2),!
	D EFDIV^PSJUTL($G(ZZND))
	S X="Is this O.K.: ^"_$S(ERR:"N",1:"Y")_"^^NO"_$S(ERR'=1:",YES",1:"") D ENQ^PSIV I X["?" S HELP="OK" D ^PSIVHLP G OK
	Q
	;
RI	; Reinstate Auto-DC'ed order.
	N DA,DIE,DIR,DIU,DR,PSIVACT,PSIVALT,PSIVALCK,PSIVREA W !!,$C(7),"This order has been Auto-DC'ed."
	S DIR(0)="Y",DIR("A")="Reinstate this order" D ^DIR K DIR I 'Y S ERR=1 Q
	D NOW^%DTC I %>$P($G(^PS(55,DFN,"IV",+ON55,2)),U,7) D
	.K DIR S ERR=1,DIR(0)="Y",DIR("A",1)="The original stop date of this order has past.",DIR("A")="Do you wish to renew this order" D ^DIR K DIR S ERR=$S(Y:2,1:1)
	Q:$G(ERR)  S X=$G(^VA(200,+P(6),"PS")) I $S('X:1,'$P(X,U,4):0,DT<$P(X,U,4):0,1:1) S ERR=1
	I $G(ERR) W !!,$C(7),"This order's provider is no longer valid. Please enter a valid provider." S (EDIT,PSIVOK)=1 D EDIT^PSIVEDT I $G(DONE) W $C(7),"Order unchanged." S ERR=1 Q
	N PSGALO S PSGALO=18530 D ENARI^PSIVOPT(DFN,ON,DUZ,PSGALO)
	Q
	;
ABORT	; No changes
	W !!,$C(7),"No changes made to this order." D PAUSE^VALM1 K PSGOEEF S PSGOEEF=0
	Q
