GMRCHL7I	;DAL/PHH - PROCESS HL7 RRI^I13 MESSAGES FROM HCPS ;8/7/14
	;;3.0;CONSULT/REQUEST TRACKING;**75**;DEC 27, 1997;Build 22
	;
	Q
	; Documented API's and Integration Agreements
	; ----------------------------------------------
	; 2165   GENACK^HLMA1
	; 2701   $$GETDFN^MPIF001
	; 2701   $$GETICN^MPIF001
	; 3535   MAKEADD^TIUSRVP2
	; 10103  $$HL7TFM^XLFDT
	;
EN	; Entry point for routine
	N FS,CS,RS,ES,SS,MID,HLQUIT,HLNODE,I13MSG
	S FS=$G(HL("FS"),"|")
	S CS=$E($G(HL("ECH")),1) S:CS="" CS="^"
	S RS=$E($G(HL("ECH")),2) S:RS="" RS="~"
	S ES=$E($G(HL("ECH")),3) S:ES="" ES="\"
	S SS=$E($G(HL("ECH")),4) S:SS="" SS="&"
	S MID=$G(HL("MID"))
	S (HLQUIT,HLNODE)=0
	D COPYMSG(.I13MSG)
	Q:$$CHKMSG(.I13MSG)
	Q:$$PROCMSG(.I13MSG)
	D ACK("AA",MID)
	Q
	;
COPYMSG(Y)	; Copy HL7 Message to array Y (by reference)
	; Based on HL*1.6*56 VISTA HL7 Site Manager & Developer Manual
	; Paragraph 9.7, page 9-4
	I $L($G(HLNEXT)) ;HL7 context
	E  Q
	N I,J
	F I=1:1 X HLNEXT Q:HLQUIT'>0  D
	.S Y(I)=HLNODE,J=0
	.F  S J=$O(HLNODE(J)) Q:'J  D
	..S Y(I)=Y(I)_HLNODE(J)
	Q
	;
CHKMSG(Y)	; Check Message for all required segments
	N QUIT,REQSEG,SEGFND,I,SEGTYP,ICN,DFN
	S QUIT=0
	F REQSEG="MSH","RF1","PRD","PID","OBR","PV1","NTE" D  Q:QUIT
	.S (SEGFND,I)=0
	.F  S I=$O(Y(I)) Q:'I!(SEGFND)  D
	..S SEGTYP=$E(Y(I),1,3)
	..I SEGTYP=REQSEG S SEGFND=1
	..;
	..I SEGTYP="MSH",$P(Y(I),FS,10)="" D
	...S QUIT=1
	...D ACK("AE",MID,"MSH","",10,101,"MESSAGE CONTROL ID MISSING")
	..;
	.I 'SEGFND D
	..S QUIT=1
	..D ACK("AE",MID,REQSEG,"","",100,REQSEG_" SEGMENT MISSING OR OUT OF ORDER")
	Q QUIT
	;
