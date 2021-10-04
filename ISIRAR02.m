ISIRAR02 ;ISI/BT RAD Report ;4/5/2016  14:08
 ;;1.0;ISI RAD Report RPCs;**local**;April 5,2016;Build 1
 ;
 QUIT
 ;
 ; ##### Given RAD Standard Report IEN(s), return the Impression and Report text
 ; 
 ; INPUT
 ;   ISIIENS      = RAD Standard Report IENs ("^" delimited)
 ;                  Example : 1^2^3
 ; OUTPUT
 ;   ISIOUT       = Global Array contains all of RAD 'Standard' reports
 ;   ISIOUT(1)    = Number of Records or 0^Error Message
 ;   ISIOUT(2..n) = Text Type (I = IMPRESSION, R = REPORT TEXT ^ Report IEN ^ Text
 ;                  Example: 
 ;                  I^1^impression line 1 for standard 1
 ;                  I^1^impression line 2 for standard 1
 ;                  I^1
 ;                  I^2^impression line 1 for standard 2
 ;                  I^2
 ;                      :
 ;                  R^1^report text line 1 for standard 1
 ;                  R^1^report text line 2 for standard 1
 ;                  R^1
 ;                  R^2^report text line 1 for standard 2
 ;                  R^2
 ;                      :
GETSTDTX(ISIOUT,ISIIENS) ;RPC [ISI GET RAD STANDARD TEXT]
 S ISIOUT=$NA(^TMP("ISIRAR02",$J))
 K @ISIOUT
 ;
 ; -- transform IENS ("^" delimited to array)
 N IDX,RAIEN,RAIENS
 F IDX=1:1:$L(ISIIENS,U) S RAIEN=+$P(ISIIENS,U,IDX) S:RAIEN RAIENS(RAIEN)=""
 I '$D(RAIENS) S @ISIOUT@(1)=0_U_"At least one 'Standard' Report IEN required" QUIT
 ;
 ; -- compile Impression and Report text sections. Add blank line between reports
 N CNT S CNT=0
 N FIL S FIL=74.1
 N RTYPES S RTYPES("I")=300,RTYPES("R")=200
 N TYP,WP
 ;
 F TYP="I","R" D
 . S RAIEN=0
 . F  S RAIEN=$O(RAIENS(RAIEN)) Q:'RAIEN  D
 . . K WP S WP=$$GET1^DIQ(74.1,RAIEN,RTYPES(TYP),,"WP")
 . . S WP=0 F  S WP=$O(WP(WP)) Q:'WP  S CNT=CNT+1,@ISIOUT@(CNT+1)=TYP_U_RAIEN_U_WP(WP)
 . . S CNT=CNT+1,@ISIOUT@(CNT+1)=TYP_U_RAIEN
 ;
 I 'CNT S @ISIOUT@(1)=0_U_"No text for the selected 'Standard' Report IEN(s)" QUIT
 S @ISIOUT@(1)=CNT
 QUIT
