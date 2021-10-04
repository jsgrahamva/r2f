TIUPS275	;ISD/HGW - Post-Install for 275 ;07/16/13  13:51
	;;1.0;TEXT INTEGRATION UTILITIES;**275**;Nov 13, 2012;Build 8
	;  Post Installation Routine for patch TIU*1.0*275
	;  Installs Title and maps it to Enterprise Standard Title and Document Class
	;
	;  EXTERNAL REFERENCES
	;    BMES^XPDUTL 10141
	;    $$FIND1^DIC
	;    NOW^%DTC
	;    UPDATE^DIE 2053
	;
MAIN	; Control subroutine
	N TIUFPRIV,TIU275X,TIUDNM,TIUSNM,TIUNATL,TIUDC
	S TIUFPRIV=1
	S TIUDNM="PATIENT RECORD FLAG CATEGORY I - URGENT    ADDRESS AS FEMALE" ; Name
	S TIUSNM="PRF Addr as Female" ; Short Name
	S TIUNATL="PATIENT RECORD FLAG" ; Enterprise Standard Title
	S TIUDC="PATIENT RECORD FLAG CAT I" ; Document Class
	S TIU275X=$$CREATE(TIUDNM,TIUNATL) ; TIU275X is "Success message" or "Error text"
	D BMES^XPDUTL(TIU275X)
	S TIU275X=$$INSTALL(TIUDNM,TIUDC,TIUSNM) ; TIU275X is "Success message" or "Error text"
	D BMES^XPDUTL(TIU275X)
	Q
CREATE(TIUDNM,TIUNATL)	; Create new DDEF entry
	N %,TIUERR,TIUFDA,TIUIEN,TIUMSG
	S TIUERR="   Title Created: "_TIUDNM
	S TIUFDA(8925.1,"?+1,",.01)=TIUDNM ; NAME
	S TIUFDA(8925.1,"?+1,",.03)=TIUDNM ; PRINT NAME
	S TIUFDA(8925.1,"?+1,",.04)="DOC" ; TYPE: TITLE
	S TIUFDA(8925.1,"?+1,",.06)=$$FIND1^DIC(8930,"","X","CLINICAL COORDINATOR","B") ; OWNER
	S TIUFDA(8925.1,"?+1,",.07)=11 ; STATUS: ACTIVE
	S TIUFDA(8925.1,"?+1,",.13)=1 ; NATIONAL STANDARD: YES
	S TIUFDA(8925.1,"?+1,",3.02)=1 ; OK TO DISTRIBUTE: YES
	S TIUFDA(8925.1,"?+1,",99)=$H ; TIMESTAMP
	S TIUFDA(8925.1,"?+1,",1501)=$$FIND1^DIC(8926.1,"","X",TIUNATL,"B") ; VHA ENTERPRISE STANDARD TITLE
	D NOW^%DTC S TIUFDA(8925.1,"?+1,",1502)=% ; MAP ATTEMPTED
	S TIUFDA(8925.1,"?+1,",1503)=DUZ ; MAP ATTEMPTED BY
	D UPDATE^DIE("","TIUFDA","TIUIEN","TIUMSG")
	I $D(TIUMSG) D  Q TIUERR
	. S TIUERR="   **ERROR** "_$G(TIUMSG("DIERR",1))_" Unable to create Title "_TIUDNM
	Q TIUERR
INSTALL(TIUDNM,TIUDC,TIUSNM)	; Install document definition
	N TIUERR,TIUFPRIV,TIUTIEN,TIUDIEN,TIUFDA,TIUIEN,TIUMSG
	S TIUERR="   Title attached to Document Class "_TIUDC
	S TIUFPRIV=1
	; Find the IEN of the Title
	S TIUTIEN=$$FIND1^DIC(8925.1,"","X",TIUDNM,"B")
	I 'TIUTIEN D  Q TIUERR
	. S TIUERR="   **ERROR** Unable to locate Title "_TIUDNM
	; Find the IEN of the Document Class
	S TIUDIEN=$$FIND1^DIC(8925.1,"","X",TIUDC,"B")
	I 'TIUDIEN D  Q TIUERR
	. S TIUERR="   **ERROR** Unable to locate Document Class "_TIUDC
	; Attach the Title to Document Class
	S TIUFDA(8925.14,"?+2,"_TIUDIEN_",",.01)=TIUTIEN ; ITEM
	S TIUFDA(8925.14,"?+2,"_TIUDIEN_",",2)="" ; MNEMONIC
	S TIUFDA(8925.14,"?+2,"_TIUDIEN_",",3)="" ; SEQUENCE
	S TIUFDA(8925.14,"?+2,"_TIUDIEN_",",4)=TIUSNM ; MENU TEXT
	D UPDATE^DIE("","TIUFDA","TIUIEN","TIUMSG")
	I $D(TIUMSG) D  Q TIUERR
	. S TIUERR="   **ERROR** Unable to update Document Class "_TIUDC
	Q TIUERR