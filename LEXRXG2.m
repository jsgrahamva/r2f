LEXRXG2	;ISL/KER - Re-Index 757.33 ACT/AMAP/AREV ;08/17/2011
	;;2.0;LEXICON UTILITY;**81**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^LEX(               SACC 1.3
	;    ^LEX(757.33,        SACC 1.3
	;    ^LEX(757.32,        SACC 1.3
	;               
	; External References
	;    $$FMDIFF^XLFDT      ICR  10103
	;    $$FMTE^XLFDT        ICR  10103
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
	D RACT,RAMAP,RAREV
	Q
RACT	;   Index    ^LEX(757.33,"ACT",SRC,TGT,EFF,STA,IEN,HIS)
	N DA,DIK,LEXBEG,LEXDIF,LEXEFF,LEXELP,LEXEND,LEXERR,LEXFI,LEXIDX,LEXIDXT,LEXIEN,LEXMC,LEXNDS,LEXOK,LEXSRC,LEXSTA,LEXTGT
	S LEXFI="757.33"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.33 ""ACT""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0,LEXSRC="",LEXFI=757.33,LEXIDX="ACT",LEXIDXT="^LEX(757.33,""ACT"",SR,TG,EF,ST,IEN,HIS)"
	S LEXSRC="" F  S LEXSRC=$O(^LEX(LEXFI,LEXIDX,LEXSRC)) Q:'$L(LEXSRC)  D
	. N LEXTGT S LEXTGT="" F  S LEXTGT=$O(^LEX(LEXFI,LEXIDX,LEXSRC,LEXTGT)) Q:'$L(LEXTGT)  D
	. . N LEXEFF S LEXEFF="" F  S LEXEFF=$O(^LEX(LEXFI,LEXIDX,LEXSRC,LEXTGT,LEXEFF)) Q:'$L(LEXEFF)  D
	. . . N LEXSTA S LEXSTA="" F  S LEXSTA=$O(^LEX(LEXFI,LEXIDX,LEXSRC,LEXTGT,LEXEFF,LEXSTA)) Q:'$L(LEXSTA)  D
	. . . . N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXSRC,LEXTGT,LEXEFF,LEXSTA,LEXIEN)) Q:+LEXIEN'>0  D
	. . . . . N LEXHIS S LEXHIS=0 F  S LEXHIS=$O(^LEX(LEXFI,LEXIDX,LEXSRC,LEXTGT,LEXEFF,LEXSTA,LEXIEN,LEXHIS)) Q:+LEXHIS'>0  D
	. . . . . . S LEXNDS=LEXNDS+1 N LEXN0,LEXNH,LEXR,LEXT,LEXE,LEXS,LEXED,LEXSD
	. . . . . . S LEXN0=$G(^LEX(757.33,+LEXIEN,0)),LEXNH=$G(^LEX(757.33,+LEXIEN,2,+LEXHIS,0))
	. . . . . . S LEXR=$P(LEXN0,"^",2),LEXT=$P(LEXN0,"^",3),LEXE=$P(LEXNH,"^",1),LEXS=$P(LEXNH,"^",2)
	. . . . . . Q:'$L(LEXR)  Q:'$L(LEXT)  Q:'$L(LEXE)  Q:'$L(LEXS)
	. . . . . . S LEXED=$TR($$FMTE^XLFDT(LEXEFF,"5DZ"),"@"," ")
	. . . . . . S LEXSD=$S(+LEXSTA>0:"Active",1:"Inactive")
	. . . . . . I $TR(LEXSRC," ","")'=LEXR!($TR(LEXTGT," ","")'=LEXT)!(LEXEFF'=LEXE)!(LEXSTA'=LEXS) D
	. . . . . . . N DA S DA(1)=LEXIEN,DA=LEXHIS S LEXERR=LEXERR+1
	. . . . . . . K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXSRC,LEXTGT,LEXEFF,LEXSTA,LEXIEN,LEXHIS)
	. . . . . . . S:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,(LEXR_" "),(LEXT_" "),LEXE,LEXS,DA(1),DA)=""
	. . . . . . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Invalid ",LEXED," ",LEXSD,?58,"  ",DA(1),"/",DA
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. N LEXHIS S LEXHIS=0 F  S LEXHIS=$O(^LEX(LEXFI,LEXIEN,2,LEXHIS)) Q:+LEXHIS'>0  D
	. . N DA,DIK,X,LEXN0,LEXHN,LEXR,LEXT,LEXE,LEXS,LEXED,LEXSD
	. . S DA(1)=LEXIEN,DA=LEXHIS,LEXN0=$G(^LEX(757.33,+LEXIEN,0)),LEXNH=$G(^LEX(757.33,+LEXIEN,2,+LEXHIS,0))
	. . S LEXR=$P(LEXN0,"^",2),LEXT=$P(LEXN0,"^",3),LEXE=$P(LEXNH,"^",1),LEXS=$P(LEXNH,"^",2)
	. . Q:'$L(LEXR)  Q:'$L(LEXT)  Q:'$L(LEXE)  Q:'$L(LEXS)  S LEXED=$TR($$FMTE^XLFDT(LEXE,"5DZ"),"@"," ")
	. . S LEXSD=$S(+LEXS>0:"Active",1:"Inactive") I '$D(^LEX(LEXFI,LEXIDX,(LEXR_" "),(LEXT_" "),LEXE,LEXS,DA(1),DA)) D
	. . . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing ",LEXED," ",LEXSD,?58,"  ",DA(1),"/",DA
	. . S ^LEX(LEXFI,LEXIDX,(LEXR_" "),(LEXT_" "),LEXE,LEXS,DA(1),DA)=""
	S LEXERR=$S(+LEXERR>0:LEXERR,1:"") I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXIDXT
	H 5 S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	Q
