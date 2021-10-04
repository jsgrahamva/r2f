PSN358E	;BHM/DB-Environment Check for PMI data updates ; 02 May 2013  11:06 AM
	;;4.0;NATIONAL DRUG FILE;**358**; 30 Oct 98;Build 70
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q
