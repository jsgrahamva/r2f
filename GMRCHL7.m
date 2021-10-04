GMRCHL7	;SLC/DCM,JFR - CONSULTS-->CPRS HL7 MESSAGING ;07/07/09  09:03
	;;3.0;CONSULT/REQUEST TRACKING;**1,5,12,19,29,66**;DEC 27, 1997;Build 30
	;
	; This routine invokes IA #872(File 101 ^ORD), #2638(^ORD(100.01,)), #2698(^ORD(101.42,), #10103(XLFDT), #10101(XQOR)
	;
	;;Format the HL-7 Message header
	Q
INIT	S HLQ=""""""
	S SEP1="|",SEP2="^",SEP3="~",SEP4="\",SEP5="&"
	Q
MSH(X)	;Format MSH segment of HL-7 message.
	;FROM=GMRC CONSULTS - the sending application
	N X
	I '$D(HLQ) D INIT
	S X="MSH|^~\&|CONSULTS|"_$S(+$G(DUZ(2)):DUZ(2),1:$$SITE^VASITE())_"|||||ORM"
	Q X
PID(GMRCIEN)	;Format the HL-7 PID segment
	;GMRCIEN=IEN of consult from File 123
	N X
	S GMRCDPT=$P(^GMR(123,GMRCIEN,0),"^",2)
	S GMRCPTN=$P($G(^DPT(GMRCDPT,0)),"^")
	S X="PID|||"_+GMRCDPT_"||"_GMRCPTN
	K GMRCDPT,GMRCPTN
	Q X
PV1(GMRCIEN,RMBED,VISIT)	;Format the HL-7 PV1 segment
	N GMRCSTS,SEP1,X,Y
	S HOSPLOC=$P(^GMR(123,GMRCIEN,0),"^",4)
	S VISIT=$$HL7DT(VISIT),GMRCSTS=$S($P(^GMR(123,GMRCIEN,0),"^",18)]"":$P(^(0),"^",18),HOSPLOC]"":"I",1:"O")
	S X="PV1"_"||"_GMRCSTS_"|"_$S(HOSPLOC]"":HOSPLOC,1:"")_"^"_$S(RMBED]"":RMBED,1:"")_"|"_$S(VISIT]"":VISIT,1:"")
	K Y,HOSPLOC,VISIT,GMRCSTS
	Q X
NTE(NTE,ND)	;Format the HL-7 NTE segment
	Q:'$D(NTE)  Q:'$O(NTE(0))
	S GMRCND=1,GMRCND1=0 D
	.S GMRCND1=$O(NTE(GMRCND1)),@(MSG_"("_ND_")")=NTE(GMRCND1)
	.F  S GMRCND1=$O(NTE(GMRCND1)) Q:GMRCND1=""  I NTE(GMRCND1)]"" S @(MSG_"("_ND_","_GMRCND_")")=NTE(GMRCND1),GMRCND=GMRCND+1
	.Q
	Q
