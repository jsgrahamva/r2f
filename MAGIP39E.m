MAGIP39E ;Patch 39's environment checking
 ;;3.0;IMAGING;**39**;Mar 19, 2002;Build 2;Sep 10, 2010
 ;; Per VHA Directive 2004-038, this routine should not be modified.
 ;; +---------------------------------------------------------------+
 ;; | Property of the US Government.                                |
 ;; | No permission to copy or redistribute this software is given. |
 ;; | Use of unreleased versions of this software requires the user |
 ;; | to execute a written test agreement with the VistA Imaging    |
 ;; | Development Office of the Department of Veterans Affairs,     |
 ;; | telephone (301) 734-0100.                                     |
 ;; | The Food and Drug Administration classifies this software as  |
 ;; | a medical device.  As such, it may not be changed in any way. |
 ;; | Modifications to this software may result in an adulterated   |
 ;; | medical device under 21CFR820, the use of which is considered |
 ;; | to be a violation of US Federal Statutes.                     |
 ;; +---------------------------------------------------------------+
 ;;
 ; Check duplicate network locations and inform the site on the entries
 N DA,EN,LIST,MAGNME,PL,RTR
 Q:+$G(XPDENV)  ;Only run on LOAD phase - the variable is defined by the KID install process
 D GETRL(.LIST),SORT(.LIST)
 S EN=$O(LIST("")) I EN=""  W !,"No duplicate NETWORK LOCATION entries were found." Q
 S PL=0 F  S PL=$O(LIST(PL)) Q:'PL  D
 . W !,"The Network Location file(#2005.2) has duplicate entries!",!
 . W !,?20,$P(^DIC(4,+$P(^MAG(2006.1,+PL,0),U),0),U) S TYPE="" F  S TYPE=$O(LIST(PL,TYPE)) Q:TYPE=""  D
 . . W !!,"Storage type: ",TYPE  I TYPE="ROUTER" W !,"Review ROUTE.DIC file and if needed change to Prime entry's name."
 . . S EN="" F  S EN=$O(LIST(PL,TYPE,EN)) Q:EN=""  D
 . . . S MAGNME=$P(^MAG(2005.2,$P(LIST(PL,TYPE,EN),U),0),U),RTR=$S(+$P(^MAG(2005.2,$P(LIST(PL,TYPE,EN),U),0),U,9):"ROUTER",1:"")
 . . . W !,"Duplicate network path: ",$P(EN,U)_"  "_$S($P(EN,U,2)="Y":"Hashed",1:"")
 . . . W !,?2,$G(RTR)_" Prime share name: ",MAGNME I $G(RTR)="" W "  (IEN:`"_$P(LIST(EN),U)_")"
 . . . F PC=2:1:$L(LIST(PL,TYPE,EN),"^") S DA=$P(LIST(PL,TYPE,EN),U,PC) Q:'DA  W !,?5," Duplicate: ",$P(^MAG(2005.2,+DA,0),U)_" (IEN:`"_DA_")",!
 . . . Q
 . . Q
 . W !!,"Patch 39 will task a job to delete the duplicate entries.",!!
 . Q
 Q
GETRL(LIST) ;  Get Redundant List (of shares)
 N HASH,IEN,NODE,NODE2,NODE3,PATH,PLACE,TYPE
 ; Must have same:  PHYSICAL REFERENCE,STORAGE TYPE,HASH DIRECTORY,PLACE
 ; Routers have the ROUTER field defined.  (Verify this with Ron)
 ; Return array:(UNC path, 1 or 0 for hash directory,division)=list of iens that match the UNC path
 ; ARRAY(\\UNC_HASH_DIVISION)=1ST IEN FOUND_IEN_IEN,etc.
 K LIST
 S U="^"
 S IEN=0 F  S IEN=$O(^MAG(2005.2,IEN)) Q:'IEN  D
 . S NODE=$G(^MAG(2005.2,IEN,0)),NODE3=$G(^MAG(2005.2,IEN,3)),NODE2=$G(^MAG(2005,IEN,3))
 . S PATH=$P(NODE,U,2),PLACE=$P(NODE,U,10),TYPE=$P(NODE,U,7),HASH=$P(NODE,U,8)
 . Q:((TYPE'["WORM")&(TYPE'["MAG"))  ; Only RAID and Jukebox NAMES
 . I +$D(LIST(PATH_U_HASH_U_PLACE)) D  Q
 . . S $P(LIST(PATH_U_HASH_U_PLACE),U,1,99)=$P(LIST(PATH_U_HASH_U_PLACE),U,1,99)_U_IEN
 . . Q
 . E  S LIST(PATH_U_HASH_U_PLACE)=IEN
 . Q
 S PATH="" F  S PATH=$O(LIST(PATH)) Q:PATH=""  D
 . I $G(LIST(PATH))'["^" K LIST(PATH) ;Only entry with more than one IEN defined.
 . Q
 ;Now start applying rules: 
 ;Use the IEN in the duplicates that is ONLINE-- as the primary.
 N NEW,OLD,ON,PC,PRIME
 S EN="" F  S EN=$O(LIST(EN)) Q:EN=""  D
 . S ON=0 F PC=1:1:$L(LIST(EN),"^") S IEN=$P(LIST(EN),U,PC) D  Q:ON
 . . I PC=1,+$P(^MAG(2005.2,IEN,0),U,6) S ON=1 Q    ;above rule
 . . I +$P(^MAG(2005.2,IEN,0),U,6) S ON=1 S NEW(EN)=IEN_"^"_PC
 . . Q
 . Q
 ;resort the array to place the new prime in right order
 S EN="" F  S EN=$O(NEW(EN)) Q:EN=""  D
 . ;get the original prime (OLD)and the new piece value for it.
 . S PRIME=$G(NEW(EN)),OLD=+LIST(EN)_U_$P(PRIME,U,2)
 . S NEW(EN)=$G(LIST(EN))   ;get the original prime and dup values 
 . S $P(NEW(EN),U)=+PRIME   ;set the new prime
 . S $P(NEW(EN),U,$P(OLD,U,2))=+OLD  ;Reposition the old prime value
 . Q
 S EN="" F  S EN=$O(LIST(EN)) Q:EN=""  D
 . I $D(NEW(EN)) M LIST(EN)=NEW(EN)
 . Q
 Q
SORT(LIST) ;Removing Router since there is a separate email sent during the post install.
 N PLACE,ROUTER,TYPE,NEW,NAME
 S EN="" F  S EN=$O(LIST(EN)) Q:EN=""  D
 . S PLACE=$P(EN,U,3),HASH=$P(EN,U,2),NAME=$P(EN,U)
 . S ROUTER=$S(+$P(^MAG(2005.2,$P(LIST(EN),U),0),U,9):"ROUTER",1:"")
 . S TYPE=$P(^MAG(2005.2,$P(LIST(EN),U),0),U,7)
 . S TYPE=$S(ROUTER'="":ROUTER,1:TYPE)
 . S NEW(PLACE,TYPE,EN)=$G(LIST(EN))
 . Q
 M LIST=NEW
 Q
 ;
