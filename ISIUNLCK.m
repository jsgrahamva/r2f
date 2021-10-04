ISIUNLCK ; ISI/JSL,SAF - Unlock Index Files for Editing
 ;;1.0;ISI IMAGING;;Jan 27, 2010;Build 2
 F FILE=2005.82,2005.83,2005.84,2005.85,2005.852 D
 . S X=$P(^DD(FILE,.01,0),U,2)
 . I X["I" S X=$TR(X,"I","") S $P(^DD(FILE,.01,0),U,2)=X ;ENABLE DEL
 . S ^DD(FILE,.01,"LAYGO",1,0)="" ;ENABLE ADDING
 . Q
 ;
 ;  disable 'Write' access for certain fields in the files
 K ^DD(2005.82,1,9)  ;Class: Status
 K ^DD(2005.83,1,9)  ;Type: Class
 K ^DD(2005.83,2,9)  ;Type: Status
 K ^DD(2005.83,3,9)  ;Type: Abbreviation
 K ^DD(2005.84,1,9)  ;Spec/SubSpec: Class 
 K ^DD(2005.84,2,9)  ;Spec/SubSpec: Spec Level
 K ^DD(2005.84,3,9)  ;Spec/SubSpec: Abbreviation
 ; ^DD(2005.84,4)    ; STATUS - Leave Write access
 K ^DD(2005.85,1,9)  ;Proc/Event: Class
 K ^DD(2005.85,2,9)  ;Proc/Event: Specialty
 K ^DD(2005.85,3,9)  ;Proc/Event: Abbreviation
 Q
