PXAIICR	;BPFO/LMT - Set the IMM CONTRA/REFUSAL nodes ;11/18/15  11:34
	;;1.0;PCE PATIENT CARE ENCOUNTER;**215**;Aug 12, 1996;Build 10
	;
ICR	;Main entry point.
	;
	K PXAERR
	S PXAERR(8)=PXAK
	S PXAERR(7)="IMM CONTRA/REFUSAL"
	;
	N IND,PXAA
	S IND=""
	F  S IND=$O(@PXADATA@("IMM CONTRA/REFUSAL",PXAK,IND)) Q:IND=""  D
	. S PXAA(IND)=@PXADATA@("IMM CONTRA/REFUSAL",PXAK,IND)
	;
	;Validate the data.
	N STOP
	D VAL^PXAIICRV
	I $G(STOP) Q
	;
SETVARA	;Set the after visit variables.
	N AFTER0,AFTER12,AFTER811,AFTER812
	;
	S $P(AFTER0,U,1)=$G(PXAA("CONTRA/REFUSAL"))
	I $G(PXAA("DELETE")) S $P(AFTER0,U,1)="@"
	S $P(AFTER0,U,2)=$G(PATIENT)
	S $P(AFTER0,U,3)=$G(PXAVISIT)
	S $P(AFTER0,U,4)=$G(PXAA("IMMUN"))
	S $P(AFTER0,U,5)=$G(PXAA("WARN UNTIL DATE"))
	S $P(AFTER12,U,1)=$G(PXAA("EVENT D/T"))
	S $P(AFTER12,U,4)=$G(PXAA("ENC PROVIDER"))
	S $P(AFTER811,U,1)=$G(PXAA("COMMENT"))
	;
	;--PACKAGE AND SOURCE
	S $P(AFTER812,"^",2)=$G(PXAPKG)
	S $P(AFTER812,"^",3)=$G(PXASOURC)
	;
	S ^TMP("PXK",$J,"ICR",PXAK,0,"AFTER")=AFTER0
	S ^TMP("PXK",$J,"ICR",PXAK,12,"AFTER")=AFTER12
	S ^TMP("PXK",$J,"ICR",PXAK,811,"AFTER")=AFTER811
	S ^TMP("PXK",$J,"ICR",PXAK,812,"AFTER")=AFTER812
	;
SETVARB	;Set the before variables.
	N BEFOR0,BEFOR12,BEFOR811,BEFOR812,IENB
	;
	S IENB=""
	S IENB=$O(^AUPNVICR("AC",+$G(PXAVISIT),+$G(PXAA("IMMUN")),$G(PXAA("CONTRA/REFUSAL")),IENB))
	;
	I $G(IENB) D
	. S BEFOR0=$G(^AUPNVICR(IENB,0))
	. S BEFOR12=$G(^AUPNVICR(IENB,12))
	. S BEFOR811=$G(^AUPNVICR(IENB,811))
	. S BEFOR812=$G(^AUPNVICR(IENB,812))
	E  S (BEFOR0,BEFOR12,BEFOR811,BEFOR812)=""
	;
	S ^TMP("PXK",$J,"ICR",PXAK,0,"BEFORE")=BEFOR0
	S ^TMP("PXK",$J,"ICR",PXAK,12,"BEFORE")=BEFOR12
	S ^TMP("PXK",$J,"ICR",PXAK,811,"BEFORE")=BEFOR811
	S ^TMP("PXK",$J,"ICR",PXAK,812,"BEFORE")=BEFOR812
	S ^TMP("PXK",$J,"ICR",PXAK,"IEN")=IENB
	;
	Q
