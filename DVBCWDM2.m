DVBCWDM2	;ALB/RLC DIGESTIVE, MISC. DISEASES ; 5 MARCH 1997
	;;2.7;AMIE;**164**;Apr 10, 1995;Build 2
	;
EN	D:'$D(IOF) SETIOF W:(IOST?1"C-".E) @IOF
	S DVBAX="For DIGESTIVE CONDITIONS, MISCELLANEOUS",PG=1
	W !?22,"Compensation and Pension Examination",!,?(IOM-$L(DVBAX)\2),DVBAX
	S DVBAX="(Tuberculous Peritonitis, Inguinal Hernia, Ventral Hernia,"
	W !,?(IOM-$L(DVBAX)\2),DVBAX
	S DVBAX="Femoral Hernia, Visceroptosis, and Benign and Malignant"
	W !,?(IOM-$L(DVBAX)\2),DVBAX
	S DVBAX="New Growths)"
	W !,?(IOM-$L(DVBAX)\2),DVBAX,!?33,"# 0330 Worksheet",!!
	W "Name: ",NAME,?45,"SSN: ",SSN,!,?45,"C-number: ",CNUM,!,"Date of exam: ____________________",!!,"Place of exam: ___________________",!!
	S DIF="^TMP($J,""DVBAW"",",XCNP=0
	K ^TMP($J,"DVBAW")
	F ROU="DVBCWDM3" S X=ROU X ^%ZOSF("LOAD")
	K DIF,XCNP,ROU
	N LP,TEXT
	S LP=0,STOP=0
	F  S LP=$O(^TMP($J,"DVBAW",LP)) Q:(LP="")!(STOP)  D
	.S TEXT=^TMP($J,"DVBAW",LP,0)
	.I (TEXT'[";;")!(TEXT[";AMIE;") Q
	.;I TEXT["TOF" D HD2
	.I TEXT["END" S STOP=1 Q
	.W:TEXT'["TOF" $P(TEXT,";;",2),! I $Y>55 D HD2
	K ^TMP($J,"DVBAW"),TEXT,STOP,LP,PG,DVBAX,X
	Q
	;
HD2	S PG=PG+1 W @IOF,!,"Page: ",PG,!!,"Compensation and Pension Exam for "_NAME,!
	W "For DIGESTIVE CONDITIONS, MISCELLANEOUS",!!!
	Q
SETIOF	;  ** Set device control var's
	D HOME^%ZIS
	Q
