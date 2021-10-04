IMRARVRR ;HIRMFO/FAI-ARV REIMBURSEMENT REPORT ;08/31/00 13:00
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**5**;Feb 09, 1998
START D KILL
 S (IMRC,IMCT,IMRCT,IMRRI,IMRONE,IMRTWO,IMRTHR,IMRFOR,IMRU,PTOT,LTOT)=0,IMRDTE=1 D EN,DEVICE
 Q
DEVICE Q:$G(IMRHNBEG)=""
 D IMRDEV^IMREDIT
 G:$G(POP) KILL
 I '$D(IO("Q")) D PRINT Q
 I $D(IO("Q")) D  G KILL
 .S ZTRTN="DQ^IMRARVRR",ZTDESC="ARV Report by Reimbursement"
 .S ZTSAVE("*")="",ZTIO=ION_";"_IOM_";"_IOSL
 .D ^%ZTLOAD K ZTRTN,ZTDESC,ZTSAVE,ZTSK
 .Q
 Q
EN ; *** Get parameters
 D ^IMRDATE
 Q:$G(IMRHNBEG)=""
 W !!,"You have selected Antiretroviral Drugs as a search group.  I will now search for"
 W !,"patients who have had any of the drugs listed in this group.  I will also",!,"search for all Category 4 ICR patients seen in the selected time period.",!!
 S DIR(0)="Y",DIR("A")="Do you want the unique ARV patients listed by name (Y/N)?",DIR("B")="NO",DIR("?")="Answer YES to see a list of individual names." D ^DIR K DIR S IMR2C=Y
 S DIR(0)="Y",DIR("A")="Do you want the unique Category 4 patients listed by name (Y/N)?",DIR("B")="NO",DIR("?")="Answer YES to see a list of individual names." D ^DIR K DIR S IMRC4=Y
 Q
DQ D HEADER,RPT,RXFIND,COMPARE,SUMM,LINES,INDIV,^IMRARVNO,CNTNO,KILL
 Q
PRINT D HEADER,RPT,RXFIND,COMPARE,SUMM,LINES,INDIV,^IMRARVNO,CNTNO,KILL
 Q
RPT ; *** Get search strings
 S RXNM="" F  S RXNM=$O(^IMR(158.7,"B",RXNM)),DR="" Q:RXNM=""  F  S DR=$O(^IMR(158.7,"B",RXNM,DR)) Q:DR=""  S NDFIEN=$P($G(^IMR(158.7,DR,0)),U,3),^TMP("ARV",$J,RXNM)=NDFIEN
 Q
RXFIND ; *** Find RX info
 F IMRJ=0:0 S IMRJ=$O(^IMR(158,IMRJ)),IMRCAT="" Q:IMRJ'>0  S X=+^(IMRJ,0) D ^IMRXOR S (IMRDFN,IMRFN)=X,(FN,DFN,D0,DA)=IMRFN,IMRCAT=$P($G(^IMR(158,IMRJ,0)),U,42) D GETRX
 Q
GETRX Q:'$D(^PS(55,DFN,"P"))
 S:IMRCAT="" IMRCAT="UNK"
 S RXN=0 F  S RXN=$O(^PS(55,DFN,"P",RXN)) Q:RXN=""  S IMRNRX=$G(^PS(55,DFN,"P",RXN,0)) Q:IMRNRX=""  Q:'$D(^PS(55,DFN,"P",RXN,0))  S PRSC=$P($G(^PS(55,DFN,"P",RXN,0)),U,1),FDT=$P($G(^PSRX(PRSC,2)),U,2) D NAME
 Q
NAME S RXNAME=$P($G(^PSRX(PRSC,0)),U,6) Q:RXNAME=""  S DRUG=$P($G(^PSDRUG(RXNAME,0)),U,1),RXU=$P($G(^PSRX(PRSC,0)),U,1),NDF=$P($G(^PSDRUG(RXNAME,"ND")),U,1)
 S:$G(NDF)'="" NDFP=$P($G(^PSNDF(50.6,NDF,0)),U,1)
 S:$G(NDF)="" NDF="UNK",NDFP=$E(DRUG,1,15)
 S:$G(DR)="19" NDFP=$E(DRUG,1,7)
 S:$G(DR)="20" NDFP=$E(DRUG,1,9)
 S:(FDT>IMRHNBEG)&(FDT<IMRHNEND) ^TMP("RXNAM",$J,NDFP,IMRDFN)=NDF_"^"_DRUG_"^"_FDT_"^"_IMRCAT
 D REFILL,PARTIAL
 Q
