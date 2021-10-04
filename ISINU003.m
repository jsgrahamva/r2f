ISINU003 ;ISI/NST - Utilities for RPC calls ; 04 Mar 2016 4:16 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
 ; ****  Get a record from a file by IEN 
 ; 
 ; Input parameters
 ; ================
 ; 
 ; FILE = FileMan number of the file (e.g. 2006.913)
 ; PK = IEN in the file
 ;
 ; Return Values
 ; =============
 ; if error found during execution
 ;   ISIRY(0) = Failure status^Error getting values
 ; if success
 ;   ISIRY(0) =  Success status^^Total lines
 ;   ISIRY(1) = header with name of the fields
 ;   ISIRY(3) = "^" delimited pairs with internal and external values of the fields listed in ISIRY(1) 
 ;   ISIRY(n) = "WordProcesingFieldxxx^line value"
 ;   ISIRY(m) = "MultipleField000^fields header"
 ;   ISIRY(m..m+1) = "MultipleField001^fields values listed in ISIRY(m)" 
 ;   
GRECBYPK(ISIRY,FILE,PK) ;
 N FIELDS,FLDSARR,FLDSARRW
 N OUT,ERR,ISIRESA,TMPOUT,IENS
 N J,CNT,WPTYPE,SUBFILE
 N RESDEL
 K ISIRY
 S RESDEL=$$RESDEL^ISINU002()
 S FIELDS=$$GETFLDS^ISINU001(.FLDSARR,.FLDSARRW,FILE,"") ; file fields names
 S IENS=PK_","
 D GETS^DIQ(FILE,PK_",","**","IE","OUT","ERR")
 I $D(ERR("DIERR")) D  Q
 . D MSG^DIALOG("A",.ISIRESA,245,5,"ERR")
 . S ISIRY(0)=$$SETERROR^ISINU002("Error getting values: "_ISIRESA(1)) Q  ; Error getting the list
 . Q
 ; Output the data
 S CNT=2
 S ISIRY(CNT)=PK
 S J=""
 F  S J=$O(FLDSARR(J)) Q:J=""  D
 . S ISIRY(CNT)=ISIRY(CNT)_RESDEL_OUT(FILE,IENS,J,"I")_RESDEL_OUT(FILE,IENS,J,"E")
 . Q
 ; Now get the word-processing and multiple fields
 S J=""
 F  S J=$O(FLDSARRW(J)) Q:J=""  D
 . I $$ISFLDWP^ISINU001(.WPTYPE,FILE,J) D  Q
 . . K TMPOUT
 . . M TMPOUT=OUT(FILE,IENS,J)
 . . D WORDPROC(.ISIRY,.CNT,.TMPOUT,FLDSARRW(J))  ; get word-processing field value
 . . Q
 . ; multi field
 . D MULTI(.ISIRY,.CNT,.OUT,FILE,FLDSARRW(J))
 . Q
 ;
 ; write the header
 S ISIRY(1)="IEN"
 S I=""
 F  S I=$O(FLDSARR(I)) Q:I=""  S ISIRY(1)=ISIRY(1)_RESDEL_FLDSARR(I)
 S ISIRY(0)=$$SETOKVAL^ISINU002(CNT-1)
 Q
 ;
WORDPROC(ISIRY,CNT,WP,FLDNAME)  ; add word-processing field values to the result
 N L,RESDEL
 S RESDEL=$$RESDEL^ISINU002()
 S L=""
 F  S L=$O(WP(L)) Q:'L  D
 . S CNT=CNT+1,ISIRY(CNT)=FLDNAME_$TR($J(L,3)," ",0)_RESDEL_WP(L)
 . Q
 Q
 ;
MULTI(ISIRY,CNT,OUT,FILE,FLDNAME)  ; add word-processing field values to the result
 N IEN,J,L,RESDEL
 N SUBFILE,FIELDS,FLDSARR,FLDSARRW
 ;
 S RESDEL=$$RESDEL^ISINU002()
 S SUBFILE=$$GSUBFILE^ISINU001(FILE,FLDNAME)  ; get sub-file number
 S FIELDS=$$GETFLDS^ISINU001(.FLDSARR,.FLDSARRW,SUBFILE,"")
 ; write header of multiple record
 S CNT=CNT+1,ISIRY(CNT)=FLDNAME_"000"_RESDEL_"IEN"
 S J=""
 F  S J=$O(FLDSARR(J)) Q:J=""  S ISIRY(CNT)=ISIRY(CNT)_RESDEL_FLDSARR(J)
 ;
 ; write the values of the multiple record
 S L=""
 F  S L=$O(OUT(SUBFILE,L)) Q:L=""  D
 . S IEN=$P(L,",")  ; IEN of the mutliple record
 . S CNT=CNT+1,ISIRY(CNT)=FLDNAME_$TR($J(IEN,3)," ",0) 
 . S J=""
 . F  S J=$O(FLDSARR(J)) Q:J=""  D
 . . S ISIRY(CNT)=ISIRY(CNT)_RESDEL_OUT(SUBFILE,L,J,"I")_RESDEL_OUT(SUBFILE,L,J,"E")
 . . Q
 . Q
 Q
