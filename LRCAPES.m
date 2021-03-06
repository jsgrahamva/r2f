LRCAPES	;DALOI/FHS/KLL -MANUAL PCE CPT WORKLOAD CAPTURE ;11/18/11  15:21
	;;5.2;LAB SERVICE;**274,259,349,308,350,448**;Sep 27, 1994;Build 1
	;
	;Reference to $$GET^XUA4A72 - Supported by DBIA #1625
EN	;
	D EN^LRCAPES1
	Q
EX1	;Parse the read entry
	N LRXY,LRACTV,LRXY1,LRXY2,LRD2,LRNR,LRWL2,LRINA2,LRREL2,LRQ
	Q:'$L($G(LRX))
	;Edit on 5-digit code entry
	I LRX?5N,'$D(^TMP("LR",$J,"AK",LRX))#2 D  Q
	.S LRXY=$$CPT^ICPTCOD(LRX,DT)
	.D CHKCPT^LRCAPES1
	.;Don't pass to PCE if CPT is missing or inactive in #81 or #64
	.Q:'$P(LRXY,U,7)!(LRNR)
	.;If CPT is inactive in #64 and another active CPT exists, replace
	.;      the inactive with the active CPT
	.I LRACTV D  Q
	..S LRXY=$$CPT^ICPTCOD(LRXY2,DT)
	..S LRCNT=+$G(LRCNT)+1
	..S ^TMP("LR",$J,"LRLST",LRCNT)=$P(LRXY,U)_U_LRWL2_U_$P(LRXY,U,3)_U
	..S LRRF64=$S($G(LRRF64):LRRF64_LRXY1_"\"_LRXY2_",",1:LRXY1_"\"_LRXY2_",")
	..;If CPT passes edits, continue
	.S LRCNT=+$G(LRCNT)+1
	.S ^TMP("LR",$J,"LRLST",LRCNT)=$P(LRXY,U)_"^^"_$P(LRXY,U,3)_U
	;Edit on ES Display Order # entry
	S LRQ="^TMP(""LR"","_$J_",""AK"","_LRX_")"
	S LRQ=$Q(@LRQ)
	I LRX'=$QS(LRQ,4) S LRINVES=LRX Q 
	S LRXY=$$CPT^ICPTCOD($QS(LRQ,6),DT)
	D CHKCPT^LRCAPES1
	Q:'$P(LRXY,U,7)!(LRNR)
	;If CPT is inactive in #64 and another active CPT exists, replace
	;      the inactive with the active CPT
	I LRACTV D  Q
	.S LRXY=$$CPT^ICPTCOD(LRXY2,DT)
	.S LRCNT=+$G(LRCNT)+1
	.S ^TMP("LR",$J,"LRLST",LRCNT)=$P(LRXY,U)_U_LRWL2_U_$P(LRXY,U,3)_U
	.S LRRF64=$S($G(LRRF64):LRRF64_LRXY1_"\"_LRXY2_",",1:LRXY1_"\"_LRXY2_",")
	.;I CPT passes edits, continue
	S LRCNT=+$G(LRCNT)+1
	S ^TMP("LR",$J,"LRLST",LRCNT)=$QS(LRQ,6)_U_@LRQ
	Q
END1	;
	D END S LREND=1
	Q
END	;
	I $G(LRAA),$G(LRAD),$G(LRAN) L -^LRO(68,LRAA,1,LRAD,1,LRAN)
	K:'$G(LRESCPT) ^TMP("LR",$J,"AK")
	I $G(LRDEBUG) W !,"END ",! Q
	Q
WLN	;Interactive entry point
	D KVA^VADPT
	K DIC,DIR
	K LREND,LRUID,DIC,DIR,LRVBY
	K ^TMP("LR",$J,"LRLST")
	K LRAA,LRACC,LRAD,LRAN,LRDFN,LRDPF,LRIDT
	K LRRB,LRSS,LRTIME,LRTREA,LRUID,LRWRD,PNM,SEX,SSN,AGE
	S (LRAA,LRACC,LRAD,LRNOP,LRAN,LREND)=0,LRVBY=1,LRUID=""
	S:'$G(LRPRO) LRPRO=DUZ
	I '$G(LRESCPT) S LRVBY=$$SELBY^LRWU4("Select Accession By")
	D:LRVBY=1 ^LRVERA D:LRVBY=2 UID^LRVERA
	I 'LRVBY!(LRAA<1) D END S LREND=1 Q
	S LRDFN=+$$GET1^DIQ(68.02,+$G(LRAN)_","_+$G(LRAD)_","_+$G(LRAA)_",",.01)
	I 'LRDFN D END S LRNOP=1 D  Q
	. W !?5,"This accession is corrupt",!
LCK	;
	L +^LRO(68,LRAA,1,LRAD,1,LRAN):10 I '$T D  Q
	. W !?5,"Someone else is editing this accession",!
	. S LRNOP=1
	D PT^LRX
	S LRUID=$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA_",",16)
	S LRLLOCX=$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA_",",6)
	S LRSPECID="Acc #: "_$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA_",",15,"E")
	S:$L($G(LRUID)) LRSPECID=LRSPECID_"  UID: "_LRUID
	S LREDT=$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA_",",9,"I")
	I LREDT'?7N.E D  Q
	. W !?5,"This accession does not have a Collection Date/Time",!
	. W !?10,"CAN NOT PROCEED",!
	. S LRNOP="6^Not Accessioned"
	I '$G(LRIDT) S LRIDT=+$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA_",",13.5,"I")
	S LRCDT="Collection Date: "_$$FMTE^XLFDT(LREDT,1)
	I '$L($G(LRSS)) S LRSS=$$GET1^DIQ(68,LRAA_",",.02,"I")
	S LRDSSLOC=+$$GET1^DIQ(68,LRAA_",",.8,"I")
	S LRDSSLOC=$S($G(LRDSSLOC):LRDSSLOC,1:LRDLOC)
	D DEM^LRCAPES1
