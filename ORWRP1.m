ORWRP1	; ALB/MJK,dcm Report Calls ;9/18/96  15:02
	;;3.0;ORDER ENTRY/RESULTS REPORTING;**10,85,109,160,262,212**;Dec 17, 1997;Build 24
	;
AHS(ROOT,ORDFN,ORHS,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	; - get adhoc health summary report
	D START^ORWRP(80,"AHSB^ORWRP1(.ROOT,.ORDFN,.ORHS,.ALPHA,.OMEGA,.DTRANGE,.REMOTE,.ORMAX,.ORFHIE)")
	Q
AHSB(ROOT,ORDFN,ORHS,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	; -build adhoc health summary
	N ORVP,GMTYP,Y
	S ORVP=ORDFN_";DPT(",Y=$P($G(^GMT(142,+ORHS,0)),U),GMTSTYP=+ORHS
	D ADHOC^ORPRS13
	Q
HS(ROOT,ORDFN,ORHS,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	; - get health summary report
	D START^ORWRP(80,"HSB^ORWRP1(.ROOT,.ORDFN,.ORHS,.ALPHA,.OMEGA,.DTRANGE,.REMOTE,.ORMAX,.ORFHIE)")
	Q
HSB(ROOT,ORDFN,ORHS,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	; - build health summary report
	N I,ICN,ORVP,GMTYP,Y,GMARXN,GMTSDLM,GMTSDTC,GMTSE,GMTSEGH,GMTSEGL,GMTSEGN,GMTSEGR,GMSEQ,GMTSHDR,GMTSLCMP,GMTSNDM,GMTSNPK,GMTSPG,GMTSPHDR,X
	I $G(REMOTE) D  Q:'ORHS
	. S Y=$O(^GMT(142,"E",$P(ORHS,";",2),0))
	. I 'Y S Y=$O(^GMT(142,"E",$P($$UPPER^ORU(ORHS),";",2),0))
	. I 'Y S I=0 F  S I=$O(^GMT(142,I)) Q:'I  I $L($P($G(^GMT(142,I,"T")),"^")),$P($$UPPER^ORU(ORHS),";",2)=$$UPPER^ORU(^("T")) S Y=I Q
	. I 'Y S Y=$O(^GMT(142,"B",$P(ORHS,";",2),0))
	. I 'Y S Y=$O(^GMT(142,"B",$P($$UPPER^ORU(ORHS),";",2),0))
	. I 'Y S I=0 F  S I=$O(^GMT(142,I)) Q:'I  S X=$P(^(I,0),"^") I $P($$UPPER^ORU(ORHS),";",2)=$$UPPER^ORU(X) S Y=I Q
	. I 'Y U IO W !,ORHS_" not found on remote system",! S ORHS=Y Q
	. S ORHS=Y
	I +$G(ORHS)<1 W !,"Report not Available" Q
	S ORVP=ORDFN_";DPT(",Y=$P($G(^GMT(142,+ORHS,0)),U),GMTYP(0)=1,GMTYP(1)=+ORHS_U_Y_U_Y_U_Y
	D PQ^ORPRS13
	Q
HSTYPE(ROOT,ORDFN,ORHS,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	; - Get HS type report
	D START^ORWRP(80,"HSTYPEB^ORWRP1(.ROOT,.ORDFN,.ORHS,.ALPHA,.OMEGA,.DTRANGE,.REMOTE,.ORMAX,.ORFHIE)")
	Q
HSTYPEB(ROOT,ORDFN,ORHS,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	; - Build HS type report
	N GMTSQIT,GMTSPRM,GMTSTITL,GMTSPX2,GMTSPX1
	I $L($G(DTRANGE)),'$G(ALPHA) S ALPHA=$$FMADD^XLFDT(DT,-DTRANGE),OMEGA=$$NOW^XLFDT
	Q:'$G(ALPHA)  Q:'$G(OMEGA)
	I +$G(ORHS)<1 W !,"Report not Available" Q
	S GMTSQIT=1,GMTSPRM=$P($G(^GMT(142.1,+ORHS,0)),"^",4),GMTSTITL="",GMTSPX2=ALPHA,GMTSPX1=OMEGA,DFN=ORDFN
	D ENCWA^GMTS
	Q
HSGUI(DFN,GMTSTYP)	; - Call ENX^GMTSDVR to print HS Type for Patient
	D ENX^GMTSDVR(DFN,GMTSTYP)
	Q
BLR(ROOT,ORDFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	; -- get 'enhanced' blood bank report
	D BB^ORWRP2
	Q
AP(ROOT,ORDFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	; -- get Anatomic path report
	N I,C,LINES,X
	K ^TMP("LRC",$J),^TMP("LRH",$J)
	D AP^LR7OSUM(ORDFN)
	I '$O(^TMP("LRC",$J,0)) S ^TMP("LRC",$J,1,0)="",^TMP("LRC",$J,2,0)="No Anatomic Pathology reports available..."
	S I=0
	I $L($O(^TMP("LRH",$J,0))) S I=.001,^TMP("LRC",$J,I)="[HIDDEN TEXT]^" D
	. S X="",C=2 F  S X=$O(^TMP("LRH",$J,X)) Q:X=""  S LINES(^(X))=X,C=C+1
	. S $P(^TMP("LRC",$J,.001),"^",2)=C
	. S X="" F  S X=$O(LINES(X)) Q:X=""  D
	.. S I=I+.001,^TMP("LRC",$J,I)=X_"^"_LINES(X)
	. S I=I+.001,^TMP("LRC",$J,I)="[REPORT TEXT]"
	S ROOT=$NA(^TMP("LRC",$J))
	K ^TMP("LRH",$J)
	Q
DIET(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	; -- get dietetics profile
	N LCNT,ORVP
	S LCNT=0,ORVP=DFN_";DPT("
	D FHP^ORCXPNDR
	S ROOT=$NA(^TMP("ORXPND",$J))
	Q
LISTNUTR(ROOT,DFN)	; -- list nutritional assessments
	N OK,I,X,SITE
	K ^TMP($J,"FHADT")
	S OK=$$FHWORADT^FHWORA(DFN)
	S I=0,SITE=$$SITE^VASITE,SITE=$P(SITE,"^",2)_";"_$P(SITE,"^",3)
	F  S I=$O(^TMP($J,"FHADT",DFN,I)) Q:'I  S X=SITE_U_I_U_^(I),^(I)=X
	S ROOT=$NA(^TMP($J,"FHADT",DFN))
	Q
NUTR(ROOT,DFN,ID,ALPHA,OMEGA,ORDTRNG,REMOTE,ORMAX,ORFHIE)	; -- get nutritional assessment
	N LCNT,ORVP
	K ^TMP("ORXPND",$J)
	S LCNT=0,ORVP=DFN_";DPT(",ID=DFN_";"_ID
	D FHA^ORCXPNDR
	S ROOT=$NA(^TMP("ORXPND",$J))
	Q
VITALS(ROOT,ORDFN,ID,ALPHA,OMEGA,ORDTRNG,REMOTE,ORMAX,ORFHIE)	; -- get vitals report
	D START^ORWRP(132,"VITALSB^ORWRP1(.ROOT,.ORDFN,.ID,.ALPHA,.OMEGA,.ORDTRNG,.REMOTE,.ORMAX,.ORFHIE)")
	Q
VITALSB(ROOT,ORDFN,ID,ALPHA,OMEGA,ORDTRNG,REMOTE,ORMAX,ORFHIE)	; -- build vitals report
	N ORVP,XQORNOD,ORSSTRT,ORSSTOP
	Q:'$G(ORDFN)
	I $L(ORDTRNG),'$G(ALPHA) S ALPHA=$$FMADD^XLFDT(DT,-ORDTRNG),OMEGA=$$NOW^XLFDT
	Q:'$G(ALPHA)  Q:'$G(OMEGA)
	I '$P(OMEGA,".",2) S OMEGA=OMEGA_".2359"
	S ORVP=ORDFN_";DPT(",XQORNOD=1,ORSSTRT(XQORNOD)=ALPHA,ORSSTOP(XQORNOD)=OMEGA
	D VITCUM^ORPRS14
	Q
STAT(ROOT,ORDFN,ID,ORALPHA,OROMEGA,ORDTRNG,REMOTE,ORMAX,ORFHIE)	;Lab Order Status
	N ORVP
	K ^TMP("ORDATA",$J)
	S ORVP=ORDFN_";DPT("
	D EN1^LR7OSOS1(.ORY,ORVP,.ORALPHA,.OROMEGA,.ORDTRNG)
	I '$O(^TMP("ORDATA",$J,1,0)) S ^TMP("ORDATA",$J,1,1,0)="",^TMP("ORDATA",$J,1,2,0)="No Orders found..."
	S ROOT=ORY
	Q
INTERIM(ROOT,ORDFN,ID,ORALPHA,OROMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Lab Interim
	D START^ORWRP(80,"INTERIMB^ORWRP1(.ROOT,.ORDFN,.ID,.ORALPHA,.OROMEGA,.DTRANGE,.REMOTE,.ORMAX,.ORFHIE)")
	Q
INTERIMB(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Build Interim
	Q:'$G(DFN)  Q:'$G(ALPHA)  Q:'$G(OMEGA)
	N ORVP,XQORNOD,ORSSTRT,ORSSTOP,LRACC,LRAD,LRAN,LRRT,LRPG,LRSB,LREDT,LRIDT
	S ORVP=DFN_";DPT(",XQORNOD=1,(ORSSTRT(XQORNOD),LREDT)=(9999999-ALPHA),(ORSSTOP(XQORNOD),LRIDT)=(9999999-OMEGA)
	D OERR^LRRP4,CLEAN^LRRP4
	Q
LRGEN(ROOT,ORDFN,ID,ORALPHA,OROMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Lab results by test
	D START^ORWRP(80,"LRGENB^ORWRP1(.ROOT,.ORDFN,.ID,.ORALPHA,.OROMEGA,.DTRANGE,.REMOTE,.ORMAX,.ORFHIE)")
	Q
LRGENB(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Build Results
	Q:'$G(DFN)  Q:'$G(ALPHA)  Q:'$G(OMEGA)
	N ORVP,ORSSTRT,ORSSTOP,LREDT,LRSDT,XQORNOD
	S ORVP=DFN_";DPT(",XQORNOD=1,(ORSSTRT(XQORNOD),LREDT)=(9999999-ALPHA),(ORSSTOP(XQORNOD),LRSDT)=(9999999-OMEGA)
	D SET1^LRGEN,CLEAN^LRRP4
	K LRPR
	Q
GRAPH(ROOT,ORDFN,ID,ORALPHA,OROMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Graph labs
	D START^ORWRP(80,"GRAPHB^ORWRP1(.ROOT,.ORDFN,.ID,.ORALPHA,.OROMEGA,.DTRANGE,.REMOTE,.ORMAX,.ORFHIE)")
	Q
GRAPHB(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Graph labs
	Q:'$G(DFN)  Q:'$G(ALPHA)  Q:'$G(OMEGA)
	N ORVP,XQORNOD,ORSSTRT,ORSSTOP,LREDT,LRSDT
	S ORVP=DFN_";DPT(",XQORNOD=1,(ORSSTRT(XQORNOD),LREDT)=ALPHA,(ORSSTOP(XQORNOD),LRSDT)=OMEGA
	D OERR^LRDIST4,CLEAN^LRDIST4
	Q
ORS(ROOT,ORDFN,ID,ALPHA,OMEGA,ORDTRNG,REMOTE,ORMAX,ORFHIE)	;Daily order summary
	D START^ORWRP(80,"ORSB^ORWRP1(.ROOT,.ORDFN,.ID,.ALPHA,.OMEGA,.ORDTRNG,.REMOTE,.ORMAX,.ORFHIE)")
	Q
ORSB(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Daily order summary
	N ORVP,XQORNOD,ORSSTRT,ORSSTOP
	S ORVP=DFN_";DPT(",XQORNOD=1,X1=DT,X2=-$S(DTRANGE:DTRANGE-1,1:0)
	D C^%DTC
	S ORSSTRT=X-.7641,ORSSTOP=DT+.2359
	D DAY^ORPRS02
	Q
ORD(ROOT,ORDFN,ID,ORALPHA,OROMEGA,ORDTRNG,REMOTE,ORMAX,ORFHIE)	;Order Summary for Date Range
	D START^ORWRP(80,"ORDB^ORWRP1(.ROOT,.ORDFN,.ID,.ORALPHA,.OROMEGA,.ORDTRNG,.REMOTE,.ORMAX,.ORFHIE)")
	Q
ORDB(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Order Summary for Date Range
	Q:'$G(DFN)
	I $L($G(DTRANGE)),'$G(ALPHA) S ALPHA=$$FMADD^XLFDT(DT,-DTRANGE),OMEGA=$$NOW^XLFDT
	Q:'$G(ALPHA)  Q:'$G(OMEGA)
	N ORVP,XQORNOD,ORSSTRT,ORSSTOP
	S ORVP=DFN_";DPT(",XQORNOD=1,ORSSTRT=ALPHA,ORSSTOP=OMEGA
	D RANGE^ORPRS02
	Q
ORC(ROOT,ORDFN,ID,ORALPHA,OROMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Custom order summary
	D START^ORWRP(80,"ORCB^ORWRP1(.ROOT,.ORDFN,.ID,.ORALPHA,.OROMEGA,.DTRANGE,.REMOTE,.ORMAX,.ORFHIE)")
	Q
ORCB(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Custom order summary build
	Q:'$G(DFN)  Q:'$G(ALPHA)  Q:'$G(OMEGA)
	N ORVP,XQORNOD,ORSSTRT,ORSSTOP
	S ORVP=DFN_";DPT(",XQORNOD=1,ORSSTRT=ALPHA,ORSSTOP=OMEGA
	D CUSTOM^ORPRS02
	Q
ORP(ROOT,ORDFN,ID,ORALPHA,OROMEGA,ORDTRNG,REMOTE,ORMAX,ORFHIE)	;Chart copy summary
	D START^ORWRP(80,"ORPB^ORWRP1(.ROOT,.ORDFN,.ID,.ORALPHA,.OROMEGA,.ORDTRNG,.REMOTE,.ORFHIE)")
	Q
ORPB(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Chart copy summary
	Q:'$G(DFN)
	I $L($G(DTRANGE)),'$G(ALPHA) S ALPHA=$$FMADD^XLFDT(DT,-DTRANGE),OMEGA=$$NOW^XLFDT
	Q:'$G(ALPHA)  Q:'$G(OMEGA)
	N ORVP,XQORNOD,ORSSTRT,ORSSTOP
	S ORVP=DFN_";DPT(",XQORNOD=1,ORSSTRT=ALPHA,ORSSTOP=OMEGA
	D CHART^ORPRS02
	Q
PSO(ROOT,ORDFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Outpatient RX Profile
	D START^ORWRP(80,"PSOB^ORWRP1(.ROOT,.ORDFN,.ID,.ALPHA,.OMEGA,.DTRANGE,.REMOTE,.ORFHIE)")
	Q
PSOB(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Outpatient RX Action Profile
	N ORVP,PSTYPE,PSONOPG
	S ORVP=DFN_";DPT(",PSTYPE=1,PSONOPG=2
	D DFN^PSOSD1
	Q
MED(ROOT,ORDFN,IID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Medicine Summary of Procedures
	D START^ORWRP(80,"MEDB^ORWRP1(.ROOT,.ORDFN,.IID,.ALPHA,.OMEGA,.DTRANGE,.REMOTE,.ORMAX,.ORFHIE)")
	Q
MEDB(ROOT,DFN,IID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Medicine Summary of Procedures
	Q:'$L($G(IID))
	N ORVP,XQY0,OT,MCARPPS,MCPRO,MCARGRTN,DXS,SSN,I,J,L,DA,MCARGDA
	S ORVP=DFN_";DPT(",XQY0="",OT=$G(^TMP("OR",$J,"MCAR","OT",IID))
	Q:'$L(OT)
	S (DA,MCARGDA)=$P(OT,U,2),MCARPPS=$P(OT,U,3,4),MCPRO=$P(OT,U,11)
	D MCPPROC^MCARP
	S MCARGRTN=$P(OT,U,5)
	D @MCARPPS
	Q
PROB(ROOT,ORDFN,IID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	; Problem List (Problem Tab)
	D START^ORWRP(80,"PROBB^ORWRP1(.ROOT,.ORDFN,.IID,.ALPHA,.OMEGA,.DTRANGE,.REMOTE,.ORMAX,.ORFHIE)")
	Q
PROBB(ROOT,DFN,IID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	;Problem List
	N ORSILENT S ORSILENT=1
	D VAF^GMPLUTL2(DFN,ORSILENT)
	Q
