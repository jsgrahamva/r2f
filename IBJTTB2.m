IBJTTB2 ;ALB/ARH - TPI AR TRANSACTION PROFILE (CONT) ; 07-APR-1995
 ;;Version 2.0 ; INTEGRATED BILLING ;**39**; 21-MAR-94
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
BC ; balance and collection amounts:  
 ; returns: IBBC= total balance ^ total collected
 ;          IBBC(x) = data lable ^ $ balance ^ $ collected
 S IBBC=0 Q:IBRCT8=""
 ;
 S IBBC=+$P(IBRCT8,U,6)_U_+$P(IBRCT3,U,6)
 S IBBC(1)="PRINCIPLE: "_U_+IBRCT8_U_$S(IBRCT3'="":+IBRCT3,1:"")
 S IBBC(2)="INTEREST: "_U_+$P(IBRCT8,U,2)_U_$S(IBRCT3'="":$P(IBRCT3,U,2),1:"")
 S IBBC(3)="ADMINISTRATIVE: "_U_+$P(IBRCT8,U,3)_U_$S(IBRCT3'="":$P(IBRCT3,U,3),1:"")
 S IBBC(4)="MARSHALL FEE: "_U_+$P(IBRCT8,U,4)_U_$S(IBRCT3'="":$P(IBRCT3,U,4),1:"")
 S IBBC(5)="COURT COST: "_U_+$P(IBRCT8,U,5)_U_$S(IBRCT3'="":$P(IBRCT3,U,5),1:"")
 Q
 ;
ADDM ; administrative charges
 ; returns:  IBADDM(x) = data lable ^ $ amount  - only if $ amount not 0
 S IBADDM="" Q:IBRCT2=""  N IBI S IBI=1
 I $P(IBRCT2,U,1)>0 S IBADDM(IBI)="IRS LOCATOR: "_U_$P(IBRCT2,U,1),IBI=IBI+1
 I $P(IBRCT2,U,2)>0 S IBADDM(IBI)="CREDIT AGENCY: "_U_$P(IBRCT2,U,2),IBI=IBI+1
 I $P(IBRCT2,U,3)>0 S IBADDM(IBI)="DMV LOCATOR: "_U_$P(IBRCT2,U,3),IBI=IBI+1
 I $P(IBRCT2,U,4)>0 S IBADDM(IBI)="CONSUMER REP: "_U_$P(IBRCT2,U,4),IBI=IBI+1
 I $P(IBRCT2,U,5)>0 S IBADDM(IBI)="MARSHALL FEE: "_U_$P(IBRCT2,U,5),IBI=IBI+1
 I $P(IBRCT2,U,6)>0 S IBADDM(IBI)="COURT COST: "_U_$P(IBRCT2,U,6),IBI=IBI+1
 I $P(IBRCT2,U,7)>0 S IBADDM(IBI)="INTEREST CHARGE: "_U_$P(IBRCT2,U,7),IBI=IBI+1
 I $P(IBRCT2,U,8)>0 S IBADDM(IBI)="ADM. CHARGE: "_U_$P(IBRCT2,U,8),IBI=IBI+1
 Q
 ;
TRCOMM ; sets TRANS. COMMENTS (433,86) into list manager array for display (if any)
 ; requires IBRCT8 and IBSTR - contains lable
 N X,IBI,IBCNT,IBARR
 S X=$P(IBRCT8,U,7) I X'="" D FSTRNG^IBJU1(X,68,.IBARR)
 I +$G(IBARR) S (IBI,IBCNT)=0 F  S IBI=$O(IBARR(IBI)) Q:'IBI  D
 . S IBT=11,IBD=IBARR(IBI) S IBSTR=$$SETLN^IBJTTB1(IBD,IBSTR,IBT,69),IBLN=$$SET^IBJTTB1(IBSTR,IBLN),IBSTR=""
 Q
 ;
COMM ; sets COMMENTS (433,41) into list manager array for display (if any)
 ; requires IBTRNS - ptr to 433 transaction, IBSTR - lable
 N X,IBI,IBCNT,COM,DIWL,DIWR,DIWF K ^UTILITY($J,"W")
 K COM D N7^RCJIBFN1(IBTRNS) S IBI=0 F  S IBI=$O(COM(IBI)) Q:'IBI  D
 . S X=COM(IBI) I X'="" S DIWL=1,DIWR=68,DIWF="" D ^DIWP
 I $D(^UTILITY($J,"W")) S (IBI,IBCNT)=0 F  S IBI=$O(^UTILITY($J,"W",1,IBI)) Q:'IBI  D
 . S IBT=11,IBD=$G(^UTILITY($J,"W",1,IBI,0)) S IBSTR=$$SETLN^IBJTTB1(IBD,IBSTR,IBT,69),IBLN=$$SET^IBJTTB1(IBSTR,IBLN),IBSTR=""
 K ^UTILITY($J,"W"),COM
 Q
 ;
BCSCR ; balance and collection amounts: continuation of screen build
 I IBRCT3'=""!(IBRCT8'=""&(IBRCT8'?1"0^0^0^0^0^0"1E.E)) S IBLN=$$SET(" ",IBLN) S IBT1=20,IBT2=38,IBT3=52,IBSTR="" D
 . S IBT=IBT2,IBD=$J("BALANCE",11) S IBSTR=$$SETLN(IBD,IBSTR,IBT,11)
 . I IBRCT3'="" S IBT=IBT3,IBD=$J("COLLECTED",11) S IBSTR=$$SETLN(IBD,IBSTR,IBT,11)
 . S IBLN=$$SET(IBSTR,IBLN) S IBSTR=""
 . S IBT=IBT2,IBD=$J("-------",11) S IBSTR=$$SETLN(IBD,"",IBT,11)
 . I IBRCT3'="" S IBT=IBT3,IBD=$J("---------",11) S IBSTR=$$SETLN(IBD,IBSTR,IBT,11)
 . S IBLN=$$SET(IBSTR,IBLN) S IBSTR=""
 . ;
 . D BC S IBI=0 F  S IBI=$O(IBBC(IBI)) Q:'IBI  D  S IBLN=$$SET(IBSTR,IBLN) S IBSTR=""
 .. S IBT=IBT1,IBD=$P(IBBC(IBI),U,1) S IBSTR=$$SETLN(IBD,"",IBT,16)
 .. S IBT=IBT2,IBD=$J($P(IBBC(IBI),U,2),11,2) S IBSTR=$$SETLN(IBD,IBSTR,IBT,11)
 .. I IBRCT3'="" S IBT=IBT3,IBD=$J($P(IBBC(IBI),U,3),11,2) S IBSTR=$$SETLN(IBD,IBSTR,IBT,11)
 . ;
 . S IBT=IBT2,IBD=$J("-------",11) S IBSTR=$$SETLN(IBD,"",IBT,11)
 . I IBRCT3'="" S IBT=IBT3,IBD=$J("---------",11) S IBSTR=$$SETLN(IBD,IBSTR,IBT,11)
 . S IBLN=$$SET(IBSTR,IBLN) S IBSTR=""
 . S IBT=IBT1,IBD="TOTAL:" S IBSTR=$$SETLN(IBD,"",IBT,16)
 . S IBT=IBT2,IBD=$J(+IBBC,11,2) S IBSTR=$$SETLN(IBD,IBSTR,IBT,11)
 . I IBRCT3'="" S IBT=IBT3,IBD=$J(+$P(IBBC,U,2),11,2) S IBSTR=$$SETLN(IBD,IBSTR,IBT,11)
 . S IBLN=$$SET(IBSTR,IBLN) S IBSTR=""
 Q
 ;
SETLN(STR,IBX,COL,WD) ;
 S IBX=$$SETSTR^VALM1(STR,IBX,COL,WD)
 Q IBX
 ;
SET(STR,LN) ; set up TMP array with screen data
 N IBX,IBI
 D SET^VALM10(LN,STR)
 S LN=LN+1
SETQ Q LN
