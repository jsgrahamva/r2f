PSUDEM8	;BIR/DAM - ICD9 Codes for Inpatient PTF Record Extract ;20 DEC 2001
	;;4.0;PHARMACY BENEFITS MANAGEMENT;**19**;MARCH, 2005;Build 28
	;
	;DBIA's
	; Reference to file 45         supported by DBIA 3511
	; Reference to file 80         supported by DBIA 10082
	; Reference to ICDEX           supported by DBIA 5747
	; Reference to ICDXCODE        supported by DBIA 5699
	;
EN	;EN  CALLED FROM PSUDEM7
	D PTFIEN
	Q
	;
PTFIEN	;$O through ^XTMP("PSU_"_PSUJOB,"PSUIPV" to get all the PTF IEN's
	;
	;S PSUC=0
	S PSUC=0
	F  S PSUC=$O(^XTMP("PSU_"_PSUJOB,"PSUIPV",PSUC)) Q:'PSUC  D
	.D PTF70     ;gather ICD9 data on ^DGPT(D0,70 node
	.D PTFM      ;gather ICD9 data on ^DGPT(D0,"M","AC" node
	.D FIN K ^XTMP("PSU_"_PSUJOB,"PSUTMP3")
	.D EN^PSUDEM9    ;gather CPT data on 2 separate ^DGPT nodes
	Q
	;
PTF70	;Find all ICD pointers present on ^DGPT(D0,70 node
	;drp 2/13/2012 added second line to each line in old block
	;N PSU1,PSU2,PSU3,PSU4,PSU5,PSU6,PSU7,PSU8,PSU9,PSU10,PSU11
	N PSU1,PSU2,PSU3,PSU4,PSU5,PSU6,PSU7,PSU8,PSU9,PSU10,PSU11,CSYS
	;
	S PSU1=$P($G(^DGPT(PSUC,70)),U,10) S:PSU1="" PSU1="NULL"  ;Ptr 1 PRINCIPAL[10P:80
	S:PSU1'="NULL" CSYS(1)=$$CSI^ICDEX(80,PSU1),PSU1("ICDSYS")=$S(CSYS(1)=1:9,CSYS(1)=30:10,1:"")
	;
	S PSU2=$P($G(^DGPT(PSUC,70)),U,16) S:PSU2="" PSU2="NULL"  ;Ptr 2 SECONDARY[16P:80]
	S:PSU2'="NULL" CSYS(2)=$$CSI^ICDEX(80,PSU2),PSU2("ICDSYS")=$S(CSYS(2)=1:9,CSYS(2)=30:10,1:"")
	;
	S PSU3=$P($G(^DGPT(PSUC,70)),U,17) S:PSU3="" PSU3="NULL"  ;Ptr 3
	S:PSU3'="NULL" CSYS(3)=$$CSI^ICDEX(80,PSU3),PSU3("ICDSYS")=$S(CSYS(3)=1:9,CSYS(3)=30:10,1:"")
	;
	S PSU4=$P($G(^DGPT(PSUC,70)),U,18) S:PSU4="" PSU4="NULL"  ;Ptr 4
	S:PSU4'="NULL" CSYS(4)=$$CSI^ICDEX(80,PSU4),PSU4("ICDSYS")=$S(CSYS(4)=1:9,CSYS(4)=30:10,1:"")
	;
	S PSU5=$P($G(^DGPT(PSUC,70)),U,19) S:PSU5="" PSU5="NULL"  ;Ptr 5
	S:PSU5'="NULL" CSYS(5)=$$CSI^ICDEX(80,PSU5),PSU5("ICDSYS")=$S(CSYS(5)=1:9,CSYS(5)=30:10,1:"")
	;
	S PSU6=$P($G(^DGPT(PSUC,70)),U,20) S:PSU6="" PSU6="NULL"  ;Ptr 6
	S:PSU6'="NULL" CSYS(6)=$$CSI^ICDEX(80,PSU6),PSU6("ICDSYS")=$S(CSYS(6)=1:9,CSYS(6)=30:10,1:"")
	;
	S PSU7=$P($G(^DGPT(PSUC,70)),U,21) S:PSU7="" PSU7="NULL"  ;Ptr 7
	S:PSU7'="NULL" CSYS(7)=$$CSI^ICDEX(80,PSU7),PSU7("ICDSYS")=$S(CSYS(7)=1:9,CSYS(7)=30:10,1:"")
	;
	S PSU8=$P($G(^DGPT(PSUC,70)),U,22) S:PSU8="" PSU8="NULL"  ;Ptr 8
	S:PSU8'="NULL" CSYS(8)=$$CSI^ICDEX(80,PSU8),PSU8("ICDSYS")=$S(CSYS(8)=1:9,CSYS(8)=30:10,1:"")
	;
	S PSU9=$P($G(^DGPT(PSUC,70)),U,23) S:PSU9="" PSU9="NULL"  ;Ptr 9
	S:PSU9'="NULL" CSYS(9)=$$CSI^ICDEX(80,PSU9),PSU9("ICDSYS")=$S(CSYS(9)=1:9,CSYS(9)=30:10,1:"")
	;
	S PSU10=$P($G(^DGPT(PSUC,70)),U,24) S:PSU10="" PSU10="NULL"  ;Ptr 10
	S:PSU10'="NULL" CSYS(10)=$$CSI^ICDEX(80,PSU10),PSU10("ICDSYS")=$S(CSYS(10)=1:9,CSYS(10)=30:10,1:"")
	;
	S PSU11=$P($G(^DGPT(PSUC,70)),U,11) S:PSU11="" PSU11="NULL"  ;Ptr 11 PRINCIPAL DIAGNOSIS pre 1986 [11P:80]
	S:PSU11'="NULL" CSYS(11)=$$CSI^ICDEX(80,PSU11),PSU11("ICDSYS")=$S(CSYS(11)=1:9,CSYS(11)=30:10,1:"")
	D ICD91
	Q
	;
ICD91	;Find ICD codes from pointer on ^DGPT(D0,70 node and place in
	;an array
	;
	N PSUID1,PSUID2,PSUID3,PSUID4,PSUID5,PSUID6,PSUID7,PSUID8,PSUID9
	N PSUID10,PSUID11
	S:PSU1'["N" PSUID1=$P($$ICDDATA^ICDXCODE(CSYS(1),PSU1),U,2) D
	.I $D(PSUID1) S ^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,1,PSUID1)=$G(PSU1("ICDSYS"))   ;1ST ICD CODE
	S:PSU2'["N" PSUID2=$P($$ICDDATA^ICDXCODE(CSYS(2),PSU2),U,2) D
	.I $D(PSUID2) S ^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,2,PSUID2)=$G(PSU2("ICDSYS"))   ;2ND ICD CODE
	S:PSU3'["N" PSUID3=$P($$ICDDATA^ICDXCODE(CSYS(3),PSU3),U,2) D
	.I $D(PSUID3) S ^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,3,PSUID3)=$G(PSU3("ICDSYS"))   ;3rd ICD CODE
	S:PSU4'["N" PSUID4=$P($$ICDDATA^ICDXCODE(CSYS(4),PSU4),U,2) D
	.I $D(PSUID4) S ^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,4,PSUID4)=$G(PSU4("ICDSYS"))   ;4th ICD CODE
	S:PSU5'["N" PSUID5=$P($$ICDDATA^ICDXCODE(CSYS(5),PSU5),U,2) D
	.I $D(PSUID5) S ^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,5,PSUID5)=$G(PSU5("ICDSYS"))   ;5th ICD CODE
	S:PSU6'["N" PSUID6=$P($$ICDDATA^ICDXCODE(CSYS(6),PSU6),U,2) D
	.I $D(PSUID6) S ^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,6,PSUID6)=$G(PSU6("ICDSYS"))   ;6th ICD CODE
	S:PSU7'["N" PSUID7=$P($$ICDDATA^ICDXCODE(CSYS(7),PSU7),U,2) D
	.I $D(PSUID7) S ^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,7,PSUID7)=$G(PSU7("ICDSYS"))   ;7th ICD CODE
	S:PSU8'["N" PSUID8=$P($$ICDDATA^ICDXCODE(CSYS(8),PSU8),U,2) D
	.I $D(PSUID8) S ^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,8,PSUID8)=$G(PSU8("ICDSYS"))   ;8th ICD CODE
	S:PSU9'["N" PSUID9=$P($$ICDDATA^ICDXCODE(CSYS(9),PSU9),U,2) D
	.I $D(PSUID9) S ^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,9,PSUID9)=$G(PSU9("ICDSYS"))   ;9th ICD CODE
	S:PSU10'["N" PSUID10=$P($$ICDDATA^ICDXCODE(CSYS(10),PSU10),U,2) D
	.I $D(PSUID10) S ^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,10,PSUID10)=$G(PSU10("ICDSYS"))  ;10th ICD CODE
	S:PSU11'["N" PSUID11=$P($$ICDDATA^ICDXCODE(CSYS(11),PSU11),U,2) D
	.I $D(PSUID11) S ^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,11,PSUID11)=$G(PSU11("ICDSYS"))  ;11th ICD CODE
	Q
	;
