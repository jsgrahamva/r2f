PSSHRENV	;WOIFO/RR,SG - ENVIRONMENT CHECK FOR PACKAGE--CHECKS EXISTANCE OF MAIL GROUP AND IF NOT CREATES IT ;09/20/07
	;;1.0;PHARMACY DATA MANAGEMENT;**136**;9/30/97;Build 89
	;
EN	;
	N PSSMGPNM,PSSMGPOR,PSSMGPDS,PSSMGPRS,PSSMGPMY,PSSMGPNM,PSSMGPSL,PSSMGPQT,PSSMGPTP
	N DTOUT,DUOUT,Y
	K XPDABORT,PSSMGPAR
	;If mail group already exists quit.
	I $$FIND1^DIC(3.8,"","X","PSS ORDER CHECKS","B") Q
	S PSSMGPAR(1)="A 'PSS ORDER CHECKS' Mail Group is now being created. Mail Group members will"
	S PSSMGPAR(2)="receive various notifications that impact Enhanced Order Checks (drug-drug"
	S PSSMGPAR(3)="interactions, duplicate therapy and dosing) introduced with PRE V. 0.5. Please"
	S PSSMGPAR(4)="enter the Pharmacy ADPAC or a designee to be the Mail Group Organizer."
	S PSSMGPAR(5)=" "
	S PSSMGPAR(6)="To continue this install, you must now enter a Mail Group organizer."
	S PSSMGPAR(7)=" "
	D MES^XPDUTL(.PSSMGPAR)
	K DIC S DIC=200,DIC(0)="QEAMZ",DIC("A")="Enter Mail Group Organizer: "
	;abort install if user does not enter a coordinator
	D ^DIC K DIC I $D(DTOUT)!($D(DUOUT))!(+Y'>0) K PSSMGPAR S XPDABORT=2 Q
	S PSSMGPOR=+Y,PSSMGPMY(+Y)=""
	S PSSMGPNM="PSS ORDER CHECKS",PSSMGPTP=0,PSSMGPSL=0,PSSMGPQT=1
	S PSSMGPDS(1)="Members of this mail group will receive various notifications that impact"
	S PSSMGPDS(2)="Enhanced Order Checks (drug-drug interactions, duplicate therapy and dosing"
	S PSSMGPDS(3)="checks) introduced with PRE V. 0.5 utilizing a COTS database."
	S PSSMGPRS=$$MG^XMBGRP(PSSMGPNM,PSSMGPTP,PSSMGPOR,PSSMGPSL,.PSSMGPMY,.PSSMGPDS,PSSMGPQT)
	I 'PSSMGPRS D BMES^XPDUTL(" ") D  Q
	.D BMES^XPDUTL("Unable to create PSS ORDER CHECKS Mail Group, aborting install.") S XPDABORT=2
	.K PSSMGPAR
	;Last line above also aborts install if the call to MG^XMBGRP fails to create the Mail Group
	K PSSMGPAR
	Q