REFILL ;Get the Refill Information
 D GETS^DIQ(52,PRSC,"52*","I","IMRAR") ;refill
 Q:'$D(IMRAR(52.1))  S IMRRI=0 ;get refill data
 S IMRN="" F  S IMRN=$O(IMRAR(52.1,IMRN)) Q:IMRN=""  S IMRRXD=+$G(IMRAR(52.1,IMRN,.01,"I")) D
 .S:(IMRRXD>IMRHNBEG)&(IMRRXD<IMRHNEND) ^TMP("RXNAM",$J,NDFP,IMRDFN)=NDF_"^"_DRUG_"^"_IMRRXD_"^"_IMRCAT
 K IMRAR,IMRRXD
 Q
PARTIAL D GETS^DIQ(52,PRSC,"60*","I","IMRAR") ;refill
 Q:'$D(IMRAR(52.2))  S IMRRI=0 ;get refill data
 S IMNR="" F  S IMNR=$O(IMRAR(52.2,IMNR)) Q:IMNR=""  S IMRRPD=+$G(IMRAR(52.2,IMNR,.01,"I")) D
 .S:(IMRRPD>IMRHNBEG)&(IMRRPD<IMRHNEND) ^TMP("RXNAM",$J,NDFP,IMRDFN)=NDF_"^"_DRUG_"^"_IMRRPD_"^"_IMRCAT
 K IMRAR,IMRRPD
 Q
COMPARE ; compare RX to NDF
 S NDFIEN=""
 S NM="" F  S NM=$O(^TMP("RXNAM",$J,NM)),DFN="" Q:NM=""  F  S DFN=$O(^TMP("RXNAM",$J,NM,DFN)) Q:DFN=""  S IMREC=^TMP("RXNAM",$J,NM,DFN),NDFN=$P($G(IMREC),U,1),LOCNM=$P($G(IMREC),U,2),PDATE=$P($G(IMREC),U,3),IMRCAT=$P($G(IMREC),U,4) D COMP2
 Q
COMP2 S ARVRX="" F  S ARVRX=$O(^TMP("ARV",$J,ARVRX)) Q:ARVRX=""  S NIEN=$P($G(^TMP("ARV",$J,ARVRX)),U,1) D STORE
 Q
STORE I $G(NIEN)'="" Q:NDFN'=NIEN
 I $G(NIEN)="" Q:LOCNM'[ARVRX
 S ^TMP("IMRPAT",$J,NM,DFN)=IMRCAT
 S TPAT=$P($G(^DPT(DFN,0)),U,1),SSN=$P($G(^DPT(DFN,0)),U,9),^TMP("IMRTOT",$J,TPAT,SSN)=IMRCAT
 Q
SUMM S (GONE,GTWO,GTHR,GFOUR,GLT,GUNK,IMRONE,IMRTWO,IMRTHR,IMRFOR,IMRU,LTOT,PTOT)=0
 S IMRAV="" F  S IMRAV=$O(^IMR(158.7,"B",IMRAV)) Q:IMRAV=""  S ^TMP($J,IMRAV)="0^0^0^0^0"
 S NAME="" F  S NAME=$O(^TMP("IMRPAT",$J,NAME)),DFN="" Q:NAME=""  F  S DFN=$O(^TMP("IMRPAT",$J,NAME,DFN)) Q:DFN=""  S IMRCAT=$P($G(^TMP("IMRPAT",$J,NAME,DFN)),U,1) D ADDCATS^IMRARVCK
 Q
HEADER ; *** Print report header
 W @IOF,?20,"Local Antiretroviral (ARV) Drug Reimbursement Report"
 W !!,?5,"Number of VA HIV/AIDS Patients Receiving Antiretroviral Drugs (ARV)",!
 W !,?20,IMRHRANG,!,?30,"Station Report",!!,"ARV DRUG",?23,"CAT1",?31,"CAT2",?39,"CAT3",?48,"CAT4",?56,"UNK",?64,"TOTAL",!
 W "-------------------",?23,"----",?31,"----",?39,"----",?48,"----",?56,"---",?64,"-----"
 Q
