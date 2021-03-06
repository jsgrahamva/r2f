PSSDSBPC	;BIR/MJE-Determine numeric dose multiplier for dose call, continued ;10/14/10
	;;1.0;PHARMACY DATA MANAGEMENT;**117,160**;9/30/97;Build 76
	;
NUMC()	;Continuation of Free Text Dosage conversion from routine PSSDSAPL
	;
	S PSSDBV1=$E(PSSDBV9,1,4) I PSSDBV1="5-6 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,5,$L(PSSDBV9)) Q $S($$8:6,1:0)
	S PSSDBV1=$E(PSSDBV9,1,6) I PSSDBV1="5 - 6 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,7,$L(PSSDBV9)) Q $S($$8:6,1:0)
	S PSSDBV1=$E(PSSDBV9,1,7) I PSSDBV1="5 TO 6 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,8,$L(PSSDBV9)) Q $S($$8:6,1:0)
	S PSSDBV1=$E(PSSDBV9,1,7) I PSSDBV1="5 OR 6 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,8,$L(PSSDBV9)) Q $S($$8:6,1:0)
	S PSSDBV1=$E(PSSDBV9,1,12) I PSSDBV1="FIVE TO SIX " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,13,$L(PSSDBV9)) Q $S($$8:6,1:0)
	S PSSDBV1=$E(PSSDBV9,1,12) I PSSDBV1="FIVE OR SIX " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,13,$L(PSSDBV9)) Q $S($$8:6,1:0)
	S PSSDBV1=$E(PSSDBV9,1,9) I PSSDBV1="FIVE-SIX " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,10,$L(PSSDBV9)) Q $S($$8:6,1:0)
	S PSSDBV1=$E(PSSDBV9,1,11) I PSSDBV1="FIVE - SIX " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,12,$L(PSSDBV9)) Q $S($$8:6,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,2) I PSSDBV1="6 ",$$4 S PSSDBV2=$E(PSSDBV9,3,$L(PSSDBV9)) I $$8 Q 6
	S PSSDBV1=$E(PSSDBV9,1,4) I PSSDBV1="SIX ",$$4 S PSSDBV2=$E(PSSDBV9,5,$L(PSSDBV9)) I $$8 Q 6
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="6 AND 1/4 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:6.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,19) I PSSDBV1="SIX AND ONE FOURTH " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,20,$L(PSSDBV9)) Q $S($$8:6.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,19) I PSSDBV1="SIX AND ONE-FOURTH " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,20,$L(PSSDBV9)) Q $S($$8:6.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="6 AND ONE FOURTH " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:6.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="6 AND ONE-FOURTH " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:6.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,12) I PSSDBV1="SIX AND 1/4 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,13,$L(PSSDBV9)) Q $S($$8:6.25,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="6 AND 1/3 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:6.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,18) I PSSDBV1="SIX AND ONE THIRD " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,19,$L(PSSDBV9)) Q $S($$8:6.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,18) I PSSDBV1="SIX AND ONE-THIRD " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,19,$L(PSSDBV9)) Q $S($$8:6.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,16) I PSSDBV1="6 AND ONE THIRD " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,17,$L(PSSDBV9)) Q $S($$8:6.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,16) I PSSDBV1="6 AND ONE-THIRD " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,17,$L(PSSDBV9)) Q $S($$8:6.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,12) I PSSDBV1="SIX AND 1/3 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,13,$L(PSSDBV9)) Q $S($$8:6.33,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="6 AND 1/2 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:6.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="SIX AND ONE HALF " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:6.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="SIX AND ONE-HALF " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:6.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,15) I PSSDBV1="6 AND ONE HALF " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,16,$L(PSSDBV9)) Q $S($$8:6.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,15) I PSSDBV1="6 AND ONE-HALF " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,16,$L(PSSDBV9)) Q $S($$8:6.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,12) I PSSDBV1="SIX AND 1/2 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,13,$L(PSSDBV9)) Q $S($$8:6.5,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,4) I PSSDBV1="6-7 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,5,$L(PSSDBV9)) Q $S($$8:7,1:0)
	S PSSDBV1=$E(PSSDBV9,1,6) I PSSDBV1="6 - 7 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,7,$L(PSSDBV9)) Q $S($$8:7,1:0)
	S PSSDBV1=$E(PSSDBV9,1,7) I PSSDBV1="6 TO 7 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,8,$L(PSSDBV9)) Q $S($$8:7,1:0)
	S PSSDBV1=$E(PSSDBV9,1,7) I PSSDBV1="6 OR 7 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,8,$L(PSSDBV9)) Q $S($$8:7,1:0)
	S PSSDBV1=$E(PSSDBV9,1,13) I PSSDBV1="SIX TO SEVEN " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,14,$L(PSSDBV9)) Q $S($$8:7,1:0)
	S PSSDBV1=$E(PSSDBV9,1,13) I PSSDBV1="SIX OR SEVEN " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,14,$L(PSSDBV9)) Q $S($$8:7,1:0)
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="SIX-SEVEN " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:7,1:0)
	S PSSDBV1=$E(PSSDBV9,1,12) I PSSDBV1="SIX - SEVEN " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,13,$L(PSSDBV9)) Q $S($$8:7,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,2) I PSSDBV1="7 ",$$4 S PSSDBV2=$E(PSSDBV9,3,$L(PSSDBV9)) I $$8 Q 7
	S PSSDBV1=$E(PSSDBV9,1,6) I PSSDBV1="SEVEN ",$$4 S PSSDBV2=$E(PSSDBV9,7,$L(PSSDBV9)) I $$8 Q 7
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="7 AND 1/4 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:7.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,21) I PSSDBV1="SEVEN AND ONE FOURTH " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,22,$L(PSSDBV9)) Q $S($$8:7.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,21) I PSSDBV1="SEVEN AND ONE-FOURTH " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,22,$L(PSSDBV9)) Q $S($$8:7.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="7 AND ONE FOURTH " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:7.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,17) I PSSDBV1="7 AND ONE-FOURTH " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,18,$L(PSSDBV9)) Q $S($$8:7.25,1:0)
	S PSSDBV1=$E(PSSDBV9,1,14) I PSSDBV1="SEVEN AND 1/4 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,15,$L(PSSDBV9)) Q $S($$8:7.25,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="7 AND 1/3 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:7.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,20) I PSSDBV1="SEVEN AND ONE THIRD " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,21,$L(PSSDBV9)) Q $S($$8:7.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,20) I PSSDBV1="SEVEN AND ONE-THIRD " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,21,$L(PSSDBV9)) Q $S($$8:7.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,16) I PSSDBV1="7 AND ONE THIRD " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,17,$L(PSSDBV9)) Q $S($$8:7.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,16) I PSSDBV1="7 AND ONE-THIRD " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,17,$L(PSSDBV9)) Q $S($$8:7.33,1:0)
	S PSSDBV1=$E(PSSDBV9,1,14) I PSSDBV1="SEVEN AND 1/3 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,15,$L(PSSDBV9)) Q $S($$8:7.33,1:0)
	;
	S PSSDBV1=$E(PSSDBV9,1,10) I PSSDBV1="7 AND 1/2 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,11,$L(PSSDBV9)) Q $S($$8:7.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,19) I PSSDBV1="SEVEN AND ONE HALF " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,20,$L(PSSDBV9)) Q $S($$8:7.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,19) I PSSDBV1="SEVEN AND ONE-HALF " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,20,$L(PSSDBV9)) Q $S($$8:7.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,15) I PSSDBV1="7 AND ONE HALF " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,16,$L(PSSDBV9)) Q $S($$8:7.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,15) I PSSDBV1="7 AND ONE-HALF " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,16,$L(PSSDBV9)) Q $S($$8:7.5,1:0)
	S PSSDBV1=$E(PSSDBV9,1,14) I PSSDBV1="SEVEN AND 1/2 " Q:'$$4 0  S PSSDBV2=$E(PSSDBV9,15,$L(PSSDBV9)) Q $S($$8:7.5,1:0)
	;
	Q ""
	;
8()	;Look for Unit - PSSDBIFL set in PSSSAPD, indicates if Order has a Dispense Drug, or just an Orderable Item
	S PSSDBV3="" D
	.I PSSDBIFL S PSSDBV3=$$UNITD^PSSDSAPI(PSSDBV2) Q
	.S PSSDBV3=$$UNIT^PSSDSAPI(PSSDBV2)
	Q $S(PSSDBV3="":0,1:1)
	;
4()	;Validate text follow the numeric part of the text
	I $L(PSSDBV9)'>$L(PSSDBV1) Q 0
	Q 1
