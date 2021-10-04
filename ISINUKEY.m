ISINUKEY ;ISI/NST -RPC for form file ; 15 Jan 2014 3:59 PM
 ;;1.0;ISI;**local**;Mar 19, 2002;Build 28;May 01, 2013
 ;;
 Q
 ;
 ;*****  Get a list with user's security keys
 ;       
 ; RPC: ISIN USER KEYS
 ; 
 ; Input Parameters
 ; ================
 ; N/A
 ;
 ; Return value
 ; =============
 ; ISIK - array with user's security keys
 ; 
USERKEYS(ISIK) ; RPC [ISIN USER KEYS]
 N ISIKS ; list of keys to send to XUS KEY CHECK
 N ISIKG ; list returned from XUS KEY CHECK
 N ISII,ISIJ,X,Y,KEYPREF
 K ISIK
 S KEYPREF="ISI"
 S X=KEYPREF
 S ISII=0
 F  S X=$O(^XUSEC(X)) Q:$E(X,1,3)'=KEYPREF  D
 . S ISII=ISII+1,ISIKS(ISII)=X
 . Q
 I ISII=0 Q  ; no key found
 D OWNSKEY^XUSRB(.ISIKG,.ISIKS)  ; verify what keys belong to the user DUZ
 ;
 S ISII=0,ISIJ=0
 F  S ISII=$O(ISIKG(ISII)) Q:ISII=""  D
 . Q:ISIKG(ISII)=0  ; The user doesn't have the key
 . S ISIJ=ISIJ+1,ISIK(ISIJ)=ISIKS(ISII)
 Q
