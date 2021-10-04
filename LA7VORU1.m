LA7VORU1	;DALOI/JMC - Builder of HL7 Lab Results Microbiology OBR/OBX/NTE ;11/18/11  14:52
	;;5.2;AUTOMATED LAB INSTRUMENTS;**46,64,68,74**;Sep 27, 1994;Build 229
	;
	Q
	;
	;
MI	; Build segments for "MI" subscript
	;
	N LA7I,LA7IDT,LA7ISOID,LA7IENS,LA7MISB,LA7NLT,LA7REL,LA7SUBFL,LA7VNLT,LA7VT,LA7VTIEN,LRDFN,LRIDT,LRSB,LRSS
	;
	S LRDFN=LA("LRDFN"),LRSS=LA("SUB"),(LA7IENS,LRIDT)=LA("LRIDT")
	; Flag that whole report has been released, complete date in field  #.03
	S LA7REL=$P(^LR(LRDFN,LRSS,LRIDT,0),"^",3)
	;
	; Determine if there are specific sections to send back.
	I $G(LA(62.49)) D
	. S LA7VNLT=$P($G(^LAHM(62.49,LA(62.49),63)),"^",5),LA7VTIEN=0
	. F  S LA7VTIEN=$O(^LAHM(62.49,LA(62.49),1,LA7VTIEN)) Q:'LA7VTIEN  D
	. . S LA7VT=^LAHM(62.49,LA(62.49),1,LA7VTIEN,0)
	. . I $P(LA7VT,"^") D
	. . . S LA7VT(63)=$G(^LAB(64.061,$P(LA7VT,"^"),63))
	. . . I $P(LA7VT(63),"^")'="MI" Q
	. . . I $P(LA7VT(63),"^",3) S LA7MISB($P(LA7VT(63),"^",2,3))=LA7VNLT
	;
	; Send gram stain if C&S
	I $D(LA7MISB("63.05^11")) S LA7MISB("63.05^11.6;63.29")=LA7MISB("63.05^11")
	;
	; Send acid fast stain if AFB culture
	I $D(LA7MISB("63.05^22")) S LA7MISB("63.05^24")=LA7MISB("63.05^22")
	;
	; If no specific section then check all sections
	I '$D(LA7MISB) F LA7VT="63.05^11","63.05^11.6;63.29","63.05^14","63.05^18","63.05^22","63.05^24","63.05^33" S LA7MISB(LA7VT)=""
	;
	; Bacteriology Report
	I $D(^LR(LRDFN,LRSS,LRIDT,1)),(LA7REL!$P($G(^LR(LRDFN,LRSS,LRIDT,1)),"^")) D
	. I '$D(LA7MISB("63.05^11")),'$D(LA7MISB("63.05^11.6;63.29"))  Q
	. S LA7NTESN=0,LA7IDT=LRIDT,LRSB=11
	. I '$D(LA7MISB("63.05^11")),$D(LA7MISB("63.05^11.6;63.29")) S LA7NLT=$S($P(LA7MISB("63.05^11.6;63.29"),"^"):$P(LA7MISB("63.05^11.6;63.29"),"^"),1:"87754.0000")
	. E  S LA7NLT=$S($P(LA7MISB("63.05^11"),"^"):$P(LA7MISB("63.05^11"),"^"),1:"87993.0000")
	. D OBR^LA7VORU
	. I LA7NVAF=1 D PLC^LA7VORUA
	. D NTE^LA7VORU
	. I LA7NVAF=1 D
	. . S LRSB=11 D RPT^LA7VORU2
	. . F LRSB=1,11.7,1.5 D RPTNTE^LA7VORU2
	. I LA7NVAF'=1 F LRSB=1,11.7,1.5,11 D RPTNTE^LA7VORU2
	. S LA7OBXSN=0
	. ; Report urine/sputum screens
	. F LA7I=5,6 I $P(^LR(LRDFN,LRSS,LRIDT,1),"^",LA7I)'="" S LRSB=$S(LA7I=5:11.58,1:11.57) D OBX
	. ; Report gram stain
	. I $D(^LR(LRDFN,LRSS,LRIDT,2)),$D(LA7MISB("63.05^11.6;63.29")) D GS
	. N LRSB
	. ; Check for organism id
	. I '$D(^LR(LRDFN,LRSS,LRIDT,3)) Q
	. S LRSB=12,LA7SUBFL=63.3
	. D ORG,MIC
	;
	; Parasite report
	I $D(^LR(LRDFN,LRSS,LRIDT,5)),(LA7REL!$P($G(^LR(LRDFN,LRSS,LRIDT,5)),"^")) D
	. I '$D(LA7MISB("63.05^14")) Q
	. S LRSB=14,LA7NTESN=0
	. S LA7NLT=$S($P(LA7MISB("63.05^14"),"^"):$P(LA7MISB("63.05^14"),"^"),1:"87925.0000")
	. D OBR^LA7VORU
	. I LA7NVAF=1 D PLC^LA7VORUA
	. D NTE^LA7VORU
	. S LA7OBXSN=0
	. I LA7NVAF=1 D
	. . S LRSB=14 D RPT^LA7VORU2
	. . F LRSB=16.5,15.51,16.4 D RPTNTE^LA7VORU2
	. I LA7NVAF'=1 F LRSB=16.5,15.51,16.4,14 D RPTNTE^LA7VORU2
	. ; Check for organism id
	. I '$D(^LR(LRDFN,LRSS,LRIDT,6)) Q
	. N LRSB
	. S LA7IDT=LRIDT,LRSB=16
	. D ORG
	;
	; Mycology report
	I $D(^LR(LRDFN,LRSS,LRIDT,8)),(LA7REL!$P($G(^LR(LRDFN,LRSS,LRIDT,8)),"^")) D
	. I '$D(LA7MISB("63.05^18")) Q
	. S LRSB=18,LA7NTESN=0
	. S LA7NLT=$S($P(LA7MISB("63.05^18"),"^"):$P(LA7MISB("63.05^18"),"^"),1:"87994.0000")
	. D OBR^LA7VORU
	. I LA7NVAF=1 D PLC^LA7VORUA
	. D NTE^LA7VORU
	. S LA7OBXSN=0
	. I LA7NVAF=1 D
	. . S LRSB=18 D RPT^LA7VORU2
	. . F LRSB=20.5,19.6,20.4 D RPTNTE^LA7VORU2
	. I LA7NVAF'=1 F LRSB=20.5,19.6,20.4,18 D RPTNTE^LA7VORU2
	. ; Check for organism id
	. I '$D(^LR(LRDFN,LRSS,LRIDT,9)) Q
	. N LRSB
	. S LA7IDT=LRIDT,LRSB=20
	. D ORG
	;
	; Mycobacterium report
	I $D(^LR(LRDFN,LRSS,LRIDT,11)),(LA7REL!$P($G(^LR(LRDFN,LRSS,LRIDT,11)),"^")) D
	. I '$D(LA7MISB("63.05^22")),'$D(LA7MISB("63.05^24"))  Q
	. S LA7NTESN=0,LA7IDT=LRIDT,LRSB=22
	. I '$D(LA7MISB("63.05^22")),$D(LA7MISB("63.05^24")) S LA7NLT=$S($P(LA7MISB("63.05^24"),"^"):$P(LA7MISB("63.05^24"),"^"),1:"87756.0000")
	. E  S LA7NLT=$S($P(LA7MISB("63.05^22"),"^"):$P(LA7MISB("63.05^22"),"^"),1:"87995.0000")
	. D OBR^LA7VORU
	. I LA7NVAF=1 D PLC^LA7VORUA
	. D NTE^LA7VORU
	. I LA7NVAF=1 D
	. . S LRSB=22 D RPT^LA7VORU2
	. . F LRSB=26.5,26.4 D RPTNTE^LA7VORU2
	. I LA7NVAF'=1 F LRSB=26.5,26.4,22 D RPTNTE^LA7VORU2
	. S LA7OBXSN=0
	. ; Report acid fast stain
	. I $P(^LR(LRDFN,LRSS,LRIDT,11),"^",3)'="" D
	. . S LRSB=24 D OBX
	. . I $P(^LR(LRDFN,LRSS,LRIDT,11),"^",4)'="" S LRSB=25 D OBX
	. ; Check for organism id
	. I '$D(^LR(LRDFN,LRSS,LRIDT,12)) Q
	. N LRSB
	. S LA7IDT=LRIDT,LRSB=26,LA7SUBFL=63.39
	. D ORG,MIC
	;
	; Virology report
	I $D(^LR(LRDFN,LRSS,LRIDT,16)),(LA7REL!$P($G(^LR(LRDFN,LRSS,LRIDT,16)),"^")) D
	. I '$D(LA7MISB("63.05^33")) Q
	. S LRSB=33,LA7NTESN=0
	. S LA7NLT=$S($P(LA7MISB("63.05^33"),"^"):$P(LA7MISB("63.05^33"),"^"),1:"87996.0000")
	. D OBR^LA7VORU
	. I LA7NVAF=1 D PLC^LA7VORUA
	. D NTE^LA7VORU
	. S LA7OBXSN=0
	. I LA7NVAF=1 D
	. . S LRSB=33 D RPT^LA7VORU2
	. . F LRSB=36.5,36.4 D RPTNTE^LA7VORU2
	. I LA7NVAF'=1 F LRSB=36.5,36.4,33 D RPTNTE^LA7VORU2
	. ; Check for virus id
	. I '$D(^LR(LRDFN,LRSS,LRIDT,17)) Q
	. N LRSB
	. S LA7IDT=LRIDT,LRSB=36
	. D ORG
	;
	; Antibiotic Levels
	I $D(^LR(LRDFN,LRSS,LRIDT,14)) D
	. N LA7SR
	. S LRSB=28,LA7NLT="93978.0000",LA7NTESN=0
	. D OBR^LA7VORU
	. S LA7SR=0
	. F  S LA7SR=$O(^LR(LRDFN,LRSS,LRIDT,14,LA7SR)) Q:'LA7SR  S LA7IDT=LRIDT_","_LA7SR D OBX
	;
	; Sterility results
	I $D(^LR(LRDFN,LRSS,LRIDT,31)) D
	. N LA7SR
	. S LRSB=11.52,LA7NLT="93982.0000",LA7NTESN=0
	. D OBR^LA7VORU
	. S LA7SR=0
	. F  S LA7SR=$O(^LR(LRDFN,LRSS,LRIDT,31,LA7SR)) Q:'LA7SR  S LA7IDT=LRIDT_","_LA7SR D OBX
	;
	; Check if specific NLT in the ORUT node for test being NP and build OBR for the NP test.
	I $G(LA7VNLT)'="" D
	. N LA7DISPO,LA7I
	. S LA7DISPO=$$FIND1^DIC(64.061,"","OQX","X","D","I $P(^(0),U,5)=""0123""")
	. S LA7I=$O(^LR(LRDFN,LRSS,LRIDT,"ORUT","B",LA7VNLT,0)) Q:'LA7I
	. I LA7DISPO'="",$P(^LR(LRDFN,LRSS,LRIDT,"ORUT",LA7I,0),"^",10)=LA7DISPO D
	. . S LA7NLT=LA7VNLT,LRSB=$P($G(LA7VT(63)),"^",3),LA7NTESN=0,LA7IDT=LRIDT
	. . S:LRSB="" LRSB=0 D OBR^LA7VORU,NTE^LA7VORU
	;
	Q
	;
	;
