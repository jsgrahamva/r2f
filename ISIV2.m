ISIV2 ;ISI/GEK,SAF - Utilities
 ;;1.0;ISI IMAGING;;Jan 03, 2008;Build 2
 ;;
 Q
ZCHKECG(IFDA) ; Called from MAGGTIA1 to check FDA array before creating
 ; new Image entry.  Change data if needed.  This is where we check FDA 
 ; array to see if the data tells us that this is aN ECG.
 ; TESTING DEBUGGING
 I '$G(GEKCT) S GEKCT=$O(^GEKTMP("MAGGTIA",""),-1)+1
 ; in MAGGTIA, we save input data to Temp Array. for Debugging
 ;M ^GEKTMP("MAGGTIA",GEKCT,"GZ")=MAGGZ
 ;here we save the FDA Array for debugging. 
 M ^GEKTMP("MAGGTIA",GEKCT,"FDA")=IFDA
 ; END TESTING DEBUGGING
 ; ^GEKTMP("MAGGTIA",1,"FDA",2005,"+1,",.01)=TEST,PATIENT   321459876
 ;                                   .05)=1
 ;                                     2)=2
 ;                                   2.1)=2
 ;                                     3)=15
 ;                                     5)=5
 ;                                     6)=CLIN
 ;                                     7)=3111102.083605
 ;                                     8)=76
 ;                                    10)=MEDICAL RECORD
 ;                                    15)=3111102
 ;                                    40)=NONE
 ;                                    41)=1
 ;                                    42)=69
 ;                                    43)=3
 ;                                    44)=2
 ;                                    45)=O
 ;                                   110)=3111102
 ;                                     
 ; if Proc/Event =3 ("EKG") this is ECG, so we change Object Type to ECG 
 ; ^DD(2005,43,0)=PROC/EVENT INDEX^P2005.85'^MAG(2005.85,^40;4^Q
 ; ^MAG(2005.85,3,0)=EKG^1
 ; ;;
 ;^DD(2005,3,0)=OBJECT TYPE^P2005.02'^MAG(2005.02,^0;6^Q                                     
 ;^MAG(2005.02,13,0)=ECG^0
 I $G(IFDA(2005,"+1,",43))=3 S IFDA(2005,"+1,",3)=13
 Q
CHKECG(MAGGDA) ; Called from MAGGTIA1 after the IMAGE entry has 
 ; been made.  we'll check entry to see if it is an ECG , if it is
 ; we'll change the OJBECT TYPE to 3 (ECG) 
 N IXP,FNM,OBT,EXT
 N ISECG
 S ISECG=0
 Q:'$G(MAGGDA) ; Should never happen.
 ; TESTING DEBUGGING
 I '$G(GEKCT) S GEKCT=$O(^GEKTMP("MAGGTIA",""),-1)+1
 S ^GEKTMP("MAGGTIA",GEKCT,"MAGGDA")=$G(MAGGDA)
 ; END TESTING DEBUGGING
 I '$D(^MAG(2005,MAGGDA)) Q ; Should never happen.
 S IXP=$$GET1^DIQ(2005,MAGGDA,43,"I") ; INDEX PROC/EVENT
 S FNM=$$GET1^DIQ(2005,MAGGDA,1,"I") ; FILENAME
 S OBT=$$GET1^DIQ(2005,MAGGDA,3,"I") ;OBJECT TYPE
 S EXT=$P(FNM,".",$L(FNM,".")) ; EXTENSION
 I IXP=3 D  ; if Procedure Index is EKG
 . I EXT="DCM" S ISECG=1 Q  ; The Extension of the File is DCM
 . I OBT=100 S ISECG=1 Q  ; 100 = DICOM
 . Q
 I ISECG S $P(^MAG(2005,MAGGDA,0),"^",6)=13 ; Set Object Type to ECG
 Q
