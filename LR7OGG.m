LR7OGG	;DALOI/STAFF- Interim report rpc grid ;02/11/11  15:09
	;;5.2;LAB SERVICE;**187,290,364,350**;Sep 27, 1994;Build 230
	;
TEST	; test use only
	N CNT,I
	K ^TMP("LR7OGX",$J)
	S ^TMP("LR7OGX",$J,"INPUT",1)="2^2970202^2920202"
	S CNT=1
	;F I=1:1:10 I $D(^LAB(60,I,0)) S CNT=CNT+1,^TMP("LR7OGX",$J,"INPUT",CNT)=I
	F I=7,173,9,1 I $D(^LAB(60,I,0)) S CNT=CNT+1,^TMP("LR7OGX",$J,"INPUT",CNT)=I
	D GRIDDATA
	S I=0 F  S I=$O(^TMP("LR7OGX",$J,"OUTPUT",I)) Q:I<1  W !,^(I)
	K ^TMP("LR7OGX",$J)
	Q
	;
GRID(ROOT,DFN,DATE1,DATE2,SPEC,TESTS)	; from ORWLRR
	N CNT,NUM
	K ^TMP("LR7OGX",$J,"INPUT"),^("OUTPUT")
	S ROOT=$NA(^TMP("LR7OGX",$J,"OUTPUT"))
	S ^TMP("LR7OGX",$J,"INPUT",1)=DFN_U_DATE1_U_DATE2_U_+SPEC
	S CNT=1,NUM=0 F  S NUM=$O(TESTS(NUM)) Q:NUM<1  D
	.S CNT=CNT+1
	.S ^TMP("LR7OGX",$J,"INPUT",CNT)=+TESTS(NUM)
	D GRIDDATA
	Q
	;
	;
