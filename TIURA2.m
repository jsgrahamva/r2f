TIURA2	; SLC/JER - More review screen actions ; 6/29/12 9:02am
	;;1.0;TEXT INTEGRATION UTILITIES;**88,58,100,123,112,182,269**;Jun 20, 1997;Build 5
	; 6/20/00: Moved DISPLAY, BROWSE, & BROWS1 from TIURA to TIURA2
DISPLAY	; Detailed Display
	N TIUDA,TIUD,TIUDATA,TIUI,Y,DIROUT,TIUQUIT,RSTRCTD
	I '$D(VALMY) D EN^VALM2(XQORNOD(0))
	S TIUI=0
	F  S TIUI=$O(VALMY(TIUI)) Q:+TIUI'>0  D  Q:$D(TIUQUIT)
	. N TIUVIEW
	. S TIUDATA=$G(^TMP("TIURIDX",$J,TIUI))
	. D CLEAR^VALM1
	. W !!,"Reviewing #",+TIUDATA
	. S TIUDA=+$P(TIUDATA,U,2)
	. S TIUVIEW=$$CANDO^TIULP(TIUDA,"VIEW")
	. I +TIUVIEW'>0 D  Q
	. . W !!,$C(7),$P(TIUVIEW,U,2),!
	. . I $$READ^TIUU("EA","RETURN to continue...") ; pause
	. . D RESTORE^VALM10(+TIUI)
	. S RSTRCTD=$$DOCRES^TIULRR(TIUDA)
	. I RSTRCTD D  Q
	. . W !!,$C(7),"Ok, no harm done...",!
	. . I $$READ^TIUU("EA","RETURN to continue...") ; pause
	. . D RESTORE^VALM10(+TIUI)
	. D EN^TIUAUDIT
	. I +$G(TIUQUIT) D FIXLSTNW^TIULM Q
	. I TIUI'=$P($G(TIUGLINK),U,2) D RESTORE^VALM10(+TIUI) ; See rtn TIURL
	K VALMY S VALMBCK="R"
	Q
BROWSE(TIULTMP)	; Browse selected documents
	; TIULTMP is list template name
	N TIUDA,DFN,TIU,TIUCHNG,TIUDATA,TIUI,Y,DIROUT,TIUQUIT
	N TIUGDATA
	I '$D(VALMY) D EN^VALM2(XQORNOD(0))
	S TIUI=0
	F  S TIUI=$O(VALMY(TIUI)) Q:+TIUI'>0  D  Q:$D(TIUQUIT)
	. N TIUVIEW,TIUGACT,RSTRCTD
	. S TIUDATA=$G(^TMP("TIURIDX",$J,TIUI))
	. S TIUDA=+$P(TIUDATA,U,2)
	. S TIUGDATA=$G(^TMP("TIUR",$J,"IDDATA",TIUDA)) ; ID note/entry
	. D CLEAR^VALM1
	. W !!,"Reviewing Item #",TIUI
	. S RSTRCTD=$$DOCRES^TIULRR(TIUDA)
	. I RSTRCTD D  Q
	. . W !!,$C(7),"Ok, no harm done...",!
	. . I $$READ^TIUU("EA","RETURN to continue...") ; pause
	. D BROWS1(TIULTMP,TIUDA,TIUGDATA)
	; -- Update or Rebuild list: --
	I $G(TIUCHNG("DELETE"))!$G(TIUCHNG("ADDM")) S TIUCHNG("RBLD")=1
	S TIUCHNG("UPDATE")=1 ; default
	D UPRBLD^TIURL(.TIUCHNG,.VALMY) K VALMY
	S VALMBCK="R"
	Q
