PXRHS04	; SLC/SBW - PCE Visit Skin Test Data Extract ;11/25/96
	;;1.0;PCE PATIENT CARE ENCOUNTER;**13,206**;Aug 12, 1996;Build 50
SKIN(DFN)	; Control branching
	;INPUT  : DFN      - Pointer to PATIENT file (#2)
	;OUTPUT : 
	;  Data from V SKIN TEST (9000010.12) file
	;  ^TMP("PXS,$J,SKIN,InvDt,IFN,0) = SKIN TEST [E;.01]
	;     ^ EVENT DATE/TIME or VISIT/ADMIT DATE&TIME [I;1201 or .03] 
	;     ^ RESULTS CODE [I;.04] ^ RESULTS [E;.04] ^ READING [E;.05]
	;     ^ DATE READ [I;.06] ^ ORDERING PROVIDER [E;1202]
	;     ^ ENCOUNTER PROVIDER [E;1204]
	;  ^TMP("PXS",$J,SKIN,InvDt,IFN,1) = ^ HOSPITAL LOCATION [E;9000010;.22] 
	;     ^ HOSP. LOC. ABBREVIATION [E;44;1]
	;     ^ LOC OF ENCOUNTER [E;9000010;.06] ^ OUTSIDE LOC [E;9000010;2101]
	;  ^TMP("PXS",$J,SKIN,InvDt,IFN,"S") = DATA SOURCE [E;80102]
	;
	;   [] = [I(nternal)/E(xternal); Optional file #; Record #]
	;   Subscripts:
	;     SKIN  - Skin Test name
	;     InvDt - Inverse FileMan date of DATE OF event or visit
	;     IFN   - Internal Record #
	;
	Q:$G(DFN)']""!'$D(^AUPNVSK("AA",DFN))
	N PXSK,PXIVD,PXIFN,IHSDATE
	S IHSDATE=9999999-$$HSDATE^PXRHS01
	K ^TMP("PXS",$J)
	S PXSK=""
	F  S PXSK=$O(^AUPNVSK("AA",DFN,PXSK)) Q:PXSK=""  D
	. S PXIVD=0
	. F  S PXIVD=$O(^AUPNVSK("AA",DFN,PXSK,PXIVD)) Q:PXIVD'>0  Q:PXIVD>IHSDATE  D
	. . S PXIFN=0
	. . F  S PXIFN=$O(^AUPNVSK("AA",DFN,PXSK,PXIVD,PXIFN)) Q:PXIFN'>0  D
	. . . N DIC,DIQ,DR,DA,REC,VDATA,SKIN,SKDT,RESULTC,RESULT,READING,RDT
	. . . N OPROV,EPROV,HLOC,HLOCABB,SOURCE,IDT,COMMENT,PXSKIEN
	. . . S DIC=9000010.12,DA=PXIFN,DIQ="REC(",DIQ(0)="IE"
	. . . S DR=".01;.03;.04;.05;.06;1201;1202;1204;80102;81101"
	. . . D EN^DIQ1
	. . . Q:'$D(REC)
	. . . S VDATA=$$GETVDATA^PXRHS03(+REC(9000010.12,DA,.03,"I"))
	. . . S SKIN=REC(9000010.12,DA,.01,"E")  ;+ORIG
	. . . S PXSKIEN=REC(9000010.12,DA,.01,"I")  ;get SKIN TEST IEN
	. . . ;replace Name with PRINT NAME for National records
	. . . I $P($G(^AUTTSK(+PXSKIEN,12)),U)]"" S SKIN=$P(^AUTTSK(+PXSKIEN,12),U)
	. . . I $L(SKIN)>11 D  ;name longer than 11 characters
	. . . . S SKIN=$E(SKIN,1,10)_"*"  ;truncate
	. . . S SKDT=REC(9000010.12,DA,1201,"I")
	. . . S:SKDT']"" SKDT=$P(VDATA,U)
	. . . S IDT=9999999-SKDT
	. . . S RESULTC=REC(9000010.12,DA,.04,"I")
	. . . S RESULT=REC(9000010.12,DA,.04,"E")
	. . . S READING=REC(9000010.12,DA,.05,"E")
	. . . S RDT=REC(9000010.12,DA,.06,"I")
	. . . S OPROV=REC(9000010.12,DA,1202,"E")
	. . . S EPROV=REC(9000010.12,DA,1204,"E")
	. . . S HLOC=$P(VDATA,U,5)
	. . . S HLOCABB=$P(VDATA,U,6)
	. . . S SOURCE=REC(9000010.12,DA,80102,"E")
	. . . S COMMENT=REC(9000010.12,DA,81101,"E")
	. . . S ^TMP("PXS",$J,SKIN,IDT,DA,0)=SKIN_U_SKDT_U_RESULTC_U_RESULT_U_READING_U_RDT_U_OPROV_U_EPROV
	. . . S ^TMP("PXS",$J,SKIN,IDT,DA,1)=HLOC_U_HLOCABB_U_$P(VDATA,U,2)_U_$P(VDATA,U,4)
	. . . S ^TMP("PXS",$J,SKIN,IDT,DA,"S")=SOURCE
	. . . S ^TMP("PXS",$J,SKIN,IDT,DA,"COM")=COMMENT
	Q