PROCMSG(Y)	; Process message
	N QUIT,I,SEGTYP,GMRCRF1,GMRCPID,GMRCOBR,GMRCNTE,GMRCIEN,GMRCICN
	N GMRCDFN,GMRCTIU,GMRCTIUS,ADDTXT,GMRCATIU
	S (QUIT,I)=0
	F  S I=$O(Y(I)) Q:'I  D
	.S SEGTYP=$E(Y(I),1,3)
	.I SEGTYP="RF1" D RF1(Y(I),.GMRCRF1)
	.I SEGTYP="PID" D PID(Y(I),.GMRCPID)
	.I SEGTYP="OBR" D OBR(Y(I),.GMRCOBR)
	.I SEGTYP="NTE" D NTE(Y(I),.GMRCNTE)
	;
	S GMRCIEN=+GMRCRF1
	;
	I 'GMRCIEN!('$D(^GMR(123,+GMRCIEN,0))) D  Q QUIT
	.S QUIT=1
	.D ACK("AE",MID,"RF1","",6,"VA207","INVALID IEN FOR CONSULT",1)
	;
	S GMRCICN=GMRCPID
	S GMRCDFN=$$GETDFN^MPIF001($P(GMRCICN,"V"))
	I GMRCDFN'>0 D  Q QUIT
	.S QUIT=1
	.D ACK("AE",MID,"PID",1,3,"VA207",$P(GMRCDFN,"^",2),1)
	I GMRCICN'=$$GETICN^MPIF001(GMRCDFN) D  Q QUIT
	.S QUIT=1
	.D ACK("AE",MID,"PID",1,3,"VA207","ICN CHECKSUM DOES NOT MATCH CHECKSUM IN DATABASE",1)
	;
	I $P(^GMR(123,GMRCIEN,0),"^",2)'=GMRCDFN D  Q QUIT
	.S QUIT=1
	.D ACK("AE",MID,"RF1","",6,"VA207","ICN DOES NOT MATCH PATIENT DFN IN CONSULT",1)
	;
	; Reject if Referral Status is not valid
	I $P(GMRCRF1,FS,2)'="IP^ADDED COMMENT",$P(GMRCRF1,FS,2)'="CM^ADDENDED",$P(GMRCRF1,FS,2)'="IP^REJECTED" D  Q QUIT
	.S QUIT=1
	.D ACK("AE",MID,"RF1","",1,"VA207","INVALID REFERRAL STATUS",1)
	;
	; Add comment to file #123
	I $P(GMRCRF1,FS,2)="IP^ADDED COMMENT"!($P(GMRCRF1,FS,2)="IP^REJECTED") D
	.;
	.; Quit if IEN being passed by HCP isn't for a Consult
	.I +GMRCOBR'=GMRCIEN!($P(GMRCOBR,FS,2)'="GMRC") D  Q
	..S QUIT=1
	..D ACK("AE",MID,"OBR",1,3,"VA207","INVALID CONSULT REFERENCE",1)
	.;
	.I $D(GMRCNTE("WP")) D ADDCMT(GMRCIEN,.GMRCNTE)
	.I $P(GMRCRF1,FS,2)="IP^ADDED COMMENT" D SNDALRT(GMRCIEN)
	.I $P(GMRCRF1,FS,2)="IP^REJECTED" D SNDALRT(GMRCIEN,1)
	;
	; Add addendum to file #8925
	I $P(GMRCRF1,FS,2)="CM^ADDENDED" D
	.;
	.S GMRCTIU=+GMRCOBR,GMRCTIUS=""
	.D GETSTAT^TIUPRF2(.GMRCTIUS,GMRCTIU)
	.S GMRCTIUS=$P(GMRCTIUS,"^",2)
	.;
	.; Quit if IEN being passed by HCP isn't for a Progress Note
	.I 'GMRCTIU!($P(GMRCOBR,FS,2)'="TIU")!('$D(^TIU(8925,+GMRCTIU,0)))!(GMRCTIUS="RETRACTED") D  Q
	..S QUIT=1
	..D ACK("AE",MID,"OBR",1,3,"VA207","INVALID PROGRESS NOTE REFERENCE",1)
	.;
	.D TIUTXT(.GMRCNTE,.ADDTXT)
	.D MAKEADD^TIUSRVP2(.GMRCATIU,GMRCTIU,.ADDTXT)
	.I +GMRCATIU>0 D UPDUSRS(GMRCTIU,GMRCATIU)
	.D SNDALRT(GMRCIEN)
	;
	Q QUIT
	;
RF1(RF1SEG,RETVAL)	; Process RF1 Segment
	N GMRCSTS,GMRCIEN
	S GMRCSTS=$P(RF1SEG,FS,2)
	S GMRCIEN=$P(RF1SEG,FS,7)
	S RETVAL=GMRCIEN_FS_GMRCSTS
	Q
	;
PID(PIDSEG,RETVAL)	; Process PID Segment
	N GMRCICN
	S GMRCICN=$P($P(PIDSEG,FS,4),CS)
	S RETVAL=GMRCICN
	Q
	;
OBR(OBRSEG,RETVAL)	; Process OBR Segment
	N GMRCOIEN,GMRCTYP
	S GMRCOIEN=+$P(OBRSEG,FS,4)
	S GMRCTYP=$P($P(OBRSEG,FS,4),CS,2)
	S RETVAL=GMRCOIEN_FS_GMRCTYP
	Q
	;
NTE(NTESEG,RETVAL)	; Process NTE Segment
	N I,GMRCTXT
	S I=$P(NTESEG,FS,2)
	Q:'+I
	S GMRCTXT=$$DEESCAPE($P(NTESEG,FS,4))
	; Strip the following only if HCPS is sending separately
	I GMRCTXT="Activity Comment" Q
	I GMRCTXT="Comment~~" Q
	;
	I $E(GMRCTXT,1,8)="Author~~" D
	.S $E(GMRCTXT,1,8)="Author: "
	;
	I $E(GMRCTXT,1,10)="Datetime~~" D  Q
	.S RETVAL("Datetime")=$P(GMRCTXT,"Datetime~~",2)
	.; Strip any 'spaces'
	.S RETVAL("Datetime")=$TR(RETVAL("Datetime")," ","")
	;
	I $E(GMRCTXT,1,9)="Comment~~" D
	.S $E(GMRCTXT,1,9)="Comment: "
	;
	S RETVAL("WP",I)=GMRCTXT
	Q
	;
ADDCMT(GMRCIEN,NTEARY)	; Add comment to file #123
	N GMRCFDA,GMRCERR,GMRCCMT,GMRCLACT,GMRCPRXY
	S GMRCFDA(.01)=$$NOW^XLFDT
	S GMRCFDA(1)=$O(^GMR(123.1,"B","ADDED COMMENT",0))
	S GMRCFDA(2)=GMRCFDA(.01)
	I $G(NTEARY("Datetime"))'="" D
	.S GMRCFDA(2)=$$HL7TFM^XLFDT(NTEARY("Datetime"),"L")
	S GMRCPRXY=+$O(^VA(200,"B","HCPS,APPLICATION PROXY",0))
	I GMRCPRXY D
	.S GMRCFDA(3)=GMRCPRXY
	.S GMRCFDA(4)=GMRCPRXY
	K FDA
	M FDA(1,123.02,"+1,"_GMRCIEN_",")=GMRCFDA
	D UPDATE^DIE("","FDA(1)",,"GMRCERR")
	;
	S GMRCCMT=$NA(NTEARY("WP"))
	S GMRCLACT=$O(^GMR(123,GMRCIEN,40," "),-1)
	D WP^DIE(123.02,GMRCLACT_","_GMRCIEN_",",5,"K",GMRCCMT)
	K FDA
	Q
	;
TIUTXT(NTEARY,RETVAL)	; Return TIU-formatted Text
	N I
	S I=0
	F  S I=$O(NTEARY("WP",I)) Q:'I  D
	.S RETVAL("TEXT",I,0)=NTEARY("WP",I)
	Q
	;
UPDUSRS(GMRCTIU,GMRCATIU)	; Update Users on Addendums
	N GMRC1302,GMRC1202,GMRC1204,DIE,DA,DR,X
	S GMRC1302=+$P($G(^TIU(8925,GMRCTIU,13)),"^",2) ; ENTERED BY
	S GMRC1202=+$P($G(^TIU(8925,GMRCTIU,12)),"^",2) ; AUTHOR/DICTATOR
	S GMRC1204=+$P($G(^TIU(8925,GMRCTIU,12)),"^",4) ; EXPECTED SIGNER
	;
	S DIE="^TIU(8925,",DA=GMRCATIU
	S DR="1302///^S X=GMRC1302;1202///^S X=GMRC1202;1204///^S X=GMRC1204"
	L +^TIU(8925,GMRCATIU):$G(DILOCKTM,3)
	I $T D ^DIE L -^TIU(8925,GMRCATIU)
	Q
	;
DEESCAPE(TXTSTR)	; De-escape delimiters
	; (assuming "\" is the escape character):
	; - field separator (de-escape from \F\)
	; - component separator (de-escape from \S\)
	; - repetition separator (de-escape from \R\)
	; - escape character (de-escape from \E\)
	; - subcomponent separator (de-escape from \T\)
	; \F\ will be de-escaped only if the length of FS is 1.
	;
	N HLDATA,HLENCHR,HLI,HLCHAR,HLCHAR23,HLEN,HLOUT
	S HLDATA=$G(TXTSTR)
	Q:HLDATA']"" HLDATA
	;
	S HLENCHR=$G(HL("ECH"),"^~\&")
	Q:$L(HLENCHR)<3 HLDATA
	;
	S HLEN=$L(HLDATA)
	S HLOUT=""
	F HLI=1:1:HLEN D
	.S HLCHAR=$E(HLDATA,HLI)
	.S HLCHAR23=""
	.I HLCHAR=ES D
	..S HLCHAR23=$E(HLDATA,HLI+1,HLI+2)
	.I $L($G(FS))=1,(HLCHAR23=("F"_ES)) D  Q
	..S HLOUT=HLOUT_FS
	..S HLI=HLI+2
	.I HLCHAR23=("S"_ES) D  Q
	..S HLOUT=HLOUT_CS
	..S HLI=HLI+2
	.I HLCHAR23=("R"_ES) D  Q
	..S HLOUT=HLOUT_RS
	..S HLI=HLI+2
	.I HLCHAR23=("E"_ES) D  Q
	..S HLOUT=HLOUT_ES
	..S HLI=HLI+2
	.I $L(HLENCHR)>3,(HLCHAR23=("T"_ES)) D  Q
	..S HLOUT=HLOUT_SS
	..S HLI=HLI+2
	.S HLOUT=HLOUT_HLCHAR
	;
	Q HLOUT
	;
SNDALRT(GMRCIEN,GMRCRJT)	; Send Alert
	; GMRCRJT is optional, and is only set to 1 for a rejection status
	N GMRCORTX,GMRCORN,GMRCRP,GMRCADUZ,GMRCDFN
	S GMRCORTX="Updates received from HCP "
	I +$G(GMRCRJT) S GMRCORTX="Rejected status from HCP "
	S GMRCORN=63
	S GMRCRP=+$P($G(^GMR(123,+GMRCIEN,0)),"^",14) ; Requesting Provider
	S:GMRCRP GMRCADUZ(GMRCRP)=""
	I '$D(GMRCADUZ) S GMRCADUZ=""
	S GMRCDFN=$P($G(^GMR(123,+GMRCIEN,0)),"^",2)
	S GMRCORTX=GMRCORTX_$$ORTX^GMRCAU(+GMRCIEN)
	D MSG^GMRCP(GMRCDFN,GMRCORTX,+GMRCIEN,GMRCORN,.GMRCADUZ,"")
	Q
	;
ACK(STAT,MID,SID,SEG,FLD,CD,TXT,ACKTYP)	; Creates ACKs for HL7 Message
	;STAT = Status (Acknowledgment Code) (REQUIRED)
	;MID = Message ID (REQUIRED)
	;SID = Segment ID (set if ERR occured in segment) (OPTIONAL)
	;SEG = Segment location of error (OPTIONAL)
	;FLD = Field location of error (OPTIONAL)
	;CD = Error Code (OPTIONAL)
	;TXT = Text describing error (OPTIONAL)
	;ACKTYP = Acknowledgment Type (OPTIONAL)
	;
	N HLA,EID,EIDS,RES,ERR
	;
	;Make sure the parameters are defined
	S STAT=$G(STAT),MID=$G(MID),SID=$G(SID),SEG=$G(SEG)
	S FLD=$G(FLD),CD=$G(CD),TXT=$G(TXT)
	;
	;Create MSA Segment
	S HLA("HLA",1)="MSA"_FS_STAT_FS_MID
	S EID=$G(HL("EID"))
	S EIDS=$G(HL("EIDS"))
	Q:((EID="")!($G(HLMTIENS)="")!(EIDS=""))
	;
	S RES=""
	;If Segment ID (SID) is set, create ERR segment
	D:$L(SID)>0
	.S HLA("HLA",2)="ERR"
	.S $P(HLA("HLA",2),FS,3)=SID_CS_SEG_CS_FLD
	.S $P(HLA("HLA",2),FS,5)="E"
	.;
	.; Commit Error
	.I '+$G(ACKTYP) D
	..S $P(HLA("HLA",2),FS,4)=CD_CS_TXT_CS_"0357"
	.;
	.; Application Error
	.I +$G(ACKTYP)=1 D
	..S $P(HLA("HLA",2),FS,6)=CS_CS_CS_CD_CS_TXT
	;
	D GENACK^HLMA1(EID,$G(HLMTIENS),EIDS,"LM",1,.RES)
	Q
