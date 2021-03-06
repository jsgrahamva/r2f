IMRARVCH ;HIRMFO/FAI-HIV REGISTRY PATIENT CLINICAL HISTORY ARV REPORT ;06/12/00 16:23;
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**5**;Feb 09, 1998
START S FLAG=0
 D RPT,GETRX,COMPARE
 W:FLAG=0 !!,"**NO DATA FOUND FOR THIS PERIOD**"
 D KILL
 Q
RPT ; *** Get search strings
 S RXNM="" F  S RXNM=$O(^IMR(158.7,"B",RXNM)),DR="" Q:RXNM=""  F  S DR=$O(^IMR(158.7,"B",RXNM,DR)) Q:DR=""  S NDFIEN=$P($G(^IMR(158.7,DR,0)),U,3),^TMP("ARV",$J,RXNM)=NDFIEN
 Q
GETRX I '$D(^PS(55,DFN,"P")) W !,"*** NO ACTIVE PHARMACY DATA ***" Q
 S IMRDFN=DFN
 S RXN=0 F  S RXN=$O(^PS(55,DFN,"P",RXN)) Q:RXN=""  Q:'$D(^PS(55,DFN,"P",RXN,0))  S PRSC=$P($G(^PS(55,DFN,"P",RXN,0)),U,1),FDT=$P($G(^PSRX(PRSC,2)),U,2) D NAME
 Q
NAME S RXNAME=$P($G(^PSRX(PRSC,0)),U,6) Q:RXNAME=""  S DRUG=$P($G(^PSDRUG(RXNAME,0)),U,1),RXU=$P($G(^PSRX(PRSC,0)),U,1),NDF=$P($G(^PSDRUG(RXNAME,"ND")),U,1)
 S:$G(NDF)'="" NDFP=$P($G(^PSNDF(50.6,NDF,0)),U,1)
 S:$G(NDF)="" NDF="UNK",NDFP=$E(DRUG,1,15)
 S:(FDT>IMRHNBEG)&(FDT<IMRHNEND) ^TMP("RXNAM",$J,NDFP,IMRDFN)=NDF_"^"_DRUG_"^"_FDT
 D REFILL,PARTIAL
 Q
REFILL ;Get the Refill Information
 D GETS^DIQ(52,PRSC,"52*","I","IMRAR") ;refill
 Q:'$D(IMRAR(52.1))  S IMRRI=0 ;get refill data
 S IMRN="" F  S IMRN=$O(IMRAR(52.1,IMRN)) Q:IMRN=""  S IMRRXD=+$G(IMRAR(52.1,IMRN,.01,"I")) D
 .S:(IMRRXD>IMRHNBEG)&(IMRRXD<IMRHNEND) ^TMP("RXNAM",$J,NDFP,IMRDFN)=NDF_"^"_DRUG_"^"_IMRRXD
 K IMRAR,IMRRXD
 Q
PARTIAL D GETS^DIQ(52,PRSC,"60*","I","IMRAR") ;refill
 Q:'$D(IMRAR(52.2))  S IMRRI=0 ;get refill data
 S IMNR="" F  S IMNR=$O(IMRAR(52.2,IMNR)) Q:IMNR=""  S IMRRPD=+$G(IMRAR(52.2,IMNR,.01,"I")) D
 .S:(IMRRPD>IMRHNBEG)&(IMRRPD<IMRHNEND) ^TMP("RXNAM",$J,NDFP,IMRDFN)=NDF_"^"_DRUG_"^"_IMRRPD
 K IMRAR,IMRRPD
 Q
COMPARE ; compare RX to NDF
 I '$D(^TMP("RXNAM",$J)) W !,"*** NO DATA FOUND ***" Q
 S NDFIEN=""
 S NAME="" F  S NAME=$O(^TMP("RXNAM",$J,NAME)),DFN="" Q:NAME=""  F  S DFN=$O(^TMP("RXNAM",$J,NAME,DFN)) Q:DFN=""  S IMREC=^TMP("RXNAM",$J,NAME,DFN),NDFN=$P($G(IMREC),U,1),LOCNM=$P($G(IMREC),U,2),PDATE=$P($G(IMREC),U,3) D COMP2
 Q
COMP2 S ARVRX="" F  S ARVRX=$O(^TMP("ARV",$J,ARVRX)) Q:ARVRX=""  S NIEN=$P($G(^TMP("ARV",$J,ARVRX)),U,1) D STORE
 Q
STORE ; expand on to include dosage if requested
 I $G(NIEN)'="" Q:NDFN'=NIEN
 I $G(NIEN)="" Q:LOCNM'[ARVRX
 S FLAG=1
 W !,NAME,?35,"Last Activity: "_$E(PDATE,4,5)_"/"_$E(PDATE,6,7)_"/"_$E(PDATE,2,3)
 Q
KILL K ^TMP("ARV",$J),^TMP("RXNAM",$J)
 K ARVRX,DRUG,FLAG,FN,GLT,IMRAV,IMRC,IMCT,IMREC,IMRRI,IMRONE,IMRTWO,IMRTHR,IMRFOR,IMRU,FDT,FOUR,GONE,GTWO,GTHR,GFOUR,GUNK,IMCT,IMNR
 K IMRC,IMRCT,IMRDFN,IMRFLG,IMRFN,IMRFOR,IMRH1HED,IMRH2HED,IMRHENGD,IMRHNBEG,IMRHNEND,IMRHQUIT,IMRHRANG,IMRHTART,IMRJ,IMRN
 K IMRONE,IMRRI,IMRSG,IMRSTN,IMRTHR,IMRTWO,IMRU,IMRUCST,INRTHR,LOCNM,LTOT,NAM,NAME,NDF,NDFN,NDFP,NDFIEN,NIEN,ONE,PDATE,PNAM,PRSC,PTOT,REC,RXN,RXNAME,RXNM,RXU,SSN,THR,TPAT,TWO,UNK,ZNAM
 Q
