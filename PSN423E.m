PSN423E	;BHM/DB-Environment Check for PMI data updates ; 06 Jan 2015  11:22 AM
	;;4.0;NATIONAL DRUG FILE;**423**; 30 Oct 98;Build 92
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q
