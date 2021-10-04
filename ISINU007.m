ISINU007 ;ISI/NST - Utilities for RPC calls ; 19 Feb 2014 4:16 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
 ;+++++ Check if all required  fields are sent
 ; 
 ; 
 ; Input parameters
 ; ================
 ; 
 ;  FILE    = file number
 ;  FLDSVAL = array with fields values. Index of the array is fields names
 ;  FLDSARR = array with fields definition. Index is field's numbers
 ;  FLGWP   = this is Word-processing fields
 ;  
 ;  Result Values
 ;  =============
 ;  
 ; if failure ISIRY = Failure status ^ Error message
 ; if success ISIRY = Success status 
 ;  
REQFLDS(ISIRY,FILE,FLDSVAL,FLDSARR,FLGWP) ; 
 N FLDNAME,MSG,ERR
 N TFLDSARR
 N WP
 M TFLDSARR=FLDSARR
 S FLDNAME=""
 S ERR=0
 F  S FLDNAME=$O(FLDSVAL(FLDNAME)) Q:FLDNAME=""  D  Q:ERR
 . I 'FLGWP Q:FLDSVAL(FLDNAME)=""  ; value is empty, so get next one
 . I FLGWP M WP=FLDSVAL(FLDNAME) Q:$$WPEMPTY^ISINU005(.WP)  ; quit if WP field is blank
 . S FIELD=$$GETFLDID^ISINU001(FILE,FLDNAME)
 . I FIELD="" D  Q
 . . S MSG="Field ["_FLDNAME_"] is not found in file #"_FILE
 . . S ISIRY=$$SETERROR^ISINU002(MSG)
 . . S ERR=1
 . . Q
 . K TFLDSARR(FIELD)  ; delete the field from the list; will use it in the check for check required fields
 . Q
 I ERR Q
 ; Check if we set all required fields
 S FIELD=""
 F  S FIELD=$O(TFLDSARR(FIELD)) Q:FIELD=""  D  Q:ERR
 . I TFLDSARR(FIELD,"TYPE")["R" D  Q
 . . S MSG="Field ["_TFLDSARR(FIELD)_"] is required in file #"_FILE
 . . S ISIRY=$$SETERROR^ISINU002(MSG)
 . . S ERR=1
 . . Q
 . Q
 Q:ERR
 ;
 S ISIRY=$$OK^ISINU002()
 Q
