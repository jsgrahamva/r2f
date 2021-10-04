PSSDSAPL	;BIR/RTR-Free Text Dosage Logic ;06/21/10
	;;1.0;PHARMACY DATA MANAGEMENT;**117,160**;9/30/97;Build 76
	;
	;
NUM	;Determine Dose Amount and Dose Unit from Free Text Dose
	;
	;PSSDBV9 = Free Text Dosage
	;
	N PSSDBV9
	S PSSDBV9=$G(PSSDSLCL)
	I $L(PSSDBV9)'>0 Q
	S PSSDBV9=$$UP^XLFSTR(PSSDBV9)
	;
	;
	N PSSDBV1,PSSDBV2,PSSDBV3,PSSDBV7,PSSDBV8
	S PSSDBV3=""
	S PSSDBV8=$$NUMF I PSSDBV8 S PSSDBAR("AMN")=PSSDBV8,PSSDBAR("UNIT")=PSSDBV3 Q
	;
	;
	I $E(PSSDBV9)="." S PSSDBV9="0"_PSSDBV9 S PSSDBV8=$$NUMF I PSSDBV8 S PSSDBAR("AMN")=PSSDBV8,PSSDBAR("UNIT")=PSSDBV3 Q
	I $E(PSSDBV9)=0 S PSSDBV9=$E(PSSDBV9,2,$L(PSSDBV9)) S PSSDBV8=$$NUMF I PSSDBV8 S PSSDBAR("AMN")=PSSDBV8,PSSDBAR("UNIT")=PSSDBV3
	Q
	;
	;
