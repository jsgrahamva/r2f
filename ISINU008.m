ISINU008 ;ISI/NST - Utilities for RPC calls ; 19 Feb 2014 4:16 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
 ; Update a record 
 ; 
 ; Input parameters
 ; ================
 ; 
 ; FILE - file number
 ; FLDSVAL - single fields
 ; FLDSVALW - word-procesing fields 
 ; 
 ; Output parameter
 ; ===============
 ; ISIRY
 ;
 ; if failed ISIRY = Failure status ^ Error message
 ; if success ISIRY = Success status 
 ; 
UPDRCD(ISIRY,FILE,FLDSVAL,FLDSVALW) ; Update a record to a file
 N IENS,FLDNAME,FIELD
 N ISINFDA,ISINIEN,ISINXE
 N MESSAGE,ERR
 ;
 I '$G(FLDSVAL("IEN")) S ISIRY=$$SETERROR^ISINU002("Missing Primary Key (IEN)") Q
 S IENS=FLDSVAL("IEN")_","
 S FLDNAME=""
 S ERR=0
 F  S FLDNAME=$O(FLDSVAL(FLDNAME)) Q:FLDNAME=""  D  Q:ERR
 . Q:FLDNAME="IEN"   ; skip primary key record (IEN)
 . S FIELD=$$GETFLDID^ISINU001(FILE,FLDNAME)
 . S ISINFDA(FILE,IENS,FIELD)=FLDSVAL(FLDNAME)
 . S ERR='$$VALIDFLD^ISINU006(FILE,FIELD,FLDSVAL(FLDNAME),.MESSAGE)
 . Q
 I ERR S ISIRY=$$SETERROR^ISINU002(MESSAGE) Q
 ;
 D UPDATE^DIE("","ISINFDA","ISINIEN","ISINXE")
 ;
 I $D(ISINXE("DIERR","E")) S ISIRY=$$SETERROR^ISINU002("Error updating a record in file #"_FILE) Q
 ;
 ; Now, store the Word-Processing fields
 S FLDNAME=""
 F  S FLDNAME=$O(FLDSVALW(FLDNAME)) Q:FLDNAME=""  D  Q:ERR
 . K ISINXE
 . S WPFLD=$$GETFLDID^ISINU001(FILE,FLDNAME) ; FileMan number of WP field
 . D WP^DIE(FILE,IENS,WPFLD,"K","FLDSVALW(FLDNAME)","ISINXE")
 . I $D(ISINXE("DIERR","E")) D  Q  ; clean up newly created record
 . . S ERR=1
 . . N DA,DIK
 . . S ISIRY=$$SETERROR^ISINU002("Error updating ["_FLDNAME_"] data.")
 . . Q
 . Q
 Q:ERR  ; ISIRY is already set
 ;
 S ISIRY=$$OK^ISINU002()
 Q