EN(PATID,GMRCIEN,GMRCRTYP,RMBED,ORCTRL,GMRCPLCR,VISIT,GMRCOM,GRPUPD,ACTDT)	;;Main entry point
	;PATID=DFN - Patients internal entry number from ^DPT(
	;GMRCIEN=IEN of consult, from File 123
	;RMBED=Hospital Room/Bed if patient is hospitalized
	;ORCTRL=Code from HL-7 table 119 (Appendix A) Order Control Codes
	;VISIT=Visit as a DATE/TIME in Fileman Format.
	;GMRCPROV=Provider - IEN from file 200
	;GMRCRTYP=consult type: GMRC REQUEST or GMRC CONSULT
	;GMRCPLCR=who is entering the order ; usually passed as DUZ for new order, "" for existing order
	;GMRCOM=comment array flag: 1 if there is comment array, 0 otherwise
	;GMRCOM(0)=DA of where comment is located: ^GMR(123,IEN,40,DA,
	;GRPUPD = group update of consults - sends nature as MAINTENANCE
	;ACTDT = date/time of activity if sent
	Q:'$L(ORCTRL)
	K GMRCMSS
	N MSG,MSH,PID,PV1,ORC,NTE,OBR,OBX,ZSV,GMRCA,GMRCURGI,GMRCPLI
	N GMRCPR,GMRCSS,GMRCTYPE,ORCPLCR
	S MSH="",MSH=$$MSH(MSH)
	S PID=$$PID(GMRCIEN)
	I ORCTRL'="Z@" S PV1=$$PV1(GMRCIEN,RMBED,VISIT)
	D ORC(GMRCIEN,ORCTRL,GMRCPLCR,$G(GRPUPD),$G(ACTDT))
	S ORCTRL=$P(ORCTRL,U)
	I ORCTRL="Z@" S ORC=$P(ORC,SEP1,1,4)
	D:ORCTRL'="Z@" OBR^GMRCHL72(GMRCIEN,$G(GMRCAUTH),$G(ACTDT))
	;GMRCAUTH=principle results interpreter
	D ZSV(GMRCIEN)
	I $S(ORCTRL="SN":1,ORCTRL="RE":1,ORCTRL="XX":1,1:0) D OBX^GMRCHL72(GMRCIEN)
	I $S(ORCTRL="OC":1,ORCTRL="OD":1,ORCTRL="XX":1,ORCTRL="SC":1,1:0),$G(GMRCOM(0)) D NTE^GMRCHL72(GMRCIEN,.GMRCOM,ORCTRL)
	D BLD(MSH,PID,$G(PV1),$G(ORC),$G(OBR),$G(ZSV),.OBX,.NTE,ORCTRL)
	;M GMRCMSS=GMRCMSG ;HL-7 message debugging aid - remove from final version
	D MSG^XQOR("GMRC EVSEND OR",.GMRCMSG)
	K GMRCND,GMRCND1,GMRCMSG,GMRCNOD,GMRCORFN,GMRCPLI,GMRCPRI,HL7DT,HLQ,J,ND,ND1,ND2,NOTIFY,OBXND,OBXNO,ORCACT,ORCDT,ORURG,SEP1,SEP2,SEP3,SEP4,SEP5
	Q
BLD(MSH,PID,PV1,ORC,OBR,ZSV,OBX,NTE,CTRLCD)	;Build the HL-7 message global to pass to OR
	S MSG="GMRCMSG",ND=1
	K @(MSG)
	F J="MSH","PID","PV1" I $G(@J)]"" S @(MSG_"("_ND_")")=@J,ND=ND+1
	I ORC]"" S @(MSG_"("_ND_")")=ORC,ND=ND+1
	I $D(NTE),$O(NTE(0)) D NTE(.NTE,ND) S ND=ND+1
	I OBR]"" S @(MSG_"("_ND_")")=OBR,ND=ND+1
	I $L($G(ZSV)) S @(MSG_"("_ND_")")=ZSV,ND=ND+1
	I $O(OBX("")) S OBXND=0 D
	.F  S OBXND=$O(OBX(OBXND)) Q:OBXND=""  D
	.. S @(MSG_"("_ND_")")=OBX(OBXND)
	.. S GMRCND1=0 F  S GMRCND1=$O(OBX(OBXND,GMRCND1)) Q:GMRCND1=""  D
	... S @(MSG_"("_ND_","_GMRCND1_")")=OBX(OBXND,GMRCND1)
	       .. S ND=ND+1
	.Q
	;I CTRLCD'="XX",$D(NTE),$O(NTE(0)) D NTE(.NTE,ND) S ND=ND+1
	Q
HL7DT(DATE)	;Convert Fileman Date to HL-7 Date
	I 'DATE Q ""
	Q $$FMTHL7^XLFDT(DATE) ; use standard function
	N X
	S X="" I DATE S X=17000000+$P(DATE,".",1)_$P(DATE,".",2)
	Q X
FMDATE(DATE)	;Convert HL-7 formatted date to a Fileman formatted date
	I 'DATE Q ""
	Q $$HL7TFM^XLFDT(DATE) ; use standard function
	N X
