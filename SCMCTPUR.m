SCMCTPUR	;BP/DMR - PCMM GUI OEF/OIF SCREEN; 2/24/09
	;;5.3;Scheduling;**504**;AUG 13, 1993;Build 21
	;
	;
START(Y)	;
	S STOP=1,XX=0
	I Y="" Q STOP
	I $$GET1^DIQ(403.47,Y_",",.01)'="OIF OEF" Q STOP
	;
	F  S XX=$O(^SCTM(404.51,XX)) Q:'XX  D
	.S PUR="" S PUR=$P($G(^SCTM(404.51,XX,0)),"^",3)
	.I PUR'="" D
	..I $P($G(^SD(403.47,PUR,0)),"^",1)="OIF OEF" S STOP=0
	Q STOP
