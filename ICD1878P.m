ICD1878P	;ALB/JDG - UPDATE DX & PX CODES ; 10/5/11 3:23pm
	;;18.0;DRG Grouper;**78**;Oct 20, 2000;Build 15
	;
	;
	Q
	;
EN	; start update
	; ********************************************************************************
	D ICDUPDPX^ICD1878S ;Update Px code(s)
	; ******************************************************************************** 
	;
	; ********************************************************************************
	D ICDUPPX1^ICD1878S ;update the MDC24 (#1.5) field
	; ********************************************************************************
	;
	; ********************************************************************************
	D ICDUPDDX^ICD1878S ;Update Dx code(s)
	; ********************************************************************************
	;
	; ********************************************************************************
	D UPDTADRG^ICD1878S ;update existing operation/procedure codes
	; ********************************************************************************
	;
	Q
