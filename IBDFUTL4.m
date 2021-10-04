IBDFUTL4	 ;ALB/MKN/CFS - Maintenance Utility Encounter Forms ICD-10 Update ;12/29/2011
	;;3.0;AUTOMATED INFO COLLECTION SYS;**63**;;Build 80
	;
	;
	N IBDARY,IBDX,IBDNA,IBDN,IBDN2,IBDBLK,IBDGPNA,IBDFM,IBDCT,IBDCT2,IBDS1,IBDS2,IBDS3,IBDFMNA,IBDCLNA,IBDCT
	N IBDFL,IBDFSRT,IBDFDIS,IBDINP,IBDLI,IBDSTA,IBDJ,IBDW,IBDLINE,IBDN,IBDN1,IBDSC,IBDCL1,IBDCL2,IBDOUT,IBDQUIT
	;
PROMPTS	;
	S (IBDFL,VALMCNT)=0
	K DIR S DIR("B")="CLINICS",DIR(0)="SA^C:CLINICS;G:GROUPS;F:FORMS",DIR("A")="Sort by [C]linics, [G]roups, [F]orms: " D ^DIR
	K DIR I $D(DTOUT)!($D(DUOUT))!(Y=U) G:'$D(IBDRE) EXIT S VALMBCK="R",VALMBG=1 Q
	S IBDX=$S("Gg"[X:2,"Ff"[X:3,"Ss"[X:4,1:1)
	S IBDFSRT=$E(IBDX),IBDFDIS=$S(IBDFSRT=1:"CLINIC",IBDFSRT=2:"GROUP",IBDFSRT=3:"FORM",1:"QUIT")
	S IBDX=$$SELASR() I 'IBDX S:$D(IBDRE) VALMBCK="R",VALMBG=1 Q:$D(IBDRE)  G EXIT
	;Coding Types
	K DIR,DIC S DIR("B")="ALL",DIR(0)="S^9:ICD-9;10:ICD-10;B:Both;N:Neither;A:All"
	S DIR("A")="Contains ICD-9 and/or ICD-10 diagnosis codes: "_$C(13,10)_"  ICD-[9], ICD-[10], [B]oth, [N]either, [A]ll"
	D ^DIR K DIR I ($D(DTOUT)!$D(DUOUT))!(Y=U) G:'$D(IBDRE) EXIT S VALMBCK="R",VALMBG=1 Q
	S IBDINP("CONTAINS")=Y
	;Update Status
	K DIR S DIR("B")="ALL",DIR(0)="S^I:Incomplete;C:Complete;R:Review;A:All"
	S DIR("A")="ICD-10 Update Status:"_$C(13,10)_"  [I]ncomplete, [C]omplete, [R]eview, [A]ll"
	D ^DIR K DIR I ($D(DTOUT)!$D(DUOUT))!(Y=U) G:'$D(IBDRE) EXIT S VALMBCK="R",VALMBG=1 Q
	S IBDINP("STATUS")=Y
	;Summary or Detail
	K DIR S DIR("B")="SUMMARY",DIR(0)="S^S:Summary Report;D:Detail Report"
	S DIR("A")="Report Type:"_$C(13,10)_"  [S]ummary Report, [D]etail Report"
	D ^DIR K DIR I ($D(DTOUT)!$D(DUOUT))!(Y=U) G:'$D(IBDRE) EXIT S VALMBCK="R",VALMBG=1 Q
	S IBDINP("SD")=Y
	I '$D(IBDRE) K XQORS,VALMEVL D EN^VALM("IBDF ICD10 STATUS REPORT")
	I $D(IBDRE) D HDR,EXIT,INIT S VALMBCK="R",VALMBG=1
	Q
	;
SORT	     ;Set up sorted list
	K ^TMP("IBDFUTL4",$J),^TMP("IBDFUTL4X",$J) S ^TMP("IBDFUTL4X",$J,"D",0)=0
	S IBDARY="^TMP(""IBDFUTL4X"","_$J_")"
	;Clinic Processing
	I IBDINP("SORTBY")="AC" D  G SETLIST
	. S IBDSC=0 F  S IBDSC=$O(^SC(IBDSC)) Q:IBDSC'?1.N  D CHECKCL^IBDFUTL5(IBDSC,IBDINP("CONTAINS"),IBDINP("SORTBY"),IBDARY)
	I IBDINP("SORTBY")="SC" D  G SETLIST
	. S IBDX="" F  S IBDX=$O(IBDINP("CLINIC",IBDX)) Q:IBDX=""  S IBDSC=IBDINP("CLINIC",IBDX) D CHECKCL^IBDFUTL5(IBDSC,IBDINP("CONTAINS"),IBDINP("SORTBY"),IBDARY)
	I IBDINP("SORTBY")="RC" S IBDX=IBDINP("CLINIC","RC",1),IBDX=$O(^SC("B",IBDX),-1) D
	. F  S IBDX=$O(^SC("B",IBDX)) Q:IBDX=""!(IBDX]IBDINP("CLINIC","RC",2))  S IBDSC="" F  S IBDSC=$O(^SC("B",IBDX,IBDSC)) Q:IBDSC'?1.N  D
	. . D CHECKCL^IBDFUTL5(IBDSC,IBDINP("CONTAINS"),IBDINP("SORTBY"),IBDARY)
	;Clinic Group Processing
	I IBDINP("SORTBY")="AG" D  G SETLIST
	. S IBDX=0 F  S IBDX=$O(^IBD(357.99,IBDX)) Q:IBDX'?1.N  S IBDGPNA=$P($G(^IBD(357.99,IBDX,0)),U,1) S:IBDGPNA="" IBDGPNA="Unknown" D
	. . S IBDN=0 F  S IBDN=$O(^IBD(357.99,IBDX,10,IBDN)) Q:IBDN'?1.N  S IBDSC=^IBD(357.99,IBDX,10,IBDN,0) D CHECKCL^IBDFUTL5(IBDSC,IBDINP("CONTAINS"),IBDINP("SORTBY"),IBDARY,IBDGPNA)
	I IBDINP("SORTBY")="SG" D  G SETLIST
	. S IBDX="" F  S IBDX=$O(IBDINP("GROUP",IBDX)) Q:IBDX=""  S IBDN=IBDINP("GROUP",IBDX),IBDGPNA=$P($G(^IBD(357.99,IBDN,0)),U,1) S:IBDGPNA="" IBDGPNA="Unknown" D
	. . S IBDY=0 F  S IBDY=$O(^IBD(357.99,IBDN,10,IBDY)) Q:IBDY'?1.N  S IBDSC=^IBD(357.99,IBDN,10,IBDY,0) D CHECKCL^IBDFUTL5(IBDSC,IBDINP("CONTAINS"),IBDINP("SORTBY"),IBDARY,IBDGPNA)
	I IBDINP("SORTBY")="RG" S IBDX=IBDINP("GROUP","RG",1),IBDX=$O(^IBD(357.99,"B",IBDX),-1) D
	. F  S IBDX=$O(^IBD(357.99,"B",IBDX)) Q:IBDX=""!(IBDX]IBDINP("GROUP","RG",2))  D
	. . S IBDIEN=$O(^IBD(357.99,"B",IBDX,""))
	. . S IBDGPNA=$P($G(^IBD(357.99,IBDIEN,0)),U,1) S:IBDGPNA="" IBDGPNA="Unknown" D
	. . . S IBDN=0 F  S IBDN=$O(^IBD(357.99,IBDIEN,10,IBDN)) Q:IBDN'?1.N  S IBDSC=^IBD(357.99,IBDIEN,10,IBDN,0) D CHECKCL^IBDFUTL5(IBDSC,IBDINP("CONTAINS"),IBDINP("SORTBY"),IBDARY,IBDGPNA)
	;Encounter Form Processing
	I $E(IBDINP("SORTBY"),2)="F" D FMARR
	I IBDINP("SORTBY")="AF" D  G TOOLKITF
	. S IBDSC=0 F  S IBDSC=$O(^SC(IBDSC)) Q:IBDSC'?1.N  D CHECKCL^IBDFUTL5(IBDSC,IBDINP("CONTAINS"),IBDINP("SORTBY"),IBDARY)
	I IBDINP("SORTBY")="SF" D  G TOOLKITF
	. S IBDFM="" F  S IBDFM=$O(IBDINP("FORM",IBDFM)) Q:IBDFM=""  D
	. . S IBDSC="" F  S IBDSC=$O(^TMP("IBDFUTL4X",$J,"X","FMARR",IBDFM,IBDSC)) Q:IBDSC=""  D CHECKCL^IBDFUTL5(IBDSC,IBDINP("CONTAINS"),IBDINP("SORTBY"),IBDARY)
	I IBDINP("SORTBY")="RF" S IBDX=IBDINP("FORM","RF",1),IBDFM=$O(^TMP("IBDFUTL4X",$J,"X","FMARR",IBDX),-1) D
	. F  S IBDFM=$O(^TMP("IBDFUTL4X",$J,"X","FMARR",IBDFM)) Q:IBDFM=""!(IBDFM]IBDINP("FORM","RF",2))  S IBDSC="" D
	. . F  S IBDSC=$O(^TMP("IBDFUTL4X",$J,"X","FMARR",IBDFM,IBDSC)) Q:IBDSC=""  D CHECKCL^IBDFUTL5(IBDSC,IBDINP("CONTAINS"),IBDINP("SORTBY"),IBDARY)
