GMTSPXOP	; SLC/SBW,KER - PCE Outpatient Encounter comp ;07/19/13  11:48
	;;2.7;Health Summary;**8,10,28,37,47,49,76,101**;Oct 20, 1995;Build 12
	;
	; External References
	;    DBIA  1238  VISIT^PXRHS01
	;    DBIA  1996  $$MOD^ICPTMOD
	;    DBIA 10103  $$DT^XLFDT
	;    DBIA 10011  ^DIWP
	;
PURPOSE	; Encounters with ICD9 and providers
	N DTYPE S DTYPE="DP" D MAIN Q
OUTPT	; Encounters with ICD9, CPT, and providers
	N DTYPE S DTYPE="CDP" D MAIN Q
MAIN	; Entry for Purpose of Visit and Outpatient Encounters
	N GMTSIVD,GMTSDAT,GMTSDTU,GMTSOVT,GMTSLOC,DIWL,GMTAB,GMTSN,GMCKP,GMTSX
	N GMTSITE,GMTSINS,GMTSEVT,GMTSHIS,GMTSICL,GMTSLOC,GMTSELIG,X,GMTSVDF
	N GMTSCPTM,GMICL
	;
	; GMTSCPTM    Component uses CPT Modifiers 1 yes 0 no
	S GMTSCPTM=+($$CPT^GMTSU(+($G(GMTSEGN)))) S:$G(GMPXCMOD)="N" GMTSCPTM=0
	; GMTSICL     # of blank left columns for support data of a visit
	S GMTSICL=14
	; DIWL        Used in TXTFMT call & to print returned data
	S DIWL=0
	; GMTAB       Used to offset data from TXTFMT call after 1st line
	S GMTAB=2
	; GMTSOVT     This is the set of Service Categories for AICTSORE
	;
	;                A  Ambulatory
	;                I  Inpatient
	;                C  Chart Review
	;                T  Telecommunications
	;                S  Day Surgery
	;                O  Observation
	;                R  Nursing Home Encounters
	;                E  Event (Historical)
	;
	;            Note:  Hospitalization and Ancillary
	;                   encounters are not included
	S GMTSOVT="AICTSORE"
	;
	D VISIT^PXRHS01(DFN,GMTSEND,GMTSBEG,GMTSNDM,GMTSOVT,DTYPE,1)
	Q:'$D(^TMP("PXHSV",$J))
	S GMTSIVD=0
	F  S GMTSIVD=$O(^TMP("PXHSV",$J,GMTSIVD)) Q:GMTSIVD']""  D  Q:$D(GMTSQIT)
	. S GMTSVDF=0
	. F  S GMTSVDF=$O(^TMP("PXHSV",$J,GMTSIVD,GMTSVDF)) Q:GMTSVDF'>0  D  Q:$D(GMTSQIT)
	. . S GMTSN=$G(^TMP("PXHSV",$J,GMTSIVD,GMTSVDF,0))
	. . S GMTSEVT=$P(GMTSN,U,4),GMTSHIS=$S(GMTSEVT["HISTORICAL":1,1:0)
	. . S X=$P(GMTSN,U,1) D REGDT4^GMTSU S GMTSDAT=X
	. . S GMTSDTU=0,(GMTSITE,GMTSLOC)=""
	. . S GMTSINS=$S($P(GMTSN,U,3)]"":$E($P(GMTSN,U,3),1,10),$P(GMTSN,U,8)]"":$E($P(GMTSN,U,8),1,10),1:""),GMTSITE=GMTSINS
	. . I $G(GMPXHLOC)'="N" S GMTSLOC=$E($P(GMTSN,U,6),1,30)
	. . I '$L(GMTSLOC) S GMTSLOC=$P(GMTSN,U,9)
	. . S GMTSELIG=$E($P(GMTSN,U,12),1,17)
	. . S:GMTSITE=""&('GMTSHIS) GMTSLOC=""
	. . I GMTSHIS D
	. . . S:GMTSLOC'=""&(GMTSITE'="") GMTSLOC=GMTSLOC_" (Historical Event)"
	. . . S:GMTSLOC=""&(GMTSITE'="") GMTSITE=GMTSITE_" (Historical Event)"
	. . . S:GMTSLOC'=""&(GMTSITE="") GMTSITE=GMTSLOC_" (Historical Event)",GMTSLOC=""
	. . . S:GMTSLOC=""&(GMTSITE="") GMTSITE="Historical Event"
	. . D CKP^GMTSUP Q:$D(GMTSQIT)  D DSPVIS,DSPPROV Q:$D(GMTSQIT)
	. . D DSPPOV Q:$D(GMTSQIT)  D DSPCPT W !
	K ^TMP("PXHSV",$J)
	Q
	;
DSPPOV	; Display Purpose of visit
	Q:$O(^TMP("PXHSV",$J,GMTSIVD,GMTSVDF,"D",""))=""
	Q:$G(GMPXICDF)="N"&($G(GMPXNARR)="N")
	N GMTSN,GMTSMOD,GMTSICD,GMTSNARR,GMTSPDN,GMTS,GMTSQTY,GMTSPRI,COMMENT,GMTSICDT
	D CKP^GMTSUP Q:$D(GMTSQIT)  D DSPVIS W ?3,"Diagnosis:"
	S GMCKP=0,GMTSPDN="",GMTSQTY=""
	F  S GMTSPDN=$O(^TMP("PXHSV",$J,GMTSIVD,GMTSVDF,"D",GMTSPDN)) Q:GMTSPDN'>0  D  Q:$D(GMTSQIT)
	. S GMTSICDT=$P(^TMP("PXHSV",$J,GMTSIVD,GMTSVDF,0),U)
	. S GMTSN=$G(^TMP("PXHSV",$J,GMTSIVD,GMTSVDF,"D",GMTSPDN))
	. S GMTSMOD=$P(GMTSN,U,2)
	. S GMTSICD=$P(GMTSN,U) D GETICDDX^GMTSPXU1(.GMTSICD,$G(GMPXICDF),GMTSMOD,GMTSICDT,"DIAG")
	. S GMTSNARR=""
	. S:$G(GMPXNARR)'="N" GMTSNARR=$G(^TMP("PXHSV",$J,GMTSIVD,GMTSVDF,"D",GMTSPDN,"N"))
	. I $P(GMTSICD,"-",2,10)=$G(GMTSNARR) S GMTSNARR=""
	. S GMTSPRI="" I $P(GMTSN,U,5)]"",$E($P(GMTSN,U,5),1)="P" S GMTSPRI=" (P)"
	. S GMTSICD=$P(GMTSICD,"-",2,10)_" ("_$$GETICDCD^GMTSPXU1(GMTSICDT,"DIAG")_"-CM "_$P(GMTSICD,"-",1)_")"
	. D TXTFMT^GMTSPXU1(GMTSICD,$G(GMTSNARR),GMTSICL,GMTAB,DIWL,GMTSQTY,GMTSPRI)
	. I '$D(^UTILITY($J,"W")) Q
	. S GMTSX=0
	. F  S GMTSX=$O(^UTILITY($J,"W",DIWL,GMTSX)) Q:GMTSX'>0!$D(GMTSQIT)  D
	. . I GMCKP>0 D CKP^GMTSUP Q:$D(GMTSQIT)  D DSPVIS
	. . S GMCKP=1
	. . W ?GMTSICL+$S(GMTSX>1:GMTAB,1:0),$G(^UTILITY($J,"W",DIWL,GMTSX,0)),!
	. S COMMENT="",COMMENT=$P($G(^TMP("PXHSV",$J,GMTSIVD,GMTSVDF,"D",GMTSPDN,"COM")),U)
	. I COMMENT]"" S GMICL=20,GMTAB=2 D FORMAT I $D(^UTILITY($J,"W")) D
	. . F GMTSLN=1:1:^UTILITY($J,"W",DIWL) D LINE Q:$D(GMTSQIT)
	Q
