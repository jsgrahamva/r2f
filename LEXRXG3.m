LEXRXG3	;ISL/KER - Re-Index 757.33 ASRC/ATAR ;08/17/2011
	;;2.0;LEXICON UTILITY;**81**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^LEX(               SACC 1.3
	;    ^LEX(757.33,        SACC 1.3
	;    ^LEX(757.32,        SACC 1.3
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
R75733	; Repair file 757.33
	D RASRC,RATAR
	Q
RASRC	;   Index    ^LEX(757.33,"ASRC",DEF,SRC,TGT,IEN)
	N DA,DIK,LEXBEG,LEXDIF,LEXELP,LEXEND,LEXERR,LEXFI,LEXIDX,LEXIDXT,LEXIEN,LEXMC,LEXNDS,LEXOK,LEXDEF
	S LEXFI="757.33"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.33 ""ASRC""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0,LEXFI=757.33,LEXIDX="ASRC",LEXIDXT="^LEX(757.33,""ASRC"",DEF,SRC,TGT,IEN)"
	N LEXDEF S LEXDEF="" F  S LEXDEF=$O(^LEX(LEXFI,LEXIDX,LEXDEF)) Q:'$L(LEXDEF)  D
	. N LEXSRC S LEXSRC="" F  S LEXSRC=$O(^LEX(LEXFI,LEXIDX,LEXDEF,LEXSRC)) Q:'$L(LEXSRC)  D
	. . N LEXTGT S LEXTGT="" F  S LEXTGT=$O(^LEX(LEXFI,LEXIDX,LEXDEF,LEXSRC,LEXTGT)) Q:'$L(LEXTGT)  D
	. . . N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXDEF,LEXSRC,LEXTGT,LEXIEN)) Q:+LEXIEN'>0  D
	. . . . S LEXNDS=LEXNDS+1 N LEXN0,LEXNH,LEXD,LEXN,LEXT,LEXE,LEXS
	. . . . S LEXN0=$G(^LEX(757.33,+LEXIEN,0))
	. . . . S LEXD=$P(LEXN0,"^",4),LEXN=$P($G(^LEX(757.32,+LEXD,0)),"^",1)
	. . . . S LEXS=$P(LEXN0,"^",2),LEXT=$P(LEXN0,"^",3)
	. . . . Q:'$L(LEXD)  Q:'$L(LEXN)  Q:'$L(LEXS)  Q:'$L(LEXT)
	. . . . I LEXDEF'=LEXN!($TR(LEXSRC," ","")'=LEXS)!($TR(LEXTGT," ","")'=LEXT) D
	. . . . . N DA S DA=LEXIEN S LEXERR=LEXERR+1
	. . . . . K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXDEF,LEXSRC,LEXTGT,LEXIEN)
	. . . . . S:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXN,(LEXS_" "),(LEXT_" "),LEXIEN)=""
	. . . . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Invalid ",LEXN," Rev ",LEXS,?58,"  ",DA
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. N DA,DIK,X,LEXN0,LEXD,LEXN,LEXS,LEXT
	. S DA=LEXIEN,LEXN0=$G(^LEX(757.33,+LEXIEN,0))
	. S LEXN0=$G(^LEX(757.33,+LEXIEN,0))
	. S LEXD=$P(LEXN0,"^",4),LEXN=$P($G(^LEX(757.32,+LEXD,0)),"^",1)
	. S LEXS=$P(LEXN0,"^",2),LEXT=$P(LEXN0,"^",3)
	. Q:'$L(LEXD)  Q:'$L(LEXN)  Q:'$L(LEXS)  Q:'$L(LEXT)
	. I '$D(^LEX(LEXFI,LEXIDX,LEXN,(LEXS_" "),(LEXT_" "),DA)) D
	. . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing ",LEXN," Rev ",LEXS,?58,"  ",DA
	. S ^LEX(LEXFI,LEXIDX,LEXN,(LEXS_" "),(LEXT_" "),DA)=""
	S LEXERR=$S(+LEXERR>0:LEXERR,1:"") I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXIDXT
	H 2 S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	Q
