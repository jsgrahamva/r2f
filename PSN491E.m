PSN491E ;BHM/DB-Environment Check for PMI data updates ; 01 Aug 2016  10:09 PM
 ;;4.0;NATIONAL DRUG FILE;**491**; 30 Oct 98;Build 113
 ;
 I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
 E  W !,"You must be a valid user."
 Q
