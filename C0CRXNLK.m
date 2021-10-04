C0CRXNLK	; VEN/SMH - RxNorm Lookup Utilities ;2014-07-22  2:27 PM
	;;2.3;RXNORM FOR VISTA;;Jul 22, 2014;Build 16
	;(c) Sam Habiel 2013
	; See accompanying license. Don't use otherwise.
	;
	S IO=$P
	N DIQUIET S DIQUIET=1
	D DT^DICRW
	D EN^XTMUNIT($T(+0),1)
	QUIT
	;
EXIST(RXN)	; $$ Public - Does this RxNorm CUI exist?
	; Input: RxNorm CUI by value
	; Output: Extrinsic
	Q ''$D(^C0CRXN(176.001,"B",RXN))
	;
GCN2RXN(GCN)	; $$ Public - Get RxNorm CUI using GCN
	; Input: GCN by Value
	; Output: Extrinsic
	S GCN=$$RJ^XLFSTR(GCN,6,0) ; pad to six digits by zeros (123 becomes 000123)
	N IEN S IEN=$O(^C0CRXN(176.001,"STC","NDDF","CDC",GCN,"")) ; Get Entry
	Q ^(IEN)
	;
GCN2RXNT	; @TEST - Test Get RxNorm CUI using GCN
	Q:'$D(^C0CRXN(176.001,"STC","NDDF"))
	N L F L=1:1 N LN S LN=$T(GCN2RXND+L) Q:LN["<<END>>"  Q:LN=""  D
	. N GCN S GCN=$P(LN,";",3)
	. N RXN S RXN=$P(LN,";",4)
	. D CHKEQ^XTMUNIT($$GCN2RXN(GCN),RXN,"Translation from GCN to RXCUI failed")
	QUIT
	;
GCN2RXND	; @DATA - Data for Tests ;;GCN;EXPECTED RXNCUI
	;;16033;991632
	;;8208;310429
	;;1275;628953
	;;18;197604
	;;346;884173
	;;<<END>>
	;
	;
	;
RXN2GCN(RXNCUI)	; $$ Public - Get GCN(s) given an RxNorm Number
	; Input: RXNCUI by Value
	; Output: Caret delimited Extrinsic
	N GCNS S GCNS=""
	N I S I=""
	F  S I=$O(^C0CRXN(176.001,"STX","NDDF","CDC",RXNCUI,I)) Q:I=""  S GCNS=GCNS_+^(I)_U ; + b/c we want the GCN w/o leading zeros
	S GCNS=$E(GCNS,1,$L(GCNS)-1) ; remove trailing ^
	Q GCNS
	;
RXN2GCNT	; @TEST - Test Get GCN from RXNCUI
	Q:'$D(^C0CRXN(176.001,"STX","NDDF"))
	N L F L=1:1 N LN S LN=$T(RXN2GCND+L) Q:LN["<<END>>"  Q:LN=""  D
	. N RXN S RXN=$P(LN,";",3)
	. N GCN S GCN=$P(LN,";",4)
	. D CHKEQ^XTMUNIT($$RXN2GCN(RXN),GCN,"Translation from RXCUI to GCN failed")
	QUIT
	;
	;
RXN2GCND	; @DATA - Data for Tests ;;RXNORM CUI;Expected GCN; Human Readable Drug name for dear reader
	;;998689;5145;Acetabulol 200mg tab
	;;745679;5037;Albuterol Inhaler
	;;197320;2536;Allopurinol 300mg tab
	;;993691;3948^46236;Bupropion 75mg tab
	;;197591;3768;Diazepam 5mg tab
	;;<<END>>
	;
	;
	;
RXN2VUI(RXNCUI)	; $$ Public - Get VUID(s) for given RXNCUI for Clinical Drug
	; Input: RXNCUI by Value
	; Output: Caret delimited extrinsic. Should not be more than 2 entries.
	N C0PVUID S C0PVUID=""
	N I S I=""
	F  S I=$O(^C0CRXN(176.001,"STX","VANDF","CD",RXNCUI,I)) Q:I=""  S C0PVUID=C0PVUID_^(I)_U
	S C0PVUID=$E(C0PVUID,1,$L(C0PVUID)-1) ; remove trailing ^
	; TODO: Return only the quantified form using:
	; I $O(^C0CRXN(176.005,"RXCUIREL",RXN,"has_quantified_form","")) N QF S QF=$O(^("")) Q $O(^C0CRXN(176.001,"RXN2VUID",QF,""))
	Q C0PVUID
	;
RXN2VUIT	; @TEST - Get VUIDs given RxNorm values
	N L F L=1:1 N LN S LN=$T(RXN2VUID+L) Q:LN["<<END>>"  Q:LN=""  D
	. N RXN S RXN=$P(LN,";",3)
	. N VUIDS S VUIDS=$P(LN,";",4)
	. D CHKEQ^XTMUNIT($$RXN2VUI(RXN),VUIDS,"Translation from RXNCUI to VUID failed")
	QUIT
	;
RXN2VUID	; @DATA - Data items for previous test
	;;991632;4006455
	;;310429;4002369^4013941
	;;628953;4000874^4000856^4013966^4015798^4015799
	;;197604;4003335^4015937
	;;884173;4002469^4013919
	;;<<END>>
	;
	;
	;
VUI2VAP(VUID)	; $$ Public - Get VA Product IEN(s) from VUID
	; Input VUID by Value
	; Output: Extrinsic
	D FIND^DIC(50.68,,"@","QP",VUID,,"AVUID") ; Find all in VUID index
	N O S O="" ; Output
	N I F I=0:0 S I=$O(^TMP("DILIST",$J,I)) Q:'I  S O=O_^(I,0)_U ; Concat results together
	S O=$E(O,1,$L(O)-1) ; remove trailing ^
	Q O
	;
VUI2VAPT	; @TEST - Get VA Product IEN from VUID
	N L F L=1:1 N LN S LN=$T(VUI2VAPD+L) Q:LN["<<END>>"  Q:LN=""  D
	. N VUID S VUID=$P(LN,";",3)
	. N VAP S VAP=$P(LN,";",4)
	. D CHKEQ^XTMUNIT($$VUI2VAP(VUID),VAP,"Translation from VUID to VA PRODUCT failed")
	QUIT
	;
VUI2VAPD	; @DATA - Data for above test
	;;4006455;5932
	;;4002369;1784
	;;4000874;252
	;;4003335;2756
	;;4002469;1884
	;;4009488;9046^10090
	;;<<END>>
	;
	;
	;
VAP2MED(VAPROD)	; $$ Public - Get Drug(s) using VA Product IEN
	; Un-Unit-testable: Drug files differ between sites.
	; Input: VA Product IEN By Value
	; OUtput: Caret delimited extrinsic
	; This code inspired from PSNAPIs
	; WHY THE HELL WOULD I USE A TEXT INDEX?
	; It's my only option. Creating new xrefs on the drug file doesn't help
	; as they are not filled out when adding a drug (IX[ALL]^DIK isn't called).
	N MEDS S MEDS="" ; result
	N PN,PN1 ; Product Name, abbreviated product name.
	S PN=$P(^PSNDF(50.68,VAPROD,0),"^"),PN1=$E(PN,1,30)
	N P50 S P50=0 ; looper through VAPN index which is DRUG file entry
	F  S P50=$O(^PSDRUG("VAPN",PN1,P50)) Q:'P50  D  ; for each text match
	. I $P(^PSDRUG(P50,"ND"),"^",3)=VAPROD S MEDS=$G(MEDS)_P50_U  ; check that the VA PRODUCT pointer is the same as ours.
	S:MEDS MEDS=$E(MEDS,1,$L(MEDS)-1) ; remove trailing ^
	Q MEDS
	;
	;
RXN2MEDS(RXNCUI)	; $$ Public - Convert RxNorm value to currently existing drugs in File 50.
	; Input: SCD RXNCUI
	; Output; Caret delimited extrinsic
	; Un-unit testable
	N VUIDS S VUIDS=$$RXN2VUI(RXNCUI) ; Get VUID from RXNCUI (multiple VUIDs per CUI)
	Q:'VUIDS ""
	N MEDS S MEDS=""
	N DONE S DONE=0
	N I F I=1:1:$L(VUIDS,U) D  Q:DONE
	. N VUID S VUID=$P(VUIDS,U,I)
	. N VAPRODS S VAPRODS=$$VUI2VAP(VUID) ; Get VA Product from VUID (multiple products per VUID)
	. I '$L(VAPRODS) S $ECODE=",U-NO-VA-PRODUCT-CORRUPT-NDF,"  ; MUST EXIST. Every VUID must have a product to go with it.
	. N J F J=1:1:$L(VAPRODS,U) D  Q:DONE
	. . N VAPROD S VAPROD=$P(VAPRODS,U,J)
	. . S MEDS=$$VAP2MED(VAPROD) ; Get Meds from VA Product
	. . I $L(MEDS) S DONE=1
	QUIT MEDS
	;
FDI2RXN(BASE)	; $$ Public - Get RxNorm CUI for FDB Ingredient/Base
	; ^C0CRXN(176.001,"STC","NDDF","IN","014739",1000870)=1362160
	; Input: BASE By Value
	; Output: RxNorm CUI
	S BASE=$$RJ^XLFSTR(BASE,6,0) ; pad to six digits by zeros (123 becomes 000123)
	N IEN S IEN=$O(^C0CRXN(176.001,"STC","NDDF","IN",BASE,"")) Q ^(IEN)
	;
FDI2RXNT	; @TEST - Test Get RxNorm CUI for FDB Ingredient/Base
	Q:'$D(^C0CRXN(176.001,"STC","NDDF"))
	D CHKEQ^XTMUNIT($$FDI2RXN(14739),1362160,"$$FDI2RXN failed")
	QUIT
	;
	;
	;
RXN2VIN(RXNCUI)	; $$ Public - Get VUID Ingredient for RxNorm CUI
	; ^C0CRXN(176.001,"STX","VANDF","IN",1366467,1008555)=4031768
	; Input: RXNCUI By Value
	; Output: VUID
	N IEN S IEN=$O(^C0CRXN(176.001,"STX","VANDF","IN",RXNCUI,"")) Q ^(IEN)
	;
RXN2VINT	; @TEST - Test Get VUID Ingredient for RxNorm CUI
	D CHKEQ^XTMUNIT($$RXN2VIN(1366467),4031768,"$$RXN2VIN failed")
	QUIT
	;
	;
	;
VIN2VAG(VUID)	; $$ Public - Get VA Generic for VUID Ingredient
	; Input: VUID By Value
	; Output: IEN^VA Generic Name (i.e. .01 field value)
	N C0PIEN S C0PIEN=$$FIND1^DIC(50.6,"","QX",VUID,"AVUID")
	N C0P01 S C0P01=$$GET1^DIQ(50.6,C0PIEN,.01)
	Q C0PIEN_"^"_C0P01
	;
VIN2VAGT	; @TEST - Test Get VA Generic for VUID Ingredient
	D CHKEQ^XTMUNIT(+$$VIN2VAG(4023636),2832,"$$VIN2VAG failed")
	QUIT
	;
	;
	;
FDI2VAG(BASE)	; $$ Public - Get VA Generic for FDB Ingredient/Base
	; TODO:Not tested...
	; Input: BASE By Value
	; Output: IEN^VA Generic Name (i.e. .01 field value)
	Q $$VIN2VAG($$RXN2VIN($$FDI2RXN(BASE)))
	;
VIN2DIN(VUID)	; $$ Public - Get Drug Ingredient for VUID Ingredient
	; TODO:Not tested...
	; Input: VUID By Value
	; Output: IEN^Drug Ingredient Name (i.e. .01 field value)
	N C0PIEN S C0PIEN=$$FIND1^DIC(50.416,"","QX",VUID,"AVUID")
	N C0P01 S C0P01=$$GET1^DIQ(50.416,C0PIEN,.01)
	Q C0PIEN_"^"_C0P01
	;
FDI2DIN(BASE)	; $$ Public - Get Drug Ingredient for FDB Ingredient/Base
	; TODO:Not tested...
	; Input: BASE By Value
	; Output: IEN^Drug Ingredient Name (i.e. .01 field value)
	Q $$VIN2DIN($$RXN2VIN($$FDI2RXN(BASE)))
	;
VUI2RXN(VUID)	; $$ Public - Get RXNCUI for VUID (any VUID type)
	; Input: VUID By Value
	; Output: RXNCUIs delimited by ^
	; Get all entries whose code is the VUID and are in the VA NDF which are clinical drugs
	D FIND^DIC(176.001,,"@;.01","PQX",VUID,,"CODE","I $P(^(0),U,12,13)=""VANDF^CD""")
	; Deserialise it into a single string
	; ^TMP("DILIST",4844,0)="1^*^0^"
	; ^TMP("DILIST",4844,0,"MAP")="IEN^.01"
	; ^TMP("DILIST",4844,1,0)="1006351^1364462"
	N RXNS S RXNS=""
	N I F I=0:0 S I=$O(^TMP("DILIST",$J,I)) Q:'I  S RXNS=RXNS_$P(^(I,0),U,2)_U
	S RXNS=$E(RXNS,1,$L(RXNS)-1)
	QUIT RXNS
	;
VUI2GCN(VUID)	; $$ Public - Get GCNs for a given VUID (any VUID type)
	; Input: VUID by Value
	; Output: GCNs delimited by ^
	; TODO: Unit Test
	N RXNS S RXNS=$$VUI2RXN(VUID)
	Q:RXNS="" ""  ; VUID not a drug or ingredient (can be food)
	N GCNS S GCNS=""
	N I F I=1:1:$L(RXNS,U) S GCNS=GCNS_$$RXN2GCN($P(RXNS,U,I))_U
	S GCNS=$E(GCNS,1,$L(GCNS)-1)
	QUIT GCNS
	;
MED2RXN(DA)	; $$ Public - Get RxNorm CUI for Drug
	; Input: DA - Medication IEN
	; Output: RXNCUIs delimited by ^
	N ND S ND=$G(^PSDRUG(DA,"ND")) ; ND Node
	N VAP S VAP=$P(ND,U,3) ; VA Product Pointer
	Q:'VAP ""  ; quit if empty
	N VUID S VUID=+^PSNDF(50.68,VAP,"VUID")  ; Get VUID
	I 'VUID S $EC=",U1," ; Must exist
	Q $$VUI2RXN(VUID)
	;
MED2SCDN(DA)	; $$ Public - Medication to Semantic Clinical Drug Name
	; Input: DA - Medication IEN
	; Output: The Canonical Semantic Clinical Drug name
	N RXNCUI S RXNCUI=$$MED2RXN(DA)
	Q:'RXNCUI ""
	N IEN S IEN=$O(^C0CRXN(176.001,"STC","RXNORM","SCD",RXNCUI,""))  ; Let's try generic drug
	I 'IEN S IEN=$O(^C0CRXN(176.001,"STC","RXNORM","SBD",RXNCUI,""))  ; Let's try non-bioequivalent Brands then
	I 'IEN S IEN=$O(^C0CRXN(176.001,"STC","RXNORM","GPCK",RXNCUI,"")) ; Let's try a Generic combination package
	I 'IEN S IEN=$O(^C0CRXN(176.001,"STC","RXNORM","SCDF",RXNCUI,"")) ; Let's try a Clinical Drug and Form (Like Metamucil)
	Q:'IEN "" ; Apparently not every VUID has a corresponding RXNCUI SCD.
	Q $P(^C0CRXN(176.001,IEN,0),U,15)
	;
RXN2NDI(RXNCUI)	; $$ Public - Get NDDF Ingredient for RXNCUI
	; Input: RXNCUI By Value
	; Output: NDDF Base code
	; TODO:Not tested...
	N IEN S IEN=$O(^C0CRXN(176.001,"STX","NDDF","IN",RXNCUI,"")) Q ^(IEN)
	;
VIN2NDI(VUID)	; $$ Public - Get NDDF Ingredient for VUID
	; NB: WILL ONLY WORK IF VUID IS AN INGREDIENT VUID, NOT A CLINICAL DRUG
	; Input: VUID By Value
	; Output: NDDF Base code
	; TODO:Not tested...
	Q $$RXN2NDI($$VUI2RXN(VUID))
	;
	; ---
	;
NDC2RXN(NDC)	; $$ Public - Get RxCUI given the NDC
	; NB: Will only work if passed NDC is in 5-4-2 format.
	; Input: NDC By Value in 5-4-2 Format
	; Output: RxNorm Code.
	S NDC=$TR(NDC,"-")
	N IEN S IEN=$O(^C0CRXN(176.002,"ASAA","RXNORM","NDC",NDC,"")) Q ^(IEN)
	;
NDC2RXNT	; @TEST - Test Get RxCUI given the NDC
	D CHKEQ^XTMUNIT($$NDC2RXN("30142-0917-71"),198439,"$$NDC2RXN failed")
	QUIT
	;
	; ---
	;
ISBRAND(RXN)	; $$ Public - Is this RxCUI for a brand drug?
	; Input: RxCUI
	; Output: 0 or 1
	Q ''$D(^C0CRXN(176.001,"STC","RXNORM","SBD",RXN))
ISBRANDT	; @TEST - Test Is this RxCUI for a brand drug?
	D CHKEQ^XTMUNIT($$ISBRAND(205535),1,"$$ISBRAND failed") ; Brand Prozac
	D CHKEQ^XTMUNIT($$ISBRAND(310384),0,"$$ISBRAND failed") ; Generic Fluoxetine
	QUIT
	;
	; ---
	;
BR2GEN(RXN)	; $$ Public - Convert Brand RxCUI to Generic RxCUI (many to 1)
	; Input: RxCUI of Brand
	; Output: RxCUI of Generic
	Q $O(^C0CRXN(176.005,"B",RXN,"has_tradename",""))
BR2GENT	; @TEST - Test Convert Brand RxCUI to Generic RxCUI (many to 1)
	D CHKEQ^XTMUNIT($$BR2GEN(205535),310384,"$$BR2GEN failed")
	QUIT
	;
	; ---
	;
GEN2BR(RXN)	; $$ Public - Convert Generic RxCUI to Brand RxCUIs (1 to many).
	N RTN S RTN="" ; Return
	N I S I="" F  S I=$O(^C0CRXN(176.005,"B",RXN,"tradename_of",I)) Q:'I  S RTN=RTN_I_U
	S RTN=$E(RTN,1,$L(RTN)-1)
	Q RTN
	;
GEN2BRT	; @TEST - Test Convert Generic RxCUI to Brand RxCUIs (1 to many).
	D CHKTF^XTMUNIT($$GEN2BR(310384)[205535,"$$GEN2BR failed")
	QUIT
	;
	; ---
	;
RXN2BNS(RXN)	; $$ Public - Get all Brand Names associated with an RXN
	N BNS S BNS=""
	I $$ISBRAND(RXN) S RXN=$$BR2GEN(RXN)
	N ALLBN S ALLBN=$$GEN2BR(RXN)
	Q:ALLBN="" ""
	N BNNO F BNNO=1:1:$L(ALLBN,U) D
	. N EACHBN S EACHBN=$P(ALLBN,U,BNNO)
	. N BNRXCUI S BNRXCUI=$O(^C0CRXN(176.005,"B",EACHBN,"ingredient_of",""))
	. Q:BNRXCUI=""
	. N BNIEN S BNIEN=$O(^C0CRXN(176.001,"B",BNRXCUI,""))
	. S BNS=BNS_$P(^C0CRXN(176.001,BNIEN,0),U,15)_U
	QUIT $E(BNS,1,$L(BNS)-1)
RXN2BNST	; @TEST - Test Get all Brand Names associated with an RXN
	D CHKTF^XTMUNIT($$RXN2BNS(205535)["Prozac","$$RXN2BNS failed")
	QUIT
	;
	; ---
	;
RXN2NDC(RXN)	; Get NDC codes for RxNorm code
	N NDCS S NDCS=""
	N I F I=0:0 S I=$O(^C0CRXN(176.002,"ASAR","RXNORM","NDC",RXN,I)) Q:'I  S NDCS=NDCS_^(I)_"^"
	S $E(NDCS,$L(NDCS))=""
	QUIT NDCS
RXN2NDCT	; @TEST - Test Get NDC codes for RxNorm code
	D CHKTF^XTMUNIT($$RXN2NDC(197379)["^"_16714003309,"$$RXN2NDC failed")
	QUIT
