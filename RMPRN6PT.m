RMPRN6PT	;HINES/HNC -PRINT NPPD NEW WORKSHEETS ;2/14/98
	;;3.0;PROSTHETICS;**31,32,39,51,57,84,103,144**;Feb 09, 1996;Build 17
	;
	; AAC Patch 84, 02-25-04, additions, deletions and change descriptions for Groups and lines
	; AAC Patch 84, 02-25-04, Change Description for 600
	; AAC PATCH 103, 01-17-05 NPPD CATEGORIES/LINES -  NEW and REPAIR
	;
	K ^TMP($J,"NS")
	S STN=1
	S SSNCT=0,BDC=0
	F  S BDC=$O(^TMP($J,"A",BDC)) Q:BDC'>0  S SSNCT=SSNCT+1
	K BDC,^TMP($J,"A")
	F  S STN=$O(^TMP($J,"N",STN)) Q:STN=""  W:$E(IOST,1,2)="C-" @IOF D HDR,CDATA,SUM
	Q
HDR	;
	;W @IOF
	W !,"REPORT OF NEW PROSTHETICS ACTIVITIES"
	;header based on sort select
	W !,$$HDR^RMPRN6S(RMPRDET)
	S Y=DATE(1) D DD^%DT S DATE(3)=Y W !,DATE(3)," - " S Y=DATE(2) D DD^%DT S DATE(4)=Y W DATE(4)
	W !,?10,"STATION: ",STN
	;RMPRSUM if summary header
	Q:$G(RMPRSUM)
	W !!
	W !,"Line",?6,"Item",?21,"VA",?26,"Com",?31,"Total",?37,"Cost",?46
	W "Ave Com",?54
	W "SC/OP",?61,"NSC/OP",?68,"SC/IP",?74,"NSC/IP"
	I IOM>120 D
	.W ?83,"SP LEG"
	.W ?90,"A&A",?97,"PHC",?104,"ELG REF",?112,"NEW",?120,"$ELG REF"
	Q
CDATA	;
	S LINE="",LINEP=""
	S (CA,CB,CC,CD,CE,CF,CG,CH,CI,CJ,CK,CL,CM)=0
	F  S LINE=$O(^TMP($J,"N",STN,LINE)) Q:LINE=""  Q:FL=1  D
	.I $E(LINE,0,3)'=$E(LINEP,0,3) D SUM Q:FL=1  D LBL
	.W !,LINE,?6,$E($P(^TMP($J,"N",STN,LINE),U,15),1,15)
	.W ?21,$P(^TMP($J,"N",STN,LINE),U,1) S CA=CA+$P(^(LINE),U,1)
	.W ?26,$P(^TMP($J,"N",STN,LINE),U,2) S CB=CB+$P(^(LINE),U,2)
	.W ?31,$P(^TMP($J,"N",STN,LINE),U,1)+($P(^TMP($J,"N",STN,LINE),U,2))
	.W ?37,$FN($J($P(^TMP($J,"N",STN,LINE),U,3),0,0),",") S CC=CC+$P(^(LINE),U,3)
	.W:$P(^TMP($J,"N",STN,LINE),U,2)>0 ?46,$FN($J(($P(^(LINE),U,3))/($P(^(LINE),U,2)),0,0),",")
	.W ?55,$P(^TMP($J,"N",STN,LINE),U,4) S CD=CD+$P(^(LINE),U,4)
	.W ?62,$P(^TMP($J,"N",STN,LINE),U,5) S CE=CE+$P(^(LINE),U,5)
	.W ?69,$P(^TMP($J,"N",STN,LINE),U,6) S CF=CF+$P(^(LINE),U,6)
	.W ?76,$P(^TMP($J,"N",STN,LINE),U,7) S CG=CG+$P(^(LINE),U,7)
	.S CH=CH+$P(^TMP($J,"N",STN,LINE),U,8)
	.S CI=CI+$P(^TMP($J,"N",STN,LINE),U,9)
	.S CJ=CJ+$P(^TMP($J,"N",STN,LINE),U,10)
	.S CK=CK+$P(^TMP($J,"N",STN,LINE),U,11)
	.S CL=CL+$P(^TMP($J,"N",STN,LINE),U,12)
	.S CM=CM+$P(^TMP($J,"N",STN,LINE),U,16)
	.I IOM>120 D
	..W ?83,$P(^TMP($J,"N",STN,LINE),U,8)
	..W ?90,$P(^TMP($J,"N",STN,LINE),U,9)
	..W ?97,$P(^TMP($J,"N",STN,LINE),U,10)
	..W ?104,$P(^TMP($J,"N",STN,LINE),U,11)
	..W ?112,$P(^TMP($J,"N",STN,LINE),U,12)
	..W ?120,$P(^TMP($J,"N",STN,LINE),U,16)
	.S LINEP=LINE
	Q
