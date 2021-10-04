MCBPFTP2 ;WISC/TJK,ALG-PFT BRIEF REPORT-VOLUMES ;2/24/98  15:42
 ;;2.3;Medicine;**17**;09/13/1996
 D SETVAR G FLOW:'$D(^MCAR(700,MCARGDA,3)),FLOW:'$O(^(3,0)) S MCX=0
 S HEAD1="VOLUMES" D HEAD1,HEAD2 Q:$D(MCOUT)
VOL S MCMAIN=0,MCX=$O(^MCAR(700,MCARGDA,3,MCX)) G FLOW:MCX'?1N.N S MCREC=^(MCX,0),TYPE=$P(MCREC,U) S:(TYPE="I")!(TYPE="B") MCMAIN=1
 S ND="AV",ND1=3 D PRETEST
 W !,?5,$S(TYPE="B":"BODY BOX",TYPE="I":"INERT GAS DILUTION",TYPE="N":"NITROGEN WASH OUT",1:"X-RAY PLANIMETRY") D PREVDATE
 I $P(MCREC,U,6)'="" W !,?5,"(NOTES): ",$P(MCREC,U,6) X MCFF Q:$D(MCOUT)
 S ACT=$P(MCREC,U,2) I ACT S MEAS="TLC",UNITS="L",PRED=TLC X:$D(MCRC1) MCRC1 S PC=2,CI95=$S(PRED:PRED-CTLC,1:"") D PRTLINE Q:$D(MCOUT)  S:MCMAIN MCTLCN=ACT,MCITL=CI95,MCIPTL=PRED
 W ! G VOL
FLOW K CTLC,CVC,CFRC,CRV G ^MCBPFTP3
EXIT Q
SETVAR S (MCVCN,MCTLCN,MCMVVN,MCIRV,MCIFA,MCIFL,MCIPTL,MCIFE,MCIFV,MCIDA,MCIDL,MCIDP,MCIAO2,MCIAO1,MCITL)="",MCDL=2,MCLNG=5,PRED=0 Q
PRTLINE S MCP1=$G(MCP1),MCP2=$G(MCP2)
 W !,?5,MEAS,?18,UNITS,?25,$S(PRED:$J(PRED,MCLNG,MCDL),1:""),?35,$J(ACT,MCLNG,MCDL),?45,$S(PRED:$J(ACT/PRED*100,5,1),1:"") W:$P(MCP1,U,PC) ?55,$J($P(MCP1,U,PC),MCLNG,MCDL) W:$P(MCP2,U,PC) ?65,$J($P(MCP2,U,PC),MCLNG,MCDL)
 W:(CI95)&(CI95'=PRED) ?72,$J(CI95,6,2) X MCFF Q
HEAD S PG=PG+1 W @IOF,!!,?22,"CONFIDENTIAL PULMONARY FUNCTION REPORT",?70,"Page: ",PG
 W !,VADM(1),?60,SSN
 W !,CLIN,?60,"DATE: "_DATE
 W !,MCDOT
 Q
HEAD1 W !! X MCFF Q:$D(MCOUT)  W ?15,"UNITS",?25,$S('$D(MCSP):"PRED",1:""),?35,"ACTUAL",?45,$S('$D(MCSP):"%PRED",1:""),?55,"PREV1",?65,"PREV2" W:'$D(MCSP) ?73,"LCI" X MCFF Q
HEAD2 Q:$D(MCOUT)  W !,HEAD1,$E(MCDOT,1,80-$L(HEAD1)),! X MCFF Q
PREVDATE F I="RDATE1","RDATE2" I $D(@I),@I S X=9999999.9999-@I S TAB=$S(I="RDATE1":"?55",1:"?65") W @TAB,+$E(X,4,5),"/",+$E(X,6,7),"/",$E(X,2,3)
 Q
PRETEST S (MCP1,MCP2,MCP1S0,MCP2S0,MCP1S1,MCP1S2,MCP2S1,MCP2S2,RDATE1,RDATE2)="" Q:'$O(^MCAR(700,ND,DFN,TYPE,RDATE))
 S RDATE1=$O(^MCAR(700,ND,DFN,TYPE,RDATE)),PD11=$O(^(RDATE1,0)),PD1=$O(^(PD11,0))
 S (MCP1,MCP1S0)=^MCAR(700,PD11,ND1,PD1,0) I ND="AS" S:$D(^(1)) MCP1S1=^(1) S:$D(^(2)) MCP1S2=^(2)
 K PD1,PD11 Q:'$O(^MCAR(700,ND,DFN,TYPE,RDATE1))
 S RDATE2=$O(^MCAR(700,ND,DFN,TYPE,RDATE1)),PD21=$O(^(RDATE2,0)),PD2=$O(^(PD21,0))
 S (MCP2,MCP2S0)=^MCAR(700,PD21,ND1,PD2,0) I ND="AS" S:$D(^(1)) MCP2S1=^(1) S:$D(^(2)) MCP2S2=^(2)
 K PD2,PD21 Q
