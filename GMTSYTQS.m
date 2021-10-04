GMTSYTQS	;SLC/JMH & ALB/ASF - MHA SCORE    ; 10/3/07 12:05pm
	;;2.7;Health Summary;**77,91**;Oct 20, 1995;Build 1
	;                  
	; External References
	;   DBIA 10035  ^DPT(
	;   DBIA 10103  $$FMTE^XLFDT
	;                     
	Q
EN	; MHA SCOREIT
	N GMTS1,GMTS2,GMTSAI,GMTSAJ,GMTSCC,GMTSCOR,GMTSCS,GMTSCW,GMTSDATA
	N GMTSDAY,GMTSDTM,GMTSGIV,GMTSI,GMTSJ,GMTSLO,GMTSLOC,GMTSLPG,GMTSNN,GMTSNPG,GMTSOR,GMTSQIT,GMTSRAW,GMTSSCL,GMTSTITL,GMTSTN,GMTSTRA,GMTSX,MAX,N
	K ^TMP("GMTSYTQS",$J),^TMP("GMTSYTQSEG",$J)
	S MAX=$S(+($G(GMTSNDM))>0:+($G(GMTSNDM)),1:9999999)
	S:+($G(GMTSBEG))'>2700101 GMTSBEG=$$FMADD^XLFDT($P($$NOW^XLFDT,".",1),-1095,0,0,1),GMTSEND=$$FMADD^XLFDT($P($$NOW^XLFDT,".",1),1,0,0,1),GMTS2=9999999-GMTSBEG,GMTS1=9999999-GMTSEND
	S:'$L($P(GMTSBEG,".",2)) GMTSBEG=$$FMADD^XLFDT(GMTSBEG,0,0,0,1)
	S:+($G(GMTSEND))'>2700101!(+($G(GMTSEND))>+($$FMADD^XLFDT($P($$NOW^XLFDT,".",1),+1,0,0,2))) GMTSEND=$$FMADD^XLFDT($P($$NOW^XLFDT,".",1),1,0,0,1),GMTS1=9999999-GMTSEND
	S:'$L($P(GMTSEND,".",2)) GMTSEND=$$FMADD^XLFDT(GMTSEND,0,0,0,1)
	S:+($G(GMTSEND))>0&(+($G(GMTS1))=0) GMTS1=9999999-GMTSEND S:+($G(GMTSBEG))>0&(+($G(GMTS2))=0) GMTS2=9999999-GMTSBEG
	S GMTSLO=+($G(GMTSLO)) S:GMTSLO=0 GMTSLO=3 S GMTSLPG=+($G(GMTSLPG)),GMTSDTM=$G(GMTSDTM) S:'$L(GMTSDTM) GMTSDTM=$$DTM
	S:'$D(GMTSTITL)!('$L($G(GMTSTITL))) GMTSTITL="MHA Administrations"
	S DFN=+($G(DFN)) Q:'$L($P($G(^DPT(DFN,0)),"^",1))
	S GMTSCW(0)=+($G(IOM)) S:GMTSCW(0)=0 GMTSCW(0)=80
	S GMTSCW(1)=5,GMTSCW(2)=10,GMTSCW(3)=20,GMTSCW(4)=GMTSCW(0)-(GMTSCW(1)+GMTSCW(2)+GMTSCW(3)+8)
	S GMTSCW("L")=(GMTSCW(1)+GMTSCW(2)+GMTSCW(3)+GMTSCW(4)+6)
	S GMTSCS(1)=1,GMTSCS(2)=GMTSCS(1)+GMTSCW(1)+2,GMTSCS(3)=GMTSCS(2)+GMTSCW(2)+2,GMTSCS(4)=GMTSCS(3)+GMTSCW(3)+2
	D GET Q:'$D(^TMP("GMTSYTQS",$J))  D OUT
	Q