PTFM	;
	S PSUCD=0
	S I=12
	F  S PSUCD=$O(^DGPT(PSUC,"M","AC",PSUCD)) Q:'PSUCD  D
	.I PSUCD="" S PSUCD="N"
	.N PSUIDT
	.I PSUCD'="N" D
	..S CSYS(I)=$$CSI^ICDEX(80,PSUCD),PSUIDT=$P(($$ICDDATA^ICDXCODE(CSYS(I),PSUCD)),U,2)
	..S ^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,I,PSUIDT)=$S(CSYS(I)=1:9,CSYS(I)=30:10,1:"")
	..D DEL
	..S I=I+1
	.Q
	Q
	;
DEL	;Delete duplicates
	;
	F N=1:1:10 I $D(^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,N,PSUIDT)) D
	.K ^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,I,PSUIDT)
	Q
	;
FIN	;$O through array, and set codes into the Inpatient Record 
	;global ^XTMP("PSU_"_PSUJOB,"PSUIPV", ISYSCODE and SYSCODE are the coding system values
	;DRP 2/13/2012 ADDED SYSCODE LOGIC
	N SYSCODE,ISYSCODE
	S T=0,N=8
	F  S T=$O(^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,T)) Q:'T  Q:N=29  D
	.S PSUIDF=""
	.F  S PSUIDF=$O(^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,T,PSUIDF)) Q:'(PSUIDF]"")  D
	..S SYSCODE=$G(^XTMP("PSU_"_PSUJOB,"PSUTMP3",PSUC,T,PSUIDF)) S:$G(ISYSCODE)="" ISYSCODE=SYSCODE
	..S:SYSCODE'="" SYSCODE=$S(SYSCODE=ISYSCODE:SYSCODE,1:"U") ; Set to "U" if there has been a change
	..I SYSCODE="U",ISYSCODE'="U" S ISYSCODE="U" ;
	..S $P(^XTMP("PSU_"_PSUJOB,"PSUIPV",PSUC),U,N)=PSUIDF
	..S N=N+1
	F N=8:1:28 I '($P(^XTMP("PSU_"_PSUJOB,"PSUIPV",PSUC),U,N)]"") D
	.S $P(^XTMP("PSU_"_PSUJOB,"PSUIPV",PSUC),U,N)=""    ;Set unfilled pieces to null
	.Q
	K PSUCSYS1 S PSUCSYS1=$G(SYSCODE,"")
	Q