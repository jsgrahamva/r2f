ONCOTNMB	;WISC/MLH - ONCOLOGY - HELPER for TNM codes ;8/21/93  11:55
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	;
MMEYELID	;Check stage indicator for PATHOLOGIC or OTHER
	I (STGIND="P")!(STGIND="O")!(STGIND="R") S SC=37
	E  D
	.Q:$G(ONCOED)=5
	.W:$G(WFLG)="Y" !?5,"No CLINICAL T classification of MALIGNANT MELANOMA OF THE EYELID is",!?5,"recommended.",!
	.S ST="" K X
	Q
