GMPLNTFT	;ISL/JER - Freetext Problem Follow-up Report ;07/09/12  11:45
	;;2.0;Problem List;**36**;Aug 25, 1994;Build 65
	;
	; ICR #2055     - $$EXTERNAL^DILFD
	;     #2056     - $$GET1^DIQ
	;     #3799     - $$FMTE^XLFDT
	;     #4558     - $$LEAP^XLFDT3
	;     #4631     - $$NOW^XLFDT
	;     #10000    - %, %I, %T, %Y Local vars
	;     #10063    - ^%ZTLOAD
	;     #10086    - ^%ZIS Routine & IO, IOF, ION, IOSL, & IOST Local Vars
	;     #10089    - ^%ZISC Routine & IO("Q") Local Var
	;     #10104    - $$LOW^XLFSTR, $$UP^XLFSTR
	;     #10112    - $$NAME^VASITE, $$SITE^VASITE
	;     #10114    - %ZIS Local Var
	;
MAIN	; Main subroutine
	N DIC,DIRUT,BADDIV,SELDIV,GMPLEDT,GMPLLDT,GMPLDI,VAUTD,ZTRTN,%I,%T,%Y,POP,GMPL1PR,GMPLPR,GMPLPCOM
	S GMPLPR=0
	W !!,$$CENTER^GMPLUTL1("--- Problem List Freetext Follow-up Report ---"),!
	D SELDIV^GMPLNTRT(.GMPLDI) Q:'$D(GMPLDI)!$D(DIRUT)
	W !
	S GMPL1PR=$$READ^GMPLUTL1("YA","Specific Provider(s)? ","NO","Indicate whether you would like to run the report for one or more specific Providers.")
	I $D(DIRUT) Q
	I +GMPL1PR D PROVSEL^GMPLNTRT(.GMPLPR) Q:'+$G(GMPLPR)!+$G(DIROUT)
	W !
	S GMPLPCOM=$$READ^GMPLUTL1("YA","Print Comments? ","YES","Indicate whether you would like to see the users' comments for New Term Requests.")
	I $D(DIRUT) Q
	W !
	S GMPLEDT=+$$EDATE^GMPLUTL1("Modification","","T-30")
	W !
	I GMPLEDT'>0 Q
	S GMPLLDT=+$$LDATE^GMPLUTL1("Modification","","NOW")
	W !
	I GMPLLDT'>0 Q
	S ZTRTN="ENTRY^GMPLNTFT"
DEVICE	; Device handling
	; Call with: ZTRTN
	N %ZIS
	S %ZIS="Q" D ^%ZIS Q:POP
	G:$D(IO("Q")) QUE
NOQUE	; Call report directly
	D @ZTRTN
	Q
QUE	; Queue output
	N %,ZTDTH,ZTIO,ZTSAVE,ZTSK
	Q:'$D(ZTRTN)
	K IO("Q") F %="DA","DFN","GMPL*" S ZTSAVE(%)=""
	S:'$D(ZTDESC) ZTDESC="PRINT NTRT FOLLOW-UP REPORT" S ZTIO=ION
	D ^%ZTLOAD W !,$S($D(ZTSK):"Request Queued!",1:"Request Cancelled!")
	K ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE
	D HOME^%ZIS
	Q
	;
ENTRY	; Build & Print Report
	N GMPLA
	S GMPLA=$NA(^TMP("GMPLNTRT",$J))
	U IO
	D GATHER(.GMPLDI,GMPLA,GMPLEDT,GMPLLDT,.GMPLPR)
	D REPORT(GMPLA,GMPLEDT,GMPLLDT,GMPLPCOM)
	K @GMPLA
	D ^%ZISC
	Q