GRIDDATA	;
	; input format
	; ^TMP("LR7OGX",$J,"INPUT",1)=dfn^start date^end date^spec^all tests
	; ^TMP("LR7OGX",$J,"INPUT",#)=test#  (tests displayed in this order)
	;   (these tests should, be atomic, subscript - ch, type - both or output)
	;
	S ^TMP("LR7OGX",$J,"OUTPUT",1)="0^0^0^1"
	N ABCNT,ABDCNT,ABLINE,ABTCNT,ABTLINE,ADCNT,ADSEQ,AGE,ATCNT,ATSEQ,CDT,CHSUB,COMCNT,COMMENT,DATACNT,DATESEQ,DFN,DISPDATE,EDATE,EDT,FLAG,I,IDT,INEXACT
	N LINE,LRCW,LRDFN,LRPROV,LRX,LRY,NUM,ONLYSPEC,OUTCNT,PNM,PRNTCODE,RESULT,SDATE,SEX,SPEC,SPECNAME,TESTNAME,TESTNUM,TESTSEQ,TESTZERO,X,ZERO
	F I="LR7OG","LRPLS","LRPLS-ADDR" K ^TMP(I,$J)
	S DFN=+^TMP("LR7OGX",$J,"INPUT",1),SDATE=+$P(^(1),U,2),EDATE=+$P(^(1),U,3),ONLYSPEC=+$P(^(1),U,4)
	D DEMO^LR7OGU(DFN,.LRDFN,.PNM,.AGE,.SEX)
	Q:'DFN  Q:'SDATE  Q:'EDATE  Q:'LRDFN
	S (COMCNT,OUTCNT)=1,(ADCNT,ADSEQ,ATCNT,ATSEQ,DATACNT,DATESEQ,TESTSEQ)=0
	S NUM=1
	F  S NUM=$O(^TMP("LR7OGX",$J,"INPUT",NUM)) Q:NUM<1  S TESTNUM=+^(NUM) D
	. S TESTZERO=$G(^LAB(60,TESTNUM,0))
	. S CHSUB=$P($P(TESTZERO,U,5),";",2)
	. I 'CHSUB Q
	. S TESTNAME=$P($G(^LAB(60,TESTNUM,.1)),U),PRNTCODE=$P($G(^(.1)),U,3)
	. I TESTNAME="" S TESTNAME=$P(TESTZERO,U)
	. S TESTSEQ=TESTSEQ+1
	. S LINE=TESTSEQ_U_TESTNUM_U_TESTNAME_U_PRNTCODE
	. S ^TMP("LR7OG",$J,"TEST",CHSUB)=LINE
	. S OUTCNT=OUTCNT+1
	. S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)=LINE
	S ^TMP("LR7OGX",$J,"OUTPUT",1)=TESTSEQ
	S EDATE=EDATE\1
	S IDT=9999999-SDATE,EDT=9999999-EDATE
	F  S IDT=$O(^LR(LRDFN,"CH",IDT)) Q:IDT<1  Q:IDT>EDT  D
	. S ZERO=^LR(LRDFN,"CH",IDT,0)
	. I '$P(ZERO,U,3) Q
	. S CDT=+ZERO,INEXACT=$P(ZERO,U,2),SPEC=+$P(ZERO,U,5),SPECNAME=$P($G(^LAB(61,SPEC,0)),U),COMMENT="**" ;COMMENT=$S($O(^LR(LRDFN,"CH",IDT,1,0)):"**",1:"")
	. I ONLYSPEC,SPEC'=ONLYSPEC Q
	. S LRPROV=$P(ZERO,"^",10)
	. S CHSUB=1
	. F  S CHSUB=$O(^LR(LRDFN,"CH",IDT,CHSUB)) Q:CHSUB=""  D
	. . I '$D(^TMP("LR7OG",$J,"TEST",CHSUB)) Q
	. . I '$D(^TMP("LR7OG",$J,"DATE",IDT)) S ^(IDT)="" D
	. . . S DATESEQ=DATESEQ+1,OUTCNT=OUTCNT+1,DISPDATE=$S(INEXACT:CDT\1,1:CDT)
	. . . S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)=DATESEQ_U_CDT_U_SPEC_U_SPECNAME_U_COMMENT_U_DISPDATE
	. . S LRX=$$TSTRES^LRRPU(LRDFN,"CH",IDT,CHSUB,"")
	. . S RESULT=$P(LRX,"^"),FLAG=$P(LRX,U,2)
	. . S PRNTCODE=$P(^TMP("LR7OG",$J,"TEST",CHSUB),U,4)
	. . I PRNTCODE'="" S X=RESULT,LRCW=8 S @("RESULT="_PRNTCODE)
	. . E  S RESULT=$J(RESULT,8)
	. . S RESULT=$$STRIP^LR7OGU(RESULT)
	. . I FLAG'="" D
	. . . S ABTLINE=^TMP("LR7OG",$J,"TEST",CHSUB)
	. . . I '$D(^TMP("LR7OG",$J,"ABTSEQ",+ABTLINE)) S ^(+ABTLINE)=U_$P(ABTLINE,U,2,3)
	. . . I '$D(^TMP("LR7OG",$J,"ABDSEQ",IDT)) S ^(IDT)=U_CDT_U_SPEC_U_SPECNAME_U_COMMENT
	. . . S ^TMP("LR7OG",$J,"ABDATA",IDT,+ABTLINE)=RESULT_U_FLAG
	. . S TESTSEQ=+^TMP("LR7OG",$J,"TEST",CHSUB)
	. . S DATACNT=DATACNT+1
	. . S ^TMP("LR7OG",$J,"DATA",DATACNT)=DATESEQ_U_TESTSEQ_U_RESULT_U_FLAG
	. . D TESTSPEC(CHSUB,SPEC,SPECNAME,AGE,SEX)
	. . I $P(LRX,"^",6) S ^TMP("LRPLS",$J,$P(LRX,"^",6),$P(^TMP("LR7OG",$J,"TEST",CHSUB),"^",3))=""
	. I '$D(^TMP("LR7OG",$J,"DATE",IDT)) Q
	. S ^TMP("LR7OG",$J,"COMMENT",COMCNT)=$P($$FMTE^XLFDT(CDT),":",1,2)_" ** Comments:",COMCNT=COMCNT+1
	. I $D(^LR(LRDFN,"CH",IDT,1)) D
	. . S NUM=0
	. . F  S NUM=$O(^LR(LRDFN,"CH",IDT,1,NUM)) Q:NUM<1  S LINE=$G(^(NUM,0)),^TMP("LR7OG",$J,"COMMENT",COMCNT)=LINE,COMCNT=COMCNT+1
	. . S ^TMP("LR7OG",$J,"COMMENT",COMCNT)=" ",COMCNT=COMCNT+1
	. S LRY=$$NAME^XUSER(LRPROV,"G")
	. S ^TMP("LR7OG",$J,"COMMENT",COMCNT)="Ordering Provider: "_LRY,COMCNT=COMCNT+1
	. D RRDT($P(ZERO,"^",3),.COMCNT)
	. D PLS
	S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,2,3)=DATESEQ_U_DATACNT
	S DATACNT=0
	F  S DATACNT=$O(^TMP("LR7OG",$J,"DATA",DATACNT)) Q:DATACNT<1  S LINE=^(DATACNT) D
	. S OUTCNT=OUTCNT+1,^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)=LINE
	S OUTCNT=OUTCNT+1,ABLINE=OUTCNT
	S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)="0^0^0"
	;
	S (ABTCNT,ATSEQ)=0
	F  S ATSEQ=$O(^TMP("LR7OG",$J,"ABTSEQ",ATSEQ)) Q:ATSEQ<1  D
	. S ABTCNT=ABTCNT+1
	. S $P(^TMP("LR7OG",$J,"ABTSEQ",ATSEQ),U)=ABTCNT
	. S OUTCNT=OUTCNT+1
	. S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)=^TMP("LR7OG",$J,"ABTSEQ",ATSEQ)
	;
	S (ABDCNT,ADSEQ)=0
	F  S ADSEQ=$O(^TMP("LR7OG",$J,"ABDSEQ",ADSEQ)) Q:ADSEQ<1  D
	. S ABDCNT=ABDCNT+1
	. S $P(^TMP("LR7OG",$J,"ABDSEQ",ADSEQ),U)=ABDCNT
	. S OUTCNT=OUTCNT+1
	. S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)=^TMP("LR7OG",$J,"ABDSEQ",ADSEQ)
	;
	S (ABCNT,ADSEQ)=0
	F  S ADSEQ=$O(^TMP("LR7OG",$J,"ABDATA",ADSEQ)) Q:ADSEQ<1  D
	. S ADCNT=+^TMP("LR7OG",$J,"ABDSEQ",ADSEQ)
	. S ATSEQ=0
	.  F  S ATSEQ=$O(^TMP("LR7OG",$J,"ABDATA",ADSEQ,ATSEQ)) Q:ATSEQ<1  D
	. . S ATCNT=+^TMP("LR7OG",$J,"ABTSEQ",ATSEQ)
	. . S ABCNT=ABCNT+1
	. . S OUTCNT=OUTCNT+1
	. . S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)=ADCNT_U_ATCNT_U_^TMP("LR7OG",$J,"ABDATA",ADSEQ,ATSEQ)
	;
	S ^TMP("LR7OGX",$J,"OUTPUT",ABLINE)=ABTCNT_U_ABDCNT_U_ABCNT
	S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,4)=OUTCNT
	S TESTSEQ=0
	F  S TESTSEQ=$O(^TMP("LR7OG",$J,"TESTSPEC",TESTSEQ)) Q:TESTSEQ<1  D
	. S SPEC=0
	. F  S SPEC=$O(^TMP("LR7OG",$J,"TESTSPEC",TESTSEQ,SPEC)) Q:SPEC<1  S LINE=^(SPEC) D
	. . S OUTCNT=OUTCNT+1
	. . S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)=LINE
	S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,5)=OUTCNT
	;
	S NUM=0
	F  S NUM=$O(^TMP("LR7OG",$J,"COMMENT",NUM)) Q:NUM<1  S LINE=^(NUM) D
	. S OUTCNT=OUTCNT+1
	. S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)=LINE
	;
	F I="LR7OG","LRPLS","LRPLS-ADDR" K ^TMP(I,$J)
	Q
	;
	;
