ONCOU55	;Hines OIFO/GWB - Utility routine # 1 ;06/23/10
	;;2.2;ONCOLOGY;**1**;Jul 31, 2013;Build 8
	;
LTS(DA,NOTTHIS)	;Sets LAST TUMOR STATUS field (165.5,95)
	;Called by AC cross-reference of CANCER STATUS (165.573,.02)
	;NOTTHIS is defined by CANCER STATUS (165.573,.02) KILL logic
	;If the latest CANCER STATUSis deleted, LAST TUMOR STATUS is updated
	;with the next most recent CANCER STATUS. 
	N OX,DIE,DR,NTS,OTS
	S NTS=""
	S OX=$$TSLAST(DA,+$G(NOTTHIS))
	S:OX NTS=$P($G(^ONCO(165.5,DA,"TS",OX,0)),U,2)
	S OTS=$P($G(^ONCO(165.5,DA,7)),U,6)
	S $P(^ONCO(165.5,DA,7),U,6)=NTS
	K:$L(OTS) ^ONCO(165.5,"ACS",OTS,DA)
	S:$L(NTS) ^ONCO(165.5,"ACS",NTS,DA)=""
	Q
	;
TSLAST(DA,NOTTHIS)	;Get last TUMOR STATUS DATE (165.573,.01)
	N IEN
	S IEN=$O(^ONCO(165.5,DA,"TS","AA",""))
	I IEN,$D(NOTTHIS),$D(^ONCO(165.5,DA,"TS","AA",IEN,NOTTHIS)) S IEN=$O(^ONCO(165.5,DA,"TS","AA",IEN))
	S:IEN IEN=$O(^ONCO(165.5,DA,"TS","AA",IEN,""))
	Q IEN
	;
SETTS(IEN,FOLDATE)	;Set TUMOR STATUS (165.5,73)
	;Called by FINDSET^ONCOAIS
	N DA,DO,DIC,PREVENT,PREVTS,SUBENT,TOFR,X,Y
	S TOFR=$$GET1^DIQ(165.5,IEN,71)
	S PREVTS=""
	S PREVENT=$O(^ONCO(165.5,IEN,"TS","AA",9999999-FOLDATE))
	I PREVENT D
	.I TOFR'="Never disease-free" D
	..S PREVENT=$O(^ONCO(165.5,IEN,"TS","AA",PREVENT,0))
	..S PREVTS=$P($G(^ONCO(165.5,IEN,"TS",PREVENT,0)),U,2)
	K DO,DIC
	S DA(1)=IEN,DIC="^ONCO(165.5,DA(1),""TS"","
	S DIC(0)="L",X=FOLDATE
	S DIC("DR")=".02////^S X=PREVTS"
	D FILE^DICN
	S SUBENT=+Y
	D LTS(IEN)
	Q SUBENT
	;
TNMED(IEN)	;AJCC Cancer Staging Manual Edition
	N CSG,PSG,TNMED,TNMMO,TOP,YR
	S YR=$E($P($G(^ONCO(165.5,IEN,0)),U,16),1,3)
	S TNMED=$S(YR<283:1,YR<288:2,YR<292:3,YR<298:4,YR<303:5,YR<310:6,1:7)
	I $$LYMPHOMA^ONCFUNC(IEN) G TNMEX
	S TNMMO=$$HIST^ONCFUNC(IEN),TNMMO=$E(TNMMO,1,4)
	S TOP=$P($G(^ONCO(165.5,IEN,2)),U,1)
	I YR>295!($$LEUKEMIA^ONCOAIP2(IEN)) D
	.S CSG=$P($G(^ONCO(165.5,IEN,2)),U,20)
	.S PSG=$P($G(^ONCO(165.5,IEN,2.1)),U,4)
	.I (CSG=88)&(PSG=88) S TNMED=88
	I TNMED=5 D
	.I (TNMMO>9730)&(TNMMO<9990) S TNMED=88 Q
	.I TNMMO=9140 S TNMED=88 Q
	.I (TOP=67173)!(TOP=67254)!(TOP=67260)!(TOP=67268)!(TOP=67269)!(TOP=67300)!(TOP=67301)!(TOP=67312)!(TOP=67313)!(TOP=67318)!(TOP=67319)!(TOP=67339)!(TOP=67379)!(TOP=67390)!(TOP=67398)!(TOP=67399)!(TOP=67420)!(TOP=67421) S TNMED=88 Q
	.I (TOP=67422)!(TOP=67423)!(TOP=67424)!(TOP=67571)!(TOP=67572)!(TOP=67573)!(TOP=67574)!(TOP=67577)!(TOP=67578)!(TOP=67579)!(TOP=67630)!(TOP=67631)!(TOP=67637)!(TOP=67638)!(TOP=67639)!(TOP=67691)!(TOP=67699)!(TOP=67700) S TNMED=88 Q
	.I (TOP=67701)!(TOP=67709)!(TOP=67710)!(TOP=67711)!(TOP=67712)!(TOP=67713)!(TOP=67714)!(TOP=67715)!(TOP=67716)!(TOP=67717)!(TOP=67718)!(TOP=67719)!(TOP=67720)!(TOP=67721)!(TOP=67722)!(TOP=67723)!(TOP=67724)!(TOP=67725) S TNMED=88 Q
	.I (TOP=67728)!(TOP=67729)!(TOP=67750)!(TOP=67751)!(TOP=67752)!(TOP=67753)!(TOP=67754)!(TOP=67755)!(TOP=67758)!(TOP=67759)!(TOP=67760)!(TOP=67761)!(TOP=67762)!(TOP=67763)!(TOP=67764) S TNMED=88 Q
	.I (TOP=67765)!(TOP=67767)!(TOP=67768)!(TOP=67809) S TNMED=88 Q
	I TNMED>5 D
	.I TNMED<7,(TOP=67740)!(TOP=67741)!(TOP=67749) S TNMED=88 Q
	.I YR>311,$E(TOP,3,4)=77,TNMMO=9823 Q  ;SEER 2012 Hematopoitic (Pg 54)
	.I (TNMMO>9730)&(TNMMO<9990) S TNMED=88 Q
	.I TNMMO=9140 S TNMED=88 Q
	.I (TOP=67173)!(TOP=67254)!(TOP=67260)!(TOP=67268)!(TOP=67269)!(TOP=67301)!(TOP=67312)!(TOP=67313)!(TOP=67318)!(TOP=67319)!(TOP=67339)!(TOP=67379)!(TOP=67390) S TNMED=88 Q
	.I (TOP=67398)!(TOP=67399)!(TOP=67420)!(TOP=67421)!(TOP=67422)!(TOP=67423)!(TOP=67424)!(TOP=67571)!(TOP=67572)!(TOP=67573)!(TOP=67574)!(TOP=67577)!(TOP=67578)!(TOP=67579) S TNMED=88 Q
	.I (TOP=67630)!(TOP=67631)!(TOP=67637)!(TOP=67638)!(TOP=67639)!(TOP=67681)!(TOP=67688)!(TOP=67689)!(TOP=67691)!(TOP=67699)!(TOP=67701)!(TOP=67709)!(TOP=67710) S TNMED=88 Q
	.I (TOP=67750)!(TOP=67754)!(TOP=67755)!(TOP=67758)!(TOP=67759)!(TOP=67760)!(TOP=67761)!(TOP=67762)!(TOP=67763)!(TOP=67764)!(TOP=67765)!(TOP=67767)!(TOP=67768)!(TOP=67809) S TNMED=88 Q
