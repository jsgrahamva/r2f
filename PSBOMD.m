PSBOMD	;BIRMINGHAM/EFC-MISSING DOSE REPORT ;12/7/12 12:41pm
	;;3.0;BAR CODE MED ADMIN;**70**;Mar 2004;Build 101
	;
	; Reference/IA
	; WARD^NURSUT5/3052
	; IN5^VADPT/10061
	; $$GET1^DIQ(52.6/436
	; $$GET1^DIQ(52.7/437
	;
	;*70 - Allow a Clinc Order only version of this report.
	;
EN	; Begin printing
	N PSBSCHD,PSBWRD,PSBSTRT,PSBSTOP,PSBWARD,PSBDRUG,PSBDT,PSBIEN,PSBWRDA
	N CLNMODE                                                        ;*70
	K ^TMP("PSB",$J)
	S CLNMODE=$S($P(PSBRPT(.1),U)="C":1,1:0)      ;clinic mode T/F    *70
	;Ward mode                                                        *70
	D:'CLNMODE
	.S PSBWRD=+$P(PSBRPT(.1),U,3)
	.I PSBWRD D WARD^NURSUT5("L^"_PSBWRD,.PSBWRDA) S X="" F  S X=$O(PSBWRDA(PSBWRD,2,X)) Q:X=""  S Y=PSBWRDA(PSBWRD,2,X,.01),PSBWRD(+Y)=$P(Y,U,2),^TMP("PSB",$J,PSBWRD(+Y))=0
	;Clinic mode                                                     *70
	D:CLNMODE
	.S PSBWRD=+$P(PSBRPT(4),U,3),PSBWRD(PSBWRD)=$P($G(^SC(PSBWRD,0)),U)
	.Q:PSBWRD(PSBWRD)=""
	.S ^TMP("PSB",$J,PSBWRD(PSBWRD))=0
	;
	S PSBSTRT=$P(PSBRPT(.1),U,6)+$P(PSBRPT(.1),U,7)
	S PSBSTOP=$P(PSBRPT(.1),U,8)+$P(PSBRPT(.1),U,9)
	S PSBDT=PSBSTRT-.0000001
	F  S PSBDT=$O(^PSB(53.68,"ADTE",PSBDT)) Q:'PSBDT!(PSBDT>PSBSTOP)  D
	.S PSBIEN=0
	.F  S PSBIEN=$O(^PSB(53.68,"ADTE",PSBDT,PSBIEN))  Q:'PSBIEN  D
	..;check ward or clinic for ALL or selection via  by array       *70
	..I CLNMODE S PSBWARD=$$GET1^DIQ(53.68,PSBIEN_",",1) Q:PSBWARD=""
	..I CLNMODE,PSBWRD,'$D(PSBWRD(+$P($G(^PSB(53.68,PSBIEN,1)),U))) Q
	..I 'CLNMODE S PSBWARD=$$GET1^DIQ(53.68,PSBIEN_",",.12) Q:PSBWARD=""
	..I 'CLNMODE,PSBWRD,'$D(PSBWRD(+$P($G(^PSB(53.68,PSBIEN,.1)),U,2))) Q
	..;end check                                                     *70
	..S PSBDRUG=$$GET1^DIQ(53.68,PSBIEN_",",.13) I PSBDRUG="" D
	...S PSBDRUG="NO DATA"
	...I $D(^PSB(53.68,PSBIEN,.6)) S X=0 F  S X=$O(^PSB(53.68,+PSBIEN,.6,X)) Q:'X  S PSBDRUG=$$GET1^DIQ(52.6,+^PSB(53.68,PSBIEN,.6,X,0),.01)
	...I $D(^PSB(53.68,PSBIEN,.7)) S X=0 F  S X=$O(^PSB(53.68,+PSBIEN,.7,X)) Q:'X  S PSBDRUG=PSBDRUG_"  "_$$GET1^DIQ(52.7,+^PSB(53.68,+PSBIEN,.7,X,0),.01)
	..S PSBSCHD=$$GET1^DIQ(53.68,PSBIEN_",",.19) S:PSBSCHD="" PSBSCHD="NO DATA"
	..S ^TMP("PSB",$J,PSBWARD,PSBDRUG,PSBSCHD)=$G(^TMP("PSB",$J,PSBWARD,PSBDRUG,PSBSCHD))+1
	..S ^TMP("PSB",$J,PSBWARD)=+$G(^TMP("PSB",$J,PSBWARD))+1
	..S ^TMP("PSB",$J)=+$G(^TMP("PSB",$J))+1
	W $$HDR()
	I '$D(^TMP("PSB",$J)) W !!?5,"<<<NO MISSING DOSE REQUESTS FOR THIS TIME FRAME>>>" Q
	;print ward report
	S PSBWARD=""
	F  S PSBWARD=$O(^TMP("PSB",$J,PSBWARD)) Q:PSBWARD=""  D
	.W:$Y>(IOSL-10) $$HDR()
	.W !,PSBWARD
	.S (PSBDRUG,PSBSCHD)=""
	.F  S PSBDRUG=$O(^TMP("PSB",$J,PSBWARD,PSBDRUG)) Q:PSBDRUG=""  D
	..F  S PSBSCHD=$O(^TMP("PSB",$J,PSBWARD,PSBDRUG,PSBSCHD)) Q:PSBSCHD=""  D
	...W:$Y>(IOSL-10) $$HDR()
	...W ?32,PSBDRUG,?74,$J(+^TMP("PSB",$J,PSBWARD,PSBDRUG,PSBSCHD),8),!,?35,"Schedule: "_PSBSCHD,!
	.W ?74,"--------"
	.W !,?31,PSBWARD," Total: ",?74,$J(^TMP("PSB",$J,PSBWARD),8),!
	W ?74,"========"
	W !,?31,"Report Total: "
	W ?74,$J(+$G(^TMP("PSB",$J)),8)
	K ^TMP("PSB",$J)
	Q
	;
HDR()	;
	I '$D(PSBRPT("DATE")) D NOW^%DTC S Y=+$E(%,1,12) D D^DIQ S PSBRPT("DATE")="Run Date: "_Y
	S:'$D(PSBRPT("PAGE")) PSBRPT("PAGE")=1
	W:$Y>1 @IOF
	W !,$TR($J("",IOM)," ","="),!,"MISSING DOSE REPORT FROM "
	S Y=PSBSTRT D D^DIQ W Y," thru "
	S Y=PSBSTOP D D^DIQ W Y
	W ?(IOM-$L(PSBRPT("DATE"))),PSBRPT("DATE"),!,$S(PSBWRD:"SELECTED",1:"ALL")
	W:'CLNMODE " WARDS"                                              ;*70
	W:CLNMODE " CLINICS"                                             ;*70
	S X="Page: "_PSBRPT("PAGE")
	W ?(IOM-$L(X)),X
	S PSBRPT("PAGE")=PSBRPT("PAGE")+1
	W !,$TR($J("",IOM)," ","="),!
	W:CLNMODE "Clinic" W:'CLNMODE "Ward"                             ;*70
	W ?32,"Medication",?77,"Total",!,$TR($J("",IOM)," ","-"),!
	Q ""
	;
POST	;
	N DFN
	S DFN=X D IN5^VADPT
	S PSBDDSW=$P(VAIP(5),U,2)
	S PSBDDSR=$P(VAIP(6),U,2)
	Q 
