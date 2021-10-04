PSN346E	;BHM/DB-Environment Check for PMI data updates ; 31 Dec 2012  2:22 PM
	;;4.0;NATIONAL DRUG FILE;**346**; 30 Oct 98;Build 66
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q
