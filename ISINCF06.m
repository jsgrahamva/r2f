ISINCF06 ;ISI/NST - RPC for ISI FORM WORFLOW file ; 18 Feb 2014 3:59 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
 ;*****  Update a record in ISI FORM WORKFLOW file (#9999910.101)
 ;       
 ; RPC: ISIN UPDATE FORM WORKFLOW
 ; 
 ; Input Parameters
 ; ================
 ; 
 ; ISIPARAM("IEN")
 ; ISIPARAM("TITLE")
 ; ISIPARAM("REQUIRES TIU NOTE")
 ; ISIPARAM("STORE AS GROUP")
 ; ISIPARAM("ACTIVE")
 ; ISIPARAM("FORM") = "^" delimited forms IENs in ISI FORM file (#9999910)
 ; 
 ; Return Values
 ; =============
 ; if error ISIRY(0) = Failure status ^ Error message^
 ; if success ISIRY(0) = Success status ^^Number of lines
 ;            ISIRY(1..n) = The form workflow
 ;
UPDWFLOW(ISIRY,ISIPARAM) ; RPC [ISIN UPDATE FORM WORKFLOW]
 N ISIFIELDS,ISIWP,FILE,CFORMS
 ;
 K ISIRY
 S FILE=9999910.101
 ; Make sure CREATED DATE/TIME and CREATED BY are not altered
 K ISIPARAM("CREATED BY")
 K ISIPARAM("CREATED DATE/TIME")
 ;
 S ISIPARAM("UPDATED DATE/TIME")=$$NOW^XLFDT
 S ISIPARAM("UPDATED BY")=DUZ
 ;
 S:$D(ISIPARAM("FORM")) CFORMS=ISIPARAM("FORM")
 K ISIPARAM("FORM")
 ;
 ; Update the record
 D UPDRCD^ISINU008(.ISIRY,FILE,.ISIPARAM,.ISIWP)
 I '$$ISOK^ISINU002(ISIRY) Q  ; Check for error and quit if we have one
 I $D(CFORMS) D
 . D UPDLIST^ISINU010(.ISIRY,FILE,"FORM",ISIPARAM("IEN"),CFORMS)
 . Q
 I '$$ISOK^ISINU002(ISIRY) Q  ; Check for error and quit if we have one
 ; 
 D GRECBYPK^ISINU003(.ISIRY,FILE,ISIPARAM("IEN"))
 Q