NUMF()	;
	S PSSDBV1=$E(PSSDBV9,1,11) I PSSDBV1="ONE FOURTH " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,12,$L(PSSDBV9)) Q $S($$8:.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,11) I PSSDBV1="ONE-FOURTH " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,12,$L(PSSDBV9)) Q $S($$8:.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,4) I PSSDBV1="1/4 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,5,$L(PSSDBV9)) Q $S($$8:.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,5) I PSSDBV1="0.25 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,6,$L(PSSDBV9)) Q $S($$8:.25,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="ONE THIRD " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="ONE-THIRD " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,4) I PSSDBV1="1/3 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,5,$L(PSSDBV9)) Q $S($$8:.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,5) I PSSDBV1="0.33 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,6,$L(PSSDBV9)) Q $S($$8:.33,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,9) I PSSDBV1="ONE HALF ",$$7 S PSSDBV2=$E(PSSDBV9,10,$L(PSSDBV9)) I $$8 Q .5
	S PSSDBV1=$E(PSSDBV9,1,9) I PSSDBV1="ONE-HALF ",$$7 S PSSDBV2=$E(PSSDBV9,10,$L(PSSDBV9)) I $$8 Q .5
	S PSSDBV1=$E(PSSDBV9,1,4) I PSSDBV1="1/2 ",$$7 S PSSDBV2=$E(PSSDBV9,5,$L(PSSDBV9)) I $$8 Q .5
	S PSSDBV1=$E(PSSDBV9,1,4) I PSSDBV1="0.5 ",$$7 S PSSDBV2=$E(PSSDBV9,5,$L(PSSDBV9)) I $$8 Q .5
	;
	S PSSDBV1=$E(PSSDBV9,1,6) I PSSDBV1="0.5-1 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,7,$L(PSSDBV9)) Q $S($$8:1,1:0)
	S PSSDBV1=$E(PSSDBV9,1,8) I PSSDBV1="0.5 - 1 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,9,$L(PSSDBV9)) Q $S($$8:1,1:0)
	S PSSDBV1=$E(PSSDBV9,1,9) I PSSDBV1="0.5 TO 1 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,10,$L(PSSDBV9)) Q $S($$8:1,1:0)
	S PSSDBV1=$E(PSSDBV9,1,9) I PSSDBV1="0.5 OR 1 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,10,$L(PSSDBV9)) Q $S($$8:1,1:0)
	S PSSDBV1=$E(PSSDBV9,1,6) I PSSDBV1="1/2-1 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,7,$L(PSSDBV9)) Q $S($$8:1,1:0)
	S PSSDBV1=$E(PSSDBV9,1,8) I PSSDBV1="1/2 - 1 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,9,$L(PSSDBV9)) Q $S($$8:1,1:0)
	S PSSDBV1=$E(PSSDBV9,1,9) I PSSDBV1="1/2 TO 1 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,10,$L(PSSDBV9)) Q $S($$8:1,1:0)
	S PSSDBV1=$E(PSSDBV9,1,9) I PSSDBV1="1/2 OR 1 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,10,$L(PSSDBV9)) Q $S($$8:1,1:0)
	S PSSDBV1=$E(PSSDBV9,1,16) I PSSDBV1="ONE-HALF TO ONE " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,17,$L(PSSDBV9)) Q $S($$8:1,1:0)
	S PSSDBV1=$E(PSSDBV9,1,18) I PSSDBV1="ONE - HALF TO ONE " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,19,$L(PSSDBV9)) Q $S($$8:1,1:0)
	S PSSDBV1=$E(PSSDBV9,1,16) I PSSDBV1="ONE HALF TO ONE " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,17,$L(PSSDBV9)) Q $S($$8:1,1:0)
	S PSSDBV1=$E(PSSDBV9,1,16) I PSSDBV1="ONE-HALF OR ONE " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,17,$L(PSSDBV9)) Q $S($$8:1,1:0)
	S PSSDBV1=$E(PSSDBV9,1,18) I PSSDBV1="ONE - HALF OR ONE " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,19,$L(PSSDBV9)) Q $S($$8:1,1:0)
	S PSSDBV1=$E(PSSDBV9,1,16) I PSSDBV1="ONE HALF OR ONE " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,17,$L(PSSDBV9)) Q $S($$8:1,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,2) I PSSDBV1="1 ",$$7 S PSSDBV2=$E(PSSDBV9,3,$L(PSSDBV9)) I $$8 Q 1
	S PSSDBV1=$E(PSSDBV9,1,4) I PSSDBV1="ONE ",$$7 S PSSDBV2=$E(PSSDBV9,5,$L(PSSDBV9)) I $$8 Q 1
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="1 AND 1/4 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:1.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,19) I PSSDBV1="ONE AND ONE FOURTH " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,20,$L(PSSDBV9)) Q $S($$8:1.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,19) I PSSDBV1="ONE AND ONE-FOURTH " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,20,$L(PSSDBV9)) Q $S($$8:1.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="1 AND ONE FOURTH " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:1.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="1 AND ONE-FOURTH " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:1.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,12) I PSSDBV1="ONE AND 1/4 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,13,$L(PSSDBV9)) Q $S($$8:1.25,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="1 AND 1/3 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:1.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,18) I PSSDBV1="ONE AND ONE THIRD " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,19,$L(PSSDBV9)) Q $S($$8:1.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,18) I PSSDBV1="ONE AND ONE-THIRD " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,19,$L(PSSDBV9)) Q $S($$8:1.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,16) I PSSDBV1="1 AND ONE THIRD " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,17,$L(PSSDBV9)) Q $S($$8:1.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,16) I PSSDBV1="1 AND ONE-THIRD " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,17,$L(PSSDBV9)) Q $S($$8:1.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,12) I PSSDBV1="ONE AND 1/3 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,13,$L(PSSDBV9)) Q $S($$8:1.33,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="1 AND 1/2 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:1.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="ONE AND ONE HALF " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:1.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="ONE AND ONE-HALF " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:1.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,15) I PSSDBV1="1 AND ONE HALF " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,16,$L(PSSDBV9)) Q $S($$8:1.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,15) I PSSDBV1="1 AND ONE-HALF " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,16,$L(PSSDBV9)) Q $S($$8:1.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,12) I PSSDBV1="ONE AND 1/2 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,13,$L(PSSDBV9)) Q $S($$8:1.5,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,4) I PSSDBV1="1-2 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,5,$L(PSSDBV9)) Q $S($$8:2,1:0)
	S PSSDBV1=$E(PSSDBV9,1,6) I PSSDBV1="1 - 2 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,7,$L(PSSDBV9)) Q $S($$8:2,1:0)
	S PSSDBV1=$E(PSSDBV9,1,7) I PSSDBV1="1 TO 2 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,8,$L(PSSDBV9)) Q $S($$8:2,1:0)
	S PSSDBV1=$E(PSSDBV9,1,7) I PSSDBV1="1 OR 2 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,8,$L(PSSDBV9)) Q $S($$8:2,1:0)
	S PSSDBV1=$E(PSSDBV9,1,11) I PSSDBV1="ONE TO TWO " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,12,$L(PSSDBV9)) Q $S($$8:2,1:0)
	S PSSDBV1=$E(PSSDBV9,1,11) I PSSDBV1="ONE OR TWO " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,12,$L(PSSDBV9)) Q $S($$8:2,1:0)
	S PSSDBV1=$E(PSSDBV9,1,8) I PSSDBV1="ONE-TWO " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,9,$L(PSSDBV9)) Q $S($$8:2,1:0)
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="ONE - TWO " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:2,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,2) I PSSDBV1="2 ",$$7 S PSSDBV2=$E(PSSDBV9,3,$L(PSSDBV9)) I $$8 Q 2
	S PSSDBV1=$E(PSSDBV9,1,4) I PSSDBV1="TWO ",$$7 S PSSDBV2=$E(PSSDBV9,5,$L(PSSDBV9)) I $$8 Q 2
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="2 AND 1/4 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:2.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,19) I PSSDBV1="TWO AND ONE FOURTH " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,20,$L(PSSDBV9)) Q $S($$8:2.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,19) I PSSDBV1="TWO AND ONE-FOURTH " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,20,$L(PSSDBV9)) Q $S($$8:2.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="2 AND ONE FOURTH " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:2.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="2 AND ONE-FOURTH " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:2.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,12) I PSSDBV1="TWO AND 1/4 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,13,$L(PSSDBV9)) Q $S($$8:2.25,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="2 AND 1/3 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:2.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,18) I PSSDBV1="TWO AND ONE THIRD " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,19,$L(PSSDBV9)) Q $S($$8:2.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,18) I PSSDBV1="TWO AND ONE-THIRD " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,19,$L(PSSDBV9)) Q $S($$8:2.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,16) I PSSDBV1="2 AND ONE THIRD " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,17,$L(PSSDBV9)) Q $S($$8:2.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,16) I PSSDBV1="2 AND ONE-THIRD " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,17,$L(PSSDBV9)) Q $S($$8:2.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,12) I PSSDBV1="TWO AND 1/3 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,13,$L(PSSDBV9)) Q $S($$8:2.33,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="2 AND 1/2 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:2.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="TWO AND ONE HALF " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:2.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="TWO AND ONE-HALF " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:2.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,15) I PSSDBV1="2 AND ONE HALF " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,16,$L(PSSDBV9)) Q $S($$8:2.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,15) I PSSDBV1="2 AND ONE-HALF " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,16,$L(PSSDBV9)) Q $S($$8:2.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,12) I PSSDBV1="TWO AND 1/2 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,13,$L(PSSDBV9)) Q $S($$8:2.5,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,4) I PSSDBV1="2-3 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,5,$L(PSSDBV9)) Q $S($$8:3,1:0)
	S PSSDBV1=$E(PSSDBV9,1,6) I PSSDBV1="2 - 3 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,7,$L(PSSDBV9)) Q $S($$8:3,1:0)
	S PSSDBV1=$E(PSSDBV9,1,7) I PSSDBV1="2 TO 3 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,8,$L(PSSDBV9)) Q $S($$8:3,1:0)
	S PSSDBV1=$E(PSSDBV9,1,7) I PSSDBV1="2 OR 3 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,8,$L(PSSDBV9)) Q $S($$8:3,1:0)
	S PSSDBV1=$E(PSSDBV9,1,13) I PSSDBV1="TWO TO THREE " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,14,$L(PSSDBV9)) Q $S($$8:3,1:0)
	S PSSDBV1=$E(PSSDBV9,1,13) I PSSDBV1="TWO OR THREE " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,14,$L(PSSDBV9)) Q $S($$8:3,1:0)
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="TWO-THREE " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:3,1:0)
	S PSSDBV1=$E(PSSDBV9,1,12) I PSSDBV1="TWO - THREE " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,13,$L(PSSDBV9)) Q $S($$8:3,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,2) I PSSDBV1="3 ",$$7 S PSSDBV2=$E(PSSDBV9,3,$L(PSSDBV9)) I $$8 Q 3
	S PSSDBV1=$E(PSSDBV9,1,6) I PSSDBV1="THREE ",$$7 S PSSDBV2=$E(PSSDBV9,7,$L(PSSDBV9)) I $$8 Q 3
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="3 AND 1/4 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:3.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,21) I PSSDBV1="THREE AND ONE FOURTH " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,22,$L(PSSDBV9)) Q $S($$8:3.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,21) I PSSDBV1="THREE AND ONE-FOURTH " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,22,$L(PSSDBV9)) Q $S($$8:3.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="3 AND ONE FOURTH " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:3.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="3 AND ONE-FOURTH " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:3.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,14) I PSSDBV1="THREE AND 1/4 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,15,$L(PSSDBV9)) Q $S($$8:3.25,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="3 AND 1/3 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:3.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,20) I PSSDBV1="THREE AND ONE THIRD " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,21,$L(PSSDBV9)) Q $S($$8:3.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,20) I PSSDBV1="THREE AND ONE-THIRD " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,21,$L(PSSDBV9)) Q $S($$8:3.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,16) I PSSDBV1="3 AND ONE THIRD " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,17,$L(PSSDBV9)) Q $S($$8:3.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,16) I PSSDBV1="3 AND ONE-THIRD " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,17,$L(PSSDBV9)) Q $S($$8:3.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,14) I PSSDBV1="THREE AND 1/3 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,15,$L(PSSDBV9)) Q $S($$8:3.33,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="3 AND 1/2 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:3.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,19) I PSSDBV1="THREE AND ONE HALF " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,20,$L(PSSDBV9)) Q $S($$8:3.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,19) I PSSDBV1="THREE AND ONE-HALF " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,20,$L(PSSDBV9)) Q $S($$8:3.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,15) I PSSDBV1="3 AND ONE HALF " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,16,$L(PSSDBV9)) Q $S($$8:3.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,15) I PSSDBV1="3 AND ONE-HALF " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,16,$L(PSSDBV9)) Q $S($$8:3.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,14) I PSSDBV1="THREE AND 1/2 " Q:'$$7 0  S PSSDBV2=$E(PSSDBV9,15,$L(PSSDBV9)) Q $S($$8:3.5,1:0)
	;
	;
	S PSSDBV7=$$NUMC^PSSDSBPB Q:PSSDBV7'="" PSSDBV7
	S PSSDBV7=$$NUMC^PSSDSBPC Q:PSSDBV7'="" PSSDBV7
	S PSSDBV7=$$NUMC^PSSDSBPD Q PSSDBV7
	;
	;
8()	;Look for Unit - PSSDBIFL set in PSSSAPD, indicates if Order has a Dispense Drug, or just an Orderable Item
	S PSSDBV3="" D
	.I PSSDBIFL S PSSDBV3=$$UNITD^PSSDSAPI(PSSDBV2) Q
	.S PSSDBV3=$$UNIT^PSSDSAPI(PSSDBV2)
	Q $S(PSSDBV3="":0,1:1)
	;
	;
7()	;Validate text follow the numeric part of the text
	I $L(PSSDBV9)'>$L(PSSDBV1) Q 0
	Q 1
	;
TEST	;used for testing numeric dose multiplier from Local Possible Dosage
	N X,Y,PSSDBV1,PSSDBV2,PSSDBV3,PSSDBV7,PSSDBV8,DIR,DIRUT,DTOUT,PSSDBIFL
	S (PSSDSLCL,PSSDBV3,PSSDBIFL)=""
TEST1	;
	K DIR S DIR("A")="Possible Dosage",DIR(0)="FO^1:40"     ;,DIR("?")="Enter a possible dosage for testing numeric dose multiplier."
	D ^DIR G TESTE:$G(DIRUT)!($G(DTOUT))!(X="")
	K DIR S (PSSDBV9,PSSDSLCL)=Y W !!,$$NUMF^PSSDSAPL,!!
	G TEST1
TESTE	;
	Q