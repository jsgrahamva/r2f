PSN369E	;BHM/DB-Environment Check for PMI data updates ; 07 Aug 2013  5:41 PM
	;;4.0;NATIONAL DRUG FILE;**369**; 30 Oct 98;Build 73
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q
