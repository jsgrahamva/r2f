DVBCWNW2 ;ALB/RLC NOSE, SINUS, ETC WKS ; 30 MARCH 2005
 ;;2.7;AMIE;**93**;Aug 7, 2003
 ;
EN D:'$D(IOF) SETIOF W:(IOST?1"C-".E) @IOF
 S DVBAX="For NOSE, SINUS, LARYNX, AND PHARYNX",PG=1
 W !?22,"Compensation and Pension Examination",!,?(IOM-$L(DVBAX)\2),DVBAX,!?33,"# 1510 Worksheet",!!
 W "Name: ",NAME,?45,"SSN: ",SSN,!,?45,"C-number: ",CNUM,!,"Date of exam: ____________________",!!,"Place of exam: ___________________",!!
 S DIF="^TMP($J,""DVBAW"",",XCNP=0
 K ^TMP($J,"DVBAW")
 F ROU="DVBCWNW3" S X=ROU X ^%ZOSF("LOAD")
 K DIF,XCNP,ROU
 N LP,TEXT
 S LP=0,STOP=0
 F  S LP=$O(^TMP($J,"DVBAW",LP)) Q:(LP="")!(STOP)  D
 .S TEXT=^TMP($J,"DVBAW",LP,0)
 .I (TEXT'[";;")!(TEXT[";AMIE;") Q
 .I TEXT["TOF" D HD2
 .I TEXT["END" S STOP=1 Q
 .W:TEXT'["TOF" $P(TEXT,";;",2),! I $Y>58 D HD2
 K ^TMP($J,"DVBAW"),TEXT,STOP,LP,PG,DVBAX,X
 Q
 ;
HD2 S PG=PG+1 W @IOF,!,"Page: ",PG,!!,"Compensation and Pension Exam for "_NAME,!
 W "For NOSE, SINUS, LARYNX, AND PHARYNX",!!!
 Q
SETIOF ;  ** Set device control var's
 D HOME^%ZIS
 Q
