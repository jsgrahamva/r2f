PSN525E ;BHM/DB-Environment Check for PMI data updates ; 06 Jun 2017  5:25 PM
 ;;4.0;NATIONAL DRUG FILE;**525**; 30 Oct 98;Build 124
 ;
 I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
 E  W !,"You must be a valid user."
 Q
