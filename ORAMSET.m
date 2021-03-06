ORAMSET	; ISL/JER - Anticoagulation Setup ;11/20/14  11:12
	;;3.0;ORDER ENTRY/RESULTS REPORTING;**307,361,391**;Dec 17, 1997;Build 11
	;;Per VHA Directive 2004-038, this routine should not be modified
	Q
	;
	;  External References:
	;  $$GET1^DIQ             ICR #2056
	;  $$FMDIFF/$$NOW^XLFDT   ICR #10103
	;  $$TITLE^XLFSTR         ICR #10104
	;  $$GET^XPAR             ICR #2263
	;  $$KSP^XUPARAM          ICR #2541
	;
SET	; Enter Parameters
	N ORAMDIV,ORAMPARM,DIRUT,DUOUT,DTOUT,ORT0,ORAMTOUT K DIROUT
	S ORAMDIV=$$GETDIV Q:+ORAMDIV'>0
	S ORT0=$$NOW^XLFDT
	D TED^XPAREDIT("ORAM PARAMETERS","B",ORAMDIV) Q:+$G(DIROUT)!+$$TIMEOUT(ORT0)
	; If Consult Link Enabled, ask Consult Request Service
	I +$$GET^XPAR(ORAMDIV,"ORAM CONSULT LINK ENABLED") D  Q:+$D(DUOUT)!+$D(DTOUT)
	. S ORAMPARM=+$$GETPARM("ORAM CONSULT REQUEST SERVICE")_U_"Consult Request Service" Q:+ORAMPARM'>0
	. D EDIT^XPAREDIT(ORAMDIV,ORAMPARM)
	; Ask PCE Link Enabled
	S ORAMPARM=+$$GETPARM("ORAM PCE LINK ENABLED")_U_"PCE Link Enabled" Q:+ORAMPARM'>0
	D EDIT^XPAREDIT(ORAMDIV,ORAMPARM) Q:+$G(DIROUT)!+$G(DIRUT)!+$D(DTOUT)
	; Continue with PCE Parameter Template if TRUE
	I +$$GET^XPAR(ORAMDIV,"ORAM PCE LINK ENABLED") D  Q:+$G(DIROUT)!+$G(ORAMTOUT)
	. S ORT0=$$NOW^XLFDT
	. D TED^XPAREDIT("ORAM PCE PARAMETERS","B",ORAMDIV)
	. S ORAMTOUT=$$TIMEOUT(ORT0)
	; Continue with Letter Template
	D TED^XPAREDIT("ORAM LETTER PARAMETERS","B",ORAMDIV)
	Q
	;
SETDIV	; Enter Site Parameters
	N ORAMDIV,DIRUT,DUOUT,DTOUT K DIROUT
	S ORAMDIV=$$GETDIV Q:+ORAMDIV'>0
	D TED^XPAREDIT("ORAM SITE PARAMETERS","BA",ORAMDIV)
	Q
	;
SETCLIN	; Enter Clinic Parameters
	N ORAMCLIN,DIRUT,DUOUT,DTOUT K DIROUT
	S ORAMCLIN=$$SELLOC Q:+ORAMCLIN'>0
	D TED^XPAREDIT("ORAM CLINIC PARAMETERS","BA",ORAMCLIN)
	Q
	;
