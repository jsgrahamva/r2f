ISINCF05 ;ISI/NST - Add records to ISI FORM file ; 17 Feb 2014 3:59 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
 ;*****  Add a new record to ISI FORM WORKFLOW file (#9999910.101)
 ;       
 ; RPC:ISIN CREATE FORM WORKFLOW
 ; 
 ; Input Parameters
 ; ================
 ; 
 ; ISIPARAM("TITLE")
 ; ISIPARAM("REQUIRES TIU NOTE")
 ; ISIPARAM("STORE AS GROUP")
 ; ISIPARAM("FORM") = "^" delimited forms IENs in ISI FORM file (#9999910)
 ; 
 ; Return Values
 ; =============
 ; if error ISIRY = Failure status ^Error message^
 ; if success ISIRY = Success status ^^IEN - IEN of the new record 
 ; 
ADDWFLOW(ISIRY,ISIPARAM) ; RPC [ISIN CREATE FORM WORKFLOW]
 N ISIWP,ISIFIELDS,IEN,CFORMS
 N FILE,SUBFILE
 K ISIRY
 ;
 S CFORMS=$G(ISIPARAM("FORM"))
 K ISIPARAM("FORM")
 ;
 S ISIPARAM("CREATED DATE/TIME")=$$NOW^XLFDT
 S ISIPARAM("CREATED BY")=DUZ
 S ISIPARAM("ACTIVE")=1
 ;
 S FILE=9999910.101
 D ADDRCD^ISINU004(.ISIRY,FILE,.ISIPARAM,.ISIWP)
 ;
 ; Add forms to the new record
 I '$$ISOK^ISINU002(ISIRY) Q  ; Error adding the new record
 ;
 S IEN=$$GETVAL^ISINU002(ISIRY)  ; get IEN of the new record
 S SUBFILE=$$GSUBFILE^ISINU001(FILE,"FORM")
 D ADDLIST^ISINU010(.ISIRY,SUBFILE,IEN,CFORMS)
 Q
