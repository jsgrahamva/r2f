PSUAR3	;BIR/PDW - PBM AR/WS EXTRACT DETAILED MAIL GENERATOR ; 1/12/09 12:12pm
	;;4.0;PHARMACY BENEFITS MANAGEMENT;**15**;MARCH, 2005;Build 2
	; DBIA(s)
	; Reference to file  #4.3 supported by DBIA 2496
	; Reference to file #40.8 supported by DBIA 2438
	;PSULC  = Line processing in ^tmp
	;PSUTLC = Total Line count
	;PSUMC  = Message counter
	;PSUMLC = Message Line Counter
	; RETURNS 
	;PSUMSG("M") = # Messages
	;PSUMSG("L") = # Lines
	;
EN(PSUMSG)	;Scan and process for Division(s)
	; PSUMSGT ("M")= # MESSAGES  ("L")= # LINES
	;
	;   restore variables
	S PSUVARS="PSUSDT,PSUEDT,PSUMON,PSUDUZ,PSUMASF,PSUPBMG,PSUSMRY,ZTIO,PSUSNDR,PSUOPTS"
	F I=1:1:$L(PSUVARS,",") S @$P(PSUVARS,",",I)=$P(^XTMP("PSU_"_PSUJOB,1),U,I)
	;S PSUMSG(PSUDIV,3,"M")=0,PSUMSG("L")=0
	I $G(PSUMASF)!$G(PSUDUZ)!$G(PSUPBMG) D
	.I '$D(^XTMP(PSUARSUB,"RECORDS")) D NODATA Q
	.S PSUDIV=0,Z=0
	.F  S PSUDIV=$O(^XTMP(PSUARSUB,"RECORDS",PSUDIV)) Q:PSUDIV=""  D
	.. D XMD^PSUAR3(.Z) ; ==> process one division
	.. S PSUMSG(PSUDIV,3,"M")=$G(PSUMSG(PSUDIV,3,"M"))+Z("M")
	.. S PSUMSG(PSUDIV,3,"L")=$G(PSUMSG(PSUDIV,3,"L"))+Z("L")
	Q
XMD(PSUMSG)	;EP returns PSUMSG("M")= # MESSAGES ("L")= # LINES
	NEW PSUMAX,PSULC,PSUTMC,PSUTLC,PSUMC
	; Scan TMP, split lines, transmit per MAX lines in Netmail
	S PSUMAX=$$VAL^PSUTL(4.3,1,8.3)
	S:PSUMAX'>0 PSUMAX=10000
	;
	;   Split and store into ^XTMP(PSUARSUB,"XMD",PSUMC,PSUMLC)
	K ^XTMP(PSUARSUB,"XMD")
	S PSUMC=1,PSUMLC=0
	F PSULC=1:1 S X=$G(^XTMP(PSUARSUB,"RECORDS",PSUDIV,PSULC)) Q:X=""  D
	. S PSUMLC=PSUMLC+1
	. I PSUMLC>PSUMAX S PSUMC=PSUMC+1,PSUMLC=0,PSULC=PSULC+1 Q  ; +  message
	. I $L(X)<235 S ^XTMP(PSUARSUB,"XMD",PSUMC,PSUMLC)=X Q
	. F I=235:-1:1 S Z=$E(X,I) Q:Z="^"
	. S ^XTMP(PSUARSUB,"XMD",PSUMC,PSUMLC)=$E(X,1,I)
	. S PSUMLC=PSUMLC+1
	. S ^XTMP(PSUARSUB,"XMD",PSUMC,PSUMLC)="*"_$E(X,I+1,999)
	;
	;   Count Lines sent
	S PSUTLC=0
	F PSUM=1:1:PSUMC S X=$O(^XTMP(PSUARSUB,"XMD",PSUM,""),-1),PSUTLC=PSUTLC+X
	;
	;   Transmit Messages
VARS	; Setup variables for contents
	F PSUM=1:1:PSUMC D
	. S X=PSUDIV,DIC=40.8,DIC(0)="X",D="C" D IX^DIC ;**1
	. S X=+Y S PSUDIVNM=$$VAL^PSUTL(40.8,X,.01)
	. S XMSUB="V. 4.0 PBMAR "_$G(PSUMON)_" "_PSUM_"/"_PSUMC_" "_PSUDIV_" "_PSUDIVNM
	. S XMTEXT="^XTMP(PSUARSUB,""XMD"",PSUM,"
	. S XMDUZ=DUZ
	. M XMY=PSUXMYH
	. S XMCHAN=1
	. I $G(PSUMASF)!$G(PSUDUZ)!$G(PSUPBMG) D
	..I '$G(PSUSMRY) D ^XMD
	;
	S PSUMSG("M")=PSUMC
	S PSUMSG("L")=PSUTLC
	M ^XTMP(PSUARSUB,"MSGCOUNT")=PSUMSG ; 
	Q
	;
NODATA	;EP Build a NODATA Message
	S PSUDIV=PSUSNDR
	S PSUMSG(PSUDIV,11,"M")=PSUMASF,PSUMSG(PSUDIV,11,"L")=0
	S XMDUZ=DUZ
	M XMY=PSUXMYH
	S (X,PSUDIV)=PSUSNDR,DIC=40.8,DIC(0)="X",D="C" D IX^DIC ;**1
	S X=+Y S PSUDIVNM=$$VAL^PSUTL(40.8,X,.01)
	S PSUM=1,PSUMC=1
	;PSU*4*15
	S XMSUB="V. 4.0 PBMAR "_$G(PSUMON)_" "_PSUM_"/"_PSUMC_" "_PSUDIV_" "_PSUDIVNM
	N X
	S X(1)="No data to report"
	S XMTEXT="X("
	S XMCHAN=1
	;I $G(PSUMASF) D ^XMD
	D ^XMD
	S PSUMSG(PSUDIV,3,"M")=1,PSUMSG(PSUDIV,3,"L")=0
	Q
