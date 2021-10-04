MDPS1	; HOIFO/NCA - CP/Medicine Report Generator ;5/17/10  08:57
	;;1.0;CLINICAL PROCEDURES;**2,10,13,21,24**;Apr 01, 2004;Build 8
	; Integration Agreements:
	; IA# 2263 [Supported] XPAR calls.
	; IA# 2693 [Subscription] TIU Extractions.
	; IA# 2925 [Subscription] Calls to GMRCSLM2.
	; IA# 2926 [Subscription] Calls to GMRCGUIA.
	; IA# 2944 [Subscription] Calls to TIUSRVR1.
	; IA# 3067 [Private] Read fields in Consult file (#123) w/FM
	; IA# 4230 [Subscription] Document MDPS1 calls (CP Custodian).
	; IA# 4231 [Subscription] Document CKP^GMTSUP usage.
	; IA# 4792 [Private] CANDO^TIUSRVA call
	; IA# 10017 [Supported] DD("DD")
	; IA# 10103 [Supported] XLFDT Call
	; IA# 10104 [Supported] Routine XLFSTR calls
	;
	; Pre-existing local variables
	; DFN,GMTS1,GMTS2,GMTSNDM,GMTSNPG,GMTSQIT
	;
EN1(MDGLO,MDDFN,MDSDT,MDEDT,MDMAX,MDPSC,MDALL)	; Return the List of Completed Studies
	; Input: MDGLO - Return Global Array (Required)
	;        MDDFN - Patient DFN         (Required)
	;        MDSDT - Start Date in FM Internal Format (Optional)
	;        MDEDT - End Date in FM Internal Format (Optional)
	;        MDMAX - Number of studies to return    (Optional)
	;        MDPSC - Procedure Summary Code         (Optional)
	;        MDALL - Return the all text reports with
	;                the procedures list            (Optional)
	; (Returns all studies for Patient, if no MDSDT, MDEDT,and MDMAX.)
	;
	I '$G(MDDFN)!('$D(MDGLO)) Q
	I $G(MDGLO)="" S MDGLO=$NA(^TMP("MDHSP",$J))
	N MDARR,MDCODE,MDCON,MDCTR,MDDTE,MDLP,MDLP1,MDPLST,MDPROC,MDSTAT,MDT,MDTIUER,MDX,Y
	S (MDIMG,MDCTR)=0,(MDCODE,MDDTE,MDTIUER)="",MDC=$G(MDPSC)
	K ^TMP("MDPLST",$J) S MDPLST=$NA(^TMP("MDPLST",$J))
	;
	; If not converted call old medicine gather routine
	D:$G(MDC)="" GP^MDPS4(MDDFN,MDSDT,MDEDT)
	I '$G(MDSDT),'$G(MDEDT) D EN^MDARP3(MDDFN,MDC)
	E  D EN^MCARPS3(MDDFN,MDC,MDSDT,MDEDT)
	;
	; Get CP procedures
	D GET702(.MDGLO,MDDFN,MDC,MDSDT,MDEDT,$S(+$G(MDMAX):MDMAX,1:999))
	K ^TMP("MDPLST",$J)
	Q
	;
