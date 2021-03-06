HLOUSR	;ALB/CJM/OAK/PIJ/RBN -ListManager Screen for viewing system status;12 JUN 1997 10:00 am ;02/28/2012
	;;1.6;HEALTH LEVEL SEVEN;**126,130,134,137,138,139,146,147,153,158,163**;Oct 13, 1995;Build 3
	;;Per VA Directive 6402, this routine should not be modified.
	;
EN	;
	;
	N HLSCREEN,TESTOPEN,HLRFRSH,HLPARMS
	D WAIT^DICD
	D EN^VALM("HLO SYSTEM MONITOR")
	Q
	;
BRIEF	;
	N COUNT,LINK,QUE,FROM,TIME,STATUS,TEMP,DIR,TODAY,LIST,LNKMSG,OS
	S HLRFRSH="BRIEF^HLOUSR"
	S (HLSCREEN,VALMSG)="Brief System Status"
	S VALMCNT=16
	;K @VALMAR
	S OS=$$OS^%ZOSV
	;
	D CLEAN^VALM10
	S VALMBG=1
	S VALMBCK="R"
	S VALMDDF("COL 1")="COL1^1^80^"
	K VALMDDF("COL 2"),VALMDDF("COL 3"),VALMDDF("COL 4"),VALMDDF("COL 5")
	D CHGCAP^VALM("COL 1"," Brief Operational Overview")
	S @VALMAR@(1,0)="SYSTEM STATUS:             "_$S($$CHKSTOP^HLOPROC:"STOPPED",1:"RUNNING")
	S @VALMAR@(2,0)="PROCESS MANAGER:           "_$S($$RUNNING:"RUNNING",1:"STOPPED")
	;
	;
	I $$CHKSTOP^HLOPROC,OS'["VMS" S TESTOPEN("LISTENER")=""
	S TIME=$P($G(TESTOPEN("LISTENER")),"^",2)
	I TIME,$$FMDIFF^XLFDT($$NOW^XLFDT,TIME,2)<100 D
	.S STATUS=+TESTOPEN("LISTENER")
	E  D
	.;** P147 START CJM
	.;is the Kernel listener running under the HLO process manager?
	.S STATUS=$$KLISTEN
	.;
	.;if the Kernel listner is NOT running, might check the listener via the OPEN command.  With loadbalancing, the IP address of the listener link sometimes fails, so also try 'loopback'.
	.I 'STATUS,(OS["VMS")!('$$CHKSTOP^HLOPROC) D
	..N IP,LINK
	..S LINK=$P($G(^HLD(779.1,1,0)),"^",10)
	..I LINK,$$GET^HLOTLNK(LINK,.LINK) D
	...;ADD LOOPBACK FOR IPV6 - HL*1.6*163
	...;$$CONVERT^XLFIPV(IP) API (ICR #5844)
	...F IP=$$CONVERT^XLFIPV("127.0.0.1"),$$CONVERT^XLFIPV("0.0.0.0"),LINK("IP") D  Q:STATUS
	....N POP,IO,IOF,IOST
	....D CALL^%ZISTCP(IP,LINK("PORT"),5)
	....S STATUS='POP
	....C:STATUS IO
	.;
	.S:(('STATUS)&('$$CHKSTOP^HLOPROC)) LNKMSG=$S(OS["VMS":" Please start the HLO VMS TCPIP SERVICE",1:"Please start the HLO Listener")
	.;
	.;** P147 END CJM
	.;
	.D:'STATUS CNTRL^VALM10(3,38,85,IOINHI,IOINORM)
	.S TESTOPEN("LISTENER")=STATUS_"^"_$$NOW^XLFDT
	;
	S @VALMAR@(3,0)="STANDARD LISTENER:         "_$S(STATUS:"RUNNING",1:"STOPPED   ")_$G(LNKMSG)
	;** P139 end **
	;
	S @VALMAR@(4,0)="TASKMAN:                   "_$S($$TM^%ZTLOAD:"RUNNING",1:"STOPPED")
	;
	S (LIST,LINK)=""
	F  S LINK=$O(^HLTMP("FAILING LINKS",LINK)) Q:LINK=""  D  I $L(LIST)>60 S LIST=LIST_",..." Q
	.N TIME,QUE,LINKARY
	.I $$GETLINK^HLOTLNK($P(LINK,":"),.LINKARY)
	.S TIME=$G(^HLTMP("FAILING LINKS",LINK)) Q:TIME=""
	.I '$G(LINKARY("SHUTDOWN")),TIME="" Q
	.I '$G(LINKARY("SHUTDOWN")),($$HDIFF^XLFDT($H,TIME,2)<300) Q
	.;;***patch HL*1.6*138 start
	.S LIST=LIST_$S($L(LIST):", ",1:"")_LINK
	.;;.S LIST=LIST_$S($L(LIST):", ",1:"")_$P(LINK,":")
	.;; ***patch HL*1.6*138 end
	S @VALMAR@(5,0)="DOWN LINKS: "_LIST
	S @VALMAR@(6,0)="CLIENT LINK PROCESSES:     "_+$G(^HLC("HL7 PROCESS COUNTS","RUNNING","OUTGOING CLIENT LINK"))
	S @VALMAR@(7,0)="IN-FILER PROCESSES:        "_+$G(^HLC("HL7 PROCESS COUNTS","RUNNING","INCOMING QUEUES"))
	; ***patch HL*1.6*146 START - RBN ***
	;S COUNT=0,LINK=""
	;F  S LINK=$O(^HLC("QUEUECOUNT","OUT",LINK)) Q:LINK=""  D
	;.S QUE=""
	;.F  S QUE=$O(^HLC("QUEUECOUNT","OUT",LINK,QUE)) Q:QUE=""  D
	;..S TEMP=$G(^HLC("QUEUECOUNT","OUT",LINK,QUE))
	;..S:TEMP>0 COUNT=COUNT+TEMP
	N CNTARRAY
	S COUNT=$$OUT^HLOQUE(.CNTARRAY)
	; ***patch HL*1.6*146 END - RBN ***
	S @VALMAR@(8,0)="MESSAGES PENDING ON OUT QUEUES:    "_$$RJ(+COUNT,7)_"     ON SEQUENCE QUEUES:  "_$$RJ(+$G(^HLC("QUEUECOUNT","SEQUENCE")),7)
	S TEMP="STOPPED OUTGOING QUEUES: "
	S COUNT=0,QUE=""
	F  S QUE=$O(^HLTMP("STOPPED QUEUES","OUT",QUE)) Q:QUE=""  S COUNT=COUNT+1 Q:COUNT>4  S:COUNT=1 TEMP=TEMP_QUE S:"23"[COUNT TEMP=TEMP_"; "_QUE S:COUNT=4 TEMP=TEMP_" ..."
	S @VALMAR@(9,0)=TEMP
	; ***patch HL*1.6*146 START - RBN ***
	;S COUNT=0,QUE=""
	;F  S QUE=$O(^HLC("QUEUECOUNT","IN",QUE)) Q:QUE=""  D
	;.S FROM=""
	;.F  S FROM=$O(^HLC("QUEUECOUNT","IN",QUE,FROM)) Q:FROM=""  D
	;..S TEMP=$G(^HLC("QUEUECOUNT","IN",QUE,FROM))
	;..S:TEMP>0 COUNT=COUNT+TEMP
	S COUNT=0
	K CNTARRAY
	S COUNT=$$IN^HLOQUE(.CNTARRAY)
	; ***patch HL*1.6*146 END - RBN ***
	S @VALMAR@(10,0)="MESSAGES PENDING ON APPLICATIONS: "_$$RJ(+COUNT,7)
	S TEMP="STOPPED INCOMING QUEUES: "
	S COUNT=0,QUE=""
	F  S QUE=$O(^HLTMP("STOPPED QUEUES","IN",QUE)) Q:QUE=""  S COUNT=COUNT+1 Q:COUNT>4  S:COUNT=1 TEMP=TEMP_QUE S:"23"[COUNT TEMP=TEMP_"; "_QUE S:COUNT=4 TEMP=TEMP_" ..."
	S @VALMAR@(11,0)=TEMP
	S @VALMAR@(12,0)="FILE 777 RECORD COUNT:         "_$$RJ($P($G(^HLTMP("FILE 777 RECORD COUNT")),"^"),10)_"     --> as of "_$$FMTE^XLFDT($P($G(^HLTMP("FILE 777 RECORD COUNT")),"^",2))
	S @VALMAR@(13,0)="FILE 778 RECORD COUNT:         "_$$RJ($P($G(^HLTMP("FILE 778 RECORD COUNT")),"^"),10)_"     --> as of "_$$FMTE^XLFDT($P($G(^HLTMP("FILE 778 RECORD COUNT")),"^",2))
	S TODAY=$$DT^XLFDT
	S @VALMAR@(14,0)="MESSAGES SENT TODAY:           "_$$RJ($$ADD("OUT"),10)
	S @VALMAR@(15,0)="MESSAGES RECEIVED TODAY:       "_$$RJ($$ADD("IN"),10)
	S @VALMAR@(16,0)="MESSAGE ERRORS TODAY:          "_$$RJ($$ADD("EOUT")+$$ADD("EIN"),10)
	Q
	;
ADD(DIR)	;
	N RAP,SAP,TIME,TOTAL,TYPE
	S TOTAL=0
	S TIME=TODAY-.0001
	F  S TIME=$O(^HLSTATS(DIR,"HOURLY",TIME)) Q:'TIME  Q:((TIME\1)>TODAY)  D
	.S SAP=""
	.F  S SAP=$O(^HLSTATS(DIR,"HOURLY",TIME,SAP)) Q:SAP=""  D
	..Q:SAP="ACCEPT ACK"
	..S RAP=""
	..F  S RAP=$O(^HLSTATS(DIR,"HOURLY",TIME,SAP,RAP)) Q:RAP=""  D
	...S TYPE=""
	...F  S TYPE=$O(^HLSTATS(DIR,"HOURLY",TIME,SAP,RAP,TYPE)) Q:TYPE=""  D
	....S TOTAL=TOTAL+$G(^HLSTATS(DIR,"HOURLY",TIME,SAP,RAP,TYPE))
	Q TOTAL
	;
HELP	;
	S X="?" D DISP^XQORM1 W !!
	Q
	;
EXIT	;
	D CLEAN^VALM10
	D CLEAR^VALM1
	Q
	;
EXPND	;
	Q
	;
PROCS	;
	S HLRFRSH="PROCS^HLOUSR"
	;K @VALMAR
	D CLEAN^VALM10
	S VALMCNT=0
	S VALMBCK="R"
	S VALMDDF("COL 1")="COL 1^1^34^"
	S VALMDDF("COL 2")="COL 2^35^10^MIN^H"
	S VALMDDF("COL 3")="COL 3^47^10^MAX^H"
	S VALMDDF("COL 4")="COL 4^59^10^#RUNNING^H"
	S VALMDDF("COL 5")="COL 5^71^10^#QUEUED^IOBON"
	D CHGCAP^VALM("COL 1"," Process Type")
	N IEN
	S IEN=0
	F  S IEN=$O(^HLD(779.3,"C",1,IEN)) Q:'IEN  D
	.N PROC
	.Q:'$$GETPROC^HLOPROC1(IEN,.PROC)
	.Q:PROC("NAME")="VMS TCP LISTENER"
	.S VALMCNT=VALMCNT+1
	.S @VALMAR@(VALMCNT,0)=$$LJ(PROC("NAME"),30)_$$RJ(PROC("MINIMUM"),6)_$$RJ(PROC("MAXIMUM"),12)_$$RJ(+$G(^HLC("HL7 PROCESS COUNTS","RUNNING",PROC("NAME"))),14)_$$RJ(+$G(^HLC("HL7 PROCESS COUNTS","QUEUED",PROC("NAME"))),12)
	S VALMCNT=VALMCNT+1,@VALMAR@(VALMCNT,0)=""
	S IEN=""
	F  S IEN=$O(^HLTMP("HL7 RUNNING PROCESSES",IEN)) Q:IEN=""  D
	.N NODE
	.S NODE=$G(^HLTMP("HL7 RUNNING PROCESSES",IEN))
	.Q:NODE=""
	.S VALMCNT=VALMCNT+1
	.S @VALMAR@(VALMCNT,0)="$J: "_$$LJ(IEN,9)_" ->"_$$CJ($P(NODE,"^",3),28)_"<- started at "_$$HTE^XLFDT($P(NODE,"^"))
	Q
	;
INQUEUE	;
	N FROM
	D CLEAN^VALM10
	;K @VALMAR
	S HLRFRSH="INQUEUE^HLOUSR"
	S (HLSCREEN,VALMSG)="Incoming Queues ('!' = stopped queues)"
	S VALMCNT=0
	S VALMBCK="R"
	S VALMDDF("COL 1")="COL 1^1^40^ From^H"
	S VALMDDF("COL 2")="COL 2^45^20^Queue^H"
	S VALMDDF("COL 3")="COL 3^70^10^Count^H"
	K VALMDDF("COL 4"),VALMDDF("COL 5")
	D CHGCAP^VALM("COL 1"," From")
	S FROM=""
	F  S FROM=$O(^HLC("QUEUECOUNT","IN",FROM)) Q:FROM=""  D
	.N COUNT,QUE,SHOW
	.S SHOW=$$LJ(FROM,40)_"  "
	.S QUE=""
	.F  S QUE=$O(^HLC("QUEUECOUNT","IN",FROM,QUE)) Q:QUE=""  D
	..S COUNT=$G(^HLC("QUEUECOUNT","IN",FROM,QUE))
	..Q:COUNT<0
	..S VALMCNT=VALMCNT+1
	..S @VALMAR@(VALMCNT,0)=SHOW_$$LJ($S($$STOPPED^HLOQUE("IN",QUE):"!",1:"")_QUE,21)_" "_$$RJ(COUNT,10)
	..S SHOW=$$LJ("",40)_"  "
	Q
VIEWLINK	;
	N C,QUIT,LINK,LINKARY,TEMP
	S (QUIT,C,LINK)=""
	S VALMBCK="R"
	;
	;currently HL7 (Optimized) only does TCP
	S LINK=$$ASKLINK
	Q:LINK=""
	Q:'$$GETLINK^HLOTLNK(LINK,.LINKARY)
	S LINK=LINK_":"_LINKARY("PORT")
	W !,"Hit any key to stop...",!
	F  D  Q:QUIT
	.N COUNT,QUE
	.S (COUNT,QUE)=""
	.F  S QUE=$O(^HLC("QUEUECOUNT","OUT",LINK,QUE)) Q:QUE=""  S TEMP=$G(^HLC("QUEUECOUNT","OUT",LINK,QUE)) S:TEMP>0 COUNT=COUNT+TEMP
	.W $C(13),"                             ",$C(13),"MESSAGES PENDING TRANSMISSION: ",IOBON,$$RJ(+COUNT,10),IOBOFF
	.R *C:1 I $T S QUIT=1
	Q
	;
CJ(STRING,LEN)	;
	Q $$CJ^XLFSTR($E(STRING,1,LEN),LEN)
LJ(STRING,LEN)	;
	Q $$LJ^XLFSTR($E(STRING,1,LEN),LEN)
RJ(STRING,LEN)	;
	Q $$RJ^XLFSTR($E(STRING,1,LEN),LEN)
	;
RUNNING()	;Process Manager running?
	N RUNNING
	L +^HLTMP("PROCESS MANAGER"):0
	S RUNNING='$T
	I 'RUNNING L -^HLTMP("PROCESS MANAGER")
	Q RUNNING
	;
TESTLINK	;
	N LINKNAME,OK,PORT,LINK
	S VALMBCK="R"
	S LINKNAME=$$ASKLINK
	Q:LINKNAME=""
	;**P138 START
	S PORT=$$ASKPORT^HLOUSRA(LINKNAME)
	Q:'PORT
	S LINK=LINKNAME_":"_PORT
	;S OK=$$IFOPEN^HLOUSR1(LINKNAME)
	W !,"Testing...." ;P158
	S OK=$$IFOPEN^HLOUSR1(LINK)
	;** P138 END
	I OK W !,LINK_" IS operational..."
	E  W !,LINK_" is NOT operational..."
	W !,"Hit any key to continue..."
	R *C:DTIME
	Q
	;
ASKLINK()	;
	N DIC,TCP,X,Y,DTOUT,DUOUT
	S DIC=870
	S DIC(0)="AEMNQ"
	S TCP=$O(^HLCS(869.1,"B","TCP",0))
	S DIC("A")="Select a TCP link:"
	S DIC("S")="I $P(^(0),U,3)=TCP"
	D FULL^VALM1
	D ^DIC
	I +Y'=-1,'$D(DTOUT),'$D(DUOUT) Q $P(Y,"^",2)
	Q ""
	;
STOP	;
	I '$$ASKYESNO^HLOUSR2("Are you SURE that you want to stop sending and receiving messages","NO") S VALMBCK="" Q
	;
	D STOPHL7^HLOPROC1
	S VALMBCK="R",VALMSG="HL7 (Optimized) has been stopped...."
	H 5
	D @HLRFRSH
	;D:HLSCREEN="Brief System Status" BRIEF^HLOUSR
	;D:HLSCREEN="Running Processes" PROCS^HLOUSR
	Q
	;
UPDMODE	;realtime
	Q:'$L(HLRFRSH)
	N TOP,BOTTOM,DX,DY,IOTM,IOBM,LINE,OLD,OLDCNT
	S OLDCNT=VALMCNT
	W !!!!!,IOINHI,"Hit any key to escape realtime display mode...",IOINORM
	S IOTM=20,IOBM=23 W @IOSTBM
	S TOP=VALMBG
	S BOTTOM=TOP+20
	F LINE=TOP:1:BOTTOM D
	.I LINE>VALMCNT S @VALMAR@(LINE,0)=$$LJ(" ",80) Q
	.S @VALMAR@(LINE,0)=$$LJ($G(@VALMAR@(LINE,0)),80)
	F LINE=TOP:1:BOTTOM D
	.S OLD(LINE)=$G(@VALMAR@(LINE,0))
	F LINE=17:1:BOTTOM D
	.S DX=50,DY=22 X IOXY W !
	.D WRITE^VALM10(LINE)
	D  F  R *C:4 Q:$T  D
	.D @HLRFRSH
	.;**START PATCH 138**
	.S OLDCNT=VALMCNT
	.;**END PATCH 138**
	.F LINE=TOP:1:BOTTOM D
	..I LINE>VALMCNT S @VALMAR@(LINE,0)=$$LJ(" ",80) Q
	..S @VALMAR@(LINE,0)=$$LJ($G(@VALMAR@(LINE,0)),80)
	.S VALMCNT=BOTTOM
	.F LINE=TOP:1:BOTTOM IF OLD(LINE)'=$G(@VALMAR@(LINE,0)) D
	..S OLD(LINE)=$G(@VALMAR@(LINE,0))
	..S DX=50,DY=22 X IOXY W !
	..D WRITE^VALM10(LINE)
	;**START PATCH 138**
	S VALMCNT=OLDCNT
	I VALMCNT<VALMBG S VALMBG=VALMCNT
	;**END PATCH 138**
	S VALMBCK="R"
	Q
	;
EDITSITE	;
	;edit HLO System Parameters
	N DR,DA,DIE
	S DA=$O(^HLD(779.1,0))
	Q:'DA
	S DIE="^HLD(779.1,"
	S DR="[HLO EDIT SYSTEM PARAMETERS]"
	D ^DIE
	Q
	;
LOGALL	;
	N ON,CHANGE,DATA
	;Will turn on/off logging of all errors
	S ON=$G(^HLTMP("LOG ALL ERRORS"))
	W !!,"Logging of all HLO errors is turned ",$S(ON:"ON",1:"OFF"),"."
	W !!,"Logging of all HLO errors, including READ and WRITE errors, should be turned",!,"on only for short periods for troubleshooting purposes.",!
	S CHANGE=$$ASKYESNO^HLOUSR2("Do you want logging of all HLO errors turned "_$S(ON:"OFF",1:"ON"),$S(ON:"YES",1:"NO"))
	Q:'CHANGE
	S ON='ON
	S ^HLTMP("LOG ALL ERRORS")=ON
	W !,"Logging of all HLO errors is turned ",$S(ON:"ON",1:"OFF"),"."
	Q
	;
KLISTEN()	;
	;checks if the Kernel multi-listener is running
	N DOLLARJ,FOUND
	S DOLLARJ=""
	S FOUND=0
	F  S DOLLARJ=$O(^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ)) Q:DOLLARJ=""  I $P($G(^HLTMP("HL7 RUNNING PROCESSES",DOLLARJ)),"^",3)["TASKMAN MULTI-LISTENER" S FOUND=1 Q
	Q FOUND