TNMEX	Q TNMED
	;
MELANOMA(IEN)	;Melanoma
	N XX
	S XX=$$HIST^ONCFUNC(IEN)
	Q (XX'<87200)&(XX<87910)
	;
GTT(D0)	;Gestational Trophoblastic Tumors - 5th, 6th and 7th editions
	;
	N HIST,HIST14,TNMED,TOP
	S TNMED=$$TNMED^ONCOU55(D0)
	S TOP=$P($G(^ONCO(165.5,D0,2)),U,1)
	S HIST=$$HIST^ONCFUNC(D0)
	S HIST14=$E(HIST,1,4)
	Q (TNMED>4)&(TOP=67589)&((HIST14>9099)&(HIST14<9106))
	;
T(D0)	;Testis - 5th, 6th and 7th editions
	N TNMED,TOP
	S TNMED=$$TNMED^ONCOU55(D0)
	S TOP=$P($G(^ONCO(165.5,D0,2)),U,1)
	Q (TNMED>4)&((TOP=67620)!(TOP=67621)!(TOP=67629))
	;
EDITION(IEN)	;SEER Extent of Disease Edition
	Q $S($$DATEDX(IEN)>2980000:3,$$DATEDX(IEN)>2920000:2,1:1)
	;
DATEDX(IEN)	;DATE DX (165.5,3)
	Q $P($G(^ONCO(165.5,IEN,0)),U,16)
	;
MYCOSIS(IEN)	;MYCOSIS FUNGOIDES
	N XX
	S XX=$$HIST^ONCFUNC(IEN)
	Q ((XX=97002)!(XX=97003))
	;
NOSTAGE(IEN)	;AUTOMATIC STAGING OVERRIDDEN (165.5,37.9)
	Q $P($G(^ONCO(165.5,D0,24)),U)
	;
TMARKER	;TUMOR MARKER 1 (165.5,25.1)
	;TUMOR MARKER 2 (165.5,25.2)
	;TUMOR MARKER 3 (165.5,25.3)
	N TOP
	S (TM1,TM2,TM3)=0
	S TOP=$P($G(^ONCO(165.5,D0,2)),U,1)
	I TOP'="" S TOP=$P($G(^ONCO(164,TOP,0)),U,2)
	I $E(TOP,2,3)=50 S (TM1,TM2)=1 Q
	I $E(TOP,2,3)=18 S TM1=1 Q
	I $E(TOP,2,3)=19 S TM1=1 Q
	I $E(TOP,2,3)=20 S TM1=1 Q
	I $E(TOP,2,3)=22 S TM1=1 Q
	I $E(TOP,2,3)=56 S TM1=1 Q
	I $E(TOP,2,3)=61 S (TM1,TM2)=1 Q
	I $E(TOP,2,3)=62 S (TM1,TM2,TM3)=1 Q
	I $$HIST^ONCFUNC(D0)=95003 S TM1=1 Q
	Q
	;
CLEANUP	;Cleanup
	K TM1,TM2,TM3