HBHCRP1A	;LR VAMC(IRMS)/MJT - HBHC report on files 634.1, 634.2, & 634.3, (Form 3/4/5 (A/V/D respectively) Error(s)), sorted by form, then by: clinic, date, patient & includes: pt name, last 4, form, & date, calls DQ^HBHCRP31 ;Apr 2000
	;;1.0;HOSPITAL BASED HOME CARE;**6,8,10,13,16,24,25**;NOV 01, 1993;Build 45
	;
	; This routine references the following supported ICRs:
	; 5747    $$CODEC^ICDEX
	; 5747    $$VSTD^ICDEX
	;
	;******************************************************************************
	;******************************************************************************
	;                       --- ROUTINE MODIFICATION LOG ---
	;        
	;PKG/PATCH    DATE        DEVELOPER    MODIFICATION
	;-----------  ----------  -----------  ----------------------------------------
	;HBH*1.0*25   FEB  2012   K GUPTA      Support for ICD-10 Coding System
	;******************************************************************************
	;******************************************************************************
	;
	; visits display current outpatient encounter file data, allowing easier re-entry when cleaning up errors, includes: Pt file IEN, error, provider, Dx, CPT code with Modifiers & clinic name, calls HBHCRP1B & PSEUDO^HBHCUTL3
	I $P(^HBHC(631.9,1,0),U,8)]"" W $C(7),!,"File Update in progress.  Please try again later." H 3 Q
	S %ZIS="Q",HBHCCC=0 K IOP,ZTIO,ZTSAVE D ^%ZIS Q:POP
	I $D(IO("Q")) S ZTRTN="DQ^HBHCRP1A",ZTSAVE("HBHC*")="",ZTDESC="HBPC Form Errors Report" D ^%ZTLOAD G EXIT
DQ	; De-queue
	U IO
	D START^HBHCRP1B
LOOP	; Loop thru files 634.1, 634.2 & 634.3 "B" cross-ref
	F HBHCFILE=634.1,634.2,634.3 S HBHCDPT="" F  S HBHCDPT=$O(^HBHC(HBHCFILE,"B",HBHCDPT)) Q:HBHCDPT=""  D SETUP^HBHCRP1B S HBHCIEN="" F  S HBHCIEN=$O(^HBHC(HBHCFILE,"B",HBHCDPT,HBHCIEN)) Q:HBHCIEN=""  D PROCESS
	D PRTLOOP^HBHCRP1B D:$D(^HBHC(634.5,"B")) PSEUDO^HBHCUTL3
	I ($D(ZTRTN)!(HBHCCC=0))&((IOSL-$Y)<12) W @IOF D HDRPAGE^HBHCUTL
	D:$D(^HBHC(634.2,"B")) PCEMSG^HBHCUTL3 D ENDRPT^HBHCUTL1
	; Print Medical Foster Home (MFH) Form Errors if exist
	I $D(^HBHC(634.7,"B")) W @IOF D DQ^HBHCRP31
EXIT	; Exit module
	D EXIT^HBHCRP1B
	Q
PROCESS	; Process report data
	S HBHCDPT0=^DPT(HBHCDPT,0),HBHCNOD0=$S(HBHCFORM="V":$G(^HBHC(HBHCFL,HBHCIEN,0)),1:$G(^HBHC(HBHCFL,$P(^HBHC(HBHCFILE,HBHCIEN,0),U,2),0)))
	; Form 3: use Evaluation Date (field 1) if Date (field 17) null, 'reject' episodes prior to PCE patch will only have eval date
	S (HBHCDAT,Y)=$P(HBHCNOD0,U,HBHCPC) S:(HBHCFORM="A")&(Y="") (HBHCDAT,Y)=$P(HBHCNOD0,U,2) D DD^%DT S HBHCDATE=$E(Y,1,18) S:HBHCDAT="" (HBHCDAT,HBHCDATE)="Missing"
	S HBHCNAME=$E($P(HBHCDPT0,U),1,14),HBHCSSN=$E($P(HBHCDPT0,U,9),6,9)
	S HBHCCLN="n/a" S:HBHCFORM="V" HBHCCLN=$S($P(HBHCNOD0,U,6)]"":$E($P(^SC($P(HBHCNOD0,U,6),0),U),1,18),1:"Unknown")
	S HBHCMSG="" S:HBHCFORM="V" HBHCMSG=$S($P(HBHCNOD0,U,3)]"":$P(^HBHC(633.1,$P(HBHCNOD0,U,3),0),U),1:"")
	I HBHCFORM="V" S HBHCOEP=$P(HBHCNOD0,U,4) D:HBHCOEP]"" OE
	S ^TMP("HBHC",$J,HBHCFORM,HBHCCLN,HBHCDAT,HBHCNAME,HBHCSSN,1)="`"_HBHCDPT_U_HBHCDATE_U_HBHCMSG
	Q
