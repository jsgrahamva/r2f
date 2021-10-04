MPIFSA3	;SF/CMC,DLR-STAND ALONE QUERY PART 2 ; 8/20/08 9:54am
	;;1.0; MASTER PATIENT INDEX VISTA ;**28,31,35,43,52**;30 Apr 99;Build 7
	;
RDT(INDEX,HL,MSG)	;
	N LASTNAME,FRSTNAME,SSN,BIRTHDAY,CMOR,NAME,ICN,POBC,POBS,PAST,HEREICN,HERESSN,MIDDLE,MNAME,SUFFIX,PREFIX,SEX,IEN,CMOR2,CLAIM,CASE,NOIS,CUSER,TFN,CMOR3,XXX,POW,MBIRTH,Y,LNGTH,SEQ1,SEQ,RDT,NXT,LNGTH2,LNGTH1,MPIREP,MPICOMP,TCASE
	N SCORE,ALTRSHLD,TKTRSHLD
	S MPICOMP=$E(HL("ECH"),1),MPIREP=$E(HL("ECH"),2)
	S SEQ1=1,SEQ=0,X=0 F  S X=$O(MSG(X)) Q:'X  S LNGTH=$L(MSG(X),HL("FS")) D
	. F Y=1:1:LNGTH S:Y'=1 SEQ=SEQ+1 D
	.. S NXT=$P(MSG(X),HL("FS"),Y) D
	... I $L($G(RDT(SEQ)))=245 D  Q
	.... I $L(NXT_$G(RDT(SEQ,SEQ1)))>245 S LNGTH1=$L(RDT(SEQ,SEQ1)) S LNGTH2=245-LNGTH1,RDT(SEQ,SEQ1)=$G(RDT(SEQ,SEQ1))_$E(NXT,1,LNGTH2),LNGTH2=LNGTH2+1,NXT=$E(NXT,LNGTH2,$L(NXT)),SEQ1=SEQ1+1
	.... I $L(NXT_$G(RDT(SEQ,SEQ1)))'>245 S RDT(SEQ,SEQ1)=$G(RDT(SEQ,SEQ1))_NXT
	... I $L(NXT_$G(RDT(SEQ)))>245 S LNGTH1=$L($G(RDT(SEQ))) S LNGTH2=245-LNGTH1,RDT(SEQ)=$G(RDT(SEQ))_$E(NXT,1,LNGTH2),LNGTH2=LNGTH2+1,NXT=$E(NXT,LNGTH2,$L(NXT)) S RDT(SEQ,SEQ1)=NXT
	... I $L(NXT_$G(RDT(SEQ)))'>245 S RDT(SEQ)=$G(RDT(SEQ))_NXT Q
RDTAL	;
	S FRSTNAME=RDT(6),LASTNAME=RDT(1),MIDDLE=RDT(9),SSN=RDT(2)
	S SUFFIX=RDT(14),PREFIX=RDT(13)
	S NAME=LASTNAME_","_FRSTNAME
	I MIDDLE'="" S NAME=NAME_" "_MIDDLE
	I SUFFIX'="" S NAME=NAME_" "_SUFFIX
	I PREFIX'="" S NAME=NAME_" "_PREFIX
	S ICN=RDT(5),CMOR=RDT(4),CMOR2=CMOR,CMOR3=CMOR
	I $G(CMOR)'="" S IEN=$$LKUP^XUAF4(CMOR) I IEN'="" S CMOR2=$P($$NS^XUAF4(+IEN),"^")
	I $G(SKIP)="Y" K SKIP Q
	S BIRTHDAY=RDT(3)
	I $G(LASTNAME)="" Q
	I $G(BIRTHDAY)]"" S BIRTHDAY=$$FMDATE^HLFNC(BIRTHDAY),BIRTHDAY=$TR($$FMTE^XLFDT(BIRTHDAY,"5D"),"/","-")
	S SEX=RDT(10),CLAIM=RDT(16),MNAME=RDT(15),POBC=RDT(11),POBS=RDT(12)
	S PAST=RDT(8) I $G(PAST)]"" S PAST=$$FMDATE^HLFNC(PAST),PAST=$TR($$FMTE^XLFDT(PAST,"5D"),"/","-")
	S CASE=RDT(17),NOIS=$P(CASE,"/",2),CUSER=$P(CASE,"/",3),TCASE=CASE,CASE=$P(CASE,"/")
	S MBIRTH=RDT(19),POW=RDT(18)
	I POW="N" S POW="No"
	I POW="Y" S POW="Yes"
	S SCORE=$G(RDT(30)),ALTRSHLD=$G(RDT(31)),TKTRSHLD=$G(RDT(32)) ;Match score, Auto Link threshold, Task Threshold
