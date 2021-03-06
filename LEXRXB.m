LEXRXB	;ISL/KER - Re-Index 757.001 B/AF ;04/21/2014
	;;2.0;LEXICON UTILITY;**81,80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^LEX(               SACC 1.3
	;    ^LEX(757.001)       SACC 1.3
	;    ^LEX(757.02)        SACC 1.3
	;    ^LEX(757.1)         SACC 1.3
	;    ^TMP("LEXRX")       SACC 2.3.2.5.1
	;               
	; External References
	;    $$FMDIFF^XLFDT      ICR  10103
	;    $$NOW^XLFDT         ICR  10103
	;    FILE^DID            ICR   2052
	;    IX1^DIK             ICR  10013
	;    IX2^DIK             ICR  10013
	;               
	; Local Variables NEWed or KILLed Elsewhere
	;     LEXFIX     Fix Flag        NEWed/KILLed by LEXRXXT
	;     LEXNAM     Task name       NEWed/KILLed by LEXRXXT
	;     LEXSET     Re-Index flag   NEWed/KILLed by LEXRXXT
	;     LEXQ       Quiet flat      NEWed/KILLed by LEXRXXT2
	;     LEXTEST    Test variable   NEWed/KILLed by Developer
	;     ZTQUEUED   Task flag       NEWed/KILLed by Taskman
	;               
	Q
EN	; Main Entry Point
R757001	; Repair file 757.001
	D RB,RAF,SET Q
RB	;   Index    ^LEX(757.001,"B",MC,IEN) 
	W:'$D(ZTQUEUED) ! N DA,DIK,LEXBEG,LEXDIF,LEXELP,LEXEND,LEXERR,LEXFI,LEXIDX,LEXIDXT,LEXIEN,LEXMC,LEXNDS,LEXOK,LEXSTR,X
	S LEXFI="757.001"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.001 ""B""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0,LEXSTR="",LEXIDX="B",LEXIDXT="^LEX(757.001,""B"",MC,IEN)"
	F  S LEXSTR=$O(^LEX(LEXFI,LEXIDX,LEXSTR)) Q:'$L(LEXSTR)  D
	. N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN)) Q:+LEXIEN'>0  D
	. . S LEXNDS=LEXNDS+1 I '$D(^LEX(LEXFI,LEXIEN,0)) D  Q
	. . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN)
	. . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,LEXSTR,?58,"  ",LEXIEN
	. . Q:+LEXSTR>0&(LEXSTR=LEXIEN)  N LEXOK,LEXMC S LEXMC=$P($G(^LEX(LEXFI,LEXIEN,0)),"^",1)
	. . S LEXOK=0 S:LEXMC=LEXSTR LEXOK=1 I 'LEXOK D
	. . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN) S:$L(LEXMC) ^LEX(LEXFI,LEXIDX,LEXMC,LEXIEN)=""
	. . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,LEXSTR,?58,"  ",LEXIEN
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. N DA,DIK,X S DA=LEXIEN,X=$P($G(^LEX(LEXFI,DA,0)),"^",1) Q:'$L(X)
	. I '$D(^LEX(LEXFI,"B",X,DA)) D
	. . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing",?58,"  ",DA
	. S:$L(X) ^LEX(LEXFI,"B",X,DA)=""
	S LEXERR=$S(+LEXERR>0:LEXERR,1:"") I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXIDXT
	S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	Q