ORC(GMRCIEN,GMRCTRL,ORCPLCR,MAINT,GMRCDT)	;Build ORC segment of HL-7 msg
	;GMRCTRL=Order Control Code (table 119)
	;GMRCIEN=File 123 IEN
	;ORPLCR=GMRCPLCR - the person entering the order
	;MAINT=1 - group update of requests
	;GMRCDT=date/time of activity, GMRCERDT=earliest appropriate date wat/66
	N GMRCURG,ORCACT,ORCDT,ORCPRV,ORCDT,ORIEN,ORCSTS,STS,ORCNATR,QUANT,REAS,GMRCERDT
	S REAS=$P(GMRCTRL,U,2),GMRCTRL=$P(GMRCTRL,U)
	S ORCDT=$P(^GMR(123,GMRCIEN,0),"^",7),ORCPRV=$P(^GMR(123,GMRCIEN,0),"^",14),ORURG=$P(^(0),"^",9),ORURG=$S(ORURG]"":$P(^ORD(101,ORURG,0),"^",1),1:"") S:ORURG]"" ORURG=$P(ORURG," - ",2)
	S ORURG=$S(ORURG="EMERGENCY":"STAT",ORURG="NOW":"STAT",ORURG="OUTPATIENT":"ROUTINE",1:ORURG)
	S:ORURG="" GMRCURG="" I ORURG]"" S GMRCURG=$O(^ORD(101.42,"B",ORURG,0)),GMRCURG=$S(+GMRCURG:$P(^ORD(101.42,GMRCURG,0),"^",2),1:"")
	S GMRCERDT=$P(^GMR(123,GMRCIEN,0),"^",24),GMRCERDT=$$HL7DT($G(GMRCERDT)) ;WAT/66
	S ORCDT=$$HL7DT(ORCDT)
	I '$G(GMRCDT) S GMRCDT=$$NOW^XLFDT
	S STS=$P(^GMR(123,GMRCIEN,0),"^",12)
	S ORCACT=$P($G(^ORD(100.01,+STS,0)),U,1) S:'$L(ORCACT) ORCACT="NO STATUS"
	S ORIEN=$P(^GMR(123,GMRCIEN,0),"^",3)
	S ORCSTS=$S(STS=1:"DC",STS=2:"CM",STS=5:"IP",STS=6:"SC",STS=9:"A",STS=12:"RP",STS=13:"CA",STS=8:"ZC",1:"IP")
	S ORCNATR=""
	I GMRCTRL="XX" S ORCNATR="S^SERVICE CORRECTION^99ORN^^"_REAS_"^"
	I $G(MAINT) S ORCNATR="M^MAINTENANCE^99ORN^^^"
	S QUANT=$S(GMRCURG]"":"^^^"_$G(GMRCERDT)_"^^"_GMRCURG,1:"") ;wat/66
	S GMRCDT=$$HL7DT(GMRCDT)
	S ORC="ORC|"_GMRCTRL_"|"_$S(ORIEN]"":ORIEN_";1^OR",1:"")_"|"
	S ORC=ORC_GMRCIEN_";GMRC^"_"GMRC"_"||"_ORCSTS_"||"_QUANT_"||"
	S ORC=ORC_GMRCDT_"|"_ORCPLCR_"||"_ORCPRV_"|||"_ORCDT_"|"_ORCNATR
	Q
ZSV(GMRCO)	;build ZSV segment for at least forward
	N SERV,SERVNM,CTYPE
	S SERV=$P($G(^GMR(123,GMRCO,0)),U,5)
	I 'SERV Q
	S SERVNM=$P($G(^GMR(123.5,SERV,0)),U)
	S CTYPE=$G(^GMR(123,GMRCO,1.11))
	I CTYPE=SERVNM S CTYPE=""
	I $P(^GMR(123,GMRCO,0),U,8) S CTYPE=""
	S ZSV="ZSV|^^^"_SERV_U_SERVNM_"^99CON|"_CTYPE
	Q