GET702(MDGLO,MDDFN,MDC,MDSDT,MDEDT,MDMAX)	; Gather the new 702 entries
	S MDLP="" F  S MDLP=$O(^MDD(702,"B",MDDFN,MDLP),-1) Q:MDLP<1  D
	.S MDX=$G(^MDD(702,MDLP,0)) Q:$P(MDX,"^",9)'=3
	.S MDPROC=$$GET1^DIQ(702,MDLP_",",.04,"E") Q:MDPROC=""
	.Q:'$P(MDX,U,6)
	.K ^TMP("MDTIUST",$J) S MDTIUER=""
	.D EXTRACT^TIULQ($P(MDX,U,6),"^TMP(""MDTIUST"",$J)",MDTIUER,".01;.05;70201;70202") Q:+MDTIUER
	.S MDCODE=$G(^TMP("MDTIUST",$J,$P(MDX,U,6),70201,"E"))
	.S:MDCODE'="" MDCODE=$$UP^XLFSTR(MDCODE)
	.I $G(MDC)'="" Q:MDCODE'=$G(MDC)
	.S MDDTE=$G(^TMP("MDTIUST",$J,$P(MDX,U,6),70202,"I"))
	.S MDSTAT=$G(^TMP("MDTIUST",$J,$P(MDX,U,6),.05,"E"))
	.S:'MDDTE MDDTE=$$GET1^DIQ(702,MDLP_",",.02,"I")
	.K ^TMP("MDTIUST",$J)
	.S MDCON=$P(MDX,U,5)
	.I +$G(MDSDT) Q:MDDTE<+$G(MDSDT)
	.I +$G(MDEDT) Q:MDDTE>+$G(MDEDT)
	.I MDCON D  Q:MDSTAT'="COMPLETE"&(MDSTAT'="PARTIAL RESULTS")
	..S MDSTAT=$$GET1^DIQ(123,MDCON_",",8,"E")
	..I MDSTAT="" S MDSTAT=$$GET1^DIQ(123,MDCON_",",8,"I") S:+MDSTAT MDSTAT=$$GET1^DIQ(100.01,MDSTAT_",",.01,"E")
	..Q
	.S Y=MDDTE X ^DD("DD")
	.I MDCON Q:$G(MDARR(MDCON))'=""  S MDARR(MDCON)=MDCON
	.S:$G(^TMP("MDPLST",$J,(9999999.9999-MDDTE),MDPROC_"~"_MDLP))="" ^(MDPROC_"~"_MDLP)=MDPROC_"^"_MDLP_"^"_"PR702"_"^"_"MDPS1"_"^^"_Y_"^"_MDCODE_"^^^^"_MDPROC_"^^"_MDCON_"^"_+$P(MDX,U,6)
	.Q
	S MDCTR=0
	S MDLP="" F  S MDLP=$O(^TMP("MDPLST",$J,MDLP)) Q:MDLP=""  S MDLP1="" F  S MDLP1=$O(^TMP("MDPLST",$J,MDLP,MDLP1)) Q:MDLP1=""  S MDX=$G(^(MDLP1)) D
	.I +$G(MDMAX) Q:MDCTR=MDMAX
	.S MDCTR=MDCTR+1,@MDGLO@(MDCTR)=$G(MDX)
	K MDARR
	I +$G(MDALL) K ^TMP("MDPTXT",$J) S MDLP=0 F  S MDLP=$O(@MDGLO@(MDLP)) Q:MDLP<1  S MDX1=$G(@MDGLO@(MDLP)) D
	.S MCARGDA=+$P(MDX1,U,2),MCPRO=$P(MDX1,U,11),MCARPPS=$P(MDX1,U,3,4)
	.S MCARGRTN=$P(MDX1,U,5),MDT="RD"
	.D @MCARPPS
	K MCARGDA,MCARGRTN,MCPRO,MCARPPS
	Q
CPA	; Abnormal Report - Health Summary Component
	N MDHR,MDHSG,MDHDR,MDHFLG,MDLIM,MDTS1,MDTS2,MDX1
	Q:'$G(DFN)  Q:'$G(GMTS1)  Q:'$G(GMTS2)
	K ^TMP("MDHSP",$J) S MDHFLG=1
	S MDHSG=$NA(^TMP("MDHSP",$J)) D SET^MDPS2
	D EN1(.MDHSG,DFN,MDTS1,MDTS2,MDLIM,"ABNORMAL")
	I '$D(^TMP("MDHSP",$J)) D CKP^GMTSUP Q:$D(GMTSQIT)  W !,"No Procedure Data for the patient." Q
	S MDHR=0 F  S MDHR=$O(^TMP("MDHSP",$J,MDHR)) Q:MDHR<1  S MDX1=$G(^(MDHR)) D
	.D HSHDR^MDPS2
	.S MCARGDA=+$P(MDX1,U,2),MCARPPS=$P(MDX1,U,3,4),MCPRO=$P(MDX1,U,11)
	.S MCARGRTN=$P(MDX1,U,5),MDT="RD",MDHDR=1
	.D @MCARPPS Q
	K ^TMP("MDHSP",$J),MCARGRTN,MCPRO,MCARPPS
	Q
