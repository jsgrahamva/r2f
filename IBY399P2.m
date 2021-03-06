IBY399P2	;ALB/ARH - IB*2*399 POST-INSTALL - RNB LIST ; 16-OCT-2008
	;;2.0;INTEGRATED BILLING;**399**;21-MAR-94;Build 8
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;
	;
RNB	;;#^Status^Code^ECME Flag^ECME Paper Flag^RNB Name
INA	;; 
	;;6^INA^^^^SERVICE NOT COVERED
	;;19^INA^^^^BILL PURGED
	;;23^INA^^^^INSUFFICIENT DOCUMENTATION
	;;25^INA^^^^NON-BILLABLE PROVIDER (RESID.)
	;;26^INA^^^^NON-BILLABLE PROVIDER (OTHER)
OLD	;; 
	;;1^OLD^CV01^^^NOT INSURED
	;;2^OLD^VA01^^^SC TREATMENT
	;;3^OLD^VA02^^^AGENT ORANGE
	;;4^OLD^VA03^^^IONIZING RADIATION
	;;5^OLD^VA04^^^SOUTHWEST ASIA
	;;7^OLD^CV02^^^COVERAGE CANCELED
	;;8^OLD^VA05^^^NEEDS SC DETERMINATION
	;;9^OLD^MC01^^^NON-BILLABLE APPOINTMENT TYPE
	;;10^OLD^RX01^^^INVALID PRESCRIPTION ENTRY
	;;11^OLD^RX02^^^REFILL ON VISIT DATE
	;;12^OLD^RX03^^^PRESCRIPTION DELETED
	;;13^OLD^RX04^^^PRESCRIPTION NOT RELEASED
	;;14^OLD^RX05^^^DRUG NOT BILLABLE
	;;15^OLD^CV03^^^HMO POLICY
	;;16^OLD^MC02^^^REFUSES TO SIGN RELEASE (ROI)
	;;17^OLD^MC03^^^NON-BILLABLE STOP CODE
	;;18^OLD^MC04^^^RESEARCH VISIT
	;;20^OLD^MC05^^^NON-BILLABLE CLINIC
	;;21^OLD^VA06^^^MILITARY SEXUAL TRAUMA
	;;22^OLD^MC06^^^CREDENTIALING ISSUE
	;;24^OLD^DC01^^^NO DOCUMENTATION
	;;27^OLD^MC07^^^OTHER COMPLIANCE
	;;28^OLD^CV04^^^OUT OF NETWORK (PPO)
	;;29^OLD^VA07^^^HEAD/NECK CANCER
	;;30^OLD^VA08^^^COMBAT VETERAN
	;;31^OLD^CV05^^^MRA REC'D. NO SEC RESP EXISTS
	;;32^OLD^CV06^^^MRA REC'D. SEC NOT BILLED
	;;33^OLD^RX06^^0^90 DAY RX FILL NOT COVERED
	;;34^OLD^RX07^^0^NOT A CONTRACTED PROVIDER
	;;35^OLD^RX08^^^INVALID MULTIPLES PER DAY SUPP
	;;36^OLD^RX09^^^REFILL TOO SOON
	;;37^OLD^RX10^^^INVALID NDC FROM CMOP
	;;38^OLD^VA09^^^PROJECT 112/SHAD
	;;999^OLD^^^^OTHER