GATHER(GMPLDI,GMPLA,GMPLEDT,GMPLLDT,GMPLPR)	; Gather records that satisfy criteria
	N GMPLDA,GMPLNOS,GMPLPOP  K @GMPLA
	S GMPLNOS=+$$NOS^GMPLX,GMPLDA="",GMPLPOP=0
	; Insure inclusive early date/time by subtracting one minute before $ORDER
	;S GMPLTDT=$$FMADD^XLFDT(GMPLEDT,0,0,-1)
	; Insure inclusive end date/time by appending time of 23:59 if time not indicated
	I $L(GMPLLDT,".")=1 S $P(GMPLLDT,".",2)="2359"
	F  S GMPLDA=$O(^AUPNPROB("B",GMPLNOS,GMPLDA),-1) Q:+GMPLPOP!(+GMPLDA'>0)  D
	. N GMPLD0,GMPLD1,GMPLD800,GMPLD8015,GMPLDIV,GMPLMDT,GMPLRPR,GMPLPTNM,GMPLPTL4,GMPLNARR
	. N GMPLSVC,GMPLSVCA,GMPLSVCN,GMPLCL,GMPLCLA,GMPLCLN,GMPLNTRT,GMPLNTC
	. S GMPLD0=$G(^AUPNPROB(GMPLDA,0)),GMPLD1=$G(^(1)),GMPLD800=$G(^(800)),GMPLD801=$G(^(801))
	. ; Filter problems with unmapped SCT Concepts
	. Q:+GMPLD800>0
	. S GMPLMDT=$P(GMPLD0,U,3)
	. I GMPLMDT<GMPLEDT S GMPLPOP=1 Q
	. I GMPLMDT>GMPLLDT Q
	. S GMPLRPR=$P(GMPLD1,U,5),GMPLDIV=$P(GMPLD0,U,6),GMPLPTNM=$P(GMPLD0,U,2)
	. I +$G(GMPLPR),'$D(GMPLPR("I",+GMPLRPR)) Q
	. I $S(GMPLDI("ENTRIES")="ALL DIVISIONS":0,$D(GMPLDI("INST",+GMPLDIV)):0,1:1) Q
	. S GMPLSVC=$P(GMPLD1,U,6),GMPLCL=$P(GMPLD1,U,8)
	. S GMPLSVCA=$S(GMPLSVC]"":$E($$GET1^DIQ(49,GMPLSVC,1),1,6),1:"n/a")
	. S GMPLSVCN=$S(GMPLSVC]"":$E($$GET1^DIQ(49,GMPLSVC,.01),1,6),1:"n/a")
	. S GMPLSVCA=$S(GMPLSVCA]"":GMPLSVCA,1:GMPLSVCN)
	. S GMPLCLA=$S(GMPLCL]"":$E($$GET1^DIQ(44,GMPLCL,1),1,6),1:"n/a")
	. S GMPLCLN=$S(GMPLCL]"":$E($$GET1^DIQ(44,GMPLCL,.01),1,6),1:"n/a")
	. S GMPLCLA=$S(GMPLCLA]"":GMPLCLA,1:GMPLCLN)
	. S GMPLDIV=$S(GMPLDIV]"":$$EXTERNAL^DILFD(9000011,.06,"",GMPLDIV),1:"DIVISION UNKNOWN")
	. S GMPLRPR=$S(GMPLRPR]"":$$EXTERNAL^DILFD(9000011,1.05,"",GMPLRPR),1:"n/a")
	. S GMPLNARR=$$EXTERNAL^DILFD(9000011,.05,"",$P(GMPLD0,U,5))
	. S GMPLPTL4=$E($$GET1^DIQ(2,$P(GMPLD0,U,2),.09),6,9) S:GMPLPTL4']"" GMPLPTL4="UNKN"
	. S GMPLPTNM=$$EXTERNAL^DILFD(9000011,.02,"",$P(GMPLD0,U,2))_"|"_GMPLPTL4
	. S GMPLNTRT=$S(+$P(GMPLD801,U):"True",1:"False"),GMPLNTC=$P(GMPLD801,U,2)
	. S @GMPLA@(GMPLDIV,GMPLRPR,GMPLPTNM,GMPLMDT,GMPLDA)=GMPLNARR_U_GMPLSVCA_U_GMPLCLA_U_GMPLNTRT_U_GMPLNTC
	Q
