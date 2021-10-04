ISINCF07 ;ISI/NST - RPC for form workflow file ; 18 Feb 2014 3:59 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
 ;***** Returns a record in ISI FORM WORKFLOW file (#9999910.101) by IEN
 ;       
 ; RPC: ISIN GET FORM WORKFLOW
 ;
 ; Input Parameters
 ; ================
 ;  
 ;  ISIPARAM("IEN") = IEN in ISI FORM WORKFLOW file (#9999910.101)
 ;
 ; Return Values
 ; =============
 ; if error ISIRY(0) = Failure status ^ Error message
 ; if success ISIRY(0) = Success status ^^Number of lines
 ;            ISIRY(1..n) = The form workflow
 ;            
GCWFLOW(ISIRY,ISIPARAM) ; RPC [ISIN GET FORM WORKFLOW]
 N IEN,FILE
 ;
 K ISIRY
 S IEN=ISIPARAM("IEN")
 S FILE=9999910.101
 D GRECBYPK^ISINU003(.ISIRY,FILE,IEN)
 Q
