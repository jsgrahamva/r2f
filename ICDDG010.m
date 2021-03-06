ICDDG010	;KUM - DRG GROUPER PROCESSING BEGINS ;05/02/12 4:06pm
	;;18.0;DRG Grouper;**64,82**;Oct 20, 2000;Build 21
	;
	;GROUPING PROCESS BEGINS
	;
GROUP	;
	N ICDFOUND,ICDRGH,ICDNODOD,ICDPREQ
	S (ICDFOUND,ICDNODOD)=0
	D PRECOND I ICDRTC=4,ICDRG=999 G GLAST ; Handle PRE-CONDITIONS
	I 'ICDFOUND D VARIABLS^ICDDRGX2
	I 'ICDFOUND D MDCSPROC ; PROCESSING FOR MDC5, MDC19, MDC23, MDC14, MDC20, MDC22, MDC15
	;MDCSPROC may have found a DRG group but still needs to Do DODRG to apply CC/MCC rules, so ICDFOUND=1 and ICDNODOD=0
	D NEONATE ; Handle Neonatal Processing
	;NEONATE may have found an actual DRG and does not need to Do DODRG to apply CC/MCC rules, so ICDFOUND=1 and ICDNODOD=1
	I 'ICDFOUND D SURGICAL ; Apply Surgical Hierarchy
	I 'ICDFOUND D DEFAULT ; Default Processing
	                               ; MDC24 PROCESSING
	                               ; MDC25 PROCESSING
	                               ; PREMDC PROCESSING
	                               ; MDC4 PROCESSING
	D END
GLAST	;
	S ICDDRG=ICDRG
	D KILL^ICDDRG
	S:+$G(ICDRG)'>0 ICDRG=999
	Q
	;
PRECOND	  ; PRE - CONDITIONS
	I $D(ICDSEX(1))&($D(ICDSEX(2))) S ICDRTC=4,ICDRG=999
	Q
	;
MDCSPROC	 ; Processing for MDCs 5, 19, 23, 14, 20, 22 and 15
	N ICDMDCL
	S ICDMDCL="/14/15/17/18/19/20/23/"[("/"_ICDMDC_"/")
	I 'ICDMDCL D:ICDOPCT<2  I "^983^986^989^"[(U_ICDRG_U) S ICDFOUND=1 Q
	. I $D(ICDF) Q
	. I $D(ICD10PD("M")),'$D(ICD10OR("y")) S ICDOPCT=0 Q
	. I $D(ICD10OR("O")),ICDNOR=ICDONR,ICDNOR>0,'$D(ICDPDRG(769)),'$D(ICD10ORNI("p")) S ICDRG=$S($D(ICD10ORNI("O")):983,$D(ICD10ORNI("y")):986,$D(ICD10ORNI("z")):989,1:983),ICDFOUND=1 Q
	. I ICDOPNR S ICDRG=$S($D(ICD10ORNI("y")):986,1:983),ICDOPNR=0,ICDFOUND=1 Q
	;
	;if number of non-extensive ORs eqs # OR, 477
	;
	I 'ICDMDCL,'$D(ICD10ORNI("y"))&($D(ICD10ORNI))&($D(ICD10ORNI("z"))) D  I ICDRG=989 S ICDFOUND=1 Q
	. I $D(ICDF) Q
	. NEW K  S K=$$ORNI(ICDORNI) I K=ICDOPCT S ICDRG=989,ICDFOUND=1 Q
	;
	;if number of non-extensive ORs+prostatics eqs # OR, 476
	;
	I 'ICDMDCL,$D(ICD10ORNI("y"))&($D(ICDORNI)) D  I ICDRG=986 S ICDFOUND=1 Q
	. N K S K=$$ORNI(ICDORNI) I K=ICDOPCT&(ICDNOR=ICDONR)  S ICDRG=986 S ICDFOUND=1 Q
	I 'ICDMDCL,ICDNOR=ICDONR&(ICDOPCT>0) S ICDRG=983,ICDFOUND=1 Q
	I ICDMDC=5,'$D(ICD10OR("O")) S ICDRTC=$S(ICDEXP="":5,1:"") S:ICDRTC'="" ICDRG=999 D:ICDRTC="" MI Q
	I ICDMDC=19,ICDOCNT>0,$D(ICD10OR("O"))  S (ICDRG,ICDRGH)=876,ICDFOUND=1 Q
	I ICDMDC=23,$D(ICD10OR("O"))!($D(ICD10ORNI("O")))  S ICDRG=941,ICDFOUND=1 Q
	;I ICDMDC=14 D ^ICDDRG14 I ICDRG]"" S ICDFOUND=1 Q
	I ICDMDC=20 S ICDRTC=$S(ICDDMS="":7,1:"") I ICDDMS'=0 S ICDRG=$S(ICDDMS="":999,1:894),ICDFOUND=1 Q
	I ICDMDC=22 S ICDRTC=$S(ICDTRS="":6,1:"") S:ICDRTC'="" ICDRG=999,ICDFOUND=1 D:ICDRTC="" CKBURN
	;I ICDMDC=15 S ICDRTC=$S(ICDEXP="":5,ICDTRS="":6,1:"") I ICDTRS'=0 S ICDRG=$S(ICDRTC'="":999,1:789),ICDFOUND=1 Q
	;
	Q
