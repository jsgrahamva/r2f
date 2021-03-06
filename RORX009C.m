RORX009C	;HCIOFO/SG - PRESCRIPTION UTILIZ. (STORE) ;12/16/05 9:19am
	;;1.5;CLINICAL CASE REGISTRIES;**21**;Feb 17, 2006;Build 45
	;
	;******************************************************************************
	;                       --- ROUTINE MODIFICATION LOG ---
	;        
	;PKG/PATCH    DATE        DEVELOPER    MODIFICATION
	;-----------  ----------  -----------  ----------------------------------------
	;ROR*1.5*21   SEP 2013    T KOPP       Added ICN as last report column if
	;                                      additional identifier option selected
	;******************************************************************************
	;
	Q
	;
	;***** DRUGS
	;
	; SECTION       IEN of the parent element
	;
	; SUBS
	;
	; NODE          Closed root of the category section
	;               in the temporary global
	;
	; TBLNAME
	;
	; Return Values:
	;       <0  Error code
	;        0  Ok
	;
DRUGS(SECTION,SUBS,NODE,TBLNAME)	;
	Q:$D(@NODE@(SUBS))<10 0
	N IEN,ITEM,NAME,NRXNAME,NUM,RC,TMP
	S TABLE=$$ADDVAL^RORTSK11(RORTSK,TBLNAME,,SECTION)
	Q:TABLE<0 TABLE
	D ADDATTR^RORTSK11(RORTSK,TABLE,"TABLE",TBLNAME)
	S NRXNAME=$E(SUBS,1,2)_"NRX"
	;---
	S NUM="",RC=0
	F  S NUM=$O(@NODE@(SUBS,"B",NUM),-1)  Q:NUM=""  D  Q:RC
	. S NAME=""
	. F  S NAME=$O(@NODE@(SUBS,"B",NUM,NAME))  Q:NAME=""  D  Q:RC
	. . S IEN=""
	. . F  S IEN=$O(@NODE@(SUBS,"B",NUM,NAME,IEN))  Q:IEN=""  D  Q:RC
	. . . S ITEM=$$ADDVAL^RORTSK11(RORTSK,"DRUG",,TABLE)
	. . . D ADDVAL^RORTSK11(RORTSK,"NAME",NAME,ITEM,1)
	. . . S TMP=+$G(@NODE@(SUBS,IEN,"P"))
	. . . D ADDVAL^RORTSK11(RORTSK,"NP",TMP,ITEM,3)
	. . . D ADDVAL^RORTSK11(RORTSK,NRXNAME,NUM,ITEM,3)
	. . . S TMP=$G(@NODE@(SUBS,IEN,"M"))
	. . . D ADDVAL^RORTSK11(RORTSK,"MAXNRPP",+$P(TMP,U),ITEM,3)
	. . . D ADDVAL^RORTSK11(RORTSK,"MAXNP",+$P(TMP,U,2),ITEM,3)
	Q $S(RC<0:RC,1:0)
	;
	;***** STORES THE REPORT DATA
	;
	; REPORT        IEN of the REPORT element
	;
	; Return Values:
	;       <0  Error code
	;        0  Ok
	;       >0  Number of non-fatal errors
	;
STORE(REPORT)	;
	N RORSONLY      ; Output summary only
	;
	N ECNT,NODE,RC,TMP
	S RORSONLY=$$SMRYONLY^RORXU006(),(ECNT,RC)=0
	S NODE=$NA(^TMP("RORX009",$J))
	Q:$D(@NODE)<10 0
	;--- Outpatient data
	S RC=$$LOOP^RORTSK01(0)  Q:RC<0 RC
	S RC=$$STOREOP(REPORT,NODE)
	I RC  Q:RC<0  S ECNT=ECNT+1
	;--- Inpatient data
	S RC=$$LOOP^RORTSK01(.33)  Q:RC<0 RC
	S RC=$$STOREIP(REPORT,NODE)
	I RC  Q:RC<0  S ECNT=ECNT+1
	;--- Highest utilization summary
	S RC=$$LOOP^RORTSK01(.66)  Q:RC<0 RC
	S RC=$$STORESUM(REPORT,NODE)
	I RC  Q:RC<0  S ECNT=ECNT+1
	;---
	Q $S(RC<0:RC,1:ECNT)
	;
	;***** INPATIENT DATA
	;
	; PRNTELMT      IEN of the parent element
	;
	; NODE          Closed root of the category section
	;               in the temporary global
	;
	; Return Values:
	;       <0  Error code
	;        0  Ok
	;