RAF	;   Index    ^LEX(757.001,"AF",FREQ,IEN)
	W:'$D(ZTQUEUED) ! N DA,DIK,LEXAF,LEXBEG,LEXDIF,LEXELP,LEXEND,LEXERR,LEXFI,LEXIDX,LEXIDXT,LEXFQ,LEXIEN,LEXNDS,LEXOF,LEXOK,LEXSTR,X
	S LEXFI="757.001"
	N LEXTC S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,"Repairing File #757.001 ""AF""") Q:LEXTC=1
	S LEXBEG=$$NOW^XLFDT,(LEXNDS,LEXERR)=0,LEXSTR="",LEXIDX="AF",LEXIDXT="^LEX(757.001,""AF"",FREQ,IEN)"
	F  S LEXSTR=$O(^LEX(LEXFI,LEXIDX,LEXSTR)) Q:'$L(LEXSTR)  D
	. N LEXIEN S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN)) Q:+LEXIEN'>0  D
	. . S LEXNDS=LEXNDS+1
	. . I '$D(^LEX(LEXFI,LEXIEN,0)) D  Q
	. . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN)
	. . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,LEXSTR,?58,"  ",LEXIEN
	. . N LEXOK,LEXFQ,LEXOF,LEXAF,LEXF S LEXFQ=+($P($G(^LEX(LEXFI,LEXIEN,0)),"^",3))
	. . S LEXOF=+($P($G(^LEX(LEXFI,LEXIEN,0)),"^",2)) I LEXOF>LEXFQ D
	. . . S LEXF=$$FREQ^LEXRXXM(LEXIEN) S:LEXF'>LEXFQ $P(^LEX(LEXFI,LEXIEN,0),"^",2)=LEXF,LEXOF=LEXF
	. . . S:LEXF>LEXFQ $P(^LEX(LEXFI,LEXIEN,0),"^",2)=LEXF,$P(^LEX(LEXFI,LEXIEN,0),"^",3)=LEXF,(LEXOF,LEXFQ)=LEXF
	. . S LEXAF=LEXFQ-LEXOF S:LEXAF>0 LEXAF=LEXAF*(-1)
	. . S LEXOK=0 S:LEXAF=LEXSTR LEXOK=1 I 'LEXOK D
	. . . S LEXERR=LEXERR+1 K:'$D(LEXTEST) ^LEX(LEXFI,LEXIDX,LEXSTR,LEXIEN) S:$L(LEXAF) ^LEX(LEXFI,LEXIDX,LEXAF,LEXIEN)=""
	. . . I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,LEXSTR,?58,"  ",LEXIEN
	S LEXIEN=0 F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. N DA,DIK,X,LEXF S DA=LEXIEN,X=+($P($G(^LEX(LEXFI,DA,0)),"^",3)),LEXF=-(X-(+($P(^LEX(LEXFI,DA,0),"^",2))))
	. I '$D(^LEX(LEXFI,"AF",LEXF,DA)) D
	. . S LEXERR=LEXERR+1 I '$D(ZTQUEUED) W !,?8,LEXFI,?19,LEXIDX,?30,"Missing",?58,"  ",DA
	. S:$L(LEXF) ^LEX(LEXFI,"AF",LEXF,DA)=""
	S LEXERR=$S(+LEXERR>0:LEXERR,1:"") I '$D(ZTQUEUED) W !,$J(LEXERR,5),?8,LEXFI,?19,LEXIDX,?30,LEXIDXT
	S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,LEXIDX,LEXNDS,LEXERR,LEXIDXT,LEXELP)
	Q
	;              
	; Miscellaneous
SET	;   Re-Index Concept Usage file 757.001 (Set logic only)
	Q:'$D(LEXSET)  N LEXTC,LEXPRE,LEXBEG,LEXEND,LEXELP,LEXNM,LEXFI,LEXRT
	N LEXOUT,LEXMSG S LEXFI=757.001
	D FILE^DID(LEXFI,"N","GLOBAL NAME","LEXOUT","LEXMSG")
	S LEXRT=$G(LEXOUT("GLOBAL NAME")) Q:LEXRT'["^LEX"
	S LEXPRE=$G(^TMP("LEXRX",$J,"T",1,"ELAP"))
	S LEXBEG=$$NOW^XLFDT,LEXNM=$$FN^LEXRXXM(LEXFI)
	S LEXTC=$$UPD^LEXRXXT3($G(LEXNAM),,("Re-Indexing File #"_LEXFI))
	Q:LEXTC=1  I '$D(ZTQUEUED) W !,?8,"Re-Indexing",!
	N LEXIEN,LEXP3,LEXP4 S (LEXP3,LEXP4,LEXIEN)=0
	F  S LEXIEN=$O(^LEX(LEXFI,LEXIEN)) Q:+LEXIEN'>0  D
	. S LEXP3=LEXIEN,LEXP4=LEXP4+1
	. N DA,DIK,LEXCFQ,LEXCMC,LEXCND,LEXCOV,LEXNFQ,LEXNND,LEXNOV
	. S LEXCND=$G(^LEX(LEXFI,LEXIEN,0)),LEXCMC=+LEXCND,LEXCOV=$P(LEXCND,"^",2)
	. S (LEXCFQ,LEXNFQ)=$P(LEXCND,"^",3),LEXNOV=$$FREQ(LEXIEN)
	. S:LEXNOV>LEXNFQ LEXNFQ=LEXNOV S:LEXNOV'=LEXCOV LEXNFQ=LEXNOV
	. I $D(LEXFIX) D  Q
	. . Q:LEXCOV=LEXNOV&(LEXCFQ=LEXNFQ)
	. . S DA=+($G(LEXIEN)),DIK=LEXRT D IX2^DIK
	. . S ^LEX(LEXFI,LEXIEN,0)=LEXCMC_"^"_LEXNOV_"^"_LEXNFQ
	. . D IX1^DIK
	. S DA=+($G(LEXIEN)),DIK=LEXRT D IX1^DIK
	S $P(^LEX(LEXFI,0),"^",3)=LEXP3,$P(^LEX(LEXFI,0),"^",4)=LEXP4
	Q:$D(LEXQ)  S LEXEND=$$NOW^XLFDT,LEXELP=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3)
	S:$E(LEXELP,1)=" "&($E(LEXELP,3)=":") LEXELP=$TR(LEXELP," ","0")
	D REP^LEXRXXS(LEXFI,LEXFI,"ALLIX",,,"Re-Index",LEXELP)
	S LEXELP=$$ADDT^LEXRXXM(LEXELP,LEXPRE)
	S ^TMP("LEXRX",$J,"T",1,"ELAP")=LEXELP
	Q
