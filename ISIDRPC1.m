ISIDRPC1 ;ISI/BT - ISI DICOM Gateway RPCs ; 01/20/2016 11:02 AM
 ;;1.0;DICOM UPDATE;**local**;01-January-2016;Build 1
 QUIT
 ;
 ; ##### Get Patient English Name
 ; 
 ; INPUT
 ;   DFN       Patient DFN
 ;
 ; OUTPUT
 ;   OUT       Return Patient English Name
 ;
ENGPAT(OUT,DFN) ;RPC [ISI GET PATIENT ENGLISH NAME]
 N PATNAM S PATNAM=$$GET1^DIQ(2,DFN,".01")
 S OUT=$$ENGPAT^MAG7RS(DFN,PATNAM)
 QUIT
