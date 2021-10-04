ORWSR	;SLC/REV-Surgery RPCs ; 3/15/11 8:08am
	;;3.0;ORDER ENTRY/RESULTS REPORTING;**109,116,132,148,160,190,274,347**;Dec 17, 1997;Build 4
	;
SHOWSURG(ORY)	;is Surgery ES patch installed?
	S ORY=$$PATCH^XPDUTL("SR*3.0*100")
	Q:+ORY=0
	S ORY=$$GET^XPAR("ALL","ORWOR SHOW SURGERY TAB",1)
	Q
LIST(ORY,ORDFN,ORBDT,OREDT,ORCTXT,ORMAX,ORFHIE)	;RETURN LIST OF SURGERY CASES FOR A PATIENT
	Q:'$$PATCH^XPDUTL("SR*3.0*100")
	N I,J,X,SHOWADD,SHOWDOCS
	S ORY=$NA(^TMP("ORLIST",$J))
	Q:'+ORDFN
	S:'$G(ORCTXT) ORCTXT=1
	S:'$G(ORBDT) ORBDT=""
	S:'$G(OREDT) OREDT=""
	S:'$G(ORMAX) ORMAX=""
	S (SHOWDOCS,SHOWADD)=1
	D LIST^SROESTV(.ORY,ORDFN,ORBDT,OREDT,ORMAX,SHOWDOCS)
	S I=0
	F  S I=$O(@ORY@(I)) Q:+I=0  D
	. S X=@ORY@(I),J=0
	. S $P(X,U,6)=$$NON^SROESTV(+X)
	. S $P(X,U,14)=ORCTXT
	. S $P(X,U,13)=$P(X,U,5),$P(X,U,5)=""
	. S @ORY@(I)=X
	. F  S J=$O(@ORY@(I,J)) Q:+J=0  D
	. . S X=@ORY@(I,J)
	. . S:(($P(X,U,14)=ORCTXT)!($P(X,U,14)="")) $P(X,U,14)=+$P(X,U,10)
	. . S @ORY@(I,J)=X
	Q
CASELIST(ORY,ORDFN)	; retrieve list of cases, but no documents
	Q:'$$PATCH^XPDUTL("SR*3.0*100")
	Q:'+ORDFN
	N ORBDT,OREDT,ORMAX,I,SHOWDOCS S (ORBDT,OREDT,ORMAX)="",SHOWDOCS=0
	S ORY=$NA(^TMP("ORLIST",$J))
	D LIST^SROESTV(.ORY,ORDFN,ORBDT,OREDT,ORMAX,SHOWDOCS)
	S I=0
	F  S I=$O(@ORY@(I)) Q:+I=0  D
	. S $P(@ORY@(I),U,4)=$P($P(@ORY@(I),U,4),";",2)
	Q
GTSURCTX(Y,ORUSER)	; Returns current Notes view context for user
	N OCCLIM,SHOWSUB
	S Y=$$GET^XPAR("ALL","ORCH CONTEXT SURGERY",1)
	Q
SVSURCTX(Y,ORCTXT)	; Save new Notes view preferences for user
	N TMP
	S TMP=$$GET^XPAR(DUZ_";VA(200,","ORCH CONTEXT SURGERY",1)
	I TMP'="" D  Q
	. D CHG^XPAR(DUZ_";VA(200,","ORCH CONTEXT SURGERY",1,ORCTXT)
	D ADD^XPAR(DUZ_";VA(200,","ORCH CONTEXT SURGERY",1,ORCTXT)
	Q
	;
ONECASE(ORY,ORTIUDA)	;Given a TIU document, return the case and related documents
	Q:'$$PATCH^XPDUTL("SR*3.0*100")!(+$G(ORTIUDA)=0)
	N ORCASE
	D GET1405^TIUSRVR(.ORCASE,ORTIUDA)
	I +ORCASE'>0 S ORY=ORCASE Q
	D GETONE(.ORY,+ORCASE)
	Q
GETONE(ORY,ORCASE)	; called by ONECASE and RPTTEXT 
	;Q:'$$PATCH^XPDUTL("SR*3.0*100")
	N ORTMP,J,SHOWADD,ORCTXT
	S SHOWADD=1,ORCTXT=1
	D ONE^SROESTV("ORY",+ORCASE)
	S X=ORY(+ORCASE),J=0
	S $P(X,U,6)=$$NON^SROESTV(+X)
	S $P(X,U,14)=ORCTXT
	S $P(X,U,13)=$P(X,U,5),$P(X,U,5)=""
	S ORTMP(0)=X
	F  S J=$O(ORY(+ORCASE,J)) Q:+J=0  D
	. S X=ORY(+ORCASE,J)
	. S:(($P(X,U,14)=ORCTXT)!($P(X,U,14)="")) $P(X,U,14)=+$P(X,U,10)
	. S ORTMP(J)=X
	K ORY M ORY=ORTMP
	Q
SHOWOPTP(ORY,ORCASE)	;Should OpTop be displayed on signature?
	I '$$PATCH^XPDUTL("SR*3.0*100") S ORY=0 Q
	S ORY=$$OPTOP^SROESTV(+ORCASE)
	Q
