ISIIP101 ;ISI/NST,BT - Install code for ISI Regional Storage ;  10 Aug 2016 5:02 PM
 ;;1.0;ISI;**local**;Mar 19, 2002;Build 24;Apr 01, 2013
 ;;
 ; There are no environment checks here but the ISIIP101 has to be
 ; referenced by the "Environment Check Routine" field of the KIDS
 ; build so that entry points of the routine are available to the
 ; KIDS during all installation phases.
 Q
 ;
 ;+++++ INSTALLATION ERROR HANDLING
ERROR ;
 S:$D(XPDNM) XPDABORT=1
 ;--- Display the messages and store them to the INSTALL file
 D DUMP^MAGUERR1(),ABTMSG^MAGKIDS()
 Q
 ;
 ;***** POST-INSTALL CODE
POS ;
 N CALLBACK
 D CLEAR^MAGUERR(1)
 ;
 ;--- Link new remote procedures to the Broker context option.
 S X=$$ADDRPCS("RPCLST^ISIIP101","MAG WINDOWS")
 ; 
 S X=$$ADDRPCS("RPCLSTCF^ISIIP101","ISI FORM")
 ;
 S X=$$ADDRPCS("RPCMAGJ^ISIIP101","MAGJ VISTARAD WINDOWS")
 ;
 S X=$$UPDATE()
 ;
 ;--- Send the notification e-mail
 D BMES^XPDUTL("Post Install Mail Message: "_$$FMTE^XLFDT($$NOW^XLFDT))
 ; TODO do we need email D INS^MAGQBUT4(XPDNM,DUZ,$$NOW^XLFDT,XPDA)
 Q
 ;
 ;***** PRE-INSTALL CODE
PRE ;
 ;
 Q
 ;
 ;+++++ LIST OF NEW REMOTE PROCEDURES
 ; have a list in format ;;ISI RPS NAME
RPCLST ;
 ;;ISI DICOM INCORRECT STUDIES
 ;;ISI DICOM STUDIES ALERTED
 ;;ISI DICOM GET BASIC IMAGE
 ;;ISI GET ADDITIONAL INFO
 ;;ISI GET PATIENT ENGLISH NAME
 ;;ISIV FIND WORK ITEM
 ;;ISIV FIND WORK ITEMS BY TAGS
 ;;ISIV PEEK WORK ITEM
 ;;ISIN LIST PACS
 ;;ISIN PARAM GET LIST
 ;;ISIN PARAM GET VALUE
 ;;ISIN PARAM SET LIST
 ;;MAG GET NETLOC
 ;;MAG DOD GET STUDIES IEN
 ;;MAG STORAGE FETCH SET
 ;;MAGV ADD WORK ITEM TAGS
 ;;MAGV CREATE WORK ITEM
 ;;MAGV DELETE WORK ITEM
 ;;MAGV FIND WORK ITEM
 ;;MAGV GET NEXT WORK ITEM
 ;;MAGV GET WORK ITEM
 ;;MAGV UPDATE WORK ITEM
 ;;MAGV WORK ITEMS COUNT 
 Q 0
 ;
