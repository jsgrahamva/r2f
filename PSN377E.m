PSN377E	;BHM/DB-Environment Check for PMI data updates ; 02 Oct 2013  2:45 PM
	;;4.0;NATIONAL DRUG FILE;**377**; 30 Oct 98;Build 78
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q