NEONATE	  ; Neonatal Processing
	N ICDOLD
	S ICDOLD=29,X1=$S($G(DGADM):$G(DGADM),1:DT),X2=$G(DOB) I X1,X2 D ^%DTC S ICDOLD=X
	I ICDOLD<29 S ICDMDC=15
	E  Q
	I ICDMDC=15 S ICDRTC=$S(ICDEXP="":5,ICDTRS="":6,1:"") I +ICDTRS'=0 D  S (ICDFOUND,ICDNODOD)=1 Q
	. S ICDRG=$S(ICDRTC'="":999,1:789) ;Transferred to another acute care facility
	I ICDMDC'=15 Q
	I ICDEXP S ICDRG=789,(ICDFOUND,ICDNODOD)=1 Q
	;If no Procedure Codes entered or no DRGs found for Procedure Codes that were entered:
	I 'ICDNOR!('$D(ICDODRG)) S ICDRG=$O(ICDPDRG(0)) X "I ICDMDC=15,$D(ICDSDRG),$O(ICDSDRG(0))<ICDRG D NEONATF^ICDDRG0" D  Q
	. N X,X1,X2,%
	. I ICDOLD<29 D NBCOMP Q
	. I ICDRG<789!(ICDRG>795) Q
	. I $O(ICDRG(795)) S ICDRG=$O(ICDRG(795)),(ICDFOUND,ICDNODOD)=1 Q
	. I 'ICDRG S ICDRG=999,ICDRTC=8
	I AGE="",ICDMDC=3 S ICDRTC=3 S ICDRG=999,(ICDFOUND,ICDNODOD)=1 Q
	S ICDDRG=ICDRG,(ICDFOUND,ICDNODOD)=1
	Q
	;
NEONATF	;NEONATE - Continuation of xecute line
	S ICDRG=$S($D(ICDPDRG(795)):795,$D(ICDPDRG(791)):791,1:$O(ICDSDRG(0)))
	Q
	;
NBCOMP	; check for complication related to Newborn
	N ICDSDXCK,ICDN,ICDX,ICDPREM,ICDMJR,ICDIMM,ICDSIG
	;Check for Premature and Major Problem in PDX or SDX
	;ICDPREM 1=PREMATURE (ID="p")  ICDIMM 1=EXTREME IMMATURE (ID="E")  ICDMJR 1=MAJORPROBLEMS (ID="J")
	S (ICDN,ICDPREM,ICDIMM,ICDMJR,ICDSIG)=0 F  S ICDN=$O(ICDDX(ICDN)) Q:'ICDN  D
	.S:$D(ICD10PD("p"))!($D(ICD10SD("p"))) ICDPREM=1 S:$D(ICD10PD("J"))!($D(ICD10SD("J"))) ICDMJR=1
	.S:$D(ICD10PD("E"))!($D(ICD10SD("E"))) ICDIMM=1 S:$D(ICD10PD("S"))!($D(ICD10SD("S"))) ICDSIG=1
	I ICDSIG S ICDRG=794,(ICDFOUND,ICDNODOD)=1 Q
	I ICDIMM S ICDRG=790,(ICDFOUND,ICDNODOD)=1 Q
	I ICDPREM=1 S:ICDMJR ICDRG=791,(ICDFOUND,ICDNODOD)=1 S:'ICDMJR ICDRG=792,(ICDFOUND,ICDNODOD)=1 Q
	I 'ICDPREM S:ICDMJR ICDRG=793,(ICDFOUND,ICDNODOD)=1 S:'ICDMJR ICDRG=795,(ICDFOUND,ICDNODOD)=1 Q
	Q
	;