TESTSPEC(CHSUB,SPEC,SPECNAME,AGE,SEX)	;
	N RANGE,TESTNAME,TESTNUM,TESTSEQ,UNITS
	S TESTSEQ=+$P(^TMP("LR7OG",$J,"TEST",CHSUB),U),TESTNUM=+$P(^(CHSUB),U,2),TESTNAME=$P(^(CHSUB),U,3)
	I $D(^TMP("LR7OG",$J,"TESTSPEC",TESTSEQ,SPEC)) Q
	D URANGE^LR7OGU(TESTNUM,SPEC,AGE,SEX,.UNITS,.RANGE)
	S ^TMP("LR7OG",$J,"TESTSPEC",TESTSEQ,SPEC)=TESTNUM_U_SPECNAME_U_SPEC_U_UNITS_U_$P(RANGE," - ")_U_$P($P(RANGE," - ",2)," (")
	Q
	;
	;
RRDT(LRDT,COMCNT)	; Display report released date/time
	; Call with LRDT = Date/time report released (completed) in FileMan d/t format
	;            CNT = Current comment line counter (pass by reference)
	N LRY
	;
	I LRDT S LRY=$$FMTE^XLFDT(LRDT,"M")
	E  S LRY=""
	S ^TMP("LR7OG",$J,"COMMENT",COMCNT)="Report Released Date/Time: "_LRY,COMCNT=COMCNT+1
	Q
	;
	;
