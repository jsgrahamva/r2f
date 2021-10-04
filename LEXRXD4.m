LEXRXD4	;ISL/KER - Re-Index 757.02 AVA/CODE/ADX/APR ;12/19/2014
	;;2.0;LEXICON UTILITY;**81,80,86**;Sep 23, 1996;Build 1
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
	D RAVA,RCODE,RI10 Q
RAVA	;   Index    ^LEX(757.02,"AVA",CODE,EXP,SAB,IEN) 
	N DA,DIK,LEXBEG,LEXCK,LEXDIF,LEXELP,LEXEND,LEXERR,LEXFI,LEXIDX,LEXIDXT,LEXIEN,LEXNDS,LEXOK,LEXSO,LEXSTR
	S LEXFI="757.02"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.02 ""AVA""") Q:LEXTC=1
	S LEXCK=$$SABS^LEXRXXM S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0
	S LEXSTR="",LEXFI=757.02,LEXIDX="AVA",LEXIDXT="^LEX(757.02,""AVA"",CODE,EXP,SAB,IEN)"
	F  S LEXSTR=$O(^LEX(LEXFI,LEXIDX,LEXSTR)) Q:'$L(LEXSTR)  D
	. N LEXEXP S LEXEXP=0  F  S LEXEXP=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXEXP)) Q:+LEXEXP'>0  D
	. . N LEXSAB S LEXSAB="" F  S LEXSAB=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXEXP,LEXSAB)) Q:'$L(LEXSAB)  D
	. . . N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXEXP,LEXSAB,LEXIEN)) Q:+LEXIEN'>0  D
	. . . . N LEXOK,LEXSO,LEXEX,LEXSR,LEXSB S LEXNDS=LEXNDS+1
	. . . . S LEXEX=$P($G(^LEX(757.02,+LEXIEN,0)),"^",1),LEXSO=$P($G(^LEX(757.02,+LEXIEN,0)),"^",2)
	. . . . S LEXSR=$P($G(^LEX(757.02,+LEXIEN,0)),"^",3),LEXSB=$E($P($G(^LEX(757.03,+LEXSR,0)),"^",1),1,3)
	. . . . I $L(LEXSAB)'=3!(LEXCK'[LEXSAB) D  Q
	. . . . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXSTR,LEXEXP,LEXSAB,LEXIEN)
	. . . . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Invalid SAB ",LEXSAB,?58,"  ",LEXIEN,!,?30,LEXCK
	. . . . I '$L(LEXEX)!('$L(LEXSO))!($L(LEXSB)'=3) D  Q
	. . . . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXSTR,LEXEXP,LEXSAB,LEXIEN)
	. . . . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,LEXSTR,?58,"  ",LEXIEN
	. . . . S LEXOK=1 S:LEXSTR='(LEXSO_" ") LEXOK=0 S:LEXEXP'=LEXEX LEXOK=0 S:LEXSAB'=LEXSB LEXOK=0 I 'LEXOK D
	. . . . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXSTR,LEXEXP,LEXSAB,LEXIEN)
	. . . . . S:$L(LEXSO)&($L(LEXEX))&($L(LEXSB))&(LEXCK[("^"_LEXSB_"^")) ^LEX(LEXFI,LEXIDX,(LEXSO_" "),LEXEX,LEXSB,LEXIEN)=""
	. . . . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,LEXSTR,?58,"  ",LEXIEN
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. N DA,DIK,LEXEX,LEXSO,LEXSR,LEXSB S DA=LEXIEN,LEXSR=$P($G(^LEX(LEXFI,+DA,0)),"^",3),LEXSO=$P($G(^LEX(LEXFI,DA,0)),U,2)
	. S LEXEX=$P($G(^LEX(LEXFI,DA,0)),U,1),LEXSB=$E($P($G(^LEX(757.03,+LEXSR,0)),"^",1),1,3) Q:$L(LEXSB)'=3  Q:'$L(LEXSO)  Q:+LEXEX'>0
	. I LEXCK[("^"_LEXSB_"^"),'$D(^LEX(757.02,"AVA",(LEXSO_" "),LEXEX,LEXSB,DA)) D
	. . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing ",LEXSO,"/",LEXSB,?58,"  ",DA
	. I LEXCK'[("^"_LEXSB_"^"),$D(^LEX(757.02,"AVA",(LEXSO_" "),LEXEX,LEXSB,DA)) D
	. . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Invalid (deleted) ",LEXSO,"/",LEXSB,?58,"  ",DA
	. . K:'$D(LEXTEST) ^LEX(757.02,"AVA",(LEXSO_" "),LEXEX,LEXSB,DA)
	. S:LEXCK[("^"_LEXSB_"^")&($L(LEXSO))&($L(LEXEX)) ^LEX(757.02,"AVA",(LEXSO_" "),LEXEX,LEXSB,DA)=""
	. K:LEXCK'[("^"_LEXSB_"^")&('$D(LEXTEST))&($L(LEXSO))&($L(LEXEX)) ^LEX(757.02,"AVA",(LEXSO_" "),LEXEX,LEXSB,DA)
	S LEXERR=$S(+LEXERR>0:LEXERR,1:"") I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXIDXT
	S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	Q
RCODE	;   Index    ^LEX(757.02,"CODE",CODE,IEN) 
	N DA,DIK,LEXBEG,LEXDIF,LEXELP,LEXEND,LEXERR,LEXFI,LEXIDX,LEXIDXT,LEXIEN,LEXNDS,LEXOK,LEXSO,LEXSTR
	S LEXFI="757.02"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.02 ""CODE""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0,LEXSTR="",LEXFI=757.02,LEXIDX="CODE",LEXIDXT="^LEX(757.02,""CODE"",CODE,IEN)"
	F  S LEXSTR=$O(^LEX(LEXFI,LEXIDX,LEXSTR)) Q:'$L(LEXSTR)  D
	. N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN)) Q:+LEXIEN'>0  D
	. . S LEXNDS=LEXNDS+1 N LEXOK,LEXSO S LEXSO=$P($G(^LEX(757.02,LEXIEN,0)),U,2)
	. . S LEXOK=0 S:(LEXSO_" ")=LEXSTR LEXOK=1 I 'LEXOK D
	. . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN) S:$L(LEXSO) ^LEX(LEXFI,LEXIDX,(LEXSO_" "),LEXIEN)=""
	. . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,LEXSTR,?58,"  ",LEXIEN
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. N DA,DIK,LEXSO S DA=LEXIEN,LEXSO=$P($G(^LEX(LEXFI,DA,0)),U,2) Q:'$L(LEXSO)
	. I '$D(^LEX(LEXFI,LEXIDX,(LEXSO_" "),DA)) D
	. . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing ",LEXSO,?58,"  ",DA
	. S:$L(LEXSO) ^LEX(LEXFI,LEXIDX,(LEXSO_" "),DA)=""
	S LEXERR=$S(+LEXERR>0:LEXERR,1:"") I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXIDXT
	S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	Q
RI10	;   Index    ^LEX(757.02 "ADX" amd "APR"
	D:$D(^LEX(757.02,"ADX")) RADX D:$D(^LEX(757.02,"APR")) RAPR
	Q
RADX	;   Index    ^LEX(757.02,"ADX",CODE,DATE,STA,IEN,HIS)
	N DA,DIK,LEXBEG,LEXDIF,LEXELP,LEXEND,LEXERR,LEXFI,LEXIDX,LEXIDXT,LEXIEN,LEXNDS,LEXOK,LEXSO,LEXSTR
	S LEXFI="757.02"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.02 ""ADX""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0,LEXSTR="",LEXFI=757.02,LEXIDX="ADX",LEXIDXT="^LEX(757.02,""ADX"",CODE,DT,STA,IEN,HIS)"
	F  S LEXSTR=$O(^LEX(LEXFI,LEXIDX,LEXSTR)) Q:'$L(LEXSTR)  D
	. N LEXEFF S LEXEFF=0 F  S LEXEFF=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXEFF)) Q:+LEXEFF'>0  D
	. . N LEXSTA S LEXSTA="" F  S LEXSTA=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXEFF,LEXSTA)) Q:'$L(LEXSTA)  D
	. . . N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXEFF,LEXSTA,LEXIEN)) Q:+LEXIEN'>0  D
	. . . . N LEXHIS S LEXHIS=0 F  S LEXHIS=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXEFF,LEXSTA,LEXIEN,LEXHIS)) Q:+LEXHIS'>0  D
	. . . . . S LEXNDS=LEXNDS+1 N LEXOK,LEX0,LEXH,LEXSO,LEXSR,LEXST,LEXEF
	. . . . . S LEX0=$G(^LEX(757.02,LEXIEN,0)),LEXH=$G(^LEX(757.02,LEXIEN,4,LEXHIS,0)),LEXSO=$P(LEX0,"^",2)
	. . . . . S LEXSR=$P(LEX0,"^",3),LEXST=$P(LEXH,"^",2),LEXEF=$P(LEXH,"^",1)
	. . . . . S LEXOK=1 S:(LEXSO_" ")'=LEXSTR LEXOK=0 S:LEXSR'=30 LEXOK=0
	. . . . . S:LEXEFF'=LEXEF LEXOK=0 S:LEXSTA'=LEXST LEXOK=0 I 'LEXOK D
	. . . . . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXSTR,LEXEFF,LEXSTA,LEXIEN,LEXHIS)
	. . . . . . S:$L(LEXSO) ^LEX(LEXFI,LEXIDX,(LEXSO_" "),LEXIEN)=""
	. . . . . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Error: ",LEXSTR,?58,"  ",LEXIEN
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. N DA,DIK,LEX0,LEXHI,LEXSO,LEXSR
	. S LEX0=$G(^LEX(LEXFI,LEXIEN,0)) S LEXSO=$P(LEX0,U,2) Q:'$L(LEXSO)  S LEXSR=$P(LEX0,U,3) Q:+LEXSR'=30
	. S LEXHI=0 F  S LEXHI=$O(^LEX(757.02,LEXIEN,4,LEXHI)) Q:+LEXHI'>0  D
	. . N LEXH,LEXEF,LEXST S LEXH=$G(^LEX(LEXFI,LEXIEN,4,LEXHI,0))
	. . S LEXEF=$P(LEXH,U,1) Q:'$L(LEXEF)
	. . S LEXST=$P(LEXH,U,2) Q:'$L(LEXST)
	. . S DA(1)=LEXIEN,DA=LEXHI
	. . I '$D(^LEX(757.02,"ADX",(LEXSO_" "),LEXEF,LEXST,DA(1),DA)) D
	. . . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing ",LEXSO,?58,"  ",DA(1),", ",DA
	. . . S:$L(LEXSO)&($L(LEXEF))&($L(LEXST))&(+($G(DA(1)))>0)&(+($G(DA))>0) ^LEX(757.02,"ADX",(LEXSO_" "),LEXEF,LEXST,DA(1),DA)=""
	S LEXERR=$S(+LEXERR>0:LEXERR,1:"") I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXIDXT
	S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	Q
RAPR	;   Index    ^LEX(757.02,"APR",CODE,DATE,STA,IEN,HIS)
	N DA,DIK,LEXBEG,LEXDIF,LEXELP,LEXEND,LEXERR,LEXFI,LEXIDX,LEXIDXT,LEXIEN,LEXNDS,LEXOK,LEXSO,LEXSTR
	S LEXFI="757.02"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.02 ""APR""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0,LEXSTR="",LEXFI=757.02,LEXIDX="APR",LEXIDXT="^LEX(757.02,""APR"",CODE,DT,STA,IEN,HIS)"
	F  S LEXSTR=$O(^LEX(LEXFI,LEXIDX,LEXSTR)) Q:'$L(LEXSTR)  D
	. N LEXEFF S LEXEFF=0 F  S LEXEFF=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXEFF)) Q:+LEXEFF'>0  D
	. . N LEXSTA S LEXSTA="" F  S LEXSTA=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXEFF,LEXSTA)) Q:'$L(LEXSTA)  D
	. . . N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXEFF,LEXSTA,LEXIEN)) Q:+LEXIEN'>0  D
	. . . . N LEXHIS S LEXHIS=0 F  S LEXHIS=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXEFF,LEXSTA,LEXIEN,LEXHIS)) Q:+LEXHIS'>0  D
	. . . . . S LEXNDS=LEXNDS+1 N LEXOK,LEX0,LEXH,LEXSO,LEXSR,LEXST,LEXEF
	. . . . . S LEX0=$G(^LEX(757.02,LEXIEN,0)),LEXH=$G(^LEX(757.02,LEXIEN,4,LEXHIS,0)),LEXSO=$P(LEX0,"^",2)
	. . . . . S LEXSR=$P(LEX0,"^",3),LEXST=$P(LEXH,"^",2),LEXEF=$P(LEXH,"^",1)
	. . . . . S LEXOK=1 S:(LEXSO_" ")'=LEXSTR LEXOK=0 S:LEXSR'=31 LEXOK=0
	. . . . . S:LEXEFF'=LEXEF LEXOK=0 S:LEXSTA'=LEXST LEXOK=0 I 'LEXOK D
	. . . . . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXSTR,LEXEFF,LEXSTA,LEXIEN,LEXHIS)
	. . . . . . S:$L(LEXSO) ^LEX(LEXFI,LEXIDX,(LEXSO_" "),LEXIEN)=""
	. . . . . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Error: ",LEXSTR,?58,"  ",LEXIEN
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. N DA,DIK,LEX0,LEXHI,LEXSO,LEXSR
	. S LEX0=$G(^LEX(LEXFI,LEXIEN,0)) S LEXSO=$P(LEX0,U,2) Q:'$L(LEXSO)  S LEXSR=$P(LEX0,U,3) Q:+LEXSR'=31
	. S LEXHI=0 F  S LEXHI=$O(^LEX(757.02,LEXIEN,4,LEXHI)) Q:+LEXHI'>0  D
	. . N LEXH,LEXEF,LEXST S LEXH=$G(^LEX(LEXFI,LEXIEN,4,LEXHI,0))
	. . S LEXEF=$P(LEXH,U,1) Q:'$L(LEXEF)
	. . S LEXST=$P(LEXH,U,2) Q:'$L(LEXST)
	. . S DA(1)=LEXIEN,DA=LEXHI
	. . I '$D(^LEX(757.02,LEXIDX,(LEXSO_" "),LEXEF,LEXST,DA(1),DA)) D
	. . . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing ",LEXSO,?58,"  ",DA(1),", ",DA
	. . . S:$L(LEXSO)&($L(LEXEF))&($L(LEXST))&(+($G(DA(1)))>0)&(+($G(DA))>0) ^LEX(757.02,LEXIDX,(LEXSO_" "),LEXEF,LEXST,DA(1),DA)=""
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
