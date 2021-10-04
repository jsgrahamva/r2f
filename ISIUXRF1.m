ISIUXRF1 ;ISI/GEK,SAF  Additional Cross References 
 ;;1.0;ISI IMAGING;;Jan 03, 2008;Build 2
 D TAGS^ISIXUT31($T(+0),1)
 Q
SETADEL ;This sets the "ADELGI", "ADELIG", "ADEL", "ADELPI" Cross references, based on the
 ;Field:   (#30) DELETED BY [1P:200] 
 N GRPIEN,DFN
 D SETUPAD
 ;S ^TMP("ISI","ADEL","SET")="X: "_$G(X)_"  DA: "_$G(DA)_"  Y: "_$G(Y)_" GRPIEN: "_GRPIEN_" DFN: "_DFN
 S ^MAG(2005,"ADEL",DA)=""
 I GRPIEN S ^MAG(2005,"ADELIG",DA,GRPIEN)="",^MAG(2005,"ADELGI",GRPIEN,DA)=""
 I DFN S ^MAG(2005,"ADELPI",DFN,DA)=""
 ; At the moment, we do not clear the APPXDT and APDTPX Cross references on Delete
 ;   may rethink that, If we do, then uncomment this to kill 
 ;I DFN S X=DFN D KILPPXD^MAGUXRF
 Q
SETUPAD ;
 N N0 S N0=$G(^MAG(2005,DA,0))
 S GRPIEN=$P(N0,"^",10) ; GROUP PARENT
 S DFN=$P(N0,"^",7) ; PATIENT
 Q
KILLADEL ;This Kills "ADELGI", "ADELIG", "ADEL", "ADELPI" Cross references, based on the
 ;Field:   (#30) DELETED BY [1P:200] 
 ;;  We do not allow Un-Delete 
 N GRPIEN,DFN
 D SETUPAD
 ;S ^TMP("ISI","ADEL")="X: "_$G(X)_"  DA: "_$G(DA)_"  Y: "_$G(Y)_" GRPIEN: "_GRPIEN_" DFN: "_DFN
 K ^MAG(2005,"ADEL",DA)
 I GRPIEN K ^MAG(2005,"ADELIG",DA,GRPIEN),^MAG(2005,"ADELGI",GRPIEN,DA)
 I DFN K ^MAG(2005,"ADELPI",DFN,DA)
 ; At the moment, we do not clear the APPXDT and APDTPX Cross references on Delete
 ;   may rethink that, If we do, then uncomment this to kill 
 ;I DFN S X=DFN D SETPPXD^MAGUXRF
 Q
SETSTHST ; This is the Set for the Status History CR
 ;we do nothing.
 ;There is also a Traditional Cross reference for the Status field
 ;It is the ASTAT Cross Reference.
 Q
KILSTHST ; This is the Kill' for the Status History multiple
 ; when the status field #35.1 is changed we save existing
 ; Status, Status By, Status Date, Status Reason.
 ; called ASTCHNG in the DD.
 N ISFDA,N35,HIST,HISTBY,HISTDT,HISTREA
 S N35=$G(^MAG(2005,DA,35)) I N35]"" D
 . S HIST=X ; X is old value of STATUS $P(N35,"^",1)
 . S HISTBY=$P(N35,"^",2)
 . S HISTDT=$P(N35,"^",3)
 . S HISTREA=$P(N35,"^",4)
 . S Y="+2,"_DA_","
 . S ISFDA(2005.036,Y,.01)=HIST
 . S ISFDA(2005.036,Y,2)=HISTBY
 . S ISFDA(2005.036,Y,3)=HISTDT
 . S ISFDA(2005.036,Y,4)=HISTREA
 . D UPDATE^DIE("S","ISFDA")
 . Q
 Q
