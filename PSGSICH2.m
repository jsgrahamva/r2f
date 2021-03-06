PSGSICH2	;BIR/JCH-PROVIDER & PHARMACY OVERRIDE UTILITIES 2; 01/25/11 1:02pm
	;;5.0;INPATIENT MEDICATIONS;**254**;16 DEC 97;Build 84
	;
	; Reference to OCCNT^OROCPI1 is supported by DBIA #5637
	;
INTROUT(INTER,PSJIDTM,PSJORDER,OUTARRAY)	; Build array of detailed intervention information
	N PSJFLDE,PSJFLDI,WPLINE
	S PSJFLDI=0 F  S PSJFLDI=$O(^UTILITY("DIQ1",$J,9009032.4,INTER,PSJFLDI)) Q:'PSJFLDI  D
	.D FIELD^DID(9009032.4,PSJFLDI,"","LABEL","PSJFLDE") S PSJFLDE=PSJFLDE("LABEL") I PSJFLDE]"" D
	..N PC,TMPFLDE,TMPPC F PC=1:1:$L(PSJFLDE," ") S TMPPC=$$ENUL^PSGMI($P(PSJFLDE," ",PC)),$E(TMPPC)=$$ENLU^PSGMI($E(TMPPC)) S TMPFLDE=$G(TMPFLDE)_$S($G(TMPFLDE)]"":" ",1:"")_TMPPC
	..S PSJFLDE=TMPFLDE
	.I PSJFLDI<1000 N DATA S DATA=$G(^UTILITY("DIQ1",$J,9009032.4,INTER,PSJFLDI,"E")) Q:DATA=""  D  Q
	..I PSJFLDE["Intervention Date",$G(PSJIDTM) D  Q
	...N PSJIDTMP S PSJIDTMP=$P($TR($$FMTE^XLFDT(PSJIDTM,2),"@","  "),":",1,2) S $P(PSJIDTMP,"/")=$S($L($P(PSJIDTMP,"/"))=1:0,1:"")_+$P(PSJIDTMP,"/") S $P(PSJIDTMP,"/",2)=$S($L($P(PSJIDTMP,"/",2))=1:0,1:"")_+$P(PSJIDTMP,"/",2)
	...S OUTARRAY(DFN,PSJORDER,INTER,PSJFLDI)=PSJFLDE_"/Time: "_PSJIDTMP Q
	..S OUTARRAY(DFN,PSJORDER,INTER,PSJFLDI)=PSJFLDE_": "_DATA
	.I PSJFLDI>1000 S WPLINE=0 F  S WPLINE=$O(^UTILITY("DIQ1",$J,9009032.4,INTER,PSJFLDI,WPLINE)) Q:'WPLINE  D
	..S OUTARRAY(DFN,PSJORDER,INTER,PSJFLDI,WPLINE)=^UTILITY("DIQ1",$J,9009032.4,INTER,PSJFLDI,WPLINE)
	..I WPLINE=1 S OUTARRAY(DFN,PSJORDER,INTER,PSJFLDI,0)=PSJFLDE_": "
	Q
INTRDICO(INTER)	; Retrieve Intervention data from APSP Intervention (#9009032.4) file
	N DIQ K ^UTILITY("DIQ1",$J)
	S DIC="^APSPQA(32.4,",DR=".01:1600",DA=INTER,DIQ(0)="E" D EN^DIQ1
	Q
DSPINT(OUTARRAY,PSGORD)	; 
	Q:$G(PSJQUITD)
	N PSJIOL,PSJBANNR,PSJINDEN,FLD,II,JJ,PSJL,PSJOCINT,PSJOCTXT,WP
	S PSJIOSL=$S($G(IOSL):IOSL,1:PSJIOSL),PSJINDEN=8
	D FULL^VALM1 W @IOF
	S PSJCOL=1,ILCNT=0,PSJBANNR=" Pharmacist Interventions for this order" S PSJBANNR=$S($G(PSJOCHIS):"Historical",1:"Current")_PSJBANNR
	W ! K LINE S $P(LINE,"=",76)="="
	S PSJL="** "_PSJBANNR_" **"
	I '$D(OUTARRAY(PSGP,PSGORD)) D BANNER^PSGSICH1(PSJL,PSJINDEN) W !,"No Pharmacist Interventions to display",!! S ILCNT=$G(ILCNT)+3 Q
	S PSJL="" S PSJOCINT=0 F  S PSJOCINT=$O(OUTARRAY(PSGP,PSGORD,PSJOCINT)) Q:'PSJOCINT!$G(PSJQUITD)  D
	.D BANNER^PSGSICH1(PSJBANNR,PSJINDEN)
	.I $D(PSJOVRAR("B",PSJOCINT_"I")) N TMPDT S TMPDT=$G(PSJOVRAR("B",PSJOCINT_"I")) K PSJOVRAR(PSGP,PSGORD,TMPDT,PSJOCINT_"I")
	.I PSJL]"" W PSJL S PSJL="",PSJCOL=1
	.S FLD=0 F II=1:1 S FLD=$O(OUTARRAY(PSGP,PSGORD,PSJOCINT,FLD)) Q:'FLD!$G(PSJQUITD)  D
	..I FLD<1000 D  Q  ; Store first column text left over
	...S PSJOCTXT=OUTARRAY(PSGP,PSGORD,PSJOCINT,FLD) I PSJOCTXT["INTERVENTION DATE"!(PSJOCTXT["Intervention Date") S PSJL=PSJOCTXT W !!,PSJL S ILCNT=$G(ILCNT)+2,PSJL="" Q
	...I PSJOCTXT["PATIENT:"!(PSJOCTXT["Patient") Q
	...I ($L(PSJL)+$L(PSJOCTXT))>60 W !,PSJL S PSJL=" "_PSJOCTXT S ILCNT=$G(ILCNT)+1,PSJCOL=2 Q
	...I $L(PSJL)=0 S PSJL=" "_PSJOCTXT,PSJCOL=2 Q
	...S PSJL=$$SETSTR^VALM1(OUTARRAY(PSGP,PSGORD,PSJOCINT,FLD),PSJL,45,34) W !,PSJL S PSJL="",ILCNT=$G(ILCNT)+1,PSJCOL=1
	..I $L(PSJL) W "   ",PSJL S PSJL=""
	..I FLD>1000 S PSJL="" S WP="" F JJ=1:1 S WP=$O(OUTARRAY(PSGP,PSGORD,PSJOCINT,FLD,WP)) Q:WP=""  D
	...S PSJL=" "_OUTARRAY(PSGP,PSGORD,PSJOCINT,FLD,WP) S:JJ>1 PSJL=" "_PSJL W !,PSJL S PSJL="" S ILCNT=$G(ILCNT)+1
	.I PSJL]"" W !,PSJL S PSJL="" S ILCNT=$G(ILCNT)+1
	.W ! S ILCNT=$G(ILCNT)+1 I $G(ILCNT)<($G(PSJIOSL)) S JJ=(($G(PSJIOSL)-2)-$G(ILCNT)) F II=1:1:JJ W ! S ILCNT=$G(ILCNT)+1
	.I $G(ILCNT)>($G(PSJIOSL)-3) D HLD^PSGSICH S ILCNT=0
	I $G(PSJL)]"" W PSJL S PSJL=""
	I $G(ILCNT)>1,($G(ILCNT)<($G(PSJIOSL))) S JJ=($G(PSJIOSL)-2)-$G(ILCNT) F II=1:1:JJ W ! S ILCNT=$G(ILCNT)+1
	I $G(ILCNT)>0 D HLD^PSGSICH S ILCNT=0
	K PSJCOL
	Q
	;
GETOORDS(DFN,PSGORCD,PSJORDS2)	; Get array of all historical CPRS orders associated with PSGORCD
	N PSJDONED,PSJRNFLG,PSJRN,PSJOERND,PSJOOERR,PSJNEWOI,PSJOLDOI S PSJDONED=0,PSJRNFLG=0 K PSJORDS2
	Q:'$G(DFN)!'$G(PSGORCD)
	S PSJPRVHD=$S(PSGORCD["V":$G(^PS(55,DFN,"IV",+PSGORCD,0)),PSGORCD["U":$G(^PS(55,DFN,5,+PSGORCD,0)),PSGORCD["P":$G(^PS(53.1,+PSGORCD,0)),1:"")
	S PSJORDT=$S(PSGORCD["V":$P($G(^PS(55,DFN,"IV",+PSGORCD,2)),"^"),1:$P(PSJPRVHD,"^",14))
	S PSJOOERR=$P(PSJPRVHD,"^",21) I PSJOOERR I '$D(PSJORDS2("B",+PSJOOERR_"C")) S PSJORDS2(+DFN,PSGORCD,+PSJORDT,+PSJOOERR_"C")=PSGORCD,PSJORDS2("B",+PSJOOERR_"C")=PSJORDT
	I PSGORCD["U" S PSJINT=0 F  S PSJINT=$O(^PS(55,DFN,5,+PSGORCD,10,PSJINT)) Q:'PSJINT  S PSJINTD=$G(^(PSJINT,0)) I PSJINTD,$P(PSJINTD,"^",2),'$D(PSJORDS2("B",+PSJINTD_"I")) D
	.S PSJORDS2(DFN,PSGORCD,+$P(PSJINTD,"^",2),+PSJINTD_"I")=PSGORCD,PSJORDS2("B",+PSJINTD_"I")=$P(PSJINTD,"^",2)
	I PSGORCD["P" S PSJINT=0 F  S PSJINT=$O(^PS(53.1,+PSGORCD,11,PSJINT)) Q:'PSJINT  S PSJINTD=$G(^(PSJINT,0)) I PSJINTD,$P(PSJINTD,"^",2),'$D(PSJORDS2("B",+PSJINTD_"I")) D
	.S PSJORDS2(DFN,PSGORCD,+$P(PSJINTD,"^",2),+PSJINTD_"I")=PSGORCD,PSJORDS2("B",+PSJINTD_"I")=$P(PSJINTD,"^",2)
	I PSGORCD["V" S PSJINT=0 F  S PSJINT=$O(^PS(55,DFN,"IV",+PSGORCD,8,PSJINT)) Q:'PSJINT  S PSJINTD=$G(^(PSJINT,0)) I PSJINTD,$P(PSJINTD,"^",2),'$D(PSJORDS2("B",+PSJINTD_"I")) D
	.S PSJORDS2(DFN,PSGORCD,+$P(PSJINTD,"^",2),+PSJINTD_"I")=PSGORCD,PSJORDS2("B",+PSJINTD_"I")=$P(PSJINTD,"^",2)
	S PSJPRV=PSGORCD I PSJPRV F  Q:'PSJPRV!$G(PSJDONED)  S PSJPRV=$S($G(PSJPRV)["V":$P($G(^PS(55,DFN,"IV",+PSJPRV,2)),"^",5),$G(PSJPRV)["U":$P($G(^PS(55,DFN,5,+PSJPRV,0)),"^",25),$G(PSJPRV)["P":$P($G(^PS(53.1,+PSJPRV,0)),"^",25),1:"") D
	.I PSJPRV=PSGORCD S PSJDONED=1 Q
	.S PSJPRVHD=$S(PSJPRV["V":$G(^PS(55,DFN,"IV",+PSJPRV,0)),PSJPRV["U":$G(^PS(55,DFN,5,+PSJPRV,0)),PSJPRV["P":$G(^PS(53.1,+PSJPRV,0)),1:"")
	.S PSJOOERR=$P(PSJPRVHD,"^",21) I 'PSJOOERR S PSJDONED=1 Q
	.S PSJORDT=$S(PSJPRV["V":$P($G(^PS(55,DFN,"IV",+PSJPRV,2)),"^"),1:$P(PSJPRVHD,"^",14)) I 'PSJORDT S PSJDONED=1 Q
	.I $P(PSJOOERR,";",2)=1,$D(PSJORDS2("B",+PSJOOERR_"C")) K PSJORDS2(DFN,PSGORCD,$G(PSJORDS2("B",+PSJOOERR_"C"))),PSJORDS2("B",+PSJOOERR_"C") D
	..S PSJORDS2(DFN,PSGORCD,+PSJORDT,+PSJOOERR_"C")=PSJPRV,PSJORDS2("B",+PSJOOERR_"C")=PSJORDT
	.I '$D(PSJORDS2("B",+PSJOOERR_"C")) S PSJORDS2(DFN,PSGORCD,+PSJORDT,+PSJOOERR_"C")=PSJPRV,PSJORDS2("B",+PSJOOERR_"C")=PSJORDT
	.I PSJPRV["V" S PSJINT=0 F  S PSJINT=$O(^PS(55,DFN,"IV",+PSJPRV,8,PSJINT)) Q:'PSJINT  S PSJINTD=$G(^(PSJINT,0)) I PSJINTD,$P(PSJINTD,"^",2),'$D(PSJORDS2("B",+PSJINTD_"I")) D
	..S PSJORDS2(DFN,PSGORCD,+$P(PSJINTD,"^",2),+PSJINTD_"I")=PSJPRV,PSJORDS2("B",+PSJINTD_"I")=$P(PSJINTD,"^",2)
	.I PSJPRV["U" S PSJINT=0 F  S PSJINT=$O(^PS(55,DFN,5,+PSJPRV,10,PSJINT)) Q:'PSJINT  S PSJINTD=$G(^(PSJINT,0)) I PSJINTD,$P(PSJINTD,"^",2),'$D(PSJORDS2("B",+PSJINTD_"I")) D
	..S PSJORDS2(DFN,PSGORCD,+$P(PSJINTD,"^",2),+PSJINTD_"I")=PSJPRV,PSJORDS2("B",+PSJINTD_"I")=$P(PSJINTD,"^",2)
	.I PSJPRV["P" S PSJINT=0 F  S PSJINT=$O(^PS(53.1,+PSJPRV,11,PSJINT)) Q:'PSJINT  S PSJINTD=$G(^(PSJINT,0)) I PSJINTD,$P(PSJINTD,"^",2),'$D(PSJORDS2("B",+PSJINTD_"I")) D
	..S PSJORDS2(DFN,PSGORCD,+$P(PSJINTD,"^",2),+PSJINTD_"I")=PSJPRV,PSJORDS2("B",+PSJINTD_"I")=$P(PSJINTD,"^",2)
	.D GETRNW(DFN,PSGORCD,PSJPRV,.PSJORDS2)
	D GETRNW(DFN,PSGORCD,PSGORCD,.PSJORDS2)
	K PSJIOR,PSJIDT,PSJO2,PSJINT,PSJINTD,PSJPRV,PSJPRVHD,PSJORDT
	Q
GETRNW(DFN,PSJCUROR,PSJRNORD,PSJORDS2)	; Get CPRS orders from all renewals for order PSJRNORD
	I $D(^PS(55,DFN,5,+PSJRNORD,14,1,0)),PSJRNORD["U",'PSJRNFLG S PSJRNFLG=1 D
	.S PSJRN=0 F  S PSJRN=$O(^PS(55,DFN,5,+PSJRNORD,14,PSJRN)) Q:'PSJRN  S PSJOERND=$G(^(PSJRN,0)),PSJOOERR=$P(PSJOERND,"^",5),PSJORDT=$P(PSJOERND,"^") D
	..Q:'PSJOOERR  S PSJORDS2(DFN,PSJCUROR,+PSJORDT,+PSJOOERR_"C")=PSJRNORD,PSJORDS2("B",+PSJOOERR_"C")=PSJORDT
	I $D(^PS(55,DFN,"IV",+PSJRNORD,14,1,0)),PSJRNORD["V",'PSJRNFLG S PSJRNFLG=1 D
	.S PSJRN=0 F  S PSJRN=$O(^PS(55,DFN,"IV",+PSJRNORD,14,PSJRN)) Q:'PSJRN  S PSJOERND=$G(^(PSJRN,0)),PSJOOERR=$P(PSJOERND,"^",5),PSJORDT=$P(PSJOERND,"^") D
	..Q:'PSJOOERR  S PSJORDS2(DFN,PSGORCD,+PSJORDT,+PSJOOERR_"C")=PSJRNORD,PSJORDS2("B",+PSJOOERR_"C")=PSJORDT
	Q
OVRDISF(PSGP,PSGORD,CODE)	; For Pending Orders, only display Provider Overrides and Pharmacy Interventions if new, incoming Provider Override to display
	N TMPOFLG,KK,PSJOVRAR,PSJORFOR Q:PSGORD'["P"  S PSJORFOR=+$P($G(^PS(53.1,+PSGORD,0)),"^",21)
	D GETPROVR^PSGSICH1(PSGP,PSGORD,.PSJOVRAR,+PSJORFOR) F KK=1:1:2 I $D(PSJOVRAR("PROVR",PSGP,+PSGORD,KK)) S TMPOFLG=1
	K PSJOVRAR I $G(TMPOFLG) D OVRDISP(DFN,PSGORD,2)
	Q
OVRDISP(PSGP,PSGORD,CODE)	; Display ALL Provider Overrides and Pharmacy Interventions associated with specific order
	K OUTARRAY,PSJOCHIS,PSJQUITD,PSJHISTF,TMPKILAR
	N LINE,ILCNT,PSJOVRAR,PSJCUROV,PSJCURIN,PSJTMPX,PSJTMPI,PSJINTAR,PSJINTER,PSJOVDON,PSJDONED,PSJINDEN,PSJBANNR,PSJHISTF,PSJHISTO,PSJIOSL,X,Y,DR,DIR,DIE,DIC,PSJOLDOR,PSJOLDOI,PSJNEWOI,PSJOROIC
	S:'$G(PSGORD) PSGORD=0 Q:'$G(PSGP)!('$G(PSGORD)&'$D(^TMP("PSJINTER",$J)))  S PSJOVDON=0,PSJIOSL=$S($G(IOSL):IOSL,1:24)
	S PSJBANNR="Provider Overrides for this order" S PSJBANNR=$S($G(PSJOCHIS):"Historical ",1:"Current ")_PSJBANNR
	S $P(LINE,"=",76)="=",PSJINDEN=8
	I $G(PSGORD) D GETOORDS(PSGP,PSGORD,.PSJOVRAR) S PSJOROIC=$$OROICHK^PSGSICH(PSGP,PSGORD,.PSJOVRAR)
	I $G(CODE)=2!($G(CODE)=3) D FULL^VALM1 W @IOF S PSJTMPX="" F  S PSJTMPX=$O(PSJOVRAR(PSGP,PSGORD,PSJTMPX),-1) Q:'PSJTMPX!$G(PSJOVDON)  D
	.S PSJCUROV="" F  S PSJCUROV=$O(PSJOVRAR(PSGP,PSGORD,PSJTMPX,PSJCUROV),-1) Q:'PSJCUROV!$G(PSJOVDON)  D
	..I PSJCUROV'>$G(PSJOROIC) S PSJOVDON=-1 Q
	..Q:(PSJCUROV)'["C"  Q:'$$OCCNT^OROCAPI1(+PSJCUROV)
	..N PSJTMPOO S PSJTMPOO=$G(PSJOVRAR(PSGP,PSGORD,PSJTMPX,PSJCUROV))
	..D GETPROVR^PSGSICH1(PSGP,PSJTMPOO,.OUTARRAY,+PSJCUROV)
	..I $D(OUTARRAY)>1 W @IOF D DSPROVR^PSGSICH1(PSGP,PSJTMPOO,.OUTARRAY) K OUTARRAY S PSJOVDON=1 K PSJOVRAR("B",PSJCUROV)
	I $G(PSJOVDON)<1 W !!,LINE,!?PSJINDEN,"** ",PSJBANNR," **",!,LINE W !!,"No Provider Overrides to display",!!! D HLD^PSGSICH
	K OUTARRAY S OUTARRAY="" I $G(CODE)=2!$G(PSJQUITD) K PSJDONED Q
	I $G(PSGORD) D INTRDIC^PSGSICH1(PSGP,PSGORD,.OUTARRAY,1)
	; New intervention to display, not yet attached to order?
	I $D(^TMP("PSJINTER",$J)) D
	.N I2 S I2="" F  S I2=$O(^TMP("PSJINTER",$J,I2)) Q:'I2  D ONEINTER^PSGSICH(+I2,$G(PSGORD),$G(PSGDT),.OUTARRAY)
	I '$D(OUTARRAY(PSGP)) D
	.S PSJBANNR="Pharmacist Interventions for this order" S PSJBANNR=$S($G(PSJOCHIS):"Historical ",1:"Current ")_PSJBANNR
	.W !,LINE,!?PSJINDEN,"** "_PSJBANNR_" **",!,LINE,!!,"No Pharmacist Interventions to display",!! F KK=1:1:($G(PSJIOSL)-10) W !
	.D HLD^PSGSICH
	I $D(OUTARRAY)>1 D DSPINT(.OUTARRAY,$S($G(PSGORD):PSGORD,1:0))
	S PSJL="" W !,PSJL
	S (PSJHISTF,PSJHISTO)="" F  S PSJHISTO=$O(PSJOVRAR("B",PSJHISTO)) Q:PSJHISTO=""!$G(PSJHISTF)  D
	.N PSJOCDT S PSJOCDT=$G(PSJOVRAR("B",PSJHISTO)) Q:'PSJOCDT  Q:'$D(PSJOVRAR(PSGP,$G(PSGORD),PSJOCDT,PSJHISTO))
	.I PSJHISTO["I" S PSJHISTF=1 Q
	.I PSJHISTF["C" K TMPOVR S TMPOVR="" D GETPROVR^PSGSICH1(PSGP,PSGORD,.TMPOVR,+PSJHISTO) S PSJHISTF=$D(TMPOVR)>1 K TMPOVR
	I $G(PSJHISTF) I $$HISTHLD() D FULL^VALM1 W @IOF D OVRHIST(.PSJOVRAR,PSGORD)
	K OUTARRAY,PSJOVRAR,PSJOCHIS,PSJDONED,PSJHIST
	Q
OVRHIST(PSJOAR,PSGORCD)	; History of overrides/interventions using hidden action
	N PSJO1,PSJO2,PSJO3,PSJOERR,PSJOCHIS,FIRST,PSJIDT,PSJIOR,PSJIOSL S PSJOCHIS=1,FIRST=1,PSJIOSL=$S($G(IOSL):IOSL,1:24)
	S PSJO1="" F  S PSJO1=$O(PSJOAR(PSGP,PSGORCD,PSJO1),-1) Q:PSJO1=""  D
	.S PSJO2="" F  S PSJO2=$O(PSJOAR(PSGP,PSGORCD,PSJO1,PSJO2),-1) Q:PSJO2=""  D
	..Q:'$D(PSJOAR("B",PSJO2))  ; This is the same as the 'current' provider override (multiple Inpatient orders can point to same CPRS order #)
	..K PSJTMPAR S PSJTMPAR="" I PSJO2["C" S PSJO3=$G(PSJOAR(PSGP,PSGORCD,PSJO1,PSJO2)) I PSJO3 D  Q
	...Q:'$D(PSJOAR("B",PSJO2))
	...D GETPROVR^PSGSICH1(PSGP,PSJO3,.PSJTMPAR,PSJO2) I $D(PSJTMPAR)>1 D DSPROVR^PSGSICH1(PSGP,PSJO3,.PSJTMPAR)
	...K PSJOAR("B",PSJO2)
	..K PSJTMPAR S PSJTMPAR="" I PSJO2["I" S PSJO3=$G(PSJOAR(PSGP,PSGORCD,PSJO1,PSJO2)) I PSJO3 D  Q
	...Q:'$D(PSJOAR("B",PSJO2))
	...D ONEINTER^PSGSICH(PSJO2,PSJO3,PSJO1,.PSJTMPAR)
	...I $D(PSJTMPAR)>1 D FULL^VALM1 W @IOF D DSPINT(.PSJTMPAR,PSJO3)
	...K PSJOAR("B",PSJO2)
	K PSJTMPAR,PSJOCHIS,PSJQUITD,PSJO1,PSJO2,PSJO3
	Q
HISTHLD()	;
	K DIR S DIR(0)="E",DIR("A")="View Historical Overrides/Interventions for this order (Y/N)",DIR("B")="Y",DIR(0)="Y" D ^DIR
	Q Y