TOOLKITF	;
	I $E(IBDINP("SORTBY"),2)="F" S IBDFM="" F  S IBDFM=$O(^TMP("IBDFUTL4X",$J,"X","FMTK",IBDFM)) Q:IBDFM=""  D CHECKFM^IBDFUTL5(IBDFM,IBDINP("CONTAINS"),IBDINP("SORTBY"),IBDARY)
	;
SETLIST	;Convert the list into Listman format
	I $E(IBDINP("SORTBY"),2)'="G" D
	. S IBDS1="",IBDCT=0 F  S IBDS1=$O(^TMP("IBDFUTL4X",$J,"S",IBDS1)) Q:IBDS1=""  D
	. . S IBDS2="" F  S IBDS2=$O(^TMP("IBDFUTL4X",$J,"S",IBDS1,IBDS2)) Q:IBDS2=""  D 
	. . . S IBDCT=IBDCT+1 M ^TMP("IBDFUTL4X",$J,"D",IBDCT)=^TMP("IBDFUTL4X",$J,"S",IBDS1,IBDS2)
	I $E(IBDINP("SORTBY"),2)="G" D
	. S IBDS1="",IBDCT=0 F  S IBDS1=$O(^TMP("IBDFUTL4X",$J,"S",IBDS1)) Q:IBDS1=""  D
	. . S IBDS2="" F  S IBDS2=$O(^TMP("IBDFUTL4X",$J,"S",IBDS1,IBDS2)) Q:IBDS2=""  D
	. . . S IBDS3="" F  S IBDS3=$O(^TMP("IBDFUTL4X",$J,"S",IBDS1,IBDS2,IBDS3)) Q:IBDS3=""  D 
	. . . . S IBDCT=IBDCT+1 M ^TMP("IBDFUTL4X",$J,"D",IBDCT)=^TMP("IBDFUTL4X",$J,"S",IBDS1,IBDS2,IBDS3)
	S ^TMP("IBDFUTL4X",$J,"D",0)=IBDCT
	S IBDVAL=""
	S (IBDN,VALMCNT,IBDCT)=0 F  S IBDN=$O(^TMP("IBDFUTL4X",$J,"D",IBDN)) Q:IBDN=""  S IBDX=^TMP("IBDFUTL4X",$J,"D",IBDN) D
	. S IBDFM=$P(IBDX,U,8),IBDCT=IBDCT+1 ;,IBDLINE=$$SETSTR^VALM1(IBDN_")","",1,5),
	. S IBDFMNA=$P(IBDX,U,1),IBDCLNA=$P(IBDX,U,6),IBDGPNA=$P(IBDX,U,9)
	. I $E(IBDINP("SORTBY"),2)="G",IBDVAL'=IBDGPNA D GRHEADNG^IBDFUTL5(IBDGPNA,.IBDCT)  ;List each clinic under its grouped heading. Grouped in ^IBD(357.99.
	. S IBDLINE=$$SETSTR^VALM1(IBDN_")","",1,5)
	. F IBDJ=1:1:6 S IBDW=$P("22/5/8/8/5/22","/",IBDJ) S IBDLINE=IBDLINE_$$SETSTR^VALM1($P(IBDX,U,IBDJ),"",1,IBDW)_" "
	. S ^TMP("IBDFUTL4",$J,IBDCT,0)=IBDLINE,VALMCNT=IBDCT,^TMP("IBDFUTL4X",$J,"X","FM",IBDN)=IBDFM ; N=ROW IBDFM=Form IEN
	. S ^TMP("IBDFUTL4X",$J,"X","ROW",IBDN)=IBDCT
	. I $E(IBDINP("SORTBY"),2)="C" S ^TMP("IBDFUTL4X",$J,"X","CLNA",IBDCLNA,IBDCT)=""
	. I $E(IBDINP("SORTBY"),2)="F" S ^TMP("IBDFUTL4X",$J,"X","FMNA",IBDFMNA,IBDCT)=""
	. I $E(IBDINP("SORTBY"),2)="G" S ^TMP("IBDFUTL4X",$J,"X","GPNA",IBDGPNA,IBDCT)=""
	. S IBDFMNA=$E(IBDFMNA,16,30),IBDCLNA=$E(IBDCLNA,13,24)
	. S IBDVAL=IBDGPNA
	. I IBDINP("SD")="D" S IBDN1=0 F  S IBDN1=$O(^TMP("IBDFUTL4X",$J,"D",IBDN,"D",IBDN1)) Q:IBDN1=""  S IBDX=^TMP("IBDFUTL4X",$J,"D",IBDN,"D",IBDN1) D
	. . I $P(IBDX,U,1)="BL" S IBDLINE="      Block: "_$E($P(IBDX,U,2),1,30)
	. . I $P(IBDX,U,1)="LT" S IBDLINE="         "_$E($P(IBDX,U,3),1,8)_$J(" ",8-$L($E($P(IBDX,U,3),1,8)))_" "_$P(IBDX,U,4)
	. . S IBDCT=IBDCT+1,^TMP("IBDFUTL4",$J,IBDCT,0)=IBDLINE,VALMCNT=IBDCT
	Q
	;
