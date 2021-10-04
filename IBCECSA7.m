IBCECSA7 ;ALB/ESG - VIEW EOB SCREEN CONTINUED ;26-JUN-2003
 ;;2.0;INTEGRATED BILLING;**135,155**;21-MAR-1994
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 Q     ; Must be called at proper entry points
 ;
LLVLA ;line level adjustment
 Q:'$G(IBSRC)  ; no MRA
 D MRALLA^IBCECSA5
 Q
RDATA ;
 I '$G(IBSRC) Q     ; no review data for IB/MRA
 I $G(IBSRC) Q      ; no review data for AR either
 N IBRM,IBREC,IBFLG,IBFST
 S IB=$$SETSTR^VALM1("REVIEW DATA:","",1,50)
 D SET(IB)
 D CNTRL^VALM10(VALMCNT,1,12,IORVON,IORVOFF)
 S ^TMP("IBCECSD",$J,"X",8)=VALMCNT
 S (Y,IBFLG)=0 F  S Y=$O(^IBM(361.1,IBCNT,21,Y)) Q:'Y  D
 . S IBREC=$G(^IBM(361.1,IBCNT,21,Y,0)),IBFLG=1
 . D SET("  REVIEW DATE/TIME: "_$$DAT1^IBOUTL($P(IBREC,U),1))
 . S Z=0,IBFST=1 F  S Z=$O(^IBM(361.1,IBCNT,21,Y,1,Z)) Q:'Z  D
 .. S IBRM=$G(^IBM(361.1,IBCNT,21,Y,1,Z,0))
 .. D:IBFST SET("  COMMENT:"_$E(IBRM,1,68))
 .. D TXT^IBCECSA5(IBRM,68,11)
 .. S IBFST=0
 D:'IBFLG SET(" NONE")
 Q
 ;
ARCP ; A/R corrected payment data from splitting payment in EOB Worklist
 N Z,Z0
 I '$O(^IBM(361.1,IBCNT,8,0)) Q
 S IB=$$SETSTR^VALM1(" **A/R CORRECTED PAYMENT DATA:","",1,50)
 D SET(IB)
 I '$G(IBSRC) D
 . D CNTRL^VALM10(VALMCNT,1,27,IORVON,IORVOFF)
 . S ^TMP("IBCECSD",$J,"X",5)=VALMCNT
 D SET("   TOTAL AMT PD: "_$J(+$P($G(^IBM(361.1,IBCNT,1)),U,1),"",2))
 S Z=0 F  S Z=$O(^IBM(361.1,IBCNT,8,Z)) Q:'Z  S Z0=$G(^(Z,0)) D
 . S IB=$E($J("",6)_$S($P(Z0,U,3):$$BN1^PRCAFN(+$P(Z0,U,3)),1:"[suspense]"_$P(Z0,U))_$J("",25),1,25)_"  "_$J(+$P(Z0,U,2),"",2)
 . D SET(IB)
 Q
 ;
INSINF(IBREC,CNT,IBCNT) ; Extract insured information (moved from IBCECSA6)
 N IB,IBZ,IBSEQ,IBREL,Z,Z0
 S IBSEQ=+$$COBN^IBCEF(IBREC)
 S IB=$$SETSTR^VALM1("Patient Name: "_$P($G(^DPT(+$P($G(^DGCR(399,IBREC,0)),U,2),0)),U),"",2,39)
 D F^IBCEF("N-ALL INSURED PT RELATION","IBZ",,IBREC)
 S IBREL=$G(IBZ(IBSEQ))
 S IB=$$SETSTR^VALM1("Pt. Relation : "_$$EXTERNAL^DILFD(2.312,16,"",IBREL),IB,41,38)
 D SET^IBCECSA6($G(IBSRC),IB,CNT,IBCNT)
 S Z=2,Z0=39,IB=""
 I +IBREL'=1 D
 . D F^IBCEF("N-ALL INSURED FULL NAMES","IBZ",,IBREC)
 . S IB=$$SETSTR^VALM1("Insured Name: "_$G(IBZ(IBSEQ)),IB,Z,Z0)
 . S Z=41,Z0=38
 D F^IBCEF("N-ALL INSURANCE NUMBER","IBZ",,IBREC)
 S IB=$$SETSTR^VALM1("Insured ID  "_$S(Z=41:" ",1:"")_": "_$G(IBZ(IBSEQ)),IB,Z,Z0)
 D SET^IBCECSA6($G(IBSRC),IB,CNT,IBCNT)
 Q
 ;
SET(IB,IBSAV) ;
 I '$G(IBSAV) D SET^IBCECSA6($G(IBSRC),IB,CNT,IBCNT)
 Q
 ;
