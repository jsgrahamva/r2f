SCRPW27	;RENO/KEITH - ACRP Ad Hoc Report (cont.) ;03 Aug 98  9:06 PM
	;;5.3;Scheduling;**144,593**;AUG 13, 1993;Build 13
PRT	;Print ACRP Ad Hoc Report
	D:$E(IOST)="C" DISP0^SCRPW23 S SDOUT=0 G:$P(SDPAR("F",6),U)="F" PFT G PDF^SCRPW28
	;
HIN	;Header initialization
	D NOW^%DTC S SDHIN=1,Y=% X ^DD("DD") S SDPNOW=$P(Y,":",1,2),SDPAGE=1,SDLINE="",$P(SDLINE,"-",(IOM+1))="",SDPBDT=$P($G(SDPAR("L",1)),U,2),SDPEDT=$P($G(SDPAR("L",2)),U,2),SDTITLX=$P($G(SDPAR("O",2)),U)
	Q
	;
PFT	;Print as formatted text
	S SDCOL=$S(SDF(2):0,IOM=80:3,1:29) F SDR="RPAR","RPRT","RDET" D @SDR Q:SDOUT
	I $E(IOST)="C",'SDOUT D  N DIR S DIR(0)="E" D ^DIR
	.F  Q:$Y>(IOSL-2)  W !
	.Q
	G EXIT
	;
PPAR	;Print parameters only
	D RPAR K:$D(ZTQUEUED) SDPNOW,SDPAGE,SDLINE,SDPBDT,SDPEDT,SDTITLX Q
	;
RPAR	;Print report parameters
	D:$E(IOST)'="C" HDR^SCRPW29("Report Parameters Selected") Q:SDOUT  D PLIST^SCRPW22((IOM-80\2),$S($E(IOST)="C":15,1:(IOSL-10))) Q
	;
RPRT	;Print formatted report
	W @IOF N DX,DY S (DX,DY)=0 X SDXY
	S SDPAGE=1,SDS1="" D HDR^SCRPW29("Report Summary") Q:SDOUT  I '$D(^TMP("SCRPW",$J,"RPT",1)) S SDX="No data found within selected parameters." W !!?(IOM-$L(SDX)\2),SDX S SDOUT=1 Q
	D HD1^SCRPW29 S SDORDV=""
	F  S SDORDV=$O(^TMP("SCRPW",$J,"MASTER",SDORDV),$S(SDORD="ALP":1,1:-1)) Q:SDORDV=""!SDOUT  D RPRT0
	Q:SDOUT  D RPRT1("TOT",1,1) Q
	;
RPRT0	S SDS1="" F  S SDS1=$O(^TMP("SCRPW",$J,"MASTER",SDORDV,SDS1)) Q:SDS1=""!SDOUT  S SDS2="" F  S SDS2=$O(^TMP("SCRPW",$J,"MASTER",SDORDV,SDS1,SDS2)) Q:SDS2=""!SDOUT  D RPRT1("RPT",SDS1,SDS2)
	Q
	;