PRO	;Get provider,patient/location information
	S LREND=0
	D
	. N LRPRONM,DIR,DIRUT,DUOUT,X,Y
	. S LRPRONM=$$GET1^DIQ(200,+$G(LRPRO),.01,"I")
	. I $L(LRPRONM),$D(^VA(200,"AK.PROVIDER",LRPRONM,+$G(LRPRO)))#2,$$GET^XUA4A72(+$G(LRPRO),DT)>0 S DIR("B")=LRPRONM
	. ;S DIR("A")="Releasing Pathologist"
	. S DIR("A")="Provider"
	. S LRPRO=0,DIR(0)="PO^200:ENMZ"
	. S DIR("S")="I $D(^VA(200,""AK.PROVIDER"",$P(^(0),U),+Y)),$$GET^XUA4A72(+Y,DT)>0"
	. D ^DIR
	. I Y>1 S LRPRO=+Y
	I '$G(LRPRO) D  D END1 Q
	. W !?5,"No Active Provider Selected",!
	. S LRNOP=1
	I '$D(^LRO(68,LRAA,1,LRAD,1,LRAN,0))#2 D  D END1 G WLN
	. W !?5,"The accession is corrupt - missing zero node",!
	. S LRNOP="7^Corrupt Accession"
LOC	;Reporting Location
	S LRNODE0=^LRO(68,LRAA,1,LRAD,1,LRAN,0)
	S LRNOP=0
	S (LRLLOCX,LRLLOC)=$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA_",",6)
	I $L(LRLLOC) S LRLLOC=+$$FIND1^DIC(44,"","OM",LRLLOC)
ASKLOC	;Check to see if outpatient location
	I '$D(^SC(+$G(LRLLOC),0))#2 D
	. N DIR,X,Y
	. S LRLLOC=""
	. S DIR(0)="PO^44:AEZNMO",DIR("A")=" Ordering Location "
	. D ^DIR
	. I +Y<1 Q
	. S LRLLOC=+Y
	I '$G(LRLLOC) D END1 Q
	S LRDSSID=+$$GET1^DIQ(44,+LRLLOC,8,"I") ;I 'LRDSSID S LRNOP="2^No Stop Code Number" Q
	S LRNINS=$$GET1^DIQ(44,+LRLLOC,3,"I")
	S LRNINS=$S(LRNINS:LRNINS,1:DUZ(2))
	Q
ES()	;Entry point for front end application.
	N DFN,LRESCPT,LRDFN,LRLLOC,LRLLOCX,LRNINS,LRTST,LRENCDT,LRDUZ
	K LRES,LRESCPT
	S LRES=1
ASK	; Option entry point - Check and setup PCE reporting variables
	D EN^LRCAPES1
	N X,Y,T1
	S LREND=0
	D ^LRPARAM Q:$G(LREND)
	K ^TMP("LRPXAPI",$J),^TMP("LR",$J,"LRLST")
	S ^TMP("LR",$J,"LRLST")=$$FMADD^XLFDT(DT,2)_U_DT_U_"LAB ES CPT"
	S:'$G(LRPKG) LRPKG=$O(^DIC(9.4,"B","LR",0))
	S:'$G(LRPKG) LRPKG=$O(^DIC(9.4,"B","LAB SERVICE",0))