FMARR	;Set up FORMARR(FORMNAME,CLINIC)
	N IBDFM,IBDCL,IBDFT,IBDX,IBDI,IBDFMX,IBDFMNA,IBDFMSTA,IBDQUIT,IBDFM
	S IBDCL=0 F  S IBDCL=$O(^SD(409.95,"B",IBDCL)) Q:IBDCL'?1.N  S IBDFT="" F  S IBDFT=$O(^SD(409.95,"B",IBDCL,IBDFT)) Q:IBDFT=""  D
	. S IBDX=^SD(409.95,IBDFT,0) ; FORM LIST
	. F IBDI=2:1:9 S IBDFM=$P(IBDX,U,IBDI) I IBDFM?1.N S IBDFMX=$G(^IBE(357,IBDFM,0)),IBDFMNA=$P(IBDFMX,U,1),IBDFMSTA=$E($P(IBDFMX,U,18)) S:IBDFMNA="" IBDFMNA="Unknown" D  I 'IBDQUIT S ^TMP("IBDFUTL4X",$J,"X","FMARR",IBDFMNA,IBDCL)=IBDFM_U_IBDFMSTA
	. . I IBDINP("STATUS")="I",IBDFMSTA'="" S IBDQUIT=1 Q
	. . I IBDINP("STATUS")="C",IBDFMSTA'="C" S IBDQUIT=1 Q
	. . I IBDINP("STATUS")="R",IBDFMSTA'="R" S IBDQUIT=1 Q
	. . S IBDQUIT=0
	S IBDFM=0 F  S IBDFM=$O(^IBE(357,IBDFM)) Q:IBDFM'?1.N  S IBDX=$G(^IBE(357,IBDFM,0)),IBDFMNA=$P(IBDX,U,1) I IBDFMNA'="" I '$D(^TMP("IBDFUTL4X",$J,"X","FMARR",IBDFMNA)) S ^TMP("IBDFUTL4X",$J,"X","FMTK",IBDFM)=""
	Q
	;
