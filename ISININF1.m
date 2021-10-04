ISININF1 ;ISI/NST - Image information RPC ; 23 Nov 2014 3:59 PM
 ;;1.0;ISI;**local**;Mar 19, 2002;Build 24;May 01, 2013
 ;;
 Q
 ;
 ;***** RETURNS THE INFORMATION OF THE IMAGE FILE
 ;RPC = ISI DICOM GET BASIC IMAGE
 ; D0            IEN of the image record in the file #2005
 ; 
 ; Return Values OUT
 ; =============
 ;           <0  ErrorCode~ErrorMessage
 ;           ""  Name is not available or an error occured
 ; if success OUT(1) = Numer(>0) of the info that been retrived
 ;            OUT(n) = image inforation TAG^value, e.g.:                             
 ;- Object Type IEN
 ;- Full UNC path of FULL image node "Full Path+FileName"
 ;- Full UNC path of ABSTRACT image node "Abstract Path+FileName"
 ;- Full UNC path of BIG image node (if it exists)
 ;- Patient DFN and ICN (if it exists)
 ;- Station number of site that owns the image (primary and local) "ACQUISITION SITE^660"
 ;- IEN of GROUP PARENT
 ;- IEN of Network location image is currently stored on
 ;
IMAGE(OUT,D0) ; RPC [ISI DICOM GET BASIC IMAGE] call to return information for 1 image;
 N I,MSG,TARGET,V,VE,VI,X,ISIRACNI
 K OUT S I=1
 I '$G(D0) S OUT(1)="-1^Invalid IEN ("_$G(D0)_")" Q
 I $D(^MAG(2005.1,D0,0)) S OUT(1)="-3^Image #"_D0_" has been deleted." Q
 I '$D(^MAG(2005,D0,0)) S OUT(1)="-2^No data for """_D0_"""." Q
 ;
 D GETS^DIQ(2005,D0_",","*","REIN","TARGET","MSG")
 S X="" F  S X=$O(TARGET(2005,D0_",",X)) Q:X=""  D
 . S VI=$G(TARGET(2005,D0_",",X,"I"))
 . S VE=$G(TARGET(2005,D0_",",X,"E"))
 . I X["ACQUISITION SITE" S VI=$P($$NS^XUAF4(VI),U,2) ;IA #2171 Get Station Number
 . E  I X["PATIENT" S:$T(GETICN^MPIF001)'="" VE=VE_"^"_$$GETICN^MPIF001(VI)
 . S I=I+1,OUT(I)=X_"^"_VI S:VI'=VE OUT(I)=OUT(I)_"^"_VE
 . Q
 ;
 D FILEFIND^MAGDFB(D0,"FULL",0,0,.X,.V)
 S:X'<0 I=I+1,OUT(I)="Full FileName^"_X
 S:V'<0 I=I+1,OUT(I)="Full Path^"_$P(V,X)
 ;
 D FILEFIND^MAGDFB(D0,"BIG",0,0,.X,.V)
 S:X'<0 I=I+1,OUT(I)="Big FileName^"_X
 S:V'<0 I=I+1,OUT(I)="Big Path^"_$P(V,X)
 ;
 D FILEFIND^MAGDFB(D0,"ABSTRACT",0,0,.X,.V)
 S:X'<0 I=I+1,OUT(I)="Abstract FileName^"_X
 S:V'<0 I=I+1,OUT(I)="Abstract Path^"_$P(V,X)
 ; Network location + regional
 S X=$P(^MAG(2005,D0,0),"^",3)
 I X>0 S I=I+1,OUT(I)="Network Location^"_X_$S($G(^MAG(2005.2,+X,"REGIONAL")):"^REGIONAL^1",1:"")
 ;
 S (V,X)=0 F  S X=$O(^MAG(2005,D0,1,X)) Q:'X  S V=V+1
 S:V I=I+1,OUT(I)="# Images^"_V
 ;
 S ISIRACNI=$$RACNI(D0)
 S:ISIRACNI I=I+1,OUT(I)="Radiology Internal Case Number^"_ISIRACNI
 S OUT(1)=I-1
 Q
 ;
RACNI(MAGIEN) ; Get RACNI - radiology internal case number - by given image IEN
 N ISIGLBR,RARPT,RADTI,RADFN,RACN,RACNI
 S RACNI=""
 S ISIGLBR=$$GET1^DIQ(2005,MAGIEN,"PARENT DATA FILE#","I")
 I ISIGLBR=74 D
 . S RARPT=$$GET1^DIQ(2005,MAGIEN,"PARENT GLOBAL ROOT D0","I")
 . S RADFN=$$GET1^DIQ(74,RARPT,"PATIENT NAME","I")
 . S RADTI=9999999.9999-$$GET1^DIQ(74,RARPT,"EXAM DATE/TIME","I")
 . S RACN=$$GET1^DIQ(74,RARPT,"DAY-CASE#","I")
 . S:RACN&RADFN&RADTI RACNI=$O(^RADPT("ADC",RACN,RADFN,RADTI,0))
 . Q
 Q RACNI
