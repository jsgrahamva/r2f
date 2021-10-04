LR7OSUM3	;DALOI/STAFF - Silent Patient cum cont. ;02/20/13  16:5
	;;5.2;LAB SERVICE;**121,201,187,228,250,350,427**;Sep 27, 1994;Build 33
	;
	N GIOM,LRPF,LRI
	S GIOM=$G(LRGIOM)
	I GIOM="" D
	. S GIOM=$$GET^XPAR("USR^DIV^PKG","LR CH GUI REPORT RIGHT MARGIN",1,"Q")
	. I GIOM="" S GIOM=80
	S LRAG=0,LRYESCOM=0,LRIL=0,LRFULL=0
	;
	; Print header with name of facility printing report.
	I $$GET^XPAR("DIV^PKG","LR REPORTS FACILITY PRINT",1,"Q")>1 D PFAC
	;
	D LRMH S LRMH="MISC"
	G PRE^LR7OSUM6
	;
LRMH	S LRMH=0
	F  S LRMH=$O(^TMP($J,LRDFN,LRMH)) Q:LRMH<1  S X=^(LRMH) D MH1
	Q
	;
	;
MH1	S LRMHN=$P(X,U,1),LRSH=0
	S LRPG=1
	D TOP^LR7OSUM6
	S LROFMT="",LRFDE=0 D LRSH
	D:'LRFDE LRBOT^LR7OSUM6
	K LRTM,^TMP($J,"TM")
	S LRFULL=0,LRTM=0,LROFMT="",LRFDE=0
	Q
	;
	;
LRSH	;from LR7OSUM4, LR7OSUM5
	S LRSH=$O(^TMP($J,LRDFN,LRMH,LRSH)) Q:LRSH<1  G:$D(^(LRSH))'=11 LRSH S X=^(LRSH),LRSHN=$P(X,U,1),LRTOPP=$P(X,U,2),LRSHD=$P(X,U,3),LRFMT=$P(X,U,4),LRFMT(1)=$E(LRFMT,1),LROFMT(1)=$E(LROFMT,1)
	Q:$S('$D(SUBHEAD):0,1:'$D(SUBHEAD(LRSHN)))
	I (LROFMT["V"&(LRFMT["V"))!(LROFMT'=""&(LRFMT(1)'=LROFMT(1))) S LROFMT="" D HEAD^LR7OSUM6
	S LROFMT=LRFMT,LRTOPP=$E($P(^LAB(61,LRTOPP,0),U,1),1,13),LRTOT=0,LRPL=1,LRACT=0,LRJS=0,LRTS=0,LRFDE=0
	S LRNP=0,LRFDT=0,LRLFDT=0,LRFFDT=0 D LRNP
	;
LOOP	;from LR7OSUM5
	I LRACT<LRPL S LRFDT=LRFFDT G:LRFMT["H" TS^LR7OSUM5 I LRFMT["V" S LRMULT=99999,LRMU=0 G BS^LR7OSUM4
	D TXT1^LR7OSUM5
	I LRCTR'<LRLNS S LRFULL=1 S:'LRFDT LRFED=1 D:LRFDE LRBOT^LR7OSUM6 D:'LRFDT HEAD^LR7OSUM6 S LRFULL=0 G LRSH
	G LRSH
	;
	;
LRNP	;from LR7OSUM4
	S I=0 F  S I=$O(^LAB(64.5,1,1,LRMH,1,LRSH,1,I)) Q:I<1  D
	. N LRCW
	. S LRCW=$P(^LAB(64.5,1,1,LRMH,1,LRSH,1,I,0),U,2)
	. I LRCW<1 S LRCW=15
	. S LRTOT=LRTOT+LRCW
	. I LRTOT>(GIOM-25) S LRPL=LRPL+1,LRTOT=LRCW
LRLNS	;from LR7OSUM5
	K LRTM,^TMP($J,"TM") S LRTM=0
	S LRLNS=((GIOSL-18)-(GCNT+(6*LRPL)))\LRPL
	S LRCL=(GIOM/2)-(5+($L(LRSHN)/2)) S GCNT=GCNT+1,CCNT=1,^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(LRCL,CCNT,"---- "_LRSHN_" ----")
	S ^TMP("LRH",$J,LRSHN)=GCNT ;Set x-ref of minor headers with data
	S LRACT=0,LRJS=0,LRNP=1
	Q
	;
	;
UDT	;from LR7OSUM4, LR7OSUM5
	N LRBDT,LREAL
	S LRBDT=LRFDT
	; If inexact date/time then suppress any pseudo time.
	S LREAL=+$P(^TMP($J,LRDFN,LRMH,LRSH,LRFDT,0),U,6)
	; Forces all formats to be inverse date/time regardless of parameter in file 64.5
	S LRFDT=$P(^TMP($J,LRDFN,LRMH,LRSH,LRFDT,0),U,2) ;,LRTIM=$E(LRFDT,9,12)
	;F I=0:0 Q:$L(LRTIM)=4  S LRTIM=LRTIM_0
	;S LRTIM=$S(LRTIM?4"0":"     ",1:$E(LRTIM,1,2)_":"_$E(LRTIM,3,4))
	;S LRUDT=$E($$Y2K^LRX($P(LRFDT,".")),1,5)_" "_$J(LRTIM,4)_" "
	S LRFDT=LRBDT D:LRTM LRTM
	Q
	;
	;
LRTM	;
	S LRNXSW=0 S:'$D(LRTM(0)) LRTM(0)=96
	I $D(^TMP($J,"TM",LRFDT)) S LRNXSW=1
	E  I $D(^TMP($J,LRDFN,LRMH,LRSH,LRFDT,"TX")) D
	. S ^TMP($J,"TM",LRFDT)=^TMP("LRCMTINDX",$J,LRFDT),LRNXSW=1
	. S I=0 F  S I=$O(^TMP($J,LRDFN,LRMH,LRSH,LRFDT,"TX",I)) Q:I<1  S ^TMP($J,"TM",LRFDT,I)=^(I,0)
	N LRUDT7
	;S LRUDT7=$$Y2K^LRX(9999999-LRFDT)
	;S LRUDT7=$$FMTE^XLFDT(9999999-LRFDT,"1"_$S(LREAL:"D",1:"M"))
	S LRUDT7=$$LRUDT^LR7OSUM6(9999999-LRFDT,LREAL)
	S LRUDT=$P(LRUDT7,"@")_" "_$E($P(LRUDT7,"@",2),1,5)
	;S:LRNXSW I=$P(^TMP($J,"TM",LRFDT),"^"),LRUDT=I_$E("   ",1,$S(I'="":1,1:2))_LRUDT
	I LRNXSW D
	. S I=$P(^TMP($J,"TM",LRFDT),"^")
	. I I'="" S I="["_I_"]"
	. S LRUDT=$$LJ^XLFSTR(I,5)_LRUDT_" "
	Q
	;
	;
PFAC	; Print header with name of facility printing report.
	;
	D PFAC^LRRP1(DUZ(2),0,1,.LRPF)
	I ($O(^TMP($J,LRDFN,0))!($O(^TMP($J,LRDFN,"MISC",0)))),$D(LRPF) D
	. S LRI=0
	. F  S LRI=$O(LRPF(LRI)) Q:'LRI  D LN^LR7OSUM4 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(CCNT,CCNT,LRPF(LRI))
	. D LINE^LR7OSUM4 S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(CCNT,CCNT,"As of: "_$$HTE^XLFDT($H,"1M"))
	. D LINE^LR7OSUM4,LINE^LR7OSUM4
	Q