PSN389E	;BHM/DB-Environment Check for PMI data updates ; 06 Feb 2014  1:26 PM
	;;4.0;NATIONAL DRUG FILE;**389**; 30 Oct 98;Build 82
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q