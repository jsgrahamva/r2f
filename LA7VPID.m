LA7VPID	;DALOI/JMC - HL7 PID/PV1 segment builder utility ;08/03/09  15:59
	;;5.2;AUTOMATED LAB INSTRUMENTS;**46,64,74**;Sep 27, 1994;Build 229
	;
	; Reference to routine $$EN^VAFHLPID supported by DBIA# 263
	;
PID(LRDFN,LA7EXTID,LA7ARRAY,LA7PIDSN,HL,LA7ALTID)	; Build PID segment
	; Call with     LRDFN = Lab DFN, passed by value
	;            LA7EXTID = to return as external patient id, id used by non-VA systems (optional)
	;            LA7ARRAY = array to return PID array, pass by reference
	;            LA7PIDSN = PID id counter, passed by value
	;                  HL = HL7 variable array, pass by reference
	;            LA7ALTID = return alternate patient id, id used by non-va systems (optional)
	;
	; Returns LA7ARRAY
	;
	N DFN,HLQ,LA763,LA7Y,LRDPF,VAFPID
	;
	; Change HLQ - VAFHLPID puts delete indicator when Vista has no value for field - not according to standard.
	S HLQ=""
	;
	I $G(LRDFN)=""!($G(HL("FS"))="") Q
	I '$D(^LR(LRDFN,0)) Q
	;
	S LA7EXTID=$G(LA7EXTID),LA7ALTID=$G(LA7ALTID),LA7PIDSN=$G(LA7PIDSN)+1
	S LA763(0)=$G(^LR(LRDFN,0))
	S LRDPF=$P(LA763(0),"^",2),DFN=$P(LA763(0),"^",3)
	;
	; Patient file - use VAF call
	I LRDPF=2 D F2PID
	;
	; Non-patient file
	I LRDPF'=2 D NF2PID
	K AGE,PNM,SEX,DOB,SSN,VA200,LRWRD,LRRB,LRTREA,VA
	Q
	;
	;
PV1(LRDFN,LA7ARRAY,LA7FS,LA7ECH)	; Build PV1 segment
	; Call with    LRDFN = ien of entry in File #63
	;           LA7ARRAY = array to return PV1 array, pass by reference
	;              LA7FS = HL field separator
	;             LA7ECH = HL encoding characters
	;
	;
	N DFN,LA763,LA7LOC,LRDPF,LA7Y
	S LA763(0)=$G(^LR(LRDFN,0))
	S LRDPF=$P(LA763(0),"^",2),DFN=$P(LA763(0),"^",3),LA7LOC=""
	;
	S LA7Y(0)="PV1"
	S LA7Y(1)=1
	;
	; Referral file with Patient file link.
	I LRDPF=67,$P($G(^LRT(67,DFN,"DPT")),"^") D
	. S LRDPF=2
	. S DFN=$P($G(^LRT(67,DFN,"DPT")),"^")
	;
	; Determine patient class
	; Current inpatient location
	I LRDPF=2 S LA7LOC=$G(^DPT(DFN,.1))
	I $L(LA7LOC) S LA7Y(2)="I" ; Inpatient
	;
	; Otherwise from lab files
	I $G(LA7LOC)="" D
	. S LA7LOC=$G(^LR(LRDFN,.1))
	. S LA7Y(2)="O" ; Default to outpatient
	;
	; Patient location
	S LA7LOC=$$CHKDATA^LA7VHLU3(LA7LOC,LA7FS_LA7ECH)
	S LA7Y(3)=LA7LOC
	;
	D BUILDSEG^LA7VHLU(.LA7Y,.LA7ARRAY,LA7FS)
	Q
	;
	;
F2PID	; Build patient identifier field on file #2 patient
	;
	; Non VA users of VistA need to send patient's address
	N I,ICN,LA7X,LRSTR,X
	S LA7STR="1,5,6,7,8,10NTB,"_$S(DUZ("AG")="V":"",1:"11,")_"16,19"
	S LA7ARRAY(0)=$$EN^VAFHLPID(DFN,LA7STR,LA7PIDSN,3)
	;
	; Check for overflow (>245)
	I $O(VAFPID(0)) D
	. S I=0
	. F  S I=$O(VAFPID(I)) Q:'I  S LA7ARRAY(I)=VAFPID(I)
	;
	; Return external identifier in PID-2 sequence, backward compatibility to V2.2
	I LA7EXTID'="" D
	. I '(LA7EXTID?1N.N) S $P(LA7ARRAY(0),HL("FS"),3)=LA7EXTID
	. E  S $P(LA7ARRAY(0),HLFS,3)=$$M11^HLFNC(LA7EXTID,HL("ECH"))
	;
	; Send SSN as patient identifier
	S X=$P(LA7ARRAY(0),HLFS,4)
	I $P(X,$E(HL("ECH")),5)="SS" S $P(X,$E(HL("ECH")),1)=$TR($P(X,$E(HL("ECH")),1),"-",""),$P(LA7ARRAY(0),HLFS,4)=X
	;
	; Send DFN as patient identifier
	S X=$$M11^HLFNC(DFN,HL("ECH"))
	S $P(X,$E(HL("ECH")),5)="PI"
	S $P(X,$E(HL("ECH")),6)=$$RETFACID^LA7VHLU2(+$$KSP^XUPARAM("INST"),2,1)_$E(HL("ECH"),4)_$$KSP^XUPARAM("WHERE")_$E(HL("ECH"),4)_"DNS"
	S $P(LA7ARRAY(0),HLFS,4)=$P(LA7ARRAY(0),HL("FS"),4)_$E(HL("ECH"),2)_X
	;
	; Send ICN from MPI as patient identifier
	S ICN=$$ICN(DFN,HL("ECH"))
	I ICN>0 S $P(LA7ARRAY(0),HLFS,4)=$P(LA7ARRAY(0),HL("FS"),4)_$E(HL("ECH"),2)_ICN
	;
	; Send alternate patient id if passed
	I LA7ALTID'="" S $P(LA7ARRAY(0),HL("FS"),5)=LA7ALTID
	I $P(LA7ARRAY(0),HLFS,5)?1N.N S $P(LA7ARRAY(0),HL("FS"),5)=$$M11^HLFNC($P(LA7ARRAY(0),HL("FS"),5),HL("ECH"))
	;
	Q
	;
	;
