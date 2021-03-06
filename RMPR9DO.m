RMPR9DO	;HOIFO/HNC -  ORDER CONROL PROCESSING-REMOTE PROCEDURE ;9/8/03  07:12
	;;3.0;PROSTHETICS;**59,77,90,60,135,163**;Feb 09, 1996;Build 9
	;
	;8/5/03 Make sure no dups, HNC patch 77
	;
	;Patch RMPR*3.0*163 check all three $O for x-ref 'L', 'L1' and 'CD' to
	;insure the linked master record has a node 0 defined.
	;
A1(START,STOP,SITE,SORT,DATE,WHAT)	;entry point for rollup
	;activated from (option name)
	I WHAT="S" D
	.S STN1=0
	.F  S STN1=$O(^RMPR(669.9,STN1)) Q:STN1'>0  D
	. .S SITE=STN1
	. .D A2
	I WHAT="ALL" G A2
	Q
EN(RESULT,DUZ,START,STOP,SITE,SORT,DATE,RMPRPRSN)	; -- Broker callback to get list to display
	;entry to send to PCM, WHAT=ALL or S for Summary Only
	;RMPRPRSN=P for Purchasing D for Delayed Order Report
	S (WHO,RMPRSC)=""
	I RMPRPRSN="P" S RMPRSC=$O(^RMPR(669.9,"PA",DUZ,RMPRSC)) Q:(RMPRSC="")!(WHO'="")  D
	. I '$D(^RMPR(669.9,RMPRSC,0)) Q
	. I '$D(^RMPR(669.9,RMPRSC,5,"B",DUZ)) Q
	. S WHO=$O(^RMPR(669.9,RMPRSC,5,"B",DUZ,""))
	. I START="" S START=$P(^RMPR(669.9,RMPRSC,5,WHO,0),U,2)
	. I STOP="" S STOP=$P(^RMPR(669.9,RMPRSC,5,WHO,0),U,3)
A2	N STRING,CLREND,COLUMN,ON,OFF
	Q:SORT=""
	Q:DATE=""
	Q:START=""
	Q:STOP=""
	Q:SITE=""
	I SITE'="ALL" S SITE=$P(^RMPR(669.9,SITE,0),U,2)
	K ^TMP($J)
	N RMPRA,CDATE,X
	K ADATE,PDAY,RMPRCD
	S VALMCNT=0,RRX=""
	;if sort for open or pending include all regardless of date
	;if sort for cancelled or closed include from date passed forward
	;
	;PPD# status=pending before date, total days create to 1st action
	;MHD# manual totals days create to 1st action
	;CHD# consult totals days create to 1st action
	;PPDD# status=pending before date, total days in pending state, 1st
	;      action to current date
	;
	S (LINE,MHD1,MHD2,MHD3,MHD4,MHD5,CHD1,CHD2,CHD3,CHD4,CHD5,CLNK,MLNK)=0
	S (PPDAY,PPD,PPD1,PPD2,PPD3,PPD4,PPD5)=0
	S (PPDDAY,PPDD1,PPDD2,PPDD3,PPDD4,PPDD5)=0
	I SORT["O"!(SORT["P") D ALL
	I SORT["C"!(SORT["X") D DTFWD
	;S LINE=LINE+1
	S ^TMP($J,"A1")="^^^^^^^^"_MHD1_U_MHD2_U_MHD3_U_MHD4_U_MHD5_"^^^^"_MLNK_U_0
	I $G(WHAT)="S" S RMPRXM(1)=MHD1_U_MHD2_U_MHD3_U_MHD4_U_MHD5_U_MLNK_U_0
	;S LINE=LINE+1
	S ^TMP($J,"A2")="^^^^^^^^"_CHD1_U_CHD2_U_CHD3_U_CHD4_U_CHD5_"^^^^"_CLNK_U_1
	I $G(WHAT)="S" S RMPRXM(2)=CHD1_U_CHD2_U_CHD3_U_CHD4_U_CHD5_U_CLNK_U_1
	;S LINE=LINE+1
	I $G(WHAT)="S" S RMPRXM(3)=PPD1_U_PPD2_U_PPD3_U_PPD4_U_PPD5_U_U_2
	S ^TMP($J,"A3")="^^^^^^^^"_PPDD1_U_PPDD2_U_PPDD3_U_PPDD4_U_PPDD5_"^^^^^"_2
	;S LINE=LINE+1
	S ^TMP($J,"A4")="^^^^^^^^"_PPD1_U_PPD2_U_PPD3_U_PPD4_U_PPD5_"^^^^^"_3
	;quarter rollup with full data
	I $G(WHAT)="Q" D MAIL
	;summary only
	I $G(WHAT)="S" D MAILG
	I $G(WHAT)="ALL" D MAILG,MAIL
	I '$G(WHAT) G EXIT
	Q
ALL	;all open pending records regardless of date passed
	S RMPRI1=0
	F RMPRI1=START:1:STOP D
	.I $L(RMPRI1)=1 S RMPRI=0_RMPRI1
	.E  S RMPRI=RMPRI1
	.S RMPRST=""
	.F  S RMPRST=$O(^RMPR(668,"L1",RMPRI,RMPRST)) Q:RMPRST=""  D
	. .Q:RMPRST="X"
	. .Q:RMPRST="C"
	. .I SORT'["P"&(RMPRST="P") Q
	. .S RMPRA=0
	. .F  S RMPRA=$O(^RMPR(668,"L1",RMPRI,RMPRST,RMPRA)) Q:RMPRA'>0  D
	. . .Q:'$D(^RMPR(668,RMPRA,0))    ;;Patch RMPR*3.0*163 check
	. . .S STN=$P(^RMPR(668,RMPRA,0),U,7)
	. . .I SITE'="ALL"&(SITE'=STN) Q
	. . .S STNX=$$STATN^RMPRUTIL(STN)
	. . .I $G(WHAT)="S" S VISNX=$P($G(^RMPR(669.9,STN1,"INV")),U,2)
	. . .S STS=$P(^RMPR(668,RMPRA,0),U,10)
	. . .Q:STS["X"
	. . .Q:STS["C"
	. . .I SORT'["O"&(STS="O") Q
	. . .I SORT'["P"&(STS="P") Q
	. . .D REC
	Q
DTFWD	;from date passed forward
	S RMPRI1=0
	F RMPRI1=START:1:STOP D
	.I $L(RMPRI1)=1 S RMPRI=0_RMPRI1
	.E  S RMPRI=RMPRI1
	.S RMPRDTM=""
	.F  S RMPRDTM=$O(^RMPR(668,"L",RMPRI,RMPRDTM)) Q:RMPRDTM=""  D
	..Q:RMPRDTM=""
	..Q:RMPRDTM<DATE
	..S RMPRST=""
	..F  S RMPRST=$O(^RMPR(668,"L",RMPRI,RMPRDTM,RMPRST)) Q:RMPRST=""  D
	.. .Q:RMPRST="O"
	.. .Q:RMPRST="P"
	.. .I SORT'["X"&(RMPRST="X") Q
	.. .I SORT'["C"&(RMPRST="C") Q
	.. .S RMPRA=0
	.. .F  S RMPRA=$O(^RMPR(668,"L",RMPRI,RMPRDTM,RMPRST,RMPRA)) Q:RMPRA'>0  D
	.. . .Q:'$D(^RMPR(668,RMPRA,0))      ;;;;Patch RMPR*3.0*163 check
	.. . .Q:RMPRA=""
	.. . .S STN=$P(^RMPR(668,RMPRA,0),U,7)
	.. . .I SITE'="ALL"&(SITE'=STN) Q
	.. . .S STNX=$$STATN^RMPRUTIL(STN)
	.. . .I $G(WHAT)'="" S VISNX=$P($G(^RMPR(669.9,SITE,"INV")),U,2)
	.. . .S STS=$P(^RMPR(668,RMPRA,0),U,10)
	.. . .Q:STS["O"
	.. . .Q:STS["P"
	.. . .I SORT'["C"&(STS="C") Q
	.. . .I SORT'["X"&(STS="X") Q
	.. . .D REC
	S RMPRDTC=$P(DATE,".",1)
	F  S RMPRDTC=$O(^RMPR(668,"CD",RMPRDTC)) Q:RMPRDTC=""  D
	.Q:RMPRDTC<DATE
	.S RMPRDYS=0
	.F  S RMPRDYS=$O(^RMPR(668,"CD",RMPRDTC,RMPRDYS)) Q:RMPRDYS=""  D
	. .Q:RMPRDYS'>5
	. .S RMPRA=0
	. .F  S RMPRA=$O(^RMPR(668,"CD",RMPRDTC,RMPRDYS,RMPRA)) Q:RMPRA'>0  D
	. . .Q:'$D(^RMPR(668,RMPRA,0))     ;;Patch RMPR*3.0*163 check
	. . .;check site
	. . .S STN=$P(^RMPR(668,RMPRA,0),U,7)
	. . .I SITE'="ALL"&(SITE'=STN) Q
	. . .S STNX=$$STATN^RMPRUTIL(STN)
	. . .;check status
	. . .S STS=$P(^RMPR(668,RMPRA,0),U,10)
	. . .I SORT'["O"&(STS="O") Q
	. . .I SORT'["P"&(STS="P") Q
	. . .I SORT'["C"&(STS="C") Q
	. . .I SORT'["X"&(STS="X") Q
	. . .;ssn range filter
	. . .S DFN=$P(^RMPR(668,RMPRA,0),U,2)
	. . .D DEM^VADPT
	. . .S SSNEN=$E($P(VADM(2),"^",2),10,11)
	. . .I SSNEN>STOP Q
	. . .I SSNEN<START Q
	. . .K SSNEN,VADM
	. . .D REC
	Q
REC	;records to grid
	;stop date, init action date
	;check ien, patch 77
	;
	Q:$D(^TMP($J,RMPRA))
	;
	N DIC,DIQ,DR,STOPDT
	S DA=RMPRA
	S DIC=668,DIQ="RE",DR=10,DIQ(0)="EN" D EN^DIQ1
	S STOPDT=$P($G(^RMPR(668,RMPRA,0)),U,9),STOPDT=$$DAT2^RMPRUTL1(STOPDT)
	S LINE=LINE+1
	S CDATE=$P(^RMPR(668,RMPRA,0),U,1),CDATE=$$DAT2^RMPRUTL1(CDATE)
	S DFN=$P(^RMPR(668,RMPRA,0),U,2) Q:DFN=""
	N VA,VADM
	D DEM^VADPT
	S WHO=VADM(1)
	S SSN=VADM(2)
	D SVC^VADPT
	S RMPROEOI=$S(VASV(11)>0:"<!>",VASV(12)>0:"<!>",VASV(13)>0:"<!>",1:0)
	D KVAR^VADPT
	;type
	S TYPE=$$TYPE^RMPREOU(RMPRA,8)
	;display description if manual
	S DES=$$DES^RMPREOU(RMPRA,22)
	S DES=$TR(DES,"^","*")
	S DES=$TR(DES,"""","'")
	;init action date
	S ADATE="",PDAY="",WRKDAY=""
	S ADATE=$P(^RMPR(668,RMPRA,0),U,9)
	;PPD=1 for previous pending
	I ADATE'="" S (PDAY,WRKDAY)=$$WRKDAY^RMPREOU(RMPRA)
	I ADATE="" S (PDAY,WRKDAY)=$$CWRKDAY^RMPREOU(RMPRA) I $P(^RMPR(668,RMPRA,0),U,10)="X" S (PDAY,WRKDAY)=$$CANWKDY^RMPREOU(RMPRA)
	I ADATE'="" S CDAY=$$PDAY^RMPREOU(RMPRA)
	;
	S STATUS=$$STATUS^RMPREOU(RMPRA)
	I STATUS["PENDING" D
	.I ADATE'=""&(ADATE<DATE) S PPD=1
	.S PPDAY=$$PWRKDAY^RMPREOU(RMPRA)
	S LINKED=$P($G(^RMPR(668,RMPRA,10,0)),U,4)
	I LINKED="" S LINKED=0
	;
	I RMPROEOI="<!>" S WHO=RMPROEOI_WHO
	S ^TMP($J,RMPRA)=CDATE_U_WHO_U_SSN_U_TYPE_U_DES_U
	;look at pday and parse
	S (HD1,HD2,HD3,HD4,HD5,DH6)=""
	;SD Working Days in Pending Status
	S (SD1,SD2,SD3,SD4,SD5)=0
	I (PDAY>0)&(PDAY<6)!(PDAY=0) S HD1=PDAY,DH6="NO"
	I (PPDAY>0)&(PPDAY<6)!(PPDAY=0) S SD1=PPDAY
	I (PDAY>0)&(PDAY<6)&(TYPE["MANUAL")!(PDAY=0)&(TYPE["MANUAL") S MHD1=MHD1+1
	I (PDAY>0)&(PDAY<6)&(TYPE'["MANUAL")!(PDAY=0)&(TYPE'["MANUAL") S CHD1=CHD1+1
	I (PPDAY>0)&(PPDAY<6)&(STATUS["PENDING") S PPDD1=PPDD1+1
	I (PDAY>0)&(PDAY<6)&(PPD=1) S PPD1=PPD1+1
	I HD1=""  S HD1=0
	I (PDAY>5)&(PDAY<10) S HD2=PDAY,DH6="YES"
	I (PPDAY>5)&(PPDAY<10) S SD2=PPDAY
	I (PDAY>5)&(PDAY<10)&(TYPE["MANUAL") S MHD2=MHD2+1
	I (PDAY>5)&(PDAY<10)&(TYPE'["MANUAL") S CHD2=CHD2+1
	I (PPDAY>5)&(PPDAY<10)&(STATUS["PENDING") S PPDD2=PPDD2+1
	I (PDAY>5)&(PDAY<10)&(PPD=1) S PPD2=PPD2+1
	I HD2="" S HD2=0
	I (PDAY>9)&(PDAY<30) S HD3=PDAY,DH6="YES"
	I (PPDAY>9)&(PPDAY<30) S SD3=PPDAY
	I (PDAY>9)&(PDAY<30)&(TYPE["MANUAL") S MHD3=MHD3+1
	I (PDAY>9)&(PDAY<30)&(TYPE'["MANUAL") S CHD3=CHD3+1
	I (PPDAY>9)&(PPDAY<30)&(STATUS["PENDING") S PPDD3=PPDD3+1
	I (PDAY>9)&(PDAY<30)&(PPD=1) S PPD3=PPD3+1
	I HD3="" S HD3=0
	I (PDAY>29)&(PDAY<90) S HD4=PDAY,DH6="YES"
	I (PPDAY>29)&(PPDAY<90) S SD4=PPDAY
	I (PDAY>29)&(PDAY<90)&(TYPE["MANUAL") S MHD4=MHD4+1
	I (PDAY>29)&(PDAY<90)&(TYPE'["MANUAL") S CHD4=CHD4+1
	I (PPDAY>29)&(PPDAY<90)&(STATUS["PENDING") S PPDD4=PPDD4+1
	I (PDAY>29)&(PDAY<90)&(PPD=1) S PPD4=PPD4+1
	I HD4="" S HD4=0
	I PDAY>89 S HD5=PDAY,DH6="YES"
	I PPDAY>89 S SD5=PPDAY
	I (PDAY>89)&(TYPE["MANUAL") S MHD5=MHD5+1
	I (PDAY>89)&(TYPE'["MANUAL") S CHD5=CHD5+1
	I (PPDAY>89)&(STATUS["PENDING") S PPDD5=PPDD5+1
	I (PDAY>89)&(PPD=1) S PPD5=PPD5+1
	I HD5="" S HD5=0
	S (PPD,PPDAY)=0
	I LINKED'=0&(TYPE["MANUAL") S MLNK=MLNK+1
	I LINKED'=0&(TYPE'["MANUAL") S CLNK=CLNK+1
	S ^TMP($J,RMPRA)=^TMP($J,RMPRA)_STOPDT_U_DH6_U_HD1_U_HD2_U_HD3_U_HD4_U_HD5
	S ^TMP($J,RMPRA)=^TMP($J,RMPRA)_U_STATUS_U_RMPRA_U_STNX_U_LINKED
	S ^TMP($J,RMPRA)=^TMP($J,RMPRA)_U_U_SD1_U_SD2_U_SD3_U_SD4_U_SD5
	K CDATE,WHO,SSN,TYPE,DES,PDAY,STATUS,ADATE
	;PUT RESULTS IN GLOBAL!!
	Q
EXIT	;common exit point
	S RESULT=$NA(^TMP($J))
	Q
MAIL	;send to PCM full dataset
	S XMY("G.RMPR SERVER")=""
	S XMY("G.PROSTHETICS@PSAS.MED.VA.GOV")=""
	S XMDUZ=.5
	S XMSUB="Full DOR From Station: "_STNX
	N LASTIEN
	S LASTIEN="A1",LASTIEN=$O(^TMP($J,LASTIEN),-1)
	S ^TMP($J,LASTIEN+1)=^TMP($J,"A1")
	S ^TMP($J,LASTIEN+2)=^TMP($J,"A2")
	S ^TMP($J,LASTIEN+3)=^TMP($J,"A3")
	S ^TMP($J,LASTIEN+4)=^TMP($J,"A4")
	K ^TMP($J,"A1")
	K ^TMP($J,"A2")
	K ^TMP($J,"A3")
	K ^TMP($J,"A4")
	S XMTEXT="^TMP($J,"
	D ^XMD
	Q
MAILG	;Mail message to local staff
	S XMDUZ=.5
	S XMY("G.RMPR SERVER")=""
	S XMY("VHACOPSASPIPReport@MED.VA.GOV")=""
	S XMSUB="DOR From Station: "_STNX
	S RMPRMSG(1)="The Automated Delayed Order Report has transmitted to Prosthetics HQ."
	S RMPRMSG(2)="This was activated by "_$P(XMFROM,"@",1)
	S RMPRMSG(3)=""
	S RMPRMSG(4)="Summary Data Transmitted, includes the following:"
	S RMPRMSG(5)="Totals for site "_STNX_" listed in the order of 0-5, 6-9, 10-29, 30-89, 90+"
	S RMPRMSG(6)="Seperated by ;"
	S RMPRMSG(7)="***Number of MANUALS      ;;"_STNX_";"_MHD1_";"_MHD2_";"_MHD3_";"_MHD4_";"_MHD5
	S RMPRMSG(8)="***Number of CONSULTS     ;;"_STNX_";"_CHD1_";"_CHD2_";"_CHD3_";"_CHD4_";"_CHD5
	S RMPRMSG(9)="***Minus Previous Pending ;;"_STNX_";"_PPD1_";"_PPD2_";"_PPD3_";"_PPD4_";"_PPD5
	S RMPRMSG(10)=""
	S XMTEXT="RMPRMSG("
	D ^XMD
	Q
