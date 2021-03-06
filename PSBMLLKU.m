PSBMLLKU	;BIRMINGHAM/TEJ - BCMA RPC LOOKUP UTLILITIES ;9/18/12 1:24am
	;;3.0;BAR CODE MED ADMIN;**3,9,11,20,13,38,32,56,42,70,72**;Mar 2004;Build 16
	;Per VHA Directive 2004-038, this routine should not be modified.
	;
	; Reference/IA
	; EN^PSJBCMA1/2829
	; $$DOB^DPTLK1/3266
	; $$SSN^DPTLK1/3267
	; ^DPT/10035
	; ^XUSEC/10076
	; File 52.6/436
	; File 52.7/437
	; File 50/221
	; File 211.4/1409
	; $$UP^XLFSTR/10104
	;
	;*70 - create a lookup for Clinics that returns all patients per 
	;      clinic selected for Client to then pass one at a time for
	;      coversheet reports and enable the NEXT button for user
	;      selection to process the next DFN for a coversheet report.
	;
RPC(RESULTS,PSBREC)	; Remote Procedure Call Entry Point.
	;
	;*70 piece out mode if exists & reset 0 node for bkwds compatability
	N PSBCLINORD
	S PSBCLINORD=$P(PSBREC(0),U,2),PSBREC(0)=$P(PSBREC(0),U)
	;
	S RESULTS="" D @(PSBREC(0)_"(.RESULTS,.PSBREC)") Q
	Q
	;
