PXCASK	;ISL/dee - Validates & Translates data from the PCE Device Interface into PCE's PXK format for Skin Test ;07/30/15  09:15
	;;1.0;PCE PATIENT CARE ENCOUNTER;**27,124,199,210**;Aug 12, 1996;Build 21
	Q
	; Variables
	;   PXCASK  Copy of a SKIN TEST node of the PXCA array
	;   PXCAPRV   Pointer to the provider (200)
	;   PXCANUMB  Count of the number if SKs
	;   PXCAINDX  Count of the number of SKIN TEST for one provider
	;   PXCAFTER  Temp used to build ^TMP(PXCAGLB,$J,"SK",PXCANUMB,0,"AFTER")
	;   PXCAPNAR  Pointer to the provider narrative (9999999.27)
	;
SK(PXCASK,PXCANUMB,PXCAPRV,PXCAERRS)	;
	N PXCAFTER
	S PXCAFTER=$P(PXCASK,"^",1)_"^"_PXCAPAT_"^"_PXCAVSIT_"^"
	S PXCAFTER=PXCAFTER_$P(PXCASK,"^",3)_"^"
	S PXCAFTER=PXCAFTER_$P(PXCASK,"^",2)_"^"
	;PX*1*124
	S PXCAFTER=PXCAFTER_$P(PXCASK,"^",4)
	S ^TMP(PXCAGLB,$J,"SK",PXCANUMB,"IEN")=""
	S ^TMP(PXCAGLB,$J,"SK",PXCANUMB,0,"BEFORE")=""
	S ^TMP(PXCAGLB,$J,"SK",PXCANUMB,0,"AFTER")=PXCAFTER
	S ^TMP(PXCAGLB,$J,"SK",PXCANUMB,12,"BEFORE")=""
	S ^TMP(PXCAGLB,$J,"SK",PXCANUMB,12,"AFTER")=$P(PXCASK,"^",5)_"^^^"_$S(PXCAPRV>0:PXCAPRV,1:"")
	S ^TMP(PXCAGLB,$J,"SK",PXCANUMB,80,"BEFORE")=""
	S ^TMP(PXCAGLB,$J,"SK",PXCANUMB,80,"AFTER")=$P(PXCASK,"^",6)_"^"_$P(PXCASK,"^",7)_"^"_$P(PXCASK,"^",8)_"^"_$P(PXCASK,"^",9)_"^"_$P(PXCASK,"^",10)_"^"_$P(PXCASK,"^",11)_"^"_$P(PXCASK,"^",12)_"^"_$P(PXCASK,"^",13)
	S ^TMP(PXCAGLB,$J,"SK",PXCANUMB,812,"BEFORE")=""
	S ^TMP(PXCAGLB,$J,"SK",PXCANUMB,812,"AFTER")="^"_PXCAPKG_"^"_PXCASOR
	Q
	;
SKINTEST(PXCA,PXCABULD,PXCAERRS)	;Validation routine for SK
	Q:'$D(PXCA("SKIN TEST"))
	N ICDDATA,ICDPCE,PXCAINDX,PXCAITEM,PXCANUMB,PXCAPRV,PXCASK,PXDXDATE
	S PXDXDATE=$S($D(PXCAVSIT)=1:$$CSDATE^PXDXUTL(PXCAVSIT),$D(PXCADT)=1:PXCADT,1:DT)
	S PXCAPRV="",PXCANUMB=0
	F  S PXCAPRV=$O(PXCA("SKIN TEST",PXCAPRV)) Q:PXCAPRV']""  D
	. I PXCAPRV>0 D
	.. I '$$ACTIVPRV^PXAPI(PXCAPRV,PXCADT) S PXCA("ERROR","SKIN TEST",PXCAPRV,0,0)="Provider is not active or valid^"_PXCAPRV
	.. E  I PXCABULD!PXCAERRS D ANOTHPRV^PXCAPRV(PXCAPRV)
	. S PXCAINDX=""
	. F  S PXCAINDX=$O(PXCA("SKIN TEST",PXCAPRV,PXCAINDX)) Q:PXCAINDX']""  D
	.. S PXCASK=$G(PXCA("SKIN TEST",PXCAPRV,PXCAINDX))
	.. S PXCANUMB=PXCANUMB+1
	.. I PXCASK="" S PXCA("ERROR","SKIN TEST",PXCAPRV,PXCAINDX,0)="SKIN TEST data missing" Q
	.. S PXCAITEM=+$P(PXCASK,"^",1)
	.. I $G(^AUTTSK(PXCAITEM,0))="" S PXCA("ERROR","SKIN TEST",PXCAPRV,PXCAINDX,1)="SKIN TEST type not in file 9999999.28^"_PXCAITEM
	.. S PXCAITEM=$P(PXCASK,"^",2)
	.. I '((PXCAITEM=(PXCAITEM\1)&(PXCAITEM>-1)&(PXCAITEM<41))!(PXCAITEM="")) S PXCA("ERROR","SKIN TEST",PXCAPRV,PXCAINDX,2)="SKIN TEST reaction must be an integer form 0 to 40^"_PXCAITEM
	.. S PXCAITEM=$P(PXCASK,"^",3)
	.. I '(PXCAITEM=""!(PXCAITEM="P")!(PXCAITEM="N")!(PXCAITEM="D")!(PXCAITEM="O")) S PXCA("ERROR","SKIN TEST",PXCAPRV,PXCAINDX,3)="SKIN TEST results must be P|N|D|O^"_PXCAITEM
	.. F ICDPCE=6:1:13 D
	... S PXCAITEM=$P(PXCASK,"^",ICDPCE) I PXCAITEM]"" D
	.... S ICDDATA=$$ICDDATA^ICDXCODE("DIAG",PXCAITEM,PXDXDATE,"I")
	.... I $P(ICDDATA,"^",1)'>0 D
	..... S PXCA("ERROR","SKIN TEST",PXCAPRV,PXCAINDX,ICDPCE)="SKIN TEST Diagnosis # "_(ICDPCE-5)_" not in file 80^"_PXCAITEM
	.... E  I $P(ICDDATA,"^",10)'=1 D
	..... S PXCA("ERROR","SKIN TEST",PXCAPRV,PXCAINDX,ICDPCE)="SKIN TEST Diagnosis # "_(ICDPCE-5)_" not an ACTIVE ICD Code^"_PXCAITEM
	.. I PXCABULD&'$D(PXCA("ERROR","SKIN TEST",PXCAPRV,PXCAINDX))!PXCAERRS D SK(PXCASK,.PXCANUMB,PXCAPRV,PXCAERRS)
	Q
	;
