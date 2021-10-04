ZZFMVIEW ; HOIFO/WAA/AA - GUI INTERFACE ROUTINE ; 23/08/2012 11:54
 ;;1.16;ZZFMVIEW;;MAY 2018
 ; based on MD* routines
 ;
RPC(RESULT,OPTION,ARRAY) ; RPC processing entry point
 ; 
 I $$VALIDOPT(OPTION)=0 S RESULT(0)="-1^Option "_OPTION_" is not supported by this RPC" Q
 D CLEAN^DILF
 S RESULT=$NA(^TMP("ZZFM00",$J)) K @RESULT
 I '($T(@OPTION)]"") S RESULT(0)="-1^Option '"_OPTION_"' not found in routine '"_$T(+0)_"'." Q
 D @OPTION
 I '$D(RESULT(0)) S RESULT(0)="-1^Unspecified Error"
 K ^TMP("ZZFM00",$J)
 D CLEAN^DILF
 Q
 ;
VALIDOPT(OPTNAME) ;
 ; option name validator
 N G,OUT,FOUND S G="",OUT=0,FOUND=0
 F I=1:1 D  Q:OUT=1
 . S G=$T(HELP+I)
 . S:G["VALID OPTIONS LIST START" FOUND=1
 . S:G["VALID OPTIONS LIST END" OUT=1,G=""
 . Q:'FOUND
 . S:$E(G,1,3)=" ;;" G=$P(G,";;",2),G=$P(G," ")
 . S:G="" OUT=1
 . I (G'="")&(OPTNAME=G) S OUT=1
 Q (G'="")&(OPTNAME=G)
 ;
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; GENERAL OPTIONS
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;
NULL ;
 S RESULT(0)="0^NULL"
 Q
 ; 
VERSION ;
 S RESULT(0)="1",RESULT(1)=$P($T(+2),";",3)
 Q
 ; 
ECHO ;
 N G,OUT S G="",OUT=0
 F I=1:1 D  Q:OUT=1
 . S G=$O(ARRAY(G))
 . S:G="" OUT=1
 . S:G'="" RESULT(G)=ARRAY(G)
 Q
 ;
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; OPTIONS COMMON FOR FMVIEW AND FMCOMPARE
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;
OS ;
 I $D(^%ZOSF("OS")) S RESULT(0)=$G(^%ZOSF("OS"))
 E  S RESULT(0)="Unknown"
 Q
 ;
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; ROUTINES
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
REXISTS ; Verifies if the routine exists
 ;
 S X=ARRAY(0) X ^%ZOSF("TEST") I '$T S RESULT(0)="-1^Routine "_ARRAY(0)_" not found" Q
 E  S RESULT(0)="0^"_ARRAY(0)_" found"
 Q
 ;  
RSOURCE ; Returns Routine Source
 ; based on MD* routines
 N DIF,X,XCNP,ZZNAME
 S ZZNAME=ARRAY(0)
 S X=ZZNAME X ^%ZOSF("TEST") I '$T S RESULT(0)="-1^Routine "_ARRAY(0)_" not found" Q
 K ^TMP("ZZAAED",$J)
 S XCNP=0,DIF="^TMP(""ZZAAED"",$J,",X=ZZNAME
 X ^%ZOSF("LOAD")
 S RESULT(0)=XCNP-1
 F X=1:1:RESULT(0)  S RESULT(X)=^TMP("ZZAAED",$J,X,0)
 I '$D(RESULT) S RESULT(0)="-1^Unspecified Error"
 E  S RESULT(0)=RESULT(0)
 Q
 ;
RLIST ;Modifcation-adding GTm to RLIST 01062016 jeb
 ; Returns list of routines from a given starting point to and end range of x
 I $G(^%ZSOSF("OS"))["GTM"!(+$P($G(^%ZOSF("OS")),"^",2)=19) D  Q
 . N X,I,cnt,%ZE,%ZR,ctrapd,delim,exc,from,k,last,mtch,out,r,rd,N,add,beg,end,i,k,last,mtch,pct,scwc
 . F I=1:1:5 S X=$T(SRC+I^%RSEL) X X
 . D init^%RSEL
 . k stack
 . s mtch="__" d start^%RSEL(0)
 . S %ZR=ARRAY(0)
 . D work^%RSEL
 . K RESULT
 . S cnt=0
 . S N="" F I=1:1 S N=$O(%ZR(N)) Q:N=""  S RESULT(I)=N_"^"_%ZR(N)_N_".m",cnt=cnt+1
 . S RESULT(0)=cnt
 . K %ZR,^%RSET($j)
 ;
 S ZZAAR="F  S X=$O(^$ROUTINE(X)) Q:$L(X)=0  S CNT=CNT+1,RESULT(CNT)=X I Y>0 Q:Y=CNT"
 N X,Y,CNT
 S CNT=0,X=ARRAY(0)
 S:X["*" X=$P(X,"*")
 S X=$O(^$R(ARRAY(0)),-1),Y=ARRAY(1)
 X ZZAAR
 S RESULT(0)=CNT
 Q
 ; 
RCHKSUM ; Returns routine list with checksums based on provided target. 
 N I,J
 S J=ARRAY(0)
 F I=1:1:ARRAY(0) D
 . S X=ARRAY(I) 
 . X ^%ZOSF("TEST") 
 . I $T X ^%ZOSF("RSUM") S RESULT(I)=X_"^"_Y_"^"_$$LOAD2L(X)
 . I '$T S RESULT(I)=X_"^?"
 S RESULT(0)=ARRAY(0)_"^rtName~rtChecksum~rtLine~rtLine"
 Q
LOAD2L(X)  ;Load routine first lines
 N DIF,XCNP,R K ^TMP($J)
 S DIF="^TMP($J,",XCNP=0,R="" X ^%ZOSF("LOAD")
 I $D(R) S R=$G(^TMP($J,1,0))_"~"_$G(^TMP($J,2,0))
 K ^TMP($J)
 Q R 
 ;
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; GLOBALS LISTER
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;
LISTGLBL ;
 ;from a given starting point (ARRAY(0)) to and end range of x (ARRAY(1))
 N I,FOUND,G,NODE,J
 S I=0,FOUND=0,J=1
 S NODE=ARRAY(0)
 S G=$D(@NODE),RESULT(0)="-1^Global "_NODE_" Not found"
 ;Q:'G
 I G#10=1 D SHOW
 F I=1:1:ARRAY(1) S NODE=$Q(@NODE) Q:NODE=""  D SHOW
 I 'FOUND Q
 S RESULT(0)=I_"|"_NODE
 Q
SHOW ; Local. Not used as an OPTION
 ;S RESULT(J)=$D(NODE)_"|"_NODE_"|"_@NODE,FOUND=1,J=J+1
 S J=J+1,RESULT(J)=J-1_"|"_NODE_"|"_@NODE,FOUND=1 ;,J=J+1
 Q
 ; 
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; FileMan Files
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;
FMFNAME ;
 ;File global name and header by file number
 N FNAME,GNAME
 S RESULT(0)="-1^File "_ARRAY(0)_" Not found"
 Q:$$VFILE^DILFD(ARRAY(0))=0
 S GNAME=$G(^DIC(ARRAY(0),0,"GL"))
 Q:GNAME=""
 S RESULT(0)=2,RESULT(1)=GNAME
 S:$D(@($$ROOT^DILFD(ARRAY(0),,0)_"0)"))#10'=0 RESULT(2)=@($$ROOT^DILFD(ARRAY(0),,0)_"0)")
 Q
 ;
FFCHAR(FNUM,FFNUM,CHAR) ; 
 ; internal. Used by FMFLDDEF. Field Char by File (FNUM) and Field (FFNUM)
 N FFC  S FFC=""
 S:$D(^DD(FNUM,FFNUM,CHAR))#10=1 FFC=FNUM_"^"_FFNUM_"^"_CHAR_"^"_^DD(FNUM,FFNUM,CHAR)
 Q FFC
 ;
FMFLDDEF ; Local, not an OPTION name
 ; internal. Used by FMFIELDS. Field FFNUM Characteristics for file FNUM
 F I=0,".1",1,2,3,4,5,7.5,8,9,9.01,9.02,9.03,9.04,9.05,9.06,9.07,9.08,9.09,10,11,10,12.1,20,21,22,23 D
 .S FC=$$FFCHAR(FNUM,FFNUM,I)  S:FC'="" IND=IND+1,RESULT(IND)=FC
 F I="AUDIT","AX","DEL","DT","LATGO" D
 .S FC=$$FFCHAR(FNUM,FFNUM,I)  S:FC'="" IND=IND+1,RESULT(IND)=FC
 Q
 ;
FMFIELDS ;
 ; Characteristics of all Fields of the FileMan file FNUM
 N G,FC,I,IND S G="0",IND=0,FNUM=ARRAY(0)
 F  S G=$O(^DD(FNUM,G))  Q:G=""  S FFNUM=G D FMFLDDEF
 S RESULT(0)=IND
 Q
 ;
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; OPTIONS FOR FMVIEW ONLY
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; 
FMFFLDS ;
 ; Fields of the FileMan file
 N I,G S G=".01",I=1,RESULT(1)=".01"
 F  S G=$O(^DD(ARRAY(0),G))  Q:G=""  S I=I+1  S RESULT(I)=G
 S RESULT(0)=I
 Q
 ;
FDICCHAR(FNUM,CHAR) ;
 ; internal function used by FCHARS option
 N FDC  S FDC=""
 S:$D(^DIC(FNUM,0,CHAR))#10=1 FDC=$J(CHAR,10)_" : "_^DIC(FNUM,0,CHAR)
 Q FDC
 ;
FCHAR(FNUM,CHAR) ;
 ; internal function used by FCHARS option
 N FC  S FC=""
 S:$D(^DD(FNUM,0,CHAR))#10=1 FC=$J(CHAR,10)_" : "_^DD(FNUM,0,CHAR)
 Q FC
 ;
FMFCHRS ;
 ; FileMan FIle characteristics
 N F,P1,I
 S P1=ARRAY(0),I=0
 S:$D(^DIC(P1,0))'=0 RESULT(I)="0^FILE "_P1_" CHARS",I=I+1
 ;
 F J="ACT","DDA","DIC","SCR","VR","VRPK","VRRV" D
 . S F=$$FCHAR(P1,J)  S:F'="" RESULT(I)=F,I=I+1
 ;
 S:$D(^DD(P1,0,"ID","WRITE"))#10=1 RESULT(I)=^DD(FNUM,0,"ID","WRITE"),I=I+1
 ;
 F J="GL","AUDIT","DD","DEL","LAYGO","RD","WR" D
 . S F=$$FDICCHAR(P1,J)  S:F'="" RESULT(I)=F,I=I+1
 ;
 S:$D(^DIC(P1,"%"))#10=1 RESULT(I)="Application Group: <"_^DIC(P1,"%")_">",I=I+1
 S:$D(^DIC(P1,"%A"))#10=1 RESULT(I)="DUZ file creation date: <"_^DIC(P1,"%A")_">",I=I+1
 S:$D(^DIC(P1,"%D"))#10=1 RESULT(I)="Description: <"_^DIC(P1,"%D")_">",I=I+1
 ;
 S RESULT(0)=I-1
 Q
 ;
FMFINDXS ;
 ; index names by file number
 N G,I,P1 S G="",I=0,P1=ARRAY(0)
 F  S G=$O(^DD(P1,0,"IX",G))  Q:G=""  S I=I+1  S RESULT(I)=G
 S RESULT(0)=I
 Q
 ;
FMFIELD ;
 ; Characteristics of the one Field FFNUM of the FileMan file FNUM
 N FC,IND S IND=0,FNUM=ARRAY(0),FFNUM=ARRAY(1)
 D FMFLDDEF
 S RESULT(0)=IND ; total number of records
 Q
 ;
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; ROUTINES EDITING
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;
RSAVE ; 
 ;RSAVE ; This subroutine will save a routine to M from the indicated array
 ;  The routine name and line count should be provided in the first record of array as
 ;  RoutineName^LineCount
 N X,XCN,DIE,CNT,ROU,ZZNAME,ZZCOUNT,FLG
 S ZZRNAME=$P(ARRAY(0),"^"),ZZCOUNT=$P(ARRAY(0),"^",2)
 S RESULT(0)="1^PROBLEM WITH ROUTINE NAME or LINE COUNT: "_ARRAY(0)
 ;Q:AUDREY="" ;not defined to generate error and test reconnection of GUI 
 Q:ZZRNAME=""
 Q:ZZCOUNT<1
 S CNT=0,XCN=0,ROU="ROU",FLG=0
 F I=1:1:ZZCOUNT S:ARRAY(I)'="" ^UTILITY($J,"ROU",I,0)=ARRAY(I) I ARRAY(I)="" S RESULT(0)="2^BLANK LINE "_I_" FOUND",FLG=1 Q
 I FLG Q
 I I'=ZZCOUNT S RESULT(0)="3^BAD LINE COUNT" Q
 S DIE="^UTILITY($J,"_ROU_",",X=ZZRNAME
 X ^%ZOSF("SAVE")
 I $D(^UTILITY(ROU,ZZRNAME)) S CNT=1
 K ^UTILITY(ROU,ZZRNAME),^UTILITY($J,ROU)
 S RESULT(0)="0^"_ZZRNAME_" SAVED"
 Q
 ;
RDELETE ; This subroutine will delete a routine from M
 ;
 N DIF,X,XCNP
 S RESULT(0)="1^FAILED"
 S X=ARRAY(0)
 X ^%ZOSF("DEL")
 S RESULT(0)="0^"_ARRAY(0)_" DELETED"
 Q
 ; 
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;
TEST ; Use TEST^ZZFMVIEW as the debug target in Studio
 ;
 N ZZAND,ZZAA
 ;D RPC(.ZZAND,"XXX",.ZZAA)
 ;D RPC(.ZZAND,"HELP")
 ;D RPC(.ZZAND,"VERSION")
 ;S ZZAA(0)="ECHO TEST Line 1",ZZAA(1)="ECHO TEST Line 2" D RPC(.ZZAND,"ECHO",.ZZAA)
 Q
 ;
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; HELP and SAMPLES
 ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;
HELP ;
 ; Description and samples
 N G,OUT,J,I S G="",OUT=0,J=1
 F I=1:1 D  Q:OUT=1
 . S G=$T(HELP+9+I)
 . S:G="" OUT=1
 . S:G["HELP END" OUT=1
 . S:(G'="")&($E(G,1,3)=" ;;") RESULT(J)=$P(G,";;",2),J=J+1
 S RESULT(0)=(J-1)
 Q
 ;*****************************************************************
 ;* Lines not started with " ;;" are not included in the output 
 ;*****************************************************************
 ;*
 ;;This RPC provides data for ZZFMVIEW GUI
 ;;RPC requires 2 parameters and returns the result array
 ;;
 ;;Input parameters
 ;;  - OPTION (#1: literal, size=8, required)
 ;;  - ARRAY  (#2: array, size=32000, optional)
 ;;
 ;;  OPTION literal defines action to execute
 ;;  ARRAY contains additional parameters required by OPTION
 ;;
 ;;Output
 ;;The first line of the results array RESULT contains number of lines returned
 ;;the rest of the result array contains data if any:
 ;;
 ;;    RESULT(0)=RC
 ;;    RESULT(1)=data_1
 ;;    RESULT(2)=data_2
 ;;    ...
 ;;    RESULT(RC)=data_RC 
 ;;
 ;;Zero or positive RC identifies the last index of the RESULT array
 ;;For negative RC description of the error is in the second piece ("^" delimeter) of the RESULT(0)  
 ;;
 ;;The next actions (OPTIONS) are supported by this version:
 ;*** VALID OPTIONS LIST STARTS HERE ***
 ;;HELP     - this text
 ;;NUL      - returns "0^NULL"
 ;;VERSION  - returns version of the RPC 
 ;;ECHO     - returns array sent as the parameter
 ;
 ;;REXISTS  - verifies if the routine exists
 ;;RLIST    - lists routines matchiing target
 ;;RSOURCE  - returns source code of routine
 ;;RSAVE    - saves routine by name
 ;;RDELETE  - delets routine by name
 ;
 ;;FMFNAME  - file global name and info by file number
 ;;FMFFLDS  - fields of the file. Field numbers only
 ;;FMFCHRS  - file chars
 ;;FMFINDXS - file index names
 ;
 ;;FMFIELD  - one field definitions
 ;;FMFIELDS - all file fields with field definition
 ;
 ;;LISTGLBL - List Global
 ;;LISTGR   - List Global in reverse
 ;;LISTGR1
 ;;DIM
 ;;ECHO0
 ;
 ;;RCHKSUM  - Checksum of list of routines
 ;
 ;FMFDATA   - file records - logic error!
 ;FILELIST - list of files - should be verfied - logic error!
 ;
 ; FMCOMPARE - OPTIONS VALID FOR FMCOMPARE
 ;
 ;;OS       - OS
 ;;FMCSETUP - FMC setup data
 ;
 ;*** VALID OPTIONS LIST ENDS HERE *** ;;
 ;;Examples
 ;;
 ;;Unknown option XXX
 ;;     D RPC(.ZZAND,"XXX",.ZZAA)
 ;;     - returns negative RC and description of error
 ;;
 ;;     ZZAND(0)="-1^Option XXX is not supported by this RPC"
 ;;
 ;;HELP 
 ;;     D RPC(.ZZAND,"HELP")
 ;;     - returns contents of the HELP. First line of the result array contains number of the lens returned (64)
 ;;
 ;;     ZZAND(0)="64"
 ;;     ZZAND(1)="This RPC...
 ;;     ...
 ;;     ZZAND(64)=""
 ;;
 ;;VERSION 
 ;;     D RPC(.ZZAND,"VERSION")
 ;;     - returns the RPC implementation version
 ;;
 ;;     ZZAND(0)="1"
 ;;     ZZAND(0)="1.2"
 ;;
 ;;ECHO
 ;;     S ZZAA(0)="ECHO TEST Line 1",ZZAA(1)="ECHO TEST Line 2" D RPC(.ZZAND,"ECHO",.ZZAA)
 ;;     - returns the array as it was received by the RPC
 ;;
 ;;     ZZAND(0)="ECHO TEST Line 1"
 ;;     ZZAND(1)="ECHO TEST Line 2" 
 ;;     
 ;;
 ;;RSOURCE
 ;;     S ZZAA(0)="ZZFMVIEW" D RPC(.ZZAND,"RSOURCE",.ZZAA)
 ;;     - returns source code of the "ZZFMVIEW" routine
 ;;
 ;;     ZZAND(0)="361"
 ;;     ZZAND(1)="ZZFMVIEW...
 ;;     ...
 ;;     ZZAND(361)="...
 ;;
 ;;RSAVE
 ;;     S ZZAA(0)="ZZRPCV1^3",ZZAA(1)="Line One",ZZAA(2)="Line TWO",ZZAA(3)="Line Three"
 ;;     D RPC(.ZZAND,"RSAVE",.ZZAA)
 ;;     - saves 3 lines in "ZZRPCV1"
 ;;
 ;;     ZZAND(0)="0^ZZRPCV1 SAVED"
 ;;
 ;RDELETE
 ;     S ZZAA(0)="ZZRPCV1"
 ;     D RPC(.ZZAND,"RDELETE",.ZZAA)
 ;     - deletes "ZZRPCV1"
 ;       returns confirmation
 ;
 ;     ZZAND(0)="0^ZZRPCV1 DELETED"
 ;
 ;;FMFNAME  
 ;;    S ZZAA(0)="1" D RPC(.ZZAND,"FMFNAME",.ZZAA)
 ;;    - returns file "1" description
 ;;
 ;;    ZZAND(0)=2
 ;;    ZZAND(1)="^DIC("
 ;;    ZZAND(2)="FILE^1^9999999.64^2366" 
 ;;
 ;;- file global name and info by file number
 ;;
 ;;FMFFLDS
 ;;    S ZZAA(0)="1" D RPC(.ZZAND,"FMFFLDS",.ZZAA)
 ;;    - returns fields of the file "1". Field number only:
 ;;
 ;;    ZZAND(0)=26
 ;;    ZZAND(1)=.01
 ;;    ZZAND(2)=1
 ;;    ...
 ;;    ZZAND(26)="SB"
 ;;
 ;;FMFCHARS
 ;;    S ZZAA(0)="1" D RPC(.ZZAND,"FMFCHRS",.ZZAA)
 ;;    - file "1" characteristics
 ;;
 ;;    ZZAND(0)=6
 ;;    ZZAND(1)="        VR : 22.0"
 ;;    ZZAND(2)="        GL : ^DIC("
 ;;    ZZAND(3)="        DD : ^"
 ;;    ZZAND(4)="     LAYGO : ^"
 ;;    ZZAND(5)="        RD : ^"
 ;;    ZZAND(6)="        WR : ^"
 ;;
 ;;FMFINDXS
 ;;    S ZZAA(0)="1" D RPC(.ZZAND,"FMFINDXS",.ZZAA)
 ;;    - indexes defined for the file "1"
 ;;
 ;;    ZZAND(0)=4
 ;;    ZZAND(1)="AC"
 ;;    ZZAND(2)="AD"
 ;;    ZZAND(3)="AE"
 ;;    ZZAND(4)="B"
 ;;
 ;;FMFIELDS
 ;;    S ZZAA(0)="1" D RPC(.ZZAND,"FMFIELDS",.ZZAA)
 ;;    - field definitions for the file "1".
 ;;    NOTE that definition of one field may be presented in several lines:
 ;;
 ;;    ZZAND(0)=30
 ;;    ZZAND(1)="1^.001^0^NUMBER^N^^ ^K:X<2!$D(^DD(X)) X I $D(X),$D(^VA(200,DUZ,1))#2,$P(^(1),U)]"""" I X<$P(^(1),""-"")!(X>$P($P(^(1),U),""-"",2)) K X"
 ;;    ZZAND(2)="1^.001^4^W !?5,""Enter an unused number"" I $D(^VA(200,DUZ,1)),$P(^(1),U)]"""" W "" within the range, "",$P(^(1),U)"
 ;;    ZZAND(3)="1^.01^0^NAME^RF^^0;1^K:$L(X)>45!($L(X)<3) X"
 ;;    ZZAND(4)="1^.01^3^3-45 CHARACTERS"
 ;;    ZZAND(5)="1^1^0^GLOBAL NAME^CJ14^^ ; ^S X=$S($D(^DIC(D0,0,""GL"")):^(""GL""),1:"""")"
 ;;    ...
 ;;    ZZAND(29)="1^1819^9^^"
 ;;    ZZAND(30)="1^1819^9.01^"
 ;;
 ;;FMFIELD
 ;;    S ZZAA(0)="1",ZZAA(1)=".01" D RPC(.ZZAND,"FMFIELD",.ZZAA)
 ;;    - returns definition of field ".01" file "1"
 ;;
 ;;    ZZAND(0)=2
 ;;    ZZAND(1)="1^.01^0^NAME^RF^^0;1^K:$L(X)>45!($L(X)<3) X"
 ;;    ZZAND(2)="1^.01^3^3-45 CHARACTERS"
 ;;
 ;;
 ;;LISTGLBL
 ;;    S ZZAA(0)="^DIC(0)",ZZAA(1)=10 D RPC(.ZZAND,"LISTGLBL",.ZZAA)
 ;;    - returns list of 10 global nodes started from "^DIC(0)"
 ;;      the last node found is included in the ZZAND(0)
 ;;
 ;;    ZZAND(0)=10|^DIC(.11,""%D"",3,0)
 ;;    ZZAND(1)="1|^DIC(.11,0)|INDEX^.11"
 ;;    ZZAND(2)="1|^DIC(.11,0,""DD"")|^"
 ;;    ZZAND(3)="1|^DIC(.11,0,""DEL"")|^"
 ;;    ZZAND(4)="1|^DIC(.11,0,""GL"")|^DD(""IX"","
 ;;    ZZAND(5)="1|^DIC(.11,0,""LAYGO"")|^"
 ;;    ZZAND(6)="1|^DIC(.11,0,""WR"")|^"
 ;;    ZZAND(7)="1|^DIC(.11,""%D"",0)|^^5^5^2980911^"
 ;;    ZZAND(8)="1|^DIC(.11,""%D"",1,0)|This file stores information about new-style cross-references defined on a"
 ;;    ZZAND(9)="1|^DIC(.11,""%D"",2,0)|file. Whereas traditional cross-references are stored under the 1 nodes of"
 ;;    ZZAND(10)="1|^DIC(.11,""%D"",3,0)|the ^DD for a particular field, new-style cross-references are stored in"
 ;;
 ; HELP ENDS HERE ***********************************************************
 ;
FMCSETUP ;
 ; available objects and data types
 N G,OUT,J,I,II,SE,SS S G="",OUT=0,J=1,II=0
 S SS=ARRAY(0)_" BEGIN",SE=ARRAY(0)_" END"
 F I=1:1 D  Q:OUT=1
 . S G=$T(FMCSETUP+11+I)
 . S:G="" OUT=1
 . S:G[SE OUT=1
 . S:G[SS II=1
 . S:(G'="")&($E(G,1,3)=" ;;")&(II=1) RESULT(J)=$P(G,";;",2),J=J+1
 S RESULT(0)=(J-1)
 Q
 ;FMCPRV BEGIN - ID~RPC~OPTION~CAPTION~DESCRIPTION
 ;;1~ZZFMVIEW~RLIST~Routines~Routines compare 
 ;;2~ZZFMVIEW~FMLIST~FM Files~FileMan Files compare
 ;;3~ZZFMVIEW~GLOB~Globals~Globals compare
 ;FMCPRV END
 ;
 ;FMCTYPE BEGIN - ID~PROVIDER~NAME~CAPTION~DESCRIPTION
 ;;1~-1~COMMENT~Comments~Description of an item
 ;;2~2~FMFILE~FM File~IEN of FileMan file
 ;;3~1~ROUTINE~Routine~Name of routine
 ;;4~3~NODE~Node~FM File node
 ;;5~-1~CHKSUM~Checksum~Routine checksum
 ;;6~-1~SOURCE~Source~Routine source
 ;FMCTYPE END 
 ;
 ;FMCREQUIRED BEGIN
 ;;FMCSETUP
 ;;RLIST
 ;;RCHKSUM
 ;;LISTGLBL
 ;;LISTGR
 ;;RSOURCE
 ;;REXISTS
 ;;FMFNAME
 ;;FMFIELDS
 ;FMCREQUIRED END
 ;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; UNDER DEVELOPMENT
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;
FILELIST ;Returns List of files
 ;P1 (START): First file to find
 ;P2 (LIMIT): Number of files to return
 ;P3 (KEYLEN): Length of search key
 N G,I,J,P1,P2,P3
 S I=0,G=ARRAY(0),P1=ARRAY(0),P2=ARRAY(1),P3=ARRAY(2)
 I G="" F  S G=$O(^DD(G))  Q:G=""  Q:I=P2  S:G>0 RESULT(I+1)=G,I=I+1
 E  S:$D(^DD(G))'=0 RESULT(I)=G  F I=2:1:P2 D
 . S G=$O(^DD(G))
 . Q:$E(P1,1,P3)'=$E(G,1,P3)
 . S:G>0 RESULT(I+1)=G,I=I+1
 S RESULT(0)=I
 Q
 ;
FMFDATA ;
 ; FileMan File Data records.
 ; returns P3 records of file P1 starting from IEN>(P2-1)
 ;
 N G,I,J,P1,P2,P3
 S P1=ARRAY(0),P2=ARRAY(1),P3=ARRAY(2)
 Q:'$$VFILE^DILFD(P1)
 S G=$$ROOT^DILFD(P1,,1) ;File root
 S I=1,J=P2-1
 F  S J=$O(@G@(J))  Q:'J  Q:I=(P3+1)  D
 .S:$D(@G@(J,0)) RESULT(I)=J_"|"_@G@(J,0)
 .S I=I+1
 .S RESULT(I)="",I=I+1
 S RESULT(0)=I-1
 Q
 ;
 ;*WVEHR - 250001*
Q(V,D) ; Function to return $QUERY for variable V and direction D.
 ; Replacement for Reverse $Q Function
 ; 1/8/08 MLP
 ;This function can be called for $Query -- either forward or reverse.
 ;In place of $Q(V,D), use $$Q^ZDQ($NA(V),D)
 ;Note: the 2nd argument is optional.
 ;
 S D=+$G(D,1)
 Q:D=1 $Q(@V)         ;Forward $Q
 IF D'=-1 Q           ;Will cause error due to no argument.
 N S
TOP IF $QL(V)=0 Q ""     ;done if unsubscripted
BKU S S=$O(@V,-1)        ;backup to previous node on current level
 S V=$NA(@V,$QL(V)-1) ;remove last subscript
 IF S="" G DAT        ;go chk for data if backed up all the way
 S V=$NA(@V@(S))      ;add the subscript found when backing up.
 IF $D(@V)>9 S V=$NA(@V@("")) G BKU  ;if downpointer, descend and repeat
DAT IF $D(@V)#2=1 Q V    ;if a data node, return with current name
 G TOP
 ;
SHOW1 ; Local. Not used as an OPTION
 S RESULT(J)=J_"|"_NODE_"|"_@NODE,FOUND=1,J=J+1
 Q
 ; 
LISTGR ;
 ;Lists global. ARRAY(0) -starting node, ARRAY(1) -Nodes to return, ARRAY(2) - Direction
 N I,FOUND,G,NODE,J,DIR,CNT,II
 S I=0,FOUND=0,J=0,CNT=10,II=1
 S NODE=ARRAY(0),DIR=-1 ; default direction 
 I $G(ARRAY(1)) S CNT=ARRAY(1) ; set default count
 I $G(ARRAY(2)) S DIR=ARRAY(2) ; set direction if specified
 S G=$D(@NODE),RESULT(0)="-1^Global "_NODE_" Not found"  ;_"DIR="_DIR
 I G#10=1 S J=1,II=2 D SHOW1
 Q:II>CNT
 ;F I=1:1:CNT S NODE=$$Q^VWUTIL($NA(@NODE),DIR) Q:NODE=""  D SHOW1
 ;F I=1:1:CNT S NODE=$$Q($NA(@NODE),DIR) Q:NODE=""  D SHOW1
 F I=II:1:CNT S NODE=$$NODEUP(NODE) Q:NODE=""  D NDSHOW(NODE)
 I 'FOUND Q
 S RESULT(0)=J-1_"|"_NODE
 Q
 ; 
NDSHOW(NODE) 
 Q:'$D(NODE)
 S RESULT(J)=J_"|"_NODE
 I $D(NODE)#2=1 S RESULT(J)=RESULT(J)_"|"_@NODE
 S J=J+1 
 Q
 ;
NDNAME(NODE,X) ; Replaces last subscript of NODE with X
 N TMP
 S TMP=$NA(@NODE,$QL(NODE)-1)
 Q $NA(@TMP@(X))
 ;
NDDOWN(NODE,NDLIMIT) ; Finds next node starting with NODE up to LIMIT 
 N TMP,TMPOLD,I,III
 S TMPOLD=NODE,TMP=$Q(@NODE),III=2000
 I TMP=NDLIMIT Q TMPOLD
 F I=1:1:III Q:(TMP="")!(TMP=NDLIMIT)  D
 . S TMPOLD=TMP,TMP=$Q(@TMP)
 .; S RESULT(J)="    NDLIMIT="_NDLIMIT_" TMPOLD="_TMPOLD_" TMP="_TMP,J=J+1
 I I=III S RESULT(J)="!!!",J=J+1 ; debug
 Q TMPOLD
 ;
NODEUP(NODEIN) ; 
 N TMP,NN,TMPN,NDLIMIT
 S TMPN=NODEIN,NDLIMIT=NODEIN,TMP=""
START 
 ;S RESULT(J)="  TMPN="_TMPN,J=J+1
 S TMP=$O(@TMPN,-1)       ; same level prev subscript
 ;S RESULT(J)="  * TMPN="_TMPN_" TMP="_TMP_" $O(TMPN,-1)="_$O(@TMPN,-1),J=J+1
 I TMP'="" S TMP=$$NDNAME(TMPN,TMP) Q $$NDDOWN(TMP,TMPN)  ; not blank - find down
 I $QL(TMPN)=1 Q "" ; quit if it is the first level        ; blank. leave if first one
 S NN=$NA(@TMPN,$QL(TMPN)-1)   ; level up 
 I $D(@NN)#10=1 Q $$NDDOWN(NN,NDLIMIT) ; check if the node exists
 S TMP=$O(@NN,-1)              ; prev subscript 
 ;S RESULT(J)="    NN="_NN_" $O(@NN,-1)="_$O(@NN,-1),J=J+1 
 I TMP="" S TMPN=NN G START    ; if blank - search on prev level
 I TMP'="" D                   ; not blank - search down
 .; S RESULT(J)="  NN="_NN_" TMP="_TMP_" $$NDNAME(NN,TMP)="_$$NDNAME(NN,TMP),J=J+1 
 . S NN=$$NDNAME(NN,TMP),TMP=$$NDDOWN(NN,NDLIMIT)
 Q TMP
 ;
DIM ; Code validation
 N G,OUT,L,C,IND S G="",OUT=0,C="",IND=""
 F I=1:1 D  Q:OUT=1 
 . S G=$O(ARRAY(G))
 . I G="" S OUT=1
 . I G'="" D 
 . . S X=ARRAY(G),C=ARRAY(G),IND=G,L=""
 . . S RESULT(IND)="IND="_IND_"  "_L_" code: """_C_""""
 . . D ^DIM
 . . I '$D(X) S L="Invalid "
 . . E  S L="  Valid "
 . . S RESULT(IND)=RESULT(IND)_"  ---- "_L
 Q
 ;
ECHO0 ;
 N G,OUT,II S G="",OUT=0,II=1
 F I=1:1 D  Q:OUT=1
 . S G=$O(ARRAY(G))
 . S:G="" OUT=1
 . S:G'="" RESULT(G)=ARRAY(G)
 Q