DSPCPT	; Display Procedures performed during the visit
	Q:$O(^TMP("PXHSV",$J,GMTSIVD,GMTSVDF,"C",""))=""
	N GMTSNARR,GMTSPDN,GMTSN,GMTSICD,GMTSNARR,GMTSCPT,GMTSQTY,GMTSPRIM,GMTSPRI,GMTSFLG,GMTSICDT
	D CKP^GMTSUP Q:$D(GMTSQIT)  D DSPVIS W ?3,"Procedure:"
	S GMCKP=0,GMTSPDN="",GMTSPRI=""
	F  S GMTSPDN=$O(^TMP("PXHSV",$J,GMTSIVD,GMTSVDF,"C",GMTSPDN)) Q:GMTSPDN'>0  D  Q:$D(GMTSQIT)
	. S GMTSICDT=$P(^TMP("PXHSV",$J,GMTSIVD,GMTSVDF,0),U)
	. S GMTSN=$G(^TMP("PXHSV",$J,GMTSIVD,GMTSVDF,"C",GMTSPDN))
	. S GMTSNARR=$P(GMTSN,U,2),GMTSQTY=$P(GMTSN,U,3),GMTSPRIM=$P(GMTSN,U,4)
	. S GMTSCPT=$$GETCPT^GMTSPXU1($P(GMTSN,U)) I $P(GMTSCPT,"-",2,10)=GMTSNARR S GMTSNARR=""
	. S GMTSPRI="" S:$G(GMTSQTY)]"" GMTSQTY=" ("_GMTSQTY_")" S:$G(GMTSPRIM)="Y" GMTSPRI="(P)"
	. S GMTSFLG=1
	. D TXTFMT^GMTSPXU1(GMTSCPT,GMTSNARR,GMTSICL,GMTAB,DIWL,GMTSQTY,GMTSPRI)
	. Q:'$D(^UTILITY($J,"W"))  D DCPT
	Q