GS	; Report Gram stain
	;
	N LA7GS
	;
	S LA7GS=0,LRSB=11.6
	F  S LA7GS=$O(^LR(LRDFN,LRSS,LRIDT,2,LA7GS)) Q:'LA7GS  D
	. S LA7IDT=LRIDT_","_LA7GS,LA7NTESN=0
	. D OBX
	Q
	;
	;
ORG	; Build OBX segments for MI subscript organism id
	;
	N LA7ND,LA7ORG
	;
	; Bacterial organism
	I LRSB=12 S LA7ND=3
	; Parasite organism
	I LRSB=16 S LA7ND=6
	; Fungal organism
	I LRSB=20 S LA7ND=9
	; Mycobacteria organism
	I LRSB=26 S LA7ND=12
	; Viral agent
	I LRSB=36 S LA7ND=17
	;
	S LA7ORG=0
	F  S LA7ORG=$O(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG)) Q:'LA7ORG  D
	. S LA7IDT=LRIDT_","_LA7ORG_","
	. D OBX
	. I LA7ND=17 Q  ; no quantity/comments on viruses
	. I LA7ND=6 D PSTAGE Q
	. D ORGNTE
	. I $P($G(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG,0)),"^",2)'="" D CC
	Q
	;
	;
CC	; Send colony count (quantity)
	;
	N LRSB
	;
	I LA7ND=3 S LRSB="12,1"
	I LA7ND=9 S LRSB="20,1"
	I LA7ND=12 S LRSB="26,1"
	D OBX
	;
	Q
	;
	;