TMP	;New pt. so incrementing index and resetting counter
	K ^TMP("MPIFVQQ",$J,INDEX)
	S ^TMP("MPIFVQQ",$J,INDEX,"DATA")=NAME_"^"_LASTNAME_"^"_SSN_"^"_BIRTHDAY_"^"_CMOR_"^"_ICN_"^"_FRSTNAME_"^^"_PAST_"^"_MIDDLE_"^"_SEX_"^"_POBC_"^"_POBS_"^"_PREFIX_"^"_SUFFIX_"^"_MNAME_"^"_CLAIM_"^"_TCASE_"^"_POW_"^"_MBIRTH
	S ^TMP("MPIFVQQ",$J,INDEX,"DATA")=^TMP("MPIFVQQ",$J,INDEX,"DATA")_"^"_SCORE_"^"_ALTRSHLD_"^"_TKTRSHLD
	;loop on TF's
	;I TF2'="" F XXX=1:1 S TTF2=$P(TF2,MPIREP,XXX) Q:TTF2=""  S TFLL(INDEX,XXX)=TTF2
	N LAST,SEQ,ORGLST,TFLL
	I $D(RDT(7)),(RDT(7)'="^^~") N LAST,LASTN S SEQ=1 S LAST=$L(RDT(7),MPIREP) S LASTN=LAST-1 D
	.N X F X=1:1:LAST-1 S TFLL(INDEX,X)=$P(RDT(7),MPIREP,X)
	.I '$D(RDT(7,SEQ)) I $P(RDT(7),MPIREP,LAST)'="" S TFLL(INDEX,LAST)=$P($P(RDT(7),MPIREP,LAST),MPICOMP)
	. N LOOP I $D(RDT(7,SEQ)) S LASTVAL=$P(RDT(7),MPIREP,LAST) S LOOP=LASTN+1 F  Q:'$D(RDT(7,SEQ))  N LAST S LAST=$L(RDT(7,SEQ),MPIREP) D
	..N X F X=1:1:LAST-1 S TFLL(INDEX,(LOOP))=$S($D(LASTVAL):LASTVAL,1:"")_$P(RDT(7,SEQ),MPIREP,X) K LASTVAL S LOOP=LOOP+1
	..I '$D(RDT(7,SEQ)) I $P(RDT(7),MPIREP,LAST)'="" S TFLL(INDEX,(LASTN+LAST))=$P($P(RDT(7),MPIREP,LAST),MPICOMP) S LOOP=LOOP+1
	..I $D(RDT(7,SEQ)) S LASTVAL=$P(RDT(7,SEQ),MPIREP,LAST)
	..S SEQ=SEQ+1
	;loop on TFLL to build TF LIST nodes
	S X=0 F  S X=$O(TFLL(INDEX,X)) Q:'X  S ^TMP("MPIFVQQ",$J,INDEX,"TF",X)=TFLL(INDEX,X)
ALIAS	;loop on alias last name
	N LAST,SEQ,ORGLST,AL
	I $D(RDT(20)) N LAST S SEQ=1 S LAST=$L(RDT(20),MPIREP) D
	.N X F X=1:1:LAST-1 S AL(INDEX,X)=$P(RDT(20),MPIREP,X)_","_$P($G(RDT(21)),MPIREP,X)_" "_$P($G(RDT(22)),MPIREP,X)_" "_$P($G(RDT(23)),MPIREP,X)_" "_$P($G(RDT(24)),MPIREP,X)
	.I '$D(RDT(20,SEQ)) I $P(RDT(20),MPIREP,LAST)'="" S AL(INDEX,LAST)=$P(RDT(20),MPIREP,LAST)_","_$P($G(RDT(21)),MPIREP,LAST)_" "_$P($G(RDT(22)),MPIREP,LAST)_" "_$P($G(RDT(23)),MPIREP,LAST)_" "_$P($G(RDT(24)),MPIREP,LAST)
	. I $D(RDT(20,SEQ)) S LASTVAL=$P(RDT(20),MPIREP,LAST) F  Q:'$D(RDT(20,SEQ))  N LAST S LAST=$L(RDT(20,SEQ),MPIREP) D
	..N X F X=1:1:LAST-1 S AL(INDEX,X)=$S($D(LASTVAL):LASTVAL,1:"")_$P(RDT(20,SEQ),MPIREP,X)_","_$P($G(RDT(21)),MPIREP,X)_" "_$P($G(RDT(22)),MPIREP,X)_" "_$P($G(RDT(23)),MPIREP,X)_" "_$P($G(RDT(24)),MPIREP,X) K LASTVAL
	..I '$D(RDT(20,SEQ)) I $P(RDT(20),MPIREP,LAST)'="" S AL(INDEX,LAST)=$P($P(RDT(20),MPIREP,LAST),MPICOMP)_","_$P($G(RDT(21)),MPIREP,LAST)_" "_$P($G(RDT(22)),MPIREP,LAST)_" "_$P($G(RDT(23)),MPIREP,LAST)_" "_$P($G(RDT(24)),MPIREP,LAST)
	..I $D(RDT(20,SEQ)) S LASTVAL=$P(RDT(20,SEQ),MPIREP,LAST)
	..S SEQ=SEQ+1
	S X=0 F  S X=$O(AL(INDEX,X)) Q:'X  S ^TMP("MPIFVQQ",$J,INDEX,"ALIAS",X)=AL(INDEX,X)
	Q