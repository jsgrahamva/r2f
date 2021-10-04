PSN392E	;BHM/DB-Environment Check for PMI data updates ; 05 Mar 2014  4:01 PM
	;;4.0;NATIONAL DRUG FILE;**392**; 30 Oct 98;Build 83
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q