PKG	;Check to see if Lab Package is installed
	I '$G(LRPKG) D  D WKL Q
	. W !?5,"LAB SERVICE PACKAGE is not loaded",!
PCE	;Check to see if PCE is turned on
	S X="PXAI" X ^%ZOSF("TEST") I '$T D:'$G(LRES)  D WKL Q
	. W !?5,"PCE Is not installed",!
	S LRPCEON=$$PKGON^VSIT("PX")
	I '$G(LRES),'LRPCEON D  D WKL Q
	. W !?5,"PCE is not turned on",!
	S LRDLOC=+$$GET1^DIQ(69.9,"1,",.8,"I")
OOS	;Check to see if the LRDLOC is an OOS location
	I $G(LRES),$P($G(^SC(LRDLOC,0)),U)'["LAB DIV " D  D WKL Q
	. W !?5,"DEFAULT LAB OOS LOCATION is not defined correctly",!
	S LRESCPT=1
	D:'$G(^TMP("LR",$J,"AK",0,1))'=DUZ_U_DT EN
	I $G(LRES) Q $G(LRESCPT)
LOOP	;
	Q:$G(LREND)
	F  D WLN Q:$G(LREND)  I '$G(LRNOP) D CPTEN Q:$G(LREND)
	D CLEAN Q
CPTEN	;Entry point from CPT API call
WKL	S (LRNOP,LREND)=0 D READ^LRCAPES1
	D DIS^LRCAPES1
	I '$O(^TMP("LR",$J,"LRLST",0)) D END Q
LOAD	;Setup ^TMP("LRPXAPI" to load CPT workload
	K LRXCPT,LRXTST,^TMP("LRPXAPI",$J)
	S LRDUZ=LRPRO
	I '$D(LRSN),'$D(LRSVDCDT) D
	.S LRSN=$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA_",",4,"I")
	.S LRSVDCDT=LRCDT
	.S LRCDT=$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA_",",3,"I")
	I '$G(LRESCPT) S LRNOP="3^PCE Workload Capture Not Setup"
	I $G(LRNOP) D  D SENDWKL Q
	. I '$D(LRQUIET) W !,$$CJ^XLFSTR("PCE Wkld Abort "_$P(LRNOP,U,2),IOM)
	I $G(LRESCPT),'$G(LRNOP) D
	. N AFTER812,D,D0,DDER,DI,DIC,DIG,DIH,DISL,DIV
	. N I,LRACC,LRCNT,LRI,LRPCEN,PXALOOK,PXASUB,PXJ,PXJJ,LRCCT
	. N SDT1,SPEL,SUBL,TYPEI,X,XPARSYS
	. S LRTST=0
	. F  S LRTST=$O(^TMP("LR",$J,"LRLST",LRTST)) Q:LRTST<1  D
	. . S (LRNLTN,CPT)=+$G(^TMP("LR",$J,"LRLST",LRTST)),LRTSTP=$P(^(LRTST),U,2,99)
	. . D SET^LRCAPPH1
	. D ADDPREV
SENDWKL	; Store LMIP workload
	D SEND^LRCAPES1
	L -^LRO(68,LRAA,1,LRAD,1,LRAN)
	S LRNOP=0
	I $D(LRSVDCDT) S LRCDT=LRSVDCDT K LRSN,LRSVDCDT
	Q
ADDPREV	;Add CPT quantities from PCE to current totals
	N LRSTR2,LRIEN2,LRPX,LRCPT,LRXX,LRCPT2,LRCPT1,LRX1,LRQ1,LRQ2,LRQT,LRCT
	S LRSTR2=$G(^LRO(68,LRAA,1,LRAD,1,LRAN,"PCE"))
	Q:'LRSTR2
	K LRVIS S LRVIS=""
	S LRCT=$L(LRSTR2,";")-1,LRVIS=$P(LRSTR2,";",LRCT)
	F LRPX=1:1 S LRIEN2=$P(LRSTR2,";",LRPX) Q:LRIEN2=""  D
	.D GETCPT^PXAPIOE(LRIEN2,"LRCPT","ERR")
	S LRXX=""
	F  S LRXX=$O(LRCPT(LRXX)) Q:LRXX=""  D
	.Q:$P(LRCPT(LRXX),"^",3)'=LRVIS
	.S LRCPT2=""
	.S LRCPT2=+$G(LRCPT(LRXX))
	.D:LRCPT2
	..S (LRX1,LRQT)=0
	..F  S LRX1=$O(^TMP("LRPXAPI",$J,"PROCEDURE",LRX1)) Q:LRX1=""!(LRQT)  D
	...S LRCPT1=+$G(^TMP("LRPXAPI",$J,"PROCEDURE",LRX1,"PROCEDURE"))
	...I LRCPT1=LRCPT2 D
	....S LRQ1=$P(LRCPT(LRXX),"^",16)
	....S LRQ2=+$G(^TMP("LRPXAPI",$J,"PROCEDURE",LRX1,"QTY"))
	....S ^TMP("LRPXAPI",$J,"PROCEDURE",LRX1,"QTY")=LRQ1+LRQ2
	....S LRQT=1
	Q