TIMEOUT(T0)	; Evaluate whether TED^XPAREDIT timed-out (since it NEWs DTOUT and DIRUT)
	Q $S($$FMDIFF^XLFDT($$NOW^XLFDT,T0,2)'<DTIME:1,1:0)
	;
GETCLINS(RESULT)	; Get Clinics
	N LIST,ERR,ORAME,ORAMI S ORAME="",ORAMI=0
	D ENVAL^XPAR(.LIST,"ORAM CLINIC NAME",1,.ERR)
	I 'LIST S RESULT(0)=0 Q
	F  S ORAME=$O(LIST(ORAME)) Q:ORAME']""  D
	. N ORAMV S ORAMV=$G(LIST(ORAME,1)) Q:ORAMV']""
	. S ORAMI=ORAMI+1,RESULT(ORAMI)=ORAMV_U_ORAME
	. S RESULT(0)=ORAMI
	Q
	;
CLIN4PT(RESULT,ORAMDFN)	; Get the Clinic which is following the patient
	N ORAMCL
	S ORAMCL=$P($G(^ORAM(103,ORAMDFN,6)),U,2)
	S RESULT=$S(+ORAMCL>0:ORAMCL_";SC(",1:0)
	Q
	;
GET(RESULT,ORAMENT,ORVDT)	; Get Parameters
	N ADD1,ADD2,ADD3,DNOTE,ENOTE,INOTE,ATEAM,CBCQO,CTEAM,CFAX,CPHONE,ORAMALL,IMPLDT,ICDCP
	N CENAB,CSVC,CPLXPH,IVST,LTR,ORIENT,SMPLPH,SVST,DSSID,DSSUNIT,HCT,HCTNM,NLABTM,TOLLFREE
	N INRQO,MCNM,NCLOC,PCEON,PHCLIN,POCNM,RPATH,SIGNM,SIGTTL,SITENM,VLOC,PILLSTR,ICDC,DPIND
	N SICDC,DSIND,ICDCS
	S ORVDT=$G(ORVDT,DT),ICDCS="ICD-9-CM"
	S IMPLDT=$$IMPDATE^LEXU("10D")
	S ORAMENT=$S($G(ORAMENT)]"":$G(ORAMENT),1:"ALL"),DPIND=""
	S ORAMALL=$S(ORAMENT["ALL":ORAMENT,1:"ALL^"_ORAMENT)
	S ADD1=$$GET^XPAR(ORAMENT,"ORAM ADDRESS LINE 1",1,"I")
	S ADD2=$$GET^XPAR(ORAMENT,"ORAM ADDRESS LINE 2",1,"I")
	S ADD3=$$GET^XPAR(ORAMENT,"ORAM ADDRESS LINE 3",1,"I")
	S DNOTE=$$GET^XPAR(ORAMALL,"ORAM DISCHARGE NOTE",1,"I")
	S ENOTE=$$GET^XPAR(ORAMALL,"ORAM INTERIM NOTE",1,"I")
	S INOTE=$$GET^XPAR(ORAMALL,"ORAM INITIAL NOTE",1,"I")
	S ATEAM=$$GET^XPAR(ORAMENT,"ORAM TEAM LIST (ALL)",1,"I")
	S CTEAM=$$GET^XPAR(ORAMENT,"ORAM TEAM LIST (COMPLEX)",1,"I")
	S CBCQO=$$GET^XPAR(ORAMALL,"ORAM CBC QUICK ORDER",1,"I")
	S CFAX=$$GET^XPAR(ORAMENT,"ORAM CLINIC FAX NUMBER",1,"I")
	S CPHONE=$$GET^XPAR(ORAMENT,"ORAM CLINIC PHONE NUMBER",1,"I")
	S TOLLFREE=$$GET^XPAR(ORAMENT,"ORAM TOLL FREE PHONE",1,"I")
	S CENAB=$$GET^XPAR(ORAMENT,"ORAM CONSULT LINK ENABLED",1,"I")
	S CSVC=$$GET^XPAR(ORAMENT,"ORAM CONSULT REQUEST SERVICE",1,"E")
	S CPLXPH=$$GET^XPAR(ORAMALL,"ORAM CPT FOR COMPLEX PHONE",1,"I")
	S IVST=$$GET^XPAR(ORAMALL,"ORAM CPT FOR INITIAL VISIT",1,"I")
	S LTR=$$GET^XPAR(ORAMALL,"ORAM CPT FOR LETTER TO PT",1,"I")
	S ORIENT=$$GET^XPAR(ORAMALL,"ORAM CPT FOR ORIENTATION",1,"I")
	S SMPLPH=$$GET^XPAR(ORAMALL,"ORAM CPT FOR SIMPLE PHONE",1,"I")
	S SVST=$$GET^XPAR(ORAMALL,"ORAM CPT FOR SUBSEQUENT VISIT",1,"I")
	S DSSID=$$GET^XPAR(ORAMALL,"ORAM DSS ID",1,"I")
	S DSSUNIT=$$GET^XPAR(ORAMALL,"ORAM DSS UNIT",1,"I")
	S HCT=$$GET^XPAR(ORAMALL,"ORAM HCT/HGB REFERENCE",1,"B")
	S HCTNM=$P(HCT,U,2)
	S HCT=$P(HCT,U)
	S INRQO=$$GET^XPAR(ORAMALL,"ORAM INR QUICK ORDER",1,"I")
	S MCNM=$$GET^XPAR(ORAMALL,"ORAM MEDICAL CENTER NAME",1,"I")
	S NCLOC=$$GET^XPAR(ORAMENT,"ORAM NON-COUNT LOCATION",1,"I")
	S PCEON=$$GET^XPAR(ORAMENT,"ORAM PCE LINK ENABLED",1,"I")
	; If I10 not yet implemented use I9 auto-prim indic, else use I10
	I (IMPLDT>ORVDT) D  I 1
	. S ICDC=$$GET^XPAR(ORAMENT,"ORAM AUTO PRIMARY INDICATION",1,"E"),ICDCS="ICD-9-CM"
	E  D
	. S ICDC=$$GET^XPAR(ORAMENT,"ORAM I10 AUTO PRIM INDICATION",1,"E"),ICDCS="ICD-10-CM"
	I ICDC]"" D  I 1
	. N ICDDESC
	. D ICDDESC^ICDXCODE("DIAGNOSIS",ICDC,DT,.ICDDESC)
	. S DPIND=ICDC_U_$$TITLE^XLFSTR($G(ICDDESC(1)))_" ("_ICDCS_" "_ICDC_")"
	E  S DPIND="^"
	; If I10 not yet implemented use I9 auto-secondary indic, else use I10
	I (IMPLDT>ORVDT) D  I 1
	. S SICDC=$$GET^XPAR(ORAMENT,"ORAM AUTO SECONDARY INDICATION",1,"E"),ICDCS="ICD-9-CM"
	E  D
	. S SICDC=$$GET^XPAR(ORAMENT,"ORAM I10 AUTO SEC INDICATION",1,"E"),ICDCS="ICD-10-CM"
	I SICDC]"" D  I 1
	. N ICDDESC
	. D ICDDESC^ICDXCODE("DIAGNOSIS",SICDC,DT,.ICDDESC)
	. S DSIND=SICDC_U_$$TITLE^XLFSTR($G(ICDDESC(1)))_" ("_ICDCS_" "_SICDC_")"
	E  S DSIND="^"
	S PHCLIN=$$GET^XPAR(ORAMENT,"ORAM PHONE CLINIC",1,"I")
	S PILLSTR=$$GET^XPAR(ORAMENT,"ORAM DEFAULT PILL STRENGTH",1,"I")
	S NLABTM=$$GET^XPAR(ORAMENT,"ORAM INCL TIME W/NEXT INR DATE",1,"I")
	S POCNM=$$GET^XPAR(ORAMENT,"ORAM POINT OF CONTACT NAME",1,"I")
	S RPATH=$$GET^XPAR(ORAMALL,"ORAM RAV FILE PATH",1,"I")
	S SIGNM=$$GET^XPAR(ORAMENT,"ORAM SIGNATURE BLOCK NAME",1,"I")
	S SIGTTL=$$GET^XPAR(ORAMENT,"ORAM SIGNATURE BLOCK TITLE",1,"I")
	S SITENM=$$GET^XPAR(ORAMENT,"ORAM CLINIC NAME",1,"I")
	S VLOC=$$GET^XPAR(ORAMENT,"ORAM VISIT LOCATION",1,"I")
	S RESULT(0)=SITENM_U_ATEAM_U_CTEAM_U_INOTE_U_ENOTE_U_DNOTE_U_SMPLPH_U_SVST_U_CPLXPH_U_ORIENT_U_IVST_U_CENAB_U_PCEON_U_LTR_U_U_ADD1_U_ADD2_U_ADD3
	S RESULT(1)=SIGNM_U_SIGTTL_U_POCNM_U_CPHONE_"|"_CFAX_U_MCNM_U_PILLSTR_U_NLABTM_U_TOLLFREE
	S RESULT(2)=VLOC_"|"_PHCLIN_"|"_NCLOC_U_INRQO_"|"_CBCQO_U_DUZ(2)_U_DSSUNIT_U_DSSID_U_CSVC_U_HCT_"|"_HCTNM_U_RPATH_U_DPIND_U_(IMPLDT'>ORVDT)
	S RESULT(3)=DSIND
	Q
	;
INDICS(RESULT,ORVDT)	; RPC To Get indications for care
	N IMPLDT
	S ORVDT=$G(ORVDT,DT)
	S IMPLDT=$$IMPDATE^LEXU("10D")
	; If I10 not yet implemented use I9 auto-prim indic, else use I10
	I (IMPLDT>ORVDT) D  I 1
	. D GETLST^XPAR(.RESULT,"SYS^PKG","ORAM INDICATIONS FOR CARE","E")
	E  D
	. D GETLST^XPAR(.RESULT,"SYS^PKG","ORAM I10 INDICATIONS FOR CARE","E")
	I +RESULT'>0 S RESULT(0)=0
	Q
	;
GETDIV()	; get division
	N DIV,ORAMY
	S DIV=$$KSP^XUPARAM("INST"),ORAMY=0
	I $$GET1^DIQ(4,DIV_",",5,"I")'="Y" S ORAMY=DIV_";DIC(4," I 1
	E  S ORAMY=$$SELDIV
	Q ORAMY
SELDIV()	; select division
	N DIC,X,Y
	W !!,"Enter Anticoagulation Management Parameters by Division:",!
	S DIC=4,DIC(0)="AEMQ",DIC("S")="I +$O(^DG(40.8,""AD"",+Y,0))"
	D ^DIC S:+Y>0 Y=+Y_";DIC(4,"
	Q Y
SELLOC()	; select hospital location
	N DIC,X,Y,TIUAPDT S DIC=44,DIC(0)="AEMQ"
	S DIC("A")="Select CLINIC: "
	S DIC("S")="I $$GOODLOC^ORAMSET(Y)"
	D ^DIC K DIC("S") S:+Y>0 Y=+Y_";SC("
	Q Y
GOODLOC(LOC)	; Returns 1 if ^SC hospital location IFN LOC is good, else 0
	N GOODLOC,INACTIVE,OOS,CLINIC,NONCOUNT S (GOODLOC,INACTIVE,NONCOUNT)=0
	I +$G(^SC(LOC,"I"))>0,(+$G(^("I"))'>DT) D
	. S INACTIVE=1
	. ; check if reactivated:
	. I +$P($G(^("I")),U,2)>0,$P($G(^("I")),U,2)'>DT S INACTIVE=0
	S OOS=+$D(^SC(LOC,"OOS")) ; Occasion of service
	S CLINIC=+($P(^SC(LOC,0),U,3)="C")
	S NONCOUNT=$S($P(^SC(LOC,0),U,17)="Y":1,1:0)
	I 'INACTIVE,'OOS,'NONCOUNT,CLINIC S GOODLOC=1
	Q GOODLOC
GETPARM(X)	; Get parameter as IEN^NAME
	N DIC,Y S DIC=8989.51,DIC(0)="MQ"
	D ^DIC
	Q Y
GETCMPDT(CODESYS)	; Returns compare date for indication set-up
	N Y,IDT
	S CODESYS=$G(CODESYS,"10D"),Y=DT
	S IDT=$$IMPDATE^LEXU("10D")
	S Y=$S(CODESYS="10D":IDT,1:+$$FMADD^XLFDT(IDT,-1))
	Q Y
ISCODEOK(CODE,CODESYS)	; Boolean - is code active as of compare date for code system
	N Y,CDT,CODESTAT
	S CODESYS=$G(CODESYS,"10D"),Y=0
	S CDT=$$GETCMPDT(CODESYS)
	S CODESTAT=$$STATCHK^ICDEX(CODE,CDT,CODESYS)
	I +CODESTAT=1,(+$P(CODESTAT,U,3)>0),($P(CODESTAT,U,3)'>CDT) S Y=1
	Q Y
