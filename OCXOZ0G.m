OCXOZ0G	;SLC/RJS,CLA - Order Check Scan ;AUG 4,2015 at 21:54
	;;3.0;ORDER ENTRY/RESULTS REPORTING;**32,221,243**;Dec 17,1997;Build 242
	;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
	;
	; ***************************************************************
	; ** Warning: This routine is automatically generated by the   **
	; ** Rule Compiler (^OCXOCMP) and ANY changes to this routine  **
	; ** will be lost the next time the rule compiler executes.    **
	; ***************************************************************
	;
	Q
	;
EL45	; Examine every rule that involves Element #45 [ORDER REQUIRES CHART SIGNATURE]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R6R1A^OCXOZ0J   ; Check Relation #1 in Rule #6 'ORDER REQUIRES CHART SIGNATURE'
	Q
	;
EL21	; Examine every rule that involves Element #21 [PATIENT ADMISSION]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R7R1A^OCXOZ0K   ; Check Relation #1 in Rule #7 'PATIENT ADMISSION'
	Q
	;
EL31	; Examine every rule that involves Element #31 [RADIOLOGY ORDER CANCELLED]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R11R1A^OCXOZ0K   ; Check Relation #1 in Rule #11 'IMAGING REQUEST CANCELLED/HELD'
	Q
	;
EL100	; Examine every rule that involves Element #100 [CANCELED BY NON-ORIG ORDERING PROVIDER]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R11R1A^OCXOZ0K   ; Check Relation #1 in Rule #11 'IMAGING REQUEST CANCELLED/HELD'
	D R11R2A^OCXOZ0K   ; Check Relation #2 in Rule #11 'IMAGING REQUEST CANCELLED/HELD'
	D R11R3A^OCXOZ0L   ; Check Relation #3 in Rule #11 'IMAGING REQUEST CANCELLED/HELD'
	D R35R1A^OCXOZ0P   ; Check Relation #1 in Rule #35 'LAB ORDER CANCELLED'
	Q
	;
EL30	; Examine every rule that involves Element #30 [RADIOLOGY ORDER PUT ON-HOLD]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R11R2A^OCXOZ0K   ; Check Relation #2 in Rule #11 'IMAGING REQUEST CANCELLED/HELD'
	Q
	;
EL32	; Examine every rule that involves Element #32 [RADIOLOGY ORDER DISCONTINUED]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R11R3A^OCXOZ0L   ; Check Relation #3 in Rule #11 'IMAGING REQUEST CANCELLED/HELD'
	Q
	;
EL46	; Examine every rule that involves Element #46 [SERVICE ORDER REQUIRES CHART SIGNATURE]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R16R1A^OCXOZ0L   ; Check Relation #1 in Rule #16 'SERVICE ORDER REQUIRES CHART SIGNATURE'
	Q
	;
EL76	; Examine every rule that involves Element #76 [STAT LAB RESULT]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R18R1A^OCXOZ0L   ; Check Relation #1 in Rule #18 'STAT RESULTS AVAILABLE'
	Q
	;
EL75	; Examine every rule that involves Element #75 [STAT IMAGING RESULT]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R18R2A^OCXOZ0M   ; Check Relation #2 in Rule #18 'STAT RESULTS AVAILABLE'
	Q
	;
EL110	; Examine every rule that involves Element #110 [STAT CONSULT RESULT]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R18R3A^OCXOZ0M   ; Check Relation #3 in Rule #18 'STAT RESULTS AVAILABLE'
	Q
	;
EL56	; Examine every rule that involves Element #56 [PATIENT DISCHARGE]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R19R1A^OCXOZ0M   ; Check Relation #1 in Rule #19 'PATIENT DISCHARGE'
	Q
	;
EL47	; Examine every rule that involves Element #47 [ORDER REQUIRES CO-SIGNATURE]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R22R1A^OCXOZ0N   ; Check Relation #1 in Rule #22 'ORDER REQUIRES CO-SIGNATURE'
	Q
	;
EL5	; Examine every rule that involves Element #5 [HL7 FINAL LAB RESULT]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R24R1A^OCXOZ0N   ; Check Relation #1 in Rule #24 'ORDERER FLAGGED RESULTS AVAILABLE'
	D R66R1A^OCXOZ0Y   ; Check Relation #1 in Rule #66 'LAB RESULTS'
	D R69R1A^OCXOZ10   ; Check Relation #1 in Rule #69 'LAB THRESHOLD'
	Q
	;
EL49	; Examine every rule that involves Element #49 [ORDER FLAGGED FOR RESULTS]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R24R1A^OCXOZ0N   ; Check Relation #1 in Rule #24 'ORDERER FLAGGED RESULTS AVAILABLE'
	Q
	;
EL55	; Examine every rule that involves Element #55 [CONSULT FINAL RESULTS]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R24R1A^OCXOZ0N   ; Check Relation #1 in Rule #24 'ORDERER FLAGGED RESULTS AVAILABLE'
	Q
	;
EL101	; Examine every rule that involves Element #101 [HL7 FINAL IMAGING RESULT]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R24R1A^OCXOZ0N   ; Check Relation #1 in Rule #24 'ORDERER FLAGGED RESULTS AVAILABLE'
	Q
	;
