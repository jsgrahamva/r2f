ISINCF03 ;ISI/NST -RPC for ISI FORM file ; 08 Jan 2014 3:59 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
 ;*****  Returns a record in ISI FORM file (#9999910) by IEN
 ;       
 ; RPC: ISIN GET FORM BY IEN
 ;
 ; Input Parameters
 ; ================
 ;  
 ;  ISIPARAM("IEN") = IEN in ISI FORM file (#9999910)
 ;
 ; Return Values
 ; =============
 ; if error ISIRY(0) = Failure status ^ Error message
 ; if success ISIRY(0) = Success status ^^Number of lines
 ;            ISIRY(1..n) = The form
 ;            
GETFORM(ISIRY,ISIPARAM) ; RPC [ISIN GET FORM BY IEN]
 N IEN,FILE
 ;
 K ISIRY
 S IEN=ISIPARAM("IEN")
 S FILE=9999910
 D GRECBYPK^ISINU003(.ISIRY,FILE,IEN)
 Q
