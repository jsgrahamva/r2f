PXRRPCE5	;HIN/MjK - Clinic Specific Caseload Demographics ;6/7/96
	;;1.0;PCE PATIENT CARE ENCOUNTER;**189**;Aug 12, 1996;Build 13
	;;Reference to ^GMRD(120.51 supported by DBIA 1382
	;;Reference to ^PXRMINDX(120.5 supported by DBIA 4290
	;;Reference to EN^GMVPXRM supported by DBIA 3647
BP	;_._._._._._._._._._._._._.Blood Pressure_._._._._._._._._._._._._._.
	;PX/189 removed direct global reads to get data from PXRMINDX
	N PXRRNODE,PXRRSXDR,PXRRVT,PXRRSXDT
	S PXRRDFN=0,PXRRVT=$O(^GMRD(120.51,"C","BP",0))
	Q:PXRRVT'>0
	F  S PXRRDFN=$O(^TMP($J,PXRRCLIN,"CLINIC PATIENTS",PXRRDFN)) Q:'PXRRDFN  D
	.S PXRRSXDT=PXRRSXMO-.000001
	.F  S PXRRSXDT=$O(^PXRMINDX(120.5,"PI",PXRRDFN,PXRRVT,PXRRSXDT)) Q:'PXRRSXDT!(PXRRSXDT>DT)  D
	..S PXRRBIEN=0
	..F  S PXRRBIEN=$O(^PXRMINDX(120.5,"PI",PXRRDFN,PXRRVT,PXRRSXDT,PXRRBIEN)) Q:$L(PXRRBIEN)'>0  D
	...D EN^GMVPXRM(.PXRRNODE,PXRRBIEN,"I")
	...I $P(PXRRNODE(1),U,1)=-1 Q
	...S X=$P(PXRRNODE(7),U,1),Y=$P(X,"/"),Z=$P(X,"/",2) D
	....;X = blood pressure ;y = systolic bp ;z = diastolic bp
	....I Y>159!(Z>90) D
	.....S PXRRNODE=$P(PXRRNODE(1),U,1)_U_$P(PXRRNODE(2),U,1)_U_$P(PXRRNODE(3),U,1)_U_$P(PXRRNODE(4),U,1)_U_$P(PXRRNODE(5),U,1)_U_$P(PXRRNODE(6),U,1)_U_""_U_$P(PXRRNODE(7),U,1)
	.....S ^TMP($J,"HIBP",PXRRCLIN,PXRRDFN)=Y_"/"_Z_U_$G(PXRRNODE)
	....Q
	...Q
	..Q
	.Q
	S (PXRRBPT,PXRRDFN)=0 F  S PXRRDFN=$O(^TMP($J,"HIBP",PXRRCLIN,PXRRDFN)) Q:'PXRRDFN  S PXRRBPT=PXRRBPT+1
PERCNT1	;_._._._._._._._._._.Calculate % Pats by DXS_._._._._._._._._._.
	F PXRR="PXRRDM","PXRRHTN","PXRRCAD","PXRRHLIP","PXRRHTDM","PXRRHLIP" S Y=@PXRR S PXRR(PXRR)=$S('Y:0,1:(Y/PXRRVPAT)*100)
PERCNT2	;_._._._._._._.Percentages for Preventive Medicine Data_._._._._._._.
	I PXRRTPAT S PXRR("SMOKE")=(PXRRSMYR/PXRRTPAT)*100 S PXRR("MAMGRM")=$S(+PXRRF50:(PXRRMMYR/PXRRF50)*100,1:"N/A")
	I +PXRR("MAMGRM") S PXRR("MAMGRM")=$J(PXRR("MAMGRM"),2,1)
	S PXRRHBA1=$S(+PXRRHBA1:$J(PXRRHBA1,2,1),1:PXRRHBA1),PXRRLDL=$S(+PXRRLDL:$J(PXRRLDL,2,1),1:PXRRLDL)
TOTS	S ^TMP($J,"CLINIC TOTALS",PXRRCLIN)=PXRRTVS_U_PXRRSESS_U_PXRRAG_U_PXRRCAD_U_$J(PXRR("PXRRCAD"),2,1)_U_PXRRDM_U_$J(PXRR("PXRRDM"),2,1)_U_PXRRHTN_U_$J(PXRR("PXRRHTN"),2,1)_U_PXRRHTDM_U_$J(PXRR("PXRRHTDM"),2,1)_U_PXRRHBA1
	S X=PXRRCDSM_U_PXRRLDL_U_PXRRNOLD_U_$J($G(PXRR("PXRRSXUN")),2,1)_U_$J($G(PXRR("PXRRSXER")),2,1)_U_$J($G(PXRR("PXRRSXHP")),2,1)_U_PXRRSMYR_U_PXRRMMYR_U_PXRRUTVS_U_$J($G(PXRR("SMOKE")),2,1)
	S Y=$G(PXRR("MAMGRM"))_U_$J(PXRRHLIP,2,1)_U_$J($G(PXRR("PXRRHLIP")),2,1)_U_PXRRRTVS_U_$J(PXRRPTSS,2,1)_U_PXRRMPAT_U_PXRRFPAT_U_PXRRHBG7_U_PXRRGL_U_PXRRCHOL_U_PXRRCDSX_U_$J(PXRR("PXRRPSUT"),2,1)_U_$J(PXRR("PXRRCOST"),4,2)
	S Z=PXRRBPT_U_PXRRF50
	S ^TMP($J,"CLINIC TOTALS",PXRRCLIN)=^TMP($J,"CLINIC TOTALS",PXRRCLIN)_U_X_U_Y_U_Z
	Q
MEAN	;_._._._._._.Calculate Mean Against Selected Clinics_._._._._._._.
	S (X,Y)=0 F  S X=$O(^TMP($J,"CLINIC TOTALS",X)) Q:'X  S Y=Y+1
	S PXRRCNUM=Y
	F I=5,7,9,11,12,13,14,16,17,18,21,22,23,25,30,31,32,33,34,35,36 S ^TMP($J,"MEAN",I)=0,PXRRCLIN=0 F  S PXRRCLIN=$O(^TMP($J,"CLINIC TOTALS",PXRRCLIN)) Q:'PXRRCLIN  D
	. I I=12!(I=14) S Z=$P(^TMP($J,"CLINIC TOTALS",PXRRCLIN),U,I),^TMP($J,"MEAN",I)=^TMP($J,"MEAN",I)+$S('Z&(PXRRCNUM-1):^TMP($J,"MEAN",I)/(PXRRCNUM-1),1:Z) Q
	. S Z=$P(^TMP($J,"CLINIC TOTALS",PXRRCLIN),U,I),^TMP($J,"MEAN",I)=^TMP($J,"MEAN",I)+Z
	F I=35 S ^TMP($J,"MEAN",I)=^TMP($J,"MEAN",I)/PXRRCNUM,^TMP($J,"MEAN",I)=$S(+^TMP($J,"MEAN",I):$J(^TMP($J,"MEAN",I),4,2),1:"N/A")
	F I=12,14 S ^TMP($J,"MEAN",I)=^TMP($J,"MEAN",I)/PXRRCNUM,^TMP($J,"MEAN",I)=$S(+^TMP($J,"MEAN",I):$J(^TMP($J,"MEAN",I),2,1),1:"N/A")
	F I=5,7,9,11,13,16,17,18,21,22,23,25,30,31,32,33,34,36 S ^TMP($J,"MEAN",I)=$J((^TMP($J,"MEAN",I)/PXRRCNUM),2,1)
	Q
INITVAR	S (PXRRCAD,PXRRSESS,PXRRAG,PXRRAGE,PXRRTVS,PXRRSXUN,PXRRVPAT,PXRRQPAT,PXRRTPAT,PXRRMPAT,PXRRPSUT,PXRRCOST)=0
	S X1=PXRREDT,X2=-180 D C^%DTC S PXRRSXMO=X,X1=PXRREDT,X2=-365 D C^%DTC S PXRRYR=X
	Q
