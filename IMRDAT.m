IMRDAT ; HCIOFO-FAI/SS - DATA EXTRACTION ; 2/14/03 9:41am
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**4,8,9,5,14,13,16,15,18,19,20**;Feb 09, 1998
 ;
 ;***** ENTRY TO DAILY EXTRACT
ENTRY ;
 N IMRTRANS  S U="^"
 Q:'$D(^IMR(158.9,1,0))  ;quit if no site parameters
 D ^IMRUTST
 S IMRDTT=$$NOW^XLFDT()
 S $P(^IMR(158.9,1,0),"^",9)=IMRDTT ; Last start time
 K IMRC  S IMRC=0                   ; Message line counter
 S IMRSET=0                         ; Message counter
 D STDTS()
EN1 ;--- Entry point from post-init. The following variables must be
 ;--- defined: IMRSD,IMRED,IMRC,IMRSET,IMRDT.
 S IMRTRANS=1 ; Tell the system that this is a transmit to national
 D DOMAIN^IMRUTL                    ; Get the domain name for ICR
 S IMRDOMN="S.IMRHDATA@"_IMRDOMN    ; Append domain to server name
 S IMRM90=$$FMADD^XLFDT($S($G(IMRSDBP(5.2)):IMRSDBP(5.2),1:DT),-90)
 K ^TMP($J)
 ;--- Set LAST START TIME if doesn't exist
 I '$D(IMRDTT) S IMRDTT=$$NOW^XLFDT(),$P(^IMR(158.9,1,0),U,9)=IMRDTT
 ;--- Get station number if it is not defined
 I '$D(IMRSTN)  D IMROPN^IMRXOR  Q:'$D(IMRSTN)
 ;--- Create the message
 S X=10987654321  D XOR^IMRXOR  S IMRCODE=X
 D STARTSEG^IMRDAT1()
 ;--- NEXT CASE node: piece #1=NEXT CASE, piece #2=LAST NEW CASE
 S X=$G(^IMR(158.9,1,"NXT"))  S:X="" ^("NXT")=0
 S IMRNXT1=+X,IMRNXT2=+$P(X,U,2)
 ;--- Process the entries
 S IMRFN=0
 F  S IMRFN=$O(^IMR(158,IMRFN))  Q:IMRFN'>0  S IMRSEND=0  D NXT
 D SEND^IMRDAT1()
 D UPDPARMS()
 ;--- Cleanup
KIL K IMRDENT,IMRRAD,IMRRX,IMRLAB,IMRMI,IMRSCH,IMRCODE,IMRT1,IMRT2,DFN,IMRDFN,IMRFN,IMRED,IMRDT,IMR101,IMRNXT1,IMRNXT2,IMROP,IMRSET,IMRSTN,X,X1,X2,IMRC,IMRSSN,%DT,Y,%H,%,IMRTRANS
 K ^TMP($J),%T,DIC,IMRN,IMRSCH1,J,XCNP,XMZ,VAERR,D,DISYS,POP,IMRPAD,IMRADM,IMRDIS,IMRDOMN,IMRSEND,IMR5,IMRDTT,IMRL,IMRT,IMRTEST,IMRTRAN,IMRTSTI,IMRSD,IMRSDBP,IMRAD,IMRM90
 K IMRDTRX,IMRSDBP
 Q
 ;
 ;*****