STOREIP(PRNTELMT,NODE)	;
	Q:$D(@NODE@("IP"))<10 0
	N BUF,COUNT,DFN,ITEM,MAXUTNUM,NAME,NRX,RC,SECTION,TABLE,TMP
	S MAXUTNUM=$$PARAM^RORTSK01("MAXUTNUM")
	S SECTION=$$ADDVAL^RORTSK11(RORTSK,"INPATIENTS",,PRNTELMT)
	Q:SECTION<0 SECTION
	S RC=0
	;--- Number of doses
	S TABLE=$$ADDVAL^RORTSK11(RORTSK,"DOSES",,SECTION)
	Q:TABLE<0 TABLE
	D ADDATTR^RORTSK11(RORTSK,TABLE,"TABLE","DOSES")
	S NRX=""
	F  S NRX=$O(@NODE@("IPRX",NRX),-1)  Q:NRX=""  D
	. S ITEM=$$ADDVAL^RORTSK11(RORTSK,"ITEM",,TABLE)
	. D ADDVAL^RORTSK11(RORTSK,"NP",$P(@NODE@("IPRX",NRX),U),ITEM,3)
	. D ADDVAL^RORTSK11(RORTSK,"IPNRX",NRX,ITEM,3)
	;--- Drugs
	S RC=$$DRUGS(SECTION,"IPD",NODE,"DRUGS_DOSES")  Q:RC<0 RC
	;--- Patients with highest utlization
	I MAXUTNUM>0  D  Q:RC<0 RC
	. S TABLE=$$ADDVAL^RORTSK11(RORTSK,"HU_DOSES",,SECTION)
	. I TABLE<0  S RC=TABLE  Q
	. D ADDATTR^RORTSK11(RORTSK,TABLE,"TABLE","HU_DOSES")
	. S NRX="",(COUNT,RC)=0
	. F  S NRX=$O(@NODE@("IPRX",NRX),-1)  Q:NRX=""  D  Q:RC
	. . S RC=$$LOOP^RORTSK01()  Q:RC<0
	. . S NAME=""
	. . F  S NAME=$O(@NODE@("IPRX",NRX,NAME))  Q:NAME=""  D  Q:RC
	. . . S DFN=""
	. . . F  S DFN=$O(@NODE@("IPRX",NRX,NAME,DFN))  Q:DFN=""  D  Q:RC
	. . . . S COUNT=COUNT+1  I COUNT>MAXUTNUM  S RC=1  Q
	. . . . S BUF=$G(@NODE@("IP",DFN))
	. . . . S ITEM=$$ADDVAL^RORTSK11(RORTSK,"PATIENT",,TABLE)
	. . . . D ADDVAL^RORTSK11(RORTSK,"NAME",NAME,ITEM,1)
	. . . . D ADDVAL^RORTSK11(RORTSK,"LAST4",$P(BUF,U),ITEM,2)
	. . . . D ADDVAL^RORTSK11(RORTSK,"DOD",$P(BUF,U,3),ITEM,1)
	. . . . D ADDVAL^RORTSK11(RORTSK,"IPNRX",NRX,ITEM,3)
	. . . . D ADDVAL^RORTSK11(RORTSK,"ND",$P(BUF,U,5),ITEM,3)
	. . . . I $$PARAM^RORTSK01("PATIENTS","ICN") D
	. . . . . D ADDVAL^RORTSK11(RORTSK,"ICN",$P(BUF,U,6),ITEM,1)
	;--- Summary
	D ADDVAL^RORTSK11(RORTSK,"NP",+$G(@NODE@("IP")),SECTION)
	D ADDVAL^RORTSK11(RORTSK,"IPNRX",+$G(@NODE@("IPRX")),SECTION)
	D ADDVAL^RORTSK11(RORTSK,"ND",+$G(@NODE@("IPD")),SECTION)
	Q 0
	;
	;***** OUTPATIENT DATA
	;
	; PRNTELMT      IEN of the parent element
	;
	; NODE          Closed root of the category section
	;               in the temporary global
	;
	; Return Values:
	;       <0  Error code
	;        0  Ok
	;
