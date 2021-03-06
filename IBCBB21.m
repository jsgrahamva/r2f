IBCBB21	;ALB/AAS - CONTINUATION OF EDIT CHECK ROUTINE FOR UB-04 ;5:23 AM  8 Sep 2015
	;;2.0;INTEGRATED BILLING;**51,137,210,232,155,291,348,349,403,400,432,447,461,WVEHR,LOCAL**;21-MAR-94;Build 1
	;
	; Copyright 2015 WorldVistA.
	;
	; This program is free software: you can redistribute it and/or modify
	; it under the terms of the GNU Affero General Public License as
	; published by the Free Software Foundation, either version 3 of the
	; License, or (at your option) any later version.
	;
	; This program is distributed in the hope that it will be useful,
	; but WITHOUT ANY WARRANTY; without even the implied warranty of
	; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	; GNU Affero General Public License for more details.
	;
	; You should have received a copy of the GNU Affero General Public License
	; along with this program.  If not, see <http://www.gnu.org/licenses/>.
	;
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;
EN(IBZPRC92)	;
	;
	N ECODE,IBTXMT,IBXDATA,IBDXTYP,IBDXVER,IBLPRT,IBI,Z,Z0,Z1,IBREQMRA
	I '$D(IBZPRC92) D ALLPROC^IBCVA1(IBIFN,.IBZPRC92)
	S IBREQMRA=$$REQMRA^IBEFUNC(IBIFN)    ; MRA?
	K IBQUIT S IBQUIT=0
	S (Z,Z0,Z1)=0
	F  S Z=$O(IBZPRC92(Z)) Q:'Z  S:IBZPRC92(Z)["CPT" Z0=Z0+1 S:IBZPRC92(Z)["ICD" Z1=Z1+1
	S IBTXMT=$$TXMT^IBCEF4(IBIFN)
	S IBZPRC92=Z0_U_Z1 ;Save # of CPT's and ICD9's
	; More than 50 procedures on a bill - must print locally
	I IBTXMT,(+IBZPRC92>50!(+$P(IBZPRC92,U,2)>50)) D  Q:IBQUIT
	. I 'IBREQMRA S IBQUIT=$$IBER^IBCBB3(.IBER,308) Q
	. I '$P(IBNDTX,U,9) S IBQUIT=$$IBER^IBCBB3(.IBER,325)
	; removed 11x check ;WCJ IB*2.0*432
	; If ICD9 procedures with dates and charges, bill 11x or 83x needs operating physician
	;I IBTOB12="11",$P(IBZPRC92,U,2),'$$CKPROV^IBCEU(IBIFN,2) S IBER=IBER_"IB304;"
	;modify 83x check for line level providers and also chacnged the erro check slightly
	;I IBTOB12="83",$P(IBZPRC92,U,2),'$$CKPROV^IBCEU(IBIFN,2) S IBER=IBER_"IB312;"
	I IBTOB12="83",'$$UBPRVCK^IBCBB12(IBIFN) S IBER=IBER_"IB312;"  ; DEM;432
	;
	; If any CPT procedures have more than 2 modifiers, warn
	S Z=0 F  S Z=$O(IBZPRC92(Z)) Q:'Z  I $P(IBZPRC92(Z),U)["ICPT(",$L($P(IBZPRC92(Z),U,15),",")>2 S Z0="Proc "_$$PRCD^IBCEF1($P(IBZPRC92(Z),U))_" has > 2 modifiers - only first 2 will be used" D WARN^IBCBB11(Z0)
	;
	I $$WNRBILL^IBEFUNC(IBIFN),$$MRATYPE^IBEFUNC(IBIFN)'="A" S IBER=IBER_"IB086;"
	;
	; UB-04 Diagnosis Codes
	K IBXDATA D F^IBCEF("N-DIAGNOSES",,,IBIFN)
	;
	; Only 24 other dx's + 1 principal dx + 3 ecode dx's are allowed per claim
	S (Z,ECODE,IBI)=0 F  S Z=$O(IBXDATA(Z)) Q:'Z  D  Q:IBER["309;"!(ECODE>3)
	. S IBI=IBI+1
	. S IBDXTYP=$$ICD9^IBACSV(+$P(IBXDATA(Z),U),$$BDATE^IBACSV(IBIFN)) I $P(IBDXTYP,U,19)=1,$E(IBDXTYP)="E" D
	.. ;Begin WorldVistA change
	.. ;WAS;S:ECODE<=3 ECODE=ECODE+1,IBI=IBI-1
	.. S:ECODE'>3 ECODE=ECODE+1,IBI=IBI-1
	.. ;End WorldVistA change
	.. I ECODE>3 D WARN^IBCBB11("Claim contains more than 3 External Cause of Injury codes.")
	. ;
	. ; max DX check does not apply to MRAs
	. I IBTXMT,IBI>25 D
	.. I 'IBREQMRA Q:$P(IBNDTX,U,8)  S IBER=IBER_"IB309;" Q
	.. I '$P(IBNDTX,U,9) S IBER=IBER_"IB326;"
	;
	I '$O(IBXDATA(0)) S IBER=IBER_"IB071;"   ;Require Diag code NOIS:OKL-0304-72495
	;
	; Principle diagnosis - updated for ICD-10 **461
	I $O(IBXDATA(0)) S IBDXTYP=$$ICD9^IBACSV(+$P(IBXDATA(1),U),$$BDATE^IBACSV(IBIFN)) D
	. S IBDXVER=$P(IBDXTYP,U,19),IBDXTYP=$E(IBDXTYP)
	. I IBDXVER=1,IBDXTYP="E" S IBER=IBER_"IB117;"
	. I IBDXVER=1,$$INPAT^IBCEF(IBIFN),IBDXTYP="V" S Z="Principal Dx V-code may not be valid" D WARN^IBCBB11(Z)
	. I IBDXVER=30,"VWXY"[IBDXTYP S IBER=IBER_"IB355;"
	. I IBDXVER=30,$$INPAT^IBCEF(IBIFN),IBDXTYP="Z" S Z="Principal Dx Z-code may not be valid" D WARN^IBCBB11(Z)
	;
	I '$$OCC10^IBCBB2(IBIFN,.IBXDATA,3) S IBER=IBER_"IB093;"
	;
	; At least one PRV diagnosis is required for outpatient UB-04 claim
	; IB*2.0*447 BI This warning was removed and replaced with an Error Message in routine IBCBB1.
	;I '$$INPAT^IBCEF(IBIFN),$$CHKPRV^IBCSC10B=3 D WARN^IBCBB11("Outpatient Institutional claims should contain a Patient Reason for Visit.")
	;
	K ^TMP($J,"IBC-RC")
	D F^IBCEF("N-UB-04 SERVICE LINE (PRINT)",,,IBIFN)
	S (Z0,IBI)=0 F  S IBI=$O(^TMP($J,"IBC-RC",IBI)) Q:'IBI  S Z=$G(^(IBI))  Q:+$P(Z,U,2)=1  I $P(Z,U,2),$P(Z,U,1)=1 D
	. ; IB*2.0*432 - The IB system shall provide the ability for users to enter maximum line item dollar amounts of 9999999.99.
	. ;I IBER'["IB090;",$P(Z,U,2)>1,($P(Z,U,7)>99999.99!($P(Z,U,8)>99999.99)) S IBER=IBER_"IB090;"
	. I IBER'["IB090;",$P(Z,U,2)>1,($P(Z,U,7)>9999999.99!($P(Z,U,8)>9999999.99)) S IBER=IBER_"IB090;"
	. Q:$P(Z,U,2)'<180&($P(Z,U,2)'>189)  ;Pass days (LOA) don't matter
	. ; Removed the following warning IB*2.0*447 BI Replaced in IBCBB1.
	. ;I '$P(Z,U,7),'$P(Z,U,8),'Z0,$$COBN^IBCEF(IBIFN)'>1  S Z0="Rev Code(s) having a 0-charge will not be transmitted for the bill" D WARN^IBCBB11(Z0) S Z0=1
	K ^TMP($J,"IBC-RC")
	Q
	;
