PSN419E	;BHM/DB-Environment Check for PMI data updates ; 04 Nov 2014  10:49 AM
	;;4.0;NATIONAL DRUG FILE;**419**; 30 Oct 98;Build 92
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q
