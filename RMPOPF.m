RMPOPF ;HINES-FO/DDA - MAIN INTERFACE ROUTINE FOR PFSS AND HOME OXYGEN ;8/18/05
 ;;3.0;PROSTHETICS;**98**;Feb 09, 1996
EN ; ENTRY POINT FOR HOME OXYGEN BACKGROUND PROCESSING
 ; Loop on APNEW and APO cross-references.
 D APNEW,APO
 K RMPR6699,RMPRACCT,RMPRAPLR,RMPRDFN,RMPRDG1,RMPRDRG,RMPREVNT,RMPRHCPC,RMPRHCPT,RMPRIEN,RMPRITEM,RMPRPAR,RMPRPR1,RMPRPV1,RMPRPV2,RMPRRX,RMPRRXDT,RMPRRXEX,RMPRRXI,RMPRRXLP,RMPRSITE,RMPRSTAT,RMPRZCL
 Q
APNEW ;Loop on file #665 APNEW cross-reference.
 ; Delete ITEM'S PFSS ACCOUNT REFERENCE associated with previous prescription date.
 ; Set PFSS ACCOUNT FLAG.  This will trigger the background process to obtain a new
 ;  PFSS ACCOUNT REFERENCE for the new prescription date.
 S RMPRIEN=0
 F  S RMPRIEN=$O(^RMPR(665,"APNEW",1,RMPRIEN)) Q:RMPRIEN'>0  D
 .; Check for valid prescription
 .D VALIDRX
 .I RMPRRXDT=0 D EXITNEW Q
 .S RMPRITEM=0
 .F  S RMPRITEM=$O(^RMPR(665,RMPRIEN,"RMPOC",RMPRITEM)) Q:RMPRITEM'>0  D
 ..S DIE="^RMPR(665,"_RMPRIEN_",""RMPOC"","
 ..S DA(1)=RMPRIEN,DA=RMPRITEM
 ..S DR="101///@;100///1"
 ..D ^DIE
 ..K DIE,DA,DR
 ..Q
 .D EXITNEW
 Q
EXITNEW ; Remove the APNEW flag
 S RMPRRX=0
 F  S RMPRRX=$O(^RMPR(665,"APNEW",1,RMPRIEN,RMPRRX)) Q:RMPRRX'>0  D
 .S DIE="^RMPR(665,"_RMPRIEN_",""RMPOB"","
 .S DA(1)=RMPRIEN,DA=RMPRRX
 .S DR="100///@"
 .D ^DIE
 .K DIE,DA,DR
 .Q
 Q
APO ;Loop on file #665 APO cross-reference and gather data for GETACCT api.
 S RMPRIEN=0
 F  S RMPRIEN=$O(^RMPR(665,"APO",1,RMPRIEN)) Q:RMPRIEN'>0  D GETACCT
 Q
