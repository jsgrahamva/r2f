ISIRESULT ; ISI/SAF - Auto result ECG Procedures ; 10/29/12 4:22pm
 ;;1.0;ISI IMAGING;;Jan 2012;Build 2
 ; This routine sets up the site specific variables for the TIU Note signer, the TIU Title and the ECG procedures
 ; to be resulted.
 ; 
 ; It has 3 options: 
 ; loop through all consults to check to see if they are ECG Procedures (with images) and result them
 ; or to list all the ECG Procedures
 ; or to result a single ECG Procedure 
 ;
 Q
OROAUTO ;result all
 N SIGNER,TITLE,PROC1,PROC2,PROC3,RES
 ;
 I DUZ'=2137 S TMPDUZ=DUZ
 S (DUZ,SIGNER)=2137 ;RESULTING,PROVIDER
 S TITLE=49  ;ELECTROCARDIOGRAM
 ;
 ;Oroville ECG procedure IENS:
 S PROC1="9;GMR(123.3,"   ;ELECTROCARDIOGRAM-HOSPITAL
 S PROC2="35;GMR(123.3,"  ;ELECTROCARDIOGRAM-ER
 S PROC3="36;GMR(123.3,"  ;ELECTROCARDIOGRAM-OPT
 D RESULT(SIGNER,TITLE,PROC1)  ;ELECTROCARDIOGRAM-HOSPITAL
 D RESULT(SIGNER,TITLE,PROC2)  ;ELECTROCARDIOGRAM-ER
 D RESULT(SIGNER,TITLE,PROC3)  ;ELECTROCARDIOGRAM-OPT
 Q
ORO 
 N SIGNER,TITLE,PROC1,PROC2,PROC3,RES
 ;
 I DUZ'=2137 S TMPDUZ=DUZ
 S (DUZ,SIGNER)=2137 ;RESULTING,PROVIDER
 S TITLE=49  ;ELECTROCARDIOGRAM
 ;Oroville ECG procedure IENS:
 S PROC1="9;GMR(123.3,"   ;ELECTROCARDIOGRAM-HOSPITAL
 S PROC2="35;GMR(123.3,"  ;ELECTROCARDIOGRAM-ER
 S PROC3="36;GMR(123.3,"  ;ELECTROCARDIOGRAM-OPT
 D SELECT(.RES)
 ;
 I RES="QUIT" S DUZ=TMPDUZ W !,"Bye..." QUIT
 ;
 I RES="ALL" D
 . D RESULT(SIGNER,TITLE,PROC1)  ;ELECTROCARDIOGRAM-HOSPITAL
 . D RESULT(SIGNER,TITLE,PROC2)  ;ELECTROCARDIOGRAM-ER
 . D RESULT(SIGNER,TITLE,PROC3)  ;ELECTROCARDIOGRAM-OPT
 . Q
 I RES="INDIVIDUAL" D 
 . W ! S DIC=123,DIC(0)="AEQMZ" D ^DIC
 . I Y<0 K Y Q
 . S CONIEN=$P(Y,"^",1) K Y
 . D RESULT1(SIGNER,TITLE,CONIEN)  ;ELECTROCARDIOGRAM-HOSPITAL
 . Q
 I RES="LIST" D
 . D LIST(PROC1)  ;ELECTROCARDIOGRAM
 . D LIST(PROC2)  ;ELECTROCARDIOGRAM-ER
 . D LIST(PROC3)  ;ELECTROCARDIOGRAM-OPT
 . Q
 ;
 D ORO  ;go back to top unles user selects quit
 Q
 ;
STU 
 N SIGNER,TITLE,PROC,RES
 S SIGNER=76 ;STU LOCAL
 S TITLE=1402  ;ECG Consult note
 S PROC1="9;GMR(123.3,"
 ;
 D SELECT(.RES)
 ;
 I RES="QUIT" QUIT
 ;
 I RES="ALL" D 
 . D RESULT(SIGNER,TITLE,PROC1)  ;ELECTROCARDIOGRAM-HOSPITAL
 . Q
 I RES="INDIVIDUAL" D 
 . W ! S DIC=123,DIC(0)="AEQMZ" D ^DIC
 . I Y<0 K Y Q
 . S CONIEN=$P(Y,"^",1) K Y
 . D RESULT1(SIGNER,TITLE,CONIEN)  ;ELECTROCARDIOGRAM-HOSPITAL
 . Q
 I RES="LIST" D
 . D LIST(PROC1)  ;ELECTROCARDIOGRAM
 . Q
 D STU
 Q
 ;
