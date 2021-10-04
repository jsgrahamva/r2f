LEXQID	;ISL/KER - Query - ICD Diagnosis - Extract ;04/21/2014
	;;2.0;LEXICON UTILITY;**62,73,80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^TMP("LEXQID")      SACC 2.3.2.5.1
	;    ^TMP("LEXQIDA"      SACC 2.3.2.5.1
	;    ^TMP("LEXQIDC"      SACC 2.3.2.5.1
	;    ^TMP("LEXQIDN"      SACC 2.3.2.5.1
	;    ^TMP("LEXQIDO"      SACC 2.3.2.5.1
	;    ^TMP("LEXQIDR"      SACC 2.3.2.5.1
	;               
	; External References
	;    $$CODEC^ICDEX       ICR   5747
	;    $$CSI^ICDEX         ICR   5747
	;    $$DTBR^ICDEX        ICR   5747
	;    $$EXIST^ICDEX       ICR   5747
	;    $$HIST^ICDEX        ICR   5747
	;    $$ICDDX^ICDEX       ICR   5747
	;    $$LA^ICDEX          ICR   5747
	;    $$SD^ICDEX          ICR   5747
	;    $$SYS^ICDEX         ICR   5747
	;    $$DT^XLFDT          ICR  10103
	;               
EN	; Main Entry Point
	N LEXENV S LEXENV=$$EV^LEXQM Q:+LEXENV'>0
	N DIC,DIR,DIRB,DIROUT,DIRUT,DTOUT,DUOUT,EXD,ICDFMT,ICDSYS,ICDVDT,LEX,LEX1,LEX2,LEX3,LEXAD,LEXBOD,LEXBRD,LEXBRW,LEXC,LEXCC,LEXCCD,LEXCCE,LEXCCI,LEXCDT
	N LEXCT,LEXCTE,LEXD,LEXDAT,LEXDDD,LEXDDE,LEXDDI,LEXDDT,LEXDEF,LEXDRG,LEXDRG1,LEXDRG2,LEXDRGC,LEXDRGD,LEXDRP,LEXDTXT,LEXDX,LEXE,LEXEDT,LEXEE,LEXEF
	N LEXEFF,LEXELDT,LEXENV,LEXES,LEXEVDT,LEXEXIT,LEXFA,LEXFUL,LEXGET,LEXH,LEXHIS,LEXI,LEXIA,LEXICD,LEXICDC,LEXID,LEXIEN,LEXIENS,LEXINC,LEXINCC
	N LEXINOT,LEXIREQ,LEXISO,LEXL,LEXLA,LEXLAST,LEXLD,LEXLDD,LEXLDR,LEXLDT,LEXLEF,LEXLEN,LEXLHI,LEXLHS,LEXLS,LEXLSD,LEXLSO,LEXLST,LEXLTXT,LEXLX,LEXM
	N LEXMC,LEXMD,LEXMDC,LEXMH,LEXN,LEXN0,LEXNAM,LEXNCC,LEXO,LEXOD,LEXODD,LEXP,LEXPF,LEXPIE,LEXR,LEXREF,LEXS,LEXSAB,LEXSD,LEXSDD,LEXSDT,LEXSIEN,LEXSO
	N LEXST,LEXSTA,LEXSTAT,LEXSTR,LEXSY,LEXSYS,LEXT,LEXTMP,LEXU,LEXVDT,LEXVTMP,LEXVTXT,LEXW,LEXWN,LEXX,X,Y S LEXEXIT=0
	K ^TMP("LEXQID",$J),^TMP("LEXQIDO",$J),^TMP("LEXQIDA",$J),^TMP("LEXQIDN",$J),^TMP("LEXQIDR",$J),^TMP("LEXQIDC",$J)
	W ! F  S LEXCDT=$$AD^LEXQM,LEXAD=LEXCDT Q:'$L(LEXCDT)  S LEXEDT=$P(LEXCDT,"^",1),LEXCDT=$P(LEXCDT,"^",2) Q:LEXCDT'?7N  D LOOK Q:LEXCDT'?7N  Q:+LEXEXIT>0
	K ^TMP("LEXQID",$J),^TMP("LEXQIDO",$J),^TMP("LEXQIDA",$J),^TMP("LEXQIDN",$J),^TMP("LEXQIDR",$J),^TMP("LEXQIDC",$J)
	Q 
LOOK	; ICD Lookup Loop
	N LEXGET,LEXST,LEXSD,LEXLD,LEXMD,LEXLX,LEXWN,LEXCC,LEXMC,LEXICD,LEXICDC
	S LEXCDT=$G(LEXCDT),LEXEDT=$$ED^LEXQM(LEXCDT) I LEXCDT'?7N S LEXCDT="" Q
	S LEXLEN=62 F  S LEXICD=$$ICD^LEXQIDA D  Q:LEXICD="^"!(LEXICD="^^")
	. S:LEXICD="^^" LEXEXIT=1 Q:+($G(LEXEXIT))>0  Q:LEXICD="^"!(LEXICD="^^")
	. K LEXGET,LEXST,LEXSD,LEXLD,LEXMD,LEXLX,LEXWN,LEXCC,LEXMC,^TMP("LEXQID",$J)
	. N LEXIEN,LEXLDT,LEXELDT,LEXINC,LEXINOT,LEXIREQ,LEXINCC,LEXFA
	. S LEXIEN=+($G(LEXICD)),LEXLDT=+($G(LEXCDT)),LEXFA=$$FA(+LEXIEN) Q:+LEXIEN'>0  Q:LEXLDT'?7N
	. S LEXELDT=$$SD^LEXQM(LEXLDT) Q:'$L(LEXELDT)
	. S (LEXINOT,LEXIREQ,LEXINCC)=0 I LEXFA?7N,LEXCDT?7N,LEXFA'>LEXCDT D
	. . S LEXINOT=$$EXIST^ICDEX(+($G(LEXIEN)),20) S:+LEXINOT>0 LEXINOT=$$NOT^LEXQIDA(+($G(LEXIEN))) S:LEXINOT["^^" LEXEXIT=1 Q:LEXINOT["^"
	. . S LEXIREQ=$$EXIST^ICDEX(+($G(LEXIEN)),30) S:+LEXIREQ>0 LEXIREQ=$$REQ^LEXQIDA(+($G(LEXIEN))) S:LEXIREQ["^^" LEXEXIT=1 Q:LEXIREQ["^"
	. . S LEXINCC=$$EXIST^ICDEX(+($G(LEXIEN)),40) S:LEXINCC>0 LEXINCC=$$NCC^LEXQIDA(+($G(LEXIEN))) S:LEXINCC["^^" LEXEXIT=1 Q:LEXINCC["^"
	. D CSV,EN^LEXQID4
	Q
CSV	; Code Set Versioning Display
	N LEXEDT,LEXIEN,LEXIENS,LEXLTXT,LEXSTAT,LEXDAT
	S LEXCDT=$G(LEXCDT),LEXEDT=$$ED^LEXQM(LEXCDT) I LEXCDT'?7N S (LEXICD,LEXCDT)="" Q
	S LEXIEN=+($G(LEXICD)),LEXSO=$$CODEC^ICDEX(80,+LEXIEN)
	S LEXLTXT=$P($G(LEXICD),"^",3) S LEXSYS=$$CSI^ICDEX(80,+LEXIEN)
	Q:+LEXIEN'>0  Q:'$L(LEXSO)  Q:+LEXSYS'>0
	S LEXDAT=$$ICDDX^ICDEX(LEXSO,LEXCDT,LEXSYS,"E")
	S LEXSO=$P(LEXDAT,"^",2),LEXNAM=$P(LEXDAT,"^",4)
	I '$L(LEXNAM) D
	. N LEXLA S LEXLA=$$LA^ICDEX(80,+LEXIEN,9999999)
	. S LEXNAM=$$SD^ICDEX(80,+LEXIEN,LEXLA)
	Q:'$L($G(LEXNAM))
	; 
	; Get the "Versioned" Fields
	;            
	;   Date/Status          80.066  (66)
	S LEXST=$$EF(+($G(LEXIEN)),+LEXCDT),LEXSTAT=+($P(LEXST,"^",2))
	;   Diagnosis Name       80.067  (67)
	D SDS(+($G(LEXIEN)),+LEXCDT,.LEXSD,62,LEXSTAT)
	;   Description          80.068  (68)
	D LDS^LEXQID2(+($G(LEXIEN)),+LEXCDT,.LEXLD,62,LEXSTAT)
	;   Lexicon Expression          
	D LX^LEXQID2(+($G(LEXIEN)),+LEXCDT,.LEXLX,62,LEXSTAT)
	;   Warning Message
	D WN^LEXQID2(+LEXCDT,.LEXWN,62)
	;   DRG Groups           80.071  (71)
	D DRG^LEXQID3(+LEXIEN,+LEXCDT,LEXLEN)
	;   CC                   80.0103 (103)
	D CC^LEXQID3(+($G(LEXIEN)),+LEXCDT,.LEXCC)
	;   MDC                  80.072  (72)
	D MDC^LEXQID2(+($G(LEXIEN)),LEXCDT,.LEXMC)
	;            
	; Get the "Asked for" Fields
	;            
	;   Codes not to use     80.01   (20) 
	D:+($G(LEXINOT))>0 NOT^LEXQID3(+LEXIEN,+LEXCDT,LEXLEN)
	;   Codes required with  80.02   (30) 
	D:+($G(LEXIREQ))>0 REQ^LEXQID3(+LEXIEN,+LEXCDT,LEXLEN)
	;   Codes not CC with    80.03   (40)
	D:+($G(LEXINCC))>0 NCC^LEXQID3(+LEXIEN,+LEXCDT,LEXLEN)
	Q
	; 
EF(X,LEXCDT)	; Effective Dates
	N LEX,LEXAD,LEXBRD,LEXBRW,LEXEE,LEXEF,LEXES,LEXFA,LEXH,LEXI,LEXID,LEXIEN,LEXLS,LEXSO,LEXST,LEXSY S LEXIEN=+($G(X)),LEXCDT=+($G(LEXCDT))
	Q:+LEXIEN'>0 "^^"  Q:LEXCDT'?7N "^^"  S LEXSO=$$CODEC^ICDEX(80,+LEXIEN),LEXSY=$$SYS^ICDEX(LEXSO,LEXCDT),LEX=$$ICDDX^ICDEX(LEXSO,LEXCDT,LEXSY,"E")
	S LEXFA=$$FA(+LEXIEN),(LEXLS,LEXST)=$P(LEX,"^",10),LEXID=$P(LEX,"^",12),LEXBRD=$$IMPDATE^LEXU("ICD"),LEXBRW=""
	I LEXCDT<LEXBRD&(+LEXFA=LEXBRD) D
	. S LEXBRW="Warning:  The 'Based on Date' provided precedes the initial Code Set Business Rule date of "
	. S LEXBRW=LEXBRW_$$SD^LEXQM(LEXBRD)_", the Effective date may be inaccurate."
	S LEXAD=$P(LEX,"^",17),LEXES=$S(+LEXST>0:"Active",1:"Inactive")
	S:+LEXST'>0&(+LEXAD'>0) LEXES="Not Applicable",LEXLS=-1
	S:+LEXFA>0&(+LEXCDT>0)&(LEXFA>LEXCDT) LEXES="Pending",LEXLS=-1,LEXST=0,LEXBRW=""
	S:LEXST>0 LEXEF=LEXAD S:LEXST'>0 LEXEF=LEXID
	S:LEXST'>0&(+LEXID'>0) LEXEF=LEXFA S LEXEE=$$SD^LEXQM(LEXEF)
	I LEXST'>0,+LEXID'>0,$L(LEXEE),+LEXEF>LEXCDT S LEXEE="(future activation of "_LEXEE_")",LEXEF=""
	S X=LEXLS_"^"_LEXST_"^"_LEXEF_"^"_LEXES_"^"_LEXEE S:$L(LEXBRW) $P(X,"^",6)=LEXBRW
	Q X
	; 
SDS(X,LEXVDT,LEX,LEXLEN,LEXSTA)	; Diagnosis (short description)
	; 
	; LEX=# of Lines
	; LEX(0)=External Date of Diagnosis Name
	; LEX(#)=Diagnosis Name
	; 
	N LEXBRD,LEXBRW,LEXC,LEXD,LEXDDT,LEXE,LEXEE,LEXEFF,LEXFA
	N LEXHIS,LEXI,LEXIA,LEXIEN,LEXL,LEXLA,LEXLAST,LEXLEF
	N LEXLHI,LEXLSD,LEXM,LEXOD,LEXODD,LEXR,LEXS,LEXSD,LEXSDD
	N LEXSDT,LEXSO,LEXSY,LEXT S LEXIEN=$G(X) Q:+LEXIEN'>0
	S LEXVDT=+($G(LEXVDT)) S:LEXVDT'?7N LEXVDT=$$DT^XLFDT
	S LEXSTA=+($G(LEXSTA)) S LEXSO=$$CODEC^ICDEX(80,+LEXIEN)
	S LEXSY=$$CSI^ICDEX(80,+LEXIEN)
	S LEXLA=$$LA^ICDEX(80,+LEXIEN,9999999),LEXFA=$$FA(+LEXIEN)
	S LEXLAST=$$ICDDX^ICDEX(LEXSO,LEXLA,LEXSY,"E")
	S LEXLSD=$P(LEXLAST,"^",5),LEXBRD=$$DTBR^ICDEX(LEXVDT,0,LEXSY),LEXBRW=""
	S LEXSD=$$SD^ICDEX(80,+LEXIEN,LEXVDT,.LEXS)
	S LEXSD=$G(LEXS(1)),LEXSDD=$P($G(LEXS(0)),"^",2)
	S:'$L(LEXSD) LEXSDD="--/--/----" S LEXM=""
	I $P(LEXSD,"^",1)="-1"!('$L(LEXSD)) D
	. S LEXM="Diagnosis Short Name is not available."
	. I (LEXVDT'?7N!(LEXFA'?7N)),LEXVDT<LEXFA D
	. . S LEXM=LEXM_"  The date provided precedes the initial activation of the code"
	. I LEXVDT?7N&(LEXFA?7N),LEXVDT<LEXFA D
	. . S LEXM=LEXM_"  The date provided ("_$$ED^LEXQM(LEXVDT)_") precedes the initial activation ("_$$ED^LEXQM(LEXFA)_") of the code"
	. S:$L(LEXM) LEXM="NOTE:  "_LEXM S LEXOD=LEXLSD,LEXODD="--/--/----"
	I $L(LEXSD)&($P(LEXSD,"^",1)'="-1") D
	. S LEXM="" S LEXOD=LEXSD,LEXODD=$S(LEXSDD?7N:$$ED^LEXQM(LEXSDD),1:"--/--/----")
	S:'$L(LEXOD) LEXOD="Diagnosis Short Name not found"
	S:'$L(LEXODD) LEXODD="--/--/----"
	K LEX,LEXT S LEXT(1)=LEXOD D PR^LEXQM(.LEXT,(LEXLEN-7))
	S LEXI=0 F  S LEXI=$O(LEXT(LEXI)) Q:+LEXI'>0  S LEXT=$G(LEXT(LEXI)) S LEX(LEXI)=LEXT
	I $L($G(LEXM)) D
	. K LEX,LEXT N LEXC S LEXT(1)=LEXM D PR^LEXQM(.LEXT,(LEXLEN-7))
	. S LEXI=0 F  S LEXI=$O(LEXT(LEXI)) Q:+LEXI'>0  S LEXT=$G(LEXT(LEXI)) S LEXC=$O(LEX(" "),-1)+1,LEX(LEXC)=LEXT
	S:$D(LEX(1)) LEX(0)=LEXODD
	Q
	; 
	; Miscellaneous
FA(X)	;   First Activation
	N LEXFA,LEXH,LEXI,LEXIEN,LEXSO,LEXSY
	S LEXIEN=+($G(X)) S X="",LEXSO=$$CODEC^ICDEX(80,+LEXIEN),LEXSY=$$CSI^ICDEX(80,+LEXIEN)
	K LEXH S X=$$HIST^ICDEX(LEXSO,.LEXH,LEXSY) S LEXFA="",LEXI=0
	F  S LEXI=$O(LEXH(LEXI)) Q:+LEXI'>0!($L(LEXFA))  S:+($G(LEXH(LEXI)))>0&(LEXI?7N) LEXFA=LEXI Q:$L(LEXFA)
	S X=LEXFA
	Q X
IA(X,Y)	;   Inaccurate
	N LEXBRD,LEXVDT,LEXIEN,LEXSYS S LEXVDT=+($G(X)),LEXIEN=+($G(Y)) Q:+LEXIEN'>0 0
	S LEXSYS=$$CSI^ICDEX(80,+LEXIEN) Q:+LEXSYS'>0 0  S:'$L(LEXVDT) LEXVDT=$$DT^XLFDT
	S:LEXVDT#10000=0 LEXVDT=LEXVDT+101 S:LEXVDT#100=0 LEXVDT=LEXVDT+1
	S LEXBRD=$$DTBR^ICDEX(LEXVDT,0,LEXSYS) S X=$S(LEXVDT<LEXBRD:1,1:0)
	Q X