DCPT	; Display CPT Comments
	N GMTSLN,GMTSMOK,GMTSX S (GMTSMOK,GMTSX)=0
	F  S GMTSX=$O(^UTILITY($J,"W",DIWL,GMTSX)) Q:GMTSX'>0  D  Q:$D(GMTSQIT)
	. I GMCKP>0 D CKP^GMTSUP Q:$D(GMTSQIT)  D DSPVIS Q:$D(GMTSQIT)
	. S (GMTSMOK,GMCKP)=1 W ?GMTSICL+$S(GMTSX>1:GMTAB,1:0)
	. W $G(^UTILITY($J,"W",DIWL,GMTSX,0))
	. D CKP^GMTSUP Q:$D(GMTSQIT)  W !
	Q:DTYPE="DP"
	S COMMENT=$P($G(^TMP("PXHSV",$J,GMTSIVD,GMTSVDF,"C",GMTSPDN,"COM")),U)
	I COMMENT]"" S GMICL=20,GMTAB=2 D FORMAT I $D(^UTILITY($J,"W")) D
	. F GMTSLN=1:1:^UTILITY($J,"W",DIWL) D  Q:$D(GMTSQIT)
	. . I GMTSFLG=1 W !,?10,"Comments:" S GMTSFLG=0
	. . D LINE
	S:+($G(GMTSCPTM))=0 GMTSMOK=0 D:GMTSMOK DMOD
	Q
