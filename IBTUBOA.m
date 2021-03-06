IBTUBOA	;ALB/RB - UNBILLED AMOUNTS - GENERATE UNBILLED REPORTS ;01-JAN-01
	;;2.0;INTEGRATED BILLING;**19,31,32,91,123,159,192,155,276,516**;21-MAR-94;Build 123
	;;Per VA Directive 6402, this routine should not be modified.
	;
%	; - Entry point from Taskman.
	;
	; IB*2.0*516 - Added ability to sort by Division, so added IBDIV as a
	; subscript to most of the IBUNB entries.
	;
	;ARRAY VARIABLES:
	;   IBAVG("BILLS-I")=number of inpatient institutional claims
	;   IBAVG("BILLS-P")=number of inpatient professional claims
	;   IBAVG("EPISD-I")=number of inpt. episodes for institutional claims
	;   IBAVG("EPISD-P")=number of inpt. episodes for professional claims
	;   IBAVG("$AMNT-I")=inpatient institutional amount billed
	;   IBAVG("$AMNT-P")=inpatient professional amount billed
	;
	;   IBUNB("UNBILTL")=total unbilled amount
	;   IBUNB("UNBILTL-MRA")=total MRA req amount
	;
	;   IBUNB(IBDIV,"ENCNTRS")=number of outpatient encounters missing claims
	;   IBUNB(IBDIV,"EPISM-I")=number of inpatient episodes missing inst. claims
	;   IBUNB(IBDIV,"EPISM-I-MRA")=number of MRA req inpat institutional claims
	;   IBUNB(IBDIV,"EPISM-P")=number of inpatient episodes missing prof. claims
	;   IBUNB(IBDIV,"EPISM-P-MRA")=number of MRA req inpat professional claims
	;   IBUNB(IBDIV,"EPISM-A")=number of inpatient admissions missing claims
	;                   (any type: Prof,Inst or both)
	;   IBUNB(IBDIV,"EPISM-A-MRA")=number inpt MRA req admissions missing claims
	;                   (any type: Prof,Inst or both)
	;   IBUNB(IBDIV,"CPTMS-I")=number of CPT codes missing institutional claims
	;   IBUNB(IBDIV,"CPTMS-I-MRA")=number of MRA req CPT codes missing inst claims
	;   IBUNB(IBDIV,"CPTMS-P")=number of CPT codes missing professional claims
	;   IBUNB(IBDIV,"CPTMS-P-MRA")=number of MRA req CPT codes missing prof claims
	;   IBUNB(IBDIV,"PRESCRP")=number of unbilled prescriptions
	;   IBUNB(IBDIV,"PRESCRP-MRA")=number of MRA req prescriptions
	;   IBUNB(IBDIV,"UNBILIP")=unbilled inpatient amount
	;   IBUNB(IBDIV,"UNBILIP-MRA")=MRA req inpatient amount
	;   IBUNB(IBDIV,"UNBILOP")=unbilled outpatient amount
	;   IBUNB(IBDIV,"UNBILOP-MRA")=MRA req outpatient amount
	;   IBUNB(IBDIV,"UNBILRX")=unbilled prescription amount
	;   IBUNB(IBDIV,"UNBILRX-MRA")=MRA req prescription amount
	; 
	;ARRAY VARIABLES FOR DM EXTRACT:
	;   IB(1)=Number of inpatient episodes missing institutional claims
	;   IB(2)=Amount of inpatient episodes missing institutional claims
	;   IB(3)=Number of inpatient episodes missing professional claims
	;   IB(4)=Amount of inpatient episodes missing professional claims
	;   IB(5)=Number of all inpatient episodes missing claims
	;   IB(6)=Amount of all inpatient episodes missing claims
	;   IB(7)=Number of unbilled outpatient encounters prior to 9/1/99
	;   IB(8)=Amount of unbilled outpatient encounters prior to 9/1/99
	;   IB(9)=Number of procedures without an institutional charge
	;   IB(10)=Amount of procedures without an institutional charge
	;   IB(11)=Number of procedures without a professional charge
	;   IB(12)=Amount of procedures without a professional charge
	;   IB(13)=Number of all procedures without a charge
	;   IB(14)=Number of encounters associated with all procedures without
	;          a charge
	;   IB(15)=Number of all encounters missing claims
	;   IB(16)=Amount of all encounters missing claims
	;   IB(17)=Number of unbilled prescriptions and refills
	;   IB(18)=Amount of unbilled prescriptions and refills
	;   IB(19)=Amount of all unbilled episodes of care
	;
	N IB,IBAMTI,IBAMTP,IBIAV,IBIA,IBNODE,IBOE,IBPA,IBQUERY,IBRX,IBSAV,IBT
	N IBAMTIM,IBAMTPM,IBTYP,IBX,IBY,DFN,DGPM,I,J
	;
	K ^TMP($J,"IBTUB-INPT"),^TMP($J,"IBTUB-OPT"),^TMP($J,"IBTUB-RX")
	K ^TMP($J,"IBTUB-INPT_MRA"),^TMP($J,"IBTUB-OPT_MRA"),^TMP($J,"IBTUB-RX_MRA")
	;
	; - Initialize DM extract variables, if necessary.
	I $G(IBXTRACT) D E^IBJDE(37,1) F IBX=1:1:19 S IB(IBX)=0
	;
	; - Initialize Unbilled Amounts variables.
	S (IBUNB("ENCNTRS"),IBUNB("PRESCRP"),IBUNB("PRESCRP-MRA"))=0
	F IBX="IP","OP","RX","TL" S IBUNB("UNBIL"_IBX)=0,IBUNB("UNBIL"_IBX_"-MRA")=0
	F IBX="I","P" S (IBUNB("EPISM-"_IBX),IBUNB("EPISM-"_IBX_"-MRA"),IBUNB("CPTMS-"_IBX),IBUNB("CPTMS-"_IBX_"-MRA"))=0
	S (IBUNB("EPISM-A"),IBUNB("EPISM-A-MRA"))=0
	;
	; - Retrieve the Rate Type code for Reimbursable Insurance
	S IBRT=$S($O(^DGCR(399.3,"B","REIMBURSABLE INS.",0)):$O(^(0)),1:8)
	;
	; - If Compile/Store - Checks if the Average Bill Amounts exists for
	;   IBTIMON. If it does not, calls IBTUBAV to calculate/updated it.
	I $G(IBCOMP) D
	. I $P($G(^IBE(356.19,IBTIMON,1)),"^",14)'="" Q
	. ;
	. ; - DQ^IBTUBAV will kill the variables IBTIMON and IBCOMP - That's why
	. ;   they are being set again after this call.
	. S IBSAV=IBTIMON D DQ^IBTUBAV S IBTIMON=IBSAV,IBCOMP=1
	. Q
	;