RATAR	;   Index    ^LEX(757.33,"ATAR",DEF,TAR,SRC,IEN)
	N DA,DIK,LEXBEG,LEXDIF,LEXELP,LEXEND,LEXERR,LEXFI,LEXIDX,LEXIDXT,LEXIEN,LEXMC,LEXNDS,LEXOK,LEXDEF
	S LEXFI="757.33"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.33 ""ATAR""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0,LEXFI=757.33,LEXIDX="ATAR",LEXIDXT="^LEX(757.33,""ATAR"",DEF,SRC,TGT,IEN)"
	N LEXDEF S LEXDEF="" F  S LEXDEF=$O(^LEX(LEXFI,LEXIDX,LEXDEF)) Q:'$L(LEXDEF)  D
	. N LEXTGT S LEXTGT="" F  S LEXTGT=$O(^LEX(LEXFI,LEXIDX,LEXDEF,LEXTGT)) Q:'$L(LEXTGT)  D
	. . N LEXSRC S LEXSRC="" F  S LEXSRC=$O(^LEX(LEXFI,LEXIDX,LEXDEF,LEXTGT,LEXSRC)) Q:'$L(LEXSRC)  D
	. . . N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXDEF,LEXTGT,LEXSRC,LEXIEN)) Q:+LEXIEN'>0  D
	. . . . S LEXNDS=LEXNDS+1 N LEXN0,LEXNH,LEXD,LEXN,LEXT,LEXE,LEXS
	. . . . S LEXN0=$G(^LEX(757.33,+LEXIEN,0))
	. . . . S LEXD=$P(LEXN0,"^",4),LEXN=$P($G(^LEX(757.32,+LEXD,0)),"^",1)
	. . . . S LEXS=$P(LEXN0,"^",2),LEXT=$P(LEXN0,"^",3)
	. . . . Q:'$L(LEXD)  Q:'$L(LEXN)  Q:'$L(LEXS)  Q:'$L(LEXT)
	. . . . I LEXDEF'=LEXN!($TR(LEXSRC," ","")'=LEXS)!($TR(LEXTGT," ","")'=LEXT) D
	. . . . . N DA S DA=LEXIEN S LEXERR=LEXERR+1
	. . . . . K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXDEF,LEXTGT,LEXSRC,LEXIEN)
	. . . . . S:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXN,(LEXT_" "),(LEXS_" "),LEXIEN)=""
	. . . . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Invalid ",LEXN," Rev ",LEXS,?58,"  ",DA
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. N DA,DIK,X,LEXN0,LEXD,LEXN,LEXS,LEXT
	. S DA=LEXIEN,LEXN0=$G(^LEX(757.33,+LEXIEN,0))
	. S LEXN0=$G(^LEX(757.33,+LEXIEN,0))
	. S LEXD=$P(LEXN0,"^",4),LEXN=$P($G(^LEX(757.32,+LEXD,0)),"^",1)
	. S LEXS=$P(LEXN0,"^",2),LEXT=$P(LEXN0,"^",3)
	. Q:'$L(LEXD)  Q:'$L(LEXN)  Q:'$L(LEXS)  Q:'$L(LEXT)
	. I '$D(^LEX(LEXFI,LEXIDX,LEXN,(LEXT_" "),(LEXS_" "),DA)) D
	. . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing ",LEXN," Rev ",LEXS,?58,"  ",DA
	. S ^LEX(LEXFI,LEXIDX,LEXN,(LEXT_" "),(LEXS_" "),DA)=""
	S LEXERR=$S(+LEXERR>0:LEXERR,1:"") I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXIDXT
	H 2 S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	Q
	;              
	; Miscellaneous
CLR	;   Clear
	K LEXNAM,LEXTEST,ZTQUEUED
	Q
