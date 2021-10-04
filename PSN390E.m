PSN390E	;BHM/DB-Environment Check for PMI data updates ; 04 Mar 2014  5:20 PM
	;;4.0;NATIONAL DRUG FILE;**390**; 30 Oct 98;Build 80
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q
