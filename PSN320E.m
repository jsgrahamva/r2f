PSN320E	;BHM/DB-Environment Check for PMI data updates ; 06 Apr 2012  11:46 AM
	;;4.0;NATIONAL DRUG FILE;**320**; 30 Oct 98;Build 59
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q
