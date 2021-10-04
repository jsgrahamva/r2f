PSS159EN	;BIR/SJA-ENVIRONMENT CHECK ROUTINE FOR PSS*1*159 ;09/13/11
	;;1.0;PHARMACY DATA MANAGEMENT;**159**;9/30/97;Build 29
	;
	Q:'$G(XPDENV)
	;
EN	;
	N PSSMES,PSSAR,PSSARX,PSSLP,PSSFLG,DIC,DTOUT,DUOUT,X,Y,DIRUT,DIROUT,DIR
	S PSSMES(1)="Upon completion of the post-install, a mail message will be sent"
	S PSSMES(2)="to the patch installer, and at least one pharmacy user. Please"
	S PSSMES(3)="enter one or more Pharmacy users (e.g., Pharmacy ADPAC or designee)"
	S PSSMES(4)="who should receive this message."
	D MES^XPDUTL(.PSSMES)
	S PSSAR(DUZ)=""
	S PSSFLG=0
	;
ASK	;
	D BMES^XPDUTL(" ")
	K DIC S DIC=200,DIC(0)="QEAMZ",DIC("A")="Enter Pharmacy User: "
	D ^DIC K DIC I $D(DTOUT)!($D(DUOUT))!(+Y'>0) G END
	I $D(PSSAR(+Y)) D BMES^XPDUTL("Already selected.") G ASK
	S PSSFLG=1
	S PSSAR(+Y)=""
	G ASK
	;
END	;
	I 'PSSFLG D BMES^XPDUTL("At least one recipient must be selected. Install aborted.") S XPDABORT=2 Q
	D BMES^XPDUTL(" ")
	K DIR,Y S DIR(0)="Y",DIR("B")="Y",DIR("A")="Continue with install",DIR("?")="Enter 'Y' to continue with install, enter 'N' or '^' to abort install" D ^DIR K DIR
	I Y'=1!($D(DTOUT))!($D(DUOUT)) S XPDABORT=2 Q
	D BMES^XPDUTL(" ")
	F PSSLP=0:0 S PSSLP=$O(PSSAR(PSSLP)) Q:'PSSLP  S @XPDGREF@("PSSARX",PSSLP)=""
	Q
