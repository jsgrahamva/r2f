IMRCLEAN ;HCIOFO/FAI-CLEAN UP ERRONEOUS VALUES IN BASIC PATIENT DATA ;04/05/01  11:49;
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**5,13**;Feb 09, 1998
 ;
BEGIN D EMPTY,KILL
 Q
EMPTY S VAL="" F  S VAL=$O(^IMR(158,"B",VAL)),IMRVAL="" Q:VAL=""  F  S IMRVAL=$O(^IMR(158,"B",VAL,IMRVAL)) Q:IMRVAL=""  D CD4,HGB,HCT,MCV,CATEG
 Q
CD4 S $P(^IMR(158,IMRVAL,102),U,5)="",$P(^IMR(158,IMRVAL,102),U,6)="",$P(^IMR(158,IMRVAL,102),U,1)="",$P(^IMR(158,IMRVAL,102),U,2)="",$P(^IMR(158,IMRVAL,112),U,9)="",$P(^IMR(158,IMRVAL,112),U,10)=""
 Q
HGB S IFN="" F  S IFN=$O(^IMR(158,IMRVAL,113,"B",3,IFN)) Q:IFN=""  S DA(1)=IMRVAL,DA=IFN,DIK="^IMR(158,"_IMRVAL_",113," D ^DIK K DA,DIK
 Q
HCT S IEN="" F  S IEN=$O(^IMR(158,IMRVAL,113,"B",4,IEN)) Q:IEN=""  S DA(1)=IMRVAL,DA=IEN,DIK="^IMR(158,"_IMRVAL_",113," D ^DIK K DA,DIK
 Q
MCV S IEN="" F  S IEN=$O(^IMR(158,IMRVAL,113,"B",5,IEN)) Q:IEN=""  S DA(1)=IMRVAL,DA=IEN,DIK="^IMR(158,"_IMRVAL_",113," D ^DIK K DA,DIK
 Q
CATEG S IMRCAT=$P($G(^IMR(158,IMRVAL,0)),U,42)
 Q:IMRCAT=4
 S $P(^IMR(158,IMRVAL,0),U,42)="",$P(^IMR(158,IMRVAL,0),U,35)="",$P(^IMR(158,IMRVAL,0),U,36)="",$P(^IMR(158,IMRVAL,0),U,44)=""
 Q
KILL ; kill variables
 K IMRCAT,IMRVAL,FIN,IEN,IFN,NUM,VAL
 Q