REPORT(GMPLA,GMPLEDT,GMPLLDT,GMPLPCOM)	; Generate report
	N GMPLDIV,GMPLRTM,DIRUT,DTOUT,DUOUT,GMPLSITE,GMPLCAT,GMPLI,GMPLPG
	N GMPLSHDR,EQLN S $P(EQLN,"-",11)="",GMPLPG=0,GMPLPCOM=+$G(GMPLPCOM)
	I $D(ZTQUEUED) S ZTREQ="@" ; Tell TaskMan to delete Task log entry
	U IO
	S GMPLRTM=$$NOW^XLFDT,GMPLSITE=$S($$NAME^VASITE]"":$$NAME^VASITE,1:$P($$SITE^VASITE,U,2))
	I '$D(@GMPLA) D  Q
	. D HEADER("",GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG)
	. W:$$CONTINUE("",GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG) !
	. W:$$CONTINUE("",GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG) "No Freetext Problems found for selected parameters...",!
	. I ($E(IOST)="C"),($E(IOSL,1,3)'=999) S:'+$$STOP^GMPLUTL1("",1) DIRUT=1
	S GMPLDIV=0
	F  S GMPLDIV=$O(@GMPLA@(GMPLDIV)) Q:GMPLDIV']""  D  Q:$D(DIRUT)
	. N GMPLRPR S GMPLRPR=""
	. D HEADER(GMPLDIV,GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG)
	. F  S GMPLRPR=$O(@GMPLA@(GMPLDIV,GMPLRPR)) Q:GMPLRPR']""  D  Q:$D(DIRUT)
	. . N GMPLPT S GMPLPT=0
	. . F  S GMPLPT=$O(@GMPLA@(GMPLDIV,GMPLRPR,GMPLPT)) Q:GMPLPT']""  D  Q:$D(DIRUT)
	. . . N GMPLMDT S GMPLMDT=0
	. . . F  S GMPLMDT=$O(@GMPLA@(GMPLDIV,GMPLRPR,GMPLPT,GMPLMDT)) Q:+GMPLMDT'>0  D  Q:$D(DIRUT)
	. . . . N GMPLDA S GMPLDA=0
	. . . . F  S GMPLDA=$O(@GMPLA@(GMPLDIV,GMPLRPR,GMPLPT,GMPLMDT,GMPLDA)) Q:+GMPLDA'>0  D  Q:$D(DIRUT)
	. . . . . N GMPLD,GMPLNARR,GMPLPRNM,GMPLPTNM,GMPLSVC,GMPLCLOC,GMPLNTRT,GMPLNTC
	. . . . . S GMPLD=$G(@GMPLA@(GMPLDIV,GMPLRPR,GMPLPT,GMPLMDT,GMPLDA))
	. . . . . S GMPLNARR=$P(GMPLD,U),GMPLSVC=$P(GMPLD,U,2),GMPLCLOC=$P(GMPLD,U,3),GMPLNTRT=$P(GMPLD,U,4),GMPLNTC=$P(GMPLD,U,5)
	. . . . . I +$$CONTINUE(GMPLDIV,GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG)'>0!$D(DIRUT) Q
	. . . . . W $E($$NAME^GMPLUTL1(GMPLRPR,"LAST"),1,10),$$NAME^GMPLUTL1(GMPLRPR,",FI MI")
	. . . . . W ?16,$E($$NAME^GMPLUTL1($P(GMPLPT,"|"),"LAST"),1,10),$$NAME^GMPLUTL1($P(GMPLPT,"|"),",FI MI"),?31," (",$P(GMPLPT,"|",2),")"
	. . . . . W ?40,$$DATE^GMPLUTL1(GMPLMDT,"MM/DD/YY"),?50,GMPLSVC,?58,GMPLCLOC,?70,GMPLNTRT,!
	. . . . . I +$$CONTINUE(GMPLDIV,GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG)'>0!$D(DIRUT) Q
	. . . . . W ?2,GMPLNARR,!
	. . . . . Q:$D(DIRUT)
	. . . . . I GMPLPCOM,(GMPLNTC]"") D
	. . . . . . I +$$CONTINUE(GMPLDIV,GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG)'>0!$D(DIRUT) Q
	. . . . . . W "Comments: ",!
	. . . . . . I +$$CONTINUE(GMPLDIV,GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG)'>0!$D(DIRUT) Q
	. . . . . . W GMPLNTC,!
	. . . . . . I +$$CONTINUE(GMPLDIV,GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG)'>0!$D(DIRUT) Q
	. . . . . . W !
	. . . . . E  Q:(+$$CONTINUE(GMPLDIV,GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG)'>0)!$D(DIRUT)  W !
	. Q:$D(DIRUT)
	. I ($E(IOST)="C"),($E(IOSL,1,3)'=999) S:'+$$STOP^GMPLUTL1("",1) DIRUT=1
	Q
CONTINUE(GMPLDIV,GMPLRTM,GMPLEDT,GMPLLDT,GMPLPG)	; Evaluate relative page position
	N GMPLY S GMPLY=1
	I $Y'>(IOSL-3) G CONTX
	I $E(IOST)="C" S GMPLY=+$$READ^GMPLUTL1("E") S:$D(DIRUT) GMPLY=0
	I GMPLY'>0 G CONTX
	D HEADER(GMPLDIV,GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG)
CONTX	Q GMPLY
HEADER(DIVISION,GMPLRTM,GMPLEDT,GMPLLDT,GMPLPG)	; Write Report Header
	N GMPLLINE,GMPLDTR S $P(GMPLLINE,"=",81)="",GMPLDTR=$$DATE^GMPLUTL1(GMPLEDT,"MM/DD/CCYY")_" to "_$$DATE^GMPLUTL1(GMPLLDT,"MM/DD/CCYY")
	S GMPLPG=GMPLPG+1
	W @IOF D JUSTIFY^GMPLUTL1("Page "_GMPLPG,"R") W !
	W GMPLLINE,! D JUSTIFY^GMPLUTL1($$TITLE^GMPLUTL1("PROBLEM LIST FREETEXT FOLLOW-UP REPORT"),"C") W !
	D JUSTIFY^GMPLUTL1(DIVISION,"C")
	W !
	W "for Problems Modified: ",GMPLDTR,?55,"Printed: ",$$DATE^GMPLUTL1(GMPLRTM,"MM/DD/CCYY HR:MIN"),!
	W !
	W "Provider",?16,"Patient",?40,"Modified",?50,"Service",?58,"Clinic",?70,"NTRT",!
	W ?2,"Narrative",?70,"Requested",!
	W GMPLLINE,!
	Q
