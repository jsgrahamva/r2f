LEXDDSD	;ISL/KER - Display Defaults - Single User Disp ;04/21/2014
	;;2.0;LEXICON UTILITY;**80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^TMP("LEXDIC")      SACC 2.3.2.5.1
	;               
	; External References
	;    ^DIR                ICR  10026
	;               
LEXSHOW	; Translate LEXSHOW
	D:$G(^LEXT(757.2,LEXAP,200,DUZ,2))'=""
	. D DIS^LEXDDSS($G(^LEXT(757.2,LEXAP,200,DUZ,2.5)))
	. D CODES(^LEXT(757.2,LEXAP,200,DUZ,2))
	D:$G(^LEXT(757.2,LEXAP,200,DUZ,2))=""
	. D DIS^LEXDDSS("No default display defined")
	Q
DICS	; Save filter in array LEX(
	N LEXID,LEXIC,LEXEC,LEXCLA
	N LEXCTR,LEXXI,LEXXE,LEXCT
	D LB^LEXDDSS("      Include:                           Exclude:")
	S LEXID="",(LEXIC,LEXEC)=0
	I $D(^TMP("LEXDIC",$J,"INC","CLASS")) D
	. F  S LEXID=$O(^TMP("LEXDIC",$J,"INC","CLASS",LEXID)) Q:LEXID=""  D
	. . Q:'$D(^LEX(757.11,"B",LEXID))
	. . S LEXCLA=$O(^LEX(757.11,"B",LEXID,0)),LEXIC=LEXIC+1
	. . S ^TMP("LEXDIC",$J,"INCLUDE",LEXIC,$P(^LEX(757.11,LEXCLA,0),U,2))=""
	I $D(^TMP("LEXDIC",$J,"INC","TYPE")) D
	. S LEXID=0
	. F  S LEXID=$O(^TMP("LEXDIC",$J,"INC","TYPE",LEXID)) Q:+LEXID=0  D
	. . S LEXIC=LEXIC+1
	. . S ^TMP("LEXDIC",$J,"INCLUDE",LEXIC,$P(^LEX(757.12,LEXID,0),U,2))=""
	I $D(^TMP("LEXDIC",$J,"EXC","CLASS")) D
	. F  S LEXID=$O(^TMP("LEXDIC",$J,"EXC","CLASS",LEXID)) Q:LEXID=""  D
	. . Q:'$D(^LEX(757.11,"B",LEXID))
	. . S LEXCLA=$O(^LEX(757.11,"B",LEXID,0)),LEXEC=LEXEC+1
	. . S ^TMP("LEXDIC",$J,"EXCLUDE",LEXEC,$P(^LEX(757.11,LEXCLA,0),U,2))=""
	I $D(^TMP("LEXDIC",$J,"EXC","TYPE")) D
	. S LEXID=0
	. F  S LEXID=$O(^TMP("LEXDIC",$J,"EXC","TYPE",LEXID)) Q:+LEXID=0  D
	. . S LEXEC=LEXEC+1
	. . S ^TMP("LEXDIC",$J,"EXCLUDE",LEXEC,$P(^LEX(757.12,LEXID,0),U,2))=""
	S LEXCTR=$S(LEXIC>LEXEC:LEXIC,1:LEXEC)
	N LEXXI,LEXXE F LEXCT=1:1:LEXCTR D
	. S (LEXXI,LEXXE)=""
	. S:$D(^TMP("LEXDIC",$J,"INCLUDE",LEXCT)) LEXXI=$E($O(^TMP("LEXDIC",$J,"INCLUDE",LEXCT,"")),1,35)
	. S:$D(^TMP("LEXDIC",$J,"EXCLUDE",LEXCT)) LEXXE=$E($O(^TMP("LEXDIC",$J,"EXCLUDE",LEXCT,"")),1,35)
	. D FIE^LEXDDSS(LEXXI,LEXXE)
	K ^TMP("LEXDIC",$J) Q
	Q
CODES(LEXSTR)	; Save contents of LEXSHOW in local array LEX(
	N LEXCT F LEXCT=1:1:$L(LEXSTR,"/") D DISE^LEXDDSS(($P(LEXSTR,"/",LEXCT)))
	D:$L(LEXSTR,"/")>0 BL^LEXDDSS Q
DP	; Display single user defaults in array LEX( continuous
	N LEXC Q:+($G(LEX(0)))=0  F LEXC=1:1:LEX(0) W !,LEX(LEXC)
	K LEX
	Q
DSPLY	; Display Defaults contained in LEX(
	Q:'$D(LEX(0))  N LEXC,LEXLC,LEXI S LEXC="",LEXLC=0
	F LEXI=1:1:LEX(0) D  Q:$G(LEXC)[U
	. W !,LEX(LEXI) D LF Q:$G(LEXC)[U
	D:LEXC'[U&(IOST["C-") CONT W:IOST["P-" @IOF
	K LEX Q
LF	; Line Feed
	Q:LEXI=LEX(0)  S LEXLC=LEXLC+1
	I IOST["P-",LEXLC>(IOSL-7) D CONT
	I IOST'["P-",LEXLC>(IOSL-4) D CONT
	Q
CONT	; Page/Form Feed
	S LEXLC=0 I IOST["P-" W @IOF Q
	W ! S DIR("?")="  Additional information is available"
	S LEXC="" N X,Y S DIR(0)="E" D ^DIR
	S:$D(DTOUT)!(X[U) LEXC=U
	K DIR,DTOUT,DUOUT,DIRUT,DIROUT W ! Q