RPRT1(SDRPT,SDS1,SDS2)	N DIWL,DIWF,SDL2 S DIWL=1 S DIWF="C42|"
	K SDX S SDX=$S(SDRPT="TOT":"REPORT TOTAL:",$G(SDPAR("P",1,6))="D":SDS2,1:SDS1)
	S SDX(0)=+$G(^TMP("SCRPW",$J,SDRPT,1,SDS1,SDS2,"ENC")),SDX(1)=+$G(^TMP("SCRPW",$J,SDRPT,1,SDS1,SDS2,"VIS")),SDX(2)=+$G(^TMP("SCRPW",$J,SDRPT,1,SDS1,SDS2,"UNI"))
	I SDCOL=0 S SDX(3)=+$G(^TMP("SCRPW",$J,SDRPT,2,SDS1,SDS2,"ENC")),SDX(4)=+$G(^TMP("SCRPW",$J,SDRPT,2,SDS1,SDS2,"VIS")),SDX(5)=+$G(^TMP("SCRPW",$J,SDRPT,2,SDS1,SDS2,"UNI"))
	I SDCOL=0 F SDI=6,7,8 D CALC(SDI)
	D:$Y>(IOSL-6) HDR^SCRPW29("Report Summary"),HD1^SCRPW29 Q:SDOUT
	I SDRPT="TOT" W !?(SDCOL),"==========================================  ========  ========  ========  " W:SDCOL=0 "========  ========  ========  ========  ========  ========"
	K ^UTILITY($J,"W") S X=SDX D ^DIWP
	F SDL2=1:1:^UTILITY($J,"W",DIWL) W !?(SDCOL),$E(^UTILITY($J,"W",DIWL,SDL2,0),1,42)
	S SDI="" F  S SDI=$O(SDX(SDI)) Q:SDI=""!SDOUT  W ?(SDCOL+44+(10*SDI)),$S(SDX(SDI)="N/A":$J(SDX(SDI),8),1:$J(SDX(SDI),8,$S(SDI<6:0,SDX(SDI)'<100000:0,SDX(SDI)'<10000:1,1:2)))
	Q
	;
CALC(SDI)	;Calculate % change
	S SDX(SDI)=$S(SDX(SDI-3)<1:"N/A",1:SDX(SDI-6)-SDX(SDI-3)*100/SDX(SDI-3))
	;
RDET	Q:SDOUT!(SDF(1)="S")  S SDS1="" F  S SDS1=$O(^TMP("SCRPW",$J,"RPT",1,SDS1)) Q:SDOUT!(SDS1="")  S SDS2="" F  S SDS2=$O(^TMP("SCRPW",$J,"RPT",1,SDS1,SDS2)) Q:SDOUT!(SDS2="")  D RDET1
	Q
	;
