HBHCP25	;ALB/KG - HBHC ICD10 CLASS I REMEDIATION PRE/POST-INSTALL ;6/1/2012
	;;1.0;HOSPITAL BASED HOME CARE;**25**;NOV 01, 1993;Build 45
	;
	Q
	;
PRE	;
	;Delete Output Transform from HBHC PATIENT file (#631)
	D BMES^XPDUTL("Deleting Output Transform from HBHC PATIENT file (#631).")
	K ^DD(631,18,2)
	K ^DD(631,18,2.1)
	K ^DD(631,46,2)
	K ^DD(631,46,2.1)
	Q
