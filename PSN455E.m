PSN455E	;BHM/DB-Environment Check for PMI data updates ; 07 Oct 2015  1:19 PM
	;;4.0;NATIONAL DRUG FILE;**455**; 30 Oct 98;Build 101
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q