PSTAGE	; Send parasite's stage/quantity/comments
	N LA7CMTP,LA7FMT,LA7J,LA7SB,LA7SOC,LA7NTESN,LA7TXT,LA7X,LRSB
	;
	; Source of comment - handle special codes for other systems, ie DOD-CHCS
	S LA7SOC=$S($G(LA7NVAF)=1:"RC",1:"L")
	;
	S LA7FMT=0,LA7CMTYP=""
	; If HDR interface then send as repetition text.
	I $G(LA7INTYP)=30 S LA7FMT=2
	;
	S LA7SB=0
	F  S LA7SB=$O(^LR(LRDFN,LRSS,LRIDT,6,LA7ORG,1,LA7SB)) Q:'LA7SB  D
	. S LA7IDT=LRIDT_","_LA7ORG_","_LA7SB
	. S LRSB="16,.01" D OBX
	. S (LA7J,LA7NTESN)=0
	. F  S LA7J=$O(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG,1,LA7SB,1,LA7J)) Q:'LA7J  D
	. . S LA7X=$G(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG,1,LA7SB,1,LA7J,0))
	. . I LA7X="" S LA7X=" "
	. . I LA7FMT S LA7TXT(LA7J)=LA7X
	. . E  S LA7TXT=LA7X D NTE
	. I LA7FMT,$D(LA7TXT) D NTE
	. S LRSB="16,1" D OBX
	Q
	;
	;
