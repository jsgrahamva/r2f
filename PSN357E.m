PSN357E	;BHM/DB-Environment Check for PMI data updates ; 08 Apr 2013  5:50 PM
	;;4.0;NATIONAL DRUG FILE;**357**; 30 Oct 98;Build 71
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q
