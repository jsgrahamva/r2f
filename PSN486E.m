PSN486E ;BHM/DB-Environment Check for PMI data updates ; 05 Jul 2016  12:35 PM
 ;;4.0;NATIONAL DRUG FILE;**486**; 30 Oct 98;Build 110
 ;
 I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
 E  W !,"You must be a valid user."
 Q
