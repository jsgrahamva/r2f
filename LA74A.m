LA74A	;DALOI/JDB - LA*5.2*74 KIDS ROUTINE ;12/27/11  09:33
	;;5.2;AUTOMATED LAB INSTRUMENTS;**74**;Sep 27, 1994;Build 229
	;
	;CREATE^XUSAP/4677 (pending)
	;File 101/872
	;
	Q
	;
POST	;
	; KIDS Post install for LA*5.2*74
	N STR,LAACTN,LAX,LAMSG,X,I,Y,LAUSR,LARECS,LACNT
	N LA101,LANODE,LAFDA,LAIEN,DIERR
	K ^TMP("LA74-FMERR",$J)
	D BMES("*** Post install started ***")
	;
	; Is subfile #200.07 available
	K LAMSG,LAACTN
	S LAX=$$ROOT^DILFD(200.07,",1,",1,"LAMSG")
	I LAX="" D  ;
	. D BMES("Could not update special Lab Users (File #200.07 not defined).")
	; Set File #200 USER CLASS to APP PROXY for these users
	I LAX'="" D  ;
	. D BMES("USER CLASS update for Lab application proxy user:")
	. F LAUSR="LRLAB,HL","LRLAB,POC","LRLAB,TASKMAN" D  ;
	. . S X=$$APROXY(LAUSR)
	. . K STR
	. . S STR="    User "_LAUSR_" "_$S(X>0:"okay",1:" ** FAILED **")
	. . I X=-1 S STR=STR_" (not in File #200)"
	. . I X=-2 S STR=STR_" (db update failed)."
	. . S STR=STR_"."
	. . I $D(STR) D MES^XPDUTL($$CJ^XLFSTR(STR,$G(IOM,80)))
	. ;
	;
	; Insert #62.47 records from transport global
	S LAX=+$G(@XPDGREF@("LA6247",0))
	S LARECS(1)=LAX ;national
	S LARECS(2)=+$G(^TMP("LA74-LOCAL",$J,"6247",0)) ; local
	S LARECS(3)=+$G(^TMP("LA74-LOCAL-MAPPING",$J,"6247",0)) ; local mappings
	S LACNT=0
	S XPDIDTOT=LARECS(1)+LARECS(2)+LARECS(3)
	D BMES("Adding "_LAX_" record"_$S(LAX=1:"",1:"s")_" to File #62.47")
	D POP6247
	;
	; Reload any local entries for File #62.47
	; Is this the patch's development account?
	S LAACTN(2)=($G(^%ZOSF("VOL"))="MHCVSS")
	I 1 D  ;
	. S LAX=+$G(^TMP("LA74-LOCAL",$J,"6247",0))
	. D BMES("Restoring "_LAX_" local code"_$S(LAX=1:"",1:"s")_" to #62.47")
	. D SETLOCAL
	K LAACTN(2)
	;
	; Check and add write identifier to 2nd piece of file header.
	S LAX=$P(^LAHM(62.49,0),"^",2)
	I LAX'="",LAX'["I" D
	. S LAX=LAX_"I"
	. S $P(^LAHM(62.49,0),"^",2)=LAX
	. D BMES("Setting write identifier to LA7 MESSAGE QUEUE (#62.49) file header")
	;
	; Re-index #62.49 field #5 "C" xref.
	D QC6249
	;
	; Check LA7V protocols and set commit and app ACKs to AL
	S LANODE="^ORD(101,""B"",""LA7V "")"
	F  S LANODE=$Q(@LANODE) Q:LANODE=""  Q:$QS(LANODE,2)'="B"  Q:$QS(LANODE,3)'?1"LA7V "0.E  D  ;
	. S LAX=$QS(LANODE,3)
	. S X=$P(LAX," ",2,$L(LAX," ")-1)
	. I "^Order to^Results Reporting to^"'[("^"_X_"^") Q
	. S LA101=$QS(LANODE,4)
	. Q:'LA101
	. K LAFDA,LAIEN,DIERR,LAMSG
	. S LAIEN=LA101_","
	. S LAFDA(1,101,LAIEN,770.8)="AL"
	. S LAFDA(1,101,LAIEN,770.9)="AL"
	. D FILE^DIE("E","LAFDA(1)","LAMSG")
	;
	; Check "LA7V Receive" protocols and set commit ACKs to AL
	S LANODE="^ORD(101,""B"",""LA7V Receive"")"
	F  S LANODE=$Q(@LANODE) Q:LANODE=""  Q:$QS(LANODE,2)'="B"  Q:$QS(LANODE,3)'?1"LA7V Receive"0.E  D  ;
	. S LAX=$QS(LANODE,3)
	. S X=$P(LAX," ",2,$L(LAX," ")-1)
	. I "^Receive Order from^Receive Results from^"'[("^"_X_"^") Q
	. S LA101=$QS(LANODE,4)
	. Q:'LA101
	. K LAFDA,LAIEN,DIERR,LAMSG
	. S LAIEN=LA101_","
	. S LAFDA(1,101,LAIEN,770.8)="AL"
	. D FILE^DIE("E","LAFDA(1)","LAMSG")
	;
	D BMES("*** Post install completed ***")
	D BMES("Sending install completion alert to mail group G.LMI")
	S STR="Installation of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
	D ALERT^LA74(STR)
	K ^TMP("LA74-LOCAL",$J),^TMP("LA74-LOCAL-MAPPING",$J)
	Q
	;
	;
POP6247	;
	; Populate File #62.47 from Transport Global
	N NODE,R6247,R624701,R1,R2,SUB,IEN,IENS,LAFDA,DIERR,MSG
	N DATA,ERRCNT,LADOT,X,LRFPRIV,LAFMERR
	K ^TMP("LA74-FMERR",$J)
	S LRFPRIV=1 ;File #62.47 override variable
	S LADOT=$H
	;S CNT=+$G(@XPDGREF@("LA6247",0))
	S ERRCNT=0
	S NODE=$$TRIM^XLFSTR(XPDGREF,"R",")")
	S NODE=NODE_",""LA6247"",1)"
	F  S NODE=$Q(@NODE) Q:NODE=""  Q:$QS(NODE,4)'="LA6247"  D  ;
	. S LACNT=LACNT+1
	. I LACNT#100=0 D UPDATE^XPDID(LACNT)
	. D PROGRESS^LA74(.LADOT)
	. S R1=$QS(NODE,5)
	. S R2=$QS(NODE,7)
	. S SUB=$QS(NODE,8)
	. S DATA=@NODE
	. I 'R2 D  ; Add top level data
	. . K LAFDA,MSG,IENS,R6247,R624701,DIERR
	. . S IENS(1)=R1
	. . S LAFDA(1,62.47,"+1,",.01)=$P(DATA,"^",1)
	. . S LAFDA(1,62.47,"+1,",.02)=$P(DATA,"^",2)
	. . S LAFDA(1,62.47,"+1,",.03)=$P(DATA,"^",3)
	. . S LAFDA(1,62.47,"+1,",.04)=$P(DATA,"^",4)
	. . D UPDATE^DIE("S","LAFDA(1)","IENS","MSG")
	. . S R6247=IENS(1)
	. . I $D(MSG) D  ;
	. . . K LAFMERR
	. . . D MSG^DIALOG("AEHM",.LAFMERR,"","","MSG(""DIERR"")")
	. . . D FMERR(.LAFMERR)
	. . . S ERRCNT=$O(^TMP("LA74-FMERR",$J,"A"),-1)+1
	. . . S ^TMP("LA74-FMERR",$J,ERRCNT,0)=R1_"^"_R2_"^"_62.47
	. . . S ^TMP("LA74-FMERR",$J,ERRCNT,1,.01)=$P(DATA,"^",1)
	. . . M ^TMP("LA74-FMERR",$J,ERRCNT,"DIERR")=MSG("DIERR")
	. . . M ^TMP("LA74-FMERR",$J,ERRCNT,"LAFDA")=LAFDA(1,62.47,"+1")
	. . ;
	. ;
	. I R2 I SUB=0 D  ; Add second level data
	. . K LAFDA,MSG,IEN,IENS,R624701,DIERR
	. . S IENS(1)=R2
	. . S IEN="+1,"_R6247_","
	. . S LAFDA(1,62.4701,IEN,.01)=$P(DATA,"^",1)
	. . S LAFDA(1,62.4701,IEN,.02)=$P(DATA,"^",2)
	. . S LAFDA(1,62.4701,IEN,.03)=$P(DATA,"^",3)
	. . S LAFDA(1,62.4701,IEN,.04)=$P(DATA,"^",4)
	. . S LAFDA(1,62.4701,IEN,.05)=$P(DATA,"^",5)
	. . D UPDATE^DIE("S","LAFDA(1)","IENS","MSG")
	. . S R624701=IENS(1)
	. . I $D(MSG) D  ;
	. . . K LAFMERR
	. . . D MSG^DIALOG("AEHM",.LAFMERR,"","","MSG(""DIERR"")")
	. . . D FMERR(.LAFMERR)
	. . . S ERRCNT=$O(^TMP("LA74-FMERR",$J,"A"),-1)+1
	. . . S ^TMP("LA74-FMERR",$J,ERRCNT,0)=R1_"^"_R2_"^"_62.4701
	. . . S ^TMP("LA74-FMERR",$J,ERRCNT,1,.01)=$P(DATA,"^",1)
	. . . M ^TMP("LA74-FMERR",$J,ERRCNT,"DIERR")=MSG("DIERR")
	. . . M ^TMP("LA74-FMERR",$J,ERRCNT,"LAFDA")=LAFDA(1,62.4701,IEN)
	. . ;
	. ;
	. I R2 I $G(R624701) I SUB>2 D  ;
	. . K LAFDA,MSG,IEN,IENS,DIERR
	. . S IEN=R624701_","_R6247_","
	. . S X=DATA
	. . I SUB=2.1 D  ;
	. . . S X=$P(DATA,";",2)
	. . . I $P(DATA,";",1)="61.2" S X="ET."_X
	. . . I $P(DATA,";",1)="62.06" S X="AB."_X
	. . I X'="" S LAFDA(1,62.4701,IEN,SUB)=X
	. . D FILE^DIE("ES","LAFDA(1)","MSG")
	. . I $D(MSG) D  ;
	. . . K LAFMERR
	. . . D MSG^DIALOG("AEHM",.LAFMERR,"","","MSG(""DIERR"")")
	. . . D FMERR(.LAFMERR)
	. . . S ERRCNT=$O(^TMP("LA74-FMERR",$J,"A"),-1)+1
	. . . S ^TMP("LA74-FMERR",$J,ERRCNT,0)=R1_"^"_R2_"^"_62.4701
	. . . S ^TMP("LA74-FMERR",$J,ERRCNT,1,SUB)=$P(DATA,"^",1)
	. . . M ^TMP("LA74-FMERR",$J,ERRCNT,"DIERR")=MSG("DIERR")
	. . . M ^TMP("LA74-FMERR",$J,ERRCNT,"LAFDA")=LAFDA(1,62.4701,IEN)
	. . ;
	. ;
	Q
	;
	;
SETLOCAL	;
	; Insert any local codes into File #62.47
	N R6247,R624701,FLD,IEN,IENS,MSG,X,LAFDA,LA7IENS,LRFPRIV,ERRCNT,DIERR
	N LAFMERR
	K ^TMP("LA74-FMERR",$J)
	S LRFPRIV=1 ;File #62.47 override variable
	S (ERRCNT,R6247)=0
	F  S R6247=$O(^TMP("LA74-LOCAL",$J,"6247",R6247)) Q:'R6247  D  ;
	. S R624701=0
	. F  S R624701=$O(^TMP("LA74-LOCAL",$J,"6247",R6247,1,R624701)) Q:'R624701  D  ;
	. . S LACNT=$G(LACNT)+1
	. . I LACNT#100=0 D UPDATE^XPDID(LACNT)
	. . K IENS,IEN,LAFDA
	. . S FLD=.001,IEN="+1,"_R6247_","
	. . F  S FLD=$O(^TMP("LA74-LOCAL",$J,"6247",R6247,1,R624701,FLD)) Q:FLD=""  D  ;
	. . . S X=^TMP("LA74-LOCAL",$J,"6247",R6247,1,R624701,FLD)
	. . . I X'="" S LAFDA(1,62.4701,IEN,FLD)=X
	. . Q:'$D(LAFDA)
	. . K MSG,DIERR
	. . D UPDATE^DIE("S","LAFDA(1)","IENS","MSG")
	. . I $D(MSG) D  ;
	. . . K LAFMERR
	. . . D MSG^DIALOG("AEHM",.LAFMERR,"","","MSG(""DIERR"")")
	. . . D FMERR(.LAFMERR)
	. . . S ERRCNT=$O(^TMP("LA74-FMERR",$J,"A"),-1)+1
	. . . S ^TMP("LA74-FMERR",$J,ERRCNT,0)=R6247_"^"_R624701_"^"_62.4701
	. . . S ^TMP("LA74-FMERR",$J,ERRCNT,1,.01)=$G(LAFDA(1,62.4701,IEN,.01))
	. . . M ^TMP("LA74-FMERR",$J,ERRCNT,"DIERR")=MSG("DIERR")
	. . . M ^TMP("LA74-FMERR",$J,ERRCNT,"LAFDA")=LAFDA(1,62.4701,IEN)
	;
	; Restore local mappings to national terms
	S (ERRCNT,R6247)=0
	F  S R6247=$O(^TMP("LA74-LOCAL-MAPPING",$J,"6247",R6247)) Q:'R6247  D  ;
	. S R624701=0
	. F  S R624701=$O(^TMP("LA74-LOCAL-MAPPING",$J,"6247",R6247,1,R624701)) Q:'R624701  D
	. . S LACNT=$G(LACNT)+1
	. . I LACNT#100=0 D UPDATE^XPDID(LACNT)
	. . K DIERR,LAFDA,IENS,IEN,MSG
	. . S LA7IENS=R624701_","_R6247_","
	. . S LAFDA(1,62.4701,LA7IENS,2.1)=^TMP("LA74-LOCAL-MAPPING",$J,"6247",R6247,1,R624701,2.1)
	. . D FILE^DIE("","LAFDA(1)","MSG")
	. . I $D(MSG) D  ;
	. . . K LAFMERR
	. . . D MSG^DIALOG("AEHM",.LAFMERR,"","","MSG(""DIERR"")")
	. . . D FMERR(.LAFMERR)
	. . . S ERRCNT=$O(^TMP("LA74-FMERR",$J,"A"),-1)+1
	. . . S ^TMP("LA74-FMERR",$J,ERRCNT,0)=R6247_"^"_R624701_"^"_62.4701
	. . . S ^TMP("LA74-FMERR",$J,ERRCNT,1,.01)=$G(LAFDA(1,62.4701,LA7IENS,2.1))
	. . . M ^TMP("LA74-FMERR",$J,ERRCNT,"DIERR")=MSG("DIERR")
	. . . M ^TMP("LA74-FMERR",$J,ERRCNT,"LAFDA")=LAFDA(1,62.4701,LA7IENS)
	. . D CLEAN^DILF
	;
	Q
	;
	;
APROXY(NAME)	;
	; re: XU*8*361 and XM*8*36
	; Sets File #200 entry's field USER CLASS to "APPLICATION PROXY"
	; File #200 update approved by Wally Fort (email 03/27/2006)
	; CREATE^XUSAP/4677 (pending)
	N IEN,LAIENS,LAFDA,DIC,IX,LAMSG,SUB,XUNOTRIG,X,DIERR
	S IEN=$$FIND1^DIC(200,,"M",NAME)
	I 'IEN D  Q IEN
	. S IEN=$$CREATE^XUSAP(NAME,"@",)
	K DIERR
	S SUB="?+1,"_IEN_","
	S LAFDA(200.07,SUB,.01)="APPLICATION PROXY"
	S LAFDA(200.07,SUB,2)=1
	D UPDATE^DIE("E","LAFDA","LAIENS","LAMSG")
	I $D(LAMSG) Q -2
	Q IEN
	;
	;
BMES(STR)	;
	; Convenience method
	D BMES^LA74(STR)
	Q
	;
	;
FMERR(IN)	;
	; Goes thru an MSG^DIALOG output array for display
	; Inputs
	;   IN <byref>  The output array created by MSG^DIALOG
	;
	N I
	S I=0
	F  S I=$O(IN(I)) Q:'I  D  ;
	. D BMES(IN(I))
	Q
	;
	;
QC6249	; Queue reindexing of "C" cross-refernce of file #62.49
	;
	N DIK,DA,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
	;
	K ^LAHM(62.49,"C")
	S DIK="^LAHM(62.49,",DIK(1)="5^C"
	S ZTDTH=$H,ZTIO="",ZTDESC="Re-index C x-ref of file #62.49"
	S ZTSAVE("DI*")="",ZTRTN="ENALL^DIK"
	D ^%ZTLOAD
	;
	Q