OUT	; Output
	N GMTSI,GMTSJ,GMTSNN
	S GMTSNN=1
	D HDR
	S GMTSGIV="" F  S GMTSGIV=$O(^TMP("GMTSYTQS",$J,GMTSGIV)) Q:GMTSGIV'>0!(GMTSNN>MAX)  S GMTSTN="" F  S GMTSTN=$O(^TMP("GMTSYTQS",$J,GMTSGIV,GMTSTN)) Q:GMTSTN=""  D
	. S GMTSJ=$G(^TMP("GMTSYTQS",$J,GMTSGIV,GMTSTN))
	. S GMTSDAY=$$ITM(GMTSGIV)
	. S GMTSOR=$P(GMTSJ,U,5) S:GMTSOR?1N.N GMTSOR=$$EXTERNAL^DILFD(601.84,5,,GMTSOR)
	. S GMTSLOC=$P(GMTSJ,U,14) S:GMTSLOC?1N.N GMTSLOC=$$EXTERNAL^DILFD(601.84,13,,GMTSLOC)
	. S GMTSNN=GMTSNN+1
	. D LINE
	. D:GMTSTN="GAF" GAFSCORE
	. D:GMTSTN="ASI" ASISCORE
	. D:(GMTSTN'="GAF")&(GMTSTN'="ASI") SCORE
	K ^TMP("GMTSYTQS",$J),^TMP("GMTSYTQSEG",$J)
	Q
SCORE	;
	K GMTSX S:+GMTSJ GMTSX("AD")=+GMTSJ S:'(+GMTSJ) GMTSX("DFN")=DFN,GMTSX("CODE")=GMTSTN,GMTSX("ADATE")=9999999.999999-GMTSGIV
	D GETSCORE^YTQAPI8(.GMTSDATA,.GMTSX)
	Q:^TMP($J,"YSCOR",1)'="[DATA]"
	S N=1 F  S N=$O(^TMP($J,"YSCOR",N)) Q:N'>0  D
	. S GMTSCOR=^TMP($J,"YSCOR",N)
	. S GMTSSCL=$P(GMTSCOR,"=")
	. S:$L(GMTSSCL)>15 GMTSSCL=$E(GMTSSCL,1,15)_"*"
	. S GMTSRAW=$P(GMTSCOR,"=",2),GMTSRAW=$P(GMTSRAW,U)
	. S GMTSTRA=$P(GMTSCOR,"=",2),GMTSTRA=$P(GMTSTRA,U,2)
	. D CKP^GMTSUP Q:$D(GMTSQIT)
	. D:GMTSNPG=1 HDR
	. W ?42,$J(GMTSRAW,5)," ",$J(GMTSTRA,8)," ",GMTSSCL,!
	Q
GAFSCORE	;
	W $J($P(GMTSJ,U,2),5),!
	Q
ASISCORE	;
	N IFN
	S IFN=+GMTSJ
	W ?42,$J($$GET1^DIQ(604,IFN_",",8.12),5),$J($$GET1^DIQ(604,IFN_",",.61),8),"  Medical",!
	W ?42,$J($$GET1^DIQ(604,IFN_",",9.34),5),$J($$GET1^DIQ(604,IFN_",",.62),5),"  Employment",!
	W ?42,$J($$GET1^DIQ(604,IFN_",",11.18),5),$J($$GET1^DIQ(604,IFN_",",.63),5),"  Alcohol",!
	W ?42,$J($$GET1^DIQ(604,IFN_",",11.185),5),$J($$GET1^DIQ(604,IFN_",",.635),5),"  Drug",!
	W ?42,$J($$GET1^DIQ(604,IFN_",",14.34),5),$J($$GET1^DIQ(604,IFN_",",.64),5),"  Legal",!
	W ?42,$J($$GET1^DIQ(604,IFN_",",18.29),5),$J($$GET1^DIQ(604,IFN_",",.65),5),"  Family",!
	W ?42,$J($$GET1^DIQ(604,IFN_",",19.33),5),$J($$GET1^DIQ(604,IFN_",",.66),5)," Psychiatric",!
	Q
LINE	; Output One Line
	D CKP^GMTSUP Q:$D(GMTSQIT)
	D:GMTSNPG=1 HDR
	W GMTSDAY,?20,$J($E(GMTSTN,1,20)_$S($L(GMTSTN)>20:"* ",1:" "),22)
	Q
HDR	; Header
	N GMTSI S GMTSI="",$P(GMTSI,"-",+($G(GMTSCW("L"))))="-"
	D CKP^GMTSUP Q:$D(GMTSQIT)  G:GMTSNPG=1 HDR W "Date",?31,"Instrument   Raw    Trans Scale",!
	Q
