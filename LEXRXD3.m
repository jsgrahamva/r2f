LEXRXD3	;ISL/KER - Re-Index 757.02 ADCODE/APCODE ;08/17/2011
	;;2.0;LEXICON UTILITY;**81**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^LEX(               SACC 1.3
	;    ^LEX(757.02,        SACC 1.3
	;    ^LEX(757,           SACC 1.3
	;    ^LEX(757.03,        SACC 1.3
	;               
	; External References
	;    $$FMDIFF^XLFDT      ICR  10103
	;    $$NOW^XLFDT         ICR  10103
	;               
	; Local Variables NEWed or KILLed Elsewhere
	;     LEXNAM     Task name       NEWed/KILLed by LEXRXXT
	;     LEXTEST    Test variable   NEWed/KILLed by Developer
	;     ZTQUEUED   Task flag       NEWed/KILLed by Taskman
	;               
	Q
EN	; Main Entry Point
R75702	; Repair file 757.02
	D RADCODE,RAPCODE Q
RADCODE	;   Index    ^LEX(757.02,"ADCODE",CODE,IEN) 
	N DA,DIK,LEXBEG,LEXDIF,LEXELP,LEXEND,LEXERR,LEXFI,LEXIDX,LEXIDXT,LEXIEN,LEXNDS,LEXOK,LEXSO,LEXST
	S LEXFI="757.02"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.02 ""ADCODE""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0,LEXST="",LEXFI=757.02,LEXIDX="ADCODE",LEXIDXT="^LEX(757.02,""ADCODE"",CODE,IEN)"
	F  S LEXST=$O(^LEX(LEXFI,LEXIDX,LEXST)) Q:'$L(LEXST)  D
	. N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXST,LEXIEN)) Q:+LEXIEN'>0  D
	. . S LEXNDS=LEXNDS+1 N LEXOK,LEXDF,LEXSO S LEXSO=$P($G(^LEX(757.02,LEXIEN,0)),U,2) I '$L(LEXSO) D  Q
	. . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXST,LEXIEN)
	. . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,LEXST,?58,"  ",LEXIEN
	. . S LEXDF=$P($G(^LEX(757.02,LEXIEN,0)),U,6) I +LEXDF'>0 D  Q
	. . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXST,LEXIEN)
	. . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,LEXST,?58,"  ",LEXIEN
	. . S LEXOK=0 S:(LEXSO_" ")=LEXST LEXOK=1 I 'LEXOK D
	. . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXST,LEXIEN)
	. . . S:$L(LEXSO)&(+LEXDF=1) ^LEX(LEXFI,LEXIDX,(LEXSO_" "),LEXIEN)=""
	. . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,LEXST,?58,"  ",LEXIEN
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. N DA,X,DIK,LEXDF,LEXSO S DA=LEXIEN,LEXSO=$P($G(^LEX(LEXFI,DA,0)),U,2),(X,LEXDF)=$P($G(^LEX(LEXFI,DA,0)),U,6) Q:'$L(LEXSO)
	. I X=1,'$D(^LEX(LEXFI,LEXIDX,(LEXSO_" "),DA)) D
	. . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing ",LEXSO,?58,"  ",DA
	. I X'=1,$D(^LEX(LEXFI,LEXIDX,(LEXSO_" "),DA)) D
	. . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Invalid (deleted)",?58,"  ",DA
	. S:X=1 ^LEX(LEXFI,LEXIDX,(LEXSO_" "),DA)="" K:X'=1&('$D(LEXTEST)) ^LEX(LEXFI,LEXIDX,(LEXSO_" "),DA)
	S LEXERR=$S(+LEXERR>0:LEXERR,1:"") I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXIDXT
	S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	Q
RAPCODE	;   Index    ^LEX(757.02,"APCODE",CODE,IEN) 
	N DA,DIK,LEXBEG,LEXDIF,LEXELP,LEXEND,LEXERR,LEXFI,LEXIDX,LEXIDXT,LEXIEN,LEXNDS,LEXOK,LEXPF,LEXSO,LEXST
	S LEXFI="757.02"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.02 ""APCODE""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0,LEXST="",LEXFI=757.02,LEXIDX="APCODE",LEXIDXT="^LEX(757.02,""APCODE"",CODE,IEN) "
	F  S LEXST=$O(^LEX(LEXFI,LEXIDX,LEXST)) Q:'$L(LEXST)  D
	. N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXST,LEXIEN)) Q:+LEXIEN'>0  D
	. . S LEXNDS=LEXNDS+1 N LEXOK,LEXSO,LEXPF S LEXSO=$P($G(^LEX(757.02,LEXIEN,0)),U,2),LEXPF=$P($G(^LEX(757.02,LEXIEN,0)),U,5)
	. . K:'$D(LEXTEST)&(+LEXPF'>0) ^LEX(LEXFI,LEXIDX,LEXST,LEXIEN) Q:+LEXPF'>0
	. . S LEXOK=0 S:(LEXSO_" ")=LEXST LEXOK=1 I 'LEXOK D
	. . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXST,LEXIEN) S:$L(LEXSO) ^LEX(LEXFI,LEXIDX,(LEXSO_" "),LEXIEN)=""
	. . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,LEXST,?58,"  ",LEXIEN
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. N DA,DIK,LEXSO,LEXPF S DA=LEXIEN,LEXSO=$P($G(^LEX(757.02,DA,0)),U,2),LEXPF=$P($G(^LEX(757.02,DA,0)),U,5) Q:'$L(LEXSO)
	. I LEXPF>0,'$D(^LEX(LEXFI,LEXIDX,(LEXSO_" "),DA)) D
	. . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing ",LEXSO,?58,"  ",DA
	. I LEXPF'>0,$D(^LEX(LEXFI,LEXIDX,(LEXSO_" "),DA)) D
	. . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Invalid (deleted) ",LEXSO,?58,"  ",DA
	. S:LEXPF>0 ^LEX(LEXFI,LEXIDX,(LEXSO_" "),DA)="" K:LEXPF'>0&('$D(LEXTEST)) ^LEX(LEXFI,LEXIDX,(LEXSO_" "),DA)
	S LEXERR=$S(+LEXERR>0:LEXERR,1:"") I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXIDXT
	S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	Q
	;              
	; Miscellaneous
CLR	;   Clear
	K LEXNAM,LEXTEST,ZTQUEUED
	Q