DMOD	; Display CPT Modifier Comments
	N GMTSM S GMTSM=""
	W !
	F  S GMTSM=$O(^TMP("PXHSV",$J,GMTSIVD,GMTSVDF,"C",GMTSPDN,GMTSM)) Q:GMTSM=""  D  Q:$D(GMTSQIT)
	. I GMTSM="COM" Q
	. N COMMENT S COMMENT=$$FCM(GMTSM) Q:'$L(COMMENT)
	. S GMICL=26,GMTAB=2 D FORMAT I $D(^UTILITY($J,"W")) D
	. . F GMTSLN=1:1:^UTILITY($J,"W",DIWL) D LINE2 Q:$D(GMTSQIT)
	Q
DSPPROV	; Display Providers for visit
	Q:$O(^TMP("PXHSV",$J,GMTSIVD,GMTSVDF,"P",""))=""
	N GMCNT,GMPROV
	D ORDERPRO^GMTSPXU1(.GMPROV,20)
	D CKP^GMTSUP Q:$D(GMTSQIT)  D DSPVIS W ?3," Provider:"
	S GMCNT=0
	F  S GMCNT=$O(GMPROV(GMCNT)) Q:GMCNT'>0  D  Q:GMCNT'>0!$D(GMTSQIT)
	. I GMCNT>1 D CKP^GMTSUP Q:$D(GMTSQIT)  D DSPVIS
	. W ?GMTSICL,GMPROV(GMCNT) S GMCNT=$O(GMPROV(GMCNT)) Q:GMCNT'>0
	. W ?37,GMPROV(GMCNT) S GMCNT=$O(GMPROV(GMCNT)) Q:GMCNT'>0
	. W ?60,GMPROV(GMCNT)
	. D CKP^GMTSUP Q:$D(GMTSQIT)  W:$O(GMPROV(GMCNT)) !
	D CKP^GMTSUP Q:$D(GMTSQIT)  W !
	Q
DSPVIS	; Display outpatient visit data
	Q:GMTSNPG'>0&(GMTSDTU>0)  D:GMTSNPG HDR I GMTSNPG!(+GMTSDTU'>0) D
	. W GMTSDAT,?14,GMTSITE,?29,GMTSLOC,?61,GMTSELIG
	. D CKP^GMTSUP Q:$D(GMTSQIT)  W !
	. S GMTSDTU=1
	Q
HDR	; Display header
	W ?3,"Date",?14,"Facility",?29,"Hospital Location",?61,"Encounter Elig.",!!
	Q
FORMAT	; Formats Diagnosis/Procedure line of text
	N DIWR,DIWF,X S DIWL=3,DIWR=80-(GMICL+GMTAB) K ^UTILITY($J,"W") S X=COMMENT D ^DIWP
	Q
FCM(X)	; Format CPT Modifier comment
	N Y,%,%H,GMTSIEN,GMTSC,GMTSS,GMTST S GMTSIEN=$G(X) Q:GMTSIEN="" ""
	S:'$D(DT)!(+($G(DT))=0) DT=$$DT^XLFDT
	S X=$$MOD^ICPTMOD(GMTSIEN,"E",) Q:'$D(X)
	S GMTSC=$P(X,"^",2),GMTSS=$P(X,"^",3)
	S GMTST=$$EN2^GMTSUMX(GMTSS) S Y=""
	S:$L(GMTST)&($L(GMTSC)) Y=GMTSC_"-"_GMTST
	S:'$L(GMTST)&($L(GMTSS))&($L(GMTSC)) Y=GMTSC_"-"_GMTSS
	S:'$L(GMTST)&('$L(GMTSS))&($L(GMTSC)) Y=GMTSC
	S:Y["-" Y="Modifier "_Y S X=Y
	Q X
LINE	; Writes formatted lines
	D CKP^GMTSUP Q:$D(GMTSQIT)  W ?20,^UTILITY($J,"W",DIWL,GMTSLN,0),! Q
LINE2	; Writes indented formatted lines
	D CKP^GMTSUP Q:$D(GMTSQIT)  N GMTST S GMTST=20 S:+($G(GMTSLN))>1 GMTST=31 W ?GMTST,^UTILITY($J,"W",DIWL,GMTSLN,0),! Q
