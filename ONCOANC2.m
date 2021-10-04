ONCOANC2	;Hines OIFO/GWB - BUILDS DATA ARRAY FOR NCDB CALL FOR DATA ;7/20/93  10:38
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
AASTUM	;  TUMOR DATA
	S AASEQ=$P(AAS1655("N0"),U,6)
	I AASEQ?2A,"^AA^BB^CC^DD^EE^FF^GG^HH^II^XX^"'[("^"_AASEQ_"^") S AASEQ="99"
	I AASEQ=""!(AASEQ<0)!(AASEQ>99) S AASEQ="99"
	S:$L(AASEQ)<2 AASEQ=$E(AASZERO,1,2-$L(AASEQ))_AASEQ
	S AASX=$P(AAS1655("N0"),U,16) X AASDTCV S AASDXDT=AASX
	S:AASAY>89 AASPS=$$ONCOPS($P(AAS1655("N2"),U))
	;The following is the old logic for Primary Site extraction
	I AASAY<90 D
	.S AASPS=$P(AAS1655("N2"),U,29),AASPS=$S('$L(AASPS):1999,AASPS<1400!(AASPS>1999):1999,1:AASPS)
	.S:"."[AASPS AASPS=$P(AASPS,".")
	S AASLAT=$P(AAS1655("N2"),U,8),AASLAT=$S(AASLAT=""!(AASLAT<0)!(AASLAT>4):0,1:AASLAT)
	S AASMHIS=$P(AAS1655("N2"),U,30) I AASMHIS'="" S:$L(AASMHIS)<5 AASMHIS=$E(AASZERO,1,5-$L(AASMHIS))_AASMHIS
	S:AASMHIS="" AASMHIS=$P(AAS1655("N2"),U,3) S:$L(AASMHIS)<5 AASMHIS=$E(AASZERO,1,5-$L(AASMHIS))_AASMHIS
	S:$L(AASMHIS)>5 AASMHIS=$E(AASMHIS,1,5)
	S AASGDIF=$P(AAS1655("N2"),U,5) S AASGDIF=$S(AASGDIF=""!(AASGDIF<0)!(AASGDIF>7):9,1:AASGDIF)
	S (AASITC,AASMORC)=9
	S AASDIA=$P(AAS1655("N2"),U,6) S AASDIA=$S(AASDIA=""!(AASDIA<1)!(AASDIA=3)!(AASDIA>9):9,1:AASDIA)
	S AASRPT=$P(AAS1655("N0"),U,10)
	S AASRPT=$S(AASRPT=2:1,AASRPT>7!(AASRPT=""):" ",1:AASRPT)
	S ^TMP($J,D0,149)=^TMP($J,D0,149)_AASEQ_AASDXDT_AASPS_AASLAT_AASMHIS_AASGDIF_AASITC_AASITC_AASMORC_$E(AASBLNK,1,1)_AASDIA_AASRPT_AASACYR_$E(AASBLNK,1,4)_$E(AASZERO,1,2)_AASDXH
AASHSP	;  HOSPITAL-SPECIFIC DATA
	S AASACCH=$P(AAS1655("N0"),U,5) S AASACCH=$S(AASACCH="":"000000",$L(AASACCH)<6:$E(AASZERO,1,6-$L(AASACCH))_AASACCH,1:AASACCH)
	S AASX=$P(AAS1655("N0"),U,8) X AASDTCV S AASHAD=AASX
	S AASX=$P(AAS1655("N0"),U,9) X AASDTCV S AASHDD=AASX
	S AASRHSR=$P(AAS1655("N3"),U,38) S AASRHSR=$S(AASRHSR="":"00",1:AASRHSR)
	S AASRHRA=$P(AAS1655("N3"),U,6) S AASRHRA=$S(AASRHRA=""!(AASRHRA<0):" ",AASRHRA=6:" ",AASRHRA>9:" ",1:AASRHRA)
	S AASRXCH=$P(AAS1655("N3"),U,13) S AASRXCH=$S(AASRXCH=""!(AASRXCH<0)!(AASRXCH>9):" ",AASRXCH>3&(AASRXCH<7):" ",1:AASRXCH)
	S AASRST=$P(AAS1655("N3"),U,16) S AASRST=$S(AASRST=""!(AASRST<0)!(AASRST>9):" ",AASRST>3&(AASRST<7):" ",1:AASRST)
	S AASRXBR=$P(AAS1655("N3"),U,19)
	S:AASRXBR'="" AASRXBR=$P($G(^ONCO(160.5,AASRXBR,0)),U,1)
	S AASRXBR=$S(AASRXBR=""!(AASRXBR<0)!(AASRXBR>9):" ",AASRXBR>1&(AASRXBR<7):" ",1:AASRXBR)
	S AASROC=$P(AAS1655("N3"),U,25) S AASROC=$S(AASROC=""!(AASROC<0)!(AASROC>9):" ",AASROC>3&(AASROC<6):" ",1:AASROC)
	S ^TMP($J,D0,225)=AASACCH_"   "_AASHAD_AASHDD_AASCASE_AASRHSR_AASRHRA_AASRXCH_AASRST_AASRXBR_AASROC
	G AASTEOD^ONCOANC1
	Q
ONCOPS(TMP1)	;
	N TMP
	S TMP=$G(^ONCO(164,+TMP1,0))
	S TMP=$P(TMP,U,2)
	Q $S(TMP'?1"C"2N1"."1N:"    ",1:$P(TMP,".")_$P(TMP,".",2))
TPREP	;
	N NAME,DATA,NEXT,REQ
	D:PG=0 HEAD
	F NEXT=1:1 D PTNEXT(.NAME,.DATA,.NEXT,.REQ) Q:NEXT=0  Q:$D(ONCOUT)  D
	.W !,NAME,?50,DATA X ONCOFF Q:$D(ONCOUT)
	Q:$D(ONCOUT)  I $Y>3 D CFORM
	Q
REQREP	;
	N NAME,DATA,NEXT,REQ,RECID
	F NEXT=1:1 D PTNEXT(.NAME,.DATA,.NEXT,.REQ) Q:+NEXT=0  Q:$D(ONCOUT)  D:REQ'=""
	.I '$D(RECID) S RECID=$$GDATA(2,6) X ONCOFF Q:$D(ONCOUT)  D:PG=0 HEAD W !,"Patient ID",?50,RECID,!,"Primary Site",?50,$$GDATA(119,122)
	.W !,NAME,?50,"******" X ONCOFF Q:$D(ONCOUT)  ;DATA
	I $D(RECID) S ONCOECNT=ONCOECNT+1 W ! X ONCOFF Q:$D(ONCOUT)  I $Y>3 D CFORM
	Q
PTNEXT(NAME,DATA,NEXT,REQ)	;
	N START,END,TMP
	S TMP=$TEXT(DATA+NEXT^ONCOANCF)
	I TMP'="" D
	.S NAME=$P($P(TMP,";;",2),U),START=$P(TMP,U,2),END=$P(TMP,U,3)
	.S DATA=$$GDATA(START,END),REQ=$P(TMP,U,4) D:REQ[":" CHKOR(.REQ)
	.S REQ=$S(REQ="":"",$E(DATA,1,$L(DATA))=$E(AASBLNK,1,$L(DATA)):1,1:"")
	S:TMP="" NEXT=0
	Q
CHKOR(REQ)	;
	N START,END,DATA1
	S START=$P($P(REQ,":",2),","),END=$P($P(REQ,":",2),",",2)
	S DATA1=$$GDATA(START,END)
	S REQ=$S($E(DATA1,1,$L(DATA1))=$E(AASBLNK,1,$L(DATA1)):1,1:"")
	Q
GDATA(START,END)	;
	N NODE,BASE S (BASE,NODE)=0
	F  S NODE=$O(^TMP($J,D0,NODE)) Q:+NODE=0  Q:(((BASE+$L(^(NODE)))>END)!(BASE+$L(^(NODE))=END))  S BASE=BASE+$L(^(NODE))
	Q $S(+NODE=0:" ",1:$E(^TMP($J,D0,NODE),START-BASE,END-BASE))
CFORM	;
	S DN=1,ONCOY="" R:IOST["C-" !!,"Press Return to Continue, '^' to escape: ",ONCOY:DTIME S:'$T ONCOY=U S:ONCOY=U ONCOUT=1,DN=0 Q:$D(ONCOUT)  D:DN HEAD^ONCOANC2 K ONCOY
	Q
HEAD	;
	S PG=PG+1 W @IOF,!,"Pg. "_PG,?79-$L(" Oncology ACOS Report "),"Oncology ACOS Report"
	I (PG>1),(IOST["C-") W ! Q
	W:$D(ONCOREP) !,$$HEDSTAR("Oncology ACOS Report ",77)
	W:$D(ONCOREQ) !,$$HEDSTAR("Oncology ACOS Required data Report ",77)
	N FFF S $P(FFF,"- ",40)="- " W !,FFF,!
	Q
HEDSTAR(X,X1)	;    surround text string X with asterisks to length X1
	N Y1
	S (TY,Y1)="",$P(Y1," ",X1-$L(X)\2-1)=" ",TY=Y1_" "_X_" "
	F I=$L(TY):1:X1 S TY=TY_" "
	Q TY
