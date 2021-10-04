PSN371E	;BHM/DB-Environment Check for PMI data updates ; 08 Aug 2013  4:48 PM
	;;4.0;NATIONAL DRUG FILE;**371**; 30 Oct 98;Build 76
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q
