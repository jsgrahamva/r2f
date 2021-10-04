LR7OGMG	;DALOI/STAFF- Interim report rpc memo grid ;11/20/09  10:35
	;;5.2;LAB SERVICE;**187,230,286,290,331,364,395,350**;Sep 27, 1994;Build 230
	;
GRID(OUTCNT)	; from LR7OGMC
	N ACC,AGE,CDT,CMNT,DATA,DOC,FLAG,IDT,INTP,LINE,LRCW,LRX,MPLS,PLS,PORDER,PRNTCODE,RANGE,SEX,SPEC,SUB,TCNT,TESTNAME,TESTNUM
	N UNITS,VALUE,X,ZERO,INEXACT,DISPDATE
	; the variables AGE, SEX, LRCW, and X are used withing the lab's print codes and ref ranges
	K ^TMP("LRMPLS",$J)
	S AGE=$P(^TMP("LR7OG",$J,"G"),U,4),SEX=$P(^("G"),U,5),LRCW=$P(^("G"),U,6)
	S CDT=+$O(^TMP("LR7OG",$J,"TP",0)) Q:'CDT
	S IDT=9999999-CDT
	S ZERO=$S($D(^TMP("LR7OG",$J,"TP",CDT))#2:^(CDT),1:"")
	S SPEC=+$P(ZERO,U,5)
	S INEXACT=$P(ZERO,U,2),DISPDATE=$S(INEXACT:CDT\1,1:CDT)
	S DOC=$$NAME^LR7OGMP(+$P(ZERO,U,10))
	S ACC=$P(ZERO,U,6)
	S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,4,6)=SPEC_U_$P($G(^LAB(61,SPEC,0)),U)_U_ACC_U_DOC
	S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U,10)=DISPDATE
	S (TCNT,MPLS,PORDER,PLS)=0
	S PLS=$O(^TMP("LRPLS",$J,0))
	I $O(^TMP("LRPLS",$J,PLS)) S MPLS=1 ; multiple performing labs
	F  S PORDER=$O(^TMP("LR7OG",$J,"TP",CDT,PORDER)) Q:PORDER'>0  S DATA=^(PORDER) D
	. I $P(DATA,U,7)="" Q
	. S TCNT=TCNT+1
	. S TESTNUM=+DATA,TESTNAME=$P(DATA,U,2),PRNTCODE=$P(DATA,U,5),SUB=$P(DATA,U,6),FLAG=$P(DATA,U,8),X=$P(DATA,U,7),UNITS=$P(DATA,U,9),RANGE=$P(DATA,U,10),PLS=$P(DATA,U,11)
	. I MPLS,PLS S ^TMP("LRMPLS",$J,PLS,TESTNAME)=""
	. I PRNTCODE="" S VALUE=$J(X,8)
	. E  S @("VALUE="_PRNTCODE)
	. S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)=TESTNUM_U_TESTNAME_U_VALUE_U_FLAG_U_UNITS_U_RANGE
	. S OUTCNT=OUTCNT+1
	S $P(^TMP("LR7OGX",$J,"OUTPUT",1),U)=TCNT ;TCNT must be correct to display all values
	;
	S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)="Report Released Date/Time: "_$$FMTE^XLFDT($P(ZERO,"^",3),"M"),OUTCNT=OUTCNT+1
	S PORDER=0
	F  S PORDER=$O(^TMP("LR7OG",$J,"TP",CDT,PORDER)) Q:PORDER'>0  S DATA=^(PORDER) D
	. I $O(^TMP("LR7OG",$J,"TP",CDT,PORDER,0))>0 D
	. . S TESTNAME=$P(DATA,U,3)
	. . S INTP=0
	. . F  S INTP=+$O(^TMP("LR7OG",$J,"TP",CDT,PORDER,INTP)) Q:INTP<1  D
	. . . S LINE=TESTNAME_" Eval: "_^TMP("LR7OG",$J,"TP",CDT,PORDER,INTP)
	. . . S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)=LINE
	. . . S OUTCNT=OUTCNT+1
	;
	I $D(^TMP("LR7OG",$J,"TP",CDT,"C")) D
	. S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)="Comment: "
	. S OUTCNT=OUTCNT+1,CMNT=0
	. F  S CMNT=+$O(^TMP("LR7OG",$J,"TP",CDT,"C",CMNT)) Q:CMNT<1  S LINE=^(CMNT) D
	. . S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)="   "_LINE
	. . S OUTCNT=OUTCNT+1
	;
	; Display reporting lab
	I $$GET^XPAR("DIV^PKG","LR REPORTS FACILITY PRINT",1,"Q")#2 D
	. S LRX=+$G(^LR(LRDFN,"CH",IDT,"RF"))
	. I LRX D RL(LRX)
	;
	D PLS
	;
	Q
	;
	;
RL(LRX)	; Set reporting lab into TMP global
	; Call with LRX = IEN of entry in file #4
	;
	N LINE
	S LINE=$$PLSADDR^LR7OSUM2(LRX)
	D SETLINE^LR7OGMP(" ",.OUTCNT)
	D SETLINE^LR7OGMP("Reporting Lab: "_$P(LINE,"^"),.OUTCNT)
	D SETLINE^LR7OGMP("               "_$P(LINE,"^",2),.OUTCNT)
	D SETLINE^LR7OGMP(" ",.OUTCNT)
	Q
	;
	;
PLS	; List performing laboratories
	; If multiple performing labs then list tests associated with each lab.
	;
	N CNT,LINE,LLEN,LRPLS,TESTNAME,X
	S (CNT,LRPLS)=0
	F  S LRPLS=$O(^TMP("LRPLS",$J,LRPLS)) Q:LRPLS<1  D
	. I CNT S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)=" ",OUTCNT=OUTCNT+1
	. I $D(^TMP("LRMPLS",$J,LRPLS)) D
	. . S TESTNAME="",LINE="For test(s): ",LLEN=13
	. . F  S TESTNAME=$O(^TMP("LRMPLS",$J,LRPLS,TESTNAME)) Q:TESTNAME=""  D
	. . . S X=$L(TESTNAME)
	. . . I (LLEN+X)>240 S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)=LINE,OUTCNT=OUTCNT+1,LINE="",LLEN=0
	. . . S LINE=LINE_$S(LLEN>13:", ",1:"")_TESTNAME,LLEN=LLEN+X+$S(LLEN>13:2,1:0)
	. . I LINE'="" S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)=LINE,OUTCNT=OUTCNT+1
	. S LINE=$$PLSADDR^LR7OSUM2(LRPLS)
	. S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)="Performing Lab: "_$P(LINE,"^"),OUTCNT=OUTCNT+1,CNT=CNT+1
	. S ^TMP("LR7OGX",$J,"OUTPUT",OUTCNT)="                "_$P(LINE,"^",2),OUTCNT=OUTCNT+1
	;
	K ^TMP("LRPLS",$J),^TMP("LRMPLS",$J)
	Q
