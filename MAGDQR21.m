MAGDQR21 ;WOIFO/EdM,NST,MLH ISI/JL - RPCs for Query/Retrieve SetUp ; 01 Apr 2014 4:27 PM
 ;;3.0;IMAGING;**83,104,local**;Mar 19, 2002;Build 2225;Jul 12, 2011
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
 Q
 ;
GET(OUT,DEST,GATEWAY) ; RPC = MAG GET DICOM DEST
 N D0,D1,N,OK,X
 I $G(DEST)="" D  Q
 . S N=1
 . S X="" F  S X=$O(^MAG(2006.587,"B",X)) Q:X=""  S N=N+1,OUT(N)="B^"_X
 . S X="" F  S X=$O(^MAG(2006.587,"D",X)) Q:X=""  S N=N+1,OUT(N)="D^"_X
 . S OUT(1)=N
 . Q
 ;
 S GATEWAY=$G(GATEWAY) S:GATEWAY="--All DICOM Gateways--" GATEWAY=""
 S D0=0,OK=0 F  S D0=$O(^MAG(2006.587,D0)) Q:'D0  D  Q:OK
 . S X=$G(^MAG(2006.587,D0,0))
 . Q:$P(X,"^",1)'=DEST
 . I GATEWAY'="",$P(X,"^",5)'=GATEWAY Q
 . S OK=1,N=6
 . S OUT(2)="2^"_$P(X,"^",2)
 . S OUT(3)="3^"_$P(X,"^",3)
 . S OUT(4)="4^"_$P(X,"^",4)
 . S OUT(5)="5^"_$P(X,"^",6)
 . S OUT(6)="6^"_$P(X,"^",7)
 . S D1=0 F  S D1=$O(^MAG(2006.587,D0,1,D1)) Q:'D1  D
 . . S X=$G(^MAG(2006.587,D0,1,D1,0)) Q:$P(X,"^",1)=""
 . . S N=N+1,OUT(N)=X
 . . Q
 . Q
 S OUT(1)=N
 Q
 ;
SET(OUT,DATA,DEST,GATEWAY) ; RPC = MAG SET DICOM DEST
 N D0,D1,I,N,P,Q,O1,O5,O7,OK,T,X
 I $G(DEST)="" S OUT="-1,No Destination Specified." Q
 ;
 S I="" F  S I=$O(DATA(I)) Q:I=""  D
 . S T=DATA(I) Q:T'["^"
 . I +T=2 S P(2)=$P(T,"^",2) Q
 . I +T=3 S P(3)=$P(T,"^",2) Q
 . I +T=4 S P(4)=$P(T,"^",2) Q
 . I +T=5 S P(6)=$P(T,"^",2) Q
 . I +T=6 S P(7)=$P(T,"^",2) Q
 . S Q($P(T,"^",1))=(+$P(T,"^",2))_"^"_(+$P(T,"^",3))
 . Q
 ;
 S OUT=0
 S GATEWAY=$G(GATEWAY) S:GATEWAY="--All DICOM Gateways--" GATEWAY=""
 S D0=0,OK=0 F  S D0=$O(^MAG(2006.587,D0)) Q:'D0  D  Q:OK
 . S X=$G(^MAG(2006.587,D0,0)),O1=$P(X,"^",1),O5=$P(X,"^",5),O7=$P(X,"^",7)
 . Q:O1'=DEST
 . I GATEWAY'="",O5'=GATEWAY Q
 . S:GATEWAY'="" OK=1 S OUT=OUT+1
 . I O1'="",O5'="",O7'="" K ^MAG(2006.587,"C",O1,O7,O5,D0)
 . I O5'="",O7'="" K ^MAG(2006.587,"D",O5,O7,D0)
 . S I="" F  S I=$O(P(I)) Q:I=""  S:P(I)'="" $P(X,"^",I)=P(I)
 . S:$G(P(7))'="" O7=P(7)
 . S ^MAG(2006.587,D0,0)=X
 . I O1'="",O5'="",O7'="" S ^MAG(2006.587,"C",O1,O7,O5,D0)=""
 . I O5'="",O7'="" S ^MAG(2006.587,"D",O5,O7,D0)=""
 . K ^MAG(2006.587,D0,1)
 . S D1=0,I="" F  S I=$O(Q(I)) Q:I=""  D
 . . S D1=D1+1,^MAG(2006.587,D0,1,D1,0)=I_"^"_Q(I)
 . . S ^MAG(2006.587,D0,1,"B",I,D1)=""
 . . Q
 . S:D1 ^MAG(2006.587,D0,1,0)="^2006.5871SA^"_D1_"^"_D1
 . Q
 Q
 ;
