PSBVDLVL	;BIRMINGHAM/EFC-BCMA VIRTUAL DUE LIST FUNCTIONS ;11/27/12 3:52pm
	;;3.0;BAR CODE MED ADMIN;**6,3,12,11,13,32,25,61,70**;Mar 2004;Build 101
	;Per VHA Directive 2004-038 (or future revisions regarding same), this routine should not be modified.
	;
	;
	; Reference/IA
	; $$GET^XPAR/2263
	; 
	;*70 - Clinic Orders will use an Admin Early/Late calc of any day
	;      before or After TODAY instead of minutes as in IM meds.
	;
EN(RESULTS,DFN,PSBXOR,PSBTYPE,PSBADMIN,PSBTAB,PSBUID,PSBASTS,PSBORSTS,PSBRMV)	;
	;
	; RPC: PSB VALIDATE ORDER
	;
	; Description: Final check of order against an actual administration
	;              date/time used immediately after scanned med has been
	;              validated to be a good un-administered order.
	;
	K PSBTST
	N PSBFLAG
	I PSBRMV="I" D GETOHIST^PSBRPC2(.PSBTST,DFN,PSBXOR_PSBTYPE) S I=0 F  S I=$O(PSBTST(I)) Q:I=""  I $P(PSBTST(I),U,5)="I" S RESULTS(0)=1,RESULTS(1)="-2^" K PSBTST Q
	K PSBOKAY D CLEAN^PSBVT,PSJ1^PSBVT(DFN,PSBXOR_PSBTYPE) S PSB=0
	S RESULTS(0)=1,RESULTS(1)="-1^***Unable to determine administration" ; Default Flag will be overwritten by anything
	D NOW^%DTC
	I ((PSBOSTS="A")!(PSBOSTS="R"))&(PSBOSP<%) S PSBOSTS="E"
	I PSBORSTS'=PSBOSTS,((PSBSCHT'="O")&(PSBOSTS'="E")) S PSB=PSB+1,RESULTS(0)=PSB,RESULTS(PSB)="-2^ORDER STATUS MISMATCH" Q
	I ((PSBTAB="UDTAB")!(PSBTAB="PBTAB")),((PSBRMV="RM")!(PSBRMV="N")) D  Q
	.S PSB=PSB+1,RESULTS(0)=PSB,RESULTS(PSB)="0^OKAY TO REMOVE"  ; patch removal does not follow rest of validte rules
	.I PSBASTS="" Q  ;status is not given - don't check for missmatch
	.I $D(^PSB(53.79,"AORD",DFN,PSBXOR_PSBTYPE,+PSBADMIN)) S X=$O(^PSB(53.79,"AORD",DFN,PSBXOR_PSBTYPE,+PSBADMIN,"")) I $P($G(^PSB(53.79,+X,0)),U,9)'=PSBASTS  S PSB=PSB+1,RESULTS(0)=PSB,RESULTS(PSB)="-2^Admin status mismatch"
	I PSBTYPE="V",PSBSCHT'="P",((PSBUID="")!(PSBUID["WS")) S RESULTS(0)=1,RESULTS(1)="0^Okay to administer" Q:PSBTAB="IVTAB"
	I PSBTYPE="V",PSBUID'="" D  Q:PSBTAB="IVTAB"  ; validate IV bags Piggybacks have additional tests
	.S PSB=0,PSBSUID=PSBUID D EN^PSBPOIV(DFN,PSBXOR_PSBTYPE)
	.S X="" F  S X=$O(^TMP("PSBAR",$J,X)) Q:X=""  D
	..I PSBSUID'=X Q
	..S PSBUIDS=^TMP("PSBAR",$J,X)
	..I $P(PSBUIDS,U,2)="I"!($P(PSBUIDS,U,2)="S") S PSB=PSB+1,RESULTS(0)=PSB,RESULTS(PSB)="0^Okay to administer" Q  ; is infusing or stopped
	..I $P(PSBUIDS,U,1)="I" S Y=$P(^TMP("PSBAR",$J,"I"),U,2) D DD^%DT S PSB=PSB+1,RESULTS(0)=PSB,RESULTS(PSB)=$P(^TMP("PSBAR",$J,"I"),U,3,99)_"  "_Y Q
	..I $P(PSBUIDS,U,1)["W" S PSBWS=$P(PSBUIDS,U,1) F PSBWM=2:1 Q:$P(PSBWS,";",PSBWM)=""  D
	...S Y=$P(^TMP("PSBAR",$J,"W",$P(PSBWS,";",PSBWM)),U,2) D DD^%DT S PSB=PSB+1,RESULTS(0)=PSB,RESULTS(PSB)=$P(^TMP("PSBAR",$J,"W",$P(PSBWS,";",PSBWM)),U,3,99)_" "_Y
	..S PSB=PSB+1,RESULTS(0)=PSB,RESULTS(PSB)="0^Okay to administer"
	.K ^TMP("PSBAR",$J)
	;
	; no IV orders
	;
	D NOW^%DTC
	I PSBOSTS="H" S PSB=PSB+1,RESULTS(0)=PSB,RESULTS(PSB)="0^Order is on Provider Hold" Q
	;test for non-one time orders   admin prior to start date of order
	I PSBSCHT'="O"&(%<($$FMADD^XLFDT(PSBOST,"","",$$GET^XPAR("ALL","PSB ADMIN BEFORE")*-1))) S PSB=PSB+1,RESULTS(0)=PSB,RESULTS(PSB)="-1^Order Not Active" Q
	I (%>PSBOSP) S PSB=PSB+1,RESULTS(0)=PSB,RESULTS(PSB)="-1^Order Not Active" Q
	;tests sched types of continuous or prns that are patches
	I (PSBSCHT="C")!((PSBSCHT="P")&(PSBDOSEF="PATCH")) D
	.S PSBOKAY="0^Okay to administer"
	.I PSBASTS["*UNKNOWN*" S PSBOKAY="-1^This administration has *UNKNOWN* status" Q
	.I PSBOSTS'="A",PSBOSTS'="R",PSBOSTS'="O" S PSBOKAY="-1^Order Not Active" Q
	.I PSBNGF S PSBOKAY="-1^marked DO NOT GIVE" Q
	.S PSBFLAG=0 I PSBRMV="M"!(PSBRMV="H")!(PSBRMV="R") S PSBFLAG=1
	.I $D(^PSB(53.79,"AORDX",DFN,PSBXOR_PSBTYPE)) D  Q:X
	..S X=0,PSBLADT=$O(^PSB(53.79,"AORDX",DFN,PSBXOR_PSBTYPE,""),-1),PSBLAIEN=$O(^PSB(53.79,"AORDX",DFN,PSBXOR_PSBTYPE,PSBLADT,""),-1)
	..I $P($G(^PSB(53.79,PSBLAIEN,0)),U,9)="G",$P($G(^PSB(53.79,PSBLAIEN,.5,1,0)),U,4)="PATCH",PSBFLAG=0 S X=1,PSBOKAY="-1^Previous patch has not been removed" Q
	.I $D(^PSB(53.79,"AORD",DFN,PSBXOR_PSBTYPE,+PSBADMIN)) D  Q:+PSBOKAY<0
	..S X=$O(^PSB(53.79,"AORD",DFN,PSBXOR_PSBTYPE,+PSBADMIN,""))
	..L +^PSB(53.79,+X):1
	..I  L -^PSB(53.79,+X)
	..E  S PSBOKAY="-1^The "_$$GET1^DIQ(53.79,+X_",",.13)_" administration is being edited by another" Q
	..I $G(PSBASTS)]"" D  Q:+PSBOKAY<0
	...I $P($G(^PSB(53.79,+X,0)),U,9)="" Q
	...I $P($G(^PSB(53.79,+X,0)),U,9)'=PSBASTS S PSBOKAY="-2^Admin status mismatch" Q
	.;*70 perform early/late admin testing of for IM & CO orders
	.D:($G(PSBCLORD)="")  ;IM order orig logic
	..; Minutes before
	..S PSBWIN1=$$GET^XPAR("DIV","PSB ADMIN BEFORE")*-1
	..; Minutes After
	..S PSBWIN2=$$GET^XPAR("DIV","PSB ADMIN AFTER")
	..D NOW^%DTC S PSBMIN=$$DIFF^PSBUTL(PSBADMIN,%)
	..I PSBMIN<PSBWIN1 S PSBOKAY="1^Admin is "_(PSBMIN*-1)_" minutes before the scheduled administration time" Q
	..I PSBMIN>PSBWIN2 S PSBOKAY="1^Admin is "_(PSBMIN)_" minutes after the scheduled administration time" Q
	..S PSBOKAY="0^Okay to administer"
	.D:($G(PSBCLORD)]"")  ;CO order new logic
	..N ADMINDT S ADMINDT=$P(PSBADMIN,".")
	..S PSBOKAY="1^You are about to give a medication that "
	..I ADMINDT>DT D  Q
	...S PSBOKAY=PSBOKAY_"is scheduled for "_$$DOW^XLFDT(ADMINDT)_", "_$$FMTE^XLFDT(ADMINDT,5)_"."
	..I ADMINDT<DT D  Q
	...S PSBOKAY=PSBOKAY_"was scheduled for "_$$DOW^XLFDT(ADMINDT)_", "_$$FMTE^XLFDT(ADMINDT,5)_"."
	..S PSBOKAY="0^Okay to administer"
	.;*70 end early/late logic
	;
	; Validate a PRN Order
	D:(PSBSCHT="P")
	.I PSBOSTS'="A",PSBOSTS'="R",PSBOSTS'="O" S PSBOKAY="-1^Order Not Active" Q
	.I PSBNGF S PSBOKAY="-1^marked DO NOT GIVE" Q
	.I (+($G(PSBOKAY))<0)&(PSBDOSEF="PATCH") Q  ;A Patch may have to be removed.
	.S PSBOKAY="1^"
	.; Get Last Four Givens
	.S PSBDT=""
	.F  S PSBDT=$O(^PSB(53.79,"AOIP",DFN,+PSBOIT,PSBDT),-1) Q:PSBDT=""  D
	..S PSBDA=""
	..F  S PSBDA=$O(^PSB(53.79,"AOIP",DFN,+PSBOIT,PSBDT,PSBDA),-1) Q:'PSBDA  D
	...S (PSBCNT1,PSBCNT2,PSBCNT3)=0
	...S PSBLADT=$$GET1^DIQ(53.79,PSBDA_",",.06,"I")
	...S PSBSTUS=$$GET1^DIQ(53.79,PSBDA_",",.09)
	...S:PSBSTUS="" PSBSTUS="U"
	...S PSBSCH=$$GET1^DIQ(53.79,PSBDA_",",.12)
	...S PSBRSN=$$GET1^DIQ(53.79,PSBDA_",",.21)
	...S PSBINJ=$$GET1^DIQ(53.79,PSBDA_",",.16)
	...Q:$P(^PSB(53.79,PSBDA,0),U,9)="N"
	...F PSBZ=.5,.6,.7 F PSBY=0:0 S PSBY=$O(^PSB(53.79,PSBDA,PSBZ,PSBY)) Q:'PSBY  D
	....Q:'$D(^PSB(53.79,PSBDA,PSBZ,PSBY))
	....S PSBDD=$S(PSBZ=.5:53.795,PSBZ=.6:53.796,1:53.797)
	....S PSBUNIT=$$GET1^DIQ(PSBDD,PSBY_","_PSBDA_",",.03) S:PSBUNIT>0&(PSBUNIT<1) PSBUNIT="0"_+PSBUNIT ;Add leading 0 for decimal values less than 1, PSB*3*61
	....S PSBUNFR=$$GET1^DIQ(PSBDD,PSBY_","_PSBDA_",",.04)
	....I PSBZ=.5 S PSBCNT1=PSBCNT1+1
	....I PSBZ=.6 S PSBCNT2=PSBCNT2+1
	....I PSBZ=.7 S PSBCNT3=PSBCNT3+1
	...;Units given or free text not to display for multiple dispense drugs or additives and solution
	...I (PSBCNT1>1)!(PSBCNT2>0)!(PSBCNT3>0) S (PSBUNIT,PSBUNFR)=""
	...S X=PSBLADT_U
	...S X=X_PSBSTUS_U_PSBSCH_U_$G(PSBRSN)_U_$G(PSBINJ)_U_$G(PSBUNIT)_U_$G(PSBUNFR)
	...S PSBOKAY($O(PSBOKAY(""),-1)+1)=3_U_X
	...S:$D(PSBOKAY(4)) PSBDT=0
	.S X1=$$LASTG^PSBCSUTL(DFN,+PSBOIT) I X1>0 S PSBOKAY($O(PSBOKAY(""),-1)+1)=4_U_X1
	; Validate a One-Time Order
	D:PSBSCHT="O"
	.S (PSBGVN,X,Y)=""
	.F  S X=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,X),-1)  Q:'X  F  S Y=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,X,Y),-1) Q:'Y  I $P(^PSB(53.79,Y,.1),U)=PSBONX,"G"[$P(^PSB(53.79,Y,0),U,9) S PSBGVN=1,(X,Y)=0
	.I PSBGVN S PSBOKAY="-1^Dose Already on medication Log" Q
	.; One Time are automatically expired so we don't check STATUS here
	.I PSBNGF S PSBOKAY="-1^marked DO NOT GIVE" Q
	.S PSBOKAY="0^Okay to administer"
	; Validate an On Call Order
	D:PSBSCHT="OC"
	.S PSBOKAY="0^Okay to administer"
	.S (PSBGVN,X,Y)=""
	.F  S X=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,X),-1)  Q:'X  F  S Y=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,X,Y),-1) Q:'Y  I $P(^PSB(53.79,Y,.1),U)=PSBONX,"G"[$P(^PSB(53.79,Y,0),U,9) S PSBGVN=1,(X,Y)=0
	.I PSBGVN&('$$GET^XPAR("DIV","PSB ADMIN MULTIPLE ONCALL")) S PSBOKAY="-1^Dose Already on medication Log" Q
	.I PSBOSTS'="A",PSBOSTS'="R",PSBOSTS'="O" S PSBOKAY="-1^Order Not Active" Q
	.I PSBNGF S PSBOKAY="-1^marked DO NOT GIVE" Q
	.I PSBGVN&($$GET^XPAR("DIV","PSB ADMIN MULTIPLE ONCALL"))&(PSBDOSEF="PATCH") S PSBOKAY="-1^Previous patch has not been removed" Q
	.S PSBOKAY="0^Okay to administer"
	;
	D:+PSBOKAY'<0
	.N PSBDIFF,Y
	.D:(PSBSCHT="C")!(PSBSCHT="OC"&('$G(PSBGVN)))
	..; On-call or cont and not on the log.
	..S Y=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,""),-1)
	..;Check for the status of the medication and insert status in the text
	..I Y]"" S X=$O(^PSB(53.79,"AOIP",DFN,+PSBOIT,Y,""),-1),PSBSTUS=$P(^PSB(53.79,X,0),U,9)
	..S:Y']"" PSBSTUS=""
	..I PSBSTUS="N" D  Q:$G(PSBQUIT)
	...S X=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,Y,X),-1)
	...D:X']""
	....S Y=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,Y),-1) I Y']"" S PSBQUIT=1 Q
	....S X=$O(^PSB(53.79,"AOIP",DFN,+PSBOIT,Y,""),-1),PSBSTUS=$P(^PSB(53.79,X,0),U,9)
	..S PSBDIFF=$$FMDIFF^XLFDT($$NOW^XLFDT(),Y,2)
	..Q:PSBDIFF>7200  ; Greater than 2 hours
	..I (PSBSTUS="G")!(PSBSTUS="H")!(PSBSTUS="R")!(PSBSTUS="RM") D
	...S PSBSTUS=$$GET1^DIQ(53.79,X_",",.09)
	...I PSBSTUS'="" D
	....S Y="1^*** NOTICE, "_PSBOITX_" was "_PSBSTUS_" "_(PSBDIFF\60)_" minutes ago."
	....I +PSBOKAY=1 S PSBOKAY(1)=Y
	....E  S PSBOKAY=Y
	;
	S PSB=PSB+1,RESULTS(0)=PSB,RESULTS(PSB)=PSBOKAY
	F X=1:1 Q:'$D(PSBOKAY(X))  S PSB=PSB+1,RESULTS(0)=PSB,RESULTS(PSB)=PSBOKAY(X)
	Q
