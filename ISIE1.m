ISIE1 ;ISI/GEK,SAF - ImageList Group functions.
 ;;1.0;ISI IMAGING;;July 2012;Build 2
 ;
 Q
 ;+++ ISI ECG List Group entries.
ISIP1(MAGDATA,MISCPRMS) ;
 N ECG
 ;;;W "MISCPRMS : " ZW MISCPRMS
 S ECG=$$ISECG(.MISCPRMS)
 I 'ECG W !,"NOT ECG" Q
 ;;;W !,"is ECG , Yes"
 N IGL,ICT
 S ICT=1 ; set to 1, so really start at 2, 0 and 1 are set with headings.
 S IGL=$NA(^TMP($J,"ISIE1")) 
 K @IGL    ;fix for issue where the ECG list wasn't getting cleared between patients
 N IID,IIX,IIY
 N IIGN,IIG1,IIG2
 N GRP,CH1,CH2,CHIEN,CHSD,CHDT
 ; THIS IS TESTING.
 I $G(GEKCT) M ^GEKISI(GEKCT,"YMAGDATA")=@MAGDATA
 S I="" 
 F  S I=$O(@MAGDATA@(I)) Q:'I  D  ;
 . S IID=$G(@MAGDATA@(I))
 . S IIY=$P(IID,"|",2)
 . S IIX=$P(IIY,"^",6)
 . ;;;W !,"I: ",I,"    IIX: ",IIX
 . I IIX'=11 S ICT=ICT+1,$P(IID,"^",1)=ICT-1,@IGL@(ICT)=IID Q
 . I IIX=11 D  ; get each Group Image
 . . S IIGN=@MAGDATA@(I)
 . . S IIG1=$P(IIGN,"|",1)
 . . S IIG2=$P(IIGN,"|",2)
 . . S GRP=$P(IIG2,"^",1)
 . . S J="A"
 . . ;S J=0
 . . ;F  S J=$O(^MAG(2005,GRP,1,J)) Q:'J  D
 . . F  S J=$O(^MAG(2005,GRP,1,J),-1) Q:'J  D
 . . . S CHIEN=+$G(^MAG(2005,GRP,1,J,0))
 . . . S CH2=$$INFO^MAGGAII(CHIEN,"E")
 . . . ;;;W !,"CH2: ",J,"  ",CH2,!
 . . . S CH1=IIG1
 . . . S CHSD=$P(CH2,"^",4)
 . . . S CHDT=$P(CH2,"^",22)
 . . . S $P(CH1,"^",14)=CHDT
 . . . S $P(CH1,"^",7)=CHSD
 . . . S $P(CH1,"^",16)=CHIEN
 . . . S ICT=ICT+1,$P(CH1,"^",1)=ICT-1,@IGL@(ICT)=CH1_"|"_CH2
 . . . Q
 . . ;;
 . . Q
 . Q
 K @MAGDATA
 M @MAGDATA=@IGL
 I $G(GEKCT) M ^GEKISI(GEKCT,"ZMAGDATA")=@MAGDATA
 ;;;W !,"MAGDATA: " ZW MAGDATA W ! ZW @MAGDATA
 Q
ISECG(MISCPRMS) ; Is this filter the ECG filter
 N I,ECG,DAT 
 S I=""
 I $D(^ISI("NOGROUPIMAGES")) Q 0 
 S ECG=0
 F  S I=$O(MISCPRMS(I)) Q:I=""  D  ;
 . S DAT=MISCPRMS(I)
 . I DAT["IXPROC^^EKG" S ECG=1
 . Q
 Q ECG
 ;;
RESET ;TESTING
 K ^GEKISI
 Q
RESET2 ;TESTING
 K ^GEKTST
 Q
SAVE(CT) ;TESTING
 S CT=$G(CT)
 Q:'$D(^GEKISI(CT))
 M ^GEKTST(CT)=^GEKISI(CT)
 Q
 ;;;
TEST(CT) ;TESTING
 S CT=$G(CT) I 'CT W !,"Quitting" Q
 I '$D(^GEKTST(CT)) W !,"Quitting" Q
 ;
 N IFL,IFR,ITO,IMA,IMI,IOUT
 S IFL=$G(^GEKTST(CT,"FLAGS"))
 S IFR=$G(^GEKTST(CT,"FROMDATE"))
 S ITO=$G(^GEKTST(CT,"TODATE"))
 S IMA=$G(^GEKTST(CT,"MAXNUM"))
 M IMI=^GEKTST(CT,"MISCPRMS")
 ;;
 D GETIMGS^MAGSIXG1(.IOUT,IFL,IFR,ITO,IMA,.IMI)
 ;
 Q
DEBUG ;Testing, called from MAGSIXG1
 S GEKCT=$O(^GEKISI(""),-1)+1
 S ^GEKISI(GEKCT,"FLAGS")=$G(FLAGS)
 S ^GEKISI(GEKCT,"FROMDATE")=$G(FROMDATE)
 S ^GEKISI(GEKCT,"TODATE")=$G(TODATE)
 S ^GEKISI(GEKCT,"MAXNUM")=$G(MAXNUM)
 M ^GEKISI(GEKCT,"MISCPRMS")=MISCPRMS
 ; Only save 20.
 K ^GEKISI(GEKCT-20)
 Q
