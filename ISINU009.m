ISINU009 ;ISI/NST - Utilities for RPC calls ; 19 Feb 2014 4:16 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
 ; Append a record to array
 ; 
 ; Input parameters
 ; ================
 ; 
 ; CNT - The starting position in the output array where the record will be appended 
 ; FILE - file number
 ; FIELDS - ";" delimited string with fields to return e.g., ".01;3"
 ; IEN - IEN in FILE 
 ; 
 ; Return values
 ; ===============
 ; if failed ISIRY(0) = Failure status ^ Error message
 ; if success ISIRY(CNT) = "^" delimted fields values
 ; 
GETONE(ISIRY,CNT,FILE,FIELDS,IEN) ; Append one record to ISIRY
 N IENS,J,X,OUT,ERR,ISIRESA
 N RESDEL
 S RESDEL=$$RESDEL^ISINU002()  ; Result delimiter
 ;
 S IENS=IEN_","
 D GETS^DIQ(FILE,IENS,FIELDS,"IE","OUT","ERR")
 I $D(ERR("DIERR")) D  Q
 . D MSG^DIALOG("A",.ISIRESA,245,5,"ERR")
 . K ISIRY
 . S ISIRY(0)=$$SETERROR^ISINU002("Error getting values: "_ISIRESA(1)) Q  ; Error getting the values
 . Q
 S ISIRY(CNT)=IEN
 S J=""
 F  S J=$O(OUT(FILE,IENS,J)) Q:'J  D
 . S ISIRY(CNT)=ISIRY(CNT)_RESDEL_OUT(FILE,IENS,J,"I")_RESDEL_OUT(FILE,IENS,J,"E")
 . Q
 Q
 