SUM	;Print summary for group
	Q:FL=1
	I LINEP'="" D  Q:FL=1
	.I $Y+13>IOSL,IOST["C-" D CHK Q:FL=1
	.S GROUPT=CA_U_CB_U_(CA+CB)_U_$J(CC,0,0)_U_CD_U_CE_U_CF_U_CG_U_CH_U_CI_U_CJ_U_CK_U_CL_U_CM
	.W !,LN,!
	.W ?21,CA,?26,CB,?31,(CA+CB),?37,$FN($J(CC,0,0),","),?55,CD,?62,CE,?69,CF,?76,CG
	.I IOM>120 W ?83,CH,?90,CI,?97,CJ,?104,CK,?112,CL,?120,CM
	.W !
	.D LBLG
	.S ^TMP($J,"NS",STN,GROUP,STN)=GROUPT
	.S (CA,CB,CC,CD,CE,CF,CG,CH,CI,CJ,CK,CL,CM)=0
	Q:$G(LINEP)'="999 Z"
	D FSUM S RMPRSUM=1 W @IOF D HDR K RMPRSUM
	W !!,"STATION SUMMARY (NEW ACTIVITIES)"
	;W !,$$HDR^RMPRN6S(RMPRDET)
	W !,?21,"VA",?31,"Com",?41,"Total",?51,"Cost",?61
	W "Ave Com",?71,"Elg Ref $"
	W !,LN
	W !,?21,$FN(CA,","),?31,$FN(CB,","),?41,$FN((CA+CB),","),?51,"$"_$FN($J(CC,0,0),",")
	I CB>0 W ?61,"$"_$FN($J((CC/CB),0,0),",")
	I CM>0 W ?71,"$"_$FN($J(CM,0,0),",")
	W !,LN,!!
	W ?21,"SC/OP",?31,"NSC/OP",?41,"SC/IP",?51,"NSC/IP"
	W !,LN,!,?21,CD,?31,CE,?41,CF,?51,CG
	W !,LN
	W !,?21,"SPEC LEG",?31,"A&A",?41,"PHC",?51,"ELG REF",?61,"NEW"
	W !,LN,!,?21,CH,?31,CI,?41,CJ,?51,CK,?61,CL,!,LN
	W !,?21,"Total Disability: ",$FN((CD+CE+CF+CG),","),?47,"Unique SSN: ",SSNCT,!
	S (CA,CB,CC,CD,CE,CF,CG,CH,CI,CJ,CK,CL,CM)=0
	I IOST["C-" D CHK
	Q
LBLG	;group description for final summary
	I $E(LINEP,0,3)=100 S GROUP=$E(LINEP,0,3)_" WHEELCHAIRS AND ACCESSORIES"
	I $E(LINEP,0,3)=200 S GROUP=$E(LINEP,0,3)_" ARTIFICIAL LEGS"
	I $E(LINEP,0,3)=300 S GROUP=$E(LINEP,0,3)_" ARTIFICIAL ARMS AND TERMINAL DEVICES"
	I $E(LINEP,0,3)=400 S GROUP=$E(LINEP,0,3)_" ORTHOSIS/ORTHOTICS"
	I $E(LINEP,0,3)=500 S GROUP=$E(LINEP,0,3)_" SHOES/ORTHOTICS"
	I $E(LINEP,0,3)=600 S GROUP=$E(LINEP,0,3)_" SENSORI-NEURO AIDS"
	I $E(LINEP,0,3)=700 S GROUP=$E(LINEP,0,3)_" RESTORATIONS"
	I $E(LINEP,0,3)=800 S GROUP=$E(LINEP,0,3)_" OXYGEN AND RESPIRATORY"
	I $E(LINEP,0,3)=900 S GROUP=$E(LINEP,0,3)_" MEDICAL EQUIPMENT"
	I $E(LINEP,0,3)=910 S GROUP=$E(LINEP,0,3)_" ALL OTHER SUPPLIES AND EQUIPMENT"
	I $E(LINEP,0,3)=920 S GROUP=$E(LINEP,0,3)_" HOME DIALYSIS PROGRAM"
	I $E(LINEP,0,3)=930 S GROUP=$E(LINEP,0,3)_" ADAPTIVE EQUIPMENT"
	I $E(LINEP,0,3)=940 S GROUP=$E(LINEP,0,3)_" HISA"
	I $E(LINEP,0,3)=960 S GROUP=$E(LINEP,0,3)_" SURGICAL IMPLANTS"
	I $E(LINEP,0,3)=970 S GROUP=$E(LINEP,0,3)_" BIOLOGICAL IMPLANTS"
	I $E(LINEP,0,3)=999 S GROUP=$E(LINEP,0,3)_" MISC"
	Q
LBL	;label for group
	I $E(LINE,0,3)=100 W !,"WHEELCHAIRS AND ACCESSORIES"
	I $E(LINE,0,3)=200 W !,"ARTIFICIAL LEGS"
	I $E(LINE,0,3)=300 W !,"ARTIFICIAL ARMS AND TERMINAL DEVICES"
	I $E(LINE,0,3)=400 W !,"ORTHOSIS/ORTHOTICS"
	I $E(LINE,0,3)=500,IOST'["C-" W @IOF D HDR W !,"SHOES/ORTHOTICS"
	I $E(LINE,0,3)=500,IOST["C-" W !,"SHOES/ORTHOTICS"
	I $E(LINE,0,3)=600 W !,"SENSORI-NEURO AIDS"
	I $E(LINE,0,3)=700 W !,"RESTORATIONS"
	I $E(LINE,0,3)=800 W !,"OXYGEN AND RESPIRATORY"
	I $E(LINE,0,3)=900,IOST'["C-" W @IOF D HDR W !,"MEDICAL EQUIPMENT"
	I $E(LINE,0,3)=900,IOST["C-" W !,"MEDICAL EQUIPMENT"
	I $E(LINE,0,3)=910 W !,"ALL OTHER SUPPLIES AND EQUIPMENT"
	I $E(LINE,0,3)=920 W !,"HOME DIALYSIS PROGRAM"
	I $E(LINE,0,3)=930 W !,"ADAPTIVE EQUIPMENT"
	I $E(LINE,0,3)=940 W !,"HISA"
	I $E(LINE,0,3)=960 W !,"SURGICAL IMPLANTS"
	I $E(LINE,0,3)=970 W !,"BIOLOGICAL IMPLANTS"
	I $E(LINE,0,3)=999,IOST'["C-" W @IOF D HDR W !,"MISC"
	I $E(LINE,0,3)=999,IOST["C-" W !,"MISC"
	Q
FSUM	;final summay on New Worksheets STATION
	S H=0
	F  S H=$O(^TMP($J,"NS",STN,H)) Q:H=""  D
	.S H1=0,H2=0
	.F  S H1=$O(^TMP($J,"NS",STN,H,H1)) Q:H1=""  D
	..Q:H1'=STN
	..S H2=^TMP($J,"NS",STN,H,H1)
	..S CA=CA+$P(H2,U,1)
	..S CB=CB+$P(H2,U,2)
	..S CC=CC+$P(H2,U,4)
	..S CD=CD+$P(H2,U,5)
	..S CE=CE+$P(H2,U,6)
	..S CF=CF+$P(H2,U,7)
	..S CG=CG+$P(H2,U,8)
	..S CH=CH+$P(H2,U,9)
	..S CI=CI+$P(H2,U,10)
	..S CJ=CJ+$P(H2,U,11)
	..S CK=CK+$P(H2,U,12)
	..S CL=CL+$P(H2,U,13)
	..S CM=CM+$P(H2,U,14)
	Q
CHK	;
	K DIR W !! S DIR(0)="E" D ^DIR S:+Y'>0 FL=1
	W @IOF
	Q
	;END