RPCLSTCF ;
 ;;DG CHK PAT/DIV MEANS TEST
 ;;DG SENSITIVE RECORD ACCESS
 ;;DG SENSITIVE RECORD BULLETIN
 ;;GMRC LIST CONSULT REQUESTS
 ;;ISI DICOM GET BASIC IMAGE
 ;;ISI GET ADDITIONAL INFO
 ;;ISI GET PATIENT ENGLISH NAME
 ;;ISIN CREATE FORM
 ;;ISIN CREATE FORM WORKFLOW
 ;;ISIN GET FORM BY IEN
 ;;ISIN GET FORM BY IMAGE
 ;;ISIN GET FORM WORKFLOW
 ;;ISIN LINK FORM IMAGE
 ;;ISIN LIST FORM
 ;;ISIN LIST FORM BY DFN
 ;;ISIN LIST FORM WORKFLOW
 ;;ISIN UPDATE FORM
 ;;ISIN UPDATE FORM WORKFLOW
 ;;ISIN USER KEYS
 ;;MAG ABSJB
 ;;MAG GET NETLOC 
 ;;MAG IMAGE CURRENT INFO
 ;;MAG STORAGE FETCH SET
 ;;MAG3 LOOKUP ANY
 ;;MAG3 TIU CREATE ADDENDUM
 ;;MAG3 TIU IMAGE
 ;;MAG3 TIU LONG LIST OF TITLES
 ;;MAG3 TIU MODIFY NOTE
 ;;MAG3 TIU NEW
 ;;MAG4 ADD IMAGE
 ;;MAG4 IMAGE LIST
 ;;MAG4 INDEX GET EVENT
 ;;MAG4 INDEX GET ORIGIN
 ;;MAG4 INDEX GET SPECIALTY
 ;;MAG4 INDEX GET TYPE
 ;;MAG4 PAT GET IMAGES
 ;;MAG4 POST PROCESS ACTIONS
 ;;MAGG GROUP IMAGES
 ;;MAGG IMAGE DELETE
 ;;MAGG INSTALL
 ;;MAGG IS DOC CLASS
 ;;MAGG PAT FIND
 ;;MAGG PAT INFO
 ;;MAGG PAT PHOTOS
 ;;MAGG VERIFY ESIG
 ;;MAGGUSER2
 ;;TIU DOCUMENTS BY CONTEXT
 ;;TIU GET RECORD TEXT
 ;;TIU IS THIS A CONSULT?
 ;;XWB GET VARIABLE VALUE
 Q 0
 ;
RPCMAGJ ;
 ;;ISI GET PATIENT ENGLISH NAME
 ;;ISI GET ADDITIONAL INFO
 ;;ISI GET RAD STANDARD REPORTS
 ;;ISI GET RAD STANDARD TEXT
 ;;ISIV FIND WORK ITEMS BY TAGS
 ;;ISIN LIST PACS
 Q 0
 ;
 ;+++++ Various updates