NXT D CLEAR
 ;--- Node 101 contains last dates noted for various services provided
 S IMR101=$G(^IMR(158,IMRFN,101)),IMRI=+IMR101
 ;--- Node 5 is the date of death node
 S IMR5=$G(^IMR(158,IMRFN,5))
 ;--- Data transmitted for deceased (1:YES,0:NO)
 S IMRTRAN=$P(IMR5,U,21)  Q:IMRTRAN
 ;--- IMRT1 is used to calculate the number of seconds needed
 ;--- to extract data for patient
 S IMRT1=$P($H,",",2)
 ;--- Decode patient id; quit if not in File 2
 S X=+^IMR(158,IMRFN,0)  D XOR^IMRXOR  Q:'$D(^DPT(X,0))
 S (DFN,IMRDFN)=X
 ;--- Piece #2 = LAST SCHEDULING DATE NOTED
 I $P(IMR101,U,2)=""  D
 . S IMRT2="NEW"  D DEMOG,CDC
 E  S IMRT2="UPD"  D DEMOG,CDC0^IMRDAT1()
 ;---
 I IMR101'=""  S IMRT1=$P($H,",",2)-IMRT1  D  D LCHK
 . S:IMRT1<0 IMRT1=IMRT1+(24*60*60)
 . S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="TIME"_"^"_IMRT2_"^"_IMRT1
 Q
 ;
 ;*****
LCHK I (IMRC-$G(IMRC(0)))'<5000  S IMRC(0)=IMRC  D SEND^IMRDAT1()
 Q
 ;
 ;*****
CDC ; Get Patient Data From File 158
 I $D(^IMR(158,IMRFN,1)),$P(^(1),"^",6)>0,$P(IMR101,"^",14)<$P(^(1),"^",6) S IMRLD=$P(^IMR(158,IMRFN,1),"^",6),$P(IMR101,"^",14)=IMRLD K IMRLD ;piece 6=date cdc form completed, piece 14=last cdc form date
 D MOVCDC0^IMRDAT1
 Q
 ;
 ;*****
DEMOG Q:'$D(^DPT(DFN,0))
 D SEGS^IMRDAT1(1,1,1,.VADM)
 ;--- Race (IMR*2.1*19)
 I $G(VADM(12))>0  D  D LCHK
 . N IMRIV,METHOD,RACE  S IMRIV=""
 . F  S IMRIV=$O(VADM(12,IMRIV))  Q:IMRIV=""  D  D LCHK
 . . S RACE=$$PTR2CODE^DGUTL4($P(VADM(12,IMRIV),U),1,2)  Q:RACE=""
 . . S METHOD=$$PTR2CODE^DGUTL4($P($G(VADM(12,IMRIV,1)),U),3,2)
 . . S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="DER^"_RACE_"^"_METHOD
 ;--- Ethnicity (IMR*2.1*19)
 I $G(VADM(11))>0  D  D LCHK
 . N ETHN,IMRIV,METHOD  S IMRIV=""
 . F  S IMRIV=$O(VADM(11,IMRIV))  Q:IMRIV=""  D  D LCHK
 . . S ETHN=$$PTR2CODE^DGUTL4($P(VADM(11,IMRIV),U),2,2)  Q:ETHN=""
 . . S METHOD=$$PTR2CODE^DGUTL4($P($G(VADM(11,IMRIV,1)),U),3,2)
 . . S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="DEE^"_ETHN_"^"_METHOD
 ;--- Cleanup
 K VADM  S IMRFLG=0
 ;--- Inpatient Data
IP D
 . S IMRLD=+$P(IMR101,"^",3)  ; LAST ADMIT DATE NOTED
 . S IMRLD1=+$P(IMR101,"^",4) ; LAST DISCHARGE DATE NOTED
 . S IMRLD2=+$P(IMR101,"^",5) ; LAST PTF ADMIT DATE NOTED
 . ; Perform the backpull if the start date is defined
 . I $G(IMRSDBP(5.2))>0  N IMRSD  S IMRSD=$G(IMRSDBP(5.2))
 . D ^IMRPTF
 . S $P(IMR101,"^",3,5)=$S(IMRADM>IMRLD:IMRADM,1:IMRLD)_"^"_$S(IMRDIS>IMRLD1:IMRDIS,1:IMRLD1)_"^"_$S(IMRPAD>IMRLD2:IMRPAD,1:IMRLD2)
 . K IMRLD,IMRLD1,IMRLD2
 D GETDAT^IMRDAT1
 Q
 ;
 ;*****
CLEAR ; Kill Variables
 K IMRT1,IMRT2,DFN,IMRLD,IMRLD1,IMRLD2
 Q
