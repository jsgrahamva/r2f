ONCOCRA	;Hines OIFO/RTK-CREATE/USE SPECIAL CROSS-REFERENCES ;05/30/00
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	;
	Q  ;NOT A RUN ROUTINE
	;TRIGGER mumps cross references for Followup attempts
SLC	;SET LAST FOLLOWUP CONTACT
	Q:X=2!(X=9)  S XD0=$O(^ONCO(160,DA(1),"A","AC",0)) Q:XD0=""  S XD0=$O(^(XD0,0)) S LA=^ONCO(160,DA(1),"A",XD0,0),LC=$P(LA,U,3),$P(^ONCO(160,DA(1),1),U,6)=LC G EX
	;
KLC	;KILL LAST FOLLOW-UP CONTACT
	Q:X=2!(X=9)  S XD0=$O(^ONCO(160,DA(1),"A","AC",0)) Q:XD0=""  S XD0=$O(^(XD0,0)),XD0=$O(^(XD0,0)) Q:DA'=XD0  S $P(^ONCO(160,DA(1),1),U,6)="" G EX
EX	;EXIT
	K XD0,LA,LC Q