SURGICAL	; Apply Surgical Hierarchy
	N ICDJ,ICDSTOP,ICDDGIEN,ICDDRGT,ICDMIEN
	S ICDDRG=0,ICDSTOP=0,ICDDA=$O(^ICDRS("B",ICDDATE_".1"),-1) I 'ICDDA Q
	S ICDIEN=$O(^ICDRS("B",ICDDA,"")) I 'ICDIEN Q
	S ICDMIEN=$O(^ICDRS(ICDIEN,1,"B",ICDMDC,"")) I 'ICDMIEN Q
	F ICDJ=0:0 S ICDJ=$O(^ICDRS(ICDIEN,1,ICDMIEN,2,"C",ICDJ)) Q:ICDJ'>0!(ICDSTOP)  S ICDDGIEN=$O(^ICDRS(ICDIEN,1,ICDMIEN,2,"C",ICDJ,"")) I ICDDGIEN D
	. S ICDDRGT=$P(^ICDRS(ICDIEN,1,ICDMIEN,2,ICDDGIEN,0),U,1) I $D(ICDODRG(ICDDRGT)) D
	. . S ICDCCT=$$ICDRGCC(ICDDRGT,ICDDATE) I ICDCCT=ICDCC S ICDRG=ICDDRGT,ICDSTOP=1 Q
	Q
	;
ICDRGCC(DRG,CDT)	;Get CC/MCC flag from DRG
	; 
	; Input:
	;   DRG  DRG Number
	;   CDT                Effective Date
	;
	; Output: CC/MCC Flag 0-3
	;
	N ICDCC,ICDIEN,ICDDA,ICDAIEN
	S ICDCC=0,ICDIEN=$O(^ICD("B","DRG"_DRG,"")) I ICDIEN D
	. S ICDDA=$O(^ICD(ICDIEN,2,"B",(CDT_".1")),-1) I ICDDA D
	. . S ICDAIEN=$O(^ICD(ICDIEN,2,"B",ICDDA,"")) I ICDAIEN D
	. . . S ICDCC=$P(^ICD(ICDIEN,2,ICDAIEN,0),U,4)
	Q ICDCC
	;
DEFAULT	G:ICDMDC=15 GETMOR S (ICDRG,ICDRGH)=$O(ICDODRG(0)) G:ICDRG'>0 ENTER
	D DODRG
	G:ICDRG'>0 AGAIN
	Q
ENTER	I 'ICDNOR,ICDORNR'=0,ICDMDC'=20,ICDMDC'=15 S ICDRG=983
GETMOR	S (ICDRG,ICDRGH)=$O(ICDPDRG(0)) S:ICDRG'>0 (ICDRG,ICDRGH)=998
CKDRG	D DODRG
	Q
	;I ICDRG="" K ICDPDRG(ICDRGH) G GETMOR
DODRG	;Go to DRG file and retrieve table entry to use if defined
	Q:ICDNODOD=1  ;Actual DRG was found prior Ex: Neonate
	N ICDMCV,ICDMCV1,ICDMCV2
	N DRGFY,ICDREF S (DRGFY,ICDREF)=""
	I ICDRG S DRGFY=$O(^ICD(ICDRG,2,"B",$P(+$G(ICDDATE),".")_.01),-1)
	I 'DRGFY S DRGFY=ICDDATE ;default to current fiscal year
	S ICDREF=$O(^ICD(+ICDRG,2,"B",+DRGFY,ICDREF))
	I ICDREF'="" D
	. S ICDREF=$P($G(^ICD(+ICDRG,2,ICDREF,0)),U,3)
	. S ICDREF="DRG"_ICDRG_"^"_ICDREF D @ICDREF K ICDREF
	Q
