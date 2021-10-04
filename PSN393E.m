PSN393E	;BHM/DB-Environment Check for PMI data updates ; 02 Apr 2014  11:29 AM
	;;4.0;NATIONAL DRUG FILE;**393**; 30 Oct 98;Build 81
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q
