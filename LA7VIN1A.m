LA7VIN1A	;DALOI/JMC - Process Incoming UI Msgs, continued ;11/17/11  15:42
	;;5.2;AUTOMATED LAB INSTRUMENTS;**64,67,74**;Sep 27, 1994;Build 229
	;
	; This routine is a continuation of LA7VIN1.
	; It performs generation of any mail bulletins needed.
	;
	; Reference to DUZ^XUP supported by DBIA #4129
	;
	Q
	;
	;
SENDARB	; Send amended report bulletin
	N LA76304,LA7BODY,LA7I,LA7ISQN,LA7TSK,LA7X,LWL
	N XMBODY,XMDUZ,XMBNAME,XMINSTR,XMPARM,XMTO,X,Y
	N XQA,XQAID,XQADATA,XQAFLAG,XQAMSG,XQAOPT,XQAROU
	;
	I '$G(DUZ) D DUZ^XUP(.5)
	S XMBNAME="LA7 AMENDED RESULTS RECEIVED"
	S LA7I=0
	F  S LA7I=$O(^TMP("LA7 AMENDED RESULTS",$J,LA7I)) Q:'LA7I  D
	. S LA7I(0)=^TMP("LA7 AMENDED RESULTS",$J,LA7I)
	. S LWL=$P(LA7I(0),"^",1),LA7ISQN=$P(LA7I(0),"^",2),LA76304=$P(LA7I(0),"^",3)
	. S XMPARM(1)=$$GET1^DIQ(62.48,$P(LA7I(0),"^",4)_",",.01)
	. S XMPARM(2)=$P(LA7I(0),"^",5)
	. S XMPARM(3)=$G(^LAH(LWL,1,LA7ISQN,.1,"PID","PNM"))
	. S XMPARM(4)=$G(^LAH(LWL,1,LA7ISQN,.1,"PID","SSN"))
	. S XMPARM(5)=$G(^LAH(LWL,1,LA7ISQN,.1,"OBR","SID"))
	. S XMPARM(6)=$$FMTE^XLFDT($G(^LAH(LWL,1,LA7ISQN,.1,"OBR","ORCDT")),"MZ")
	 .S XMPARM(7)=$P(LA7I(0),"^",8)_" ["_$P(LA7I(0),"^",7)_"]"
	. S X=$G(^LAH(LWL,1,LA7ISQN,LA76304)),X(5)=$P(X,"^",5)
	. S XMPARM(8)=$$GET1^DIQ(4,$P(X,"^",9)_",",.01)
	. S XMPARM(9)=$G(^LAH(LWL,1,LA7ISQN,.1,"OBR","FID"))
	. S XMPARM(10)=$P(X,"^")
	. S XMPARM(11)=$P(X(5),"!",7)
	. S XMPARM(12)=$P(X(5),"!",2)_$S($P(X(5),"!",3)'="":"-"_$P(X(5),"!",3),1:"")
	. S LA7X=$P(LA7I(0),"^",9),X=" L^ H^LL^HH^ <^ >^ N^ A^AA^ U^ D^ B^ W^ S^ R^ I^MS^VS"
	. S I=$F(X,LA7X)\3 S:I LA7X=$P($T(ABFLAGS+I^LA7VHLU1),";;",2)
	. S XMPARM(13)=LA7X
	. S X="UNKNOWN"
	. I $P(LA7I(0),"^",6)="C" S X="Record coming over is a correction and thus replaces a final result"
	. I $P(LA7I(0),"^",6)="D" S X="Deletes the OBX record"
	. I $P(LA7I(0),"^",6)="W" S X="Post original as wrong, e.g., transmitted for wrong patient"
	. S XMPARM(14)=X
	. S LA7BODY(1)=" ",LA7BODY(2)="Comments:"
	. S I=0
	. F  S I=$O(^LAH(LWL,1,LA7ISQN,1,I)) Q:'I  S LA7BODY(I+2)=$P(^(I),"^")
	. D SMB
	. S XQAMSG="Lab Messaging - Amended results received from "_XMPARM(1),XQAID="LA7-AMENDED-"_XMPARM(1)
	. D SA
	;
	K ^TMP("LA7 AMENDED RESULTS",$J)
	;
	Q
	;
	;
SENDUNCB	; Send units/normals changed bulletin
	;
	N LA76248,LA76304,LA7BODY,LA7I,LA7ISQN,LA7TSK,LA7X,LWL
	N XMBODY,XMDUZ,XMBNAME,XMINSTR,XMPARM,XMTO,X,Y
	N XQA,XQAID,XQADATA,XQAFLAG,XQAMSG,XQAOPT,XQAROU
	;
	I '$G(DUZ) D DUZ^XUP(.5)
	S XMBNAME="LA7 UNITS/NORMALS CHANGED"
	S LA7I=0
	F  S LA7I=$O(^TMP("LA7 UNITS/NORMALS CHANGED",$J,LA7I)) Q:'LA7I  D
	. S LA7I(0)=^TMP("LA7 UNITS/NORMALS CHANGED",$J,LA7I)
	. S LWL=$P(LA7I(0),"^",1),LA7ISQN=$P(LA7I(0),"^",2),LA76304=$P(LA7I(0),"^",3),LA76248=$P(LA7I(0),"^",4)
	. S XMPARM(1)=$$GET1^DIQ(62.48,LA76248_",",.01)
	. S XMPARM(2)=$P(LA7I(0),"^",5)
	. S XMPARM(3)=$G(^LAH(LWL,1,LA7ISQN,.1,"PID","PNM"))
	. S XMPARM(4)=$G(^LAH(LWL,1,LA7ISQN,.1,"PID","SSN"))
	. S XMPARM(5)=$G(^LAH(LWL,1,LA7ISQN,.1,"OBR","SID"))
	. S XMPARM(6)=$$FMTE^XLFDT($G(^LAH(LWL,1,LA7ISQN,.1,"OBR","ORCDT")),"MZ")
	 .S XMPARM(7)=$P(LA7I(0),"^",8)_" ["_$P(LA7I(0),"^",7)_"]"
	. S X=$G(^LAH(LWL,1,LA7ISQN,LA76304)),X(5)=$P(X,"^",5)
	. S XMPARM(8)=$$GET1^DIQ(4,$P(X,"^",9)_",",.01)
	. S XMPARM(9)=$G(^LAH(LWL,1,LA7ISQN,.1,"OBR","FID"))
	. S XMPARM(10)=$$GET1^DIQ(60,$P(LA7I(0),"^",10)_",",.01)
	. S XMPARM(11)=$P(X(5),"!",7)
	. S XMPARM(12)=$P(X(5),"!",2)_$S($P(X(5),"!",3)'="":"-"_$P(X(5),"!",3),1:"")
	. S XMTO("G."_$$FAMG^LA7VHLU1(LA76248,2))=""
	. D SMB
	. S XQAMSG="Lab Messaging - Reference Lab Units/Normals Change received from "_XMPARM(1),XQAID="LA7-UNITS/NORMALS-CHANGED-"_XMPARM(1)
	. D SA
	;
	K ^TMP("LA7 UNITS/NORMALS CHANGED",$J)
	;
	Q
	;
	;
SENDACB	; Send abnormal/critical bulletin
	;
	N LA76248,LA76304,LA7BODY,LA7I,LA7ISQN,LA7TSK,LA7X,LWL
	N XMBODY,XMDUZ,XMBNAME,XMINSTR,XMPARM,XMTO,X,Y
	N XQA,XQAID,XQADATA,XQAFLAG,XQAMSG,XQAOPT,XQAROU
	;
	I '$G(DUZ) D DUZ^XUP(.5)
	S XMBNAME="LA7 ABNORMAL RESULTS RECEIVED"
	S LA7I=0
	F  S LA7I=$O(^TMP("LA7 ABNORMAL RESULTS",$J,LA7I)) Q:'LA7I  D
	. S LA7I(0)=^TMP("LA7 ABNORMAL RESULTS",$J,LA7I)
	. S LWL=$P(LA7I(0),"^",1),LA7ISQN=$P(LA7I(0),"^",2),LA76304=$P(LA7I(0),"^",3),LA76248=$P(LA7I(0),"^",4)
	. S XMPARM(1)=$$GET1^DIQ(62.48,LA76248_",",.01)
	. S XMPARM(2)=$P(LA7I(0),"^",5)
	. S XMPARM(3)=$G(^LAH(LWL,1,LA7ISQN,.1,"PID","PNM"))
	. S XMPARM(4)=$G(^LAH(LWL,1,LA7ISQN,.1,"PID","SSN"))
	. S XMPARM(5)=$G(^LAH(LWL,1,LA7ISQN,.1,"OBR","SID"))
	. S XMPARM(6)=$$FMTE^XLFDT($G(^LAH(LWL,1,LA7ISQN,.1,"OBR","ORCDT")),"MZ")
	 .S XMPARM(7)=$P(LA7I(0),"^",8)_" ["_$P(LA7I(0),"^",7)_"]"
	. S X=$G(^LAH(LWL,1,LA7ISQN,LA76304)),X(5)=$P(X,"^",5)
	. S XMPARM(8)=$$GET1^DIQ(4,$P(X,"^",9)_",",.01)
	. S XMPARM(9)=$G(^LAH(LWL,1,LA7ISQN,.1,"OBR","FID"))
	. S XMPARM(10)=$P(X,"^")
	. S XMPARM(11)=$P(X(5),"!",7)
	. S XMPARM(12)=$P(X(5),"!",2)_$S($P(X(5),"!",3)'="":"-"_$P(X(5),"!",3),1:"")
	. S LA7X=$P(LA7I(0),"^",9),X=" L^ H^LL^HH^ <^ >^ N^ A^AA^ U^ D^ B^ W^ S^ R^ I^MS^VS"
	. S I=$F(X,LA7X)\3 S:I LA7X=$P($T(ABFLAGS+I^LA7VHLU1),";;",2)
	. S XMPARM(13)=LA7X
	. D SMB
	. S XQAMSG="Lab Messaging - Reference Lab Abnormal Results received from "_XMPARM(1),XQAID="LA7-ABNORMAL-RESULTS-"_XMPARM(1)
	. D SA
	;
	K ^TMP("LA7 ABNORMAL RESULTS",$J)
	;
	Q
	;
	;
SMB	; Send mail bulletin
	; Ignore any restrictions (domain closed or protected by security key)
	;
	N XMERR
	S XMINSTR("ADDR FLAGS")="R"
	S XMINSTR("FROM")="LAB PACKAGE"
	S XMTO("G."_$$FAMG^LA7VHLU1(LA76248,1))=""
	D SENDBULL^XMXAPI(DUZ,XMBNAME,.XMPARM,$S($D(LA7BODY):"LA7BODY",1:""),.XMTO,.XMINSTR,.LA7TSK,"")
	;
	Q
	;
	;
SA	; Send alert
	;
	M XQA=XMTO
	D DEL^LA7UXQA(XQAID)
	D SETUP^XQALERT
	;
	Q
	;
	;
CHKOK(LA7INDX)	; Check if ok to send bulletin on added/reflexed tests order change
	; Returns OK = 1 if results associated with added/reflex test are not
	;               on the accession.
	;         OK = 0 if accession already has tests on accession.
	;
	N LA760,LA7AA,LA7AD,LA7AN,LA7I,LA7TREEN,LRUID,OK,X
	S OK=1,LRUID=$P($G(^LAH(LWL,1,LA7ISQN,.1,"OBR","SID")),"^")
	;
	; Store all tests accessioned in ^TMP
	S X=$Q(^LRO(68,"C",LRUID))
	I X'="",$QS(X,3)=LRUID D
	. K ^TMP("LA7TREE",$J)
	. S LA7AA=$QS(X,4),LA7AD=$QS(X,5),LA7AN=$QS(X,6),LA7I=0
	. F  S LA7I=$O(^LRO(68,LA7AA,1,LA7AD,1,LA7AN,4,LA7I)) Q:'LA7I  D UNWIND^LA7UTIL(LA7I)
	. I '$O(^TMP("LA7 ORDER STATUS",$J,LA7INDX,0)) Q
	. S (LA7I,OK)=0
	. F  S LA7I=$O(^TMP("LA7 ORDER STATUS",$J,LA7INDX,LA7I)) Q:'LA7I  D  Q:OK
	. . I '$D(^TMP("LA7TREE",$J,LA7I)) S OK=1 ;wasn't ordered
	. K ^TMP("LA7TREE",$J)
	Q OK
	;
	;
LAHCLUP	; LAH clean up
	; Clean up entry in LAH if no results/comments to process
	;   i.e. if entry added from ORR msg and needed for mail bulletins.
	N LA7X
	S LA7X=$O(^LAH(LWL,1,LA7ISQN,.3))
	I LA7X="" D ZAPALL^LRVR3(LWL,LA7ISQN)
	;
	Q