ORNI(X)	;
	N I,K
	S K=0 F I=1:1:$L(ICDORNI) I $E(ICDORNI,I,I)="z"!($E(ICDORNI,I,I)="y") S K=K+1
	Q K
END	;
	; - MDC24 PROCESSING
	; - MDC25 PROCESSING
	; - PREMDC PROCESSING
	; - MDC4 PROCESSING
	; - CHECK FOR MCC/CC
	;
	;MDC24 PROCESSING
	D:ICDP24'=""!($D(ICDS24)) CKMST^ICDDRGX1 S ICDDRG=ICDRG
	I ICDRG=976!(ICDRG=977)!(ICDRG=24&($G(ICDOR)="")) S ICDRG=$P($G(ICDPDRG),U,2) I ICDRG=24 S ICDRG=99
	;MDC25 PROCESSING
	D:$G(ICDP25)=1!(($G(ICDP25)>1)&($D(ICDS25(1)))) CKHIV^ICDDRGX1 S ICDDRG=ICDRG
	;PRE-MDC PROCESSING
	;I $D(ICDNMDC(1)) I ICDNMDC(1)="" D CKNMDC^ICDDRGX1 S ICDDRG=ICDRG K ICDNMDC
	S ICDPREQ=0 D PREMDC
	Q:ICDPREQ
	;PREMDC may have found an actual DRG and does not need to Do DODRG to apply CC/MCC rules, so ICDFOUND=1 and ICDNODOD=1
	;MDC4 PROCESSING
	I ICDRG=983 D CHKMDC4^ICDDRGX1
	; CHECK FOR MCC/CC
	D:'ICDNODOD DODRG ;check for MCC/CC
	S:ICDRTC="" ICDRTC=0
	S ICDTMP=$$DRG^ICDGTDRG(ICDRG,ICDDATE) I '$P(ICDTMP,U,14) S ICDRG=999
	Q
	G KILL^ICDDRG
AGAIN	G:'$D(ICDODRG) ENTER
	K ICDODRG(ICDRGH) I $O(ICDODRG(ICDRGH))'>0 K ICDODRG Q
	S ICDRG=$O(ICDODRG(ICDRGH))
	Q
	;
CKBURN	; MDC22 - Burns (extensive, full thickness, or non-extensive)
	D
	. I $D(ICD10PD("*"))!($D(ICD10SD("*"))) S ICDRG=$S($D(ICD10OR("k")):927,1:933) Q
	. I $D(ICD10PD("b"))!($D(ICD10SD("b"))) D FTBURN Q
	.  S ICDRG=$S(ICDCC!($D(ICD10PD("T")))!($D(ICD10SD("T"))):935,1:935)
	Q
	; FTBURN ; full thickness burn check
	I $D(ICD10SD("j"))!($D(ICD10OR("k"))) D
	. I ICDCC!($D(ICD10PD("T")))!($D(ICD10SD("T")))  S ICDRG=928
	. E  S ICDRG=929
	E  D
	. I ICDCC!($D(ICD10PD("T")))!($D(ICD10SD("T")))  S ICDRG=934
	. E  S ICDRG=934
	Q
	;
FTBURN	; full thickness burn check
	I $D(ICD10SD("j"))!($D(ICD10OR("k"))) D
	. I ICDCC!($D(ICD10PD("T")))!($D(ICD10SD("T"))) S ICDRG=928
	. E  S ICDRG=929
	E  D
	. I ICDCC!($D(ICD10PD("T")))!($D(ICD10SD("T"))) S ICDRG=934
	. E  S ICDRG=934
	Q
	;
