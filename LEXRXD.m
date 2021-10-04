LEXRXD	;ISL/KER - Re-Index 757.02 B/ACODE/ACT ;12/19/2014
	;;2.0;LEXICON UTILITY;**81,80,86**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^LEX(               SACC 1.3
	;    ^LEX(757.02)        SACC 1.3
	;    ^TMP("LEXRX")       SACC 2.3.2.5.1
	;               
	; External References
	;    $$FMDIFF^XLFDT      ICR  10103
	;    $$NOW^XLFDT         ICR  10103
	;    FILE^DID            ICR   2052
	;    IX1^DIK             ICR  10013
	;    ^DIM                ICR  10016
	;               
	; Local Variables NEWed or KILLed Elsewhere
	;     LEXNAM     Task name       NEWed/KILLed by LEXRXXT
	;     LEXSET     Re-Index flag   NEWed/KILLed by LEXRXXT
	;     LEXTEST    Test variable   NEWed/KILLed by Developer
	;     LEXQ       Quiet flat      NEWed/KILLed by LEXRXXT2
	;     ZTQUEUED   Task flag       NEWed/KILLed by Taskman
	;               
	Q
EN	; Main Entry Point
R75702	; Repair file 757.02
	D RB,RACODE,RACT,R75702^LEXRXD2,R75702^LEXRXD3,R75702^LEXRXD4
	D:+($G(^TMP("LEXRX",$J,"ERR",757.02)))>0 SET
	Q
RB	;   Index    ^LEX(757.02,"B",EXP,IEN) 
	;            ^LEX(757.02,IEN,4,"B",EFF,IEN2)
	N DA,DIK,LEXBEG,LEXDIF,LEXED,LEXELP,LEXEND,LEXERR,LEXEXP,LEXFI,LEXIDX,LEXIDXT,LEXIDST,LEXIEN,LEXMC,LEXNDS,LEXNDSS,LEXOK,LEXS,LEXSER,LEXSTR
	S LEXFI="757.02"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.02 ""B""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXNDSS,LEXERR,LEXSER)=0,LEXSTR="",LEXFI="757.02",LEXIDX="B",LEXIDXT="^LEX(757.02,""B"",EXP,IEN)"
	S LEXIDST="^LEX(757.02,IEN,4,""B"",EFF,IEN2)" F  S LEXSTR=$O(^LEX(LEXFI,LEXIDX,LEXSTR)) Q:'$L(LEXSTR)  D
	. N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN)) Q:+LEXIEN'>0  D
	. . S LEXNDS=LEXNDS+1 N LEXOK,LEXEXP S LEXEXP=$P($G(^LEX(LEXFI,LEXIEN,0)),"^",1)
	. . S LEXOK=0 S:LEXEXP=LEXSTR LEXOK=1
	. . I 'LEXOK  D
	. . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN)
	. . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,LEXSTR,?58,"  ",LEXIEN
	. . S:$L(LEXEXP) ^LEX(LEXFI,LEXIDX,LEXEXP,LEXIEN)=""
	. . I $D(^LEX(LEXFI,LEXIEN,4)) D
	. . . N LEXSTR S LEXSTR="" F  S LEXSTR=$O(^LEX(LEXFI,LEXIEN,4,LEXIDX,LEXSTR)) Q:'$L(LEXSTR)  D
	. . . . N LEXS S LEXS=0 F  S LEXS=$O(^LEX(LEXFI,LEXIEN,4,LEXIDX,LEXSTR,LEXS)) Q:+LEXS'>0  D
	. . . . . S LEXNDSS=+($G(LEXNDSS))+1 N LEXOK,LEXED S LEXED=$P($G(^LEX(LEXFI,LEXIEN,4,LEXS,0)),"^",1)
	. . . . . S LEXOK=0 S:LEXED=LEXSTR LEXOK=1
	. . . . . I 'LEXOK D
	. . . . . . S LEXSER=LEXSER+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIEN,4,LEXIDX,LEXSTR,LEXS)
	. . . . . . I '$D(ZTQUEUED) W !,?10,757.28,?19,LEXIDX,?30,LEXSTR,?58,"  ",LEXIEN,"/",LEXS
	. . . . . S:$L(LEXED) ^LEX(LEXFI,LEXIEN,4,LEXIDX,LEXED,LEXS)=""
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. N DA,X S X=$P($G(^LEX(LEXFI,LEXIEN,0)),"^",1) I $L(X) D
	. . S DA=LEXIEN
	. . I '$D(^LEX(LEXFI,LEXIDX,X,DA)) D
	. . . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing ",X,?58,"  ",DA
	. . S:$L(X) ^LEX(LEXFI,LEXIDX,X,DA)=""
	. I $D(^LEX(LEXFI,LEXIEN,4)) D
	. . N LEXS S LEXS=0 F  S LEXS=$O(^LEX(LEXFI,LEXIEN,4,LEXS)) Q:+LEXS'>0  D
	. . . N DA,X S DA(1)=LEXIEN,DA=LEXS,X=$P($G(^LEX(LEXFI,DA(1),4,DA,0)),"^",1) I $L(X) D
	. . . . I '$D(^LEX(LEXFI,DA(1),4,LEXIDX,X,DA)) D
	. . . . . S LEXSER=LEXSER+1 I '$D(ZTQUEUED) W !,?10,757.28,?19,LEXIDX,?30,"Missing ",X,?58,"  ",DA(1),"/",DA
	. . . . S:$L(X) ^LEX(LEXFI,DA(1),4,LEXIDX,X,DA)=""
	S LEXERR=$S(+LEXERR>0:LEXERR,1:"") I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXIDXT
	S LEXSER=$S(+LEXSER>0:LEXSER,1:"") I '$D(ZTQUEUED) W !,$J(LEXSER,5),?10,757.28,?19,LEXIDX,?30,LEXIDST
	S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	D REP^LEXRXXS(LEXFI,757.28,LEXIDX,LEXNDSS,LEXSER,LEXIDST)
	Q
