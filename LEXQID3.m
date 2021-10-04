LEXQID3	;ISL/KER - Query - ICD Diagnosis - Extract (cont) ;04/21/2014
	;;2.0;LEXICON UTILITY;**62,80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^ICD(               ICR   4487
	;    ^TMP("LEXQID"       SACC 2.3.2.5.1
	;    ^TMP("LEXQIDC"      SACC 2.3.2.5.1
	;    ^TMP("LEXQIDN"      SACC 2.3.2.5.1
	;    ^TMP("LEXQIDR"      SACC 2.3.2.5.1
	;               
	; External References
	;    $$CODEABA^ICDEX     ICR   5747
	;    $$CODECS^ICDEX      ICR   5747
	;    $$CODEC^ICDEX       ICR   5747
	;    $$CSI^ICDEX         ICR   5747
	;    $$GETDRG^ICDEX      ICR   5747
	;    $$ICDDX^ICDEX       ICR   5747
	;    $$NCC^ICDEX         ICR   5747
	;    $$NOT^ICDEX         ICR   5747
	;    $$REQ^ICDEX         ICR   5747
	;    $$VCC^ICDEX         ICR   5747
	;    DRGD^ICDGTDRG       ICR   4052
	;    $$DT^XLFDT          ICR  10103
	;    $$FMTE^XLFDT        ICR  10103
	;    $$UP^XLFSTR         ICR  10104
	;               
	Q
NOT(X,LEXVDT,LEXLEN)	; Include ICD Codes not to use with ***.**
	; 
	; ^TMP("LEXQIDN",$J,IEN)=CODE
	; ^TMP("LEXQIDN",$J,"B",(CODE_" "),IEN)=""
	; 
	; ^TMP("LEXQID",$J,"NOT",0)=<total>
	; ^TMP("LEXQID",$J,"NOT",1,1)=<header>
	; ^TMP("LEXQID",$J,"NOT",2,#)=<header text>
	; ^TMP("LEXQID",$J,"NOT",3,<code >)=<code>_"  "_<diagnosis>
	; 
	K ^TMP("LEXQIDN",$J),^TMP("LEXQID",$J,"NOT")
	N LEX,LEXI,LEXC,LEXICD,LEXIEN,LEXISO,LEXSO,LEXSD,EXD,LEXT,LEXSTR,LEXO
	S LEXIEN=+($G(X)) Q:+LEXIEN'>0  S LEXVDT=+($G(LEXVDT)) S:LEXVDT'?7N LEXVDT=$$DT^XLFDT
	S LEXISO=$$CODEC^ICDEX(80,+LEXIEN) Q:'$L(LEXISO)
	S LEXLEN=+$G(LEXLEN) S:+LEXLEN>62 LEXLEN=62 S X=$$NOT^ICDEX(+($G(LEXIEN)),"LEXQIDN",1)
	S LEXO="" F  S LEXO=$O(^TMP("LEXQIDN",$J,"B",LEXO)) Q:'$L(LEXO)  D
	. N LEXD S LEXICD=$O(^TMP("LEXQIDN",$J,"B",LEXO,0)) Q:+LEXICD'>0
	. S LEXSYS=$$CSI^ICDEX(80,+LEXICD)
	. S LEXD=$$ICDDX^ICDEX(+LEXICD,LEXVDT,LEXSYS,"I")
	. S LEXSO=$P(LEXD,"^",2),LEXSD=$$UP^XLFSTR($P(LEXD,"^",4)) Q:'$L(LEXSO)  Q:'$L(LEXSD)
	. S LEXT=LEXSO,LEXT=LEXT_$J(" ",(9-$L(LEXT)))_LEXSD
	. S ^TMP("LEXQID",$J,"NOT",3,(LEXSO_" "))=LEXT
	K ^TMP("LEXQIDN",$J) S LEXC=0,LEXI=""
	F  S LEXI=$O(^TMP("LEXQID",$J,"NOT",3,LEXI)) Q:'$L(LEXI)  S LEXC=LEXC+1
	S ^TMP("LEXQID",$J,"NOT",0)=+($G(LEXC))
	S LEXI=+($G(^TMP("LEXQID",$J,"NOT",0))) I LEXI>0 D
	. N LEX,LEXC,LEXSTR,LEXT S LEXSTR="The following code"_$S(LEXI>1:"s ",1:" ")_"cannot be used in conjunction with "
	. S:$L($G(LEXISO)) LEXSTR=LEXSTR_"ICD Code "_LEXISO S:'$L($G(LEXISO)) LEXSTR=LEXSTR_"this ICD Code"
	. S LEX(1)=LEXSTR D PR^LEXQM(.LEX,(LEXLEN-7)) S (LEXC,LEXT)=0 F  S LEXT=$O(LEX(LEXT)) Q:+LEXT'>0  D
	. . S LEXSTR=$$TM^LEXQM($G(LEX(LEXT))) S:$L(LEXSTR) LEXC=LEXC+1,^TMP("LEXQID",$J,"NOT",2,LEXC)=LEXSTR
	S:$D(^TMP("LEXQID",$J,"NOT",2)) ^TMP("LEXQID",$J,"NOT",1,1)="Not used"
	Q
REQ(X,LEXVDT,LEXLEN)	; Include ICD Codes required with ***.**
	; 
	; ^TMP("LEXQIDR",$J,IEN)=CODE
	; ^TMP("LEXQIDR",$J,"B",(CODE_" "),IEN)=""
	; 
	; ^TMP("LEXQID",$J,"REQ",0)=<total>
	; ^TMP("LEXQID",$J,"REQ",1,1)=<header>
	; ^TMP("LEXQID",$J,"REQ",2,#)=<header text>
	; ^TMP("LEXQID",$J,"REQ",3,<code >)=<code>_"  "_<diagnosis>
	; 
	K ^TMP("LEXQIDR",$J),^TMP("LEXQID",$J,"NOT")
	N LEX,LEXI,LEXC,LEXICD,LEXIEN,LEXISO,LEXSO,LEXSD,EXD,LEXT,LEXSTR,LEXO
	S LEXIEN=+($G(X)) Q:+LEXIEN'>0  S LEXVDT=+($G(LEXVDT)) S:LEXVDT'?7N LEXVDT=$$DT^XLFDT
	S LEXISO=$$CODEC^ICDEX(80,+LEXIEN) Q:'$L(LEXISO)
	S LEXLEN=+$G(LEXLEN) S:+LEXLEN>62 LEXLEN=62 S X=$$REQ^ICDEX(+($G(LEXIEN)),"LEXQIDR",1)
	S LEXO="" F  S LEXO=$O(^TMP("LEXQIDR",$J,"B",LEXO)) Q:'$L(LEXO)  D
	. N LEXD S LEXICD=$O(^TMP("LEXQIDR",$J,"B",LEXO,0)) Q:+LEXICD'>0
	. S LEXSYS=$$CSI^ICDEX(80,+LEXICD)
	. S LEXD=$$ICDDX^ICDEX(+LEXICD,LEXVDT,LEXSYS,"I")
	. S LEXSO=$P(LEXD,"^",2),LEXSD=$$UP^XLFSTR($P(LEXD,"^",4)) Q:'$L(LEXSO)  Q:'$L(LEXSD)
	. S LEXT=LEXSO,LEXT=LEXT_$J(" ",(9-$L(LEXT)))_LEXSD
	. S ^TMP("LEXQID",$J,"REQ",3,(LEXSO_" "))=LEXT
	K ^TMP("LEXQIDR",$J) S LEXC=0,LEXI=""
	F  S LEXI=$O(^TMP("LEXQID",$J,"REQ",3,LEXI)) Q:'$L(LEXI)  S LEXC=LEXC+1
	S ^TMP("LEXQID",$J,"REQ",0)=+($G(LEXC))
	S LEXI=+($G(^TMP("LEXQID",$J,"REQ",0))) I LEXI>0 D
	. N LEX,LEXC,LEXSTR,LEXT S:LEXI>1 LEXSTR="One of the following codes is required when "
	. S:LEXI>1 LEXSTR="One of the following codes is required when " S:LEXI'>1 LEXSTR="The following code is required when "
	. S:$L($G(LEXISO)) LEXSTR=LEXSTR_"ICD Code "_LEXISO_" "
	. S:'$L($G(LEXISO)) LEXSTR=LEXSTR_"this ICD Code " S LEXSTR=LEXSTR_"is used"
	. S LEX(1)=LEXSTR D PR^LEXQM(.LEX,(LEXLEN-7)) S (LEXC,LEXT)=0 F  S LEXT=$O(LEX(LEXT)) Q:+LEXT'>0  D
	. . S LEXSTR=$$TM^LEXQM($G(LEX(LEXT))) S:$L(LEXSTR) LEXC=LEXC+1,^TMP("LEXQID",$J,"REQ",2,LEXC)=LEXSTR
	S:$D(^TMP("LEXQID",$J,"REQ",2)) ^TMP("LEXQID",$J,"REQ",1,1)="Required with"
	Q
NCC(X,LEXVDT,LEXLEN)	; Include the codes that ***.** is not CC with
	; 
	; ^TMP("LEXQIDC",$J,IEN)=CODE
	; ^TMP("LEXQIDC",$J,"B",(CODE_" "),IEN)=""
	; 
	; ^TMP("LEXQID",$J,"NCC",0)=<total>
	; ^TMP("LEXQID",$J,"NCC",1,1)=<header>
	; ^TMP("LEXQID",$J,"NCC",2,#)=<header text>
	; ^TMP("LEXQID",$J,"NCC",3,<code >)=<code>_"  "_<diagnosis>
	; 
	K ^TMP("LEXQIDC",$J),^TMP("LEXQID",$J,"NOT")
	N LEX,LEXI,LEXC,LEXICD,LEXIEN,LEXISO,LEXSO,LEXSD,EXD,LEXT,LEXSTR,LEXO
	S LEXIEN=+($G(X)) Q:+LEXIEN'>0  S LEXVDT=+($G(LEXVDT)) S:LEXVDT'?7N LEXVDT=$$DT^XLFDT
	S LEXISO=$$CODEC^ICDEX(80,+LEXIEN) Q:'$L(LEXISO)
	S LEXLEN=+$G(LEXLEN) S:+LEXLEN>62 LEXLEN=62 S X=$$NCC^ICDEX(+($G(LEXIEN)),"LEXQIDC",1)
	S LEXO="" F  S LEXO=$O(^TMP("LEXQIDC",$J,"B",LEXO)) Q:'$L(LEXO)  D
	. N LEXD,LEXI,LEXC
	. S LEXI=$O(^TMP("LEXQIDC",$J,"B",LEXO,0)) Q:+LEXI'>0
	. S LEXC=$G(^TMP("LEXQIDC",$J,LEXI)) Q:'$L(LEXC)
	. S LEXSYS=+($$CODECS^ICDEX(LEXC,80)) Q:+LEXSYS'>0
	. S LEXICD=$$CODEABA^ICDEX(LEXC,80,+LEXSYS)
	. ; S LEXICD=$O(^TMP("LEXQIDC",$J,"B",LEXO,0)) Q:+LEXICD'>0
	. ; S LEXSYS=$$CSI^ICDEX(80,+LEXICD)
	. S LEXD=$$ICDDX^ICDEX(+LEXICD,LEXVDT,LEXSYS,"I")
	. S LEXSO=$P(LEXD,"^",2),LEXSD=$$UP^XLFSTR($P(LEXD,"^",4)) Q:'$L(LEXSO)  Q:'$L(LEXSD)
	. S LEXT=LEXSO,LEXT=LEXT_$J(" ",(9-$L(LEXT)))_LEXSD
	. S ^TMP("LEXQID",$J,"NCC",3,(LEXSO_" "))=LEXT
	K ^TMP("LEXQIDC",$J) S LEXC=0,LEXI=""
	F  S LEXI=$O(^TMP("LEXQID",$J,"NCC",3,LEXI)) Q:'$L(LEXI)  S LEXC=LEXC+1
	S ^TMP("LEXQID",$J,"NCC",0)=+($G(LEXC))
	S LEXI=+($G(^TMP("LEXQID",$J,"NCC",0))) I LEXI>0 D
	. N LEX,LEXC,LEXSTR,LEXT S LEXSTR="ICD Code " S:$L($G(LEXISO)) LEXSTR=LEXSTR_LEXISO_" "
	. S LEXSTR=LEXSTR_"is not considered as Complication Comorbidity (CC) with the following code"_$S(LEXI>1:"s",1:"")
	. S LEX(1)=LEXSTR D PR^LEXQM(.LEX,(LEXLEN-7)) S (LEXC,LEXT)=0 F  S LEXT=$O(LEX(LEXT)) Q:+LEXT'>0  D
	. . S LEXSTR=$$TM^LEXQM($G(LEX(LEXT))) S:$L(LEXSTR) LEXC=LEXC+1,^TMP("LEXQID",$J,"NCC",2,LEXC)=LEXSTR
	S:$D(^TMP("LEXQID",$J,"NCC",2)) ^TMP("LEXQID",$J,"NCC",1,1)="Not CC with"
	Q
DRG(X,LEXVDT,LEXLEN)	; Diagnosis Related Group
	;               
	; ^TMP("LEXQID",$J,"DRG",0)=<total>
	; ^TMP("LEXQID",$J,"DRG",1,1)=<header>
	; ^TMP("LEXQID",$J,"DRG",1,2)=<effective date>
	; ^TMP("LEXQID",$J,"DRG",2,1)=<header text>
	; ^TMP("LEXQID",$J,"DRG",3,#)=<DRG list>
	;               
	N LEXC,LEXDDD,LEXDDE,LEXDEF,LEXDDI,LEXDDT,LEXDRG,LEXDRG1,LEXDRG2,LEXDRGC,LEXDRGD,LEXDRP,LEXI,LEXIEN,LEXL,LEXN,LEXN0,LEXT
	N LEXEFF,LEXPIE,LEXSTA S LEXIEN=+($G(X)) Q:+LEXIEN'>0
	S LEXVDT=+($G(LEXVDT)) S:LEXVDT'?7N LEXVDT=$$DT^XLFDT S LEXLEN=+$G(LEXLEN) S:+LEXLEN>62 LEXLEN=62
	S LEXSTR=$$GETDRG^ICDEX(80,LEXIEN,LEXVDT),LEXSTA=$P(LEXSTR,";",3) Q:LEXSTA'>0  S LEXEFF=$P(LEXSTR,";",2) Q:LEXEFF'?7N  S LEXSTR=$P(LEXSTR,";",1)
	I '$L($TR(LEXSTR,"^","")) D  Q
	. S ^TMP("LEXQID",$J,"DRG",0)=0,^TMP("LEXQID",$J,"DRG",1,1)="DRG Groups"
	. S ^TMP("LEXQID",$J,"DRG",2,1)="No DRG Groups found to be active for the date provided"
	. S:LEXVDT?7N ^TMP("LEXQID",$J,"DRG",2,1)="No DRG Groups found to be active on "_$$SD^LEXQM(LEXVDT)
	F LEXPIE=1:1 Q:'$L($P(LEXSTR,"^",LEXPIE))  S LEXDRP=$P(LEXSTR,"^",LEXPIE) D
	. S LEXDRG=$P($G(^ICD(+LEXDRP,0)),"^",1)
	. K LEXDRGD D DRGD^ICDGTDRG(LEXDRG,"LEXDRGD",,+LEXVDT)
	. S LEXDRG=$TR(LEXDRG,"DRG",""),LEXDRG=+LEXDRG Q:+LEXDRG'>0
	. S LEXI=0 F  S LEXI=$O(LEXDRGD(LEXI)) Q:+LEXI'>0  D
	. . N LEXT S LEXT=$$TM^LEXQM($G(LEXDRGD(LEXI)))
	. . I '$L(LEXT)!(LEXT["CODE TEXT MAY BE INACCURATE") K LEXDRGD(LEXI) Q
	. . S LEXDRGD(LEXI)=LEXT
	. S LEXDRG1=LEXDRG,LEXDRG1=LEXDRG1_$J(" ",(6-$L(LEXDRG1))),LEXDRG2=$J(" ",6) D PR^LEXQM(.LEXDRGD,(LEXLEN-8))
	. S (LEXC,LEXI)=0 F  S LEXI=$O(LEXDRGD(LEXI)) Q:+LEXI'>0  D
	. . N LEXT,LEXL,LEXN S LEXT=$$TM^LEXQM($G(LEXDRGD(LEXI)))
	. . Q:'$L(LEXT)  S LEXC=LEXC+1
	. . S:LEXC=1 LEXL=LEXDRG1_LEXT,LEXDRGC=+($G(LEXDRGC))+1
	. . S:LEXC>1 LEXL=LEXDRG2_LEXT
	. . S LEXN=$O(^TMP("LEXQID",$J,"DRG",3," "),-1)+1
	. . S ^TMP("LEXQID",$J,"DRG",3,LEXN)=LEXL
	S ^TMP("LEXQID",$J,"DRG",0)=+($G(LEXDRGC)),^TMP("LEXQID",$J,"DRG",1,1)="DRG Groups"
	S:$G(LEXEFF)?7N ^TMP("LEXQID",$J,"DRG",1,2)=$$SD^LEXQM(LEXEFF)
	S:+($G(LEXDRGC))>0 ^TMP("LEXQID",$J,"DRG",2,1)=+($G(LEXDRGC))_" Diagnosis Related Group"_$S(+($G(LEXDRGC))>1:"s",1:"")_" (DRG)"
	Q
CC(X,LEXVDT,LEX)	; Complication/Comorbidity
	N LEXCCE,LEXCCI,LEXCCD K LEX S LEX=0,LEXIEN=+($G(X)) Q:+LEXIEN'>0  S LEXVDT=+($G(LEXVDT)) S:LEXVDT'?7N LEXVDT=$$DT^XLFDT
	S LEXCCI=$$VCC^ICDEX(+LEXIEN,LEXVDT,1),LEXCCD=$P(LEXCCI,"^",2),LEXCCI=$P(LEXCCI,"^",1) Q:"^0^1^2^"'[("^"_LEXCCI_"^")
	Q:LEXCCD'?7N  S LEXCCE=$S(+LEXCCI=0:"Non-Complication/Comorbidity (Non-CC)",+LEXCCI=1:"Complication/Comorbidity (CC)",+LEXCCI=2:"Major Complication/Comorbidity (MCC)",1:"")
	Q:'$L(LEXCCE)  S LEX=1,LEX(0)=$$SD^LEXQM(LEXCCD),LEX(1)=LEXCCE
	Q
	; 
	; Miscellaneous            
SD(X)	;   Short Date
	Q $TR($$FMTE^XLFDT(+($G(X)),"5DZ"),"@"," ")
IA(X)	;   Inaccurate
	N LEXBRD,LEXVDT,LEXSYS S LEXVDT=+($G(X)),LEXSYS=1,LEXVDT=$S($G(LEXVDT)="":$$DT^XLFDT,1:$$DBR(LEXVDT)),LEXBRD=3021001,X=$S(LEXVDT<LEXBRD:1,1:0)
	Q X
DBR(X)	;   Date Business Rules
	N LEXVDT S LEXVDT=$G(X) Q:'$G(LEXVDT)!($P(LEXVDT,".")'?7N) $$DT^XLFDT
	S:LEXVDT#10000=0 LEXVDT=LEXVDT+101 S:LEXVDT#100=0 LEXVDT=LEXVDT+1 S X=$S(LEXVDT<2781001:2781001,1:LEXVDT)
	Q X