ISINCF04 ;ISI/NST -RPC for ISI FORM file ; 22 Jul 2016 3:59 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
 ;*****  Update a record in ISI FORM file (#9999910)
 ;       
 ; RPC: ISIN UPDATE FORM
 ; 
 ; Input Parameters
 ; ================
 ; 
 ;   ISIPARAM("IEN")
 ;   ISIPARAM("TITLE")
 ;   ISIPARAM("ACTIVE")
 ;   ISIPARAM("PAGES")
 ;   ISIPARAM("TYPE INDEX")
 ;   ISIPARAM("PROC/EVENT INDEX")
 ;   ISIPARAM("SPEC/SUBSPEC INDEX")
 ;   ISIPARAM("ORIGIN INDEX")
 ;   ISIPARAM("SIGN AGAIN")
 ;   ISIPARAM("TIU NOTE")
 ;   ISIPARAM("TIU STATUS")
 ;   ISIPARAM("LOCATION")
 ;   ISIPARAM("DESCRIPTIONnnn")
 ;   ISIPARAM("XMLnnn")
 ;   ISIPARAM("TIU NOTE TEXTnnn")
 ;
 ; 
 ; Return Values
 ; =============
 ; if error ISIRY(0) = Failure status ^ Error message^
 ; if success ISIRY(0) = Success status ^^Number of lines
 ;            ISIRY(1..n) = The form
 ;
UPDFORM(ISIRY,ISIPARAM) ; RPC [ISIN UPDATE FORM]
 N ISIFIELDS,ISIWP,FILE
 ;
 K ISIRY
 S FILE=9999910
 ; Make sure CREATED DATE/TIME and CREATED BY are not altered
 K ISIPARAM("CREATED BY")
 K ISIPARAM("CREATED DATE/TIME")
 ;
 S ISIPARAM("UPDATED DATE/TIME")=$$NOW^XLFDT
 S ISIPARAM("UPDATED BY")=DUZ
 ;
 S ISIFIELDS("XML")=""
 S ISIFIELDS("DESCRIPTION")=""
 S ISIFIELDS("TIU NOTE TEXT")=""
 D TRANS^ISINU005(.ISIWP,.ISIPARAM,.ISIFIELDS)  ; normalize WP paramaters
 ;
 ; Update the record
 D UPDRCD^ISINU008(.ISIRY,FILE,.ISIPARAM,.ISIWP)
 I '$$ISOK^ISINU002(ISIRY) Q  ; Check for error and quit if we have one
 D GRECBYPK^ISINU003(.ISIRY,FILE,ISIPARAM("IEN"))
 Q