EXIT	;  -- Code executed at action exit
	K IBDARY,IBDX,IBDNA,IBDN,IBDN2,IBDBLK,IBDGPNA,IBDFM,IBDCT,IBDS1,IBDS2,IBDFMNA,IBDCLNA,IBDCT,IBDRE
	K ^TMP("IBDFUTL4",$J),^TMP("IBDFUTL4X",$J)
	Q
	;
SELASR()	;Ask for All, Selected or Range
	K DIR
	I IBDFDIS="CLINIC" S DIR("B")="ALL CLINICS",DIR(0)="S^AC:ALL CLINICS;SC:SELECTED CLINICS;RC:RANGE OF CLINICS",DIR("A")="Selection type"
	I IBDFDIS="GROUP" S DIR("B")="ALL CLINIC GROUPS",DIR(0)="S^AG:ALL CLINIC GROUPS;SG:SELECTED CLINIC GROUPS;RG:RANGE OF CLINIC GROUPS",DIR("A")="Selection type"
	I IBDFDIS="FORM" S DIR("B")="ALL ENCOUNTER FORMS",DIR(0)="S^AF:ALL ENCOUNTER FORMS;SF:SELECTED ENCOUNTER FORMS;RF:RANGE OF ENCOUNTER FORMS",DIR("A")="Selection type"
	D ^DIR Q:$D(DTOUT)!$D(DUOUT) 0  S IBDINP("SORTBY")=Y
	K IBDINP("CLINIC") I "SC^RC"[IBDINP("SORTBY") D @IBDINP("SORTBY") Q:'$D(IBDINP("CLINIC")) 0
	K IBDINP("GROUP") I "SG^RG"[IBDINP("SORTBY") D @IBDINP("SORTBY") Q:'$D(IBDINP("GROUP")) 0
	K IBDINP("FORM") I "SF^RF"[IBDINP("SORTBY") D @IBDINP("SORTBY") Q:'$D(IBDINP("FORM")) 0
	Q 1
	;
SC	;Clinic selector
	N IBDI
	S IBDOUT=0 F IBDI=1:1:30 S IBDCL1=$$SC1("Select CLINIC: ") Q:IBDOUT
	Q
	;
SC1(IBDICA)	;Select a clinic
SC2	K DIC S DIC("A")=IBDICA,DIC="^SC(",DIC(0)="AEMQZN",DIC("S")="I $P(^(0),U,3)=""C""" D ^DIC I $D(DTOUT)!$D(DUOUT)!(X="") S IBDOUT=1 Q ""
	S IBDINP("CLINIC",$P(Y,U,2))=$P(Y,U)
	Q $P(Y,U,2)
	;
RC	;Clinic range selector
	S IBDCL1=$$SC1("Select beginning CLINIC: ") Q:'$L(IBDCL1)
RCE	S IBDCL2=$$SC1("Select ending CLINIC: ") I '$L(IBDCL2) W !,"Ending clinic must be specified!" K IBDINP("CLINIC") Q
	I IBDCL1]IBDCL2 K IBDINP("CLINIC",IBDCL2) W !!,$C(7),"Ending clinic must collate after beginning clinic!" G RCE
	S IBDINP("CLINIC","RC",1)=IBDCL1,IBDINP("CLINIC","RC",2)=IBDCL2
	Q
	;
SG	;Clinic GROUP selector
	N IBDI
	S IBDOUT=0 F IBDI=1:1:30 S IBDCL1=$$SG1("Select Clinic GROUP: ") Q:IBDOUT
	Q
	;
SG1(IBDICA)	;Select a clinic GROUP
SG2	;
	K DIC S DIC("A")=IBDICA,DIC="^IBD(357.99,",DIC(0)="AEMQZ" D ^DIC I $D(DTOUT)!$D(DUOUT)!(X="") S IBDOUT=1 Q ""
	S IBDINP("GROUP",$P(Y,U,2))=$P(Y,U)
	Q $P(Y,U,2)
	;
RG	;Clinic range selector
	S IBDCL1=$$SG1("Select beginning Clinic GROUP: ") Q:'$L(IBDCL1)
RGE	S IBDCL2=$$SG1("Select ending Clinic GROUP: ") I '$L(IBDCL2) W !,"Ending clinic group must be specified!" K IBDINP("GROUP") Q
	I IBDCL1]IBDCL2 K IBDINP("GROUP",IBDCL2) W !!,$C(7),"Ending clinic group must collate after beginning clinic!" G RGE
	S IBDINP("GROUP","RG",1)=IBDCL1,IBDINP("GROUP","RG",2)=IBDCL2
	Q
	;
SF	;Encounter Form selector
	N IBDI
	S IBDOUT=0 F IBDI=1:1:30 S IBDCL1=$$SF1("Select Encounter Form: ") Q:IBDOUT
	Q
	;
SF1(IBDICA)	;Select an Encounter Form
SF2	K DIC S DIC("A")=IBDICA,DIC="^IBE(357,",DIC(0)="AEMQZ" D ^DIC I $D(DTOUT)!$D(DUOUT)!(X="") S IBDOUT=1 Q ""
	S IBDINP("FORM",$P(Y,U,2))=$P(Y,U)
	Q $P(Y,U,2)
	;
RF	;Clinic range selector
	S IBDCL1=$$SF1("Select beginning Encounter Form: ") Q:'$L(IBDCL1)
RFE	S IBDCL2=$$SF1("Select ending Encounter Form: ") I '$L(IBDCL2) W !,"Ending Encounter Form must be specified!" K IBDINP("FORM") Q
	I IBDCL1]IBDCL2 K IBDINP("FORM",IBDCL2) W !!,$C(7),"Ending Encounter Form must collate after Encounter Form!" G RFE
	S IBDINP("FORM","RF",1)=IBDCL1,IBDINP("FORM","RF",2)=IBDCL2
	Q
	;
