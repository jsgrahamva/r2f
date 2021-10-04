C0CRXNAD	; VEN/SMH - Add a drug to VISTA from RxNorm;2013-04-19  5:39 PM
	;;2.3;RXNORM FOR VISTA;;Jul 22, 2014;Build 16
	; (C) 2013 Sam Habiel
	; Proprietary Code. Don't use if license terms aren't supplied.
	;
ADDDRUG(RXN,NDC,BARCODE)	; Public Proc; Add Drug to Drug File
	; Input: RXN - RxNorm Semantic Clinical Drug CUI by Value. Required.
	; Input: NDC - Drug NDC by Value. Optional. Pass in 11 digit format without dashes.
	; Input: BARCODE - Wand Barcode. Optional. Pass exactly as wand reads minus control characters.
	; Output: Internal Entry Number
	;
	; Prelim Checks
	I '$G(RXN) S $EC=",U1," ; Required
	I $L($G(NDC)),$L(NDC)'=11 S $EC=",U1,"
	;
	N PSSZ S PSSZ=1    ; Needed for the drug file to let me in!
	;
	; If RXN refers to a brand drug, get the generic instead.
	I $$ISBRAND^C0CRXNLK(RXN) S RXN=$$BR2GEN^C0CRXNLK(RXN)
	W !,"(debug) RxNorm is "_RXN,!
	;
	; Get first VUID for this RxNorm drug
	N VUID S VUID=+$$RXN2VUI^C0CRXNLK(RXN)
	Q:'VUID
	W "(debug) VUID for RxNorm CUI "_RXN_" is "_VUID,!
	;
	; IEN in 50.68
	N C0XVUID ; For Searching Compound Index
	S C0XVUID(1)=VUID
	S C0XVUID(2)=1
	N F5068IEN S F5068IEN=$$FIND1^DIC(50.68,"","XQ",.C0XVUID,"AMASTERVUID")
	Q:'F5068IEN
	W "F 50.68 IEN (debug): "_F5068IEN,!
	;
	; FDA Array
	N C0XFDA
	;
	; Name, shortened
	S C0XFDA(50,"+1,",.01)=$E($$GET1^DIQ(50.68,F5068IEN,.01),1,40)
	;
	; File BarCode as a Synonym for BCMA
	I $L($G(BARCODE)) D
	. S C0XFDA(50.1,"+2,+1,",.01)=BARCODE
	. S C0XFDA(50.1,"+2,+1,",1)="Q"
	;
	; Brand Names
	N BNS S BNS=$$RXN2BNS^C0CRXNLK(RXN) ; Brands
	I $L(BNS) N I F I=1:1:$L(BNS,U) D
	. N IENS S IENS=I+2
	. S C0XFDA(50.1,"+"_IENS_",+1,",.01)=$$UP^XLFSTR($E($P(BNS,U,I),1,40))
	. S C0XFDA(50.1,"+"_IENS_",+1,",1)="T"
	;
	; NDC (string)
	I $G(NDC) S C0XFDA(50,"+1,",31)=$E(NDC,1,5)_"-"_$E(NDC,6,9)_"-"_$E(NDC,10,11)
	;
	; Dispense Unit (string)
	S C0XFDA(50,"+1,",14.5)=$$GET1^DIQ(50.68,F5068IEN,"VA DISPENSE UNIT")
	;
	; National Drug File Entry (pointer to 50.6)
	S C0XFDA(50,"+1,",20)="`"_$$GET1^DIQ(50.68,F5068IEN,"VA GENERIC NAME","I")
	;
	; VA Product Name (string)
	S C0XFDA(50,"+1,",21)=$E($$GET1^DIQ(50.68,F5068IEN,.01),1,70)
	;
	; PSNDF VA PRODUCT NAME ENTRY (pointer to 50.68)
	S C0XFDA(50,"+1,",22)="`"_F5068IEN
	;
	; DEA, SPECIAL HDLG (string)
	D  ; From ^PSNMRG
	. N CS S CS=$$GET1^DIQ(50.68,F5068IEN,"CS FEDERAL SCHEDULE","I")
	. S CS=$S(CS?1(1"2n",1"3n"):+CS_"C",+CS=2!(+CS=3)&(CS'["C"):+CS_"A",1:CS)
	. S C0XFDA(50,"+1,",3)=CS
	;
	; NATIONAL DRUG CLASS (pointer to 50.605) (triggers VA Classification field)
	S C0XFDA(50,"+1,",25)="`"_$$GET1^DIQ(50.68,F5068IEN,"PRIMARY VA DRUG CLASS","I")
	;
	; Right Now, I don't file the following which ^PSNMRG does (cuz I don't need them)
	; - Package Size (derived from NDC/UPN file)
	; - Package Type (ditto)
	; - CMOP ID (from $$PROD2^PSNAPIS)
	; - National Formulary Indicator (from 50.68)
	;
	; Next Step is to kill Old OI if Dosage Form doesn't match
	; Won't do that here as it's assumed any drugs that's added is new.
	; This happens at ^PSNPSS
	;
	; Now add drug to drug file, as we need the IEN for the dosages call.
	N C0XERR,C0XIEN
	D UPDATE^DIE("E","C0XFDA","C0XIEN","C0XERR")
	S:$D(C0XERR) $EC=",U1,"
	;
	; Next Step: Kill off old doses and add new ones.
	D EN2^PSSUTIL(C0XIEN(1))
	;
	; Mark uses for the Drug; use the undocumented Silent call in PSSGIU
	N PSIUDA,PSIUX ; Expected Input variables
	S PSIUDA=C0XIEN(1),PSIUX="O^Outpatient Pharmacy" D ENS^PSSGIU
	S PSIUDA=C0XIEN(1),PSIUX="U^Unit Dose" D ENS^PSSGIU
	S PSIUDA=C0XIEN(1),PSIUX="X^Non-VA Med" D ENS^PSSGIU
	;
	; Get VA Generic text and VA Product pointer for Orderable Item creation plus dosage form information
	N VAGENP S VAGENP=$P(^PSDRUG(C0XIEN(1),"ND"),U) ; VA Generic Pointer
	N VAGEN S VAGEN=$$VAGN^PSNAPIS(VAGENP) ; VA Generic Full name
	N VAPRODP S VAPRODP=$P(^PSDRUG(C0XIEN(1),"ND"),U,3) ; VA Product Pointer
	N DOSAGE S DOSAGE=$$PSJDF^PSNAPIS(0,VAPRODP) ; IEN of dose form in 50.606 ^ Text
	N DOSEPTR S DOSEPTR=$P(DOSAGE,U) ; ditto
	N DOSEFORM S DOSEFORM=$P(DOSAGE,U,2) ;ditto
	;
	; Get the (possibly new) Orderable Item Text
	N VAG40 S VAG40=$E(VAGEN,1,40) ; Max length of .01 field
	;
	; See if there is an existing orderable item already. If so, populate the Pharmacy Orderable item on drug file.
	N OI S OI=$O(^PS(50.7,"ADF",VAG40,DOSEPTR,""))
	;
	; Otherwise, add a new one. (See MCHAN+12^PSSPOIMN)
	I 'OI D
	. N C0XFDA,C0XERR
	. S C0XFDA(50.7,"+1,",.01)=VAG40
	. S C0XFDA(50.7,"+1,",.02)=DOSEPTR
	. D UPDATE^DIE("",$NA(C0XFDA),$NA(OI),$NA(C0XERR))
	. I $D(C0XERR) S $EC=",U1,"
	. S OI=OI(1) ; For ease of use...
	. ; Next two statements: See FIN^PSSPOIM1 and MF^PSSDEE.
	. D EN^PSSPOIDT(OI) ; Update Indexes; activations, etc.
	. D EN2^PSSHL1(OI,"MUP") ; Send HL7 message to CPRS
	;
	; Finally, add the orderable Item to the drug file.
	N C0XFDA,C0XERR S C0XFDA(50,C0XIEN(1)_",",2.1)=OI ; Orderable Item
	D FILE^DIE("",$NA(C0XFDA),$NA(C0XERR))
	S:$D(C0XERR) $EC=",U1,"
	;
EX	QUIT C0XIEN(1)
