OCXOZ0W	;SLC/RJS,CLA - Order Check Scan ;AUG 4,2015 at 21:54
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
R57R4B	; Send Order Check, Notication messages and/or Execute code for  Rule #57 'CLOZAPINE'  Relation #4 'CLOZAPINE AND 1.5 <= ANC < 2.0'
	;  Called from R57R4A+12^OCXOZ0V.
	;
	Q:$G(OCXOERR)
	;
	;      Local Extrinsic Functions
	; GETDATA( ---------> GET DATA FROM THE ACTIVE DATA FILE
	;
	Q:$D(OCXRULE("R57R4B"))
	;
	N OCXNMSG,OCXCMSG,OCXPORD,OCXFORD,OCXDATA,OCXNUM,OCXDUZ,OCXQUIT,OCXLOGS,OCXLOGD
	I ($G(OCXOSRC)="CPRS ORDER PRESCAN") S OCXCMSG=(+OCXPSD)_"^19^^ANC between 1.5 and 2.0 - please repeat CBC/Diff including WBC and ANC immediately and twice weekly.  Most recent results - "_$$GETDATA(DFN,"116^140",130) I 1
	E  S OCXCMSG="ANC between 1.5 and 2.0 - please repeat CBC/Diff including WBC and ANC immediately and twice weekly.  Most recent results - "_$$GETDATA(DFN,"116^140",130)
	S OCXNMSG=""
	;
	Q:$G(OCXOERR)
	;
	; Send Order Check Message
	;
	S OCXOCMSG($O(OCXOCMSG(999999),-1)+1)=OCXCMSG
	Q
	;
R59R1A	; Verify all Event/Elements of  Rule #59 'AMINOGLYCOSIDE ORDER'  Relation #1 'AGS ORDER'
	;  Called from EL71+5^OCXOZ0H.
	;
	Q:$G(OCXOERR)
	;
	;      Local Extrinsic Functions
	; MCE71( ----------->  Verify Event/Element: 'AMINOGLYCOSIDE ORDER SESSION'
	;
	Q:$G(^OCXS(860.2,59,"INACT"))
	;
	I $$MCE71 D R59R1B
	Q
	;
R59R1B	; Send Order Check, Notication messages and/or Execute code for  Rule #59 'AMINOGLYCOSIDE ORDER'  Relation #1 'AGS ORDER'
	;  Called from R59R1A+10.
	;
	Q:$G(OCXOERR)
	;
	;      Local Extrinsic Functions
	; GETDATA( ---------> GET DATA FROM THE ACTIVE DATA FILE
	;
	Q:$D(OCXRULE("R59R1B"))
	;
	N OCXNMSG,OCXCMSG,OCXPORD,OCXFORD,OCXDATA,OCXNUM,OCXDUZ,OCXQUIT,OCXLOGS,OCXLOGD
	I ($G(OCXOSRC)="CPRS ORDER PRESCAN") S OCXCMSG=(+OCXPSD)_"^20^^Aminoglycoside - est. CrCl: "_$$GETDATA(DFN,"71^",76)_" ("_$$GETDATA(DFN,"71^",64)_")  [Est. CrCl based on modified Cockcroft-Gault equation using Adjusted Body Weight (if ht > 60 in)]" I 1
	E  S OCXCMSG="Aminoglycoside - est. CrCl: "_$$GETDATA(DFN,"71^",76)_" ("_$$GETDATA(DFN,"71^",64)_")  [Est. CrCl based on modified Cockcroft-Gault equation using Adjusted Body Weight (if ht > 60 in)]"
	S OCXNMSG=""
	;
	Q:$G(OCXOERR)
	;
	; Send Order Check Message
	;
	S OCXOCMSG($O(OCXOCMSG(999999),-1)+1)=OCXCMSG
	Q
	;
R60R1A	; Verify all Event/Elements of  Rule #60 'CT OR MRI PHYSICAL LIMIT CHECK'  Relation #1 'TOO BIG'
	;  Called from EL72+5^OCXOZ0H.
	;
	Q:$G(OCXOERR)
	;
	;      Local Extrinsic Functions
	; MCE72( ----------->  Verify Event/Element: 'PATIENT OVER CT OR MRI DEVICE LIMITATIONS'
	;
	Q:$G(^OCXS(860.2,60,"INACT"))
	;
	I $$MCE72 D R60R1B
	Q
	;
R60R1B	; Send Order Check, Notication messages and/or Execute code for  Rule #60 'CT OR MRI PHYSICAL LIMIT CHECK'  Relation #1 'TOO BIG'
	;  Called from R60R1A+10.
	;
	Q:$G(OCXOERR)
	;
	;      Local Extrinsic Functions
	; GETDATA( ---------> GET DATA FROM THE ACTIVE DATA FILE
	;
	Q:$D(OCXRULE("R60R1B"))
	;
	N OCXNMSG,OCXCMSG,OCXPORD,OCXFORD,OCXDATA,OCXNUM,OCXDUZ,OCXQUIT,OCXLOGS,OCXLOGD
	I ($G(OCXOSRC)="CPRS ORDER PRESCAN") S OCXCMSG=(+OCXPSD)_"^8^^Patient may be "_$$GETDATA(DFN,"72^",79)_" for the "_$$GETDATA(DFN,"72^",80)_"." I 1
	E  S OCXCMSG="Patient may be "_$$GETDATA(DFN,"72^",79)_" for the "_$$GETDATA(DFN,"72^",80)_"."
	S OCXNMSG=""
	;
	Q:$G(OCXOERR)
	;
	; Send Order Check Message
	;
	S OCXOCMSG($O(OCXOCMSG(999999),-1)+1)=OCXCMSG
	Q
	;
GETDATA(DFN,OCXL,OCXDFI)	;     This Local Extrinsic Function returns runtime data
	;
	N OCXE,VAL,PC S VAL=""
	F PC=1:1:$L(OCXL,U) S OCXE=$P(OCXL,U,PC) I OCXE S VAL=$G(^TMP("OCXCHK",$J,DFN,OCXE,OCXDFI)) Q:$L(VAL)
	Q VAL
	;
MCE71()	; Verify Event/Element: AMINOGLYCOSIDE ORDER SESSION
	;
	;  OCXDF(37) -> PATIENT IEN data field
	;
	N OCXRES
	S OCXDF(37)=$G(DFN) I $L(OCXDF(37)) S OCXRES(71,37)=OCXDF(37)
	Q:'(OCXDF(37)) 0 I $D(^TMP("OCXCHK",$J,OCXDF(37),71)) Q $G(^TMP("OCXCHK",$J,OCXDF(37),71))
	Q 0
	;
MCE72()	; Verify Event/Element: PATIENT OVER CT OR MRI DEVICE LIMITATIONS
	;
	;  OCXDF(37) -> PATIENT IEN data field
	;
	N OCXRES
	S OCXDF(37)=$G(DFN) I $L(OCXDF(37)) S OCXRES(72,37)=OCXDF(37)
	Q:'(OCXDF(37)) 0 I $D(^TMP("OCXCHK",$J,OCXDF(37),72)) Q $G(^TMP("OCXCHK",$J,OCXDF(37),72))
	Q 0
	;
