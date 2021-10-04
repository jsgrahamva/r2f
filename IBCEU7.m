IBCEU7	;ALB/DEM - EDI UTILITIES ;26-SEP-2010
	;;2.0;INTEGRATED BILLING;**432**;21-MAR-94;Build 192
	;;Per VHA Directive 2004-038, this routine should not be modified.
	Q
	;
LNPRVOK(VAL,IBIFN)	; Check bill form & line prov function agree
	; DEM;432 - New routine for Claim Line Provider.
	; VAL = internal value of prov function
	;
	; Allowable line provider functions for UB04 (FORM TYPE = 3)
	; Inpatient and UB04 Outpatient:
	;   - Rendering Provider(3).
	;   - Referring Provider(1).
	;   - Operating Physician(2).
	;   - Other Operating Physician(9).
	;
	; Allowable line provider functions for CMS 1500 (FORM TYPE = 2)
	; Inpatient and CMS 1500 Outpatient:
	;   - Rendering Provider(3).
	;   - Referring Provider(1).
	;   - Supervising Provider(5).
	;
	N OK,IBUB
	S VAL=$$UP^XLFSTR(VAL)
	S OK=$S(VAL'="":1,1:0)
	G:'OK!'$G(IBIFN) PRVQ
	;
	S IBUB=($$FT^IBCEF(IBIFN)=3) ; 1 if UB-04 ; 0 if CMS-1500
	;
	;
	S OK=0
	S:(IBUB)&("1239"[VAL) OK=1  ; UB-04
	S:('IBUB)&("135"[VAL) OK=1  ; CMS-1500
	;
PRVQ	Q OK
	;
LNPRVHLP	;Helptext for line provider function.
	;
	N IBZ,IBQUIT,VALUE,FORMAT
	F IBZ=1:1 S:$P($T(HLPTXT+IBZ),";;",2)="END" IBQUIT=1 Q:$G(IBQUIT)  D
	. S VALUE=$P($T(HLPTXT+IBZ),";;",2)
	. S FORMAT=$S(VALUE="":"!",1:"")
	. D EN^DDIOL(VALUE,"",FORMAT)
	. Q
	Q
	;
HLPTXT	; Helptext for line provider function.
	;;
	;;Enter the name of the line level provider who provided this service.
	;;Line level providers are optional and should only be entered if
	;;different from the claim level provider.
	;;
	;;
	;;END
	;
HLPTXT2	; ***Currently, not activated*** - Helptext for line provider function.
	;;
	;;LINE PROVIDER FUNCTION requirements:
	;;
	;;Allowable line provider functions for UB04 Inpatient and Outpatient:
	;;
	;;  - Rendering Provider(3).
	;;  - Referring Provider(1).
	;;  - Operating Physician(2).
	;;  - Other Operating Physician(9).
	;;
	;;Allowable line provider functions for CMS 1500 Inpatient and Outpatient:
	;;
	;;  - Rendering Provider(3).
	;;  - Referring Provider(1).
	;;  - Supervising Provider(5).
	;;
	;;END
	Q
	;
LNPRVFT(IBFT,IBLNPRV)	; DEM;432 - Field Index "AK" (#301) on FORM TYPE field (399,.19).
	;
	; Description:
	;
	; This function is called by the FORM TYPE (399,.19) "AK" field index.
	; In the case when the FORM TYPE field is changed, then the line
	; provider types are checked to see if any, or all, line providers
	; need to be deleted from the claim.
	;
	; Input:
	;
	; IBFT = FORM TYPE = 2 = (CMS-1500), or FORM TYPE = 3 = (UB-04).
	;        Must be either FORM TYPE 2, or FORM TYPE 3 to continue.
	;        See allowable line provider functions by FORM TYPE below.
	; IBLNPRV = Array passed by reference.
	;
	; Output:
	;
	; OK = 1 = line providers to delete, OK = 0 = no line providers to delete.
	; IBLNPRV Array = If line providers to delete, then array contains
	;                 these line providers - IBLNPRV(399.0404,"IENS",.01)="@"
	;
	; Allowable line provider functions for UB04 (FORM TYPE = 3)
	; Inpatient and UB04 Outpatient:
	;   - Rendering Provider(VAL=3).
	;   - Referring Provider(VAL=1).
	;   - Operating Physician(VAL=2).
	;   - Other Operating Physician(VAL=9).
	;
	; Allowable line provider functions for CMS 1500 (FORM TYPE = 2)
	; Inpatient and CMS 1500 Outpatient:
	;   - Rendering Provider(VAL=3).
	;   - Referring Provider(VAL=1).
	;   - Supervising Provider(VAL=5).
	;
	Q:'$G(IBIFN) 0  ; QUIT 0 if no claim number.
	Q:'$G(IBFT) 0  ; QUIT 0 if no FORM TYPE.
	Q:(IBFT'=2)&(IBFT'=3) 0  ; QUIT 0 - Must be CMS-1500 (2) or UB-04 (3) FORM TYPE.
	;
	N IBPRVFUN,OK
	S:IBFT=3 IBPRVFUN("VAL",IBFT)="1239"  ; Allowable LINE PROVIDER FUNCTIONs for UB-04.
	S:IBFT=2 IBPRVFUN("VAL",IBFT)="135"  ; Allowable LINE PROVIDER FUNCTIONs for CMS-1500.
	;
	S OK=0  ; Initialize OK=0.
	;
	N IBPROCP,IBLPIEN,IBLNPROV,DA
	S IBPROCP=0 F  S IBPROCP=$O(^DGCR(399,IBIFN,"CP",IBPROCP)) Q:'IBPROCP  D  ; Loop on PROCEDURES multiple.
	. Q:'($D(^DGCR(399,IBIFN,"CP",IBPROCP,0))#10)  ; No zero node for procedure.
	. S IBPRVFUN=0 F  S IBPRVFUN=$O(^DGCR(399,IBIFN,"CP",IBPROCP,"LNPRV","B",IBPRVFUN)) Q:'IBPRVFUN  D:IBPRVFUN("VAL",IBFT)'[IBPRVFUN
	. . S IBLPIEN=0 F  S IBLPIEN=$O(^DGCR(399,IBIFN,"CP",IBPROCP,"LNPRV","B",IBPRVFUN,IBLPIEN)) Q:'IBLPIEN  D
	. . . Q:'($D(^DGCR(399,IBIFN,"CP",IBPROCP,"LNPRV",IBLPIEN,0))#10)  ; No zero node for line level provider.
	. . . S IBLNPROV=$P(^DGCR(399,IBIFN,"CP",IBPROCP,"LNPRV",IBLPIEN,0),U,2)
	. . . Q:'IBLNPROV  ; No line provider for this line provider function.
	. . . S OK=1,IBLNPRV(399.0404,IBLPIEN_","_IBPROCP_","_IBIFN_",",.01)="@"  ; We have at leaset one line provider to delete from claim.
	. . . Q
	. . Q
	. Q
	;
	Q OK
	;
REMOVE(IBIFN,IBFT)	; This will be used to remove all line level providers and all line level attachments from inpatient UB claims
	;
	; Input IBIFN - Claim Number
	;
	Q:IBFT'=3   ; Only worried about UBs
	N IBINPAT
	S IBINPAT=$$INPAT^IBCEF(IBIFN) Q:'IBINPAT   ; Quit if it's not an inpatient
	;
	; If we got here, we have an inpatient UB
	; In which case, we should not have any line level providers or line level attachment control numbers
	; If we do, then let's remove them
	;
	N CPIEN,LNPRVIEN,FDA,ERR
	S CPIEN=0 F  S CPIEN=$O(^DGCR(399,IBIFN,"CP",CPIEN)) Q:'+CPIEN  D
	. ;
	. ; Remove the Line level attachments
	. S FDA(399.0304,CPIEN_","_IBIFN_",",70)="@"
	. S FDA(399.0304,CPIEN_","_IBIFN_",",71)="@"
	. S FDA(399.0304,CPIEN_","_IBIFN_",",72)="@"
	. D FILE^DIE("E","FDA")
	. ;
	. K FDA
	. S LNPRVIEN=0 F  S LNPRVIEN=$O(^DGCR(399,IBIFN,"CP",CPIEN,"LNPRV",LNPRVIEN)) Q:'+LNPRVIEN  D
	.. ;
	.. ;Remove the line level providers
	.. S FDA(399.0404,LNPRVIEN_","_CPIEN_","_IBIFN_",",.01)="@"
	. I $D(FDA) D FILE^DIE("E","FDA")
	Q
