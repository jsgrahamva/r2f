ONCOAIP1	;Hines OIFO/GWB [EE Abstract Edit Primary]; 08/29/01
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	;
SSS	;SYSTEMIC/SURGERY SEQUENCE (165.5,15)
	Q:$P(^ONCO(165.5,D0,3.1),U,39)'=""
	S S=$E($$GET1^DIQ(165.5,D0,58.6,"E"),1,2)
	S SATF=$E($$GET1^DIQ(165.5,D0,58.7,"E"),1,2)
	S SCP=$P($G(^ONCO(165.5,D0,3.1)),U,31)
	S SCPATF=$P($G(^ONCO(165.5,D0,3.1)),U,32)
	S SOTH=$P($G(^ONCO(165.5,D0,3.1)),U,33)
	S SOTHATF=$P($G(^ONCO(165.5,D0,3.1)),U,34)
	S C=$$GET1^DIQ(165.5,D0,53.2,"I")
	S CATF=$$GET1^DIQ(165.5,D0,53.3,"I")
	S H=$$GET1^DIQ(165.5,D0,54.2,"I")
	S HATF=$$GET1^DIQ(165.5,D0,54.3,"I")
	S I=$$GET1^DIQ(165.5,D0,55.2,"I")
	S IATF=$$GET1^DIQ(165.5,D0,55.3,"I")
	S HTE=$$GET1^DIQ(165.5,D0,153,"I")
	I ((S="00")!(S=99)!(S=98)!(S=""))&((SATF="00")!(SATF=99)!(SATF=98)!(SATF=""))&((SCP=0)!(SCP="")!(SCP=9))&((SCPATF=0)!(SCPATF="")!(SCPATF=9))&((SOTH=0)!(SOTH=""))&((SOTHATF=0)!(SOTHATF="")) S SR=0
	E  S SR=1
	S DST=$$GET1^DIQ(165.5,D0,152)
	I ((DST="00/00/0000")!(DST="99/99/9999")!(DST="88/88/8888")!(DST="")) S ST=0
	E  S ST=1
	I ($G(SR)&$G(ST)) D
	.S SDT=$P($G(^ONCO(165.5,D0,3)),U,1)
	.S:SDT'="" SSSEQ("S",SDT)="S",SSSEQ(SDT)="S"
	.S SATFDT=$P($G(^ONCO(165.5,D0,3.1)),U,8)
	.S:SATFDT'="" SSSEQ("S",SATFDT)="S",SSSEQ(SATFDT)="S"
	.S SCPDT=$P($G(^ONCO(165.5,D0,3.1)),U,22)
	.S:SCPDT'="" SSSEQ("S",SCPDT)="S",SSSEQ(SCPDT)="S"
	.S SCPATFDT=$P($G(^ONCO(165.5,D0,3.1)),U,23)
	.S:SCPATFDT'="" SSSEQ("S",SCPATFDT)="S",SSSEQ(SCPATFDT)="S"
	.S SOTDT=$P($G(^ONCO(165.5,D0,3.1)),U,24)
	.S:SOTDT'="" SSSEQ("S",SOTDT)="S",SSSEQ(SOTDT)="S"
	.S SOTATFDT=$P($G(^ONCO(165.5,D0,3.1)),U,25)
	.S:SOTATFDT'="" SSSEQ("S",SOTATFDT)="S",SSSEQ(SOTATFDT)="S"
	.S CDT=$P($G(^ONCO(165.5,D0,3)),U,11)
	.S:CDT'="" SSSEQ("SYS",CDT)="SYS",SSSEQ(CDT)="SYS"
	.S CATFDT=$P($G(^ONCO(165.5,D0,3.1)),U,15)
	.S:CATFDT'="" SSSEQ("SYS",CATFDT)="SYS",SSSEQ(CATFDT)="SYS"
	.S HDT=$P($G(^ONCO(165.5,D0,3)),U,14)
	.S:HDT'="" SSSEQ("SYS",HDT)="SYS",SSSEQ(HDT)="SYS"
	.S HATFDT=$P($G(^ONCO(165.5,D0,3.1)),U,17)
	.S:HATFDT'="" SSSEQ("SYS",HATFDT)="SYS",SSSEQ(HATFDT)="SYS"
	.S IDT=$P($G(^ONCO(165.5,D0,3)),U,17)
	.S:IDT'="" SSSEQ("SYS",IDT)="SYS",SSSEQ(IDT)="SYS"
	.S IATFDT=$P($G(^ONCO(165.5,D0,3.1)),U,19)
	.S:IATFDT'="" SSSEQ("SYS",IATFDT)="SYS",SSSEQ(IATFDT)="SYS"
	.S HTEDT=$P($G(^ONCO(165.5,D0,3.1)),U,35)
	.S:HTEDT'="" SSSEQ("SYS",HTEDT)="SYS",SSSEQ(HTEDT)="SYS"
	.S FSDT=$O(SSSEQ("S",0)),FSYSDT=$O(SSSEQ("SYS",0))
	.I FSDT=FSYSDT G EXIT
	.S SSSEQ=$O(SSSEQ(0))
	.I SSSEQ(SSSEQ)="SYS" S $P(^ONCO(165.5,D0,3.1),U,39)=2
	.I SSSEQ(SSSEQ)="S" S $P(^ONCO(165.5,D0,3.1),U,39)=3
	E  D
	.S $P(^ONCO(165.5,D0,3.1),U,39)=0
	;
EXIT	;Exit
	K S,SATF,SCP,SCPATF,SOTH,SOTHATF,C,CATF,H,HATF,I,IATF,HTE,SR,DST,ST
	K SDT,SATFDT,SCPDT,SCPATFDT,SOTDT,SOTATFDT
	K CDT,CATFDT,HDT,HATFDT,IDT,IATFDT,HTEDT
	K SSSEQ,FSDT,FSYSDT
	Q
