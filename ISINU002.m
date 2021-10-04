ISINU002 ;ISI/NST - Utilities for RPC calls ; 19 Feb 2014 4:16 PM
 ;;1.0;ISI;**CF**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
OK() Q 0   ; Success status
 ;
FAILED() Q -1   ; Failure status
 ;
RESDEL() Q "^"  ; Result delimiter
 ;
RESDATA() Q 3  ; Returns the piece number where the result data value is stored in ISIRY
 ;
ISOK(ISIRY) ; Returns 0 (failed) or 1 (success): Checks if first piece of ISIRY is success
 Q +ISIRY=$$OK()
 ;
GETVAL(ISIRY) ; Returns data value in ISIRY
 Q $P(ISIRY,$$RESDEL(),$$RESDATA())
 ;
SETVAL(ISIRY,VAL) ; set VAL in RY data piece
 S $P(ISIRY,$$RESDEL(),$$RESDATA())=VAL
 Q
 ;
SETOKVAL(VAL) ; set OK result and value
 N RY
 S RY=$$OK()
 D SETVAL(.RY,VAL)
 Q RY
 ;
SETERROR(VAL) ; set Error result and value
 Q $$FAILED()_$$RESDEL()_VAL