CLEAN	;Final Cleanup
	K AFTER812,AGE,CPT,D,D0,DOB,DDER,DFN,DI,DIC,DIG,DIH,DIR,DIRUT
	K DISL,DIRUT,DIU,DUOUT,DIV,DQ
	K I,J,LRACC,LRCNT,LRI,POP,PXALOOK,PXASUB,PXJ,PXJJ
	K SDT1,SPEL,SUBL,T1,TYPEI,X,XPARSYS
	K ANS,CLN,CNT,FPRI,LRAA,LRAD,LRAN,LRANSX,LRANSY,LRCDT,LRCNT
	K LRDFN,LRDPF,LRDLOC,LRDSSID,LRDSSLOC,LRDUZ,LREDT,LREND,LRES,LRESCPT
	K LRIDT,LRIDIV,LRLLOC,LRLLOCX,LRLST,LRNINS,LRNLT,LRNLTN,LRNODE0,LRNOP,LROK
	K LRPCEN,LRPCENON,LRPCEVSO,LRPKG,LRPRAC,LRPRO,LRRB,LRQ,LRSS,LRTREA,LRTST,LRURG
	K LRSPECID,LRTSTP,LRUID,LRVBY
	K LRVSITN,LRWRD,LRX,LRXCPT,LRXTST
	K NODE,NODE0,PNM,SEX,SDFLAG,SSN,VA,X1,X2,X3
	K ^TMP("LRMOD",$J)
	K ^TMP("LR",$J,"AK"),^TMP("LR",$J,"LRLST")
	K ^TMP("LRPXAPI",$J)
	D KVAR^VADPT
	Q
CPT(LRAA,LRAD,LRAN,LRPRO)	;AP Release entry point
	;LRAA=accession area, LRAD=accession date, LRAN=accession number
	;LRPRO=provider
	N X,Y,I,LRI,LREDT,LRCDT,LRIDT,LRLLOCX,LRSPECID,DIC,LRNOP,LREND,LRES
	S (LRLLOCX,LRLLOC)=$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA_",",6)
	S DIC=44,DIC(0)="ONM",X=LRLLOC D ^DIC
	I Y>1 S LRLLOC=+Y
	I Y<1 D  Q:$G(LREND)
	. S DIC(0)="AEZNM" D ^DIC
	. I Y<1 S LRNOP="4^Not an outpatient location",LREND=1 Q
	. S LRLLOC=+Y
	;KLL - set LRDSSLOC to LRDLOC, instead of LRLLOC to resolve location
	;      problem occurring in PCE
	;TAC - use accession area OOS location if one exists
	S LRDSSLOC=+$$GET1^DIQ(68,LRAA_",",.8,"I")
	S LRDSSLOC=$S($G(LRDSSLOC):LRDSSLOC,1:+$G(LRDLOC))
	S LRDSSID=+$$GET1^DIQ(44,+LRLLOC,8,"I")
	S LRNINS=$$GET1^DIQ(44,+LRLLOC,3,"I")
	S LRNINS=$S(LRNINS:LRNINS,1:DUZ(2))
	I '$G(LRIDT) S LRIDT=+$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA_",",13.5,"I")
	S LRUID=$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA_",",16)
	S LRLLOCX=$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA_",",6)
	S LRSPECID="Acc #: "_$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA_",",15,"E")
	S:$L($G(LRUID)) LRSPECID=LRSPECID_"  UID: "_LRUID
	S LREDT=$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA_",",9,"I")
	I 'LREDT S LREDT=$$NOW^XLFDT
	S LRCDT="Collection Date: "_$$FMTE^XLFDT(LREDT,1)
	I '$G(LRESCPT) D  Q
	. D EN^DDIOL("CPT workload is not activated","","!?20")
	I $S('$G(LRAA):1,'$G(LRAD):1,'$G(LRAN):1,'$G(LRPRO):1,1:0) Q
	I +$G(^LRO(68,LRAA,1,LRAD,1,LRAN,0))'=LRDFN Q
	D CPTEN
	Q