MI	;
	; if PTCA and not a bypass
	I $D(ICD10OR("1"))!($D(ICDOP(" 37.90"))) I '$D(ICD10OR("b"))&('$D(ICD10OR("6"))) D CMS516^ICDTBL2 Q
	I $D(ICDPD("A")) D EN1^ICDDRG5 I ICDCC3 S ICDRG=$O(ICDODRG(0)) D DODRG Q
	I ($D(ICD10PD("A"))&($D(ICD10PD("I"))))!($D(ICD10SD("A"))&($D(ICD10SD("I")))) D  Q
	. S ICDRG=$S($S($D(ICDEXP):ICDEXP,1:0):285,$D(ICD10PD("V"))!($D(ICD10SD("V"))):280,1:282)
	I $D(ICDOP(" 37.26"))&($D(ICDOP(" 39.61"))) S ICDRG=230 Q
	I $D(ICD10OR("H"))  S ICDRG=$S($D(ICD10PD("X"))!($D(ICD10SD("X"))):286,1:287) Q
	K ICDPDRG(286),ICDPDRG(287)
	I $D(ICD10OR("p")) S ICDRG=$O(ICDODRG(0)) D DODRG Q
	I $D(ICD10OR("F")) S ICDRG=$O(ICDODRG(0)) D DODRG Q
	E  K ICDPDRG(280),ICDPDRG(281),ICDPDRG(282) S ICDRG=$O(ICDPDRG(0)) D DODRG Q
	Q
	;
PREMDC	; Check if any Surgical Procedure Code in Pre-MDC and, if so, use that DRG group
	N ICDTMP,ICDPC,ICDX,ICDI,ICDCCT,ICDRGT
	S ICDPC="",ICDRGT=999 F  S ICDPC=$O(ICDPRC(ICDPC)) Q:ICDPC=""  I $D(ICD10OR(80)) S ICDTMP=$$GETDRG^ICDEX(80.1,ICDPRC(ICDPC),ICDDATE,98) D
	. I $P(ICDTMP,";",1)'=-1 S ICDX=$P(ICDTMP,";",1) F ICDI=1:1 Q:$P(ICDX,U,ICDI)=""  D
	. . S ICDCCT=$$ICDRGCC^ICDRGAPI($P(ICDX,U,ICDI),ICDDATE) I ICDCCT=ICDMCC!(ICDCCT=3&(ICDMCC=1!(ICDMCC=2))) S:$P(ICDX,U,1)<ICDRGT ICDRGT=$P(ICDX,U,ICDI) Q
	D
	. I $D(ICD10OR("q")) S ICDRGT=$S(ICDMCC=2:1,1:2) Q  ;Heart Transplant
	. I $D(ICD10OR("r")) S ICDRGT=7 Q  ;Lung Transplant
	. I $D(ICD10OR(245)) S ICDRGT=8 Q  ;Simultaneous Pancreas/Kidney Transplant
	. I $D(ICD10OR(116)) S ICDRGT=10 Q  ;Pancreas Transplant
	. ;Next Block for DRGs 3 and 4: PreMDC ECMO/Tracheostomy/MV96+/Major OR/PDX Except Face,Mount not DRG11,12 or 13
	. I $D(ICD10OR(44)) S ICDRGT=3 Q  ;ECMO
	. I $D(ICD10OR(150)) S ICDRGT=$S($D(ICD10OR(81)):3,1:4) Q  ;Tracheostomy
	. ;End of ECMO etc..
	. I ($D(ICD10OR(68))&(ICDMCC=2))!($D(ICD10OR(59))) S ICDRGT=5 Q  ;(Liver Transplant w/MCC) OR (Intestinal Implant)
	. I $D(ICD10OR(68)),ICDMCC=0 S ICDRGT=6 Q  ;Intestinal implant
	. I $D(ICD10OR(151))!($D(ICD10OR(66))) S ICDRGT=$S(ICDMCC=2:11,ICDMCC=1:12,1:13) Q  ;151=Tracheostomy for Face, Mouth and Neck Diagnoses  66=Laryngectomy
	. I $D(ICD10OR(14)) S ICDRGT=14 Q  ;Allogeneic Bone Marrow Transplant
	. I $D(ICD10OR(22)) S ICDRGT=$S(ICDMCC>0:16,1:17) Q  ;Autologous Bone Marrow Transplant
	I ICDRGT'=999 S ICDRG=ICDRGT,(ICDFOUND,ICDNODOD,ICDPREQ)=1
	Q
	;
PDX11T13()	;Is PDX assigned to DRG 11, 12 or 12
	I $D(ICDPDRG(11))!($D(ICD10PDRG(12)))!($D(ICD10PDRG(13))) Q 1
	Q 0
	;
