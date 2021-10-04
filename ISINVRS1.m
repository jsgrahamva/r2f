ISINVRS1 ;ISI/JL,NST - Regional storage ; 17 June 2016 12:15 PM
 ;;1.0;ISI;**local**;Mar 19, 2002;Build 24;May 01, 2013
 ;;
 Q
NWRKITEM(MAGGDA) ;ISI - Create New MAG WORK ITEM
 ; MAGGDA - IEN of image in IMAGE file (#2005)
 ;
 N LOC S LOC=+$P($G(^MAG(2005,MAGGDA,0)),"^",3)
 Q:$G(^MAG(2005.2,LOC,"REGIONAL"))=1  ; Quit if Image is stored in Regional location
 ;
 N IEN,GB,GB2,GB100,DFN,ICN,J,OUT,TYPE,SUBTYPE,STATUS,PLACEID,PRIORITY,MSGTAGS,CRTUSR,CRTAPP,Y,DATCRTD,NOW
 S IEN=+$G(MAGGDA) Q:'IEN
 ; ISI/NST 06/17/2016 The code below doesn't work - it will loop all items. No need it for now 
 ;S (J,STATUS)=0
 ;F  S J=$O(^MAGV(2006.941,"H","imageIen",J)) Q:'J  S Y=$G(^MAGV(2006.941,J,4,2,0)) I $P(Y,U,2)=IEN S STATUS=1 Q
 ;Q:STATUS  ;IEN already exist
 S GB=$G(^MAG(2005,IEN,0)) Q:GB=""  Q:$P(GB,U,2)=""
 S TYPE="Storage",SUBTYPE="Process",STATUS="New",PRIORITY=0,DFN=$P(GB,U,7)
 S J=0,GB100=$G(^MAG(2005,IEN,100)),PLACEID=$P(GB100,U,3),PLACEID=$G(PLACEID,DUZ(2)) ;ACQ site
 S NOW=$$NOW^XLFDT()
 S DATCRTD=$TR($$FMTE^XLFDT(NOW\1,"7Z"),"/","-") ; yyy-mm-dd
 ; TAGS
 S J=J+1,MSGTAGS(J)="guid`"_PLACEID_"-"_IEN_"-"_NOW_"-"_$$UUID()
 S J=J+1,MSGTAGS(J)="dateCreated`"_DATCRTD
 S J=J+1,MSGTAGS(J)="siteId`"_PLACEID
 S J=J+1,MSGTAGS(J)="imageIen`"_IEN  ;IMAGE IEN
 S:$P(GB,U,10) J=J+1,MSGTAGS(J)="studyIen`"_$P(GB,U,10)   ;GRP IEN
 S:DFN J=J+1,MSGTAGS(J)="patientDfn`"_DFN
 I $L($T(GETICN^MPIF001)) S ICN=$$GETICN^MPIF001(DFN) S:ICN>1 J=J+1,MSGTAGS(J)="patientIcn`"_ICN
 S PLACEID=$$STA^XUAF4(PLACEID) ;IA # 2171
 S GB2=$G(^MAG(2005,IEN,2)),CRTUSR=$P(GB2,U,2),CRTUSR=$G(CRTUSR,DUZ)
 S CRTAPP=$P(GB2,U,12),CRTAPP=$S(CRTAPP="D":"DICOM",CRTAPP="C":"CAPTURE",1:"IMPORTER")
 D CRTITEM^MAGVIM01(.OUT,TYPE,SUBTYPE,STATUS,PLACEID,PRIORITY,.MSGTAGS,CRTUSR,CRTAPP)
 Q
 ;
UUID() ; generate a GUID using $R function
 N R,I,J,N
 S N=""
 F  S N=N_$R(100000) Q:$L(N)>64
 S R=""
 F I=1:2:64 S R=R_$E("0123456789abcdef",($E(N,I,I+1)#16+1))
 Q $E(R,1,8)_"-"_$E(R,9,12)_"-4"_$E(R,14,16)_"-"_$E("89ab",$E(N,17)#4+1)_$E(R,18,20)_"-"_$E(R,21,32)