FREQ(X)	;   Get frequency based on codes and semantics
	N LEXMC,LEXMCE,LEXND,LEXOF,LEXNF S LEXMC=+($G(X)),X=0 Q:'$D(^LEX(757,LEXMC,0)) X
	S LEXMCE=$P($G(^LEX(757,+LEXMC,0)),"^",1)
	S LEXOF=$P($G(^LEX(757.001,LEXMC,0)),"^",2)
	N LEXSA,LEXSAB,LEXACT,LEXSMC,LEXNUR,LEXBEH,LEXI10,LEXPRO,LEXDIA
	S (LEXSA,LEXNUR,LEXBEH,LEXPRO,LEXDIA,LEXI10,LEXSMC)=0 D SO,SM S X=0
	S LEXNF="",X=0
	;     ICD-10-CM                       6
	S:+LEXI10=1&(+LEXDIA=1) (LEXNF,X)=6 Q:$L(LEXNF)&(LEXNF'=LEXOF)&(X>0) X
	;     ICD-10-PCS                      5
	S:+LEXI10=1&(+LEXDIA'=1) (LEXNF,X)=5 Q:$L(LEXNF)&(LEXNF'=LEXOF)&(X>0) X
	;     ICD-9 coded Diagnosis           4
	S:LEXI10=0&(+LEXDIA=1)&(X=0) (LEXNF,X)=4 Q:$L(LEXNF)&(LEXNF'=LEXOF)&(X>0) X
	;     Behavior or non-ICD Diagnosis   3
	S:'$L(LEXNF)&(+($G(LEXBEH))=1)&($G(LEXSMC)>0) (LEXNF,X)=3 Q:$L(LEXNF)&(LEXNF'=LEXOF)&(X>0) X
	;     Procedures                      2
	S:'$L(LEXNF)&(+($G(LEXPRO))=1) (LEXNF,X)=2 Q:$L(LEXNF)&(LEXNF'=LEXOF)&(X>0) X
	;     Nursing                         1
	S:'$L(LEXNF)&(+($G(LEXNUR))=1) (LEXNF,X)=1 Q:$L(LEXNF)&(LEXNF'=LEXOF)&(X>0) X
	;     Diseases                        3
	S:'$L(LEXNF)&(+($G(LEXSMC))>1) (LEXNF,X)=3 Q:$L(LEXNF)&(LEXNF'=LEXOF)&(X>0) X
	;     Non-Critical                    0
	S:'$L(LEXNF) (LEXNF,X)=0
	Q X
SO	;   Codes
	N LEXSA S LEXSA=0 F  S LEXSA=$O(^LEX(757.02,"AMC",LEXMC,LEXSA)) Q:+LEXSA=0  D SOC
	Q
SOC	;     Code Type
	N LEXCOD,LEXEFF,LEXHIS,LEXND,LEXSAB
	S LEXEFF=$O(^LEX(757.02,LEXSA,4,"B"," "),-1) Q:LEXEFF'?7N
	S LEXHIS=$O(^LEX(757.02,LEXSA,4,"B",LEXEFF," "),-1) Q:+LEXHIS'>0
	S LEXND=$G(^LEX(757.02,LEXSA,4,+LEXHIS,0)) Q:+($P(LEXND,"^",2))'>0
	S LEXND=$G(^LEX(757.02,LEXSA,0)),LEXSAB=+($P(LEXND,U,3)),LEXCOD=$P(LEXND,U,2)
	Q:LEXSAB=0
	;       ICD-10       CM/PCS
	S:LEXSAB=30!(LEXSAB=31) LEXI10=1_"^"_LEXCOD
	;       Diagnosis    ICD-9 and ICD-10
	S:LEXSAB=1!(LEXSAB=30) LEXDIA=1_"^"_LEXCOD
	;       Procedures   ICD-9, ICD-10, CPT and HCPCS
	S:LEXSAB=2!(LEXSAB=31)!(LEXSAB=3)!(LEXSAB=4) LEXPRO=1_"^"_LEXCOD
	;       Behaviors    DSM-III and DSM-IV
	S:LEXSAB=5!(LEXSAB=6) LEXBEH=1_"^"_LEXCOD
	;       Nursing      NANDA, NIC, NOC, HHC and Omaha
	S:LEXSAB>10&(LEXSAB<16) LEXNUR=1_"^"_LEXCOD
	Q
SM	;   Semantics - BEH Behavior and DIS Disorders
	N LEXBD,LEXCLA,LEXSM S LEXSMC=0,LEXMC=+($G(LEXMC)) Q:'$D(^LEX(757,LEXMC,0))
	S (LEXBD,LEXSM)=0 F  S LEXSM=$O(^LEX(757.1,"B",LEXMC,LEXSM)) Q:+LEXSM=0  D SMC
	S LEXSMC=LEXBD
	Q
SMC	;     Semantic Class
	S LEXCLA=+($P($G(^LEX(757.1,LEXSM,0)),U,2))
	;       Behavior
	S:LEXCLA=3&(LEXBD'>0) LEXBD=1
	;       Disease
	S:LEXCLA=6 LEXBD=2
	Q
CLR	;   Clear
	K LEXFIX,LEXNAM,LEXSET,LEXTEST,ZTQUEUED,LEXQ
	Q