GETACCT ; ENTRY POINT TO SEND HOME OXYGEN ACCOUNT CREATION, PRE-CERTIFICATION
 ;OR UPDATE DATA TO OBTAIN A PFSS ACCOUNT REFERENCE.     
 ; QUIT IF ALL VALID PRESCRIPTIONS HAVE EXPIRED.
 D VALIDRX       ; LOOP ON EACH ITEM
 S RMPRITEM=0
 F  S RMPRITEM=$O(^RMPR(665,"APO",1,RMPRIEN,RMPRITEM)) Q:RMPRITEM'>0  D
 .I RMPRRXDT=0 D  Q
 ..; Remove APO Flag
 ..S DIE="^RMPR(665,"_RMPRIEN_",""RMPOC"","
 ..S DA(1)=RMPRIEN,DA=RMPRITEM
 ..S DR="100///@"
 ..D ^DIE
 ..K DIE,DA,DR
 ..Q
 .S RMPRDFN=RMPRIEN
 .S RMPRPAR=$P($G(^RMPR(665,RMPRIEN,"RMPOC",RMPRITEM,"PFSS")),"^",2)
 .S:RMPRPAR="" RMPREVNT="A05"
 .S:RMPRPAR'="" RMPREVNT="A08"
 .S RMPRAPLR="GETACCT;RMPOPF"
 .S RMPRPV1(2)="O"
 .S RMPRSTA=$P($G(^RMPR(665,RMPRIEN,0)),"^",2)
 .D GETSITE^RMPRPF1
 .S RMPRPV1(3)=RMPRHLOC
 .S RMPRPV1(7)=$P($G(^RMPR(665,RMPRIEN,"RMPOB",RMPRRXI,"PFSS")),"^",2)
 .S RMPRPV1(44)=RMPRRXDT
 .S RMPRPV2(8)=RMPRRXDT
 .; INSURE HCPCS IS CODE SET VERSIONED
 .S RMPRHCPC=$P($G(^RMPR(665,RMPRIEN,"RMPOC",RMPRITEM,0)),"^",7),RMPRHCDT=RMPRRXDT
 .D PSASHCPC
 .; If HCPCS version check fails then quit, but leave APO Flag intact for future processing.
 .; The HCPCS should eventually be corrected.
 .Q:RMPRVHC=0
 .S RMPRPR1(3)=RMPRVHC
 .S RMPRPR1(4)=RMPRTHC
 .S RMPRPR1(6)="O"
 .; INSURE ICD9 IS CODE SET VERSIONED
 .S RMPRDRG=$P($G(^RMPR(665,RMPRIEN,"RMPOC",RMPRITEM,0)),"^",8)
 .S:RMPRDRG'="" RMPRDRG=$$STATCHK^ICDAPIU($P($G(^ICD9(RMPRDRG,0)),"^"),RMPRRXDT)
 .S RMPRDG1(1,3)=""
 .S:$P(RMPRDRG,"^")=1 RMPRDG1(1,3)=$P(RMPRDRG,"^",2),RMPRDG1(1,6)="F"
 .;ZCL SEGMENT TO GO HERE
 .S RMPRZCL=""
 .; FIELDS NOT YET ENTERED.
 .; Call GETACCT api
 .S RMPRACCT=$$GETACCT^IBBAPI(RMPRDFN,RMPRPAR,RMPREVNT,RMPRAPLR,.RMPRPV1,.RMPRPV2,.RMPRPR1,.RMPRDG1,.RMPRZCL)
 .; Store PFSS ACCOUNT REFERENCE data and Delete the APO flag.
 .S DIE="^RMPR(665,"_RMPRIEN_",""RMPOC"","
 .S DA(1)=RMPRIEN,DA=RMPRITEM
 .S DR="100///@;101///`"_RMPRACCT
 .D ^DIE
 .K DIE,DA,DR
 .K RMPRDFN,RMPRPAR,RMPREVNT,RMPRAPLR,RMPRPV1,RMPRPV2,RMPRSTA,RMPRHLOC,RMPRHCPC,RMPRPR1,RMPRDRG,RMPRDG1,RMPRZCL,RMPRACCT,RMPRSTAT,RMPRCHDT,RMPRVHC,RMPRTHC,RMPREHC
 .Q
EXITGET ;
 K RMPRRXDT,RMPRRXI,RMPRITEM
 Q
PSASHCPC ; determine correct HCPCS code to send based on PSAS HCPCS.
 ; UPON ENTRY RMPRHCPC = POINTER TO 661.1 AND  RMPRHCDT = FILEMAN DATE
 ; Returns with RMPRVHC having the correct value to pass to IBB.
 I RMPRHCPC="" S RMPREHC="A9900",RMPRTHC="HCPCS DELETED" G CHK
 S RMPREHC=$P($G(^RMPR(661.1,RMPRHCPC,0)),"^")
 S RMPRTHC=$P($G(^RMPR(661.1,RMPRHCPC,0)),"^",2)
CHK S RMPRSTAT=$$STATCHK^ICPTAPIU(RMPREHC,RMPRHCDT)
 I ($A($E(RMPREHC,2,2))>64)!($P(RMPRSTAT,"^")=0) D
 .S RMPREHC="A9900"
 .S RMPRSTAT=$$STATCHK^ICPTAPIU(RMPREHC,RMPRHCDT)
 .Q
 I $P(RMPRSTAT,"^")=1 S RMPRVHC=$P(RMPRSTAT,"^",2) Q
 S RMPRVHC=0
 Q
