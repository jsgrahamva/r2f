TIUR	; SLC/JER - Integrated Document Review ;11/01/03
	;;1.0;TEXT INTEGRATION UTILITIES;**74,79,58,100,113,112,207,224,272,282**;Jun 20, 1997;Build 1
	; 11/30/00 Moved PUTLIST & ADDELMNT to TIUR1
MAKELIST(TIUCLASS,TIUCHVW)	; Get Search Criteria
	N DIRUT,DTOUT,DUOUT,TIUI,SCREEN,STATUS,TIUTYP,TIUSTAT,TIUEDFLT,TIUDCL
	N TIUDPRMT,TIUPICT,TIUOUT,STATWORD,STATIFN,NOWFLAG,TIUSC207,TIU1DOC
	K DIROUT
	D INITRR^TIULRR(0)
	;  TIURPN used in Order Entry 2.5, OR OE/RR MENU CLIN:
	I +$G(ORVP),(+$G(TIUCHVW)'>0) D EN^TIURPN(TIUCLASS,+ORVP) Q
STATUS	;
	; Kill status to clear out the variable when "^" is used to backup
	K STATUS S STATUS=$$STAT
	;VMP/ELR changed status ck from <0 TO <1 to account for entering an *  p224
	I +STATUS<1 S VALMQUIT=1 Q
	S TIUI=0
	F  S TIUI=$O(TIUSTAT(TIUI)) Q:'TIUI!(+$G(TIUOUT))  D
	. I $P($G(TIUSTAT(TIUI)),U,3)="" S TIUOUT=1 Q
	. S STATIFN=$O(^TIU(8925.6,"B",$$UPPER^TIULS($P(TIUSTAT(TIUI),U,3)),0))
	. Q:'STATIFN
	. S STATUS("IFNS")=$G(STATUS("IFNS"))_STATIFN_";"
	I +$G(TIUOUT) S VALMQUIT=1 Q
	S TIUI=1,STATWORD=$$UPPER^TIULS($P(TIUSTAT(1),U,3))
	I +$G(TIUSTAT(4))'>0 F  S TIUI=$O(TIUSTAT(TIUI)) Q:+TIUI'>0  D
	. S STATWORD=STATWORD_$S(TIUI=+TIUSTAT(1):" & ",1:", ")_$$UPPER^TIULS($P(TIUSTAT(TIUI),U,3))
	I +$G(TIUSTAT(4))>0 S STATWORD=$S($P(TIUSTAT(4),U,4)="ALL":"ALL",1:STATWORD_", OTHER")
	S STATUS("WORDS")=STATWORD
DOCTYPE	; Select Document Type(s)
	; TIU207-If only 1 docytyp and have been to screen prompt then go back another level to avoid loop with next prompt.
	I $G(TIUSC207)=1,$G(TIU1DOC)=1 D  G STATUS
	.S (TIUSC207,TIU1DOC)=0
	S (TIUSC207,TIU1DOC)=0
	N TIUDCL K TIUPICT
	I $S(('$D(TIUQUIK)&'$D(ORVP)):1,($D(ORVP)&+$G(TIUCHVW)):1,1:0) D SELTYP^TIULA(TIUCLASS,.TIUTYP,"A","LAST","DOC",0,.TIUDCL,.TIUPICT)
	S TIU1DOC=+$P($G(^TIU(8925.1,+TIUCLASS,10,0)),U,3)
	; SELTYP sets array ^TMP("TIUTYP",$J);
	; SELTYP used to set data into TIUTYP array
	; Now TIUTYP just ="^TMP("TIUTYP",$J)"
	I $S($D(TIUQUIK):1,($D(ORVP)&'+$G(TIUCHVW)):1,1:0) D SELTYP^TIULA(TIUCLASS,.TIUTYP,"F","ALL","DOC",0)
	I +$G(DIROUT) S VALMQUIT=1 Q
	I +$G(@TIUTYP)'>0,'$D(TIUQUIK) G STATUS
SCREEN	;
	S TIUSC207=1
	N TIUNAME,TIUOVER
	S TIUNAME=$P($G(^VA(200,+DUZ,0)),U)
	I $D(TIUQUIK) D  I 1 ; all my unsigned TIUQUIK=1
	. I $G(TIUQUIK)=3 S SCREEN(1)="ALL^ANY" Q
	. S SCREEN(1)="AAU^"_DUZ_U_TIUNAME
	. S:$G(TIUQUIK)=1 SCREEN(2)="ASUP^"_DUZ
	. S SCREEN="ALL"
	E  I $D(ORVP),'+$G(TIUCHVW) S SCREEN(1)="APT^"_+ORVP_U_$P($G(^DPT(+ORVP,0)),U) I 1
	S TIUOVER=""
	E  D SELCAT^TIULA1(.SCREEN,"A","AUTHOR",.TIUOVER)
	I +$G(DIROUT) S VALMQUIT=1 Q
	I $D(SCREEN)'>9 K @TIUTYP G DOCTYPE
	I $D(@TIUTYP)'>9 W !,$C(7),"You must select one or more TITLES..." G SCREEN
	I $G(SCREEN(1))="ALL^ANY",+$G(ORVP) S SCREEN(1)="APT^"_+$G(ORVP)_U_$P($G(^DPT(+$G(ORVP),0)),U)
	D CHECKADD
ERLY	S TIUEDFLT=$S(TIUCLASS=3:"T-2",TIUCLASS=244:"T-30",1:"T-7")
	S TIUDPRMT=$S(TIUCLASS=244:"Discharge",1:"Reference")
	S TIUEDT=$S($D(TIUQUIK):1,$D(ORVP)&(+$G(TIUCHVW)'>0):$$FMADD^XLFDT(DT,$S($D(^DPT(+$G(ORVP),.1))'>0:-180,1:-30)),1:$P($$EDATE^TIULA(TIUDPRMT,"",TIUEDFLT),U))
	I +$G(DIROUT) S VALMQUIT=1 Q
	I TIUEDT'>0 G SCREEN
	S TIULDT=$S($D(TIUQUIK):9999999,$D(ORVP)&(+$G(TIUCHVW)'>0):+$$NOW^XLFDT,1:$P($$LDATE^TIULA(TIUDPRMT),U))
	I +$G(DIROUT) S VALMQUIT=1 Q
	I TIULDT'>0 G ERLY
	I TIUEDT>TIULDT D SWAP(.TIUEDT,.TIULDT)
	I $L(TIULDT,".")=1 D EXPRANGE(.TIUEDT,.TIULDT)
	; -- Reset late date to NOW on rebuild:
	S NOWFLAG=$S(TIULDT-$$NOW^XLFDT<.0001:1,1:0)
	I '$G(TIURBLD) W !,"Searching for the documents."
	D BUILD(TIUCLASS,.STATUS,.SCREEN,TIUEDT,TIULDT,NOWFLAG) ;11/30/00 removed param TIUTYP since BUILD uses global now.
	; -- If attaching ID note & changed view,
	;    update video for line to be attached: --
	I $G(TIUGLINK) D RESTOREG^TIULM(.TIUGLINK)
	;K @TIUTYP ;11/30/00 keep ^TMP("TIUTYP",$J) for rebuild
	Q
STAT()	; Determine status
	N TIUY
	I +$G(TIUQUIK) D  G STATX
	. S TIUY=$$SELSTAT^TIULA(.TIUSTAT,"F",$S(TIUQUIK=1:"UNSIGNED,UNCOSIGNED",TIUQUIK>1:"UNDICTATED,UNTRANSCRIBED"))
	I $D(ORVP),'+$G(TIUCHVW) D  G STATX
	. S TIUY=$$SELSTAT^TIULA(.TIUSTAT,"F","COMPLETED")
	S TIUY=$$SELSTAT^TIULA(.TIUSTAT,"A",$$DFLTSTAT^TIURM(DUZ))
STATX	Q TIUY
CHECKADD	; Checks whether Addendum is included in the list of types
	N TIUI,HIT,NUMTYPS
	S (TIUI,HIT)=0
	F  S TIUI=$O(^TMP("TIUTYP",$J,TIUI)) Q:+TIUI'>0!+HIT  I $$UP^XLFSTR(^TMP("TIUTYP",$J,TIUI))["ADDENDUM" S HIT=1
	S NUMTYPS=^TMP("TIUTYP",$J)
	I +HIT'>0 S ^TMP("TIUTYP",$J,NUMTYPS+1)=+^TMP("TIUTYP",$J,NUMTYPS)+1_U_"81^Addendum^NOT PICKED",^TMP("TIUTYP",$J)=^TMP("TIUTYP",$J)+1
	Q
	;
SWAP(TIUX,TIUY)	; Swap variables
	N TIUTMP S TIUTMP=TIUX,TIUX=TIUY,TIUY=TIUTMP
	Q
EXPRANGE(TIUX,TIUY)	; Expand late date to include time
	;P74 If user entered date/time = T, then numerical date time is FIRST ^ PIECE ONLY of TIUX & TIUY.
	I $P(TIUY,U)=DT S TIUY=$$NOW^XLFDT I 1
	E  S TIUY=$P(TIUY,U)_"."_235959 ;P74 Add seconds
	Q
BUILD(TIUCLASS,STATUS,SCREEN,EARLY,LATE,NOWFLAG)	; Build List.
	;11/30/00 - removed param TYPES. 12/3 added param TIUCLASS
	; BUILD (GATHER) uses docmt type info from ^TMP("TIUTYP",$J)
	N TIUDT,TIUI,TIUK
	N TIUT,TIUTP,XREF,TIUS,TIUPREF
	S TIUPREF=$$PERSPRF^TIULE(DUZ),(TIUK,VALMCNT)=0
	K ^TMP("TIUR",$J),^TMP("TIURIDX",$J),^TMP("TIUI",$J)
	; If user entered NOW at first build, update NOW for rebuild;
	; Save data in ^TMP("TIURIDX",$J,0) for rebuild:
	I $G(TIURBLD),$G(NOWFLAG) S LATE=$$NOW^XLFDT
	S ^TMP("TIURIDX",$J,0)=+EARLY_U_+LATE_U_$G(STATUS("IFNS"))_U_NOWFLAG
	S ^TMP("TIUR",$J,"RTN")="TIUR"
	S ^TMP("TIUR",$J,"TITLE OVERRIDE")=$G(TIUOVER)
	I '$D(TIUPRM0) D SETPARM^TIULE
	S EARLY=9999999-+$G(EARLY),LATE=9999999-$S(+$G(LATE):+$G(LATE),1:3333333)
	F  S TIUK=$O(SCREEN(TIUK)) Q:TIUK'>0  D
	. I $G(SCREEN)'="ALL" S SCREEN=$G(TIUK)
	. S XREF=$P(SCREEN(TIUK),U)
	. I XREF'="ASUB" D
	. . S TIUI=$S(XREF'="APRB":$P(SCREEN(TIUK),U,2),1:$$UPPER^TIULS($P(SCREEN(TIUK),U,3)))
	. . D GATHER^TIUR1(TIUI,TIUPREF,TIUCLASS,STATUS("IFNS"),EARLY,LATE,XREF,SCREEN)
	. ;*282 - Search by multiple terms 
	. I XREF="ASUB" D
	. . N TIUSUBJ
	. . S TIUSUBJ=$S($P(SCREEN(TIUK),U,2)[" ":$P($P(SCREEN(TIUK),U,2)," "),1:$P(SCREEN(TIUK),U,2))
	. . S TIUI=$O(^TIU(8925,XREF,TIUSUBJ),-1)
	. . F  S TIUI=$O(^TIU(8925,XREF,TIUI)) Q:TIUI=""!(TIUI'[TIUSUBJ)  D GATHER^TIUR1(TIUI,TIUPREF,TIUCLASS,STATUS("IFNS"),EARLY,LATE,XREF,SCREEN)
	. . I $P(SCREEN(TIUK),U,2)[" " D
	. . . N TIUIEN,TIUX,TIUY
	. . . S TIUX=0 F  S TIUX=$O(^TMP("TIUI",$J,TIUX)) Q:TIUX=""  D
	. . . . S TIUY=0 F  S TIUY=$O(^TMP("TIUI",$J,TIUX,TIUY)) Q:TIUY=""  D
	. . . . . S TIUIEN=0 F  S TIUIEN=$O(^TMP("TIUI",$J,TIUX,TIUY,TIUIEN)) Q:TIUIEN=""  I $$UP^XLFSTR(^TIU(8925,TIUIEN,17))'[($P(SCREEN(TIUK),U,2)) K ^TMP("TIUI",$J,TIUX,TIUY,TIUIEN)
	D PUTLIST^TIUR2(TIUPREF,TIUCLASS,.STATUS,.SCREEN)
	K ^TMP("TIUI",$J)
	Q
	;
CLEAN	; Clean up your mess!
	K ^TMP("TIUR",$J),^TMP("TIURIDX",$J) D CLEAN^VALM10,KILLRR^TIULRR
	K VALMY
	K ^TMP("TIUTYP",$J)
	Q
	;
RBLD	; Rebuild list after actions 11/30/00
	N TIUEXP,TIUR0,TIURIDX0,TIUSCRN,TMP,TIUEDT,TIULDT,TIUSTAT
	N TIURBLD,TIUI,TIUCLASS,NOWFLAG
	S TIURBLD=1
	D FIXLSTNW^TIULM ;restore video for elements added to end of list
	I +$O(^TMP("TIUR",$J,"EXPAND",0)) D
	. M TIUEXP=^TMP("TIUR",$J,"EXPAND")
	S TIUR0=^TMP("TIUR",$J,0),TIURIDX0=^TMP("TIURIDX",$J,0)
	S TIUSCRN=$P(TIUR0,U,3,99),TIUCLASS=^TMP("TIUR",$J,"CLASS")
	S TIUI=1
	F  S TMP=$P(TIUSCRN,";",TIUI) Q:TMP=""  D
	. S TIUSCRN(TIUI)=TMP,TIUI=TIUI+1
	S TIUSCRN=$L(TIUSCRN,";")
	S STATUS("WORDS")=$P(TIUR0,U,2)
	S STATUS("IFNS")=$P(TIURIDX0,U,3)
	S TIUEDT=$P(TIURIDX0,U),TIULDT=$P(TIURIDX0,U,2),NOWFLAG=+$P(TIURIDX0,U,4)
	;VMP/ELR ADDED THE FOLLOWING LINE IN PATCH 224
	S TIUSCRN="ALL"
	D BUILD(TIUCLASS,.STATUS,.TIUSCRN,TIUEDT,TIULDT,NOWFLAG)
	; Reexpand previously expanded items:
	D RELOAD^TIUROR1(.TIUEXP)
	D BREATHE^TIUROR1(1)
	Q