OE	; Process Outpatient Encounter data
	; Provider, 2 pieces of info delimited by $ (Provider name & V PROVIDER  ^AUPNVPRV(9000010.06) DFN)
	K HBHCPRV1,HBHCPRVL
	D GETPRV^SDOE(HBHCOEP,"HBHCPRVL")
	S HBHCDFN=0 F HBHCI=1:1 S HBHCDFN=$O(HBHCPRVL(HBHCDFN)) Q:HBHCDFN'>0  S HBHCPRVP=$P(HBHCPRVL(HBHCDFN),U),^TMP("HBHC",$J,HBHCFORM,HBHCCLN,HBHCDAT,HBHCNAME,HBHCSSN,2,HBHCI)=$S(HBHCPRVP]"":$P(^VA(200,HBHCPRVP,0),U)_"$"_HBHCPRVP,1:"")
	; Dx
	K HBHCDXL
	D GETDX^SDOE(HBHCOEP,"HBHCDXL")
	S HBHCDFN=0 F HBHCI=1:1 S HBHCDFN=$O(HBHCDXL(HBHCDFN)) Q:HBHCDFN'>0  S HBHCINFO=HBHCDXL(HBHCDFN),HBHCICDP=$P(HBHCINFO,U),HBHCDX1=$S($P(HBHCINFO,U,12)="P":"* ",1:HBHCSP2) D ICD
	; CPT Code, 3 pieces of info delimited by $ (CPT Code w/Text, Quantity of CPT code & New Person file (200) DFN), must match V PROVIDER ^AUPNVPRV(9000010.06) DFN to ensure same provider
	K HBHCCPTL,HBHCPRV
	D GETCPT^SDOE(HBHCOEP,"HBHCCPTL")
	S HBHCDFN=0 F HBHCI=1:1  S HBHCDFN=$O(HBHCCPTL(HBHCDFN)) Q:HBHCDFN'>0  S HBHCJ=0 F  S HBHCJ=$O(HBHCCPTL(HBHCDFN,HBHCJ)) Q:HBHCJ'>0  S HBHCINFO=HBHCCPTL(HBHCDFN,0),HBHCCPT=$$CPT^ICPTCOD($P(HBHCINFO,U)) D SETCPT,MOD
	Q
ICD	; Dx info
	N DXINFO
	S:HBHCICDP]"" DXINFO=$$CODEC^ICDEX(80,HBHCICDP)_"  "_$$VSTD^ICDEX(HBHCICDP)
	S ^TMP("HBHC",$J,HBHCFORM,HBHCCLN,HBHCDAT,HBHCNAME,HBHCSSN,3,HBHCI)=HBHCDX1_$G(DXINFO)_$S(HBHCDX1["*":"  *  Primary Dx",1:"")
	Q
SETCPT	; Set TMP global with CPT info
	S ^TMP("HBHC",$J,HBHCFORM,HBHCCLN,HBHCDAT,HBHCNAME,HBHCSSN,4,HBHCI)=$P(HBHCCPT,U,2)_HBHCSP3_$P(HBHCCPT,U,3)_"$"_$P(HBHCINFO,U,16)_"$"_$S($D(HBHCCPTL(HBHCDFN,12)):$P(HBHCCPTL(HBHCDFN,12),U,4),1:"")
	Q
MOD	; CPT Modifier loop & set
	S HBHCK=0
	F  S HBHCK=$O(HBHCCPTL(HBHCDFN,HBHCJ,HBHCK)) Q:HBHCK'>0  S HBHCMOD=$$MOD^ICPTMOD(HBHCCPTL(HBHCDFN,HBHCJ,HBHCK,0),"I"),^TMP("HBHC",$J,HBHCFORM,HBHCCLN,HBHCDAT,HBHCNAME,HBHCSSN,4,HBHCI,HBHCJ)=$P(HBHCMOD,U,2)_HBHCSP3_$P(HBHCMOD,U,3)
	Q
