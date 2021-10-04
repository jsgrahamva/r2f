ISINU005 ;ISI/NST - Misc utilities ; 18 Feb 2014 4:16 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
STRWP(WP) ; Return WP field value as a string
 N I,RESULT
 S I=""
 S RESULT=""
 F  S I=$O(WP(I)) Q:I=""  D 
 . S RESULT=RESULT_WP(I)
 . Q
 Q RESULT
 ;
 ; WP field value is blank
 ; Return 1 - WP field value is blank
 ;        0
 ; WP = Word-Processing field values
 ; e.g. WP(1)=Line 1
 ;      WP(2)=Line 2
 ;      
WPEMPTY(WP) ; Return 1 when WP field value is blank
 N I,RESULT
 S I=""
 S RESULT=1
 F  S I=$O(WP(I)) Q:I=""!'RESULT  D 
 . S RESULT=$L(WP(I))=0
 . Q
 Q RESULT
 ;
 ;
TRANS(ISIWP,ISIPARAM,FIELD) ; Create a array from 
 ; Input Values
 ; ============
 ; ISIPARAM - input array
 ; FIELD    - array with a node field name
 ; e.g.,
 ; ISIPARAM("XML001")="line 1"
 ; ISIPARAM("XML002")="line 2"
 ; ISIPARAM("XML003")="line 3"
 ; FIELD("XML")=""
 ;
 ; Return Value
 ; ============
 ; ISIWP    - added records from ISIPARAM
 ; ISIPARAM - removed records array
 ; e.g.,
 ; ISIWP("FLD",1)="Line 1"
 ; ISIWP("FLD",2)="Line 2"
 ; ISIWP("FLD",3)="Line 3"
 ;  
 N L,LL,LEN,FLD,ISITEMP
 S FLD=""
 F  S FLD=$O(FIELD(FLD)) Q:FLD=""  D
 . S LEN=$L(FLD)
 . S L=FLD
 . S LL=0
 . F  S L=$O(ISIPARAM(L)) Q:(L="")!($E(L,1,LEN)'=FLD)  S LL=LL+1,ISIWP(FLD,LL)=ISIPARAM(L) K ISIPARAM(L)
 . Q
 Q