GETSORT(PRMSORT,EXPSORT)	; Get order for ID entries
	Q $S($G(EXPSORT)'="":EXPSORT,1:PRMSORT)
	;
BROWS1(TIULTMP,TIUDA,TIUGDATA)	; Browse single document
	;  Calls EN^VALM
	N %DT,C,D0,DIQ2,FINISH,TIU,TIUVIEW
	I '$D(TIUGDATA) S TIUGDATA=$$IDDATA^TIURECL1(TIUDA)
	I TIULTMP="TIU COMPLETE NOTES",$P(TIUGDATA,U,2) W !!,"You are completing the PARENT ENTRY of this interdisciplinary note."
	I '$P(TIUGDATA,U,2) D  Q:+TIUVIEW'>0  ;TIU*1*123
	. S TIUVIEW=$$CANDO^TIULP(TIUDA,"VIEW")
	. I +TIUVIEW'>0 D
	. . W !!,$C(7),$P(TIUVIEW,U,2),!
	. . I $$READ^TIUU("EA","RETURN to continue...") ; pause
	I '$D(TIUPRM0)!'$D(TIUPRM1) D SETPARM^TIULE
	D EN^VALM(TIULTMP)
	K ^TMP("TIUVIEW",$J)
	Q
	;
EXPAND	; Expand/Collapse ID notes, Addenda in lists
	N TIUDNM,TIULNM,TIUSTAT
	D:'$D(VALMY) EN^VALM2(XQORNOD(0))
	I $D(VALMY) D EC^TIURECL(.VALMY)
	W !,"Refreshing the list."
	K VALMY
	S VALMCNT=+$G(@VALMAR@(0))
	S VALMBCK="R"
	Q
	;
PRNTSCRN(VALMY)	; Evaluate whether a record may be printed
	N TIUI S TIUI=""
	F  S TIUI=$O(VALMY(TIUI)) Q:+TIUI'>0  D  Q:$D(DIROUT)
	. N TIUPMTHD,TIUDTYP,TIUPFHDR,TIUPFNBR,TIUPGRP,TIUPRINT,TIUFLAG,RSTRCTD,TIUTYP
	. S RSTRCTD=0,TIUDATA=$G(^TMP("TIURIDX",$J,TIUI))
	. ; *269 vmp/djh - Check if file exists
	. S TIUDA=+$P(TIUDATA,U,2),TIUTYP=+$G(^TIU(8925,TIUDA,0))
	. Q:TIUTYP'>0
	. ; Evaluate whether user can print record
	. S TIUPRINT=$$CANDO^TIULP(TIUDA,"PRINT RECORD")
	. I +TIUPRINT'>0 D  Q
	. . W !!,"Item #",TIUI,": ",!,$P(TIUPRINT,U,2),!
	. . K VALMY(TIUI)
	. . I $$READ^TIUU("EA","RETURN to continue...")
	. ;-- Add Check for restricted record when available --
	. S DFN=+$P(^TIU(8925,TIUDA,0),U,2)
	. S RSTRCTD=$$PTRES^TIULRR(DFN)
	. I +RSTRCTD D  Q
	. . W !!,"Item #",TIUI," Removed from print list.",!
	. . K VALMY(TIUI)
	. . I $$READ^TIUU("EA","Press RETURN to continue...")
	. I +$G(TIUPFLG) S TIUFLAG=+$$CHARTONE^TIURA1(TIUDA)
	Q
DICTATED	       ; Mark Document(s) "dictated"
	N TIUCHNG,TIUI,TIUY,Y,DIROUT
	I '$D(VALMY) D EN^VALM2(XQORNOD(0))
	S TIUI=0
	F  S TIUI=$O(VALMY(TIUI)) Q:+TIUI'>0  D  Q:$D(DIROUT)
	. N TIU,DFN,TIUDA,TIUDATA,RSTRCTD
	. S TIUDATA=$G(^TMP("TIURIDX",$J,TIUI))
	. S TIUDA=+$P(TIUDATA,U,2) S RSTRCTD=$$DOCRES^TIULRR(TIUDA)
	. I RSTRCTD D  Q
	. . W !!,$C(7),"Ok, no harm done...",!
	. . I $$READ^TIUU("EA","RETURN to continue...") ; pause
	. D EN^VALM("TIU DOCUMENT DICTATED")
	; -- Update or Rebuild list: --
	S TIUCHNG("UPDATE")=1
	D UPRBLD^TIURL(.TIUCHNG,.VALMY) K VALMY
	S VALMBCK="R"
	Q
DICTATE1(TIUDA)	; Single record sign on chart
	N DICMSG D FULL^VALM1
	D DICT(TIUDA,.DICMSG)
	W !!,$G(DICMSG(1)),!,$G(DICMSG(2)),! H $S($D(DICMSG(0)):+DICMSG(0),1:3)
	Q
DICT(DA,MSG)	; Mark signed on chart. Edit on-chart signatures.
	N AUTHOR,DIE,DR,Y,TIUSTAT,EXPCSNR,ATTNDNG,TIUDA,TIUPRMT,TIU0,TIU12,TIU13
	S TIU0=$G(^TIU(8925,+DA,0)),TIU12=$G(^(12)),TIU13=$G(^(13))
	S TIUSTAT=$P(TIU0,U,5)
	S TIUPRMT=$S(TIUSTAT>1:"Edit Dictation Data? ",1:"Has this document been dictated? ")
	W ! S MSG=$$READ^TIUU("YAO",TIUPRMT,"NO") W !
	I 'MSG S TIUCHNG=0 G DICTX
	S TIUCHNG=1
	S AUTHOR=$$PERSNAME^TIULC1(+$P(TIU12,U,2))
	S EXPCSNR=$$PERSNAME^TIULC1(+$P(TIU12,U,8))
	S:+$P(TIU12,U,9) ATTNDNG=$$PERSNAME^TIULC1(+$P(TIU12,U,9))
	S DR="1202//^S X=AUTHOR;1307//^S X=$S(+$P(TIU13,U,7)'>0:""NOW"",1:$$DATE^TIULS(+$P(TIU13,U,7),""MM/DD/CCYY@HR:MIN:SEC""))"
	I $D(ATTNDNG) S DR=DR_";1209//^S X=ATTNDNG"
	E  I $D(EXPCSNR) S DR=DR_";1208//^S X=EXPCSNR"
	S DR=DR_";1204////^S X=$$WHOSIGNS^TIULC1(DA);1208////^S X=$$WHOCOSIG^TIULC1(DA)"
	S DIE=8925 D ^DIE
	S TIU0=$G(^TIU(8925,+DA,0)),TIU12=$G(^(12)),TIU13=$G(^(13))
	;Toggle status between undictated and untranscribed, depending on Dict Date
	S DR=".05///^S X=$S(+$P(TIU13,U,7):""UNTRANSCRIBED"",1:""UNDICTATED"")",DIE=8925 D ^DIE
	D UPDTIRT^TIUDIRT(.TIU,+DA)
DICTX	S MSG(1)="  Dictation data "_$S(TIUCHNG:"",1:"NOT ")_"changed."
	Q
