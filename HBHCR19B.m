HBHCR19B	;LR VAMC(IRMS)/MJT - HBHC rpt, called by HBHCR19A, entry points:  INITIAL, PRTLOOP, EXIT ;Aug 2000
	;;1.0;HOSPITAL BASED HOME CARE;**8,14,22,25**;NOV 01, 1993;Build 45
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
INITIAL	; Initialize variables
	K ^TMP("HBHC",$J)
	S $P(HBHCSP2," ",3)="",(HBHCCNT,HBHCTOT)=0,$P(HBHCY,"-",81)="",HBHCHEAD="ICD Code/Diagnosis Text by Date Range"
	S HBHCHDR="W !,""Patient Name"",?27,""Last Four"",?41,"""_$$ICDTEXT^HBHCUTL3(HBHCBEG1,HBHCEND1)_" Code/Diagnosis Text"""
	S HBHCCOLM=(80-(20+$L(HBHCHEAD))\2) S:HBHCCOLM'>0 HBHCCOLM=1
	Q
PRTLOOP	; Print loop
	S HBHCCAT=""
	F  S HBHCCAT=$O(^TMP("HBHC",$J,HBHCCAT)) Q:HBHCCAT=""  D SUBTOT S HBHCNAME="" F  S HBHCNAME=$O(^TMP("HBHC",$J,HBHCCAT,HBHCNAME)) Q:HBHCNAME=""  S HBHCLST4="" F  S HBHCLST4=$O(^TMP("HBHC",$J,HBHCCAT,HBHCNAME,HBHCLST4)) Q:HBHCLST4=""  D PRTLOOP2
	D SUBTOT
	Q
SUBTOT	; Print subtotal from previous category
	I HBHCCNT>0 W !!,"Category:  "_HBHC_"  Count:  ",HBHCCNT,!,HBHCY S HBHCTOT=HBHCTOT+HBHCCNT
	S HBHC=HBHCCAT,HBHCCNT=0
	Q
PRTLOOP2	; Print loop 2, PRTLOOP continued
	S HBHCDX="" F  S HBHCDX=$O(^TMP("HBHC",$J,HBHCCAT,HBHCNAME,HBHCLST4,HBHCDX)) Q:HBHCDX=""  D PRINT
	Q
PRINT	; Print report
	I ($D(ZTRTN)!(HBHCCC=0))&((IOSL-$Y)<8) W @IOF D HDRRANGE^HBHCUTL
	S HBHCTMP=^TMP("HBHC",$J,HBHCCAT,HBHCNAME,HBHCLST4,HBHCDX)
	W !,HBHCNAME,?27,$E(HBHCLST4,8,11),?41,HBHCDX
	S HBHCCNT=HBHCCNT+1
	Q
EXIT	; Exit module
	D ^%ZISC
	K HBHC,HBHCAPDT,HBHCBEG1,HBHCBEG2,HBHCCAT,HBHCCATB,HBHCCATE,HBHCCC,HBHCCNT,HBHCCOLM,HBHCDFN,HBHCDPT0,HBHCDX,HBHCEND1,HBHCEND2,HBHCFLAG,HBHCHDR,HBHCHEAD,HBHCI,HBHCICDP,HBHCLST4,HBHCNAME,HBHCNOD0,HBHCPAGE,HBHCSP2,HBHCTDY,HBHCTMP
	K HBHCTOT,HBHCY,HBHCZ,X,X1,X2,Y,^TMP("HBHC",$J),^TMP($J)
	Q