HDR	; -- header code
	S VALMHDR(1)="     ENCOUNTER FORM         ICD9/   LAST EDITED    ICD10  CLINIC"
	S VALMHDR(2)="                            ICD10  ICD9     ICD10  STATUS       "
	Q
	;
INIT	;
	D FULL^VALM1 D KILL^VALM10()
	K ^TMP("IBDFUTL4",$J),^TMP("IBDFUTL4X",$J)
	D SORT
	I '$D(^TMP("IBDFUTL4",$J)) S ^TMP("IBDFUTL4",$J,1,0)=" ",^TMP("IBDFUTL4",$J,2,0)="No records found"
	Q
	;
HELP	;
	S X="?" D DISP^XQORM1 W !!
	Q
	;
CL	;
	D FULL^VALM1 S IBDRE=1
	D PROMPTS
	Q
	;
JP	;
	N IBDI,IBDX,IBDY,IBDARR,IBDSB,IBDQUIT,IBDL,IBDRES,IBDN
	D FULL^VALM1
JMP	;
	S DIC=$S($E(IBDINP("SORTBY"),2)="F":"^IBE(357,",$E(IBDINP("SORTBY"),2)="G":"^IBD(357.99,",1:"^SC(")
	S DIC(0)="AEMN",DIC("A")="Select the "_$S($E(IBDINP("SORTBY"),2)="F":"Encounter Form",$E(IBDINP("SORTBY"),2)="G":"Clinic Group",1:"Clinic")_" that you wish to move to: "
	S:$E(IBDINP("SORTBY"),2)="C" DIC("S")="I $P(^SC(+Y,0),U,3)=""C"""
	D ^DIC K DIC
	I X["^" S VALMBG=1,VALMBCK="R" Q
	I Y<0 G JP
	S IBDX=$S($E(IBDINP("SORTBY"),2)="F":$P(^IBE(357,+Y,0),"^",1),$E(IBDINP("SORTBY"),2)="G":$P(^IBD(357.99,+Y,0),"^",1),1:$P(^SC(+Y,0),"^",1))
	I '$D(IBDX) W !!,"There is no data listed for this Clinic Group" G JMP
	I $E(IBDINP("SORTBY"),2)="C" S IBDSB="CLNA"
	I $E(IBDINP("SORTBY"),2)="F" S IBDSB="FMNA"
	I $E(IBDINP("SORTBY"),2)="G" S IBDSB="GPNA"
	S IBDY=$O(^TMP("IBDFUTL4X",$J,"X",IBDSB,IBDX),-1),(IBDI,IBDQUIT,IBDL)=0,IBDRES="" K IBDARR
	F  S IBDY=$O(^TMP("IBDFUTL4X",$J,"X",IBDSB,IBDY)) Q:IBDY=""!($E(IBDY,1,$L(IBDX))'=IBDX)  D
	. S IBDI=IBDI+1,IBDARR(IBDI)=IBDY
	I IBDI=1 S IBDRES=IBDARR(1) G JP5
	S IBDN="",IBDI=0 F  S IBDN=$O(IBDARR(IBDN)) Q:IBDN=""  S IBDI=IBDI+1 W !,IBDN,". ",IBDARR(IBDN) D  Q:IBDQUIT!(IBDRES'="")
	. I '(IBDI#5) S IBDL=IBDI D JPDIS S:$D(DTOUT)!($D(DUOUT))!(Y=U) IBDQUIT=1 Q:IBDQUIT  D  Q:IBDRES'=""
	. . S Y=+Y I Y>0 S IBDRES=IBDARR(Y)
	I IBDQUIT S VALMBCK="R" Q
	I IBDRES="",IBDI>IBDL D JPDIS Q:$D(DTOUT)!($D(DUOUT))!(Y=U)  S Y=+Y I Y>0 S IBDRES=IBDARR(Y)
	I IBDRES="" S VALMBCK="R" Q
JP5	;
	S IBDROW=$O(^TMP("IBDFUTL4X",$J,"X",IBDSB,IBDRES,""))
	S VALMBG=IBDROW,VALMBCK="R"
	;
	Q
	;
JPDIS	;
	W !,"Press <RETURN> to see more, '^' to exit this list, OR"
	S DIR(0)="NO^1:"_IBDI,DIR("A")="Choose 1-"_IBDI D ^DIR
	Q
	;
IS	;UPDATE ICD10 STATUS FIELD
	N IBDI,IBDX,IBDY,IBDFM,IBDN,IBDQUIT,IBDPR,IBDROW,IBDSTA
	I '$D(^TMP("IBDFUTL4X",$J,"D",0)) S VALMBCK="R" Q
	K DIR S DIR(0)="L^1:"_^TMP("IBDFUTL4X",$J,"D",0) D ^DIR
	I $D(DTOUT)!($D(DUOUT))!(Y=U) S VALMBCK="R" Q
	S IBDY=Y,(IBDQUIT,IBDROW)=0 F IBDI=1:1:$L(Y,",") S IBDLI=$P(IBDY,",",IBDI) I IBDLI?1.N S:IBDROW=0 IBDROW=IBDLI D  Q:IBDQUIT
	. S IBDFM=$G(^TMP("IBDFUTL4X",$J,"X","FM",IBDLI)) Q:IBDFM'?1.N
	. S IBDX=$G(^IBE(357,IBDFM,0)) Q:IBDX=""  W !,"Encounter Form: ",$P(IBDX,U,1)
	. S IBDSTA="",IBDN=$O(^IBE(357,IBDFM,3,"B",30,"")) I IBDN?1.N S IBDX=^IBE(357,IBDFM,3,IBDN,0),IBDSTA=$P(IBDX,U,2)
	. K DIR D
	. . I IBDSTA="" S IBDPR="Update Status to [C]omplete or [R]eview",DIR(0)="S^C:Complete;R:Review",DIR("B")="Complete"
	. . I IBDSTA="C" S IBDPR="Update Status to [I]ncomplete or [R]eview",DIR(0)="S^I:Incomplete;R:Review",DIR("B")="Incomplete"
	. . I IBDSTA="R" S IBDPR="Update Status to [C]omplete or [I]ncomplete",DIR(0)="S^C:Complete;I:Incomplete",DIR("B")="Complete"
	. S DIR("A")=IBDPR D ^DIR K DIR I ($D(DTOUT)!$D(DUOUT)) S IBDQUIT=1 Q
	. S IBDPR="Are you changing the Status from "_$S(IBDSTA="":"Incomplete",IBDSTA="C":"Complete",1:"Review")_" to "_$S(Y="I":"Incomplete",Y="C":"Complete",1:"Review")
	. S IBDX=$$YESNO^IBDUTIL1(IBDPR,"Y",0,300)
	. I IBDX=1 S IBDX=$$YESNO^IBDUTIL1("Are you sure you want to change the status","NO",0,300)
	. I IBDX=1 S:Y="I" Y="@" S IBDX=$$CSUPD357^IBDUTICD(IBDFM,30,Y,$$NOW^XLFDT(),DUZ)
	D SORT
	S VALMBCK="R"
	Q
	;
EXP	;
	Q
