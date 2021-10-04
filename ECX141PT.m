ECX141PT	;ALB/AG-PATCH ECX*3.0*141 POST-INIT RTN; ; 10/5/12 10:46am
	;;3.0;DSS EXTRACTS;**141**;DEC 22,1997;Build 5
	;
	;Post-init routine adding new entries and updating current entries to:
	;
	;NATIONAL CLINIC file(#728.441)
	;
	;
	Q
EN	;Routine Entry Point
	D ADDNEW  ;Add new Clinic codes
	D UPDATE  ;Change short description of existing clinic codes
	Q
	;
	;
ADDNEW	;Add new entry to file 728.441
	;ECXREC is in format:code^short description
	;
	;
	N ECXFDA,ECXERR,ECXCODE,ECXREC,I
	;
	;-Get NATIONAL CLINIC record
	F I=1:1 S ECXREC=$P($T(ADDCLIN+I),";;",2) Q:ECXREC="QUIT"  D
	.;
	.;-National Clinic code
	.S ECXCODE=$P(ECXREC,"^")
	.;
	.;-Quit w/error message if entry already exists in file #728.441
	.I $$FIND1^DIC(728.441,"","X",ECXCODE) D  Q
	..D BMES^XPDUTL(">>>..."_ECXCODE_" "_$P(ECXREC,U,2)_" not added, entry already exists.")
	..D BMES^XPDUTL(">>> Delete entries and reinstall patch if entries were not created by a")
	..D BMES^XPDUTL(">>> previous installation of this patch.")
	.;
	.;-Setup field values of new entry
	.S ECXFDA(728.441,"+1,",.01)=ECXCODE
	.S ECXFDA(728.441,"+1,",1)=$P(ECXREC,"^",2)
	.;
	.;-Add new entry to file #728.441
	.D UPDATE^DIE("E","ECXFDA","","ECXERR")
	.;
	.I '$D(ECXERR) D BMES^XPDUTL(">>>...."_ECXCODE_" "_$P(ECXREC,U,2)_" added to file.")
	.I $D(ECXERR) D BMES^XPDUTL(">>>....Unable to add "_ECXCODE_" "_$P(ECXREC,U,2)_"to file.")
	;
	Q
UPDATE	;Changing short description of existing clinic
	N ECXCODE,ECXDESC,ECXIEN,DIE,DA,DR,I
	D BMES^XPDUTL(">>>Updating entry in the NATIONAL CLINIC (728.441) file...")
	F I=1:1 S ECXREC=$P($T(UPDCLIN+I),";;",2) Q:ECXREC="QUIT"  D
	.S ECXCODE=$P(ECXREC,"^"),ECXDESC=$P(ECXREC,"^",2)
	.S ECXIEN=$$FIND1^DIC(728.441,"","X",ECXCODE,"","","ERR")
	.I ECXIEN="" D  Q
	..D BMES^XPDUTL(">>>...Unable to add "_ECXCODE_" "_$P(ECXREC,U,2)_" to file.")
	..D BMES^XPDUTL("Contact support for assistance")
	.S DIE="^ECX(728.441,",DA=ECXIEN,DR="1///^S X=ECXDESC"
	.D ^DIE
	.D BMES^XPDUTL(">>>...."_ECXCODE_" "_$P(ECXREC,U,2)_" updated")
	;
ADDCLIN	;Contains the NATIONAL CLINIC entries to be added
	;;EQTH^Equine Therapy
	;;NCCH^Nat'lCallCtrforHomelessVets
	;;QUIT
UPDCLIN	;Contains the NATIONAL CLINIC entry description to be updated
	;;PLTR^Polytrauma PRC
	;;PLTV^TBI CVT Telehealth Eval
	;;QUIT
