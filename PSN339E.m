PSN339E	;BIR/DMA-environment check for data updates ; 19 Oct 2012  11:05 AM
	;;4.0;NATIONAL DRUG FILE;**339**; 30 Oct 98;Build 65
	;
	I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
	E  W !!,"You must be a valid user." S XPDQUIT=2
	I $$PATCH^XPDUTL(XPDNM) W !!,"This patch has already been installed." S XPDQUIT=1 Q
	Q
