LEXXFQ	;ISL/KER - Set Frequencies in 757.001 ;04/21/2014
	;;2.0;LEXICON UTILITY;**4,25,73,80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^LEX(757.001)       N/A
	;               
	; External References
	;    $$FMDIFF^XLFDT      ICR  10103
	;    $$FMTE^XLFDT        ICR  10103
	;    HOME^%ZIS           ICR  10086
	;    NOW^%DTC            ICR  10000
	;    ^%ZTLOAD            ICR  10063
	;               
	Q
EN	; Update term frequencies when not found  (at site)
	S ZTRTN="UP^LEXXFQ",ZTDESC="Update Term Frequency in file 757.001"
	S ZTIO="",ZTDTH=$H
	D ^%ZTLOAD,HOME^%ZIS
	K Y,ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN
	Q
EN2	; Reset term frequencies to export values (at CIOFO)
	S ZTRTN="RE^LEXXFQ",ZTDESC="Reset Term Frequencies in file 757.001"
	S ZTIO="",ZTDTH=$H
	D ^%ZTLOAD,HOME^%ZIS
	K Y,ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN
	Q
CHK	; Check frequencies                       (at site or IRMFO)
	N LEXI,LEXC S (LEXI,LEXC)=0
	F  S LEXI=$O(^LEX(757,LEXI)) Q:+LEXI=0  S:'$D(^LEX(757.001,LEXI)) LEXC=LEXC+1
	I '$D(ZTQUEUED) D
	.W:LEXC>0 !!,LEXC," Concepts do not have frequencies set",!!
	.W:LEXC'>0 !!,"All concepts have frequencies set",!!
	Q
UP	; Update frequencies
	S:$D(ZTQUEUED) ZTREQ="@"
	N LEX1,LEX2,LEXU,LEXUC,LEXDC,LEXMA,LEXT,LEXL,LEXH
	S (LEXDC,LEXU,LEXUC,LEXT,LEXL,LEXMA)=0,LEXH="."
	S LEX1=$$HACK
	I '$D(ZTQUEUED) D
	.W !!,"Initializing Global",!,"  Start:     ",$P(LEX1,"^",2),!,"  "
	F  S LEXMA=$O(^LEX(757,LEXMA)) Q:+LEXMA=0  D
	. S:'$D(^LEX(757.001,LEXMA,0)) LEXH="+" S LEXT=LEXT+1,LEXL=LEXMA
	. W:'$D(ZTQUEUED)&(LEXT#1000=0) LEXH S:LEXT#1000=0 LEXH=".",LEXDC=LEXDC+1
	. W:'$D(ZTQUEUED)&(LEXDC#76=0)&(LEXDC>0)&(LEXT#1000=0) !,"  "
	. I '$D(^LEX(757.001,LEXMA,0)) D SET S LEXUC=LEXUC+1
	W:'$D(ZTQUEUED) LEXH
	S:LEXT>0 $P(^LEX(757.001,0),"^",4)=LEXT
	S:LEXL>0 $P(^LEX(757.001,0),"^",3)=LEXL S:$D(ZTQUEUED) ZTREQ="@"
	S LEX2=$$HACK
	I '$D(ZTQUEUED) D
	.W !,"  Finished:  ",$P(LEX2,"^",2)
	.W !,"  Time:      ",$$TIME($P(LEX1,"^",1),$P(LEX2,"^",1)),!
	Q
RE	; Reset frequencies
	S:$D(ZTQUEUED) ZTREQ="@"
	N LEXMA,LEXT,LEXL S (LEXT,LEXL,LEXMA)=0
	F  S LEXMA=$O(^LEX(757,LEXMA)) Q:+LEXMA=0  S LEXT=LEXT+1,LEXL=LEXMA D SET
	S:LEXT>0 $P(^LEX(757.001,0),"^",4)=LEXT
	S:LEXL>0 $P(^LEX(757.001,0),"^",3)=LEXL S:$D(ZTQUEUED) ZTREQ="@" Q