VALIDRX ; GET ASSOCIATED RX MAKE SURE IT HAS NOT EXPIRED.
 S (RMPRRXLP,RMPRRX,RMPRRXI,RMPRRXEX,RMPRRXDT)=0
 F  S RMPRRXLP=$O(^RMPR(665,RMPRIEN,"RMPOB","B",RMPRRXLP)) Q:RMPRRXLP'>0  D
 .F  S RMPRRX=$O(^RMPR(665,RMPRIEN,"RMPOB","B",RMPRRXLP,RMPRRX)) Q:RMPRRX'>0  D
 ..S:$P($G(^RMPR(665,RMPRIEN,"RMPOB",RMPRRX,0)),"^",3)'<DT RMPRRXEX=$P($G(^RMPR(665,RMPRIEN,"RMPOB",RMPRRX,0)),"^",3),RMPRRXDT=RMPRRXLP,RMPRRXI=RMPRRX
 ..Q
 .Q
 K RMPRRXLP,RMPRRX,RMPRRXEX
 Q
ACCTCNCL ; ENTRY POINT TO SEND HOME OXYGEN ACCOUNT CANCELLATION DATA.
 ;  THIS TAG IS CALLED AS A ONE-TIME TASKMAN TASK LOADED FROM ACCTTASK^PMPOPF.
 ;  Input variables from TaskMan-
 ;    RMPRDFN = DA (also DFN)
 ;    RMPRRXDT = Home Oxygen Prescription date
 ;    RMPRRXEN = Home Oxygen Prescription IEN
 ;  
 ;CHECK IF HOME OXYGEN PRESCRIPTION SUB RECORD HAS BEEN DELETED.
 ; EXIT IF IT STILL EXISTS
 G:$D(^RMPR(665,RMPRDFN,"RMPOB","B",RMPRRXDT,RMPRRXEN)) EXITCNCL
 ; THE RECORD WAS DELETED
 ; LOOP ON PATIENT'S ITEMS.
 S RMPRITEM=0
 F  S RMPRITEM=$O(^RMPR(665,RMPRDFN,"RMPOC",RMPRITEM)) Q:RMPRITEM'>0  D CANCEL
EXITCNCL ;
 K RMPRDFN,RMPRRXDT,RMPRRXEN,RMPRITEM
 Q
CANCEL ; ENTRY POINT TO SEND HOME OXYGEN ACCOUNT CANCELLATION DATA.
 ;  THIS TAG IS CALLED AS A ONE-TIME TASKMAN TASK LOADED FROM ITEMTASK^PMPOPF.
 ;  Input variables from TaskMan-
 ;    RMPRDFN = DA (also DFN)
 ;    RMPRITEM = Home Oxygen Item IEN
 ;  
 ;CHECK IF HOME OXYGEN PRESCRIPTION SUB RECORD HAS BEEN DELETED.
 ; EXIT IF IT STILL EXISTS
 ;   SET FROM: 
 ;    RMPRDFN = DFN SENT WITHIN TASKMAN
 ;    RMPRPAR = HOME OXYGEN ITEM (19.4); PFSS Account Reference (101)
 ;    RMPREVNT = "A38"
 ;    RMPRAPLR = "CANCEL1;RMPOPF"
 ;    RMPRPV1(2) = "O"
 ;    RMPRPV1(3) = FILE 669.9, FIELD 52
 ;    RMPRPV1(44) = THE HOME OXYGEN PRESCRIPTION DATE SENT WITHIN TASKMAN
 S RMPRPAR=$P($G(^RMPR(665,RMPRDFN,"RMPOC",RMPRITEM,"PFSS")),"^",2)
CANCEL1 ; ENTRY POINT FOR SINGLE ITEM DELETE (ITEMTASK)
 S RMPREVNT="A38"
 S RMPRAPLR="CANCEL1;RMPOPF"
 S RMPRPV1(2)="O"
 S RMPRSTA=$P($G(^RMPR(665,RMPRDFN,0)),"^",2)
 D GETSITE^RMPRPF1
 S RMPRPV1(3)=RMPRHLOC
 S RMPRIEN=RMPRDFN D VALIDRX
 S:RMPRRXDT'=0 RMPRPV1(44)=RMPRRXDT
 ;   SEND A38 GETACCT FOR THE ITEM
 S RMPRCNCL=$$GETACCT^IBBAPI(RMPRDFN,RMPRPAR,RMPREVNT,RMPRAPLR,.RMPRPV1)
 K RMPRPAR,RMPREVNT,RMPRAPLR,RMPRPV1,RMPRSTA,RMPRHLOC,RMPRCNCL
 Q
