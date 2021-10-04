GMPLNTRT	;ISL/JER - Problem List NTRT Mapping Follow-up Report ;06/08/12  13:55
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
	N DIC,DIRUT,BADDIV,SELDIV,GMPLEDT,GMPLLDT,GMPLNTST,GMPLDI,VAUTD,ZTRTN,%I,%T,%Y,POP,GMPL1PR,GMPLPR,GMPLPCOM
	S GMPLPR=0
	W !!,$$CENTER^GMPLUTL1("--- Problem List NTRT Mapping Follow-up Report ---"),!
	D SELDIV(.GMPLDI) Q:'$D(GMPLDI)!$D(DIRUT)
	W !
	S GMPLNTST=$P($$READ^GMPLUTL1("SA^0:All;1:Pending;2:Completed","NTRT Status? ","ALL","Indicate the NTRT Status for the report."),U)
	I $D(DIRUT) Q
	W !
	S GMPL1PR=$$READ^GMPLUTL1("YA","Specific Provider(s)? ","NO","Indicate whether you would like to run the report for one or more specific Providers.")
	I $D(DIRUT) Q
	I +GMPL1PR D PROVSEL(.GMPLPR) Q:'+$G(GMPLPR)!+$G(DIROUT)
	W !
	S GMPLEDT=+$$EDATE^GMPLUTL1("Modification","","T-30")
	W !
	I GMPLEDT'>0 Q
	S GMPLLDT=+$$LDATE^GMPLUTL1("Modification","","NOW")
	W !
	I GMPLLDT'>0 Q
	S ZTRTN="ENTRY^GMPLNTRT"
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
PROVSEL(GMPLY)	; Select Providers
	N DIRUT,GMPLQUIT,GMPLPRSN,GMPLI,GMPLPRMT,GMPLVBCUC,GMPLSCRN,GMPLHLP S (GMPLY,GMPLI,GMPLQUIT)=0
	; Identify User Class for VBC Line Count
	S GMPLHLP="Please choose a KNOWN Provider (Duplicates not allowed)."
	S GMPLSCRN="I '$D(GMPLY(""I"",+Y)),$$CLINUSER^ORQQPL1(+Y)"
	W !!,"Select Provider(s):",!
	F  D  Q:+GMPLQUIT
	. S GMPLI=GMPLI+1,GMPLPRMT=$J(GMPLI,3)_")  "
	. S GMPLPRSN=$$READ^GMPLUTL1("PAO^200:AEMQ",GMPLPRMT,"",GMPLHLP,GMPLSCRN)
	. I +GMPLPRSN'>0 S GMPLQUIT=1 Q
	. S GMPLY=GMPLI,GMPLY(GMPLI)=GMPLPRSN,GMPLY("I",+GMPLPRSN)=GMPLI
	W !
	Q