EL60	; Examine every rule that involves Element #60 [NEW OBR STAT ORDER]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R28R1A^OCXOZ0O   ; Check Relation #1 in Rule #28 'STAT ORDER PLACED'
	Q
	;
EL61	; Examine every rule that involves Element #61 [NEW ORC STAT ORDER]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R28R1A^OCXOZ0O   ; Check Relation #1 in Rule #28 'STAT ORDER PLACED'
	Q
	;
EL42	; Examine every rule that involves Element #42 [PATIENT TRANSFERRED FROM PSYCH WARD]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R32R1A^OCXOZ0O   ; Check Relation #1 in Rule #32 'PATIENT TRANSFERRED FROM PSYCHIATRY TO ANOTHER UNIT'
	Q
	;
EL20	; Examine every rule that involves Element #20 [HL7 LAB ORDER CANCELLED]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R35R1A^OCXOZ0P   ; Check Relation #1 in Rule #35 'LAB ORDER CANCELLED'
	Q
	;
EL40	; Examine every rule that involves Element #40 [HL7 LAB REQUEST CANCELLED]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R35R1A^OCXOZ0P   ; Check Relation #1 in Rule #35 'LAB ORDER CANCELLED'
	Q
	;
EL6	; Examine every rule that involves Element #6 [HL7 NEW OERR ORDER]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R38R1A^OCXOZ0P   ; Check Relation #1 in Rule #38 'NEW ORDER PLACED'
	Q
	;
EL126	; Examine every rule that involves Element #126 [HL7 DCED OERR ORDER]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R38R2A^OCXOZ0P   ; Check Relation #2 in Rule #38 'NEW ORDER PLACED'
	Q
	;
EL23	; Examine every rule that involves Element #23 [HL7 LAB ORDER RESULTS ABNORMAL]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R42R1A^OCXOZ0Q   ; Check Relation #1 in Rule #42 'ABNORMAL LAB RESULTS'
	Q
	;
EL103	; Examine every rule that involves Element #103 [HL7 LAB TEST RESULTS ABNORMAL]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R42R2A^OCXOZ0Q   ; Check Relation #2 in Rule #42 'ABNORMAL LAB RESULTS'
	Q
	;
EL48	; Examine every rule that involves Element #48 [ORDER REQUIRES ELECTRONIC SIGNATURE]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R44R1A^OCXOZ0Q   ; Check Relation #1 in Rule #44 'ORDER REQUIRES ELECTRONIC SIGNATURE'
	Q
	;
EL58	; Examine every rule that involves Element #58 [NEW SITE FLAGGED ORDER]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R48R1A^OCXOZ0R   ; Check Relation #1 in Rule #48 'SITE FLAGGED ORDER'
	D R48R2A^OCXOZ0R   ; Check Relation #2 in Rule #48 'SITE FLAGGED ORDER'
	Q
	;
EL127	; Examine every rule that involves Element #127 [INPATIENT]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R48R1A^OCXOZ0R   ; Check Relation #1 in Rule #48 'SITE FLAGGED ORDER'
	D R49R1A^OCXOZ0S   ; Check Relation #1 in Rule #49 'SITE FLAGGED RESULT'
	Q
	;
EL128	; Examine every rule that involves Element #128 [OUTPATIENT]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R48R2A^OCXOZ0R   ; Check Relation #2 in Rule #48 'SITE FLAGGED ORDER'
	D R49R2A^OCXOZ0T   ; Check Relation #2 in Rule #49 'SITE FLAGGED RESULT'
	Q
	;
EL59	; Examine every rule that involves Element #59 [SITE FLAGGED FINAL LAB RESULT]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R49R1A^OCXOZ0S   ; Check Relation #1 in Rule #49 'SITE FLAGGED RESULT'
	D R49R2A^OCXOZ0T   ; Check Relation #2 in Rule #49 'SITE FLAGGED RESULT'
	Q
	;
EL102	; Examine every rule that involves Element #102 [SITE FLAGGED FINAL IMAGING RESULT]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R49R1A^OCXOZ0S   ; Check Relation #1 in Rule #49 'SITE FLAGGED RESULT'
	D R49R2A^OCXOZ0T   ; Check Relation #2 in Rule #49 'SITE FLAGGED RESULT'
	Q
	;
EL109	; Examine every rule that involves Element #109 [SITE FLAGGED FINAL CONSULT RESULT]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R49R1A^OCXOZ0S   ; Check Relation #1 in Rule #49 'SITE FLAGGED RESULT'
	D R49R2A^OCXOZ0T   ; Check Relation #2 in Rule #49 'SITE FLAGGED RESULT'
	Q
	;
EL129	; Examine every rule that involves Element #129 [ABNORMAL RENAL RESULTS]
	;  Called from SCAN+9^OCXOZ01.
	;
	Q:$G(OCXOERR)
	;
	D R50R1A^OCXOZ0T   ; Check Relation #1 in Rule #50 'BIOCHEM ABNORMALITIES/CONTRAST MEDIA CHECK'
	Q
	;