NF2PID	; Build patient identifier field on non-file #2 patient
	;
	N X
	D PT^LRX
	S LA7Y(0)="PID"
	S LA7Y(1)=LA7PIDSN
	;
	; Return external identifier in PID-2 sequence, backward compatibility to V2.2
	; Also include external identifier in PID-3 for current versions (>v2.2)
	S LA7Y(3)=""
	I LA7EXTID'="" D
	. I '(LA7EXTID?1N.N) S LA7Y(2)=LA7EXTID
	. E  S LA7Y(2)=$$M11^HLFNC(LA7EXTID,HL("ECH"))
	. S LA7Y(3)=LA7EXTID
	;
	S X=$$M11^HLFNC(SSN(2),HL("ECH"))
	I LRDPF=67.1 S $P(X,$E(HL("ECH"),1),5)="L2"
	I LA7Y(3)'="",LA7Y(3)'[SSN(2) S LA7Y(3)=LA7Y(3)_$E(HL("ECH"),2)_X
	I LA7Y(3)="" S LA7Y(3)=X
	;
	; Send LRDFN as alternate patient ID, unless alternate id passed
	I LA7ALTID'="" S LA7Y(4)=LA7ALTID
	E  S LA7Y(4)=LRDFN
	I LA7Y(4)?1N.N S LA7Y(4)=$$M11^HLFNC(LA7Y(4),HL("ECH"))
	I $P(LA7Y(4),$E(HL("ECH"),1),5)="" S $P(LA7Y(4),$E(HL("ECH"),1),5)="U"
	;
	S LA7Y(5)=$$HLNAME^XLFNAME(PNM,"S",$E(HL("ECH")))
	;
	I $G(DOB)'="" D
	. S DOB=$$CHKDT^LA7VHLU1(DOB)
	. S LA7Y(7)=$$FMTHL7^XLFDT(DOB)
	;
	S LA7Y(8)=$S($G(SEX)'="":SEX,1:"U")
	;
	; Race - if from REFERRAL PATIENT file (#67) then check RACE field.
	S LA7Y(10)=""
	I LRDPF=67 D
	. S LA7X=$$GET1^DIQ(67,DFN_",",.06,"I")
	. I LA7X<1 Q
	. S LA7Y(10)=$$PTR2CODE^DGUTL4(LA7X,1,2)
	. S $P(LA7Y(10),$E(HL("ECH"),1),2)=$$PTR2TEXT^DGUTL4(LA7X,1)
	. S $P(LA7Y(10),$E(HL("ECH"),1),3)="HL70005"
	;
	; SSN from referral file if 9N - DoD uses PID-19 to validate
	S LA7Y(19)=""
	I LRDPF=67 D
	. S LA7X=$$GET1^DIQ(67,DFN_",",.09,"I")
	. I LA7X?9N S LA7Y(19)=LA7X
	;
	D BUILDSEG^LA7VHLU(.LA7Y,.LA7ARRAY,HL("FS"))
	Q
	;
	;
ICN(DFN,LA7ECH)	; Send ICN from MPI
	; Call with DFN = internal entry number of patient in PATIENT #2 file.
	;        LA7ECH = HL7 encoding characters.
	;
	; If ICN is local then assigning facility is local site
	;    otherwise indicate 200M.
	;
	N ICN,LA7ICN,LOCAL,SITE
	;
	S ICN=""
	;
	S LA7ICN=$$GETICN^MPIF001(DFN)
	I LA7ICN>0 D
	. S ICN=LA7ICN
	. S LOCAL=$$IFLOCAL^MPIF001(DFN)
	. I LOCAL'=1 S SITE="200M"
	. E  S SITE=$P($$SITE^VASITE,"^",3)
	. S $P(ICN,$E(LA7ECH,1),4)="USVHA"_$E(LA7ECH,4)_$E(LA7ECH,4)_"HL70363"
	. S $P(ICN,$E(LA7ECH,1),5)="NI"
	. S $P(ICN,$E(LA7ECH,1),6)="VA FACILITY ID"_$E(LA7ECH,4)_SITE_$E(LA7ECH,4)_"L"
	;
	Q ICN