PROC	; - Loops through all the entries in the Claims Tracking file for the
	;   period selected and calculate the Unbilled Amounts
	S IBDT=IBBDT-.1
	;
	F  S IBDT=$O(^IBT(356,"D",IBDT)) Q:'IBDT!(IBDT>IBEDT)  D
	. S IBX=0 F  S IBX=$O(^IBT(356,"D",IBDT,IBX)) Q:'IBX  D
	. . S IBNODE=$G(^IBT(356,IBX,0)) Q:IBNODE=""
	. . I $P(IBNODE,U,12) Q  ; Tort-Feasor,Workman's Comp,No-fault Auto Acc.
	. . I $P(IBNODE,U,19) Q  ;  Reason not billable assigned.
	. . I '$P(IBNODE,U,20) Q  ; Inactive.
	. . S DFN=+$P(IBNODE,U,2)
	. . I '$$PTCHK^IBTUBOU(DFN,IBNODE) Q  ; Has a non-veteran eligibility.
	. . I '$$INSURED^IBCNS1(DFN,IBDT) Q  ;  Not insured during care.
	. . I $P(IBNODE,U,5),IBSEL[1,$$COV^IBTUBOU(DFN,IBDT,1) D  Q  ;Inpatient
	. . . S DGPM=+$P(IBNODE,U,5) D INPT^IBTUBO2(DGPM)
	. . I $P(IBNODE,U,4),IBSEL[2,$$COV^IBTUBOU(DFN,IBDT,2) D  Q  ;Outpatient
	. . . S IBOE=+$P(IBNODE,U,4) I $$NCCL^IBTUBOU(IBOE) Q  ; Non-Count Clinic
	. . . D OPT^IBTUBO1(IBOE,.IBQUERY)
	. . I $P(IBNODE,U,8),IBSEL[3,$$COV^IBTUBOU(DFN,IBDT,3) D  Q  ;Prescription
	. . . N IBIFN,IBCSTAT S IBIFN=+$P(IBNODE,U,11)
	. . . I IBIFN S IBCSTAT=$$GET1^DIQ(399,IBIFN_",",.13,"I") Q:$S(IBCSTAT=0:1,IBCSTAT=1:0,IBCSTAT=2:1,IBCSTAT=3:1,IBCSTAT=4:1,IBCSTAT=5:1,IBCSTAT=7:0,1:1)  ;already billed (modified in T9)
	. . . S IBRX=+$P(IBNODE,U,8) D RX^IBTUBO2(IBRX)
	. . ;
	. . ; - Check CT entry event type to get unbilled amounts, if necessary.
	. . S IBTYP=$P($G(^IBE(356.6,+$P(IBNODE,U,18),0)),U,8)
	. . I IBTYP=1,IBSEL[1,$$COV^IBTUBOU(DFN,IBDT,1) D
	. . . D INPT^IBTUBO2(+$O(^DGPM("APTT1",DFN,IBDT,0)))
	. . I IBTYP=2,IBSEL[2,$$COV^IBTUBOU(DFN,IBDT,2) D
	. . . D OPT^IBTUBO1("",.IBQUERY)
	;
	I $G(IBXTRACT) D XTRACT^IBTUBOU ; Load extract file, if necessary.
	;
	; MRD;IB*2.0*516 - Moved code that was here into the new
	; procedure TOTAL, and tally most of the values up by Division.
	;
	D TOTAL
	;
	; - If Compile/Store - update Unbilled Amounts data on file #356.19
	I $G(IBCOMP) D LD^IBTUBOU(3,IBTIMON)
	;
PRT	; - Print report(s).
	I $G(IBQUERY) D CLOSE^IBSDU(.IBQUERY)
	D REPORT^IBTUBO3
	;
END	K ^TMP($J,"IBTUB-INPT"),^TMP($J,"IBTUB-OPT"),^TMP($J,"IBTUB-RX")
	K IBDT,IBRT,IBUNB
	I $D(ZTQUEUED) S ZTREQ="@" Q
	D ^%ZISC K IBTEMON,IBXTRACT,D,D0,DA,DIC,DIE
	Q
	;
TOTAL	; Determine grand total amounts.
	;
	; - Calculate the Amount Inpatient INST. & PROF. Unbilled Amounts,
	;   based on average amounts of Billed Amounts
	;
	S IBIAV=$$INPAVG^IBTUBOU(IBTIMON)
	;
	S IBAMTI=$P(IBIAV,"^")*$G(IBUNB("EPISM-I")) ; Inst
	S IBAMTIM=$P(IBIAV,"^")*$G(IBUNB("EPISM-I-MRA")) ; Inst
	S IBAMTP=$P(IBIAV,"^",2)*$G(IBUNB("EPISM-P")) ; Prof
	S IBAMTPM=$P(IBIAV,"^",2)*$G(IBUNB("EPISM-P-MRA")) ; Prof
	;
	S IBUNB("UNBILIP")=IBAMTI+IBAMTP
	S IBUNB("UNBILIP-MRA")=IBAMTIM+IBAMTPM
	;
	;S IBUNB("UNBILTL")=IBUNB("UNBILIP")
	;S IBUNB("UNBILTL-MRA")=IBUNB("UNBILIP-MRA")
	;
	; - Calculate Unbilled Amounts Totals by Division
	;
	S IBDIV=0
	F  S IBDIV=$O(IBUNB(IBDIV)) Q:'IBDIV  D
	. ;
	. S IBAMTI=$P(IBIAV,"^")*$G(IBUNB(IBDIV,"EPISM-I")) ; Inst
	. S IBAMTIM=$P(IBIAV,"^")*$G(IBUNB(IBDIV,"EPISM-I-MRA")) ; Inst
	. S IBAMTP=$P(IBIAV,"^",2)*$G(IBUNB(IBDIV,"EPISM-P")) ; Prof
	. S IBAMTPM=$P(IBIAV,"^",2)*$G(IBUNB(IBDIV,"EPISM-P-MRA")) ; Prof
	. ;
	. S IBUNB(IBDIV,"UNBILIP")=IBAMTI+IBAMTP
	. S IBUNB(IBDIV,"UNBILIP-MRA")=IBAMTIM+IBAMTPM
	. ;
	. S IBUNB("UNBILTL")=$G(IBUNB("UNBILTL"))+$G(IBUNB(IBDIV,"UNBILIP"))+$G(IBUNB(IBDIV,"UNBILOP"))+$G(IBUNB(IBDIV,"UNBILRX"))
	. S IBUNB("UNBILTL-MRA")=$G(IBUNB("UNBILTL-MRA"))+$G(IBUNB(IBDIV,"UNBILIP-MRA"))+$G(IBUNB(IBDIV,"UNBILOP-MRA"))+$G(IBUNB(IBDIV,"UNBILRX-MRA"))
	. ;
	. Q
	;
	Q
	;