ADMLKUP(RESULTS,PSBREC)	;
	;  Lookup ADMinistrations per DFN and search DATE
	;   input - PSBREC(1)  DFN
	;           PSBREC(2)  Search DATE
	;
	;   outpt - RESULTS (array)
	;          (Administrations returned will be dated  = to Search Date
	;
	;
	K RESULTS
	S DFN=PSBREC(1),PSBSRCH=$G(PSBREC(2)) I $G(PSBSRCH)']"" D NOW^%DTC S PSBSRCH=$P(%,".")
	S PSBDT=PSBSRCH,PSBCNT=0 S:PSBSRCH'["." PSBSRCH=PSBSRCH+.9
	S RESULTS(0)=1,RESULTS(1)="-1^No Meds Found!"
	F  S PSBSRCH=$O(^PSB(53.79,"AADT",DFN,PSBSRCH),-1) Q:'PSBSRCH!(PSBSRCH<PSBDT)  D
	.S PSBIEN=""
	.F  S PSBIEN=$O(^PSB(53.79,"AADT",DFN,PSBSRCH,PSBIEN),-1) Q:'PSBIEN  D:'$D(^PSB(53.79,PSBIEN)) KILLAADT  Q:'$D(^PSB(53.79,PSBIEN))  D:$$CHKKEY(PSBIEN)
	..L +^PSB(53.79,PSBIEN):1
	..I  L -^PSB(53.79,PSBIEN)
	..E  Q
	..S PSBXORDN=$$GET1^DIQ(53.79,PSBIEN_",",.11) Q:'$D(^PSB(53.79,"AORDX",DFN,PSBXORDN,PSBSRCH))
	..Q:($$GET1^DIQ(53.79,PSBIEN_",",.06,"I")>PSBSRCH)
	..Q:($$GET1^DIQ(53.79,PSBIEN_",",.09,"I")="N")
	..S PSBCNT=PSBCNT+1,RESULTS(PSBCNT)=PSBIEN
	..S $P(RESULTS(PSBCNT),U,2)=PSBSRCH
	..S $P(RESULTS(PSBCNT),U,3)=$$GET1^DIQ(53.79,PSBIEN_",",.08)
	..S:$$GET1^DIQ(53.79,PSBIEN_",",.26) $P(RESULTS(PSBCNT),U,4)=$$GET1^DIQ(53.79,PSBIEN_",",.26)
	..S $P(RESULTS(PSBCNT),U,5)=$S($$GET1^DIQ(53.79,PSBIEN_",",.09,"I")']"":"U",1:$$GET1^DIQ(53.79,PSBIEN_",",.09,"I"))
	..D  ; Get order information
	...K ^TMP("PSJ1",$J) D EN^PSJBCMA1(DFN,PSBXORDN,1)
	...S $P(RESULTS(PSBCNT),U,3)=$P(^TMP("PSJ1",$J,2),U,2)  ;OItem_" "_Dosage Form
	...S $P(RESULTS(PSBCNT),U,6)=$P(^TMP("PSJ1",$J,4),U)    ;Sched Type
	...K ^TMP("PSJ1",$J)
	..S $P(RESULTS(PSBCNT),U,7)=$$GET1^DIQ(53.79,PSBIEN_",",.06,"I")
	..S $P(RESULTS(PSBCNT),U,8)=$$GETINIT^PSBCSUTX(PSBIEN,"I") ;Get initials of who took action, PSB*3*72
	..S:$D(^PSB(53.79,PSBIEN,.2)) $P(RESULTS(PSBCNT),U,9)=$P(^PSB(53.79,PSBIEN,.2),U),$P(RESULTS(PSBCNT),U,10)=$P(^PSB(53.79,PSBIEN,.2),U,2)
	S:+$G(RESULTS(1))>0 $P(RESULTS(0),U)=PSBCNT
	Q
	;
CHKKEY(PSBIENX)	;
	I '(($D(^XUSEC("PSB MANAGER",DUZ)))!($$GET1^DIQ(53.79,+PSBIENX,.07,"I")=DUZ)) Q 0
	Q 1
	;
PTLKUP(RESULTS,PSBREC)	; Patient lookup handled separately for security
	;   input - PSBREC (array)  User entered patient lookup data
	;
	;   outpt - RESULTS (array)
	;          (Person(s) in PATIENT File (#2) meeting search criteria)
	;
	;
	N PSBNRSWD,PSBINDX,PSBRPT
	K RESULTS,PSBDATA
	K PSBPT S PSBPT(0)=0
	S PSBINDX="" K ^TMP("DILIST",$J)
	I PSBCLINORD'="C" D
	.S PSBDATA=$E(PSBREC(1),1,60)
	.I PSBDATA?12N!(PSBDATA?1.6N)&(DUZ("AG")="I") D  Q  ; HRN/ASUFAC code
	..N X
	..S X=$$HRCNF^APSPFUNC($S($L(PSBDATA)=12:PSBDATA,1:$$PAD($$GET1^DIQ(9999999.06,+DUZ(2),.12))_$$PAD(PSBDATA)))
	..I X<0 D  Q
	...S RESULTS(0)=1,RESULTS(1)="-1^No patients matching '"_PSBDATA_"'."
	..S RESULTS(0)=1
	..S RESULTS(1)=$$PTREC(X)
	.S PSBDATA1=PSBDATA
	.I $E(PSBDATA,$L(PSBDATA)-10,60)=" [MAS WARD]" S PSBINDX="CN" S PSBDATA=$P(PSBDATA," [MAS WARD]")
	.I $E(PSBDATA,$L(PSBDATA)-11,60)=" [NURS UNIT]" S PSBINDX="CN" S PSBDATA=$P(PSBDATA," [NURS UNIT]") D
	..K PSBPT S PSBPT(0)=0
	..S PSBZ=0 F  S PSBZ=$O(^NURSF(211.4,PSBZ)) Q:PSBZ'?.N  S PSBNRSWD=$$GET1^DIQ(211.4,PSBZ_",",.01) I $$UP^XLFSTR(PSBNRSWD)=PSBDATA S PSBY=PSBZ Q  ;Update API, PSB*3*72
	..K PSBDATA S PSBDATA=""
	..S PSBX=0 F  S PSBX=$O(^NURSF(211.4,PSBY,3,PSBX)) Q:PSBX=""  S PSBDATA(PSBX)=$$GET1^DIQ(42,$P(^NURSF(211.4,PSBY,3,PSBX,0),U)_",",.01)
	;
	I PSBCLINORD="C" D
	.;Clinic mode report - get and return array of all DFN's that belong
	.;  to clinics passed in by user.
	.F QQ=0:0 S QQ=$O(PSBREC(QQ)) Q:'QQ  D
	..S PSBRPT(2,QQ,0)=PSBREC(QQ)
	..S PSBRPT(2,"B",PSBREC(QQ),QQ)=""
	.S PSBDATA=1 D CLIN^PSBO(.PSBRPT,.PSBDATA)
	.I $D(PSBDATA)=11 D
	..N DFNXX S PSBCNT=0
	..F DFNXX=0:0 S DFNXX=$O(PSBDATA(DFNXX)) Q:'DFNXX  D
	...S PSBCNT=PSBCNT+1,RESULTS(PSBCNT)=$$PTREC(DFNXX)
	.; check if any data found
	.I '$D(RESULTS) D
	..S RESULTS(0)=1
	..S RESULTS(1)="-1^No patients matching Clinic Search List"
	.E  D
	..S RESULTS(0)=+$O(RESULTS(""),-1)
	..S PSBINDX="CN"
	I PSBCLINORD="C",+RESULTS(1)=-1 Q
	;
	I PSBINDX="" S PSBINDX=$S(PSBDATA?9N.1P:"SSN",PSBDATA?4N.1P:"BS5^BS",1:PSBINDX)
	I ($O(PSBDATA(""))'>0) D FIND^DIC(2,"","@;.01;.02;.03;.09","MP",PSBDATA,200,PSBINDX)
	I ($O(PSBDATA(""))>0) D
	.S PSBX="",PSBY=1 F  S PSBX=$O(PSBDATA(PSBX)) Q:PSBX=""  D  K ^TMP("DILIST",$J) Q:$P(PSBPT(0),U,3)=1
	..D FIND^DIC(2,"","@;.01;.02;.03;.09","MPO",PSBDATA(PSBX),200,PSBINDX)
	..S PSBZ=0 F  S PSBZ=$O(^TMP("DILIST",$J,PSBZ)) Q:PSBZ=""  S PSBPT(PSBY,0)=^TMP("DILIST",$J,PSBZ,0),PSBPT(0)=PSBY,PSBY=PSBY+1 I PSBY>200 S $P(PSBPT(0),U,3)=1
	K:+$G(PSBPT(0))=0 PSBPT
	I $D(PSBPT) M ^TMP("DILIST",$J)=PSBPT
	I $P($G(^TMP("DILIST",$J,0)),U,3) D  Q
	.S RESULTS(0)=1,RESULTS(1)="-1^Too many patients found matching '"_PSBDATA1_"'. Please be more specific."
	I $D(^TMP("DILIST",$J,0)) D
	.F PSBXX=0:0 S PSBXX=$O(^TMP("DILIST",$J,PSBXX)) Q:'PSBXX  D
	..S RESULTS(PSBXX)=$$PTREC(+^TMP("DILIST",$J,PSBXX,0))
	I '$D(RESULTS) S RESULTS(0)=1,RESULTS(1)="-1^No patients matching '"_PSBDATA1_"'"
	E  S RESULTS(0)=+$O(RESULTS(""),-1)
	Q
	;
PTREC(DFN)	;
	; Extrinsic to return a Pt Rec  in standard list format
	N PSBXX
	S PSBXX=$G(^DPT(DFN,0))
	S PSBXX=DFN_U_$P(PSBXX,U,1)_U_$P(PSBXX,U,2)_U_$P(PSBXX,U,3)_U_$S(DUZ("AG")="I":$$HRCNF^BDGF2(DFN,DUZ(2)),1:$P(PSBXX,U,9))
	S $P(PSBXX,U,6)=$$GET1^DIQ(2,DFN_",",.1)
	S $P(PSBXX,U,7)=$$GET1^DIQ(2,DFN_",",.101)
	S $P(PSBXX,U,10)=$$DOB^DPTLK1(DFN)
	S $P(PSBXX,U,11)=$S(DUZ("AG")="I":$$HRN^AUPNPAT(DFN,DUZ(2)),1:$$SSN^DPTLK1(DFN))
	Q PSBXX
	;
SELECTAD(RESULTS,PSBREC)	; Select Administration
	;
	;  Process the SELECTed ADministration
	;   input - PSBREC(1) = PSB Med Log File (#53.79) IEN
	;
	;
	;   outpt - RESULTS (array)
	;          (Administration data that can be subsequently updated via GUI MED LOG EDIT)
	;
	;
	K RESULTS,PSBXIV,PSBPTCHX
	N PSBIEN,PSBCNT,PSBX S PSBIEN=PSBREC(1),PSBCNT=2
	; Construct form data    Patient^SSN^Med^BagID^AdminStat^AdminD/T^InjctSt^PRNReas^PRNEff^DisDrg^UntsGiven^Unt^
	S RESULTS(0)=0
	D:$$CHKKEY(PSBIEN)
	.L +^PSB(53.79,PSBIEN):1
	.E  I $P(^PSB(53.79,PSBIEN,0),U,9)]"" S PSBCNT=1,RESULTS(1)="-1^ This administration is being modified by another process at this moment." L -^PSB(53.79,PSBIEN) Q
	.S $P(RESULTS(1),U)=PSBIEN
	.S $P(RESULTS(1),U,2)=$$GET1^DIQ(53.79,PSBIEN_",",.01,"I")
	.S $P(RESULTS(1),U,3)=$$GET1^DIQ(53.79,PSBIEN_",",.01)
	.S $P(RESULTS(1),U,4)=$$GET1^DIQ(2,$P(RESULTS(1),U,2)_",",.09)
	.S $P(RESULTS(1),U,5)=$$GET1^DIQ(53.79,PSBIEN_",",.08,"I")_"~"_$$GET1^DIQ(53.79,PSBIEN_",",.08)
	.S $P(RESULTS(1),U,6)=$$GET1^DIQ(53.79,PSBIEN_",",.26)
	.S $P(RESULTS(1),U,7)=$S($$GET1^DIQ(53.79,PSBIEN_",",.09,"I")']"":"U",1:$$GET1^DIQ(53.79,PSBIEN_",",.09,"I"))
	.;
	.D:($P(RESULTS(1),U,7)'="N")&($P(RESULTS(1),U,7)]"") SELSTTUS(.RESULTS)  ; Amend RESULTS(1) data...
	.S Y=$E($$GET1^DIQ(53.79,PSBIEN_",",.06,"I"),1,12) D DD^%DT
	.S $P(RESULTS(1),U,8)=Y
	.S $P(RESULTS(1),U,9)=$$GET1^DIQ(53.79,PSBIEN_",",.06,"I")
	.S $P(RESULTS(1),U,10)=$$GET1^DIQ(53.79,PSBIEN_",",.16)
	.S $P(RESULTS(1),U,16)=0
	.S $P(RESULTS(2),U)=$$GET1^DIQ(53.79,PSBIEN_",",.21),$P(RESULTS(2),U,2)=$$GET1^DIQ(53.79,PSBIEN_",",.22)
	.; Determine if there are any active IVs/Patchs per order
	.D:$G(PSBPTCHX)
	..S PSBX="",PSBX="^PSB(53.79,""APATCH"","_$P(RESULTS(1),U,2)_")"
	..F  S PSBX=$Q(@PSBX) Q:PSBX=""  Q:$QS(PSBX,3)'=$P(RESULTS(1),U,2)  D  Q:$P(RESULTS(1),U,16)
	...S PSBXX=$QS(PSBX,5),PSBXXX=$S(($P(^PSB(53.79,PSBXX,0),U,9)="G")&(PSBXX'=PSBIEN):1,1:0)
	...I PSBXXX&($P(^PSB(53.79,PSBXX,.1),U)=$P(RESULTS(1),U,15)) S $P(RESULTS(1),U,16)=1
	.D:$G(PSBXIV)
	..S PSBX="",PSBX="^PSB(53.79,""AUID"","_$P(RESULTS(1),U,2)_")"
	..F  S PSBX=$Q(@PSBX) Q:PSBX=""  Q:$QS(PSBX,3)'=$P(RESULTS(1),U,2)  Q:$QS(PSBX,4)>$P(RESULTS(1),U,15)  D  Q:$P(RESULTS(1),U,16)
	...Q:$QS(PSBX,4)'=$P(RESULTS(1),U,15)
	...S PSBXX=$QS(PSBX,6) S:(PSBXX'=PSBIEN) $P(RESULTS(1),U,16)=$S($P(^PSB(53.79,PSBXX,0),U,9)="I":1,$P(^PSB(53.79,PSBXX,0),U,9)="S":1,1:0)
	.;
	.; LOOP - Place DD in RESULTS
	.S PSBX=0 F  S PSBX=$O(^PSB(53.79,PSBIEN,.5,PSBX)) Q:'(+PSBX)  D
	..S PSBCNT=PSBCNT+1
	..S RESULTS(PSBCNT)="DD^"_$P(^PSB(53.79,PSBIEN,.5,PSBX,0),U)_"^"_$$GET1^DIQ(50,$P(^PSB(53.79,PSBIEN,.5,PSBX,0),U)_",",.01)
	..S $P(RESULTS(PSBCNT),U,4)=$P(^PSB(53.79,PSBIEN,.5,PSBX,0),U,2)_"^"_$P(^PSB(53.79,PSBIEN,.5,PSBX,0),U,3)_"^"_$P(^PSB(53.79,PSBIEN,.5,PSBX,0),U,4)
	..S:$P(RESULTS(PSBCNT),U,4)?1"."1.N $P(RESULTS(PSBCNT),U,4)=0_+$P(RESULTS(PSBCNT),U,4)
	..S:$P(RESULTS(PSBCNT),U,5)?1"."1.N $P(RESULTS(PSBCNT),U,5)=0_+$P(RESULTS(PSBCNT),U,5)
	.; LOOP - Place ADD in RESULTS
	.S PSBX=0 F  S PSBX=$O(^PSB(53.79,PSBIEN,.6,PSBX)) Q:'(+PSBX)  D
	..S PSBCNT=PSBCNT+1
	..S RESULTS(PSBCNT)="ADD^"_$P(^PSB(53.79,PSBIEN,.6,PSBX,0),U)_"^"_$$GET1^DIQ(52.6,$P(^PSB(53.79,PSBIEN,.6,PSBX,0),U)_",",.01)
	..S $P(RESULTS(PSBCNT),U,4)=$P(^PSB(53.79,PSBIEN,.6,PSBX,0),U,2)_"^"_$P(^PSB(53.79,PSBIEN,.6,PSBX,0),U,3)_"^"_$P(^PSB(53.79,PSBIEN,.6,PSBX,0),U,4)
	.; LOOP - Place SOL in RESULTS
	.S PSBX=0 F  S PSBX=$O(^PSB(53.79,PSBIEN,.7,PSBX)) Q:'(+PSBX)  D
	..S PSBCNT=PSBCNT+1
	..S RESULTS(PSBCNT)="SOL^"_$P(^PSB(53.79,PSBIEN,.7,PSBX,0),U)_"^"_$$GET1^DIQ(52.7,$P(^PSB(53.79,PSBIEN,.7,PSBX,0),U)_",",.01)
	..S $P(RESULTS(PSBCNT),U,4)=$P(^PSB(53.79,PSBIEN,.7,PSBX,0),U,2)_"^"_$P(^PSB(53.79,PSBIEN,.7,PSBX,0),U,3)_"^"_$P(^PSB(53.79,PSBIEN,.7,PSBX,0),U,4)
	.L -^PSB(53.79,PSBIEN)
	S:PSBCNT>0 RESULTS(0)=PSBCNT
	Q
	;
SELSTTUS(RESULTS)	;
	; Provide the SELectable STaTUS
	;
	; Get TAB, ScheduleType, Current Status, provide Selectable Staus(s) in ^8
	N PSBORTYP,PSBIVTYP,PSBINTSY,PSBCHMTY,PSBIVPSH,PSBXTAB
	K ^TMP("PSJ1",$J) D EN^PSJBCMA1($$GET1^DIQ(53.79,PSBIEN_",",.01,"I"),$$GET1^DIQ(53.79,PSBIEN_",",.11),1)
	I ^TMP("PSJ1",$J,0)>0 D
	.S PSBORTYP=$TR($P(^TMP("PSJ1",$J,0),U,3),"1234567890"),PSBIVTYP=$P(^TMP("PSJ1",$J,0),U,6)
	.S PSBINTSY=$P(^TMP("PSJ1",$J,0),U,7),PSBCHMTY=$P(^TMP("PSJ1",$J,0),U,8),PSBIVPSH=+$P($G(^TMP("PSJ1",$J,1,0)),U,2)
	.S:$$IVPTAB^PSBVDLU3(PSBORTYP,PSBIVTYP,PSBINTSY,PSBCHMTY,PSBIVPSH) PSBXTAB="PB"
	.D:'$D(PSBXTAB)
	..I PSBORTYP="U" S PSBXTAB="UD"
	..I PSBORTYP="V" S PSBXTAB="IV"
	; Set Results(1) and other flags...
	I ^TMP("PSJ1",$J,0)>0 D
	.S $P(RESULTS(1),U,13)=$P(^TMP("PSJ1",$J,4),U)
	.S $P(RESULTS(1),U,14)=$P(^TMP("PSJ1",$J,1),U,10)
	.S $P(RESULTS(1),U,15)=$P(^TMP("PSJ1",$J,0),U,3)
	.I (PSBXTAB="UD"),($P(^TMP("PSJ1",$J,2),U,6)="PATCH") S PSBPTCHX=1
	.I PSBXTAB="IV" S PSBXIV=1
	.S:$G(PSBXTAB)]"" $P(RESULTS(1),U,11)=$G(PSBXTAB)
	K ^TMP("PSJ1",$J)
	Q
	;
KILLAADT	;
	;   Here because there is an errorant index entry via version 1.0/2.0
	;   Cleansing!
	;
	K ^PSB(53.79,"AADT",DFN,PSBSRCH,PSBIEN)
	Q
	;
PAD(VAL)	; Return VAL with leading zeroes padded to 6 characters
	Q $E("000000",1,6-$L(VAL))_VAL
