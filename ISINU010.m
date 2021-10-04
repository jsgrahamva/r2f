ISINU010 ;ISI/NST - Utilities for RPC calls ; 18 Feb 2014 4:16 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
 ; +++++++++++++++++++++++
 ; Add a list to a file
 ;
 ; Input parameters
 ; ================
 ; FILE - Sub-file number
 ; IEN  - IEN in the sub-file  
 ; PLIST = "^" delimited string with IENs
 ;   
 ; Result values
 ; ===============
 ; if failed ISIRY = Failure status ^ Error message
 ; if success ISIRY = Success status ^  ^ IEN
 ;
ADDLIST(ISIRY,FILE,IEN,PLIST) ; Add a list to a muliple field in a file
 N ISIFDA,ISIERR,ITEM,ISII
 S ISIRY=""
 ; insert the new multiples
 F ISII=1:1 S ITEM=$P(PLIST,"^",ISII) Q:(ITEM="")!(ISIRY'="")  D
 . K ISIFDA,ISIERR
 . S ISIFDA(FILE,"+1,"_IEN_",",.01)=ITEM
 . D UPDATE^DIE("","ISIFDA","","ISIERR")
 . I $D(ISIERR("DIERR","E")) S ISIRY=$$SETERROR^ISINU002("Error adding an item ["_ITEM_"] to list")
 . Q
 Q:ISIRY'=""
 ;
 S ISIRY=$$SETOKVAL^ISINU002(IEN)
 Q
 ;
 ; +++++++++++++++++++++++
 ; Update a list in a file
 ;
 ; Input parameters
 ; ================
 ; FILE  - FileMan file number
 ; FIELD - Multiple field
 ; IEN   - IEN in the sub-file
 ; PLIST - "^" delimited string with IENs
 ;   
 ; Result values
 ; ===============
 ; if failed ISIRY = Failure status ^ Error message
 ; if success ISIRY = Success status ^  ^ IEN
 ;
UPDLIST(ISIRY,FILE,FIELD,IEN,PLIST) ; Update a list in a muliple field in a file
 N DA,DIK,OUT,ISIFDA,ISIERR,ISIRESA,ISII,SUBFILE
 K ISIRY
 ;
 S SUBFILE=$$GSUBFILE^ISINU001(FILE,FIELD)
 D LIST^DIC(SUBFILE,","_IEN_",","@;.01I","",,,,,,,"OUT","ISIERR")
 I $D(ISIERR("DIERR","E")) D  Q
 . D MSG^DIALOG("A",.ISIRESA,245,5,"ISIERR")
 . S ISIRY=$$SETERROR^ISINU002("Error getting list: "_ISIRESA(1))
 . Q
 ; delete multiple
 S DA(1)=IEN  ; set the variables so we can perform deletion of multiple
 S DIK=$$GSUBROOT^ISINU001(FILE,FIELD,IEN)
 ;
 S ISII=0
 F  S ISII=$O(OUT("DILIST","ID",ISII)) Q:'ISII  D
 . S DA=OUT("DILIST","2",ISII)
 . D ^DIK
 . Q 
 D ADDLIST(.ISIRY,SUBFILE,IEN,PLIST)
 Q