STOREOP(PRNTELMT,NODE)	;
	Q:$D(@NODE@("OP"))<10 0
	N BUF,COUNT,DFN,ITEM,MAXUTNUM,NAME,NRX,RC,SECTION,TABLE,TMP
	S MAXUTNUM=$$PARAM^RORTSK01("MAXUTNUM")
	S SECTION=$$ADDVAL^RORTSK11(RORTSK,"OUTPATIENTS",,PRNTELMT)
	Q:SECTION<0 SECTION
	S RC=0
	;--- Number of fills
	S TABLE=$$ADDVAL^RORTSK11(RORTSK,"FILLS",,SECTION)
	Q:TABLE<0 TABLE
	D ADDATTR^RORTSK11(RORTSK,TABLE,"TABLE","FILLS")
	S NRX=""
	F  S NRX=$O(@NODE@("OPRX",NRX),-1)  Q:NRX=""  D
	. S ITEM=$$ADDVAL^RORTSK11(RORTSK,"ITEM",,TABLE)
	. D ADDVAL^RORTSK11(RORTSK,"NP",$P(@NODE@("OPRX",NRX),U),ITEM,3)
	. D ADDVAL^RORTSK11(RORTSK,"OPNRX",NRX,ITEM,3)
	;--- Drugs
	S RC=$$DRUGS(SECTION,"OPD",NODE,"DRUGS_FILLS")  Q:RC<0 RC
	;--- Patients with highest utlization
	I MAXUTNUM>0  D  Q:RC<0 RC
	. S TABLE=$$ADDVAL^RORTSK11(RORTSK,"HU_FILLS",,SECTION)
	. I TABLE<0  S RC=TABLE  Q
	. D ADDATTR^RORTSK11(RORTSK,TABLE,"TABLE","HU_FILLS")
	. S NRX="",(COUNT,RC)=0
	. F  S NRX=$O(@NODE@("OPRX",NRX),-1)  Q:NRX=""  D  Q:RC
	. . S RC=$$LOOP^RORTSK01()  Q:RC<0
	. . S NAME=""
	. . F  S NAME=$O(@NODE@("OPRX",NRX,NAME))  Q:NAME=""  D  Q:RC
	. . . S DFN=""
	. . . F  S DFN=$O(@NODE@("OPRX",NRX,NAME,DFN))  Q:DFN=""  D  Q:RC
	. . . . S COUNT=COUNT+1  I COUNT>MAXUTNUM  S RC=1  Q
	. . . . S BUF=$G(@NODE@("OP",DFN))
	. . . . S ITEM=$$ADDVAL^RORTSK11(RORTSK,"PATIENT",,TABLE)
	. . . . D ADDVAL^RORTSK11(RORTSK,"NAME",NAME,ITEM,1)
	. . . . D ADDVAL^RORTSK11(RORTSK,"LAST4",$P(BUF,U),ITEM,2)
	. . . . D ADDVAL^RORTSK11(RORTSK,"DOD",$P(BUF,U,3),ITEM,1)
	. . . . D ADDVAL^RORTSK11(RORTSK,"OPNRX",NRX,ITEM,3)
	. . . . D ADDVAL^RORTSK11(RORTSK,"ND",$P(BUF,U,5),ITEM,3)
	. . . . I $$PARAM^RORTSK01("PATIENTS","ICN") D
	. . . . . D ADDVAL^RORTSK11(RORTSK,"ICN",$P(BUF,U,6),ITEM,1)
	;--- Summary
	D ADDVAL^RORTSK11(RORTSK,"NP",+$G(@NODE@("OP")),SECTION)
	D ADDVAL^RORTSK11(RORTSK,"OPNRX",+$G(@NODE@("OPRX")),SECTION)
	D ADDVAL^RORTSK11(RORTSK,"ND",+$G(@NODE@("OPD")),SECTION)
	Q 0
	;
	;***** SUMMARY DATA
	;
	; PRNTELMT      IEN of the parent element
	;
	; NODE          Closed root of the category section
	;               in the temporary global
	;
	; Return Values:
	;       <0  Error code
	;        0  Ok
	;
