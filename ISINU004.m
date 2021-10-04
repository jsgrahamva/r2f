ISINU004 ;ISI/NST - Utilities for RPC calls ; 18 Feb 2014 4:16 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
 ; Add a new record 
 ; 
 ; Input parameters
 ; ================
 ; 
 ; FILE - file number
 ; FLDSVAL - array with index field name and value
 ; FLDSVALW - array with first index WP field name and the second values 
 ;  e.g FLDSVALW("URL",1)="Line1
 ;      FLDSVALW("URL",2)="Line 2"
 ; 
 ; Result values
 ; ===============
 ; if failed ISIRY = Failure status ^ Error message
 ; if success ISIRY = Success status ^  ^ IEN
 ; 
 ; 
ADDRCD(ISIRY,FILE,FLDSVAL,FLDSVALW) ; Add a new record to a file
 N IENS,FLDNAME,FIELD,WPFLD
 N ISIDA,ISINFDA,ISINIEN,ISINXE
 N MESSAGE,ERR
 N X,FLDSARR,FLDSARRW
 ;
 S X=$$GETFLDS^ISINU001(.FLDSARR,.FLDSARRW,FILE,"")  ; Get all fields
 ; Check if we set all required fields
 D REQFLDS^ISINU007(.ISIRY,FILE,.FLDSVAL,.FLDSARR,0) ; 
 I '$$ISOK^ISINU002(ISIRY) Q
 ;
 ; Check for WP required fields
 D REQFLDS^ISINU007(.ISIRY,FILE,.FLDSVALW,.FLDSARRW,1) ; 
 I '$$ISOK^ISINU002(ISIRY) Q
 ;
 ; Set FDA array and check for valid values
 S IENS="+1,"
 S FLDNAME=""
 S ERR=0
 F  S FLDNAME=$O(FLDSVAL(FLDNAME)) Q:FLDNAME=""  D  Q:ERR
 . Q:FLDSVAL(FLDNAME)=""
 . S FIELD=$$GETFLDID^ISINU001(FILE,FLDNAME)
 . K FLDSARR(FIELD)  ; delete the field from the list; will use it in the check for check required fields
 . S ISINFDA(FILE,IENS,FIELD)=FLDSVAL(FLDNAME)
 . S ERR='$$VALIDFLD^ISINU006(FILE,FIELD,FLDSVAL(FLDNAME),.MESSAGE)
 . Q
 I ERR S ISIRY=$$SETERROR^ISINU002(MESSAGE) Q
 ;    
 ; Add the regular field first
 D UPDATE^DIE("S","ISINFDA","ISINIEN","ISINXE")
 ;
 I $D(ISINXE("DIERR","E")) S ISIRY=$$SETERROR^ISINU002("Error adding a new record") Q
 S ISIDA=ISINIEN(1)  ; IEN of the new record
 ;
 ; Now store the Word-Processing fields
 S IENS=ISIDA_","
 S FLDNAME=""
 F  S FLDNAME=$O(FLDSVALW(FLDNAME)) Q:FLDNAME=""  D  Q:ERR
 . K ISINXE
 . S WPFLD=$$GETFLDID^ISINU001(FILE,FLDNAME) ; FileMan number of WP field
 . I '(FLDSARRW(WPFLD,"TYPE")["Wx") Q  ; it is not a Word-processing field
 . D WP^DIE(FILE,IENS,WPFLD,"A","FLDSVALW(FLDNAME)","ISINXE")
 . I $D(ISINXE("DIERR","E")) D  Q  ; clean up newly created record
 . . S ERR=1
 . . N DA,DIK
 . . S ISIRY=$$SETERROR^ISINU002("Error adding new ["_FLDNAME_"] data.")
 . . ; clean up data
 . . S DIK=$$GETFILGL^ISINU001(FILE)
 . . S DA=ISIDA
 . . D ^DIK
 . . Q
 . Q
 Q:ERR  ; ISIRY is already set
 ;
 S ISIRY=$$SETOKVAL^ISINU002(ISIDA)
 Q
