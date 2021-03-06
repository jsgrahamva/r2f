LEXRXA	;ISL/KER - Re-Index 757 B ;08/17/2011
	;;2.0;LEXICON UTILITY;**81**;Sep 23, 1996;Build 1
	;               
	; Global Variables 
	;    ^LEX(               SACC 1.3
	;    ^LEX(757,           SACC 1.3
	;    ^LEX(757.001,       SACC 1.3 
	;    ^TMP("LEXRX")       SACC 2.3.2.5.1
	;               
	; External References
	;    FILE^DID            ICR  2052
	;    IX1^DIK             ICR  10013
	;    $$FMDIFF^XLFDT      ICR  10103
	;    $$NOW^XLFDT         ICR  10103
	;               
	; Local Variables NEWed or KILLed Elsewhere
	;     LEXNAM     Task name       NEWed/KILLed by LEXRXXT
	;     LEXSET     Re-Index flag   NEWed/KILLed by LEXRXXT
	;     LEXQ       Quiet flat      NEWed/KILLed by LEXRXXT2
	;     LEXTEST    Test variable   NEWed/KILLed by Developer
	;     ZTQUEUED   Task flag       NEWed/KILLed by Taskman
	;               
	Q
EN	; Main Entry Point
R757	; Repair file 757
	D RB,SET Q
RB	;   Index    ^LEX(757,"B",EXP,IEN) 
	W:'$D(ZTQUEUED) ! N DA,DIK,LEXBEG,LEXDIF,LEXTC,LEXELP,LEXEND,LEXERR,LEXFI,LEXFQ,LEXIDX
	N LEXIDXT,LEXIEN,LEXMC,LEXNDS,LEXOK,LEXSTR,X S LEXFI=757
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757 ""B""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0,LEXSTR="",LEXIDX="B",LEXIDXT="^LEX(757,""B"",MC,IEN)"
	F  S LEXSTR=$O(^LEX(LEXFI,LEXIDX,LEXSTR)) Q:'$L(LEXSTR)  D
	. N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN)) Q:+LEXIEN'>0  D
	. . S LEXNDS=LEXNDS+1
	. . I '$D(^LEX(LEXFI,LEXIEN,0)) D  Q
	. . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN)
	. . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,LEXSTR,?58,"  ",LEXIEN
	. . N LEXOK,LEXMC S LEXMC=$P($G(^LEX(LEXFI,LEXIEN,0)),"^",1)
	. . S LEXOK=0 S:LEXMC=LEXSTR LEXOK=1 I 'LEXOK D
	. . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN) S:$L(LEXMC) ^LEX(LEXFI,LEXIDX,LEXMC,LEXIEN)=""
	. . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,LEXSTR,?58,"  ",LEXIEN
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. N DA,X S DA=LEXIEN,X=$P($G(^LEX(LEXFI,DA,0)),"^",1) Q:'$L(X)
	. I '$D(^LEX(LEXFI,"B",X,DA)) S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing",?58,"  ",DA
	. S ^LEX(LEXFI,"B",X,DA)="" I '$D(^LEX(757.001,DA)) D
	. . N LEXFQ,DIK S LEXFQ=+($$FREQ^LEXRXXM(DA)) S ^LEX(757.001,DA,0)=DA_"^"_LEXFQ_"^"_LEXFQ
	. . S DIK="^LEX(757.001," D IX1^DIK
	S LEXERR=$S(+LEXERR>0:LEXERR,1:"") I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXIDXT
	S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	Q
	;              
	; Miscellaneous
SET	;   Re-Index Major Concept Map file 757 (Set logic only)
	Q:'$D(LEXSET)  N LEXTC,LEXPRE,LEXBEG,LEXEND,LEXELP,LEXNM,LEXFI,LEXRT
	N LEXOUT,LEXMSG S LEXFI=757
	D FILE^DID(LEXFI,"N","GLOBAL NAME","LEXOUT","LEXMSG")
	S LEXRT=$G(LEXOUT("GLOBAL NAME")) Q:LEXRT'["^LEX"
	S LEXPRE=$G(^TMP("LEXRX",$J,"T",1,"ELAP"))
	S LEXBEG=$$NOW^XLFDT,LEXNM=$$FN^LEXRXXM(LEXFI)
	S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,("Re-Indexing File #"_LEXFI))
	Q:LEXTC=1  I '$D(ZTQUEUED) W !,?8,"Re-Indexing",!
	N LEXIEN,LEXP3,LEXP4 S (LEXP3,LEXP4,LEXIEN)=0
	F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. S LEXP3=LEXIEN,LEXP4=LEXP4+1
	. N DA,DIK S DA=+($G(LEXIEN)),DIK=LEXRT D IX1^DIK
	S $P(^LEX(LEXFI,0),"^",3)=LEXP3,$P(^LEX(LEXFI,0),"^",4)=LEXP4
	Q:$D(LEXQ)  S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,"ALLIX",,,"Re-Index",LEXELP)
	S LEXELP=$$ADDT^LEXRXXM(LEXELP,LEXPRE)
	S ^TMP("LEXRX",$J,"T",1,"ELAP")=LEXELP
	Q
CLR	;   Clear
	K LEXNAM,LEXSET,LEXTEST,ZTQUEUED,LEXQ
	Q