TMPOUT(NAME) N X
 S X=$$RTRNFMT^XWBLIB("GLOBAL ARRAY",1)
 S X=$NA(^TMP("MAG",$J,NAME))
 K @X
 Q X
 ;
STUDY1(OUT,STUDIES) ; RPC = MAG DOD GET STUDIES UID
 N I,N,STUDY,UID
 S N=1 S OUT=$$TMPOUT("STUDY")
 S UID=$G(STUDIES) S:UID'="" STUDY(UID)=""
 S I="" F  S I=$O(STUDIES(I)) Q:I=""  S UID=$G(STUDIES(I)) S:UID'="" STUDY(UID)=""
 S UID="" F  S UID=$O(STUDY(UID)) Q:UID=""  D STUDY(UID)
 S @OUT@(1)=N-1
 Q
 ;
STUDY2(OUT,GROUPS,REQDFN,IMGLESS) ; RPC = MAG DOD GET STUDIES IEN
 ; CR, 5-28-09
 ; IMGLESS is a new flag to speed up queries: if=1 (true), just get study-level 
 ; data, if null or zero get everything. This new flag is optional.
 N I0,I,N,P0,STUDY,UID
 S REQDFN=$G(REQDFN),IMGLESS=$G(IMGLESS)
 S N=1 S OUT=$$TMPOUT("STUDY")
 S I0=$G(GROUPS) D  S I="" F  S I=$O(GROUPS(I)) Q:I=""  S I0=$G(GROUPS(I)) D
 . Q:'I0
 . F  S P0=$P($G(^MAG(2005,+I0,0)),"^",10) Q:'P0  S I0=P0
 . S UID=$P($G(^MAG(2005,+I0,"PACS")),"^",1) S:UID="" UID="?"
 . S STUDY(UID,I0)=""
 . Q
 S UID="" F  S UID=$O(STUDY(UID)) Q:UID=""  D
 . I UID="?" D  Q
 . . S I0=""
 . . F  S I0=$O(STUDY(UID,I0)) Q:I0=""  D STUDY("",I0,REQDFN,IMGLESS)
 . . Q
 . D STUDY(UID,"",REQDFN,IMGLESS)  ; UID is not "?"
 . Q
 S @OUT@(1)=N-1
 Q
 ;
