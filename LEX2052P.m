LEX2052P	;ISL/KER - LEX*2.0*52 Pre/Post Install ;08/18/2007
	;;2.0;LEXICON UTILITY;**52**;Sep 23, 1996;Build 1
	;            
	; Global Variables
	;    ^%ZOSF("DEL"    DBIA  10096
	;    ^%ZOSF("TEST"   DBIA  10096
	;    ^TMP("LEXCNT"   SACC 2.3.2.5.1
	;    ^TMP("LEXCS"    SACC 2.3.2.5.1
	;    ^TMP("LEXI"     SACC 2.3.2.5.1
	;    ^TMP("LEXINS"   SACC 2.3.2.5.1
	;    ^TMP("LEXKID"   SACC 2.3.2.5.1
	;    ^TMP("LEXMSG"   SACC 2.3.2.5.1
	;            
	; External References
	;    HOME^%ZIS       DBIA  10086
	;    ^DIM            DBIA  10016
	;    $$GET1^DIQ      DBIA   2056
	;    $$DT^XLFDT      DBIA  10103
	;    $$FMTE^XLFDT    DBIA  10103
	;    $$NOW^XLFDT     DBIA  10103
	;    $$DTIME^XUP     DBIA   4490
	;            
	Q
POST	; LEX*2.0*52 Post-Install
	N ENV,LEXBEG,LEXEND,LEXELP,LEXRTN,ZTREQ,X,Y S ENV=$$ENV Q:'ENV  S LEXBEG=$$NOW^XLFDT
	K ^TMP("LEXCS",$J),^TMP("LEXCNT",$J),^TMP("LEXI",$J),^TMP("LEXMSG",$J),^TMP("LEXINS",$J),^TMP("LEXKID",$J)
	N LEXEDT,LEXCHG,LEXSCHG,LEXMUMPS,LEXSHORT,LEXPOST,LEXBLDS,LEXBUILD,LEXBLD,LEXID,LEXSUB,X D EN^LEX2052A,EN^LEX2052E,EN^LEX2052F,EN^LEX2052G
	I $D(^%ZOSF("DEL")) F LEXRTN="LEX2052A","LEX2052B","LEX2052C","LEX2052D","LEX2052E","LEX2052F","LEX2052G","LEX2052H" D
	. N EXC,X,Y I +($$ROK(LEXRTN))>0 S (EXC,X)=$G(^%ZOSF("DEL")) D ^DIM I $D(X) S X=LEXRTN X EXC
	S LEXSHORT=1,(LEXID,LEXSUB)="LEXKID",(LEXBUILD,LEXBLD)="LEX*2.0*52",LEXPOST=1
	S LEXEND=$$NOW^XLFDT,LEXELP=$$EP^LEXXII(LEXBEG,LEXEND)
	D MSG,RX
	Q
MSG	;   Send a Install Message
	S:$D(ZTQUEUED) ZTREQ="@"
	N LEXFC,LEXMOD,LEXMUL,LEXTCS,LEXTND,ZTQUEUED,LEXT,LEXI
	S LEXMUL=1,(LEXTND,LEXTCS,LEXMOD,LEXFC,ZTQUEUED)=0
	D HDR^LEXXFI,EN^LEXXII I $L($G(LEXID)) S LEXI=0 F  S LEXI=$O(^TMP(LEXID,$J,LEXI)) Q:+LEXI'>0  D
	. S:$G(^TMP(LEXID,$J,LEXI))=" Lexicon/ICD/CPT Installation" ^TMP(LEXID,$J,LEXI)=" CPT Modifier 51 Update",^TMP(LEXID,$J,(LEXI+1))=" ======================"
	I $G(LEXBEG)?7N1".".N S LEXT="" S LEXT="  Started:     "_$TR($$FMTE^XLFDT($G(LEXBEG),"1Z"),"@"," ") D TL^LEXXII(LEXT)
	I $G(LEXEND)?7N1".".N S LEXT="" S LEXT="  Finished:    "_$TR($$FMTE^XLFDT($G(LEXEND),"1Z"),"@"," ") D TL^LEXXII(LEXT)
	I $G(LEXBEG)?7N1".".N!$G(LEXEND)?7N1".".N!($L($G(LEXELP))&($G(LEXELP)[":")) S LEXT="" S LEXT="  Elapsed:     "_$$ED^LEXXII($G(LEXELP)) D TL^LEXXII(LEXT),BL^LEXXII
	D MAIL^LEXXFI,KILL^LEXXFI
	Q
RX	; Re-Index
	N Y,ZTSK,ZTDESC,ZTDTH,ZTIO,ZTSAVE,ZTRTN,ZTREQ,ZTQUEUED
	S ZTRTN="RXT^LEX2052P",ZTDESC="Re-Index CPT Modifier file 81.3",ZTIO="",ZTDTH=$H D ^%ZTLOAD
	D:+($G(ZTSK))>0 BMES^XPDUTL((" Re-Indexing CPT Modified file 81.3 (Task #"_+($G(ZTSK))_")"))
	D HOME^%ZIS K Y,ZTSK,ZTDESC,ZTDTH,ZTIO,ZTSAVE,ZTRTN
	Q
RXT	; Re-Index (tasked)
	S:$D(ZTQUEUED) ZTREQ="@" N MIEN,DA,DIK S MIEN=0 F  S MIEN=$O(^DIC(81.3,MIEN)) Q:+MIEN'>0  D
	. K ^DIC(81.3,MIEN,10,"B"),^DIC(81.3,MIEN,"M")
	. N RIEN S RIEN=0 F  S RIEN=$O(^DIC(81.3,MIEN,10,RIEN)) Q:+RIEN'>0  D
	. . N DA,DIK S DA(1)=MIEN,DA=RIEN,DIK="^DIC(81.3,"_DA(1)_",10," D IX1^DIK
	. K DA S DA=MIEN,DIK="^DIC(81.3," D IX1^DIK
	F DA=3,11,46,47 S DIK="^DIC(81.3," D IX1^DIK
	F DA=643,644,645,646,647 S DIK="^DIC(81.3," D IX1^DIK
	Q
ROK(X)	; Routine OK
	S X=$G(X) Q:'$L(X) 0  Q:$L(X)>8 0  X ^%ZOSF("TEST") Q:$T 1
	Q 0
ENV(X)	; Environment check
	N LEXNM D HOME^%ZIS S U="^",DT=$$DT^XLFDT,LEXNM=$$GET1^DIQ(200,+($G(DUZ)),.01),DTIME=$$DTIME^XUP(+($G(DUZ))) Q:+($G(DUZ))'>0!('$L(LEXNM)) 0
	Q 1