RACODE	;   Index    ^LEX(757.02,"ACODE",CODE,IEN) 
	N DA,DIK,LEXBEG,LEXDF,LEXDIF,LEXELP,LEXEND,LEXERR,LEXFI,LEXIDX,LEXIDXT,LEXIEN,LEXNDS,LEXOK,LEXSO,LEXSTR
	S LEXFI="757.02"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.02 ""ACODE""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0,LEXSTR="",LEXFI=757.02,LEXIDX="ACODE",LEXIDXT="^LEX(757.02,""ACODE"",CODE,IEN)"
	F  S LEXSTR=$O(^LEX(LEXFI,LEXIDX,LEXSTR)) Q:'$L(LEXSTR)  D
	. N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN)) Q:+LEXIEN'>0  D
	. . S LEXNDS=LEXNDS+1 N LEXOK,LEXDF,LEXSO S LEXDF=+$P($G(^LEX(757.02,LEXIEN,0)),U,6)
	. . S LEXSO=$P($G(^LEX(757.02,LEXIEN,0)),U,2)
	. . K:'$D(LEXTEST)&(+LEXDF>0) ^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN) Q:+LEXDF>0
	. . S LEXOK=0 S:(LEXSO_" ")=LEXSTR LEXOK=1 I 'LEXOK D
	. . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN) S:+LEXDF'>0&($L(LEXSO)) ^LEX(LEXFI,LEXIDX,(LEXSO_" "),LEXIEN)=""
	. . . I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXSTR,?58,"  ",LEXIEN
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. Q:+($P($G(^LEX(LEXFI,LEXIEN,0)),"^",6))>0
	. N DA,X S DA=LEXIEN,X=$P($G(^LEX(LEXFI,DA,0)),"^",2) Q:'$L(X)
	. I '$D(^LEX(LEXFI,LEXIDX,(X_" "),DA)) D
	. . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing ",X,?58,"  ",DA
	. S ^LEX(LEXFI,LEXIDX,(X_" "),DA)=""
	S LEXERR=$S(+LEXERR>0:LEXERR,1:"") I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXIDXT
	S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	Q
