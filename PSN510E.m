PSN510E ;BHM/DB-Environment Check for PMI data updates ; 31 Jan 2017  12:46 PM
 ;;4.0;NATIONAL DRUG FILE;**510**; 30 Oct 98;Build 119
 ;
 I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
 E  W !,"You must be a valid user."
 Q