UPDATE() ;
 ;
 ; Add "Process" to MAG WORK ITEM SUBTYPE file
 N ITEM,ITEMS,ISII,CNT,MAGERR,MAGFDA,MSG
 ;
 K MAGFDA,MAGERR
 S ITEM="Process"
 I '$O(^MAGV(2006.9414,"B",ITEM,0)) D
 . S MAGFDA(2006.9414,"+1,",.01)=ITEM
 . D UPDATE^DIE("","MAGFDA","","MAGERR")
 . Q
 I $D(MAGERR) S MSG(1)=MAGERR("DIERR",1,"TEXT",1) D BMES^MAGKIDS("Error in Updating: ",.MSG) Q 0  ;ERROR
 ;
 ; Add "Storage" to WORKLIST file
 K MAGFDA,MAGERR
 S ITEM="Storage"
 I '$O(^MAGV(2006.9412,"B",ITEM,0)) D
 . S MAGFDA(2006.9412,"+1,",.01)=ITEM
 . S MAGFDA(2006.9412,"+1,",1)=1 ;ACTIVE
 . D UPDATE^DIE("","MAGFDA","","MAGERR")
 . Q
 I $D(MAGERR) S MSG(1)=MAGERR("DIERR",1,"TEXT",1) D BMES^MAGKIDS("Error in Updating: ",.MSG) Q 0  ;ERROR
 ;
 ; Add the following to MAG WORK ITEM STATUS file
 K ITEM
 S CNT=0
 S CNT=CNT+1,ITEMS(CNT)="New"
 S CNT=CNT+1,ITEMS(CNT)="RetrievingLocalStudy"
 S CNT=CNT+1,ITEMS(CNT)="LocalCopyCached"
 S CNT=CNT+1,ITEMS(CNT)="StoringRegionally"
 S CNT=CNT+1,ITEMS(CNT)="StoredRegionally"
 S CNT=CNT+1,ITEMS(CNT)="DeletingLocalCopy"
 S CNT=CNT+1,ITEMS(CNT)="CompleteSuccessful"
 S CNT=CNT+1,ITEMS(CNT)="CancelledRegionalStorage"
 S CNT=CNT+1,ITEMS(CNT)="CompletedUnsuccessfully"
 S CNT=CNT+1,ITEMS(CNT)="ErrorRegionalStorage"
 ;
 F ISII=1:1:CNT D 
 . S ITEM=ITEMS(ISII)
 . I '$O(^MAGV(2006.9413,"B",ITEM,0)) D
 . . K MAGFDA,MAGERR
 . . S MAGFDA(2006.9413,"+1,",.01)=ITEM 
 . . D UPDATE^DIE("","MAGFDA","","MAGERR")
 . . Q
 . I $D(MAGERR) S MSG(1)=MAGERR("DIERR",1,"TEXT",1) D BMES^MAGKIDS("Error in Updating: ",.MSG) Q  ;ERROR
 . Q
 ; reindex cross-reference "C" in MAG WORK ITEM file (#2006.941)
 N DIK
 L +^MAGV(2006.941):1999999
 S DIK="^MAGV(2006.941,"
 K ^MAGV(2006.941,"B")
 K ^MAGV(2006.941,"C") 
 K ^MAGV(2006.941,"H")
 K ^MAGV(2006.941,"HH") 
 K ^MAGV(2006.941,"T") 
 D IXALL^DIK
 L -^MAGV(2006.941)
 ;
 ; MAG Filter cleanup - issue found in FMC Jordan
 D FILTER
 ;
 Q 0
 ;
ADDRPCS(RPCNAMES,OPTNAME,FLAGS) ;
 N IENS,MAGFDA,MAGMSG,MAGRC,NAME,OPTIEN,RPCIEN,SILENT
 ;
 ;=== Validate and prepare parameters
 S FLAGS=$G(FLAGS),SILENT=(FLAGS["S")
 ;--- Single RPC name or a list?
 I $D(RPCNAMES)<10  Q:$G(RPCNAMES)?." " $$IPVE^MAGUERR("RPCNAMES")  D
 . N I,GET
 . ;--- Get the list from the source code
 . S GET=$P(RPCNAMES,"^")_"+I^"_$P(RPCNAMES,"^",2)
 . S GET="S NAME=$$TRIM^XLFSTR($P($T("_GET_"),"";;"",2))"
 . F I=1:1  X GET  Q:NAME=""  S RPCNAMES(NAME)=""
 . Q
 ;--- Name of the menu option (RPC Broker context)
 S OPTIEN=$$LKOPT^XPDMENU(OPTNAME)
 Q:OPTIEN'>0 $$ERROR^MAGUERR(-44,,OPTNAME)
 ;
 ;=== Add the names to the multiple
 D:'SILENT BMES^MAGKIDS("Attaching RPCs to the '"_OPTNAME_"' option...")
 S NAME="",MAGRC=0
 F  S NAME=$O(RPCNAMES(NAME))  Q:NAME=""  D  Q:MAGRC<0
 . D:'SILENT MES^MAGKIDS(NAME)
 . ;--- Check if the remote procedure exists
 . S RPCIEN=$$FIND1^DIC(8994,,"X",NAME,"B",,"MAGMSG")
 . I $G(DIERR)  S MAGRC=$$DBS^MAGUERR("MAGMSG",8994)  Q
 . I RPCIEN'>0  S MAGRC=$$ERROR^MAGUERR(-45,,NAME)  Q
 . ;--- Add the remote procedure to the multiple
 . S IENS="?+1,"_OPTIEN_","
 . S MAGFDA(19.05,IENS,.01)=RPCIEN
 . D UPDATE^DIE(,"MAGFDA",,"MAGMSG")
 . I $G(DIERR)  S MAGRC=$$DBS^MAGUERR("MAGMSG",19.05,IENS)  Q
 . ;---
 . Q
 I MAGRC<0  D:'SILENT MES^MAGKIDS("ABORTED!")  Q MAGRC
 ;
 ;=== Success
 D:'SILENT MES^MAGKIDS("RPCs have been successfully attached.")
 Q 0
 ; 
FILTER ; MAG Filter clean up
 N IEN,FDA,ISINIEN,ISIERR
 S IEN=0
 F  S IEN=$O(^MAG(2005.87,IEN)) Q:'IEN  D
 . Q:$P(^MAG(2005.87,IEN,1),"^",2)'=1  ; not a public filter
 . Q:$P(^MAG(2005.87,IEN,1),"^",1)=""  ; User field is blank
 . K FDA
 . S FDA(2005.87,IEN_",",20)="@"
 . D UPDATE^DIE("","FDA","ISINIEN","ISIERR")
 . Q
 Q