RACT	;   Index    ^LEX(757.02,"ACT",CODE,STA,DATE,IEN,HIS)
	N DA,DIK,LEXBEG,LEXDIF,LEXDT,LEXEF,LEXELP,LEXEND,LEXERR,LEXFI,LEXIDT,LEXIDX,LEXIDXT,LEXIEN,LEXIHS,LEXISO,LEXIST,LEXN0,LEXN1
	N LEXN1X,LEXN2,LEXN2X,LEXNDS,LEXNH,LEXNI,LEXNIX,LEXPF,LEXSO,LEXST,LEXTS,X
	S LEXFI="757.02"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.02 ""ACT""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0,LEXFI=757.02,LEXIDX="ACT",LEXISO="",LEXIDXT="^LEX(757.02,""ACT"",CODE,ST,DT,IEN,HIS)"
	F  S LEXISO=$O(^LEX(LEXFI,LEXIDX,LEXISO)) Q:'$L(LEXISO)  D
	. N LEXIST S LEXIST="" F  S LEXIST=$O(^LEX(LEXFI,LEXIDX,LEXISO,LEXIST)) Q:'$L(LEXIST)  D
	. . N LEXIDT S LEXIDT=0 F  S LEXIDT=$O(^LEX(LEXFI,LEXIDX,LEXISO,LEXIST,LEXIDT)) Q:+LEXIDT'>0  D
	. . . N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXISO,LEXIST,LEXIDT,LEXIEN)) Q:+LEXIEN'>0  D
	. . . . N LEXIHS S LEXIHS=0 F  S LEXIHS=$O(^LEX(LEXFI,LEXIDX,LEXISO,LEXIST,LEXIDT,LEXIEN,LEXIHS)) Q:+LEXIHS'>0  D
	. . . . . S LEXNDS=LEXNDS+1 N LEXSO,LEXST,LEXTS,LEXDT,LEXPF,LEXN0,LEXNH,LEXEF,LEXNI,LEXNIX,LEXN1,LEXN1X,LEXN2,LEXN2X S LEXEF=0
	. . . . . S LEXN0=$G(^LEX(757.02,LEXIEN,0)),LEXNH=$G(^LEX(757.02,LEXIEN,4,LEXIHS,0))
	. . . . . S LEXSO=$P(LEXN0,U,2),LEXPF=$P(LEXN0,U,5),LEXDT=$P(LEXNH,U,1),LEXST=$P(LEXNH,U,2)
	. . . . . S LEXTS=LEXST S:+LEXPF>0 LEXTS=LEXTS+2
	. . . . . S LEXNI="^LEX("_LEXFI_","""_LEXIDX_""","""_LEXISO_""","_LEXIST_","_LEXIDT_","_LEXIEN_","_LEXIHS_")"
	. . . . . S LEXN1="^LEX("_LEXFI_","""_LEXIDX_""","""_LEXSO_" "","_LEXST_","_LEXDT_","_LEXIEN_","_LEXIHS_")"
	. . . . . S LEXN2="^LEX("_LEXFI_","""_LEXIDX_""","""_LEXSO_" "","_LEXTS_","_LEXDT_","_LEXIEN_","_LEXIHS_")"
	. . . . . S X="K "_LEXNI D ^DIM Q:'$L($G(X))  S LEXNIX=$G(X)
	. . . . . S X="S "_LEXN1_"=""""" D ^DIM Q:'$L($G(X))  S LEXN1X=$G(X)
	. . . . . S X="S "_LEXN2_"=""""" D ^DIM Q:'$L($G(X))  S LEXN2X=$G(X)
	. . . . . X:'$D(LEXTEST)&(LEXNI'=LEXN1)&(LEXNI'=LEXN2) LEXNIX
	. . . . . I LEXNI'=LEXN1,LEXNI'=LEXN2 D
	. . . . . . S LEXERR=LEXERR+1
	. . . . . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,LEXSO,?58,"  ",LEXIEN W:+LEXIHS>0 "/",+LEXIHS
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. N LEXIHS S LEXIHS=0 F  S LEXIHS=$O(^LEX(LEXFI,LEXIEN,4,LEXIHS)) Q:+LEXIHS'>0  D
	. . N DA,DIK,LEXSO,LEXPF,LEXDT,LEXST,LEXTS S DA(1)=LEXIEN,DA=LEXIHS
	. . S LEXSO=$P($G(^LEX(LEXFI,DA(1),0)),U,2),LEXPF=$P($G(^LEX(LEXFI,DA(1),0)),U,5)
	. . S LEXDT=$P($G(^LEX(LEXFI,DA(1),4,DA,0)),U,1) Q:LEXDT'?7N  S LEXST=$P($G(^LEX(LEXFI,DA(1),4,DA,0)),U,2) Q:LEXST'?1N
	. . S LEXTS=LEXST S:+LEXPF>0 LEXTS=LEXTS+2
	. . I '$D(^LEX(LEXFI,LEXIDX,(LEXSO_" "),+LEXST,+LEXDT,DA(1),DA)) D
	. . . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing ",LEXST,"/",LEXDT,?58,"  ",DA(1),"/",DA
	. . I LEXTS>LEXST,'$D(^LEX(LEXFI,LEXIDX,(LEXSO_" "),+LEXTS,+LEXDT,DA(1),DA)) D
	. . . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing ",LEXTS,"/",LEXDT,?58,"  ",DA(1),"/",DA
	. . S:$L(LEXSO)&($L(LEXST))&($L(LEXDT)) ^LEX(LEXFI,LEXIDX,(LEXSO_" "),+LEXST,+LEXDT,DA(1),DA)=""
	. . I LEXTS>LEXST S:$L(LEXSO)&($L(LEXTS))&($L(LEXDT)) ^LEX(LEXFI,LEXIDX,(LEXSO_" "),+LEXTS,+LEXDT,DA(1),DA)=""
	S LEXERR=$S(+LEXERR>0:LEXERR,1:"") I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXIDXT
	S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	Q
	;              
	; Miscellaneous
SET	;   Re-Index 
	Q:'$D(LEXSET)  N LEXTC,LEXPRE,LEXBEG,LEXEND,LEXELP,LEXNM,LEXFI,LEXRT,LEXIEN,LEXP3,LEXP4
	N LEXOUT,LEXMSG,ZTQUEUED,ZTREQ,ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE S LEXFI=757.02
	D FILE^DID(LEXFI,"N","GLOBAL NAME","LEXOUT","LEXMSG") S LEXRT=$G(LEXOUT("GLOBAL NAME")) Q:LEXRT'["^LEX"
	S LEXPRE=$G(^TMP("LEXRX",$J,"T",1,"ELAP")),LEXBEG=$$NOW^XLFDT,LEXNM=$$FN^LEXRXXM(LEXFI)
	S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,("Re-Indexing File #"_LEXFI)) Q:LEXTC=1  I 1 D
	. N ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE S ZTRTN="SETIX^LEXRXD" S ZTDESC="Set 757.02 Indexes"
	. S ZTSAVE("LEXRT")="",ZTSAVE("LEXFI")="",ZTIO="",ZTDTH=$H D ^%ZTLOAD
	Q:$D(LEXQ)  S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,"ALLIX",,,"Re-Index",LEXELP)
	S LEXELP=$$ADDT^LEXRXXM(LEXELP,LEXPRE)
	S ^TMP("LEXRX",$J,"T",1,"ELAP")=LEXELP
	Q
SETIX	;   Set Indexes (Set logic only)
	S:$D(ZTQUEUED) ZTREQ="@" W:'$D(ZTQUEUED) !,?8,"Re-Indexing",! N DIK,LEXP3,LEXP4,LEXIEN
	Q:'$L($G(LEXRT))  Q:'$L($G(LEXFI))  S DIK=LEXRT D IXALL^DIK S (LEXP3,LEXP4,LEXIEN)=0
	F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  S LEXP3=LEXIEN,LEXP4=LEXP4+1
	S $P(^LEX(LEXFI,0),"^",3)=LEXP3,$P(^LEX(LEXFI,0),"^",4)=LEXP4
	Q
CLR	;   Clear
	K LEXNAM,LEXSET,LEXTEST,ZTQUEUED,LEXQ
	Q