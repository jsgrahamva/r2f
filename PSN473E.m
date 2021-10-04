PSN473E ;BIR/DMA-environment check for data updates ; 02 Mar 2016  1:43 PM
 ;;4.0;NATIONAL DRUG FILE;**473**; 30 Oct 98;Build 110
 ;
 I $D(DUZ)#2 N DIC,X,Y S DIC=200,DIC(0)="N",X="`"_DUZ D ^DIC I Y>0
 E  W !!,"You must be a valid user." S XPDQUIT=2
 I $$PATCH^XPDUTL(XPDNM) W !!,"This patch has already been installed." S XPDQUIT=1 Q
 Q