ASK ; Entry Point to Process Data Extract For A Given Date Range
 K %DT S %DT="AQEXP",%DT("A")="   Start Date for Period: " D ^%DT K %DT G:Y'>0 KIL S IMRSD=Y,%DT="AQEXP",%DT("A")="    End Date for Period: " D ^%DT K %DT G:Y'>0 KIL S IMRED=Y
 I IMRED<IMRSD W !,$C(7),"END CAN NOT BE BEFORE START",! G ASK
 S X1=IMRED,X2=IMRSD D ^%DTC I 'X S X1=IMRSD,X2=-1 D C^%DTC S IMRSD=X
 I X>180 W !,$C(7),"MORE THAN 180 DAYS OF DATA IS TOO MUCH TO TRANSMIT.",!,"TRY A SHORTER DATE RANGE." G ASK
 S IMRED=IMRED+.3,IMRDT=IMRED
 S $P(^IMR(158.9,1,0),"^",9)=$$NOW^XLFDT() ;LAST START TIME
 S IMRC=0,IMRSET=0
DQ ; Queue Data Extract
 K ZTUCI,ZTDTH,ZTIO,ZTSAVE
 S ZTRTN="EN1^IMRDAT"
 S ZTSAVE("IMRSD")="",ZTSAVE("IMRED")="",ZTSAVE("IMRC")="",ZTSAVE("IMRSET")="",ZTSAVE("IMRDT")=""
 S ZTDTH=$$NOW^XLFDT()
 S ZTIO="",ZTDESC="Process Data Extract for a Date Range"
 D ^%ZTLOAD
 K ZTDESC,ZTDTH,ZTRTN,ZTSAVE,ZTIO,ZTSK
 Q
 ;
 ;***** LOADS THE START DATES
 ;
 ; Initializes the variables: IMRDT, IMRED, IMRSD, IMRSDBP, IMRDTRX
STDTS() ;
 N FLD,IENS,IMRBUF,IMRMSG,TMP
 K IMRSDBP,IMRDTRX
 S (IMRED,IMRDT)=$$NOW^XLFDT(),IMRSD=0
 S IENS="1,"
 D GETS^DIQ(158.9,IENS,".1;5.1;5.2;5.3","I","IMRBUF","IMRMSG")
 S IMRSD=$G(IMRBUF(158.9,IENS,.1,"I"))\1
 S:$G(IMRSD)'>0 IMRSD=$$FMADD^XLFDT($$DT^XLFDT,-1)
 F FLD=5.1,5.2,5.3  D
 . S TMP=$G(IMRBUF(158.9,IENS,FLD,"I"))\1
 . S:TMP>0 IMRSDBP(FLD)=TMP
 ;--- Dates for the Pharmacy data extraction
 S IMRDTRX("S")=$$FMADD^XLFDT(IMRSD,-14)
 S IMRDTRX("E")=$$FMADD^XLFDT(IMRED\1,-14)
 I IMRDTRX("E")'>IMRDTRX("S")  D
 . S IMRDTRX("E")=$$FMADD^XLFDT(IMRDTRX("S"),1)
 E  S:IMRDTRX("E")>IMRSD IMRDTRX("E")=IMRSD
 Q
 ;
 ;***** UPDATES SITE PARAMETERS
UPDPARMS() ;
 N IENS,IMRFDA,IMRMSG
 S IENS="1,"
 S IMRFDA(158.9,IENS,.1)=$$NOW^XLFDT ; LAST COMPLETION TIME
 S IMRFDA(158.9,IENS,5.1)="@"        ; LAB BACKPULL START
 S IMRFDA(158.9,IENS,5.2)="@"        ; INPATIENT BACKPULL START
 S IMRFDA(158.9,IENS,5.3)="@"        ; PHARMACY BACKPULL START
 S IMRFDA(158.9,IENS,21.01)=0        ; NEXT CASE
 S IMRFDA(158.9,IENS,21.02)=IMRNXT2  ; LAST NEW CASE
 D FILE^DIE(,"IMRFDA","IMRMSG")
 Q
