EDPRPT10	;SLC/MKB - Admissions Report ;4/25/13 3:15pm
	;;2.0;EMERGENCY DEPARTMENT;**6,2**;Feb 24, 2012;Build 23
	;
ADM(BEG,END,CSV)	; Get Admissions Report for EDPSITE by date range
	N IN,OUT,LOG,X,X0,X1,X3,DX,DISP,ROW,TAB
	N ELAPSE,TRIAGE,WAIT,ADMDEC,ADMDEL
	D INIT ;set counters, sums to 0
	D:'$G(CSV) XML^EDPX("<logEntries>") I $G(CSV) D  ;headers
	. S TAB=$C(9)
	. ;***pij 4/19/2013 changed ED to IEN
	. ;S X="ED"_TAB_"Time Out"_TAB_"Complaint"_TAB_"MD"_TAB_"Acuity"_TAB_"Dispo"_TAB_"Adm Dec"_TAB_"Adm Delay"_TAB_"Diagnosis"_TAB_"ICD9" ;_TAB_"ER Spec Visit"
	. ;Begin EDP*2.0*2 changes - drp
	. S X="IEN"_TAB_"Time Out"_TAB_"Complaint"_TAB_"MD"_TAB_"Acuity"_TAB_"Dispo"_TAB_"Adm Dec"_TAB_"Adm Delay"_TAB_"Diagnosis"_TAB_"ICD"_TAB_"ICD Type" ;_TAB_"ER Spec Visit"
	. ;end EDP*2.0*2 changes
	. ;***
	. D ADD^EDPCSV(X)
	S IN=BEG-.000001
	F  S IN=$O(^EDP(230,"ATI",EDPSITE,IN)) Q:'IN  Q:IN>END  S LOG=0 F  S LOG=+$O(^EDP(230,"ATI",EDPSITE,IN,LOG)) Q:LOG<1  D
	. S X0=^EDP(230,LOG,0),X1=$G(^(1)),X3=$G(^(3))
	. Q:'+$P(X1,U,2)
	. S DISP=$$ECODE^EDPRPT($P(X1,U,2)),OUT=$P(X0,U,9)
	. ;TDP - Patch 2 change to capture entries without abbreviations
	. ;Q:DISP=""  Q:'$D(CNT($$UP^XLFSTR(DISP)))  ;visits w/admit disp
	. ;S:DISP="" DISP="NONE"
	. I DISP="" S DISP=$$DISP^EDPRPT($P(X1,U,2))
	. ;Q:'$D(CNT($$UP^XLFSTR(DISP)))  ;visits w/admit disp
	. ;TDP - Patch 2, added VADMIT1 call for additional VA Admit check
	. I '$D(CNT($$UP^XLFSTR(DISP))),'$$VADMIT1^EDPRPT2($P(X1,U,2)) Q  ;visits w/admit disp
	. S DX=$$DXPRI^EDPQPCE(+$P(X0,U,3),LOG)
	. K ROW S ROW("id")=LOG
	. S ROW("outTS")=$S($G(CSV):$$EDATE^EDPRPT(OUT),1:OUT)
	. S ROW("complaint")=$P(X1,U)
	. S ROW("md")=$$EPERS^EDPRPT($P(X3,U,5))
	. S ROW("acuity")=$$ECODE^EDPRPT($P(X3,U,3))
	. S ROW("disposition")=DISP,DISP=$$UP^XLFSTR(DISP)
	. ;Begin EDP*2.0*2 changes - drp
	. S ROW("icd")=$P(DX,U),ROW("dx")=$P(DX,U,2),ROW("icdType")=$P(DX,U,3)
	. ; ER Special Visit ?? -- ck ^DPT dispositions
	. S CNT("ALL")=CNT("ALL")+1,CNT(DISP)=CNT(DISP)+1
	. ;
A1	. ; calculate times
	. ; S:OUT="" OUT=NOW
	. S ELAPSE=$S(OUT:($$FMDIFF^XLFDT(OUT,IN,2)\60),1:0)
	. F I="ALL",DISP S MIN(I,"elapsed")=MIN(I,"elapsed")+ELAPSE
	. ;
	. S X=$$ACUITY^EDPRPT(LOG),TRIAGE=0 ;S:X<1 X=OUT
	. S:X TRIAGE=($$FMDIFF^XLFDT(X,IN,2)\60)
	. F I="ALL",DISP S MIN(I,"triage")=MIN(I,"triage")+TRIAGE
	. ;
	. S X=$$LVWAITRM^EDPRPT(LOG),WAIT=0 ;leave waiting room
	. S:X WAIT=($$FMDIFF^XLFDT(X,IN,2)\60)
	. F I="ALL",DISP S MIN(I,"wait")=MIN(I,"wait")+WAIT
	. ;
	. S X=$$ADMIT^EDPRPT(LOG) ;decision to admit
	. S ADMDEC=$S(X:($$FMDIFF^XLFDT(X,IN,2)\60),1:0)
	. F I="ALL",DISP S MIN(I,"admDec")=MIN(I,"admDec")+ADMDEC
	. S ROW("admDec")=ADMDEC
	. ;
	. S ADMDEL=$S(X:($$FMDIFF^XLFDT(OUT,X,2)\60),1:0)
	. F I="ALL",DISP S MIN(I,"admDel")=MIN(I,"admDel")+ADMDEL
	. S ROW("admDel")=ADMDEL
	. ;
	. I '$G(CSV) S X=$$XMLA^EDPX("log",.ROW) D XML^EDPX(X) Q
	. S X=ROW("id")
	. F I="outTS","complaint","md","acuity","disposition","admDec","admDel","dx","icd","icdType" S X=X_$C(9)_$G(ROW(I))
	. ;End EDP*2.0*2 changes - drp
	. D ADD^EDPCSV(X)
	D:'$G(CSV) XML^EDPX("</logEntries>")
	;
