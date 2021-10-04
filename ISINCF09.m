ISINCF09 ;ISI/NST - RPC for form workflow file ; 21 Feb 2014 3:59 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
 ;***** Link form image
 ;       
 ; RPC: ISIN LINK FORM IMAGE
 ;
 ; Input Parameters
 ; ================
 ;  
 ; ISIPARAM("IMAGE") = IEN in IMAGE file (#2005)
 ; ISIPARAM("FORM") = IEN in ISI FORM file (#9999910)
 ;
 ; Return Values
 ; =============
 ; if error ISIRY = Failure status ^ Error message
 ; if success ISIRY = Success status ^^IEN in ISI FORM IMAGE file (#9999910.102)
 ;            
LINKIMG(ISIRY,ISIPARAM) ; RPC [ISIN LINK FORM IMAGE]
 N ISIWP,DFN
 ;
 S DFN=$$GET1^DIQ(2005,$G(ISIPARAM("IMAGE")),5,"I") ; get patient DFN
 S ISIPARAM("PATIENT")=DFN
 ;  
 D ADDRCD^ISINU004(.ISIRY,9999910.102,.ISIPARAM,.ISIWP)
 Q
 ;
 ;***** Get a form by image
 ;       
 ; RPC: ISIN GET FORM BY IMAGE
 ;
 ; Input Parameters
 ; ================
 ;  
 ; ISIPARAM("IMAGE") = IEN in IMAGE file (#2005)
 ;
 ; Return Values
 ; =============
 ; if error ISIRY(0) = Failure status ^ Error message
 ; if success ISIRY(0) = Success status ^^Number of lines
 ;            ISIRY(1..n) = The form
 ;            
GCFBYIMG(ISIRY,ISIPARAM) ; RPC [ISIN GET FORM BY IMAGE]
 N PAR,FILE,IEN
 ;
 K ISIRY
 S FILE=9999910.102
 I $G(ISIPARAM("IMAGE"))="" S ISIRY(0)=$$SETERROR^ISINU002("[IMAGE] value is required") Q 
 S IEN=$O(^ISI(FILE,"B",ISIPARAM("IMAGE"),""))  ; get form IEN for the image
 I IEN="" S ISIRY(0)=$$SETERROR^ISINU002("[IMAGE="_ISIPARAM("IMAGE")_"] is not found in ISI FORM IMAGE file (#"_FILE_").") Q
 S PAR("IEN")=IEN
 D GETFORM^ISINCF03(.ISIRY,.PAR)
 Q
 ;
 ;***** List form by patient
 ;       
 ; RPC: ISIN LIST FORM BY DFN
 ;
 ; Input Parameters
 ; ================
 ;  
 ; ISIPARAM("PATIENT") = Patient ID (DFN)
 ;
 ; Return Values
 ; =============
 ; if error ISIRY(0) = Failure status ^ Error message
 ; if success ISIRY(0) = Success status ^^Number of lines
 ;            ISIRY(1) = IMAGE ^ FORM
 ;            ISIRY(2..n) = image IEN ^ form IEN
 ;            
LCFBYDFN(ISIRY,ISIPARAM) ; RPC [ISIN LIST FORM BY DFN]
 N RESDEL,IEN,CNT,FILE,DFN
 ;
 K ISIRY
 ;
 S DFN=$G(ISIPARAM("PATIENT"))
 I 'DFN S ISIRY(0)=$$SETERROR^ISINU002("[PATIENT] value is required") Q 
 ;
 S RESDEL=$$RESDEL^ISINU002()  ; Result delimiter
 S FILE=9999910.102
 ;
 S CNT=1
 ;
 S IEN=""
 F  S IEN=$O(^ISI(FILE,"C",DFN,IEN))  Q:'IEN  D
 . S CNT=CNT+1,ISIRY(CNT)=$$GET1^DIQ(FILE,IEN,.01,"I")_RESDEL_$$GET1^DIQ(FILE,IEN,2,"I") 
 . Q
 ;
 S ISIRY(0)=$$SETOKVAL^ISINU002(CNT-1)
 S ISIRY(1)="IMAGE"_RESDEL_"FORM"
 Q