STUDY(UID,IEN,REQDFN,IMGLESS) ;
 N D0,D1,DFN,F1,F2,F3,I0,IMGCNT,IMGINFO,MAGR0,OBJGRP,OVRDDFN,PAT,QINTEG,STUDY,STUMO,X
 N SERIESARRAY ; array of series numbers for this study
 N TOTIMAGES ; total number of images for all series in this study
 N PATCOUNT ; array of patients having studies with the requested study instance UID
 N RG,ICN  ; ISI
 ;
 S N=N+1,@OUT@(N)="NEXT_STUDY|"_UID_"|"_IEN
 I UID'="" S D0="" F  S D0=$O(^MAG(2005,"P",UID,D0)) Q:D0=""  D
 . S:'$P($G(^MAG(2005,D0,0)),"^",10) STUDY(D0)="" ; Get only image IEN
 . Q
 D:$G(IEN)
 . S:'$P($G(^MAG(2005,IEN,0)),"^",10) STUDY(IEN)="" ; Get only image IEN
 . Q
 Q:'$O(STUDY(""))
 S TOTIMAGES=0
 S D0="" F  S D0=$O(STUDY(D0)) Q:D0=""  D
 . S DFN=+$P($G(^MAG(2005,D0,0)),"^",7),PATCOUNT(DFN)=""
 . D  ; add to patient array unless single pt was requested and this isn't that pt
 . . I REQDFN'=DFN Q
 . . S:'$D(^MAG(2005,D0,1)) TOTIMAGES=TOTIMAGES+1 ; a single image (e.g., photo ID), not a group
 . . S PAT(DFN,D0)=""
 . . Q
 . S D1=0 F  S D1=$O(^MAG(2005,D0,1,D1)) Q:'D1  D
 . . S I0=+$G(^MAG(2005,D0,1,D1,0)) Q:'I0
 . . S DFN=+$P($G(^MAG(2005,I0,0)),"^",7),PATCOUNT(DFN)=""  ; Group DFN
 . . D  ; increment image count unless single pt was requested and this isn't that pt
 . . . I REQDFN'=DFN Q
 . . . S TOTIMAGES=TOTIMAGES+1
 . . . Q
 . . Q
 . Q
 ;
 S PAT=0,DFN="" F  S DFN=$O(PATCOUNT(DFN)) Q:DFN=""  S PATCOUNT=$G(PATCOUNT)+1
 I PATCOUNT>1 D  Q:'REQDFN  Q:'$D(PAT(REQDFN))
 . ; duplicate study instance UID?
 . S N=N+1,@OUT@(N)="STUDY_ERR|"_UID_"|"_PATCOUNT_" different patients"
 . Q
 ;
 S:UID'="" N=N+1,@OUT@(N)="STUDY_UID|"_UID
 S I0=$O(PAT(REQDFN,""))
 I 'I0 S N=N+1,@OUT@(N)="STUDY_ERR|"_UID_"|Matching study not found for patient "_REQDFN Q
 S OBJGRP=$$ONEGROUP(I0) ; get the first image IEN for group/image I0
 S RG=$S($D(^MAG(2005,I0,1,0)):$$REGIONAL(OBJGRP),1:$$REGIONAL(I0)) ;ISI regional image
 S N=N+1,@OUT@(N)="STUDY_IEN|"_I0_"|"_TOTIMAGES_"|"_OBJGRP_"|"_$$CPTCODE(I0)_"|"_$$GETSITE1(OBJGRP)_"|"_$G(RG) ;ISI - more info
 ;
 ; check integrity of study record, bail out unless DFN is specified
 ; and matches study DFN (VA internal use only!)
 D CHK^MAGGSQI(.X,I0) S QINTEG='$G(X(0)) D:QINTEG
 . S @OUT@(N)=@OUT@(N)_"|"_$P($G(X(0)),"^",2)
 . Q
 ; override QI check only if image DFN = DFN specified in call
 ; (VA internal only!)
 I QINTEG Q:'REQDFN  Q:$P($G(^MAG(2005,I0,0)),"^",7)'=REQDFN
 ;
 S N=N+1,@OUT@(N)="STUDY_PAT|"_REQDFN_"|"_$$GETICN^MPIF001(REQDFN)_"|"_$P($G(^DPT(REQDFN,0)),"^",1)
 ;
 ; CR, 5-28-09
 ; For study-level data stop here without additional checks 
 Q:IMGLESS=1
 ;end of check above
 ;
 S D0="" F  S D0=$O(PAT(REQDFN,D0)) Q:D0=""  D
 . N ANY,I,INUM,SERID,SERIES,SNUM,STS,TMP,U1
 . K ^TMP("MAG",$J,"S")
 . K ^TMP("MAG",$J,"M")
 . D  ; retrieve info for either single or group image
 . . I $D(^MAG(2005,D0,1)) D  Q  ; image is part of a group
 . . . ; allow return of info if DFN defined
 . . . D GROUP^MAGGTIG(.TMP,D0,REQDFN)
 . . . Q
 . . D  ; DEFAULT - image is a single
 . . . N X
 . . . D IMAGEINF^MAGGTU3(.X,D0,REQDFN)
 . . . S TMP=$NA(^TMP("MAGGTIG",$J))
 . . . K @TMP S @TMP@(0)="1^1",@TMP@(1)=X(0)
 . . . Q
 . . Q
 . D:$E($G(TMP),1,5)="^TMP("
 . . N D,G,M,P,X
 . . K @TMP@(0)
 . . S I="" F  S I=$O(@TMP@(I)) Q:I=""  D
 . . . S X=$G(@TMP@(I)),D=$P(X,"^",2) Q:'D
 . . . ; Only if those two pieces really aren't used:
 . . . ;;S $P(X,"^",3)=""
 . . . ;;S $P(X,"^",4)=""
 . . . S ^TMP("MAG",$J,"S",D)=X
 . . . S X=$G(^MAG(2005,D,0)),G=+$P(X,"^",10)
 . . . S M=$P(X,"^",8) S:$E(M,1,4)="RAD " M=$E(M,5,$L(M)) Q:M=""
 . . . S G=$P($G(^MAG(2005,G,2)),"^",6),P=$P($G(^MAG(2005,D,2)),"^",6)
 . . . I P'=74,G'=74 Q
 . . . S ^TMP("MAG",$J,"M",1,D)=M,STUMO(M)=""
 . . . S G=$G(^MAG(2005,D,"SERIESUID"))
 . . . S:G'="" ^TMP("MAG",$J,"M",2,G,M)=""
 . . . Q
 . . Q
 . S (ANY,D1)=0 F  S D1=$O(^MAG(2005,D0,1,D1)) Q:'D1  D
 . . S X=$G(^MAG(2005,D0,1,D1,0)),I0=+X Q:'I0
 . . S ANY=1,I0=+X,SNUM=$P(X,"^",2),INUM=$P(X,"^",3)
 . . S U1=$G(^MAG(2005,I0,"SERIESUID"))
 . . S:SNUM="" SNUM="?" S:INUM="" INUM="?" S:U1="" U1="?"
 . . S SERIES(U1_"_"_SNUM,INUM,I0)="",SERID(U1_"_"_SNUM,U1)=""
 . . Q
 . D:'ANY
 . . S U1=$G(^MAG(2005,D0,"SERIESUID")) S:U1="" U1="?"
 . . S SERIES(U1_"_1",1,D0)="",SERID(U1_"_1",U1)=""
 . . Q
 . S SNUM="" F  S SNUM=$O(SERIES(SNUM)) Q:SNUM=""  D
 . . ; refresh temp image index
 . . N MAGTI S MAGTI=0 ; temp image index
 . . K ^TMP("MAG",$J,"TI")
 . . ;
 . . ; seek qualifying images (no QI or matching known DFN)
 . . S INUM="" F  S INUM=$O(SERIES(SNUM,INUM)) Q:INUM=""  D
 . . . S I0="" F  S I0=$O(SERIES(SNUM,INUM,I0)) Q:I0=""  D
 . . . . ; if dup study instance UID, purge image info and bail out
 . . . . ; unless pt is specified and this image is for that pt
 . . . . S MAGR0=$G(^MAG(2005,I0,0))
 . . . . I REQDFN,$P(MAGR0,"^",7)'=REQDFN K ^TMP("MAG",$J,"S",I0) Q
 . . . . ;
 . . . . S X=$P($G(^MAG(2005,I0,"PACS")),"^",1)
 . . . . S MAGTI=MAGTI+1,^TMP("MAG",$J,"TI",MAGTI)="NEXT_IMAGE"
 . . . . S:X'="" MAGTI=MAGTI+1,^TMP("MAG",$J,"TI",MAGTI)="IMAGE_UID|"_X
 . . . . S MAGTI=MAGTI+1,^TMP("MAG",$J,"TI",MAGTI)="IMAGE_IEN|"_I0
 . . . . S X=$P(MAGR0,"^",10)
 . . . . S:X MAGTI=MAGTI+1,^TMP("MAG",$J,"TI",MAGTI)="GROUP_IEN|"_X
 . . . . ; QI check - override only if DFN specified in call
 . . . . ; (VA internal only!)
 . . . . D CHK^MAGGSQI(.X,I0) I '$G(X(0)) D  Q:'REQDFN
 . . . . . S MAGTI=MAGTI+1,^TMP("MAG",$J,"TI",MAGTI)="IMAGE_ERR|"_$P($G(X(0)),"^",2)
 . . . . . Q
 . . . . ;
 . . . . S:INUM'="?" MAGTI=MAGTI+1,^TMP("MAG",$J,"TI",MAGTI)="IMAGE_NUMBER|"_INUM
 . . . . S IMGINFO=$G(^TMP("MAG",$J,"S",I0)) K ^TMP("MAG",$J,"S",I0)
 . . . . ; Get Site image parameters IEN from 16^ piece of IMGINFO
 . . . . S:IMGINFO'="" MAGTI=MAGTI+1,^TMP("MAG",$J,"TI",MAGTI)="IMAGE_INFO|"_IMGINFO_"|"_$$GETSNUM($P(IMGINFO,"^",16))_"|"_$$REGIONAL(I0) ;ISI:RG regional image
 . . . . Q
 . . . Q
 . . D:$D(^TMP("MAG",$J,"TI"))  ; qualifying images were found
 . . . S U1="" F  S U1=$O(SERID(SNUM,U1)) Q:U1=""  D
 . . . . N M,X
 . . . . S N=N+1,@OUT@(N)="NEXT_SERIES"
 . . . . S:U1'="?" N=N+1,@OUT@(N)="SERIES_UID|"_U1
 . . . . S N=N+1,@OUT@(N)="SERIES_IEN|"_D0
 . . . . ; Officially, there can be only one modality per series,
 . . . . ; so stop when the first modality is found...
 . . . . S X="",M="" F  S M=$O(^TMP("MAG",$J,"M",2,U1,M)) Q:M=""  D  Q:X'=""
 . . . . . S X=$S(X'="":"\",1:"")_M
 . . . . . Q
 . . . . S:X'="" N=N+1,@OUT@(N)="SERIES_MODALITY|"_X
 . . . . Q
 . . . D:SNUM'="?"  ; assign the series number
 . . . . N SERIESNUM
 . . . . D  ; - get series no from study itself if possible, else generate
 . . . . . N SERIESTEST,SGN
 . . . . . S SERIESTEST=$P(SNUM,"_",2)
 . . . . . Q:"+-1234567890"'[$E(SERIESTEST,1)  ; invalid number
 . . . . . S:"+-"[$E(SERIESTEST,1) SGN=$E(SERIESTEST,1)
 . . . . . S:$D(SGN) SERIESTEST=$E(SERIESTEST,2,$L(SERIESTEST))
 . . . . . Q:SERIESTEST'?1.12N
 . . . . . S SERIESTEST=$G(SGN)_SERIESTEST
 . . . . . Q:$D(SERIESARRAY(SERIESTEST))
 . . . . . S SERIESNUM=SERIESTEST
 . . . . . Q
 . . . . D:'$D(SERIESNUM)  ; still need to generate
 . . . . . F SERIESNUM=1:1 Q:'$D(SERIESARRAY(SERIESNUM))
 . . . . . Q
 . . . . S N=N+1,@OUT@(N)="SERIES_NUMBER|"_SERIESNUM
 . . . . S SERIESARRAY(SERIESNUM)=""
 . . . . Q
 . . . S MAGTI=""
 . . . F  S MAGTI=$O(^TMP("MAG",$J,"TI",MAGTI)) Q:'MAGTI  D
 . . . . S N=N+1,@OUT@(N)=^TMP("MAG",$J,"TI",MAGTI)
 . . . . Q
 . . . K ^TMP("MAG",$J,"TI")
 . . . Q
 . . Q
 . S I="" F  S I=$O(^TMP("MAG",$J,"S",I)) Q:I=""  D
 . . S N=N+1,@OUT@(N)="UNUSED_GROUP_INFO|"_^TMP("MAG",$J,"S",I)
 . . Q
 . K ^TMP("MAG",$J,"S")
 . K ^TMP("MAG",$J,"M")
 . Q
 D  ; list all modalities
 . N M,X
 . S X="",M="" F  S M=$O(STUMO(M)) Q:M=""  S X=X_$S(X'="":",",1:"")_M
 . S:X'="" N=N+1,@OUT@(N)="STUDY_MODALITY|"_X
 . Q
 Q
 ;
ONEGROUP(GROUP) ; Get the first IMAGE_IEN for this group
 N D1,IMGIEN
 I '$D(^MAG(2005,GROUP,1)) Q GROUP ; a single image (e.g., photo ID), not a group
 S IMGIEN=""
 S D1=$O(^MAG(2005,GROUP,1,0))
 I D1>0 S IMGIEN=+$G(^MAG(2005,GROUP,1,D1,0))
 I IMGIEN'>0 S IMGIEN="0^Error 1 - First Image not available"
 Q IMGIEN
 ;
CPTCODE(MAGIEN) ; Returns CPT code by IEN (image pointer) in IMAGE file (#2005) 
 ; MAGIEN = IEN in IMAGE file (#2005)
 N RAIEN,CPTCODE
 S RAIEN=+$$GET1^DIQ(2005,MAGIEN,62,"I")  ; Get PACS PROCEDURE field #62
 S CPTCODE=$P($G(^RAMIS(71,RAIEN,0)),"^",9) ; IA # 1174  get CPT Code
 Q:CPTCODE="" ""  ; quit with empty code
 S CPTCODE=$$CPT^ICPTCOD(CPTCODE) ; IA # 1995, supported reference
 Q $P(CPTCODE,"^",2) ; Return the code
 ;
GETSITE1(MAGIEN) ; Returns STATION NUMBER where the image is stored
 ; MAGIEN = IEN in IMAGE file (#2005)
 N MAGNODE,TMP,NLOCIEN,PLC
 N SITEIEN,SITENUM
 I MAGIEN'>0 Q ""
 D:'$D(MAGJOB("NETPLC")) NETPLCS^MAGGTU6 ; Initialize MAGJOB("NETPLC")
 S MAGNODE=$$NODE^MAGGI11(MAGIEN)
 I MAGNODE="" Q ""
 S TMP=$G(@MAGNODE@(0))
 S NLOCIEN=+$S($P(TMP,U,3):$P(TMP,U,3),1:$P(TMP,U,5)) ; Get IEN in NETWORK LOCATION file (#2005.2)
 S PLC=$P($G(MAGJOB("NETPLC",NLOCIEN)),U,1)     ; Imaging Site Parameters IEN
 Q $$GETSNUM(PLC)  ; Return STATION NUMBER
 ;
GETSNUM(MAGPLC) ; Returns STATION NUMBER by Image Site Parameters IEN
 ; MAGPLC - IEN in IMAGING SITE PARAMETERS file (#2006.1)
 I MAGPLC'>0 Q ""
 N SITEIEN,SITENUM
 S SITEIEN=$P($G(^MAG(2006.1,MAGPLC,0)),U,1)    ; Get Station IEN in INSTITUTION file (#4)
 Q:SITEIEN="" ""  ; if SITE IEN is not defined return blank
 S SITENUM=$P($$NS^XUAF4(SITEIEN),U,2)      ; IA #2171  Get Station Number
 Q SITENUM
 ;
REGIONAL(I0) ;ISI check if image is regional :=1
 N LOC S LOC=+$P($G(^MAG(2005,+$G(I0),0)),"^",3)
 Q $G(^MAG(2005.2,LOC,"REGIONAL"))
 ;
