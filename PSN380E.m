PSN380E	;BHM/DB-Environment Check for PMI data updates ; 07 Nov 2013  1:21 PM
	;;4.0;NATIONAL DRUG FILE;**380**; 30 Oct 98;Build 79
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !,"You must be a valid user."
	Q
