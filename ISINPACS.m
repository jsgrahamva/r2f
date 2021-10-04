ISINPACS ;ISI/NST - RPC for PACS ; 02 Dec 2014 3:59 PM
 ;;1.0;ISI;**local**;Mar 19, 2002;Build 4525;May 01, 2013
 ;;
 Q
 ;
 ;*****  Get the PACS list from ISI PACS file (#9999910.111)
 ;       
 ; RPC:ISI LIST PACS
 ; 
 ; Input Parameters
 ; ================
 ; 
 ; [DFN] - not in use
 ; [HEADER] - 1 (default) for include header
 ; [ENABLED] - 0 for disabled, 1 for enabled, 2 for all 
 ; 
 ; Return Values
 ; =============
 ; if error ISIRY(0) = Failure status ^Error message^
 ; if success ISIRY(0) = Success status ^^Count or records
 ;            ISIRY(1..n) = PACS ID ^ PACS Name
 ; The header is excluded if it is not requested 
 ; 
LIST(ISIRY,DFN,HEADER,ENABLED) ; RPC [ISIN LIST PACS]
 N IEN,ISITMP
 N RESDEL
 N ISII,CNT,FILE,FIELDS,FLDSARR,FLDSARRW,ERR,OUT
 K ISIRY
 ;
 S RESDEL=$$RESDEL^ISINU002()  ; Result delimiter
 S FILE=9999910.111
 S FIELDS=$$GETFLDS^ISINU001(.FLDSARR,.FLDSARRW,FILE,"")
 ;
 S ENABLED=$G(ENABLED,1)
 S HEADER=$G(HEADER,1)
 S CNT=$S(HEADER:1,1:0)  ; set the starting counter
 I (ENABLED=0)!(ENABLED=1) D  ; Use ENABLED index to get records
 . S IEN=""
 . F  S IEN=$O(^ISI(FILE,"C",ENABLED,IEN)) Q:'IEN!$D(ERR)  D
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
 ; 
 S ISII=""
 F  S ISII=$O(ISIRY(ISII)) Q:ISII=""  D
 . S ISITMP(ISII)=$P(ISIRY(ISII),RESDEL,4)_RESDEL_$P(ISIRY(ISII),RESDEL,2)_RESDEL_RESDEL_RESDEL  ; PACS ID ^ PACS NAME
 . Q
 K ISIRY
 M ISIRY=ISITMP
 ;
 I HEADER D 
 . ;S ISIRY(0)=$$SETOKVAL^ISINU002(CNT)
 . ;S ISIRY(1)="IEN"
 . ;S ISII=""
 . ;F  S ISII=$O(FLDSARR(ISII)) Q:ISII=""  S ISIRY(1)=ISIRY(1)_RESDEL_FLDSARR(ISII)
 . S ISIRY(0)=1_RESDEL_(CNT-1)_"~Treating facilities returned"
 . Q
 Q