LINES I '$D(^TMP($J)) W !!,"***NO DATA FOUND FOR THIS PERIOD***" Q
 S NDF="" F  S NDF=$O(^TMP($J,NDF)) Q:NDF=""  S REC=^TMP($J,NDF) D LIN2
 Q
LIN2 S ONE=$P(REC,U,1),TWO=$P(REC,U,2),THR=$P(REC,U,3),FOUR=$P(REC,U,4),UNK=$P(REC,U,5) W !,NDF,?24,ONE,?32,TWO,?40,THR,?49,FOUR,?57,UNK S LTOT=ONE+TWO+THR+FOUR+UNK W ?65,LTOT
 S GLT=GLT+LTOT,GONE=GONE+ONE,GTWO=GTWO+TWO,GTHR=GTHR+THR,GFOUR=GFOUR+FOUR,GUNK=GUNK+UNK
 Q
INDIV W:IMR2C=1 !!,?10,"******** List of Unique Patients on ARVs ********",!,"Patient",?23,"SSN",?37,"Category",!,"-------",?23,"---",?37,"--------",!
 S DFN="" F  S DFN=$O(^TMP("IMRTOT",$J,DFN)),SSN="" Q:DFN=""  F  S SSN=$O(^TMP("IMRTOT",$J,DFN,SSN)) Q:SSN=""  S IMRCAT=$P($G(^TMP("IMRTOT",$J,DFN,SSN)),U,1) S PTOT=PTOT+1 D INDI2
 W !!,?15,">>>>>>       # of Unique Patients on ARVs: "_PTOT_"      <<<<<<"
 Q
INDI2 W:IMR2C=1 !,$E(DFN,1,20),?23,$E(SSN,6,9),?40,IMRCAT
 Q
CNTNO W !!!,?10,">>>>>>   # of Unique Category 4 Patients NOT on ARVs: "_$G(CTNOARV)_"   <<<<<<"
 Q
KILL D ^%ZISC K ^TMP($J),^TMP("ARV",$J),^TMP("IMRPAT",$J),^TMP("IMRTOT",$J),^TMP("RXNAM",$J)
 K ARVRX,DFN,DRUG,FN,GLT,IMRAV,IMRC,IMCT,IMREC,IMRRI,IMRONE,IMRTWO,IMRTHR,IMRFOR,IMRU,FDT,FOUR,GONE,GTWO,GTHR,GFOUR,GUNK,IMCT,IMNR
 K IMRC,IMRCAT,IMRCT,IMRDFN,IMRFLG,IMRFN,IMRFOR,IMRH1HED,IMRH2HED,IMRHENGD,IMRHNBEG,IMRHNEND,IMRHQUIT,IMRHRANG,IMRHTART,IMRJ,IMRN
 K IMRONE,IMRRI,IMRSG,IMRSTN,IMRTHR,IMRTWO,IMRU,IMRUCST,INRTHR,IMR4C,PT4C,LOCNM,LTOT,NAM,NAME,NDF,NDFN,NDFP,NDFIEN,NIEN,NM,ONE
 K IMR2C,IMRC4,IMRI,IMRPCT,PDATE,PNAM,PRSC,PTOT,REC,REIM,RXN,RXNAME,RXNM,RXU,SSN,THR,TPAT,TWO,UNK,ZNAM
 K IMRTYP,IMRUT,I,J,K,N,X,Y,POP,IMRFLG,IMRSTN,IMRCAT,VADM,VA,VAERR,VAEL,D,DISYS,IMREXC,IMRPG,IMRHED,IMRSD
 K IMRED,IMRPER,IMRAD,IMRCHK,IMRDD,IMRDFN,IMRDISP,IMRDOD,IMRDSP,IMRDTE,IMREC,IMRFB,IMRINP,IMRNRX,IMRJ,IMRLAB
 K IMRLR,IMROUT,IMRPTF,IMRRX,IMRRXN,IMRSCH,IMRBL,IMRHQUIT,IMRHRANG,IMRHTART,IMRN,IMRPAT,IMRRI,IMRSCT
 K LCL,LCLAB,LG,LGROUP,LLOC,LNL,LNLT,LOCNM,LV3,IMRH1HED,IMRH2HED,IMRHENGD,IMRHNBEG,IMRHNEND,IMRST,IMRSUF,CTNOARV,MC,PD,PID,RM,TY
 Q