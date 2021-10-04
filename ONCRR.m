ONCRR	;Hines OIFO/GWB - RECONSTRUCTION/RESTORATION  ;09/21/04
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	;
RRIT	;RECONSTRUCTION/RESTORATION (165.5,23)
	;INPUT
	S NTXDD=$G(NTXDD) I NTXDD="" Q
	S SCDXDT=$P($G(^ONCO(165.5,D0,0)),U,16) I SCDXDT="" K X Q
	I SCDXDT<2980000 D  I $D(X),NTXDD=1 S V=1 D NT^ONCODSR
	.K DIC S DIC="^ONCO(160.4," D ^DIC
	.I Y=-1 K X Q
	.S X=$P(Y,U,1) W "  ",$P(^ONCO(160.4,X,0),U,2)
	I SCDXDT>2971231 D
	.S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" W "  No TOPOGRAPHY!" K X Q
	.S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" K X Q
	.;ROADS D-cxliii
	.I ($E(TOP,3,4)=76)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424) S ICD=67141
	.S FOUND=0
	.F XRR=0:0 S XRR=$O(^ONCO(164,ICD,"RR5",XRR)) Q:XRR'>0!(FOUND=1)  D
	..I $P(^ONCO(164,ICD,"RR5",XRR,0),U,2)=X S X=XRR,FOUND=1 Q
	.I FOUND=0 K X Q
	.W "  ",$P(^ONCO(164,ICD,"RR5",X,0),U,1)
	I $D(X),NTXDD=1 S V=1 D NT^ONCODSR
	K SCDXDT,FOUND,ICD,TOP,XRR Q
	;
RROT	;OUTPUT
	S SCDXDT=$P($G(^ONCO(165.5,D0,0)),U,16) I SCDXDT="" Q
	I SCDXDT<2980000 D
	.S:Y'="" Y=$P($G(^ONCO(160.4,Y,0)),U,2)
	I SCDXDT>2971231 D
	.Q:Y=""
	.S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" S Y="" Q
	.S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" S Y="" Q
	.;ROADS D-cxliii
	.I ($E(TOP,3,4)=76)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424) S ICD=67141
	.S Y=$P($G(^ONCO(164,ICD,"RR5",Y,0)),U,1)
	K SCDXDT,ICD,TOP Q
	;
RRHP	;HELP
	S SCDXDT=$P($G(^ONCO(165.5,D0,0)),U,16) I SCDXDT="" Q
	I SCDXDT<2980000 D
	.W !?3,"Select from the following list:"
	.F XRR=0:0 S XRR=$O(^ONCO(160.4,XRR)) Q:XRR'>0  W !?6,$P($G(^ONCO(160.4,XRR,0)),U,1),?12,$P($G(^ONCO(160.4,XRR,0)),U,2)
	I SCDXDT>2971231 D
	.S TOP=$P($G(^ONCO(165.5,D0,2)),U,1) I TOP="" W !,"No TOPOGRAPHY!" Q
	.S ICD=$P($G(^ONCO(164,TOP,0)),U,16) I ICD="" W !,"No ICD Codes!" Q
	.;ROADS D-cxliii
	.I ($E(TOP,3,4)=76)!(TOP=67809)!(TOP=67420)!(TOP=67421)!(TOP=67423)!(TOP=67424) S ICD=67141
	.W !?3,"Select from the following list:",!
	.F XRR=0:0 S XRR=$O(^ONCO(164,ICD,"RR5",XRR)) Q:XRR'>0  W !?6,$P($G(^ONCO(164,ICD,"RR5",XRR,0)),U,2),?12,$P($G(^ONCO(164,ICD,"RR5",XRR,0)),U,1)
	K SCDXDT,ICD,TOP,XRR Q