CPB	; Brief Report - Health Summary Component
	N MDHR,MDHSG,MDLIM,MDTS1,MDTS2,MDX1
	Q:'$G(DFN)  Q:'$G(GMTS1)  Q:'$G(GMTS2)
	K ^TMP("MDHSP",$J)
	S MDHSG=$NA(^TMP("MDHSP",$J)) D SET^MDPS2
	D EN1(.MDHSG,DFN,MDTS1,MDTS2,MDLIM)
	I '$D(^TMP("MDHSP",$J)) D CKP^GMTSUP Q:$D(GMTSQIT)  W !,"No Procedure Data for the patient." Q
	D HDR^MDPS2
	S MDHR=0 F  S MDHR=$O(^TMP("MDHSP",$J,MDHR)) Q:MDHR<1  S MDX1=$G(^(MDHR)) D
	.D CKP^GMTSUP Q:$D(GMTSQIT)
	.W !,$S(+$P(MDX1,U,13):$J($P(MDX1,U,13),9),1:""),?12,$E($P(MDX1,U,1),1,30),?44,$P(MDX1,U,6),?67,$P(MDX1,U,7)
	.Q
	K ^TMP("MDHSP",$J)
	Q
CPC	; Full Caption Report - Health Summary Component
	S MDT1="CD"
CPF	; Full Report - Health Summary Component
	N MDHR,MDHSG,MDHDR,MDHFLG,MDLIM,MDT,MDTS1,MDTS2,MDX1
	Q:'$G(DFN)  Q:'$G(GMTS1)  Q:'$G(GMTS2)
	K ^TMP("MDHSP",$J) S MDHFLG=1
	S MDHSG=$NA(^TMP("MDHSP",$J)) D SET^MDPS2
	D EN1(.MDHSG,DFN,MDTS1,MDTS2,MDLIM)
	I '$D(^TMP("MDHSP",$J)) D CKP^GMTSUP Q:$D(GMTSQIT)  W !,"No Procedure Data for the patient." Q
	S MDHR=0 F  S MDHR=$O(^TMP("MDHSP",$J,MDHR)) Q:MDHR<1  S MDX1=$G(^(MDHR)) D
	.D HSHDR^MDPS2
	.S MCARGDA=+$P(MDX1,U,2),MCPRO=$P(MDX1,U,11),MCARPPS=$P(MDX1,U,3,4)
	.S MCARGRTN=$P(MDX1,U,5),MDT=$S($G(MDT1)="":"RD",1:"CD"),MDHDR=1
	.D @MCARPPS Q
	K ^TMP("MDHSP",$J),MCARGDA,MCARGRTN,MCPRO,MCARPPS,MDT1
	Q
CPS	; One Line Summary Report
	N MDHR,MDHSG,MDLIM,MDTS1,MDTS2,MDX1
	Q:'$G(DFN)  Q:'$G(GMTS1)  Q:'$G(GMTS2)
	K ^TMP("MDHSP",$J)
	S MDHSG=$NA(^TMP("MDHSP",$J)) D SET^MDPS2
	D EN1(.MDHSG,DFN,MDTS1,MDTS2,MDLIM)
	I '$D(^TMP("MDHSP",$J)) D CKP^GMTSUP Q:$D(GMTSQIT)  W !,"No Procedure Data for the patient." Q
	S MDHR=0 F  S MDHR=$O(^TMP("MDHSP",$J,MDHR)) Q:MDHR<1  S MDX1=$G(^(MDHR)) D
	.D HSHDR^MDPS2
	K ^TMP("MDHSP",$J)
	Q
