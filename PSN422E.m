PSN422E	;BHM/DB-Environment Check for PMI data updates ; 03 Dec 2014  9:59 AM
	;;4.0;NATIONAL DRUG FILE;**422**; 30 Oct 98;Build 93
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q