RESULT(MAGESBY,MAGTITLE,PROC) ; Result ECG consults that are open (have not been resulted) and contain linked ECGs
 ;
 ; Loop through file 123 and check if there is an unresulted consult for the PROC (procedure) that is passed in.
 S CONIEN=0 F  S CONIEN=$O(^GMR(123,"AP",PROC,CONIEN)) Q:CONIEN=""  I $P(^GMR(123,CONIEN,0),"^",20)="" D CREATENOTE(CONIEN,MAGESBY,MAGTITLE)
 Q
RESULT1(MAGESBY,MAGTITLE,CONIEN) ; Result one ECG consult
 ;
 ;If the entry exists and is not already resulted, create a resulting progress note
 I $P(^GMR(123,CONIEN,0),"^",20)="" D CREATENOTE(CONIEN,MAGESBY,MAGTITLE)
 Q
LIST(PROC) ;    List ECG consults that are open (unresulted) for a passed in Procedure type
 N CONIEN,PATNM
 W !,"--------- Unresulted consults ---------"
 S CONIEN=0 F  S CONIEN=$O(^GMR(123,"AP",PROC,CONIEN)) Q:CONIEN=""  I $P(^GMR(123,CONIEN,0),"^",20)="" I $P(^GMR(123,CONIEN,0),"^",12)'=1 I $P(^GMR(123,CONIEN,0),"^",12)'=13 D
 . S PAT=$P(^GMR(123,CONIEN,0),"^",2),PAT=$P(^DPT(PAT,0),"^")
 . W !,CONIEN,": ",$G(^GMR(123,CONIEN,1.11)),": ",PAT
 . I $O(^MAG(2006.5839,"C",123,CONIEN,""))'="" W " (I)"  ;Has images
 W !,"--------- End of unresulted consults ---------" 
 Q
LISTPROC ;List procedures (from 123.3) in file 123
 N PROC
 S PROC=0 F  S PROC=$O(^GMR(123,"AP",PROC)) Q:'PROC  W !,PROC,": ",$P(^GMR(123.3,+PROC,0),"^")
 Q
 ;
SELECT(RES) 
 N UP,LO,X
 SET UP="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 SET LO="abcdefghijklmnopqrstuvwxyz"
 S RES=""
 ;
 W !,"Choose (I)ndividual, (A)ll, (L)ist or (Q)uit: "
 R X
 I X["^" Q
 I X="" Q
 S X=$TR(X,LO,UP)
 I $E(X)="I" S RES="INDIVIDUAL" Q
 I $E(X)="A" S RES="ALL" Q
 I $E(X)="L" S RES="LIST" Q
 I $E(X)="Q" S RES="QUIT" Q
 Q
 ;
CREATENOTE(CONIEN,MAGESBY,MAGTITLE) ;
 ;
 W !!,"CONSULT ",CONIEN,":"
 I $O(^MAG(2006.5839,"C",123,CONIEN,""))="" W "There are no images associated with this consult. Skipping entry..." Q
 S MAGDFN=$P(^GMR(123,CONIEN,0),"^",2)  ;Patient
 S MAGADCL=1  ;Admin close
 S MAGMODE="E"  ;Electronically filed
 s MAGES=""
 S MAGLOC=$P(^GMR(123,CONIEN,0),"^",6)  ;Location
 S MAGDATE=$$NOW^XLFDT
 S MAGCNSLT=CONIEN
 S MAGTEXT(.1)=" "
 S MAGTEXT(.2)=" See ECG image for results"
 ;
 D NEW^MAGGNTI1(.ZZ,MAGDFN,MAGTITLE,MAGADCL,MAGMODE,MAGES,MAGESBY,MAGLOC,MAGDATE,MAGCNSLT,.MAGTEXT) ;RPC [MAG3 TIU NEW]
 W ZZ K ZZ
 Q
