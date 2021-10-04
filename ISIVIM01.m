ISIVIM01 ;ISI/NST - Utilities for RPC calls for work itmes ; 17 Sep 2015 9:54 AM
 ;;1.0;ISI;**local**;Mar 19, 2002;Build 23;May 01, 2013
 Q
 ;
 ; RPC: ISIV FIND WORK ITEM
FIND(OUT,TYPE,SUBTYPE,STATUS,PLACEID,PRIORITY,STOPTAG,MAXROWS,TAGS,LASTIEN) ; Find records with given attributes - return ID
 ; Copy from FIND^MAGVIM01 - added LASTIEN input parameter
 ;PLACEID is FILE #4's STATION NUMBER
 N IEN,IEN2,J,TAGMATCH,SSEP,ISEP,TAG,WICOUNT,FLD
 N VALUE,FLDS,AFLD,NOMATCH,IENS,MAGOUT,LOCIEN
 S SSEP=$$STATSEP,ISEP=$$INPUTSEP
 ;
 I $G(MAXROWS)'="",'(MAXROWS?1N.N) S OUT=-2_SSEP_"Invalid MAXROWS parameter provided" Q
 ;
 I $G(PLACEID)'="" D  Q:$G(OUT)<0
 . S LOCIEN=$$IEN^XUAF4(PLACEID) ;IA #2171 Get Institution IEN for a station number
 . I LOCIEN="" S OUT=-2_SSEP_"Invalid PLACEID parameter provided"
 . Q
 ;
 S OUT(0)=0
 ; AFLD(FLD,"IE") = compare the external or internal value of the field
 S FLDS=""
 I $G(TYPE)'="" S FLDS=FLDS_"1;",AFLD(1)=TYPE,AFLD(1,"IE")="E"
 I $G(SUBTYPE)'="" S FLDS=FLDS_"2;",AFLD(2)=SUBTYPE,AFLD(2,"IE")="E"
 I $G(STATUS)'="" S FLDS=FLDS_"3;",AFLD(3)=STATUS,AFLD(3,"IE")="E"
 I $G(LOCIEN)'="" S FLDS=FLDS_"4;",AFLD(4)=LOCIEN,AFLD(4,"IE")="I"
 I $G(PRIORITY)'="" S FLDS=FLDS_"5;",AFLD(5)=PRIORITY,AFLD(5,"IE")="E"
 ;
 K ERR
 S IEN=$G(LASTIEN,0),WICOUNT=0
 F  S IEN=$O(^MAGV(2006.941,IEN)) Q:(+IEN=0)!($D(ERR))!((($G(MAXROWS)'="")&($G(MAXROWS)<=WICOUNT)))  D
 . S IENS=IEN_","
 . K ERR
 . D GETS^DIQ(2006.941,IENS,FLDS,"IE","MAGOUT","ERR")
 . I $D(ERR) K OUT S OUT(0)=-1_SSEP_$G(ERR("DIERR",1,"TEXT",1)) Q  ; Set Error and quit
 . S FLD=""
 . S NOMATCH=0
 . F  S FLD=$O(AFLD(FLD)) Q:FLD=""!NOMATCH  D
 . . S:AFLD(FLD)'=MAGOUT("2006.941",IENS,FLD,AFLD(FLD,"IE")) NOMATCH=1
 . . Q
 . Q:NOMATCH  ; get next one if no match
 . ; Tag matching
 . S J=0,TAGMATCH=1
 . F  S J=$O(TAGS(J)) Q:J=""  D
 . . S TAG=$P(TAGS(J),ISEP,1),VALUE=$P(TAGS(J),ISEP,2)
 . . I '$D(^MAGV(2006.941,"H",TAG,IEN)) S TAGMATCH=0 Q
 . . S IEN2=$O(^MAGV(2006.941,"H",TAG,IEN,""))
 . . I $P($G(^MAGV(2006.941,IEN,4,IEN2,0)),U,2)'=VALUE S TAGMATCH=0
 . . Q
 . I 'TAGMATCH Q
 . ; Add work item header to output array
 . D GETWI^MAGVIM09(.OUT,IEN,$G(STOPTAG))  ; Get Work Item Record
 . I +OUT(0)<0 S ERR=""  ; Check for error and set ERR to quit from the loop
 . S WICOUNT=WICOUNT+1
 . Q
 Q
 ;
 ;*****  Returns all of the data elements for a single entry in the MAG WORK ITEM file (#2006.941)
 ;       
 ; RPC:ISIV PEEK WORK ITEM
 ; 
 ; Input Parameters
 ; ================
 ; 
 ; ID - IEN in MAG WORK ITEM file (#2006.941)
 ; 
 ; Return Values
 ; =============
 ; "0" for success.
 ; "-1" followed by an error message is returned if an error has occurred.
 ; A successful look up will return all data elements filed for the entry.
 ; 
PEEKITEM(OUT,ID) ; Find work item with matching ID and return it
 N SSEP
 S SSEP=$$STATSEP
 K OUT
 I $G(ID)="" S OUT(0)=-1_SSEP_"No work item ID provided" Q
 I '$D(^MAGV(2006.941,ID)) S OUT(0)=-5_SSEP_"No work item with matching ID provided" Q
 S OUT(0)=0
 D GETWI^MAGVIM09(.OUT,ID)  ; Get Work Item Record
 Q
 ;
FNDITEMS(OUT,ATAG) ;Find Work Items by TAG and VALUE
 ; OUT(0) - 1 ^ list count
 ; OUT(1..n)= Work Item IEN
 ;
 N II,IEN,TAG,VALUE,WITEMS
 S TAG=""
 ;
 K OUT
 F  S TAG=$O(ATAG(TAG)) Q:TAG=""  D
 . S VALUE=ATAG(TAG)
 . S IEN=""
 . K MATCH
 . F  S IEN=$O(^MAGV(2006.941,"HH",TAG,VALUE,IEN)) Q:IEN=""  S MATCH(IEN)=""
 . D CROSLIST(.WITEMS,.MATCH)
 . Q
 ;
 S II=0
 S IEN=""
 F  S IEN=$O(WITEMS(IEN)) Q:IEN=""  D
 . S II=II+1,OUT(II)=IEN
 . Q
 S OUT(0)="1^"_II
 Q
 ;
CROSLIST(TARGET,NEWLIST) ; cross check of two list
 ; TARGET - the output result of cross-checking of two list
 ; NEWLIST - list of values
 N RESULT,II
 I $O(TARGET(""))="" M TARGET=NEWLIST Q  ; TARGET is empty. Return the whole NEWLIST
 S II=""
 F  S II=$O(TARGET(II)) Q:II'=""  D
 . I $D(NEWLIST(II)) S RESULT(II)=""
 Q
 M TARGET=RESULT
 Q 
 ;
OUTSEP() ; Name value separator for output data ie. NAME|TESTPATIENT
 Q "|"
STATSEP() ; Status and result separator ie. -3``No record IEN
 Q "`"
INPUTSEP() ; Name value separator for input data ie. NAME`TESTPATIENT
 Q "`"