ACCTTASK ; FILE #665, HOME OXYGEN PRESCRITION; DATE FIELD MUMPS XREF KILL LOGIC.
 ; TASKMAN LOAD A ONE TIME TASKMAN TASK.
 Q:'+$$SWSTAT^IBBAPI()
 N ZTRTN,ZTDESC,ZTDTH,ZTIO,ZTUCI,ZTCPU,ZTPRI,ZTSAVE,ZTKIL,ZTSYNC
 S ZTIO="",ZTRTN="ACCTCNCL^RMPOPF",ZTDESC="Prosthetics Home Oxygen PFSS Account Cancel",ZTDTH=$H
 S ZTSAVE("RMPRDFN")=DA(1),ZTSAVE("RMPRRXEN")=DA,ZTSAVE("RMPRRXDT")=X
 D ^%ZTLOAD
 Q
ITEMTASK ; FILE #665, HOME OXYGEN ITEM; ITEM FIELD MUMPS XREF
 ;KILL LOGIC.
 ; TASKMAN LOAD A ONE TIME TASKMAN TASK.
 Q:'+$$SWSTAT^IBBAPI()
 S RMPRPAR=$P($G(^RMPR(665,DA(1),"RMPOC",DA,"PFSS")),"^",2)
 N ZTRTN,ZTDESC,ZTDTH,ZTIO,ZTUCI,ZTCPU,ZTPRI,ZTSAVE,ZTKIL,ZTSYNC
 S ZTIO="",ZTRTN="CANCEL1^RMPOPF",ZTDESC="Prosthetics Home Oxygen PFSS Item Cancel",ZTDTH=$H
 S ZTSAVE("RMPRDFN")=DA(1),ZTSAVE("RMPRITEM")=DA,ZTSAVE("RMPRPAR")=RMPRPAR
 D ^%ZTLOAD
 K RMPRPAR
 Q
CHRGTASK ; FILE #665.72, BILLING MONTH; VENDOR; PATIENT; ITEM FIELD MUMPS XREF
 ;KILL LOGIC.
 ; TASKMAN LOAD A ONE TIME TASKMAN TASK.
 Q:'+$$SWSTAT^IBBAPI()
 S RMPRPFSS=^RMPO(665.72,DA(4),1,DA(3),1,DA(2),"V",DA(1),1,DA,"PFSS")
 N ZTRTN,ZTDESC,ZTDTH,ZTIO,ZTUCI,ZTCPU,ZTPRI,ZTSAVE,ZTKIL,ZTSYNC
 S ZTIO="",ZTRTN="CHRGCRED^RMPOPF1",ZTDESC="Prosthetics Home Oxygen PFSS Charge Credit",ZTDTH=$H
 S ZTSAVE("RMPRDFN")=DA(1),ZTSAVE("RMPRITEM")=DA,ZTSAVE("RMPRVDR")=DA(2),ZTSAVE("RMPRBLDT")=DA(3),ZTSAVE("RMPRSITE")=DA(4)
 S ZTSAVE("RMPRPFSS")=^RMPO(665.72,DA(4),1,DA(3),1,DA(2),"V",DA(1),1,DA,"PFSS")
 D ^%ZTLOAD
 Q
CHARGE ; Called from RMPOPST3.
 ;IMPORTANT VARIBLES PASSED IN FROM RMPOPST3.
 ; D6I= FILE 660 IEN
 ; RMPOXITE= FILE 665.72 SITE (IEN)
 ; RMPODATE= FILE 665.72 BILLING MONTH mult IEN
 ; RMPOVDR= FILE 665.72 VENDOR mult IEN (DINUM to 440)
 ; DFN= FILE 665.72 PATIENT mult IEN (DINUM to 2)
 ; ITM= FILE 665.72 ITEM mult IEN
 ; TRXDT= Date TRX Built
 ; ITMD= Item multiple zero node
 ;
 Q:'+$$SWSTAT^IBBAPI()
 D CHARGE^RMPOPF1
 Q