SELDIV(GMPLDI)	; Select divisions
	;
	; Output - SELDIV  -1= user ^ at prompt if multidivisional
	;                   0= institution file pointer missing for
	;                      division entry
	;                   1= successful division selection
	;          BADDIV    = comma-delimited list of bad divisions (if any)
	;          GMPLDI(  undefined= user <cr> for all divisions or ^ at prompt
	;                             if multidivisional
	;                  defined= user selected one or more divisions if
	;                           multidivisional, or pre-selection of
	;                           division file entry if not multidivisional;
	;                           i.e.: GMPLDI(file #40.8 ien)= Institution
	;                           file pointer for file #40.8 entry
	N DIRUT,DTOUT,DUOUT,GMPLI,VAUTD,Y
	K SELDIV,GMPLDI,BADDIV
	; -- Determine if facility is multidivisional
	I $P($G(^DG(43,1,"GL")),U,2) D
	. D DIVISION^VAUTOMA
	. I Y<0 S SELDIV=-1 Q
	. I VAUTD=1 S SELDIV=1 Q
	. S GMPLI=0 F  S GMPLI=$O(VAUTD(GMPLI)) Q:'GMPLI  D ONE(GMPLI,.VAUTD,.GMPLDI)
	E  S GMPLI=$$PRIM^VASITE D ONE(GMPLI,.VAUTD)
	Q:SELDIV=-1
	I +SELDIV=0 D  Q:'$D(GMPLDI)
	. W !!,"Inconsistencies found between the MEDICAL CENTER DIVISION FILE, the INSTITUTION"
	. W !,"FILE and/or STATION NUMBER (TIME SENSITIVE) FILE for the:",!!,$S($G(BADDIV)]"":BADDIV_" division"_$S($L(BADDIV,",")>1:"s",1:""),1:"a division you selected"),"."
	. W !!,"Please contact the National Support team."
	. I '$D(GMPLDI) W ! S:'$$READ^GMPLUTL1("E") DIRUT=1
	I $D(GMPLDI) D
	. N GMPLK
	. S GMPLK=0 F  S GMPLK=$O(GMPLDI(GMPLK)) Q:'GMPLK  D
	. . S GMPLDI("INST",GMPLDI(GMPLK))=GMPLK
	. . S GMPLDI("ENTRIES")=$G(GMPLDI("ENTRIES"))_GMPLK_";"
	E  S GMPLDI("ENTRIES")="ALL DIVISIONS"
	Q
	;
ONE(GMPLI,VAUTD,GMPLDI)	; Input - GMPLI  Medical Center Division file (#40.8) IEN
	N GMPLIFP
	S GMPLIFP=$P($$SITE^VASITE(,GMPLI),U) I GMPLIFP>0 D
	. S GMPLDI(GMPLI)=GMPLIFP,SELDIV=1
	E  D
	. S SELDIV=0,BADDIV=$G(BADDIV)_$S($L($G(BADDIV)):", ",1:"")_$G(VAUTD(GMPLI))
	Q
	;
ENTRY	; Build & Print Report
	N GMPLA
	S GMPLA=$NA(^TMP("GMPLNTRT",$J))
	U IO
	D GATHER(.GMPLDI,GMPLA,GMPLEDT,GMPLLDT,GMPLNTST,.GMPLPR)
	D REPORT(GMPLA,GMPLEDT,GMPLLDT)
	K @GMPLA
	D ^%ZISC
	Q
GATHER(GMPLDI,GMPLA,GMPLEDT,GMPLLDT,GMPLNTST,GMPLPR)	; Gather records that satisfy criteria
	N GMPLDA,GMPLDT,GMPLNOS,GMPLPOP,GMPLST0,GMPLST1  K @GMPLA
	S GMPLNOS=+$$NOS^GMPLX,GMPLDA="",GMPLPOP=0
	S GMPLST0=$S(GMPLNTST=0:1,1:GMPLNTST),GMPLST1=$S(GMPLNTST=0:2,1:GMPLNTST)
	; Insure inclusive early date/time by subtracting one minute before $ORDER
	S GMPLDT=$$FMADD^XLFDT(GMPLEDT,0,0,-1)
	; Insure inclusive end date/time by appending time of 23:59 if time not indicated
	I $L(GMPLLDT,".")=1 S $P(GMPLLDT,".",2)="2359"
	F  S GMPLDT=$O(^AUPNPROB("DM",GMPLDT)) Q:(+GMPLDT>GMPLLDT)!(+GMPLDT'>0)  D  Q:+GMPLPOP
	. N GMPLSTI F GMPLSTI=GMPLST0:1:GMPLST1 D  Q:+GMPLPOP
	. . N GMPLDA S GMPLDA=0
	. . F  S GMPLDA=$O(^AUPNPROB("DM",GMPLDT,GMPLSTI,GMPLDA)) Q:+GMPLDA'>0  D  Q:+GMPLPOP
	. . . N GMPLD0,GMPLD1,GMPLD800,GMPLDIV,GMPLMDT,GMPLRPR,GMPLPTNM,GMPLPTL4,GMPLNARR
	. . . N GMPLSVC,GMPLSVCA,GMPLSVCN,GMPLCL,GMPLCLA,GMPLCLN,GMPLSCTC,GMPLSTAT
	. . . S GMPLD0=$G(^AUPNPROB(GMPLDA,0)),GMPLD1=$G(^(1)),GMPLD800=$G(^(800))
	. . . S GMPLMDT=$P(GMPLD0,U,3)
	. . . I GMPLMDT<GMPLEDT S GMPLPOP=1 Q
	. . . I GMPLMDT>GMPLLDT Q
	. . . S GMPLRPR=$P(GMPLD1,U,5),GMPLDIV=$P(GMPLD0,U,6),GMPLPTNM=$P(GMPLD0,U,2)
	. . . I +$G(GMPLPR),'$D(GMPLPR("I",+GMPLRPR)) Q
	. . . I $S(GMPLDI("ENTRIES")="ALL DIVISIONS":0,$D(GMPLDI("INST",+GMPLDIV)):0,1:1) Q
	. . . S GMPLSVC=$P(GMPLD1,U,6),GMPLCL=$P(GMPLD1,U,8),GMPLSCTC=$P(GMPLD800,U)
	. . . S GMPLSVCA=$S(GMPLSVC]"":$E($$GET1^DIQ(49,GMPLSVC,1),1,6),1:"n/a")
	. . . S GMPLSVCN=$S(GMPLSVC]"":$E($$GET1^DIQ(49,GMPLSVC,.01),1,6),1:"n/a")
	. . . S GMPLSVCA=$S(GMPLSVCA]"":GMPLSVCA,1:GMPLSVCN)
	. . . S GMPLCLA=$S(GMPLCL]"":$E($$GET1^DIQ(44,GMPLCL,1),1,6),1:"n/a")
	. . . S GMPLCLN=$S(GMPLCL]"":$E($$GET1^DIQ(44,GMPLCL,.01),1,6),1:"n/a")
	. . . S GMPLCLA=$S(GMPLCLA]"":GMPLCLA,1:GMPLCLN)
	. . . S GMPLDIV=$S(GMPLDIV]"":$$EXTERNAL^DILFD(9000011,.06,"",GMPLDIV),1:"DIVISION UNKNOWN")
	. . . S GMPLRPR=$S(GMPLRPR]"":$$EXTERNAL^DILFD(9000011,1.05,"",GMPLRPR),1:"n/a")
	. . . S GMPLNARR=$$EXTERNAL^DILFD(9000011,.05,"",$P(GMPLD0,U,5))
	. . . S GMPLPTL4=$E($$GET1^DIQ(2,$P(GMPLD0,U,2),.09),6,9) S:GMPLPTL4']"" GMPLPTL4="UNKN"
	. . . S GMPLPTNM=$$EXTERNAL^DILFD(9000011,.02,"",$P(GMPLD0,U,2))_"|"_GMPLPTL4
	. . . S GMPLSTAT=$$EXTERNAL^DILFD(9000011,80005,"",$P(GMPLD800,U,5))
	. . . S @GMPLA@(GMPLDIV,GMPLRPR,GMPLPTNM,GMPLMDT,GMPLDA)=GMPLNARR_U_GMPLSVCA_U_GMPLCLA_U_GMPLSCTC_U_GMPLSTAT
	Q
