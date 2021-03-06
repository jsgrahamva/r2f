PSSDSPON	;BIR/RTR-Determine numeric dose multiplier for patch 129 install ;07/10/08
	;;1.0;PHARMACY DATA MANAGEMENT;**129**;9/30/07;Build 67
	;
	;
NUM()	;Determine numeric dose multiplier from Local Possible Dosage
	;
	N PSSQVJ1,PSSQVJ2
	K PSSQVJ1,PSSQVJ2
	I $L($G(PSSQVLCD))'>0 Q 0
	;
	;
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="4 AND 1/2 " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q 4.5
	S PSSQVJ1=$E(PSSQVLCD,1,18) I PSSQVJ1="FOUR AND ONE HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,19,$L(PSSQVLCD)) I $$6 Q 4.5
	S PSSQVJ1=$E(PSSQVLCD,1,18) I PSSQVJ1="FOUR AND ONE-HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,19,$L(PSSQVLCD)) I $$6 Q 4.5
	S PSSQVJ1=$E(PSSQVLCD,1,15) I PSSQVJ1="4 AND ONE HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,16,$L(PSSQVLCD)) I $$6 Q 4.5
	S PSSQVJ1=$E(PSSQVLCD,1,15) I PSSQVJ1="4 AND ONE-HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,16,$L(PSSQVLCD)) I $$6 Q 4.5
	S PSSQVJ1=$E(PSSQVLCD,1,13) I PSSQVJ1="FOUR AND 1/2 " I $$7 S PSSQVJ2=$E(PSSQVLCD,14,$L(PSSQVLCD)) I $$6 Q 4.5
	;
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="3 AND 1/2 " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q 3.5
	S PSSQVJ1=$E(PSSQVLCD,1,19) I PSSQVJ1="THREE AND ONE HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,20,$L(PSSQVLCD)) I $$6 Q 3.5
	S PSSQVJ1=$E(PSSQVLCD,1,19) I PSSQVJ1="THREE AND ONE-HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,20,$L(PSSQVLCD)) I $$6 Q 3.5
	S PSSQVJ1=$E(PSSQVLCD,1,15) I PSSQVJ1="3 AND ONE HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,16,$L(PSSQVLCD)) I $$6 Q 3.5
	S PSSQVJ1=$E(PSSQVLCD,1,15) I PSSQVJ1="3 AND ONE-HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,16,$L(PSSQVLCD)) I $$6 Q 3.5
	S PSSQVJ1=$E(PSSQVLCD,1,14) I PSSQVJ1="THREE AND 1/2 " I $$7 S PSSQVJ2=$E(PSSQVLCD,15,$L(PSSQVLCD)) I $$6 Q 3.5
	;
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="2 AND 1/2 " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q 2.5
	S PSSQVJ1=$E(PSSQVLCD,1,17) I PSSQVJ1="TWO AND ONE HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,18,$L(PSSQVLCD)) I $$6 Q 2.5
	S PSSQVJ1=$E(PSSQVLCD,1,17) I PSSQVJ1="TWO AND ONE-HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,18,$L(PSSQVLCD)) I $$6 Q 2.5
	S PSSQVJ1=$E(PSSQVLCD,1,15) I PSSQVJ1="2 AND ONE HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,16,$L(PSSQVLCD)) I $$6 Q 2.5
	S PSSQVJ1=$E(PSSQVLCD,1,15) I PSSQVJ1="2 AND ONE-HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,16,$L(PSSQVLCD)) I $$6 Q 2.5
	S PSSQVJ1=$E(PSSQVLCD,1,12) I PSSQVJ1="TWO AND 1/2 " I $$7 S PSSQVJ2=$E(PSSQVLCD,13,$L(PSSQVLCD)) I $$6 Q 2.5
	;
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="1 AND 1/2 " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q 1.5
	S PSSQVJ1=$E(PSSQVLCD,1,17) I PSSQVJ1="ONE AND ONE HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,18,$L(PSSQVLCD)) I $$6 Q 1.5
	S PSSQVJ1=$E(PSSQVLCD,1,17) I PSSQVJ1="ONE AND ONE-HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,18,$L(PSSQVLCD)) I $$6 Q 1.5
	S PSSQVJ1=$E(PSSQVLCD,1,15) I PSSQVJ1="1 AND ONE HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,16,$L(PSSQVLCD)) I $$6 Q 1.5
	S PSSQVJ1=$E(PSSQVLCD,1,15) I PSSQVJ1="1 AND ONE-HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,16,$L(PSSQVLCD)) I $$6 Q 1.5
	S PSSQVJ1=$E(PSSQVLCD,1,12) I PSSQVJ1="ONE AND 1/2 " I $$7 S PSSQVJ2=$E(PSSQVLCD,13,$L(PSSQVLCD)) I $$6 Q 1.5
	;
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="4 AND 1/4 " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q 4.25
	S PSSQVJ1=$E(PSSQVLCD,1,20) I PSSQVJ1="FOUR AND ONE FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,21,$L(PSSQVLCD)) I $$6 Q 4.25
	S PSSQVJ1=$E(PSSQVLCD,1,20) I PSSQVJ1="FOUR AND ONE-FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,21,$L(PSSQVLCD)) I $$6 Q 4.25
	S PSSQVJ1=$E(PSSQVLCD,1,17) I PSSQVJ1="4 AND ONE FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,18,$L(PSSQVLCD)) I $$6 Q 4.25
	S PSSQVJ1=$E(PSSQVLCD,1,17) I PSSQVJ1="4 AND ONE-FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,18,$L(PSSQVLCD)) I $$6 Q 4.25
	S PSSQVJ1=$E(PSSQVLCD,1,13) I PSSQVJ1="FOUR AND 1/4 " I $$7 S PSSQVJ2=$E(PSSQVLCD,14,$L(PSSQVLCD)) I $$6 Q 4.25
	;
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="3 AND 1/4 " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q 3.25
	S PSSQVJ1=$E(PSSQVLCD,1,21) I PSSQVJ1="THREE AND ONE FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,22,$L(PSSQVLCD)) I $$6 Q 3.25
	S PSSQVJ1=$E(PSSQVLCD,1,21) I PSSQVJ1="THREE AND ONE-FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,22,$L(PSSQVLCD)) I $$6 Q 3.25
	S PSSQVJ1=$E(PSSQVLCD,1,17) I PSSQVJ1="3 AND ONE FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,18,$L(PSSQVLCD)) I $$6 Q 3.25
	S PSSQVJ1=$E(PSSQVLCD,1,17) I PSSQVJ1="3 AND ONE-FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,18,$L(PSSQVLCD)) I $$6 Q 3.25
	S PSSQVJ1=$E(PSSQVLCD,1,14) I PSSQVJ1="THREE AND 1/4 " I $$7 S PSSQVJ2=$E(PSSQVLCD,15,$L(PSSQVLCD)) I $$6 Q 3.25
	;
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="2 AND 1/4 " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q 2.25
	S PSSQVJ1=$E(PSSQVLCD,1,19) I PSSQVJ1="TWO AND ONE FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,20,$L(PSSQVLCD)) I $$6 Q 2.25
	S PSSQVJ1=$E(PSSQVLCD,1,19) I PSSQVJ1="TWO AND ONE-FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,20,$L(PSSQVLCD)) I $$6 Q 2.25
	S PSSQVJ1=$E(PSSQVLCD,1,17) I PSSQVJ1="2 AND ONE FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,18,$L(PSSQVLCD)) I $$6 Q 2.25
	S PSSQVJ1=$E(PSSQVLCD,1,17) I PSSQVJ1="2 AND ONE-FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,18,$L(PSSQVLCD)) I $$6 Q 2.25
	S PSSQVJ1=$E(PSSQVLCD,1,12) I PSSQVJ1="TWO AND 1/4 " I $$7 S PSSQVJ2=$E(PSSQVLCD,13,$L(PSSQVLCD)) I $$6 Q 2.25
	;
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="1 AND 1/4 " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q 1.25
	S PSSQVJ1=$E(PSSQVLCD,1,19) I PSSQVJ1="ONE AND ONE FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,20,$L(PSSQVLCD)) I $$6 Q 1.25
	S PSSQVJ1=$E(PSSQVLCD,1,19) I PSSQVJ1="ONE AND ONE-FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,20,$L(PSSQVLCD)) I $$6 Q 1.25
	S PSSQVJ1=$E(PSSQVLCD,1,17) I PSSQVJ1="1 AND ONE FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,18,$L(PSSQVLCD)) I $$6 Q 1.25
	S PSSQVJ1=$E(PSSQVLCD,1,17) I PSSQVJ1="1 AND ONE-FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,18,$L(PSSQVLCD)) I $$6 Q 1.25
	S PSSQVJ1=$E(PSSQVLCD,1,12) I PSSQVJ1="ONE AND 1/4 " I $$7 S PSSQVJ2=$E(PSSQVLCD,13,$L(PSSQVLCD)) I $$6 Q 1.25
	;
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="4 AND 1/3 " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q 4.33
	S PSSQVJ1=$E(PSSQVLCD,1,19) I PSSQVJ1="FOUR AND ONE THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,20,$L(PSSQVLCD)) I $$6 Q 4.33
	S PSSQVJ1=$E(PSSQVLCD,1,19) I PSSQVJ1="FOUR AND ONE-THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,20,$L(PSSQVLCD)) I $$6 Q 4.33
	S PSSQVJ1=$E(PSSQVLCD,1,16) I PSSQVJ1="4 AND ONE THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,17,$L(PSSQVLCD)) I $$6 Q 4.33
	S PSSQVJ1=$E(PSSQVLCD,1,16) I PSSQVJ1="4 AND ONE-THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,17,$L(PSSQVLCD)) I $$6 Q 4.33
	S PSSQVJ1=$E(PSSQVLCD,1,13) I PSSQVJ1="FOUR AND 1/3 " I $$7 S PSSQVJ2=$E(PSSQVLCD,14,$L(PSSQVLCD)) I $$6 Q 4.33
	;
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="3 AND 1/3 " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q 3.33
	S PSSQVJ1=$E(PSSQVLCD,1,20) I PSSQVJ1="THREE AND ONE THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,21,$L(PSSQVLCD)) I $$6 Q 3.33
	S PSSQVJ1=$E(PSSQVLCD,1,20) I PSSQVJ1="THREE AND ONE-THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,21,$L(PSSQVLCD)) I $$6 Q 3.33
	S PSSQVJ1=$E(PSSQVLCD,1,16) I PSSQVJ1="3 AND ONE THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,17,$L(PSSQVLCD)) I $$6 Q 3.33
	S PSSQVJ1=$E(PSSQVLCD,1,16) I PSSQVJ1="3 AND ONE-THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,17,$L(PSSQVLCD)) I $$6 Q 3.33
	S PSSQVJ1=$E(PSSQVLCD,1,14) I PSSQVJ1="THREE AND 1/3 " I $$7 S PSSQVJ2=$E(PSSQVLCD,15,$L(PSSQVLCD)) I $$6 Q 3.33
	;
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="2 AND 1/3 " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q 2.33
	S PSSQVJ1=$E(PSSQVLCD,1,18) I PSSQVJ1="TWO AND ONE THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,19,$L(PSSQVLCD)) I $$6 Q 2.33
	S PSSQVJ1=$E(PSSQVLCD,1,18) I PSSQVJ1="TWO AND ONE-THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,19,$L(PSSQVLCD)) I $$6 Q 2.33
	S PSSQVJ1=$E(PSSQVLCD,1,16) I PSSQVJ1="2 AND ONE THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,17,$L(PSSQVLCD)) I $$6 Q 2.33
	S PSSQVJ1=$E(PSSQVLCD,1,16) I PSSQVJ1="2 AND ONE-THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,17,$L(PSSQVLCD)) I $$6 Q 2.33
	S PSSQVJ1=$E(PSSQVLCD,1,12) I PSSQVJ1="TWO AND 1/3 " I $$7 S PSSQVJ2=$E(PSSQVLCD,13,$L(PSSQVLCD)) I $$6 Q 2.33
	;
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="1 AND 1/3 " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q 1.33
	S PSSQVJ1=$E(PSSQVLCD,1,18) I PSSQVJ1="ONE AND ONE THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,19,$L(PSSQVLCD)) I $$6 Q 1.33
	S PSSQVJ1=$E(PSSQVLCD,1,18) I PSSQVJ1="ONE AND ONE-THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,19,$L(PSSQVLCD)) I $$6 Q 1.33
	S PSSQVJ1=$E(PSSQVLCD,1,16) I PSSQVJ1="1 AND ONE THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,17,$L(PSSQVLCD)) I $$6 Q 1.33
	S PSSQVJ1=$E(PSSQVLCD,1,16) I PSSQVJ1="1 AND ONE-THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,17,$L(PSSQVLCD)) I $$6 Q 1.33
	S PSSQVJ1=$E(PSSQVLCD,1,12) I PSSQVJ1="ONE AND 1/3 " I $$7 S PSSQVJ2=$E(PSSQVLCD,13,$L(PSSQVLCD)) I $$6 Q 1.33
	;
	S PSSQVJ1=$E(PSSQVLCD,1,6) I PSSQVJ1="0.5-1 " I $$7 S PSSQVJ2=$E(PSSQVLCD,7,$L(PSSQVLCD)) I $$6 Q 1
	S PSSQVJ1=$E(PSSQVLCD,1,8) I PSSQVJ1="0.5 - 1 " I $$7 S PSSQVJ2=$E(PSSQVLCD,9,$L(PSSQVLCD)) I $$6 Q 1
	S PSSQVJ1=$E(PSSQVLCD,1,9) I PSSQVJ1="0.5 TO 1 " I $$7 S PSSQVJ2=$E(PSSQVLCD,10,$L(PSSQVLCD)) I $$6 Q 1
	S PSSQVJ1=$E(PSSQVLCD,1,9) I PSSQVJ1="0.5 OR 1 " I $$7 S PSSQVJ2=$E(PSSQVLCD,10,$L(PSSQVLCD)) I $$6 Q 1
	S PSSQVJ1=$E(PSSQVLCD,1,6) I PSSQVJ1="1/2-1 " I $$7 S PSSQVJ2=$E(PSSQVLCD,7,$L(PSSQVLCD)) I $$6 Q 1
	S PSSQVJ1=$E(PSSQVLCD,1,8) I PSSQVJ1="1/2 - 1 " I $$7 S PSSQVJ2=$E(PSSQVLCD,9,$L(PSSQVLCD)) I $$6 Q 1
	S PSSQVJ1=$E(PSSQVLCD,1,9) I PSSQVJ1="1/2 TO 1 " I $$7 S PSSQVJ2=$E(PSSQVLCD,10,$L(PSSQVLCD)) I $$6 Q 1
	S PSSQVJ1=$E(PSSQVLCD,1,9) I PSSQVJ1="1/2 OR 1 " I $$7 S PSSQVJ2=$E(PSSQVLCD,10,$L(PSSQVLCD)) I $$6 Q 1
	S PSSQVJ1=$E(PSSQVLCD,1,16) I PSSQVJ1="ONE-HALF TO ONE " I $$7 S PSSQVJ2=$E(PSSQVLCD,17,$L(PSSQVLCD)) I $$6 Q 1
	S PSSQVJ1=$E(PSSQVLCD,1,18) I PSSQVJ1="ONE - HALF TO ONE " I $$7 S PSSQVJ2=$E(PSSQVLCD,19,$L(PSSQVLCD)) I $$6 Q 1
	S PSSQVJ1=$E(PSSQVLCD,1,16) I PSSQVJ1="ONE HALF TO ONE " I $$7 S PSSQVJ2=$E(PSSQVLCD,17,$L(PSSQVLCD)) I $$6 Q 1
	S PSSQVJ1=$E(PSSQVLCD,1,16) I PSSQVJ1="ONE-HALF OR ONE " I $$7 S PSSQVJ2=$E(PSSQVLCD,17,$L(PSSQVLCD)) I $$6 Q 1
	S PSSQVJ1=$E(PSSQVLCD,1,18) I PSSQVJ1="ONE - HALF OR ONE " I $$7 S PSSQVJ2=$E(PSSQVLCD,19,$L(PSSQVLCD)) I $$6 Q 1
	S PSSQVJ1=$E(PSSQVLCD,1,16) I PSSQVJ1="ONE HALF OR ONE " I $$7 S PSSQVJ2=$E(PSSQVLCD,17,$L(PSSQVLCD)) I $$6 Q 1
	;
	S PSSQVJ1=$E(PSSQVLCD,1,4) I PSSQVJ1="1-2 " I $$7 S PSSQVJ2=$E(PSSQVLCD,5,$L(PSSQVLCD)) I $$6 Q 2
	S PSSQVJ1=$E(PSSQVLCD,1,6) I PSSQVJ1="1 - 2 " I $$7 S PSSQVJ2=$E(PSSQVLCD,7,$L(PSSQVLCD)) I $$6 Q 2
	S PSSQVJ1=$E(PSSQVLCD,1,7) I PSSQVJ1="1 TO 2 " I $$7 S PSSQVJ2=$E(PSSQVLCD,8,$L(PSSQVLCD)) I $$6 Q 2
	S PSSQVJ1=$E(PSSQVLCD,1,7) I PSSQVJ1="1 OR 2 " I $$7 S PSSQVJ2=$E(PSSQVLCD,8,$L(PSSQVLCD)) I $$6 Q 2
	S PSSQVJ1=$E(PSSQVLCD,1,11) I PSSQVJ1="ONE TO TWO " I $$7 S PSSQVJ2=$E(PSSQVLCD,12,$L(PSSQVLCD)) I $$6 Q 2
	S PSSQVJ1=$E(PSSQVLCD,1,11) I PSSQVJ1="ONE OR TWO " I $$7 S PSSQVJ2=$E(PSSQVLCD,12,$L(PSSQVLCD)) I $$6 Q 2
	S PSSQVJ1=$E(PSSQVLCD,1,8) I PSSQVJ1="ONE-TWO " I $$7 S PSSQVJ2=$E(PSSQVLCD,9,$L(PSSQVLCD)) I $$6 Q 2
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="ONE - TWO " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q 2
	;
	S PSSQVJ1=$E(PSSQVLCD,1,4) I PSSQVJ1="2-3 " I $$7 S PSSQVJ2=$E(PSSQVLCD,5,$L(PSSQVLCD)) I $$6 Q 3
	S PSSQVJ1=$E(PSSQVLCD,1,6) I PSSQVJ1="2 - 3 " I $$7 S PSSQVJ2=$E(PSSQVLCD,7,$L(PSSQVLCD)) I $$6 Q 3
	S PSSQVJ1=$E(PSSQVLCD,1,7) I PSSQVJ1="2 TO 3 " I $$7 S PSSQVJ2=$E(PSSQVLCD,8,$L(PSSQVLCD)) I $$6 Q 3
	S PSSQVJ1=$E(PSSQVLCD,1,7) I PSSQVJ1="2 OR 3 " I $$7 S PSSQVJ2=$E(PSSQVLCD,8,$L(PSSQVLCD)) I $$6 Q 3
	S PSSQVJ1=$E(PSSQVLCD,1,13) I PSSQVJ1="TWO TO THREE " I $$7 S PSSQVJ2=$E(PSSQVLCD,14,$L(PSSQVLCD)) I $$6 Q 3
	S PSSQVJ1=$E(PSSQVLCD,1,13) I PSSQVJ1="TWO OR THREE " I $$7 S PSSQVJ2=$E(PSSQVLCD,14,$L(PSSQVLCD)) I $$6 Q 3
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="TWO-THREE " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q 3
	S PSSQVJ1=$E(PSSQVLCD,1,12) I PSSQVJ1="TWO - THREE " I $$7 S PSSQVJ2=$E(PSSQVLCD,13,$L(PSSQVLCD)) I $$6 Q 3
	;
	S PSSQVJ1=$E(PSSQVLCD,1,4) I PSSQVJ1="3-4 " I $$7 S PSSQVJ2=$E(PSSQVLCD,5,$L(PSSQVLCD)) I $$6 Q 4
	S PSSQVJ1=$E(PSSQVLCD,1,6) I PSSQVJ1="3 - 4 " I $$7 S PSSQVJ2=$E(PSSQVLCD,7,$L(PSSQVLCD)) I $$6 Q 4
	S PSSQVJ1=$E(PSSQVLCD,1,7) I PSSQVJ1="3 TO 4 " I $$7 S PSSQVJ2=$E(PSSQVLCD,8,$L(PSSQVLCD)) I $$6 Q 4
	S PSSQVJ1=$E(PSSQVLCD,1,7) I PSSQVJ1="3 OR 4 " I $$7 S PSSQVJ2=$E(PSSQVLCD,8,$L(PSSQVLCD)) I $$6 Q 4
	S PSSQVJ1=$E(PSSQVLCD,1,14) I PSSQVJ1="THREE TO FOUR " I $$7 S PSSQVJ2=$E(PSSQVLCD,15,$L(PSSQVLCD)) I $$6 Q 4
	S PSSQVJ1=$E(PSSQVLCD,1,14) I PSSQVJ1="THREE OR FOUR " I $$7 S PSSQVJ2=$E(PSSQVLCD,15,$L(PSSQVLCD)) I $$6 Q 4
	S PSSQVJ1=$E(PSSQVLCD,1,11) I PSSQVJ1="THREE-FOUR " I $$7 S PSSQVJ2=$E(PSSQVLCD,12,$L(PSSQVLCD)) I $$6 Q 4
	S PSSQVJ1=$E(PSSQVLCD,1,13) I PSSQVJ1="THREE - FOUR " I $$7 S PSSQVJ2=$E(PSSQVLCD,14,$L(PSSQVLCD)) I $$6 Q 4
	;
	S PSSQVJ1=$E(PSSQVLCD,1,4) I PSSQVJ1="0.5 " I $$7 S PSSQVJ2=$E(PSSQVLCD,5,$L(PSSQVLCD)) I $$6 Q .5
	S PSSQVJ1=$E(PSSQVLCD,1,4) I PSSQVJ1="1/2 " I $$7 S PSSQVJ2=$E(PSSQVLCD,5,$L(PSSQVLCD)) I $$6 Q .5
	S PSSQVJ1=$E(PSSQVLCD,1,9) I PSSQVJ1="ONE HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,10,$L(PSSQVLCD)) I $$6 Q .5
	S PSSQVJ1=$E(PSSQVLCD,1,9) I PSSQVJ1="ONE-HALF " I $$7 S PSSQVJ2=$E(PSSQVLCD,10,$L(PSSQVLCD)) I $$6 Q .5
	;
	S PSSQVJ1=$E(PSSQVLCD,1,5) I PSSQVJ1="0.33 " I $$7 S PSSQVJ2=$E(PSSQVLCD,6,$L(PSSQVLCD)) I $$6 Q .33
	S PSSQVJ1=$E(PSSQVLCD,1,4) I PSSQVJ1="1/3 " I $$7 S PSSQVJ2=$E(PSSQVLCD,5,$L(PSSQVLCD)) I $$6 Q .33
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="ONE THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q .33
	S PSSQVJ1=$E(PSSQVLCD,1,10) I PSSQVJ1="ONE-THIRD " I $$7 S PSSQVJ2=$E(PSSQVLCD,11,$L(PSSQVLCD)) I $$6 Q .33
	;
	S PSSQVJ1=$E(PSSQVLCD,1,5) I PSSQVJ1="0.25 " I $$7 S PSSQVJ2=$E(PSSQVLCD,6,$L(PSSQVLCD)) I $$6 Q .25
	S PSSQVJ1=$E(PSSQVLCD,1,4) I PSSQVJ1="1/4 " I $$7 S PSSQVJ2=$E(PSSQVLCD,5,$L(PSSQVLCD)) I $$6 Q .25
	S PSSQVJ1=$E(PSSQVLCD,1,11) I PSSQVJ1="ONE FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,12,$L(PSSQVLCD)) I $$6 Q .25
	S PSSQVJ1=$E(PSSQVLCD,1,11) I PSSQVJ1="ONE-FOURTH " I $$7 S PSSQVJ2=$E(PSSQVLCD,12,$L(PSSQVLCD)) I $$6 Q .25
	;
	S PSSQVJ1=$E(PSSQVLCD,1,2) I PSSQVJ1="4 " I $$7 S PSSQVJ2=$E(PSSQVLCD,3,$L(PSSQVLCD)) I $$6,PSSQVJ2'["4",PSSQVJ2'["3",PSSQVJ2'["2",PSSQVJ2'["FOURTH",PSSQVJ2'["THIRD",PSSQVJ2'["HALF" Q 4
	S PSSQVJ1=$E(PSSQVLCD,1,5) I PSSQVJ1="FOUR " I $$7 S PSSQVJ2=$E(PSSQVLCD,6,$L(PSSQVLCD)) I $$6,PSSQVJ2'["4",PSSQVJ2'["3",PSSQVJ2'["2",PSSQVJ2'["FOURTH",PSSQVJ2'["THIRD",PSSQVJ2'["HALF" Q 4
	;
	S PSSQVJ1=$E(PSSQVLCD,1,2) I PSSQVJ1="3 " I $$7 S PSSQVJ2=$E(PSSQVLCD,3,$L(PSSQVLCD)) I $$6,PSSQVJ2'["4",PSSQVJ2'["3",PSSQVJ2'["2",PSSQVJ2'["FOURTH",PSSQVJ2'["THIRD",PSSQVJ2'["HALF" Q 3
	S PSSQVJ1=$E(PSSQVLCD,1,6) I PSSQVJ1="THREE " I $$7 S PSSQVJ2=$E(PSSQVLCD,7,$L(PSSQVLCD)) I $$6,PSSQVJ2'["4",PSSQVJ2'["3",PSSQVJ2'["2",PSSQVJ2'["FOURTH",PSSQVJ2'["THIRD",PSSQVJ2'["HALF" Q 3
	;
	S PSSQVJ1=$E(PSSQVLCD,1,2) I PSSQVJ1="2 " I $$7 S PSSQVJ2=$E(PSSQVLCD,3,$L(PSSQVLCD)) I $$6,PSSQVJ2'["4",PSSQVJ2'["3",PSSQVJ2'["2",PSSQVJ2'["FOURTH",PSSQVJ2'["THIRD",PSSQVJ2'["HALF" Q 2
	S PSSQVJ1=$E(PSSQVLCD,1,4) I PSSQVJ1="TWO " I $$7 S PSSQVJ2=$E(PSSQVLCD,5,$L(PSSQVLCD)) I $$6,PSSQVJ2'["4",PSSQVJ2'["3",PSSQVJ2'["2",PSSQVJ2'["FOURTH",PSSQVJ2'["THIRD",PSSQVJ2'["HALF" Q 2
	;
	S PSSQVJ1=$E(PSSQVLCD,1,2) I PSSQVJ1="1 " I $$7 S PSSQVJ2=$E(PSSQVLCD,3,$L(PSSQVLCD)) I $$6,PSSQVJ2'["4",PSSQVJ2'["3",PSSQVJ2'["2",PSSQVJ2'["FOURTH",PSSQVJ2'["THIRD",PSSQVJ2'["HALF" Q 1
	S PSSQVJ1=$E(PSSQVLCD,1,4) I PSSQVJ1="ONE " I $$7 S PSSQVJ2=$E(PSSQVLCD,5,$L(PSSQVLCD)) I $$6,PSSQVJ2'["FOURTH",PSSQVJ2'["THIRD",PSSQVJ2'["HALF",PSSQVJ2'["4",PSSQVJ2'["3",PSSQVJ2'["2" Q 1
	;
	Q 0
	;
	;
6()	;
	;Some special characters in a Nouns will pass, (), etc. others like "/" will not
	I PSSQVJ2[" " Q 0
	I PSSQVJ2["-" Q 0
	I PSSQVJ2["&" Q 0
	I PSSQVJ2["\" Q 0
	I PSSQVJ2["/" Q 0
	Q 1
	;
7()	;
	I $L(PSSQVLCD)'>$L(PSSQVJ1) Q 0
	Q 1