RDET1	S SDENC=^TMP("SCRPW",$J,"RPT",1,SDS1,SDS2,"ENC"),SDVIS=^TMP("SCRPW",$J,"RPT",1,SDS1,SDS2,"VIS"),SDUNI=^TMP("SCRPW",$J,"RPT",1,SDS1,SDS2,"UNI")
	S SDPTX(1)="Detail of "_$P(SDPAR("P",1,1),U,2)_": "_$S($G(SDPAR("P",1,6))="D":SDS2,1:SDS1),SDPTX(2)="Encounters: "_SDENC_"    Visits: "_SDVIS_"    Uniques: "_SDUNI D HDR^SCRPW29("Report Detail"),HD2^SCRPW29 Q:SDOUT
	D:"EB"[SDF(3) DPTL Q:SDOUT  D:"DB"[SDF(3) DDXP Q
	;
DSV(SDPER)	;Encrypt detail sort values
	N SDX S SDX=$G(^TMP("SCRPW",$J,"DSV",$P(SDPER,U,2),$P(SDPER,U))) Q:SDX SDX
	S (SDX,^TMP("SCRPW",$J,"DSV",0))=$G(^TMP("SCRPW",$J,"DSV",0))+1
	S ^TMP("SCRPW",$J,"DSV",$P(SDPER,U,2),$P(SDPER,U))=SDX Q SDX
	;
DPTL	;Detail patient list
	N SDDSV S SDDSV=$$DSV(SDS2_"^"_SDS1)
	S SDCOL=$S($D(SDPAR("PF")):0,IOM=80:0,1:26) D DPHD^SCRPW29
	S SDPNAM="" F  S SDPNAM=$O(^TMP("SCRPW",$J,"DET",SDDSV,SDPNAM)) Q:SDOUT!(SDPNAM="")  S DFN=0 F  S DFN=$O(^TMP("SCRPW",$J,"DET",SDDSV,SDPNAM,DFN)) Q:SDOUT!'DFN  D DPTL1
	Q
	;
DPTL1	S SDI=0 I SDF(4)="U" D:$Y>(IOSL-6) HDR^SCRPW29("Report Detail"),HD2^SCRPW29,DPHD^SCRPW29 Q:SDOUT  W !?(SDCOL+19),SDPNAM,?(SDCOL+51),$P($G(^DPT(DFN,0)),U,9) D APFP^SCRPW29 S SDI=SDI+1 Q
	S SDT=0 F  S SDT=$O(^TMP("SCRPW",$J,"DET",SDDSV,SDPNAM,DFN,SDT)) Q:SDOUT!'SDT  D DPTL2
	Q
	;
DPTL2	I SDF(4)="V" D:$Y>(IOSL-6) HDR^SCRPW29("Report Detail"),HD2^SCRPW29,DPHD^SCRPW29 Q:SDOUT  W !?(SDCOL+13),SDPNAM,?(SDCOL+45),$P($G(^DPT(DFN,0)),U,9) S Y=SDT X ^DD("DD") W ?(SDCOL+57),Y D APFP^SCRPW29 S SDI=SDI+1 Q
	S SDDT=0 F  S SDDT=$O(^TMP("SCRPW",$J,"DET",SDDSV,SDPNAM,DFN,SDT,SDDT)) Q:SDOUT!'SDDT  S SDOE=0 F  S SDOE=$O(^TMP("SCRPW",$J,"DET",SDDSV,SDPNAM,DFN,SDT,SDDT,SDOE)) Q:SDOUT!'SDOE  D DPTL3
	Q
	;
DPTL3	D:$Y>(IOSL-6) HDR^SCRPW29("Report Detail"),HD2^SCRPW29,DPHD^SCRPW29 Q:SDOUT
	S SDCL=^TMP("SCRPW",$J,"DET",SDDSV,SDPNAM,DFN,SDT,SDDT,SDOE),SDCL=$P($G(^SC(SDCL,0)),U),Y=SDDT X ^DD("DD")
	W !?(SDCOL),$E(SDPNAM,1,18),?(SDCOL+20),$P($G(^DPT(DFN,0)),U,9) W ?(SDCOL+32),$P(Y,":",1,2),?(SDCOL+52),$E(SDCL,1,28) D APFP^SCRPW29 S SDI=SDI+1 Q
	;
DDXP	;Detail dx/procedure lists
	I $Y>(IOSL-10) D HDR^SCRPW29("Report Detail"),HD2^SCRPW29,DDPH^SCRPW29("D") Q:SDOUT  G DDXP0
	W:SDF(3)="B" !! D DDPH^SCRPW29("D")
DDXP0	I '$D(^TMP("SCRPW",$J,"RPTTDX",1,SDS1,SDS2)) W !!,"No diagnoses found for this detail item." G DAPP
	K SDTCT S SDQT="",SDCT=0
	F  S SDQT=$O(^TMP("SCRPW",$J,"RPTTDX",1,SDS1,SDS2,SDQT),-1) Q:SDOUT!(SDQT="")!(SDCT>(SDF(5)-1))  S SDS3="" F  S SDS3=$O(^TMP("SCRPW",$J,"RPTTDX",1,SDS1,SDS2,SDQT,SDS3)) Q:SDOUT!(SDS3="")!(SDCT>(SDF(5)-1))  D DDXP1
	Q:SDOUT  D:$Y>(IOSL-6) HDR^SCRPW29("Report Detail"),HD2^SCRPW29,DDPH^SCRPW29("D") Q:SDOUT
	W !?(SDCOL),"==========================================",?(SDCOL+46),"==========",?(SDCOL+61),"==========",?(SDCOL+76),"==========",!?(SDCOL),"TOTAL:",?(SDCOL+46),$J(SDTCT(1),10),?(SDCOL+61),$J(SDTCT(2),10),?(SDCOL+76),$J(SDTCT(3),10)
	;
DAPP	I $Y>(IOSL-10) D HDR^SCRPW29("Report Detail"),HD2^SCRPW29,DDPH^SCRPW29("P") Q:SDOUT  G DAPP0
	W !! D DDPH^SCRPW29("P")
DAPP0	I '$D(^TMP("SCRPW",$J,"RPTTAP",1,SDS1,SDS2)) W !!,"No procedures found for this detail item." Q
	K SDTCT S SDQT="",SDCT=0
	F  S SDQT=$O(^TMP("SCRPW",$J,"RPTTAP",1,SDS1,SDS2,SDQT),-1) Q:SDOUT!(SDQT="")!(SDCT>(SDF(5)-1))  S SDS3="" F  S SDS3=$O(^TMP("SCRPW",$J,"RPTTAP",1,SDS1,SDS2,SDQT,SDS3)) Q:SDOUT!(SDS3="")!(SDCT>(SDF(5)-1))  D DAPP1
	Q:SDOUT  D:$Y>(IOSL-6) HDR^SCRPW29("Report Detail"),HD2^SCRPW29,DDPH^SCRPW29("A") Q:SDOUT  W !?(SDCOL+13),"======================================",?(SDCOL+56),"==========",!?(SDCOL+13),"TOTAL:",?(SDCOL+56),$J(SDTCT(1),10)
	Q
	;
DDXP1	D:$Y>(IOSL-6) HDR^SCRPW29("Report Detail"),HD2^SCRPW29,DDPH^SCRPW29("D") Q:SDOUT  F SDI=1,2,3 S SDICT(SDI)=+$P(^TMP("SCRPW",$J,"RPTDX",1,SDS1,SDS2,SDS3),U,SDI),SDTCT(SDI)=$G(SDTCT(SDI))+SDICT(SDI)
	N DIWL,DIWF,SDL2 S DIWL=1 S DIWF="C42|" K ^UTILITY($J,"W") S X=SDS3 D ^DIWP
	F SDL2=1:1:^UTILITY($J,"W",DIWL) W !?(SDCOL),$E(^UTILITY($J,"W",DIWL,SDL2,0),1,42)
	W ?(SDCOL+46),$J(SDICT(1),10),?(SDCOL+61),$J(SDICT(2),10),?(SDCOL+76),$J(SDICT(3),10) S SDCT=SDCT+1 Q
	;
DAPP1	D:$Y>(IOSL-6) HDR^SCRPW29("Report Detail"),HD2^SCRPW29,DDPH^SCRPW29("A") Q:SDOUT  S SDICT(1)=^TMP("SCRPW",$J,"RPTAP",1,SDS1,SDS2,SDS3),SDTCT(1)=$G(SDTCT(1))+SDICT(1)
	W !?(SDCOL+13),SDS3,?(SDCOL+56),$J(SDICT(1),10) S SDCT=SDCT+1 Q
	;
EXIT	D DISP0^SCRPW23,KVA^VADPT,KILL^%ZISS S X=IOM X ^%ZOSF("RM")
	K %,%DT,%Y,C,DFN,DIC,DIR,DTOUT,DUOUT,I,II,S1,S2,SD,SDA,SDACT,SDATE,SDBOT,SDCL,SDCOL,SDCT,SDDT,SDDV,SDE,SDEDT,SDEF,SDENC,SDEXE,SDF,SDFE,SDFI,SDFL
	K SDFOUND,SDH,SDI,SDICT,SDII,SDIRB,SDIRQ,SDISP,SDL,SDLEV,SDLINE,SDLP,SDLR,SDNUL,SDO,SDOE,SDOE0,SDOCH,SDOUT,SDP,SDPAGE,SDPAR,SDPBDT,SDPER,SDPNAM
	K SDPNOW,SDPTX,SDQT,SDR,SDR1,SDR2,SDREV,SDRPT,SDS,SDS1,SDS2,SDS3,SDDSC1,SDSC2,SDSEL,SDT,SDTAG,SDTCT,SDTITL,SDTITLX,SDTOP,SDTX,SDTYP,SDU,SDUNI
	K SDAPFM,SDD,SDPFL,SDIII,S0,SDLPX,SDHIN,SDV,SDVIS,SDX,SDX1,SDX2,SDY,SDYR,SDZ,T,X,X1,X2,Y,ZTSAVE,SDSTOP,SDXY,SDTEMP,SDRM,D0,DINUM,SDNEW,SDOECH
	K SDOECH,SDORD,SDORDV,SDS4,SDTOT,^TMP("SCRPW",$J)
	Q