SET	; Set frequency
	N DIK,DIC,DA,LEXFQ
	S LEXMA=+($G(LEXMA))
	Q:'$D(^LEX(757,LEXMA,0))
	S DIC="^LEX(757.001,",DA=LEXMA,LEXFQ=+($$FQ(LEXMA))
	D:$D(^LEX(757.001,DA)) KILL^LEXNDX2
	S ^LEX(757.001,LEXMA,0)=LEXMA_"^"_LEXFQ_"^"_LEXFQ
	D SET^LEXNDX2
	Q
FQ(LEXX)	; Frequency
	;
	; LEXSAB  Source Abbreviation
	; LEXSMC  Semantic Class
	; LEXNUR  Nursing Class
	; LEXBEH  Behavior/Mental Health Class
	; LEXPRO  Procedural Class
	; LEXDIA  Diagnostic Class
	; LEXSA   IEN Source Code (ICD, CPT, DSM, etc)
	; LEXMC   IEN Major Concept
	; LEXSO   Code 
	;
	N LEXMC S LEXMC=+($G(LEXX)) Q:'$D(^LEX(757,LEXMC,0)) 0 Q:LEXMC<3 0
	N LEXSA,LEXSAB,LEXSMC,LEXNUR,LEXBEH,LEXPRO,LEXDIA,LEXSN,LEXSO,LEXSR
	S (LEXSA,LEXNUR,LEXBEH,LEXPRO,LEXDIA)=0
	F  S LEXSA=$O(^LEX(757.02,"AMC",LEXMC,LEXSA)) Q:+LEXSA=0  D
	. S LEXSN=$G(^LEX(757.02,LEXSA,0))
	. S LEXSO=$P(LEXSN,"^",2),LEXSR=$P(LEXSN,"^",3)
	. Q:+$$STATCHK^LEXSRC2(LEXSO,,,LEXSR)=0
	. S LEXSAB=+($P($G(^LEX(757.02,LEXSA,0)),"^",3)) Q:LEXSAB=0
	. Q:LEXSAB>15  S:LEXSAB=1 LEXDIA=1
	. S:LEXSAB>1&(LEXSAB<5) LEXPRO=1
	. S:LEXSAB>4&(LEXSAB<7) LEXBEH=1
	. S:LEXSAB>10&(LEXSAB<16) LEXNUR=1
	S LEXSMC=$$SM(LEXMC),LEXX=0 I LEXDIA=1 S LEXX=4 Q LEXX
	I LEXBEH=1!(LEXSMC=1) S LEXX=3 Q LEXX
	I LEXPRO=1 S LEXX=2 Q LEXX
	I LEXNUR=1 S LEXX=1 Q LEXX
	Q LEXX
SM(LEXX)	; Semantic Map (757.1)
	N LEXMC,LEXCL,LEXSA
	S LEXSA=0,LEXMC=+($G(LEXX)),LEXX=0
	Q:'$D(^LEX(757,LEXMC,0)) 0
	F  S LEXSA=$O(^LEX(757.1,"B",LEXMC,LEXSA)) Q:+LEXSA=0  D
	.S LEXCL=+($P($G(^LEX(757.1,LEXSA,0)),"^",2))
	.I LEXCL=3!(LEXCL=6) S LEXX=1
	Q LEXX
HACK(LEXX)	; Time Hack
	N X,%,%H,%I
	N HACK D NOW^%DTC S HACK=$$FMTE^XLFDT(%,1),HACK=$TR(HACK,"@"," ")
	S LEXX=%_"^"_HACK Q LEXX
TIME(LEXBEG,LEXEND)	; Elapsed time from begining to end
	S LEXBEG=+($G(LEXBEG)) Q:LEXBEG=0 "" S LEXEND=+($G(LEXEND)) Q:LEXBEG=0 ""
	S LEXBEG=$$FMDIFF^XLFDT(LEXEND,LEXBEG,3) S:$L($P(LEXBEG,":",1))=1 $P(LEXBEG,":",1)="0"_$P(LEXBEG,":",1) S LEXBEG=$TR(LEXBEG," ","0")
	Q LEXBEG
