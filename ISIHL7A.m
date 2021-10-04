ISIHL7A ;ISI/MLS - HL7 Order message parse and send
 ;;1.0;ISI IMAGING;;Jan 27, 2010;Build 2
 ;
 Q
OERR(MSG) ;Entry point from protocol
 N HLA,HL,INT,I,J,SEG,SEND,EID,I,J,ORN,GMRCN,CNT
 N DFN,HLMSG,NOD,SEP1,SEP2,SEP3,SEP4,SEP5
 S HLMSG="",NOD=0,SEND=1,CNT=1
 F  S NOD=$O(MSG(NOD)) Q:NOD=""  S HLMSG=MSG(NOD) D  Q:'SEND
 . S SEG=$E(HLMSG,1,3)
 . I SEG="MSH" D MSH(HLMSG) Q
 . I SEG="PID" S DFN=+$P(HLMSG,SEP1,4) D PID,PV1 Q
 . I SEG="ORC" S ORN=$$ORC(HLMSG) Q
 . I SEG="OBR" D OBR(HLMSG) Q
 . I SEG="ZSV" D ZSV(HLMSG) Q
 . I SEG="NTE" D HLA(HLMSG) Q
 . I SEG="OBX" D OBX(HLMSG) Q
 Q:'SEND
 D TASK
 Q
 ;
TASK S ZTIO=""
 S ZTRTN="SNDMSG^ISIHL7A"
 S ZTSAVE("HLA(""HLS"",")=""
 S ZTSAVE("EID")=""
 S ZTSAVE("HL*")=""
 S ZTDESC="FHCC Consults HL7 Outbound Message"
 S ZTDTH=$H
 D ^%ZTLOAD
 D EXIT
 Q
 ;
INIT(EVNT) ;Initialize HL variables for outbound message
 S EID=$O(^ORD(101,"B",EVNT,0))
 S HL="HL",INT=0
 D INIT^HLFNC2(EID,.HL,INT)
 ;
 Q
 ;
MSH(MSG) ;break out MSH segment separators and set other needed variables
 ;MSH = MSH segment of the HL-7 message
 N X
 S (SEP1,SEP2,SEP3,SEP4,SEP5)=""
 S SEP1=$E(MSG,4),X=$P(MSG,SEP1,2)
 S SEP2=$E(X,1),SEP3=$E(X,2),SEP4=$E(X,3),SEP5=$E(X,4)
 ; Initialize HL7 variable for outbound Consults message
 D INIT("TIUHL7 MIRTH MDM EVENT")
 Q
 ;
PID ;PID Segment
 N FLDS,X,PID,XPID
 N ZARY,ZIEN,ZDOB,ZSEX
 I $G(DFN)="" Q "-1^Value missing to build message (PID segment)"
 S FLDS="3,5",PID=""
 D BLDPID^VAFCQRY(DFN,1,FLDS,.XPID,.HL)
 N XCNT S XCNT=0 F  S XCNT=$O(XPID(XCNT)) Q:XCNT=""  S PID=PID_XPID(XCNT)
 K ZARY S ZIEN=DFN_","
 D GETS^DIQ(2,ZIEN,".02;.03","I","ZARY")
 S ZSEX=ZARY(2,ZIEN,".02","I")
 S ZDOB=ZARY(2,ZIEN,".03","I"),ZDOB=$$HLDATE^HLFNC(ZDOB,"DT")
 S $P(PID,SEP1,8)=ZDOB
 S $P(PID,SEP1,9)=ZSEX
 D UPDATEPID
 D HLA(PID)
 Q
 ;
UPDATEPID ;Add site specific info to PID segment
 ;Use HRN if Oroville
 Q:$$SITE^VASITE()'["OROVILLE"
 N SUBPID
 ;DFN must be defined before calling
 Q:'$G(DFN)
 D DEM^VADPT
 S SUBPID=$P(PID,SEP1,4)
 S $P(SUBPID,SEP2,1)=VA("PID")  ;Get MRN - don't strip leading zeros
 S $P(PID,SEP1,4)=SUBPID
 Q
 ;
PV1 ;PV1 Segment
 ;CURRENTLY ADMITTED?
 N PV1,VAINDT,VAIN
 S PV1=""
 S VAINDT=DT
 D INP^VADPT
 I $G(VAIN(1))'="" S $P(PV1,HL("FS"),44)=$$HLDATE^HLFNC($P(VAIN(7),"^")),PV1="PV1"_HL("FS")_PV1
 K VAIN
 D HLA(PV1)
 Q
 ;
ORC(MSG) ;ORC Segment
 ; Get OERR Order Number
 S ORN=$P($P(MSG,SEP1,3),";")
 ; Get REQUEST/CONSULTATION IEN
 S GMRCN=$O(^GMR(123,"AC",ORN,0))
 I GMRCN]"" S $P(MSG,SEP1,4)=GMRCN
 D HLA(MSG)
 Q ORN
 ;
OBR(MSG) ;OBR Segment
 D HLA(MSG)
 Q
 ;
ZSV(MSG) ;ZSV Segment
 D HLA(MSG)
 Q
 ;
OBX(MSG) ;OBX Segment
 D HLA(MSG)
 Q
 ;
HLA(MSG) ;Set the HLA array
 S HLA("HLS",CNT)=MSG,CNT=CNT+1
 Q
 ;
SNDMSG ;Create the ^TMP("HLS",$J array and send the message
 S:$D(ZTQUEUED) ZTREQ="@"
 N HLRESLT,HLP
 D GENERATE^HLMA(EID,"LM",1,.HLRESLT,"",.HLP)
 K HLA,EVNT
 Q
 ;
EXIT ;Kill variables and quit
 K SG,ZTIO,ZTSAVE,STDESC,STRTN,STDTH
 Q 
