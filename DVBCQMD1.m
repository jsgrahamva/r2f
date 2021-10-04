DVBCQMD1	;;ALB-CIOFO/ECF - MENTAL DISORDERS QUESTIONNAIRE ; 9/10/2010
	;;2.7;AMIE;**161**;Apr 10, 1995;Build 8
	;
EN	;
	D:'$D(IOF) SETIOF W:(IOST?1"C-".E) @IOF
	S DVBAX="Mental Disorders",TT=40-($L(DVBAX)\2),PG=1
	W !?40-($L("Disability Benefits Questionnaire")\2),"Disability Benefits Questionnaire",!,?TT,DVBAX
	S DVBAX="(other than PTSD and Eating Disorders)",TT=40-($L(DVBAX)\2)
	W !,?TT,DVBAX,!
	W !?1,"Name of patient/Veteran: ",$S($G(NAME)]"":NAME,1:"_______________________")
	W ?45,"   SSN: ",$S($G(SSN)]"":SSN,1:"________________"),!!
	S DIF="^TMP($J,""DVBAW"",",XCNP=0
	K ^TMP($J,"DVBAW")
	F ROU="DVBCQMD2" S X=ROU X ^%ZOSF("LOAD")
	K DIF,XCNP,ROU
	N LP,TEXT
	S LP=0,STOP=0
	F  S LP=$O(^TMP($J,"DVBAW",LP)) Q:(LP="")!(STOP)  D
	.S TEXT=^TMP($J,"DVBAW",LP,0)
	.I (TEXT'[";;")!(TEXT[";AMIE;")!(TEXT["ALB-CIOFO/") Q
	.I TEXT["^TOF^" D HD2
	.I TEXT["^END^" S STOP=1 Q
	.W:TEXT'["^TOF^" $P(TEXT,";;",2),! I $Y>56 D HD2
	K ^TMP($J,"DVBAW"),DVBY,TEXT,STOP,LP,PG,DVBAX,X
	Q
	;
HD2	;
	S DVBY=$O(^TMP($J,"DVBAW",LP))
	Q:DVBY=""
	Q:$G(^TMP($J,"DVBAW",DVBY,0))["^END^"
	S PG=PG+1 W @IOF,!,"Page: ",PG,!!,"Disability Benefits Questionnaire for ",$G(NAME),!
	W "Mental Disorders (other than PTSD and Eating Disorders)",!!!
	Q
SETIOF	;  ** Set device control var's
	D HOME^%ZIS
	Q