PR702	; Return the Result Text for File 702 records
	Q:'$G(MCARGDA)
	N FFF,MDAK,MDAX,MDCLIN,MDCON,MDIMG,MDMCG,MDMED,MDREC,MDPRILV,MDPTR,MDSTUDY,MDTIU,MDX4,MDXY,PATID,MDRPG,RESULTS,MDRMT
	I '$G(MDALL) K ^TMP("MDPTXT",$J)
	S MDIMG=0,$P(FFF,"-",80)="",MDRPG=0,MDXY=""
	S MDSTUDY=+$G(MCARGDA)
	S MDTIU=$$GET1^DIQ(702,MDSTUDY_",",.06,"I")
	S MDCON=$$GET1^DIQ(702,MDSTUDY_",",.05,"I")
	S MDAK=$$GET1^DIQ(702,MDSTUDY_",",.04,"E")
	Q:'MDTIU
	I +$P($G(^MDD(702,MDSTUDY,.1,0)),U,4)>0 S MDIMG=1
	S (MDPRILV,RESULTS)="",MDCLIN=0
	D CANDO^TIUSRVA(.MDPRILV,+MDTIU,"VIEW")
	I +MDPRILV<1 S ^TMP("MDPTXT",$J,MCARGDA,MCPRO,1)=$P(MDPRILV,U,2) D NXT Q
	I 'MDCON D TGET^TIUSRVR1(.RESULTS,+MDTIU) M ^TMP("MDPTXT",$J,MCARGDA,MCPRO)=@RESULTS K ^TMP("TIUVIEW",$J) Q:+$G(MDALL)  D NXT Q
	I MDCON D  Q:+$G(MDRMT)!('+$P(MDXY,";",2))!(+$G(MDMED))
	.S MDG=$NA(^TMP("MDPTXT",$J,MCARGDA,MCPRO))
	.S MDMED=$$CHKMED^MDPS3(MDCON)
	.I MDMED D GETARY(.MDG,MDCON) Q:+$G(MDALL)  Q:+$G(MDRDV)  D NXT Q
	.S MDRMT=$$GETAMDT^MDPS3(MDCON)
	.S MDXY=$$GET^XPAR("SYS","MD GET HIGH VOLUME",MDAK,"E")
	.K ^TMP("GMRCR",$J,"DT")
	.I '+$P(MDXY,";",2) D GETARY(.MDG,MDCON) Q:+$G(MDALL)  Q:+$G(MDRDV)  D NXT Q
	.I +$P(MDXY,";",2) S RESULTS=$NA(^TMP("GMRCR",$J,"DT")) D DT^GMRCSLM2(MDCON)
	.D SETLINE(.MDG,.RESULTS) K ^TMP("GMRCR",$J,"DT")
NXT	Q:+$G(MDALL)  Q:+$G(MDRDV)
	I $D(ORHFS) U IO G PRINT
	G PRINT
PR690	; Return the Result text for File 690 Medicine report record
	Q:'$G(MCARGDA)
	N MDSTUDY,RESULTS,MDTMP,PATID
	I '$G(MDALL) K ^TMP("MDPTXT",$J)
	S MDSTUDY=+$G(MCARGDA)
	S MDG=$NA(^TMP("MDPTXT",$J,MCARGDA,MCPRO))
	S MDTMP="",MDTMP=+$O(^MCAR(697.2,"B",MCPRO,MDTMP))
	S MDTMP=$G(^MCAR(697.2,+MDTMP,0)) Q:MDTMP=""
	S MDF=$P(MDTMP,U,2),MDF=$P(MDF,"(",2),MDR=+MCARGDA,MDPR=MCPRO,PATID=DFN S:$G(MDT)="" MDT="RD"
	D GETDATA^MDPS2(.MDG,DFN,MDPR,MDF,MDR,MDT,$S(+$G(MDHDR):MDHDR,1:0))
	Q:+$G(MDALL)  Q:+$G(MDRDV)
	I $D(ORHFS) U IO G PRINT
PRINT	; Print the text for Display
	N MDRE S MDREC=$NA(^TMP("MDPTXT",$J)),MDRPG=1,MDRE=+$P(MDREC,",",2)
	W:'$G(MDHFLG) @IOF,!!
	F  S MDREC=$Q(@MDREC) Q:MDREC=""  Q:$QS(MDREC,1)'="MDPTXT"  D
	.Q:$QS(MDREC,2)'=MDRE
	.I +$G(MDHFLG) D CKP^GMTSUP Q:$D(GMTSQIT)
	.I '$G(MDHFLG)&($Y>(IOSL-6)!($Y<1)) W @IOF D HDR^MDPS3
	.W !,$G(@MDREC)
	.Q
	I +$G(MDIMG) D
	.I +$G(MDHFLG) D CKP^GMTSUP Q:$D(GMTSQIT)
	.W ! I +$G(MDHFLG) D CKP^GMTSUP Q:$D(GMTSQIT)
	.W !,"NOTE: Images are associated with this procedure."
	.I +$G(MDHFLG) D CKP^GMTSUP Q:$D(GMTSQIT)
	.W !,"      Please use Imaging Display to view the images."
	.Q
	K MCPRO,MCARPPS,MCARGRTN,^TMP("MDPTXT",$J)
	Q
GETARY(MDG,MDCON)	; Get the Medicine Result
	N MDCK,MDCX,MDX4,MDGL
	K ^TMP("MDREST",$J) S MDGL=$NA(^TMP("MDREST",$J))
	D GETS^DIQ(123,MDCON_",","50*","I","MDCX")
	S MDCK="" F  S MDCK=$O(MDCX(123.03,MDCK),-1) Q:MDCK<1  S MDX4=$G(MDCX(123.03,MDCK,.01,"I")) D
	.I MDX4["MCAR" D  Q
	..S MDR=+MDX4,MDF=+$P(MDX4,"(",2),PATID=DFN S:$G(MDT)="" MDT="RD"
	..Q:MDX4=""  S MCPRO=$$PRO^MDPS3(MDX4),MDPR=MCPRO
	..D GETDATA^MDPS2(.MDGL,DFN,MDPR,MDF,MDR,MDT,$S(+$G(MDHDR):1,1:0))
	..D SETLINE(.MDG,.MDGL) K ^TMP("MDREST",$J)
	..Q
	.I MDX4["TIU" D  Q
	..S RESULTS="" D TGET^TIUSRVR1(.RESULTS,+MDX4)
	..D SETLINE(.MDG,.RESULTS) K ^TMP("TIUVIEW",$J)
	..S MDCLIN=MDCLIN+1,@MDG@(MDCLIN,0)=FFF
	..Q
	Q
SETLINE(MDG,MDGL)	; Set Global Lines
	N MDCK1,MDX3,MDSC,MDNAME,MDTITL,MDDTM
	D NOW^%DTC S X=% D DTIME^MCARP S MDDTM=$$FMTE^XLFDT(X,2) K %
	I $G(MCPRO)'="" S MDNAME=$O(^MCAR(697.2,"B",MCPRO,0)) D
	.I MDNAME S MDTITL=$P($G(^MCAR(697.2,+MDNAME,0)),"^",8)
	.I $G(MDTITL)="" S MDNAME=$O(^MDS(702.01,"B",MCPRO,0)) S:MDNAME MDTITL=$P($G(^MDS(702.01,+MDNAME,0)),U)
	S MDCK1=MDGL,MDSC=$QS(MDCK1,1),MDRPG=MDRPG+1
	I '$G(MDHDR) D
	.Q:MDSC="MDREST"
	.S MDCLIN=MDCLIN+1,@MDG@(MDCLIN,0)="Pg. "_MDRPG_$J(" ",25)_$$HOSP^MDPS2(DFN)_$J(" ",25)_MDDTM
	.I $G(MDTITL)'="" S MDCLIN=MDCLIN+1,@MDG@(MDCLIN,0)=$J(" ",25)_MDTITL
	.S MDCLIN=MDCLIN+1,@MDG@(MDCLIN,0)=$$DEMO^MDPS2(DFN)
	.S MDCLIN=MDCLIN+1,@MDG@(MDCLIN,0)=FFF
	F  S MDCK1=$Q(@MDCK1) Q:MDCK1=""  Q:$QS(MDCK1,1)'=MDSC  Q:$QS(MDGL,2)'=$QS(MDCK1,2)  S MDCLIN=MDCLIN+1,@MDG@(MDCLIN,0)=$G(@MDCK1)
	Q