A2	; calculate & include averages
	Q:CNT("ALL")<1  ;no visits found
	I $G(CSV) D  Q  ;return as CSV
	. ;***pij 4/19/2013 changed field to Elapsed from Visit
	. ;S X=TAB_TAB_TAB_"     Activity Summary"_TAB_"Total"_TAB_"Visit"_TAB_"Triage"_TAB_"Wait"_TAB_"Adm Dec"_TAB_"Adm Delay"
	. S X=TAB_TAB_TAB_"     Activity Summary"_TAB_"Total"_TAB_"Elapsed"_TAB_"Triage"_TAB_"Wait"_TAB_"Adm Dec"_TAB_"Adm Delay"
	. ;***
	. D BLANK^EDPCSV,ADD^EDPCSV(X),BLANK^EDPCSV
	. S X=TAB_TAB_TAB_"Total Patients VA Admitted"_TAB_CNT("ALL")
	. F I="elapsed","triage","wait","admDec","admDel" D
	.. S Y=MIN("ALL",I)\CNT("ALL"),X=X_TAB_$S(Y:$$ETIME^EDPRPT(Y),1:"0:00")
	. D ADD^EDPCSV(X),BLANK^EDPCSV
	. S X=TAB_TAB_TAB_"     Disposition" D ADD^EDPCSV(X)
	. S DISP="" F  S DISP=$O(CNT(DISP)) Q:DISP=""  I DISP'="ALL",CNT(DISP) D
	.. S X=TAB_TAB_TAB_DISP_TAB_CNT(DISP)
	.. F I="elapsed","triage","wait","admDec","admDel" D
	... S Y=MIN(DISP,I)\CNT(DISP),X=X_TAB_$S(Y:$$ETIME^EDPRPT(Y),1:"0:00")
	.. D ADD^EDPCSV(X)
	; or as XML
	D XML^EDPX("<averages>")
	S DISP="" F  S DISP=$O(CNT(DISP)) Q:DISP=""  I CNT(DISP) D
	. S MIN(DISP,"type")=$S(DISP="ALL":"Total Patients VA Admitted",1:DISP)
	. S MIN(DISP,"total")=CNT(DISP)
	. F I="elapsed","triage","wait","admDec","admDel" D
	.. S X=MIN(DISP,I)\CNT(DISP)
	.. S MIN(DISP,I)=$S(X:$$ETIME^EDPRPT(X),1:"0:00")
	. K ROW M ROW=MIN(DISP)
	. S X=$$XMLA^EDPX("average",.ROW) D XML^EDPX(X)
	D XML^EDPX("</averages>")
	K CNT,MIN
	Q
	;
INIT	; Initialize counters and sums
	N I,DISP,DA,X,Y
	;F D="VA","T","ICU","OBS","ALL" D
	S DISP="" F  S DISP=$O(^EDPB(233.1,"AB","disposition",DISP)) Q:DISP=""  D
	. Q:'$$VADMIT^EDPRPT2(DISP)
	. S CNT(DISP)=0
	. F I="elapsed","triage","wait","admDec","admDel" S MIN(DISP,I)=0
	;TDP - Patch 2, Added additional disposition inits to prevent undefined
	;      errors and capture dispositions without abbreviations
	S Y=EDPSTA_".disposition"
	S X=0 F  S X=$O(^EDPB(233.2,"AS",Y,X)) Q:X=""  D
	. S DA=0 F  S DA=$O(^EDPB(233.2,"AS",Y,X,DA)) Q:DA=""  D
	.. S DISP=$P($G(^EDPB(233.2,"AS",Y,X,DA)),U)
	.. I '$L(DISP) S DISP=$E($TR($P($G(^EDPB(233.2,"AS",Y,+X,DA)),U,2)," ","_"),1,30)
	.. I $L(DISP),'$D(CNT(DISP)),(($$VADMIT^EDPRPT2(DISP))!($$VADMIT1^EDPRPT2(X))) D
	... S DISP=$$UP^XLFSTR(DISP)
	... S CNT(DISP)=0
	... F I="elapsed","triage","wait","admDec","admDel" S MIN(DISP,I)=0
	;S CNT("NONE")=0 F I="elapsed","triage","wait","admDec","admDel" S MIN("NONE",I)=0
	S CNT("ALL")=0
	F I="elapsed","triage","wait","admDec","admDel" S MIN("ALL",I)=0
	Q
	;
ECODE(IEN)	; Return external value for a Code
	Q:IEN $P($G(^EDPB(233.1,IEN,0)),U,2) ;name
	Q ""