NEW	;; 
	;;39^NEW^RX11^1^0^NON COVERED DRUG PER PLAN
	;;40^NEW^CV07^1^0^FILING TIMEFRAME NOT MET
	;;41^NEW^MC08^^^GLOBAL SURGERY
	;;42^NEW^BL01^^^CHARGES SPLIT
	;;43^NEW^MC09^^^PRE-CERT NOT OBTAINED
	;;44^NEW^MC10^^^DUPLICATE ENCOUNTER
	;;45^NEW^CV08^^^MEDICARE REPLACEMENT POLICY
	;;46^NEW^CV09^^^COVERED BY MEDICARE AT 100%
	;;47^NEW^CV10^^^BENEFITS MAXED
	;;48^NEW^VA10^^^C&P EXAM/REGISTRY EXAM
	;;49^NEW^MC11^^^TELEPHONE ENCOUNTER
	;;50^NEW^DC02^^^NO TX PROVIDED/ADVICE ONLY
	;;51^NEW^MC12^^^ROI NOT OBTAINED
	;;52^NEW^DC03^^^UNSIGNED DOCUMENT
	;;53^NEW^CV11^^^CONCURRENT CARE
	;;54^NEW^MC13^^^72 HOUR RULE
	;;55^NEW^CV12^^^CUSTODIAL/RESIDENTIAL CARE
	;;56^NEW^BL02^^^OBSERVATION-OP BILLED
	;;57^NEW^BL03^^^BILLED INSTITUTIONAL ONLY
	;;58^NEW^BL04^^^BILLED PROFESSIONAL ONLY
	;;59^NEW^CV13^^^NO OUTPATIENT COVERAGE
	;;60^NEW^CV14^^^NO INPATIENT COVERAGE
	;;61^NEW^CV15^1^0^NO PHARMACY COVERAGE
	;;62^NEW^CV16^^^NO DENTAL COVERAGE
	;;63^NEW^CV17^^^NO MENTAL HEALTH COVERAGE
	;;64^NEW^CV18^^^NO LTC COVERAGE
	;;65^NEW^MN01^^^MED NEC-DX NOT COVERED
	;;66^NEW^MN02^^^MED NEC-CPT NOT COVERED
	;;67^NEW^MN03^^^MED NEC-LCD EDIT
	;;68^NEW^MN04^^^MED NEC-OTHER
	;;69^NEW^CV19^^^MEDICARE EXCLUDED SERVICE
	;;70^NEW^MC14^^^RESIDENT SUPERVISION NOT MET
	;;71^NEW^MC15^^^ANCILLARY PROVIDER AT CBOC
	;;72^NEW^CV20^^^NON-COVERED PROVIDER
	;;73^NEW^DC04^^^NO DIAGNOSIS/SYMPTOMS IN NOTE
	;;74^NEW^DC05^^^NO CHIEF COMPLAINT
	;;75^NEW^DC06^^^NOTE NOT WRITTEN TIMELY
	;;76^NEW^DC07^^^NO PHYSICIAN ORDER
	;;77^NEW^DC08^^^NO PLAN OF CARE
	;;78^NEW^DC09^^^STUDENT NOTE ONLY
	;;79^NEW^BL05^^^ALL BILLABLE CPT CODES BILLED
	;;80^NEW^BL06^^^NO INPT PROF FEES BILLED
	;;81^NEW^BL07^^^REPETITIVE SERVICES
	;;82^NEW^MC16^^^PENDING CODE SET UPDATE
	;;83^NEW^MC17^^^PENDING RC CHARGE UPDATE
	;;84^NEW^MC18^1^0^NPI/TAXONOMY ISSUES
	;;85^NEW^RX12^1^0^RX DUR REJECT
	;;86^NEW^RX13^1^0^RX PRIOR AUTH NOT OBTAINED
	;;87^NEW^RX14^1^0^RX MEDICARE PART D
	;;88^NEW^RX15^1^0^RX DISCOUNT CARD
	;;89^NEW^MC19^1^0^DATE OF BIRTH MISMATCH
	;;90^NEW^DC10^^^NEW PT/NO HX
	;;91^NEW^DC11^^^NEW PT/NO EXAM
	;;92^NEW^DC12^^^NEW PT/NO COMPLEXITY
	;;93^NEW^DC13^^^EST PT/NO HX/NO EXAM
	;;94^NEW^DC14^^^EST PT/NO HX/NO COMPLEXITY
	;;95^NEW^DC15^^^EST PT/NO EXAM/NO COMPLEXITY
	;;96^NEW^CV21^^^NO VISION COVERAGE
	;;
	Q
