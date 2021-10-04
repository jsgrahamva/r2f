ISINCF08 ;ISI/NST - RPC for form workflow file ; 07 Mar 2014 3:59 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
 ;*****  Get a list of form workflows
 ;       
 ; RPC:ISIN LIST FORM WORKFLOW
 ; 
 ; Input Parameters
 ; ================
 ; 
 ; ISIPARAM("ACTIVE") - 0 for inactive, 1 for active, 2 for all 
 ; 
 ; Return Values
 ; =============
 ; if error ISIRY(0) = Failure status ^Error message^
 ; if success ISIRY(0) = Success status ^^Count or records
 ;            ISIRY(1)    = "^" delimited string with all field names in ISI FORM WORKFLOW file (#9999910.101)
 ;                              excluding word-processing fields
 ;            ISIRY(2..n) = "^" delimited string with internal and external values of fields listed in ISIRY(1) 
 ; 
CWFLIST(ISIRY,ISIPARAM) ; RPC [ISIN LIST FORM WORKFLOW]
 N ACTIVE,IEN
 N RESDEL
 N ISII,CNT,FILE,FIELDS,FLDSARR,FLDSARRW,ERR,OUT
 K ISIRY
 ;
 S RESDEL=$$RESDEL^ISINU002()  ; Result delimiter
 S FILE=9999910.101
 S FIELDS=$$GETFLDS^ISINU001(.FLDSARR,.FLDSARRW,FILE,"")
 ;
 S ACTIVE=ISIPARAM("ACTIVE")
 S CNT=1
 I (ACTIVE=0)!(ACTIVE=1) D  ; Use ACTIVE index to get records
 . S IEN=""
 . F  S IEN=$O(^ISI(FILE,"C",ACTIVE,IEN)) Q:'IEN!$D(ERR)  D
 . . S CNT=CNT+1
 . . D GETONE^ISINU009(.ISIRY,CNT,FILE,FIELDS,IEN)
 . . I $D(ISIRY(0)) S ERR=ISIRY(0) Q  ; Check for error and quit if we have one
 . . Q
 . Q
 E  D
 . D LIST^DIC(FILE,,"@;.01I",,,,,,,,"OUT","ERR")  ; get a list with all 
 . S ISII=0
 . F  S ISII=$O(OUT("DILIST","2",ISII)) Q:'ISII!$D(ERR)  D
 . . S IEN=OUT("DILIST","2",ISII)
 . . S CNT=CNT+1
 . . D GETONE^ISINU009(.ISIRY,CNT,FILE,FIELDS,IEN)
 . . I $D(ISIRY(0)) S ERR=ISIRY(0) Q  ; Check for error and quit if we have one
 . . Q
 . Q
 ;
 I $D(ERR) Q  ; Error found. ISIRY(0) is set already
 S ISIRY(0)=$$SETOKVAL^ISINU002(CNT)
 S ISIRY(1)="IEN"
 S ISII=""
 F  S ISII=$O(FLDSARR(ISII)) Q:ISII=""  S ISIRY(1)=ISIRY(1)_RESDEL_FLDSARR(ISII)
 Q