ISNONOR(ORY,ORCASE)	;Is the procedure a non-OR procedure?
	I '$$PATCH^XPDUTL("SR*3.0*100") S ORY=0 Q
	S ORY=$$NON^SROESTV(+ORCASE)
	Q
RPTLIST(ORY,ORDFN)	;Return list of surgery reports for reports tab
	;I '$$PATCH^XPDUTL("SR*3.0*100") D NOTYET(.ORY)  Q
	Q:'$$PATCH^XPDUTL("SR*3.0*100")
	Q:'+ORDFN
	N ORBDT,OREDT,ORMAX,I,SHOWDOCS,X,SITE,Z,SPEC,GMN,STATUS,DCTDTM,TRSDTM,Y,ORLW
	S (ORBDT,OREDT,ORMAX)="",SHOWDOCS=0
	S ORY=$NA(^TMP("ORLIST",$J))
	S SITE=$$SITE^VASITE,SITE=$P(SITE,"^",2)_";"_$P(SITE,"^",3)
	D LIST^SROESTV(.ORY,ORDFN,ORBDT,OREDT,ORMAX,SHOWDOCS)
	S I=0
	F  S I=$O(@ORY@(I)) Q:+I=0  D
	. S X=$P(@ORY@(I),U,2),$P(@ORY@(I),U,2)=$P(@ORY@(I),U,3),$P(@ORY@(I),U,3)=X
	. S $P(@ORY@(I),U,4)=$P($P(@ORY@(I),U,4),";",2)
	. S GMN=$P(@ORY@(I),U)
	. ;*347 Use Fileman calls.
	. K ORLW D GETS^DIQ(130,GMN,"49","","ORLW") S Z=$Q(ORLW) S:Z']"" Z="Z" S $P(@ORY@(I),U,6)="LAB WORK-"_$S($D(@Z)>1:"Yes",1:"No") ; Lab work
	. D STATUS^GMTSROB S:'$D(STATUS) STATUS="UNKNOWN"
	. S $P(@ORY@(I),U,7)="STATUS-"_STATUS ; op status
	. S Z=$$GET1^DIQ(130,GMN,.04,"I") I Z>0 S Y=Z,C=$P(^DD(130,.04,0),U,2) D Y^DIQ S SPEC=Y K Y
	. S $P(@ORY@(I),U,8)="SPEC-"_$G(SPEC) ; Surgical specialty
	. S Z=$$GET1^DIQ(130,GMN,15,"I") S:Z>0 DCTDTM=$$DATE^ORDVU(Z)
	. S $P(@ORY@(I),U,9)="DICT-"_$G(DCTDTM) ; Dictation Time
	. S Z=$$GET1^DIQ(130,GMN,39,"I") S:Z>0 TRSDTM=$$DATE^ORDVU(Z)
	. S $P(@ORY@(I),U,10)="TRANS-"_$G(TRSDTM) ; Transcription Time
	. ;*347 Reset variables for each item.
	. K SPEC,DCTDTM,TRSDTM,STATUS,Y,Z
	. S @ORY@(I)=SITE_U_@ORY@(I)
	Q
RPTTEXT(ROOT,DFN,ORID,ALPHA,OMEGA,DTRANGE,REMOTE,ORMAX,ORFHIE)	; -- return surgery report
	;I '$$PATCH^XPDUTL("SR*3.0*100") D NOTYET(.ROOT)  Q
	Q:'$$PATCH^XPDUTL("SR*3.0*100")
	Q:+ORID=0
	N X,ORI,J,ORDOC,ORCASE,CNT,LINES,ORSEP,ORTMP
	S (X,ORI)="",$P(ORSEP,"=",74)=""
	S ROOT=$NA(^TMP("ORXPND",$J))
	K @ROOT
	S CNT=0
	D GETONE(.ORCASE,ORID)
	S (ORI,J)=""
	F  S ORI=$O(ORCASE(ORI)) Q:ORI=""  D
	. S ORTMP(ORID,ORI)=ORCASE(ORI)
	K ORCASE M ORCASE=ORTMP
	S ORI=""
	F  S ORI=$O(ORCASE(ORID,ORI)) Q:ORI=""  D
	. Q:'$L($P(ORCASE(ORID,ORI),U,10))
	. Q:$E($P(ORCASE(ORID,ORI),U,2),1,8)="Addendum"
	. D TGET^TIUSRVR1(.ORDOC,+ORCASE(ORID,ORI),"VIEW")
	. S J="",LINES=0
	. F  S J=$O(@ORDOC@(J)) Q:J=""  D
	. . I $D(@ORDOC@(J))=10 D
	. . . S @ROOT@(J+CNT,0)=@ORDOC@(J,0),LINES=LINES+1
	. . E  S @ROOT@(J+CNT,0)=@ORDOC@(J),LINES=LINES+1
	. K ORDOC,ORY(ORID) S CNT=CNT+LINES+1
	. S @ROOT@(CNT,0)=ORSEP,CNT=CNT+1
	I CNT=0 S @ROOT@(CNT,0)="No reports are available for this case."
	Q
NOTYET(ROOT)	; -- standard not available display text
	D SETITEM(.ROOT,"Report not available at this time.")
	Q
SETITEM(ROOT,X)	; -- set item in list
	S @ROOT@($O(@ROOT@(9999),-1)+1)=X
	Q