ORGNTE	; Send comments on organisms.
	;
	N LA7CMTYP,LA7FMT,LA7J,LA7SOC,LA7NTESN,LA7TXT,LA7X
	;
	; Source of comment - handle special codes for other systems, ie DOD-CHCS
	S LA7SOC=$S($G(LA7NVAF)=1:"RC",1:"L")
	;
	S LA7FMT=0,LA7CMTYP=""
	; If HDR interface then send as repetition text.
	I $G(LA7INTYP)=30 S LA7FMT=2
	;
	S (LA7J,LA7NTESN)=0
	F  S LA7J=$O(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG,1,LA7J)) Q:'LA7J  D
	. S LA7X=$G(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG,1,LA7J,0))
	. I LA7X="" S LA7X=" "
	. I LA7FMT S LA7TXT(LA7J)=LA7X
	. E  S LA7TXT=LA7X D NTE
	;
	; If formatted or repetition format then build each type of comments to a NTE segment.
	I LA7FMT,$D(LA7TXT) D NTE
	;
	Q
	;
	;
MIC	; Build OBR/OBX segments for MI subscript susceptibilities (MIC)
	;
	N LA7ORG,LA7ND,LA7NLT,LA7SB,LA7SB1,LA7SOC
	;
	; Source of comment - handle special codes for other systems, ie DOD-CHCS
	S LA7SOC=$S($G(LA7NVAF)=1:"RC",1:"L")
	;
	S LA7NLT=""
	I LRSB=12 S LA7ND=3,LA7NLT="87565.0000"
	I LRSB=26 S LA7ND=12,LA7NLT="87568.0000"
	;
	S LA7ORG=0,LA7SB=LRSB
	F  S LA7ORG=$O(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG)) Q:'LA7ORG  D
	. N LA7NTESN,LA7PARNT
	. ; Check for susceptibilities for this organism
	. S X=$O(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG,2))
	. I X<2!(X>3) Q
	. S LA7PARNT=$$GETISO^LA7VHLU1(LA7SUBFL,LA7ORG_","_LRIDT_","_LRDFN_",")
	. M LA7PARNT=LA7ISOID(LA7PARNT)
	. D OBR^LA7VORU
	. S LA7OBXSN=0,LA7SB1=2
	. F  S LA7SB1=$O(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG,LA7SB1)) Q:'LA7SB1!(LA7SB1>2.99)  D
	. . N LA7CMTYP,LA7FMT,LA7TXT,LRSB,X
	. . S LA7IDT=LRIDT_","_LA7ORG_","_LA7SB1,LRSB=LA7SB_","_LA7SB1
	. . D OBX
	. . S X=""
	. . I LA7SB=12 S X=$O(^LAB(62.06,"AD",LA7SB1,0))
	. . I LA7SB=26 S X=$O(^LAB(62.06,"AD1",LA7SB1,0))
	. . I X<1 Q
	. . S LA7TXT=$P($G(^LAB(62.06,X,0)),"^",3)
	. . I LA7TXT'="" S (LA7NTESN,LA7FMT)=0,LA7CMTYP="" D NTE
	. I LA7ND'=3 Q  ; no free text antibiotics on AFB
	. S LA7SB1=0
	. F  S LA7SB1=$O(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG,3,LA7SB1)) Q:'LA7SB1  D
	. . N LA7I,LRSB
	. . F LA7I=2,3 I $P(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG,3,LA7SB1,0),"^",LA7I)'="" D
	. . . S LA7IDT=LRIDT_","_LA7ORG_","_LA7SB1,LRSB=LA7SB_",3,"_(LA7I-1)
	. . . N LA7I D OBX
	Q
	;
	;
OBX	; Build OBX segments for MI subscript
	; Also called by AP^LA7VORU2 to build AP OBX segments.
	;
	N LA7DATA
	D OBX^LA7VOBX(LRDFN,LRSS,LA7IDT,LRSB,.LA7DATA,.LA7OBXSN,LA7FS,LA7ECH,LA7NVAF)
	;
	; If OBX failed to build then don't store
	I '$D(LA7DATA) Q
	;
	D FILESEG^LA7VHLU(GBL,.LA7DATA)
	;
	; Check for flag to only build message but do not file
	I '$G(LA7NOMSG) D FILE6249^LA7VHLU(LA76249,.LA7DATA)
	Q
	;
	;
NTE	; Build NTE segment with comment
	;
	N LA7DATA
	;
	D NTE^LA7VHLU3(.LA7DATA,.LA7TXT,$G(LA7SOC),LA7FS,LA7ECH,.LA7NTESN,$G(LA7CMTYP),$G(LA7FMT))
	D FILESEG^LA7VHLU(GBL,.LA7DATA)
	;
	; Check for flag to only build message but do not file
	I '$G(LA7NOMSG) D FILE6249^LA7VHLU(LA76249,.LA7DATA)
	;
	Q