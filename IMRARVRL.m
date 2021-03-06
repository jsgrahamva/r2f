IMRARVRL ;HIRMFO/FAI-CHECK REIMBURSEMENT LEVEL ;06/13/00 05:14;
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**5**;Feb 09, 1998
 ;
START S IMRBL="NOARV" D RPT,GETRX,COMPARE,KILL
 Q
RPT ; *** Get search strings
 S RXNM="" F  S RXNM=$O(^IMR(158.7,"B",RXNM)),DR="" Q:RXNM=""  F  S DR=$O(^IMR(158.7,"B",RXNM,DR)) Q:DR=""  S NDFIEN=$P($G(^IMR(158.7,DR,0)),U,3),^TMP("RXARV",$J,RXNM)=NDFIEN
 Q
GETRX I '$D(^PS(55,DFN,"P")) S IMRBL="NOARV" G KILL Q
 S RXN=0 F  S RXN=$O(^PS(55,DFN,"P",RXN)) Q:RXN=""  Q:'$D(^PS(55,DFN,"P",RXN,0))  S PRSC=$P($G(^PS(55,DFN,"P",RXN,0)),U,1) Q:$G(PRSC)=""  S FDT=$P($G(^PSRX(PRSC,2)),U,2) D NAME
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
 S NDFIEN=""
 S NAME="" F  S NAME=$O(^TMP("RXNAM",$J,NAME)),PID="" Q:NAME=""  F  S PID=$O(^TMP("RXNAM",$J,NAME,PID)) Q:PID=""  S IMREC=^TMP("RXNAM",$J,NAME,PID),NDFN=$P($G(IMREC),U,1),LOCNM=$P($G(IMREC),U,2),PDATE=$P($G(IMREC),U,3) D COMP2
 Q
COMP2 S ARVRX="" F  S ARVRX=$O(^TMP("RXARV",$J,ARVRX)) Q:ARVRX=""  S NIEN=$P($G(^TMP("RXARV",$J,ARVRX)),U,1) D STORE
 Q
STORE I $G(NIEN)'="" Q:NDFN'=NIEN
 I $G(NIEN)="" Q:LOCNM'[ARVRX
 S IMRBL="ARV"
 Q
KILL K ^TMP("RXNAM",$J),^TMP("RXARV",$J)
 Q