STORESUM(PRNTELMT,NODE)	;
	N BUF,DFN,DOD,IPNRX,ITEM,LAST4,MAXUTNUM,NAME,NRX,OPNRX,RC,SECTION,TABLE,TMP
	S MAXUTNUM=$$PARAM^RORTSK01("MAXUTNUM")
	Q:($D(@NODE@("SUMRX"))<10)!(MAXUTNUM'>0) 0
	;---
	S SECTION=$$ADDVAL^RORTSK11(RORTSK,"SUMMARY",,PRNTELMT)
	Q:SECTION<0 SECTION
	S RC=0
	;--- Patients with highest utlization
	S TABLE=$$ADDVAL^RORTSK11(RORTSK,"HU_NRX",,SECTION)
	I TABLE<0  S RC=TABLE  Q
	D ADDATTR^RORTSK11(RORTSK,TABLE,"TABLE","HU_NRX")
	;---
	S NRX="",RC=0
	F  S NRX=$O(@NODE@("SUMRX",NRX),-1)  Q:NRX=""  D  Q:RC
	. S RC=$$LOOP^RORTSK01()  Q:RC<0
	. S NAME=""
	. F  S NAME=$O(@NODE@("SUMRX",NRX,NAME))  Q:NAME=""  D  Q:RC
	. . S DFN=""
	. . F  S DFN=$O(@NODE@("SUMRX",NRX,NAME,DFN))  Q:DFN=""  D  Q:RC
	. . . S ITEM=$$ADDVAL^RORTSK11(RORTSK,"PATIENT",,TABLE)
	. . . S (IPNRX,OPNRX)=0
	. . . S BUF=$G(@NODE@("OP",DFN))
	. . . S:BUF'="" LAST4=$P(BUF,U),DOD=$P(BUF,U,3),OPNRX=$P(BUF,U,4)
	. . . S BUF=$G(@NODE@("IP",DFN))
	. . . S:BUF'="" LAST4=$P(BUF,U),DOD=$P(BUF,U,3),IPNRX=$P(BUF,U,4)
	. . . D ADDVAL^RORTSK11(RORTSK,"NAME",NAME,ITEM,1)
	. . . D ADDVAL^RORTSK11(RORTSK,"LAST4",LAST4,ITEM,2)
	. . . D ADDVAL^RORTSK11(RORTSK,"DOD",DOD,ITEM,1)
	. . . D ADDVAL^RORTSK11(RORTSK,"OPNRX",OPNRX,ITEM,3)
	. . . D ADDVAL^RORTSK11(RORTSK,"IPNRX",IPNRX,ITEM,3)
	. . . S TMP=+$G(@NODE@("SUMRX",NRX,NAME,DFN))
	. . . D ADDVAL^RORTSK11(RORTSK,"ND",TMP,ITEM,3)
	;---
	Q 0