PLS	; List reporting and performing laboratories
	; If multiple performing labs then list tests associated with each lab.
	;
	;ZEXCEPT: COMCNT,IDT,LRDFN
	;
	N LINE,LLEN,LRPLS,LRX,MPLS,PLS,TESTNAME,X
	;
	; Reporting Laboratory
	I $$GET^XPAR("DIV^PKG","LR REPORTS FACILITY PRINT",1,"Q")#2 D
	. S LRX=+$G(^LR(LRDFN,"CH",IDT,"RF"))
	. I LRX<1 Q
	. S LINE=$$PLSADDR^LR7OSUM2(LRX)
	. S ^TMP("LR7OG",$J,"COMMENT",COMCNT)=" ",COMCNT=COMCNT+1
	. S ^TMP("LR7OG",$J,"COMMENT",COMCNT)="Reporting Lab: "_$P(LINE,"^"),COMCNT=COMCNT+1
	. S ^TMP("LR7OG",$J,"COMMENT",COMCNT)="               "_$P(LINE,"^",2),COMCNT=COMCNT+1
	;
	S PLS=$O(^TMP("LRPLS",$J,0)),MPLS=0
	I $O(^TMP("LRPLS",$J,PLS)) S MPLS=1 ; multiple performing labs
	S LRPLS=0
	F  S LRPLS=$O(^TMP("LRPLS",$J,LRPLS)) Q:LRPLS<1  D
	. S ^TMP("LR7OG",$J,"COMMENT",COMCNT)=" ",COMCNT=COMCNT+1
	. I MPLS D
	. . S TESTNAME="",LINE="For test(s): ",LLEN=13
	. . F  S TESTNAME=$O(^TMP("LRPLS",$J,LRPLS,TESTNAME)) Q:TESTNAME=""  D
	. . . S X=$L(TESTNAME)
	. . . I (LLEN+X)>240 S ^TMP("LR7OG",$J,"COMMENT",COMCNT)=LINE,COMCNT=COMCNT+1,LINE="",LLEN=0
	. . . S LINE=LINE_$S(LLEN>13:", ",1:"")_TESTNAME,LLEN=LLEN+X+$S(LLEN>13:2,1:0)
	. . I LINE'="" S ^TMP("LR7OG",$J,"COMMENT",COMCNT)=LINE,COMCNT=COMCNT+1
	. S LINE=$$PLSADDR^LR7OSUM2(LRPLS)
	. S ^TMP("LR7OG",$J,"COMMENT",COMCNT)="Performing Lab: "_$P(LINE,"^"),COMCNT=COMCNT+1
	. S ^TMP("LR7OG",$J,"COMMENT",COMCNT)="                "_$P(LINE,"^",2),COMCNT=COMCNT+1
	;
	S ^TMP("LR7OG",$J,"COMMENT",COMCNT)=" ",COMCNT=COMCNT+1
	;
	K ^TMP("LRPLS",$J)
	Q