RAMAP	;   Index    ^LEX(757.33,"AMAP",DEF,SRC,TGT,IEN)
	N DA,DIK,LEXBEG,LEXDIF,LEXELP,LEXEND,LEXERR,LEXFI,LEXIDX,LEXIDXT,LEXIEN,LEXMC,LEXNDS,LEXOK,LEXDEF,LEXTGT
	S LEXFI="757.33"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.33 ""AMAP""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0,LEXDEF="",LEXFI=757.33,LEXIDX="AMAP",LEXIDXT="^LEX(757.33,""AMAP"",DEF,SRC,TGT,IEN)"
	S LEXDEF="" F  S LEXDEF=$O(^LEX(LEXFI,LEXIDX,LEXDEF)) Q:'$L(LEXDEF)  D
	. S LEXSRC="" F  S LEXSRC=$O(^LEX(LEXFI,LEXIDX,LEXDEF,LEXSRC)) Q:'$L(LEXSRC)  D
	. . S LEXTGT="" F  S LEXTGT=$O(^LEX(LEXFI,LEXIDX,LEXDEF,LEXSRC,LEXTGT)) Q:'$L(LEXTGT)  D
	. . . S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXDEF,LEXSRC,LEXTGT,LEXIEN)) Q:+LEXIEN'>0  D
	. . . . S LEXNDS=LEXNDS+1 N LEXN0,LEXNH,LEXD,LEXN,LEXT,LEXE,LEXS
	. . . . S LEXN0=$G(^LEX(757.33,+LEXIEN,0))
	. . . . S LEXD=$P(LEXN0,"^",4),LEXN=$P($G(^LEX(757.32,+LEXD,0)),"^",1)
	. . . . S LEXS=$P(LEXN0,"^",2),LEXT=$P(LEXN0,"^",3)
	. . . . Q:'$L(LEXD)  Q:'$L(LEXN)  Q:'$L(LEXS)  Q:'$L(LEXT)
	. . . . I LEXDEF'=LEXN!($TR(LEXSRC," ","")'=LEXS)!($TR(LEXTGT," ","")'=LEXT) D
	. . . . . N DA S DA=LEXIEN S LEXERR=LEXERR+1
	. . . . . K:'$D(LEXTEST) ^LEX(757.33,LEXIDX,LEXDEF,LEXSRC,LEXTGT,DA)
	. . . . . S:'$D(LEXTEST) ^LEX(757.33,LEXIDX,LEXN,LEXS,LEXT,DA)=""
	. . . . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Invalid ",LEXN," Map ",LEXS,?58,"  ",DA
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. N DA,DIK,X,LEXN0,LEXD,LEXN,LEXS,LEXT
	. S DA=LEXIEN,LEXN0=$G(^LEX(757.33,+LEXIEN,0))
	. S LEXN0=$G(^LEX(757.33,+LEXIEN,0))
	. S LEXD=$P(LEXN0,"^",4),LEXN=$P($G(^LEX(757.32,+LEXD,0)),"^",1)
	. S LEXS=$P(LEXN0,"^",2),LEXT=$P(LEXN0,"^",3)
	. Q:'$L(LEXD)  Q:'$L(LEXN)  Q:'$L(LEXS)  Q:'$L(LEXT)
	. I '$D(^LEX(LEXFI,LEXIDX,LEXN,(LEXS_" "),(LEXT_" "),DA)) D
	. . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing ",LEXN," Map ",LEXS,?58,"  ",DA
	. S ^LEX(LEXFI,LEXIDX,LEXN,(LEXS_" "),(LEXT_" "),DA)=""
	S LEXERR=$S(+LEXERR>0:LEXERR,1:"") I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXIDXT
	H 3 S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	Q
RAREV	;   Index    ^LEX(757.33,"AREV",DEF,TGT,SRC,IEN)
	N DA,DIK,LEXBEG,LEXDIF,LEXELP,LEXEND,LEXERR,LEXFI,LEXIDX,LEXIDXT,LEXIEN,LEXMC,LEXNDS,LEXOK,LEXDEF,LEXTGT
	S LEXFI="757.33"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.33 ""AREV""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0,LEXDEF="",LEXFI=757.33,LEXIDX="AREV",LEXIDXT="^LEX(757.33,""AREV"",DEF,TGT,SRC,IEN)"
	S LEXDEF="" F  S LEXDEF=$O(^LEX(LEXFI,LEXIDX,LEXDEF)) Q:'$L(LEXDEF)  D
	. S LEXTGT="" F  S LEXTGT=$O(^LEX(LEXFI,LEXIDX,LEXDEF,LEXTGT)) Q:'$L(LEXTGT)  D
	. . S LEXSRC="" F  S LEXSRC=$O(^LEX(LEXFI,LEXIDX,LEXDEF,LEXTGT,LEXSRC)) Q:'$L(LEXSRC)  D
	. . . S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXDEF,LEXTGT,LEXSRC,LEXIEN)) Q:+LEXIEN'>0  D
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
	H 3 S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	Q
	;              
	; Miscellaneous
CLR	;   Clear
	K LEXNAM,LEXTEST,ZTQUEUED
	Q