REPORT(GMPLA,GMPLEDT,GMPLLDT)	; Generate report
	N GMPLDIV,GMPLRTM,DIRUT,DTOUT,DUOUT,GMPLSITE,GMPLPG
	N GMPLSHDR,EQLN S $P(EQLN,"-",11)="",GMPLPG=0
	I $D(ZTQUEUED) S ZTREQ="@" ; Tell TaskMan to delete Task log entry
	U IO
	S GMPLRTM=$$NOW^XLFDT,GMPLSITE=$S($$NAME^VASITE]"":$$NAME^VASITE,1:$P($$SITE^VASITE,U,2))
	I '$D(@GMPLA) D  Q
	. D HEADER("",GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG)
	. W:$$CONTINUE("",GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG) !
	. W:$$CONTINUE("",GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG) "No Problems found for selected parameters...",!
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
	. . . . . N GMPLD,GMPLNARR,GMPLPRNM,GMPLPTNM,GMPLSVC,GMPLCLOC,GMPLSCTC,GMPLICD,GMPLSTAT,GMPLNI
	. . . . . S GMPLD=$G(@GMPLA@(GMPLDIV,GMPLRPR,GMPLPT,GMPLMDT,GMPLDA))
	. . . . . S GMPLNARR=$$WRAP^GMPLX1($P(GMPLD,U),76),GMPLSVC=$P(GMPLD,U,2),GMPLCLOC=$P(GMPLD,U,3),GMPLSCTC=$P(GMPLD,U,4)
	. . . . . S GMPLSTAT=$P(GMPLD,U,5),GMPLICD=$S(+GMPLSCTC:$$GETDX^GMPLX(GMPLSCTC,"SCT"),1:"")
	. . . . . I +$$CONTINUE(GMPLDIV,GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG)'>0!$D(DIRUT) Q
	. . . . . W $E($$NAME^GMPLUTL1(GMPLRPR,"LAST"),1,10),$$NAME^GMPLUTL1(GMPLRPR,",FI MI")
	. . . . . W ?16,$E($$NAME^GMPLUTL1($P(GMPLPT,"|"),"LAST"),1,10),$$NAME^GMPLUTL1($P(GMPLPT,"|"),",FI MI"),?31," (",$P(GMPLPT,"|",2),")"
	. . . . . W ?40,$$DATE^GMPLUTL1(GMPLMDT,"MM/DD/YY"),?50,GMPLSVC,?58,GMPLCLOC,?70,GMPLSTAT,!
	. . . . . F GMPLNI=1:1:$L(GMPLNARR,"|") D  Q:$D(DIRUT)
	. . . . . . I +$$CONTINUE(GMPLDIV,GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG)'>0!$D(DIRUT) Q
	. . . . . . W ?2,$P(GMPLNARR,"|",GMPLNI),!
	. . . . . I +$$CONTINUE(GMPLDIV,GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG)'>0!$D(DIRUT) Q
	. . . . . W ?2,"SCT: ",GMPLSCTC,?25," ==> ",?40,GMPLICD,!
	. . . . . Q:(+$$CONTINUE(GMPLDIV,GMPLRTM,GMPLEDT,GMPLLDT,.GMPLPG)'>0)!$D(DIRUT)  W !
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
	W GMPLLINE,! D JUSTIFY^GMPLUTL1($$TITLE^GMPLUTL1("PROBLEM LIST NTRT MAPPING REPORT"),"C") W !
	D JUSTIFY^GMPLUTL1(DIVISION,"C")
	W !
	W "for Problems Modified: ",GMPLDTR,?55,"Printed: ",$$DATE^GMPLUTL1(GMPLRTM,"MM/DD/CCYY HR:MIN"),!
	W !
	W "Provider",?16,"Patient",?40,"Modified",?50,"Service",?58,"Clinic",?70,"NTRT Map",!
	W ?2,"Narrative",?70,"Status",!
	W GMPLLINE,!
	Q
