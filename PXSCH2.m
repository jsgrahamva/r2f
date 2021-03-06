PXSCH2	;ISL/JVS,SCK - SCHEDULING REDESIGN PROCEDURES-CPT #2 ;7/25/96  09:12
	;;1.0;PCE PATIENT CARE ENCOUNTER;**73,194**;Aug 12, 1996;Build 2
	;  Variable List
	;
	; CPTNOD0   The data for the ^TMP("PXK",$J,  globals
	; CPTNOD12  The data for the ^TMP("PXK",$J,  globals
	; CPTNOD8   The data for the ^TMP("PXK",$J,  globals
	; PXSCPT    Pointer to the precedure being processed
	; PXSCPTQ   Quantity of the above procedure
	; PXSDX     The main Diagnosis
	; PXSINDX   Index for the "PXK" global
	; PXSPNN    resolved provider narrative
	; PXSPNN(1)    ""       ""      ""
	; PXSPR     The main Provider
	; XP,XPFG   Scratch Variables
	;
SET	;Set the TMP("PXK",$J, GLOBAL
CPT	;Create nodes for Procedures
	S PXSCPT=0 F  S PXSCPT=$O(PXS("PROC",PXSCPT)) Q:PXSCPT=""  D
	.S PXSINDX=PXSINDX+1
	.S PXSCPTQ=$G(PXS("PROC",PXSCPT))
	.D CPTNOD
	Q
CPTNOD	;
	S CPTNOD0="",$P(CPTNOD0,"^")=$G(PXSCPT)
	S $P(CPTNOD0,"^",2)=$G(PXS("PATIENT")) ;PATIENT
	S $P(CPTNOD0,"^",3)=$G(PXS("VISIT")) ;VISIT
	S PXSFILE=9000010.18
	;K ^UTILITY("DIQ1",$J)
	;S DIC=81,DA=PXSCPT,DR=2 D EN^DIQ1
	;S PXSZPN=$G(^UTILITY("DIQ1",$J,81,DA,2))
	;K ^UTILITY("DIQ1",$J),DIC,DA,DR
	S PXSZPN=$P($$CPT^ICPTCOD(PXSCPT),U,3) ; px*2.0*194
	S $P(CPTNOD0,"^",4)=+$$PROVNARR^PXAPI(PXSZPN,PXSFILE) ;PROVIDER NARR
	Q:$P(CPTNOD0,"^",4)=-1
	;S $P(CPTNOD0,"^",5)=$G(PXSDX) ;DIAGNOSIS
	S $P(CPTNOD0,"^",16)=$G(PXSCPTQ) ;QUANTITY
	S CPTNOD12=""
	;S $P(CPTNOD12,"^")=$G(PXS("DATE")) ;DATE AND TIME
	;S $P(CPTNOD12,"^",3)=$G(PXS("STOP CODE ORIG")) ;CLINIC STOP
	;S $P(CPTNOD12,"^",4)=$G(PXSPR) ;PROVIDER
	;S $P(CPTNOD12,"^",5)=$G(PXS("CLINIC")) ;HOSPITAL LOCATION
	;S $P(CPTNOD12,"^",7)=$P(CPTNOD0,"^",3) ;SECONDARY VISIT
	;--DECIDED TO REMOVE THE CATEGORY
	;S CPTNOD8=""
	;K ^UTILITY("DIQ1",$J) S DIC=81,DA=PXSCPT,DR=3,DIQ(0)="EIN" D EN^DIQ1
	;I $G(^UTILITY("DIQ1",$J,81,DA,3,"I")) D
	;.S PXSZPN=$G(^UTILITY("DIQ1",$J,81,DA,3,"E"))
	;.S CPTNOD8=+$$PROVNARR^PXAPI(PXSZPN,PXSFILE)
	;.I CPTNOD8'>0 S CPTNOD8=""
	;K ^UTILITY("DIQ1",$J),DIC,DA,DR,DIQ
	S ^TMP("PXK",$J,"CPT",PXSINDX+1,0,"AFTER")=$G(CPTNOD0)
	S ^TMP("PXK",$J,"CPT",PXSINDX+1,0,"BEFORE")=""
	S ^TMP("PXK",$J,"CPT",PXSINDX+1,1,1,"BEFORE")=""
	S ^TMP("PXK",$J,"CPT",PXSINDX+1,12,"AFTER")=$G(CPTNOD12)
	S ^TMP("PXK",$J,"CPT",PXSINDX+1,12,"BEFORE")=""
	S ^TMP("PXK",$J,"CPT",PXSINDX+1,802,"AFTER")=""
	S ^TMP("PXK",$J,"CPT",PXSINDX+1,802,"BEFORE")=""
	S ^TMP("PXK",$J,"CPT",PXSINDX+1,"IEN")=""
	S ^TMP("PXK",$J,"SOR")=8
	S ^TMP("PXK",$J,"VST",1,"IEN")=$G(PXS("VISIT"))
CPTDUP	;Look for duplicates on the same visit
	N XPFG,XP,PXKSEQ,PXKMOD
	S (XPFG,XP)=0
	F  Q:XPFG  S XP=$O(^AUPNVCPT("AD",PXS("VISIT"),XP)) Q:XP=""  D
	.I $P(^AUPNVCPT(XP,0),"^",1)=PXSCPT D
	..S ^TMP("PXK",$J,"CPT",PXSINDX+1,0,"BEFORE")=$G(^AUPNVCPT(XP,0))
	..S PXKSEQ=0
	..F  S PXKSEQ=$O(^AUPNVCPT(XP,1,PXKSEQ)) Q:'PXKSEQ  D
	...S PXKMOD=^AUPNVCPT(XP,1,PXKSEQ,0)
	...S ^TMP("PXK",$J,"CPT",PXSINDX+1,1,PXKSEQ,"BEFORE")=PXKMOD
	..S ^TMP("PXK",$J,"CPT",PXSINDX+1,12,"BEFORE")=$G(^AUPNVCPT(XP,12))
	..S ^TMP("PXK",$J,"CPT",PXSINDX+1,802,"BEFORE")=+$G(^AUPNVCPT(XP,802))
	..S ^TMP("PXK",$J,"CPT",PXSINDX+1,"IEN")=XP
	..S XPFG=1
	Q
