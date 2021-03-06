PSOHLSG1	;BIR/LC - Build HL7 Segments ; 11/4/04 2:56pm
	;;7.0;OUTPATIENT PHARMACY;**10,26,30,56,70,139,152,385**;DEC 1997;Build 27
	;HLFNC supp. by DBIA 10106
	;PSNAPIS supp. by DBIA 2531
	;VASITE supp. by DBIA 10112
	;VADPT supp. by DBIA 10061
	;EN^DIQ1 supp. by DBIA 10015
	;EN^VAFHLPID supp. by DBIA 263
	;EN^VAFHLZTA supp. by DBIA 758
	;PSDRUG supp. by DBIA 221
	;PS(50.7 supp. by DBIA 2223
	;PS(50.606 supp. by DBIA 2174
	;PSNDF(50.6 supp. by DBIA 2195
	;PS(51.2 supp. by DBIA 2226
	;PS(55 supp. by DBIA 2228
	;PS(50.607 supp. by DBIA 2221
	;DIC(5 supp. by DBIA 10056
	;DPT supp. by DBIA 3097
	;SC supp. by DBIA 10040
	;VA(200 supp. by DBIA 10060
START	;
	D PID(.PSI),ORC(.PSI),RXE(.PSI),NTE(.PSI),RXR(.PSI),ZRL(.PSI)
	D ZAL^PSOHLSG2(.PSI),ZML^PSOHLSG2(.PSI),ZSL^PSOHLSG2(.PSI)
	Q
PID(PSI)	;patient ID segment
	Q:'$D(DFN)!$D(PAS)
	S HLFS=HL1("FS"),HLECH=HL1("ECH"),HLQ=HL1("Q"),HLVER=HL1("VER")
	N X1,X2,D1,D2
	S X1=$$EN^VAFHLPID(DFN,"3,5,8,11,13,19,",1)
	S X2=$$EN^VAFHLZTA(DFN,"2,3,4,5,6,7,",1)
	;if temp. address is active then use it
	I $P(X2,HLFS,3) D
	.S:$P(X2,HLFS,4) D1=$$FMDATE^HLFNC($P(X2,HLFS,4))
	.S:$P(X2,HLFS,5) D2=$$FMDATE^HLFNC($P(X2,HLFS,5))
	.I $G(D1),$G(D2),(DT'<D1&(DT'>D2)) D
	..S:$P(X2,HLFS,6)]"" $P(X1,HLFS,12)=$P(X2,HLFS,6),$P(X1,HLFS,14)=$P(X2,HLFS,8)
	S ^TMP("PSO",$J,PSI)=$E(X1,1,245)
	S PSI=PSI+1,PAS=1
	Q
ORC(PSI)	;common order segment
	Q:'$D(DFN)
	N ORC
	S:$G(FP)="F"&('$G(FPN)) FDT=$P(^PSRX(IRXN,2),"^",2),EXDT=$S($P(^(2),"^",6):$P(^(2),"^",6),1:"")
	S:$G(FP)="F"&('$G(FPN)) EBY=$P(^PSRX(IRXN,0),"^",16),PVDR=$P(^(0),"^",4),EFDT=$P(^(2),"^",2)
	S:$G(FP)="F"&($G(FPN)) FDT=$P(^PSRX(IRXN,1,FPN,0),"^"),EXDT=$S($P(^(0),"^",15):$P(^(0),"^",15),1:"")
	S:$G(FP)="F"&($G(FPN)) EBY=$S($P(^PSRX(IRXN,1,FPN,0),"^",5):$P(^(0),"^",5),1:$P(^(0),"^",7)),PVDR=$P(^(0),"^",17),EFDT=$P(^(0),"^",8)
	S:$G(FP)="P" FDT=$P(^PSRX(IRXN,"P",FPN,0),"^"),PVDR=$P(^(0),"^",17),EXDT=$S($P(^PSRX(IRXN,2),"^",6):$P(^(2),"^",6),1:"")
	S:$G(FP)="P" EBY=$S($P(^PSRX(IRXN,"P",FPN,0),"^",5):$P(^(0),"^",5),1:$P(^(0),"^",7)),PVDR=$P(^(0),"^",17),EFDT=$P(^(0),"^",8)
	S EBY1=$P(^VA(200,EBY,0),"^"),PVDR1=$P(^VA(200,PVDR,0),"^")
	S FDT=$$HLDATE^HLFNC(FDT,"DT") S:$G(EXDT) EXDT=$$HLDATE^HLFNC(EXDT,"DT"),EFDT=$$HLDATE^HLFNC(EFDT,"DT")
	S EBY1=$$HLNAME^HLFNC(EBY1),PVDR1=$$HLNAME^HLFNC(PVDR1)
	S ORC="ORC"_FS_"NW"_FS_IRXN_CS_"OP7.0"_FS_FS_FS_FS_FS_CS_CS_CS
	S ORC=ORC_FDT_CS_EXDT_FS_FS_FS_EBY_CS_EBY1_FS_FS
	S ORC=ORC_PVDR_CS_PVDR1_FS_FS_FS_EFDT_FS_CS_CS_CS_CS_"NEW"_FS_FS_FS_FS_FS_$S($$STATUS^PSOBPSUT(IRXN,$G(RXFL(IRXN)))]"":"VA5",1:"")
	S ^TMP("PSO",$J,PSI)=ORC
	S PSI=PSI+1
	K EBY,EBY1,EFDT,EXDT,FDT,PVDR,PVDR1
	Q
RXE(PSI)	;pharmacy encoded order segment
	Q:'$D(DFN)
	N RXE
	S PSND1=$P($G(^PSDRUG(IDGN,"ND")),"^"),PSND2=$P($G(^("ND")),"^",2),PSND3=$P($G(^("ND")),"^",3)
	K PSOXN,PSOXN2
	I PSND1,PSND3 D
	.I $T(^PSNAPIS)]"" S PSOXN=$$DFSU^PSNAPIS(PSND1,PSND3),UNIT=$P($G(PSOXN),"^",6) S PSOXN=$P($G(PSOXN),"^",5) S PSOXN2=$$PROD2^PSNAPIS(PSND1,PSND3) Q
	.S PSOXN2=$G(^PSNDF(PSND1,5,PSND3,2))
	.S PRODUCT=$G(^PSNDF(PSND1,5,PSND3,0))
	.I $G(PRODUCT)'="" S PSOXN=+$P($G(^PSNDF(PSND1,2,+$P(PRODUCT,"^",2),3,+$P(PRODUCT,"^",3),4,+$P(PRODUCT,"^",4),0)),"^"),UNIT=$P($G(^PS(50.607,PSOXN,0)),"^")
	S RXE="RXE"_FS_""""""_FS_$S($P($G(^PSDRUG(IDGN,"ND")),"^",10)'="":$P(^("ND"),"^",10),($G(PSND1)&$G(PSND3)):$P($G(PSOXN2),"^",2),1:"""""")_CS_PSND2_CS_"PSNDF"
	S RXE=RXE_CS_PSND1_"."_PSND3_"."_$G(IDGN)_CS_$P($G(^PSDRUG(IDGN,0)),"^")_CS_"99PSD"_FS_""""""_FS_FS
	I $G(PSOXN)="" S PSOXN=""""""
	S RXE=RXE_CS_CS_CS_PSOXN_CS_$S($G(UNIT)'="":$G(UNIT),1:"""""")_CS_"99PSU"_FS
	K PSOXN,PSOXN2
	S POIPTR=$P($G(^PSRX(IRXN,"OR1")),"^") I POIPTR S PODOSE=$P($G(^PS(50.7,POIPTR,0)),"^",2),PODOSENM=$G(^PS(50.606,PODOSE,0))
	I '$G(POIPTR) S PODOSE=$P($G(^PS(50.7,$P($G(^PSDRUG(IDGN,2)),"^"),0)),"^",2),PODOSENM=$G(^PS(50.606,PODOSE,0))
	;S RXE=RXE_CS_CS_CS_$S($G(PODOSE):PODOSE,1:"""""")_CS_$S($G(PODOSENM):PODOSENM,1:"""""")_CS_"99PSF"_FS_FS_FS_FS_FS_CS_$P(^PSDRUG(IDGN,660),"^",8)_FS
	S RXE=RXE_CS_CS_CS_PODOSE_CS_PODOSENM_CS_"99PSF"_FS_FS_FS_FS_FS_CS_$P($G(^PSDRUG(IDGN,660)),"^",8)_FS
	S:$G(FP)="F"&('$G(FPN)) VPHARMID=$P(^PSRX(IRXN,2),"^",3)
	S:$G(FP)="F"&($G(FPN)) VPHARMID=$S($P(^PSRX(IRXN,1,FPN,0),"^",5)'="":$P(^(0),"^",5),1:$P(^PSRX(IRXN,2),"^",3))
	S:$G(FP)="P" VPHARMID=$S($P(^PSRX(IRXN,"P",FPN,0),"^",5)'="":$P(^(0),"^",5),1:$P(^PSRX(IRXN,2),"^",3))
	I '$G(VPHARMID) S VPHARMID="""""",VPHARM=""""""
	I $G(VPHARMID) S VPHARM=$P(^VA(200,VPHARMID,0),"^"),VPHARM=$$HLNAME^HLFNC(VPHARM)
	S NFLD=0,UU="" F  S UU=$O(^PSRX(IRXN,1,UU)) Q:UU=""  S:$D(^PSRX(IRXN,1,UU,0)) NFLD=NFLD+1
	S NRFL=$P(^PSRX(IRXN,0),"^",9),RFRM=(NRFL-NFLD),DISPDT=$P(^PSRX(IRXN,3),"^"),DISPDT=$$HLDATE^HLFNC(DISPDT,"DT")
	S RXE=RXE_NRFL_FS_FS_VPHARMID_CS_VPHARM_FS_$P(^PSRX(IRXN,0),"^")_FS_RFRM_FS_FS_DISPDT
	S ^TMP("PSO",$J,PSI)=RXE
	S PSI=PSI+1
	K PSND1,PSND2,PSND3,PRODUCT,UNIT,PODOSE,PODOSENM,POIPTR,VPHARMID,VPHARM,NRFL,DISPDT,UU
	Q
NTE(PSI)	;note segments
	;
	D NTE1^PSOHLSG2(.PSI)
	D NTE2^PSOHLSG2(.PSI)
	D NTE3^PSOHLSG2(.PSI)
	D NTE4^PSOHLSG2(.PSI)
	D NTE5^PSOHLSG2(.PSI)
	D NTE6^PSOHLSG2(.PSI)
	Q
RXR(PSI)	;pharmacy route segment
	Q:'$D(DFN)
	N RXR
	S (PSROUTE,RTNAME)=""""""
	F PSRTLP=0:0 S PSRTLP=$O(^PSRX(IRXN,"MEDR",PSRTLP)) Q:'PSRTLP  D
	.S PSROUTE=$P($G(^PSRX(IRXN,"MEDR",PSRTLP,0)),"^") I PSROUTE,$D(^PS(51.2,PSROUTE,0))  S RTNAME=$P(^PS(51.2,PSROUTE,0),"^")
	S RXR="RXR"_FS_CS_CS_CS_$G(PSROUTE)_CS_$G(RTNAME)_CS_"99PSR"
	S ^TMP("PSO",$J,PSI)=RXR
	S PSI=PSI+1
	K PSROUTE,RTNAME,PSRTLP
	Q
	;
ZRL(PSI)	;Rx label segment
	Q:'$D(DFN)!('$D(PSOSITE))
	N ZRL,ZRL1
	S SITE=$S($D(^PS(59,PSOSITE,0)):^(0),1:"")
	S ZRL="ZRL"_FS_$P(SITE,"^",6)_FS_$P(SITE,"^",2)_CS_$P(SITE,"^",7)_CS
	S ZRL=ZRL_$S($D(^DIC(5,+$P(SITE,"^",8),0)):$P(^(0),"^",2),1:"UKN")_CS
	S PSZIP=$P(SITE,"^",5) S PSOHZIP=$S(PSZIP["-":PSZIP,1:$E(PSZIP,1,5)_$S($E(PSZIP,6,9)]"":"-"_$E(PSZIP,6,9),1:""))
	S ZRL=ZRL_PSOHZIP_FS_$P(SITE,"^",3)_"-"_$P(SITE,"^",4)_FS
	S CLN=+$P(^PSRX(IRXN,0),"^",5),CLN1=$S($D(^SC(CLN,0)):$P(^(0),"^",2),1:"UNKNOWN")
	S CSINER=$S($P(^PSRX(IRXN,3),"^",3):$P(^(3),"^",3),1:"""""")
	S CSINER1=$S($G(CSINER):$P(^VA(200,CSINER,0),"^"),1:""""""),CSINER1=$$HLNAME^HLFNC(CSINER1)
	S ZRL=ZRL_CLN_CS_CLN1_CS_"99PSC"_FS_CSINER_CS_CSINER1_FS
	D 6^VADPT S ZRL=ZRL_$E($P(VADM(2),"^",2),5,11)_FS_$P(VADM(2),"^")_FS_$P($G(^PS(53,+$P($G(^PSRX(IRXN,0)),"^",3),0)),"^",2)_FS_$S($P($G(VAPA(10)),"^",2)]"":$P($G(VAPA(10)),"^",2),1:"""""")_FS
	S:$G(FP)="F"&('$G(FPN)) MW=$P(^PSRX(IRXN,0),"^",11),FDT=$P(^(2),"^",2),QTY=$P(^(0),"^",7),DASPLY=$P(^(0),"^",8)
	S:$G(FP)="F"&($G(FPN)) MW=$P(^PSRX(IRXN,1,FPN,0),"^",2),FDT=$P(^(0),"^"),QTY=$P(^(0),"^",4),DASPLY=$P(^(0),"^",10)
	S:$G(FP)="P" MW=$P(^PSRX(IRXN,"P",FPN,0),"^",2),FDT=$P(^(0),"^"),QTY=$P(^(0),"^",4),DASPLY=$P(^(0),"^",10)
	I MW="W" S MP=$S($G(^PSRX(IRXN,"MP")):$G(^("MP")),1:"""""")
	S X=$S($D(^PS(55,DFN,0)):^(0),1:""),CAP=$P(X,"^",2)
	S:MW="M" MP="""""",MW=$S($P(X,"^",3):"R",1:MW) S MW=$S(MW="M":"REGULAR MAIL",MW="R":"CERTIFIED MAIL",1:"""""")
	I (($P(^PSRX(IRXN,"STA"),"^")>0)&($P(^("STA"),"^")'=2)&('$G(PSODBQ)))!'$G(^PSRX(IRXN,"IB")) S COPAY="NO COPAY"
	E  S COPAY="COPAY"
	S ZRL=ZRL_MP_FS_COPAY_FS_$S($G(CAP):"NON-SAFETY",1:"SAFETY")_FS_$S($G(RFRM):"REFILLABLE",'$G(RFRM):"NON-REFILLABLE",1:"""""")_FS
	S ZRL=ZRL_$S($G(RFRM)>1:RFRM_" Refills remain prior to",$G(RFRM)=1:"Last fill prior to",1:"""""")_FS_$S($E(MW)="W":"""""",1:MW)_FS
	S NURSE=$S($P($G(^DPT(DFN,"NHC")),"^")="Y":1,$P($G(^PS(55,DFN,40)),"^"):1,1:0)
	S ZRL=ZRL_$S($G(NURSE):"Mfg______Exp______",1:"""""")_FS_$S($G(FP)="P":"PARTIAL",1:"""""")_FS
	S DATE=$$HLDATE^HLFNC(FDT) D NOW^%DTC S NOW=$$HLDATE^HLFNC(%,"TS")
	K DIC,DR,DIQ S DA=$P($$SITE^VASITE(),"^") I DA D
	.K PSOINST S DIC=4,DIQ(0)="I",DR=99,DIQ="PSOINST" D EN^DIQ1
	.S PSOINST=PSOINST(4,DA,99,"I") K DIC,DA,DR,DIQ,PSOINST(4)
	S DRUG=$$ZZ^PSOSUTL(IRXN),DEA=$P($G(^PSDRUG(+$P(^PSRX(IRXN,0),"^",6),0)),"^",3),WARN=$P($G(^(0)),"^",8)
	S ZRL=ZRL_NOW_FS_DATE_FS_$S($G(NFLD):NFLD,1:"""""")_FS_DASPLY_FS_PSOINST_"-"_IRXN_FS_$S($G(WARN)'="":"DRUG WARNING "_$G(WARN),1:"""""")_FS_QTY
	;COMPENSATE FOR $L(ZRL)>245
	I $L(ZRL)>245 S LTH=$E($L(ZRL)/245,1) S:$L(ZRL)#245>0 LTH=LTH+1 F WW=1:1:LTH D
	.S:WW=1 ST=1,EN=245 S:WW>1 ST=(ST+245),EN=(EN+245)
	.S ZRL1=$E(ZRL,ST,EN)
	.S:WW=1 ^TMP("PSO",$J,PSI)=ZRL1
	.S:WW>1 ^TMP("PSO",$J,PSI,WW-1)=ZRL1
	S:'$D(LTH) ^TMP("PSO",$J,PSI)=ZRL
	S PSI=PSI+1
	K SITE,PSZIP,PSOHZIP,CLN,CLN1,CSINER,CSINER1,MW,MP,NOW,QTY,CAP,DASPLY,COPAY,NURSE,DATE,DRUG,WARN,DEA,LTH,WW,ST,EN,VADM,VAPA,%,X,NFLD,RFRM
	Q