GET	; Get and Format Data
	N %DT,X,Y,GMTSNN,GMTSGIV,GMTSTN
	K ^TMP("GMTSYTQSEG",$J)
	;selctions
	S GMTSCC=0 F  S GMTSCC=$O(GMTSEG(GMTSCC)) Q:GMTSCC'>0  Q:$D(GMTSEG($G(GMTSCC,0),601.71))  ;ASF 7/6/07
	Q:GMTSCC'>0  ;must have a selection
	S GMTSAI=0 F  S GMTSAI=$O(GMTSEG(GMTSCC,601.71,GMTSAI)) Q:GMTSAI'>0  S GMTSAJ=GMTSEG(GMTSCC,601.71,GMTSAI),^TMP("GMTSYTQSEG",$J,$P(^YTT(601.71,GMTSAJ,0),U))=""
	;
	S GMTSNN=0
	K GMTSX
	S GMTSX("DFN")=DFN,GMTSX("COMPLETE")="Y" D ADMINS^YTQAPI5(.GMTSDATA,.GMTSX)
	Q:'$D(GMTSDATA(3))
	S N=2 F  S N=$O(GMTSDATA(N)) Q:N'>0!(GMTSNN>MAX)  D
	. S GMTSTN=$P(GMTSDATA(N),U,2) Q:GMTSTN=""
	. Q:'$D(^TMP("GMTSYTQSEG",$J,GMTSTN))
	. S GMTSGIV=$P($G(GMTSDATA(N)),U,3) Q:GMTSGIV'?7N.E
	. Q:GMTSGIV<GMTSBEG
	. Q:GMTSGIV>GMTSEND
	. S GMTSNN=GMTSNN+1
	. F  Q:'$D(^TMP("GMTSYTQS",$J,9999999.999999-GMTSGIV,GMTSTN))  S GMTSGIV=GMTSGIV+.00000001 ; 2/3/09  *91 - VM/RJT
	. S ^TMP("GMTSYTQS",$J,9999999.999999-GMTSGIV,GMTSTN)=GMTSDATA(N)
	K GMTSDATA
	D:$D(^TMP("GMTSYTQSEG",$J,"GAF")) GAFGET
	K GMTSDATA
	D:$D(^TMP("GMTSYTQSEG",$J,"ASI")) ASIGET
	Q
ASIGET	;
	N G,GMTSIEN,GMTSNN,GMTSELS
	S GMTSNN=0
	S GMTSIEN=0
	F  S GMTSIEN=$O(^YSTX(604,"C",DFN,GMTSIEN)) Q:GMTSIEN'>0  D
	. S G=^YSTX(604,GMTSIEN,0)
	. S GMTSGIV=$P(G,U,12)
	. S GMTSELS=$P($G(^YSTX(604,GMTSIEN,.5)),U)
	. Q:GMTSELS'=1
	. Q:GMTSGIV<GMTSBEG
	. Q:GMTSGIV>GMTSEND
	. S GMTSNN=GMTSNN+1
	. S ^TMP("GMTSYTQS",$J,9999999.999999-GMTSGIV,"ASI")=GMTSIEN
	Q
GAFGET	;get axis5
	N G,N,GMTSNN
	S GMTSNN=0
	S GMTSX("DFN")=DFN D GAFRET^YTQAPI6(.GMTSDATA,.GMTSX)
	Q:'$D(GMTSDATA(2))
	S N=1 F  S N=$O(GMTSDATA(N)) Q:N'>0!(GMTSNN>MAX)  D
	. S G=GMTSDATA(N)
	. S GMTSGIV=$P(^YSD(627.8,+G,0),U)
	. Q:GMTSGIV<GMTSBEG
	. Q:GMTSGIV>GMTSEND
	. S GMTSNN=GMTSNN+1
	. S ^TMP("GMTSYTQS",$J,9999999.999999-GMTSGIV,"GAF")=+G_U_$P(G,U,2)
	Q
ITM(X)	; Inverse date to Mental Health formats
	S X=+($G(X)) Q:X=0 "" S X=9999999.999999-X D REGDTM4^GMTSU Q X
DTM(X)	; Current Date and Time (External)
	S X=$$NOW^XLFDT D REGDTM4^GMTSU Q X
