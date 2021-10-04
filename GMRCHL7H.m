GMRCHL7H	;DSS/KC - Receive HL7 Message for HCP ;10/29/15  16:55
	;;3.0;CONSULT/REQUEST TRACKING;**75,85**;DEC 27, 1997;Build 3
	;
	;DBIA# Supported Reference
	;----- --------------------------------
	;2161  INIT^HLFNC2
	;2164  GENERATE^HLMA
	;2944  TGET^TIUSRVR1
	;3267  SSN^DPTLK1
	;3630  BLDPID^VAFCQRY
	;5807  GETLINK^TIUSRVT1
	;10103 FMTE^XLFDT, FMTHL7^XLFDT
	;10104 UP^XLFSTR
	;10106 FMDATE^HLFNC
	;;Patch 85 fix for CA SDM ticket R6063960FY16
	;
EN(MSG)	;Entry point to routine from GMRC CONSULTS TO HCP protocol attached or GMRC EVSEND OR
	;MSG = local array which contains the HL7 segments
	N I,QUIT,MSGTYP,DFN,ORC,GMRCDA,FS,MSGTYP2,MSGTYP3,ACTIEN,FROMSVC,OK,OKFROM,STATUS
	S (I,QUIT)=0,I=$O(MSG(I)) Q:'I  S MSG=MSG(I) Q:$E(MSG,1,3)'="MSH"  D  Q:QUIT
	.S FS=$E(MSG,4) I $P(MSG,FS,3)'="CONSULTS" S QUIT=1 Q
	.S MSGTYP=$P(MSG,FS,9) I ",ORR,ORM,"'[","_MSGTYP_"," S QUIT=1 Q  ;ORR is new consult, ORM are updates
	.Q
	F  S I=$O(MSG(I)) Q:'I!QUIT  S MSG=MSG(I) D
	.I $E(MSG,1,3)="PID" S DFN=$P(MSG,FS,4) I 'DFN!('$D(^DPT(DFN))) S QUIT=1 Q
	.I $E(MSG,1,3)="ORC" S ORC=MSG S GMRCDA=+$P(ORC,FS,4),MSGTYP2=$P(ORC,FS,2),MSGTYP3=$P(ORC,FS,6) D
	..I MSGTYP3="IP" S ACTIEN=$O(^GMR(123,GMRCDA,40,99999),-1) D
	...I ACTIEN S FROMSVC=$P($G(^GMR(123,GMRCDA,40,ACTIEN,0)),U,6) I FROMSVC S OKFROM=$$FEE(FROMSVC)
	..S OK=$$FEE($$GET1^DIQ(123,GMRCDA,1,"I"))
	..I '$G(OKFROM)&'$G(OK) S QUIT=1 ;not a Fee service or not forwarded from a fee service
	..Q
	.Q
	Q:QUIT
	I MSGTYP="ORR" S MSGTYP3="NW"
	S STATUS=$$STATUS(MSGTYP2,MSGTYP3) I STATUS="UNKNOWN" Q  ;don't process anything we haven't coded for
	;done verifying this consult needs to go to HCP, start building HL7 message
	N SNAME,GMRCHL,ZERR,ZCNT,ECH,DATA,GDATA,URG,TYP,RES,EFFDT,PDUZ,PN,ADDR,PH,GMRCP,SENS,DX,DXCODE
	S SNAME="GMRC HCP REF-"_$S(MSGTYP2="DR":"I14",MSGTYP="ORR":"I12",MSGTYP2="OC":"I14",MSGTYP2="OD":"I14",1:"I13")_" SERVER"
	S GMRCHL("EID")=$$FIND1^DIC(101,,"X",SNAME)
	Q:'GMRCHL("EID")  D INIT^HLFNC2(GMRCHL("EID"),.GMRCHL)
	S ZERR="",ZCNT=0,ECH=$E(GMRCHL("ECH")) ;component separator
	;start creating the segments.
	S DATA=$NA(^TMP("GMRCHL7H",$J)) K @DATA D GETS^DIQ(123,GMRCDA,"*","IE",DATA)
	S GDATA=$NA(^TMP("GMRCHL7H",$J,123,+GMRCDA_",")) ;File 123 data
	;RF1 segment
	K GMRCM
	S URG=$G(@GDATA@(5,"E")) ;I URG]"" S URG=$S(URG["ROUTINE":"R",URG["STAT":"S",1:"A")
	S URG=$P(URG,"- ",2)
	S TYP=$G(@GDATA@(1,"I"))_ECH_$G(@GDATA@(1,"E")) D GETLINK^TIUSRVT1(.RES,+TYP_";GMR(123.5,")
	S TYP=TYP_ECH_ECH_$P($G(RES),U)_ECH_$P($G(RES),U,4)
	S EFFDT=$$FMTHL7^XLFDT($G(@GDATA@(.01,"I")))
	S ZCNT=ZCNT+1,GMRCM(ZCNT)="RF1|"_STATUS_"|"_URG_"|"_TYP_"||"_$G(@GDATA@(14,"I"))_"|"_GMRCDA_"|"_EFFDT_"||||"
	;PRD segment
	S PDUZ=$G(@GDATA@(10,"I")),PN=$G(@GDATA@(10,"E")),PN=$$HLNAME^XLFNAME(PN,"S",ECH),$P(PN,ECH,9)=PDUZ
	S ADDR=$$ADDR^GMRCHL7P(PDUZ,.GMRCHL),PH=$$PH^GMRCHL7P(PDUZ,.GMRCHL)
	S ZCNT=ZCNT+1,GMRCM(ZCNT)="PRD|RP|"_PN_"|"_$G(ADDR)_"||"_$G(PH)_"|"
	;PID segment  May be multiple nodes in the return array - make nodes 2-n sub nodes
	D BLDPID^VAFCQRY(DFN,1,"ALL",.GMRCP,.GMRCHL,ZERR)
	S I=0 F  S I=$O(GMRCP(I)) Q:'I  D
	.I I=1 S ZCNT=ZCNT+1,GMRCM(ZCNT)=$TR(GMRCP(I),"""") Q
	.S GMRCM(ZCNT,I)=$TR(GMRCP(I),"""")
	K GMRCP
	;DG1 segment ;Patch 85 modified
	S DX=$G(@GDATA@(30,"E"))
	S DXCODE=$G(@GDATA@(30.1,"E"))
	I $G(DX)["(" S DX=$P(DX,"(")
	S ZCNT=ZCNT+1,GMRCM(ZCNT)="DG1|1||"_$G(DXCODE)_ECH_$G(DX)_"|||W"
	;OBR segment
	S ZCNT=ZCNT+1,GMRCM(ZCNT)="OBR|1|"_$P(ORC,FS,3)_"|"_$P(ORC,FS,4)_"|ZZ||"_$$FMTHL7^XLFDT($G(@GDATA@(17,"I")))
	;PV1 segment
	D IN5^VADPT ;VAIP(18)=Attending Physician, VAIP(13,5)=Primary Physician for admission
	S ZCNT=ZCNT+1,GMRCM(ZCNT)="PV1|1|"_$S(VAIP(13):"I",1:"O")_"|||||"_VAIP(18)_"|"
	I VAIP(5) S $P(GMRCM(ZCNT),"|",4)=VAIP(5) ;location for last movement event
	S SENS=$$SSN^DPTLK1(DFN) I SENS["*SENSITIVE*" S $P(GMRCM(ZCNT),"|",17)="R" ;sensitive patient
	S $P(GMRCM(ZCNT),"|",18)=VAIP(13,5)
	D KVA^VADPT
	;NTE segment
	D NTE(.GMRCHL)
	K ^TMP("GMRCHL7H",$J)
	;
	; When done, re-serve the (modified) referral message to HCP
	N HL,HLA,GMRCRES,GMRCHLP
	M HL=GMRCHL,HLA("HLS")=GMRCM
	D GENERATE^HLMA(GMRCHL("EID"),"LM",1,.GMRCRES,"",.GMRCHLP)
	Q
NTE(HL)	;Find Reason for Request for New or Resubmit entries, Find TIU for complete, find Activity Comment for others
	N NTECNT,X S NTECNT=1
	I (MSGTYP="ORR"&(MSGTYP2'="DR"))!((MSGTYP3="IP")&'$G(OKFROM)) D  Q
	.D AUTHDTTM
	.S ZCNT=ZCNT+1,GMRCM(ZCNT)="NTE|"_NTECNT_"|P|Reason for Request"
	.S I=0 F  S I=$O(@GDATA@(20,I)) Q:'I  S X=@GDATA@(20,I) Q:X["^TMP"  D
	..S X=$$TRIM^XLFSTR(X) I $L(X)=0 Q
	..I X=$C(9,9) Q
	..D HL7TXT^GMRCHL7P(.X,.HL,"\")
	..S ZCNT=ZCNT+1,NTECNT=NTECNT+1,GMRCM(ZCNT)="NTE|"_NTECNT_"||"_X
	..Q
	.Q
	; Build NTE for CM^ADDENDED
	I MSGTYP2="XX",MSGTYP3="CM" D  Q
	.N GMRCN,GMRCTXT,GMRCCMP,GMRCASTR
	.D AUTHDTTM
	.S ZCNT=ZCNT+1,GMRCM(ZCNT)="NTE|"_NTECNT_"|P|Progress Note"
	.S GMRCN=$P($G(^GMR(123,GMRCDA,50,1,0)),U) I GMRCN'["TIU(8925," Q
	.D TGET^TIUSRVR1(.GMRCTXT,$S(+$G(GMRCPARN):+GMRCPARN,+$G(TIUDA):+TIUDA,1:+GMRCN),"VIEW")
	.;
	.S GMRCCMP=$$DATE($P($G(^TIU(8925,+TIUDA,13)),U),"MM/DD/CCYY")_" ADDENDUM"_"                      STATUS: "_$$GET1^DIQ(8925,+TIUDA_",",.05)
	.S (I,GMRCASTR)=0
	.F  S I=$O(@GMRCTXT@(I)) Q:I=""  S X=@GMRCTXT@(I) D
	..I X=GMRCCMP S GMRCASTR=I
	.;
	.I GMRCASTR D
	..S I=GMRCASTR-1
	..F  S I=$O(@GMRCTXT@(I)) Q:I=""  S X=@GMRCTXT@(I) D
	...S X=$$TRIM^XLFSTR(X) I $L(X)=0 Q
	...D HL7TXT^GMRCHL7P(.X,.HL,"\")
	...S ZCNT=ZCNT+1,NTECNT=NTECNT+1,GMRCM(ZCNT)="NTE|"_NTECNT_"||"_X
	.K ^TMP("TIUVIEW",$J) ;clean up results of TIUSRVR1 call
	;
	I MSGTYP3="CM" D  Q
	.N GMRCN,GMRCTXT
	.D AUTHDTTM
	.S ZCNT=ZCNT+1,GMRCM(ZCNT)="NTE|"_NTECNT_"|P|Progress Note"
	.S GMRCN=$P($G(^GMR(123,GMRCDA,50,1,0)),U) I GMRCN'["TIU(8925," Q
	.D TGET^TIUSRVR1(.GMRCTXT,$S(+$G(TIUDA):+TIUDA,1:+GMRCN),"VIEW") S I=0
	.F  S I=$O(@GMRCTXT@(I)) Q:I=""  S X=@GMRCTXT@(I) D
	..S X=$$TRIM^XLFSTR(X) I $L(X)=0 Q
	..D HL7TXT^GMRCHL7P(.X,.HL,"\")
	..S ZCNT=ZCNT+1,NTECNT=NTECNT+1,GMRCM(ZCNT)="NTE|"_NTECNT_"||"_X
	..Q
	.K ^TMP("TIUVIEW",$J) ;clean up results of TIUSRVR1 call
	.Q
	I (MSGTYP2="DR") D  Q
	.N ORIEN,CMT
	.D AUTHDTTM
	.S ZCNT=ZCNT+1,GMRCM(ZCNT)="NTE|"_NTECNT_"|L|Activity Comment"
	.S ORIEN=$G(@GDATA@(.03,"I")) I 'ORIEN Q
	.S CMT=$$GET1^DIQ(100,ORIEN_",",64),CMT=$$TRIM^XLFSTR(CMT)
	.D HL7TXT^GMRCHL7P(.CMT,.HL,"\")
	.S ZCNT=ZCNT+1,GMRCM(ZCNT)="NTE|2||"_CMT
	.Q
	N ACT,ACTD,ACTIEN,Q
	S Q=0,ACTIEN=9999 F  S ACTIEN=$O(^GMR(123,GMRCDA,40,ACTIEN),-1) Q:'ACTIEN!Q  S X=$G(^GMR(123,GMRCDA,40,ACTIEN,0)) D
	.S ACT=$P(X,U,2),ACTD=$P($P($G(^GMR(123.1,+ACT,0)),U)," ")
	.I $P($P(STATUS,ECH,2)," ")'=ACTD Q
	.I +$O(^GMR(123,GMRCDA,40,ACTIEN,1,0)) D AUTHDTTM
	.S I=0 F  S I=$O(^GMR(123,GMRCDA,40,ACTIEN,1,I)) Q:'I  S X=$G(^GMR(123,GMRCDA,40,ACTIEN,1,I,0)) D
	..I 'Q S ZCNT=ZCNT+1,GMRCM(ZCNT)="NTE|"_NTECNT_"|L|Activity Comment",Q=1
	..S X=$$TRIM^XLFSTR(X) I $L(X)=0 Q
	..D HL7TXT^GMRCHL7P(.X,.HL,"\")
	..S ZCNT=ZCNT+1,NTECNT=NTECNT+1,GMRCM(ZCNT)="NTE|"_NTECNT_"||"_X
	..Q
	.Q
	Q
AUTHDTTM	; Add Author and Date/Time to NTE
	S ACTIEN=$G(ACTIEN,$O(^GMR(123,GMRCDA,40,99999),-1))
	I '+ACTIEN D  Q
	.S ZCNT=ZCNT+1,GMRCM(ZCNT)="NTE|"_NTECNT_"||Author\R\\R\"
	.S ZCNT=ZCNT+1,NTECNT=NTECNT+1,GMRCM(ZCNT)="NTE|"_NTECNT_"||Datetime\R\\R\"
	.S ZCNT=ZCNT+1,NTECNT=NTECNT+1,GMRCM(ZCNT)="NTE|"_NTECNT_"||Comment\R\\R\"
	.S NTECNT=4
	;
	S ZCNT=ZCNT+1,GMRCM(ZCNT)="NTE|"_NTECNT_"||Author\R\\R\"_$$GET1^DIQ(123.02,ACTIEN_","_GMRCDA_",",4)
	S ZCNT=ZCNT+1,NTECNT=NTECNT+1,GMRCM(ZCNT)="NTE|"_NTECNT_"||Datetime\R\\R\"_$$FMTHL7^XLFDT($$GET1^DIQ(123.02,ACTIEN_","_GMRCDA_",",2,"I"))
	S ZCNT=ZCNT+1,NTECNT=NTECNT+1,GMRCM(ZCNT)="NTE|"_NTECNT_"||Comment\R\\R\"
	S NTECNT=4
	Q
STATUS(T1,T2)	;get status for event
	;also add IP^COMMENT when those events are captured
	I T2="DC"!(T1="DR") Q "DC^DISCONTINUED"
	I T2="NW" Q "NW^CPRS RELEASED ORDER"
	I T1="SC"&(T2="SC") Q "SC^RECEIVED"
	I T1="SC"&(T2="ZC") Q "SC^SCHEDULED"
	I T1="XX"&(T2="XX") Q "IP^ADDED COMMENT"
	I T2="CA" Q "CA^CANCELLED"
	I T2="CM" D
	.I '+$G(GMRCPARN),'+$G(TIUDA) S GMRCPARN=$P($G(^GMR(123,GMRCDA,50,1,0)),U)
	.S $P(ORC,FS,4)=$S(+$G(GMRCPARN):+GMRCPARN_";TIU^TIU",+$G(TIUDA):+TIUDA_";TIU^TIU",1:$P(ORC,FS,4))
	I T1="XX"&(T2="CM") Q "CM^ADDENDED"
	I T2="CM" Q "CM^COMPLETE"
	I T1="XX"&(T2="IP")&$G(OKFROM) Q "XX^FORWARDED"
	I T1="XX"&(T2="IP") Q "IP^RESUBMITTED"
	Q "UNKNOWN"
FEE(FEESVC)	;send only if name contains HCPS
	I $G(FEESVC)="" Q 0
	N VAL
	S VAL=0
	I $$UP^XLFSTR($$GET1^DIQ(123.5,FEESVC,.01,"E"))["HCPS" S VAL=1
	Q VAL
COMMENT(GMRCDA)	;send comments on Non VA Care consults to HCP
	;create a fake event for HCP since there is no HL7 event passed to GMRC EVSEND OR
	I '$G(GMRCDA) Q
	N DFN S DFN=$$GET1^DIQ(123,GMRCDA,.02,"I") I 'DFN,'$D(^DPT(DFN)) Q
	N T S T(1)="MSH|^~\&|CONSULTS||||||ORM"
	S T(2)="PID|||"_DFN
	S T(4)="ORC|XX|"_$$GET1^DIQ(123,GMRCDA,.03,"I")_";"_$$OITEM($$GET1^DIQ(123,GMRCDA,.03,"I"))_"^OR|"_GMRCDA_";GMRC^GMRC||XX|"
	D EN(.T)
	Q
ADDEND(TIUDA)	;send addendums on Non VA Care consults to HCP
	;create a fake event for HCP since there is no HL7 event passed to GMRC EVSEND OR
	I '$G(TIUDA) Q
	Q:'$D(^TIU(8925,+TIUDA,0))
	N TIUTYP,DFN,GMRCPARN,GMRCO,GMRCD,GMRCDA,GMRCD1,GMRC8925,T
	;
	; Quit if not an addendum
	S TIUTYP=$$GET1^DIQ(8925,TIUDA,.01,"I")
	I TIUTYP'=81 Q
	;
	S DFN=$$GET1^DIQ(8925,TIUDA,.02,"I")
	I 'DFN,'$D(^DPT(DFN)) Q
	;
	; Get parent note IEN, if addendum IEN is passed in:
	S GMRCPARN=$$GET1^DIQ(8925,TIUDA,.06,"I")
	;
	S (GMRCO,GMRCD)=0
	F  S GMRCD=$O(^GMR(123,"AD",DFN,GMRCD)) Q:'GMRCD!(GMRCO)  D
	.S GMRCDA=0
	.F  S GMRCDA=$O(^GMR(123,"AD",DFN,GMRCD,GMRCDA)) Q:'GMRCDA!(GMRCO)  D
	..S GMRCD1=0
	..F  S GMRCD1=$O(^GMR(123,GMRCDA,50,GMRCD1)) Q:'GMRCD1!(GMRCO)  D
	...S GMRC8925=$$GET1^DIQ(123.03,GMRCD1_","_GMRCDA_",",.01,"I")
	...I +GMRC8925=$S(+GMRCPARN:+GMRCPARN,1:TIUDA) S GMRCO=GMRCDA
	Q:'GMRCO
	;
	S T(1)="MSH|^~\&|CONSULTS||||||ORM"
	S T(2)="PID|||"_DFN
	S T(4)="ORC|XX|"_$$GET1^DIQ(123,GMRCO,.03,"I")_";"_$$OITEM($$GET1^DIQ(123,GMRCO,.03,"I"))_"^OR|"_GMRCO_";GMRC^GMRC||CM|"
	I $$FEE($$GET1^DIQ(123,GMRCO,1,"I")) D EN(.T)
	Q
TIME(X,FMT)	; Copied from $$TIME^TIULS
	; Recieves X as 2910419.01 and FMT=Return Format of time (HH:MM:SS).
	N HR,MIN,SEC,TIUI
	I $S('$D(FMT):1,'$L(FMT):1,1:0) S FMT="HR:MIN"
	S X=$P(X,".",2),HR=$E(X,1,2)_$E("00",0,2-$L($E(X,1,2))),MIN=$E(X,3,4)_$E("00",0,2-$L($E(X,3,4))),SEC=$E(X,5,6)_$E("00",0,2-$L($E(X,5,6)))
	F TIUI="HR","MIN","SEC" S:FMT[TIUI FMT=$P(FMT,TIUI)_@TIUI_$P(FMT,TIUI,2)
	Q FMT
DATE(X,FMT)	; Copied from $$DATE^TIULS
	; Call with X=2910419.01 and FMT=Return Format of date ("MM/DD")
	N AMTH,MM,CC,DD,YY,TIUI,TIUTMP
	I +X'>0 S $P(TIUTMP," ",$L($G(FMT))+1)="",FMT=TIUTMP G QDATE
	I $S('$D(FMT):1,'$L(FMT):1,1:0) S FMT="MM/DD/YY"
	S MM=$E(X,4,5),DD=$E(X,6,7),YY=$E(X,2,3),CC=17+$E(X)
	S:FMT["AMTH" AMTH=$P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC","^",+MM)
	F TIUI="AMTH","MM","DD","CC","YY" S:FMT[TIUI FMT=$P(FMT,TIUI)_@TIUI_$P(FMT,TIUI,2)
	I FMT["HR" S FMT=$$TIME(X,FMT)
QDATE	Q FMT
OITEM(GMRCORDN)	; Orderable Item
	N RETVAL,GMRCOITM
	S RETVAL=1
	S GMRCOITM=+$O(^OR(100,GMRCORDN,.1,0))
	I GMRCOITM D
	.S RETVAL=+$G(^OR(100,GMRCORDN,.1,GMRCOITM,0))
	.I 'RETVAL S RETVAL=1
	Q RETVAL
ACK	; Process ACK HL7 messages
	N GMRCMSG,I,X,DONE,MSGID,ERRARY,ERRI
	;Get the message
	S ERRI=0
	F I=1:1 X HLNEXT Q:(HLQUIT'>0)  D
	. S GMRCMSG(I,1)=HLNODE
	. S X=0 F  S X=+$O(HLNODE(X)) Q:'X  S GMRCMSG(I,(X+1))=HLNODE(X)
	S DONE=0
	S I=0 F  S I=$O(GMRCMSG(I)) Q:'+I  D  Q:DONE
	. I $P($G(GMRCMSG(I,1)),"|",1)="MSA" D  Q
	. . I $P($G(GMRCMSG(I,1)),"|",2)="AA" S DONE=1 Q
	. . S MSGID=$P($G(GMRCMSG(I,1)),"|",3)
	. I $P($G(GMRCMSG(I,1)),"|",1)="ERR" D
	. . ;Process Error
	. . S ERRI=ERRI+1
	. . S ERRARY(ERRI,2)=$P($G(GMRCMSG(I,1)),"|",3)
	. . I $P($G(GMRCMSG(I,1)),"|",6)'="" D  Q
	. . . S ERRARY(ERRI,3)=$P($P($G(GMRCMSG(I,1)),"|",6),"^",4)_"^"_$P($P($G(GMRCMSG(I,1)),"|",6),"^",5)
	. . S ERRARY(ERRI,3)=$P($G(GMRCMSG(I,1)),"|",4)
	I $D(ERRARY) D MESSAGE(MSGID,.ERRARY)
	Q
MESSAGE(MSGID,ERRARY)	; Send a MailMan Message with the errors
	N MSGTEXT,DUZ,XMDUZ,XMSUB,XMTEXT,XMY,XMMG,XMSTRIP,XMROU,DIFROM,XMYBLOB,XMZ,XMMG,DATE,J
	S DATE=$$FMTE^XLFDT($$FMDATE^HLFNC($P(HL("DTM"),"-",1)))
	S XMSUB="GMRC Consults to HCP HL7 Error"
	S MSGTEXT(1)=" "
	S MSGTEXT(2)="Error in transmitting HL7 message to HCP"
	S MSGTEXT(3)="Date:       "_DATE
	S MSGTEXT(4)="Message ID: "_MSGID
	S MSGTEXT(5)="Error(s):"
	S I=0,J=5 F  S I=$O(ERRARY(I)) Q:'I  D
	. S J=J+1,MSGTEXT(J)=" "
	. S J=J+1,MSGTEXT(J)="   "_$P($G(ERRARY(I,3)),U)_" - "_$P($G(ERRARY(I,3)),U,2)
	. I $P($G(ERRARY(I,2)),U,1)'="" S J=J+1,MSGTEXT(J)="      Segment:       "_$P($G(ERRARY(I,2)),U,1)
	. I $P($G(ERRARY(I,2)),U,2)'="" S J=J+1,MSGTEXT(J)="      Sequence:      "_$P($G(ERRARY(I,2)),U,2)
	. I $P($G(ERRARY(I,2)),U,3)'="" S J=J+1,MSGTEXT(J)="      Field:         "_$P($G(ERRARY(I,2)),U,3)
	. I $P($G(ERRARY(I,2)),U,4)'="" S J=J+1,MSGTEXT(J)="      Fld Rep:       "_$P($G(ERRARY(I,2)),U,4)
	. I $P($G(ERRARY(I,2)),U,5)'="" S J=J+1,MSGTEXT(J)="      Component:     "_$P($G(ERRARY(I,2)),U,5)
	. I $P($G(ERRARY(I,2)),U,6)'="" S J=J+1,MSGTEXT(J)="      Sub-component: "_$P($G(ERRARY(I,2)),U,6)
	S XMTEXT="MSGTEXT("
	S XMDUZ="GMRC->HCP Transaction Error"
	S XMY("G.GMRC HCP HL7 MESSAGES")=""
	D ^XMD
	Q
