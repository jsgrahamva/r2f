PSO408PI	;BIRM/MFR - PSO*7*408 Post-install routine ;11/26/12
	;;7.0;OUTPATIENT PHARMACY;**408**;DEC 1997;Build 100
	;
EN	; - Entry Point
	N PSOROOT
	D OPTSTAT^XUTMOPT("PSO SPMP SCHEDULED EXPORT",.PSOROOT)
	I '+$G(PSOROOT(1)) D RESCH^XUTMOPT("PSO SPMP SCHEDULED EXPORT",$$FMADD^XLFDT(DT,1)+.01,"","24H","L")
	Q
	;
