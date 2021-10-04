LEX10CX3	;ISL/KER - ICD-10 Cross-Over - Target (find) ;04/21/2014
	;;2.0;LEXICON UTILITY;**80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^TMP("LEXFND")      SACC 2.3.2.5.1
	;    ^TMP("LEXHIT")      SACC 2.3.2.5.1
	;    ^TMP("LEXSCH")      SACC 2.3.2.5.1
	;    ^TMP("LEXTMP")      SACC 2.3.2.5.1
	;               
	; External References
	;    $$CODEC^ICDEX       ICR   5747
	;    $$DT^XLFDT          ICR  10103
	;    $$FMADD^XLFDT       ICR  10103
	;    $$LA^ICDEX          ICR   5747
	;    $$OD^ICDEX          ICR   5747
	;    $$UP^XLFSTR         ICR  10104
	;    $$VLTD^ICDEX        ICR   5747
	;    ^DIC                ICR  10006
	;               
	; Local Variables NEWed or KILLed Elsewhere
	;     LEX0FND NEWed in LEX10CX
	;               
FIND1(X,LEXSRC,LEXTGT)	; Find ICD-10 Codes based on Text Lookup
	;
	; Input
	; 
	;     X        Input Code
	;     LEXSRC   Local Array Source Code (passed by reference)
	;     LEXTGT   Local Array Target ICD-10 (passed by reference)
	; 
	; Output
	; 
	;     X        Number if ICD-10 Dx Codes found
	;              
	;     LEXSRC   Local Array ICD-9 (passed by reference)
	;     LEXTGT   Local Array (passed by reference)
	; 
	;                LEXTGT(0) = Number of ICD-10 Codes found
	;                LEXTGT(n) = Three piece "^" delimited string
	;                               1  Pointer to Expression file
	;                               2  Expression
	;                               3  ICD-10 Code
	; 
	N DIC,DO,LEX,LEXCTR,LEXAI,LEXICDD,LEXIIEN,LEXMAX,LEXO,LEXOK
	N LEXP,LEXS,LEXSO,LEXTD,LEXU,LEXU1,LEXUI,LEXVDT,LEXX,LEXXC,LEXXE
	N LEXXI,LEXXT,Y S LEXMAX=+($G(LEXNASKM)) K DIC,DO,^TMP("LEXSCH",$J)
	K ^TMP("LEXHIT",$J),^TMP("LEXFND",$J),^TMP("LEXTMP",$J,"FIND1")
	Q:+($G(LEXSRC(0)))'>0 -1  S LEXSO=$G(X)
	S LEXICDD=$$FMADD^XLFDT($$IMPDATE^LEXU("10D"),3)
	S LEXTD=$$DT^XLFDT S:LEXTD>LEXICDD LEXICDD=LEXTD
	S LEXAI=0 F  S LEXAI=$O(LEXSRC(LEXAI)) Q:+LEXAI'>0  D
	. N LEXX,X,Y,DIC,LEXVDT,LEXXI,LEXXC,LEXXE,LEXU1,LEXUI,LEXOK
	. S LEXVDT=$G(LEXICDD)
	. S (LEXX,X)=$G(LEXSRC(LEXAI)) Q:'$L(X)
	. D CONFIG^LEXSET("10D","10D",LEXVDT)
	. S ^TMP("LEXSCH",$J,"DIS",0)="10D"
	. S DIC("S")="I $L($$ONE^LEXU(+Y,+($G(LEXVDT)),""10D""))"
	. S ^TMP("LEXSCH",$J,"FIL",0)=DIC("S")
	. K LEX D LOOK^LEXA(LEXX,"LEX",100,"10D",$G(LEXVDT))
	. S:$O(LEX("LIST",0))>0 LEX0FND=1
	. S LEXU1=$$UP^XLFSTR($G(^LEX(757.01,+($G(LEX("LIST",1))),0)))
	. S LEXUI=$$UP^XLFSTR(LEXX)
	. I LEXU1=LEXUI S LEXOK=0 D  Q:LEXOK
	. . N LEXXE,LEXXC,LEXIIEN S LEXXE=$G(LEX("LIST",1))
	. . S LEXXC=$$EC(+LEXXE,"10D") Q:'$L(LEXXC)  S LEXOK=1
	. . S ^TMP("LEXTMP",$J,"FIND1","SO",(LEXXC_" "))=LEXXE
	. S LEXUI=$TR(LEXUI,"~`!@#$%^&*()_-+={}|[]\;':"",./<>?"," ")
	. S LEXOK=0 S LEXXI=0 F  S LEXXI=$O(LEX("LIST",LEXXI)) Q:+LEXXI'>0  D
	. . N LEXU,LEXXE,LEXXC,LEXIIEN,LEXS,LEXP S LEXXE=$G(LEX("LIST",LEXXI))
	. . S LEXXC=$$EC(+LEXXE,"10D") Q:'$L(LEXXC)
	. . S LEXU=$$UP^XLFSTR($G(^LEX(757.01,+LEXXE,0)))
	. . S LEXU=$TR(LEXU,"~`!@#$%^&*()_-+={}|[]\;':"",./<>?"," ")
	. . F LEXP=1:1 S LEXS=$P(LEXUI," ",LEXP) Q:'$L(LEXS)  D
	. . . S LEXS=$$TM(LEXS) Q:'$L(LEXS)
	. . . F  Q:LEXU'[LEXS  S LEXU=$P(LEXU,LEXS,1)_" "_$P(LEXU,LEXS,2,299)
	. . S LEXU=$$TM(LEXU) I '$L(LEXU) D
	. . . S LEXXC=$$EC(+LEXXE,"10D") Q:'$L(LEXXC)  S LEXOK=1
	. . . S ^TMP("LEXTMP",$J,"FIND1","SO",(LEXXC_" "))=LEXXE
	. Q:LEXOK  S LEXXI=0 F  S LEXXI=$O(LEX("LIST",LEXXI)) Q:+LEXXI'>0  D
	. . N LEXXE,LEXXC,LEXIIEN
	. . S LEXXE=$G(LEX("LIST",LEXXI))
	. . S LEXXC=$$EC(+LEXXE,"10D") Q:'$L(LEXXC)
	. . S ^TMP("LEXTMP",$J,"FIND1","SO",(LEXXC_" "))=LEXXE
	K LEX,LEXTGT S LEXCTR=0,LEXO=0,LEXXC=""
	F  S LEXXC=$O(^TMP("LEXTMP",$J,"FIND1","SO",LEXXC)) Q:'$L(LEXXC)  D
	. N LEXXE,LEXXT,LEXXI
	. S LEXXE=$G(^TMP("LEXTMP",$J,"FIND1","SO",LEXXC))
	. Q:'$L(LEXXE)   Q:+LEXXE'>0  S LEXXT=$P(LEXXE,"^",2)
	. S:LEXXT["(ICD-10-CM " LEXXT=$P(LEXXT," (ICD-10-CM ",1)
	. S LEXXI=$O(LEXTGT(" "),-1)+1,LEXCTR=LEXCTR+1
	. I +($G(LEXMAX))>0,LEXCTR>+($G(LEXMAX)) Q
	. S LEXTGT(LEXXI)=+LEXXE_"^"_LEXXT_"^"_$TR(LEXXC," ","")
	. S (LEXO,LEXTGT(0))=LEXXI
	K ^TMP("LEXTMP",$J,"FIND1","SO")
	K ^TMP("LEXSCH",$J),^TMP("LEXHIT",$J),^TMP("LEXFND",$J)
	S X=+($G(LEXO)) S:X'>0 X=""
	Q X
FIND2(X,LEXSRC,LEXTGT)	; Find by margin
	;
	; Input        Same as $$FIND1
	; 
	; Output       Same as $$FIND1
	; 
	N LEXCO,LEXCT,LEXCTR,LEXCTL,LEXF,LEXHI,LEXI,LEXICDD,LEXIEN,LEXKEY
	N LEXLA,LEXLO,LEXMAX,LEXMX,LEXOR,LEXORD,LEXSEG,LEXSG,LEXSI,LEXSO
	N LEXTD,LEXTX,LEXX S (LEXOR,LEXX)=$G(X),LEXOR=$$UP^XLFSTR(LEXOR)
	S LEXICDD=$$FMADD^XLFDT($$IMPDATE^LEXU("10D"),3)
	S LEXTD=$$DT^XLFDT S:LEXTD>LEXICDD LEXICDD=LEXTD
	S LEXSI=0,LEXMAX=+($G(LEXNASKM)) I $O(LEXSRC("SEG",0))'>0 D
	. N LEXSEG D SEGS^LEX10CX5(LEXX,1,.LEXSEG)
	. S LEXI=0 F  S LEXI=$O(LEXSEG(LEXI)) Q:+LEXI'>0  D
	. . N LEXSG S LEXSG=$G(LEXSEG(LEXI)) Q:'$L(LEXSG)
	. . S LEXSI=$O(LEXSRC("SEG"," "),-1)+1
	. . S LEXSRC("SEG",LEXSI)=LEXSG
	I $O(LEXSRC("SEG",0))'>0 K LEXTGT Q -1
	S LEXKEY=$G(LEXSRC("SEG",1)) I '$L(LEXKEY) K LEXTGT Q -1
	K ^TMP("LEXTMP",$J,"FIND2") D FIND2B
	I '$D(^TMP("LEXTMP",$J,"FIND2")),+($G(LEXSI))>2 D
	. K ^TMP("LEXTMP",$J,"FIND2")
	. S LEXKEY=$G(LEXSRC("SEG",2))
	. D:$L(LEXKEY) FIND2B D:'$L(LEXKEY) FIND2C
	S LEXLO=$O(^TMP("LEXTMP",$J,"FIND2","B",0))
	S LEXHI=$O(^TMP("LEXTMP",$J,"FIND2","B"," "),-1)
	S LEXMX=$O(LEXSRC("SEG"," "),-1)
	S LEXCO=LEXMX S:LEXMX>0 LEXCO=$P(((LEXMX/5)*4),".",1)
	S:LEXMX>0 LEXLO=$P((LEXMX/3),".",1)
	S:LEXLO'<LEXCO LEXLO=LEXCO-1 S LEXF=0,LEXCTR=0
	F  S LEXF=$O(^TMP("LEXTMP",$J,"FIND2","B",LEXF)) Q:+LEXF'>0  D
	. Q:LEXF<LEXCO  N LEXI S LEXI=0
	. F  S LEXI=$O(^TMP("LEXTMP",$J,"FIND2","B",LEXF,LEXI)) Q:+LEXI'>0  D
	. . N LEXN,LEXT S LEXN=$O(LEXTGT(" "),-1)+1
	. . S LEXT=$G(^TMP("LEXTMP",$J,"FIND2",LEXI,LEXF))
	. . Q:'$L(LEXT)  S LEXCTR=LEXCTR+1
	. . I +($G(LEXMAX))>0,LEXCTR>+($G(LEXNASKM)) Q
	. . S LEXTGT(LEXN)=LEXT,LEXTGT(0)=LEXN
	S X=$G(LEXTGT(0)) S:+X'>0 X=""
	Q X
FIND2B	;   Find by margin based on Keyword #n
	N LEXORD S LEXORD=LEXKEY
	F  S LEXORD=$$OD^ICDEX(80,LEXORD,30) Q:$P(LEXORD,"^",1)'=LEXKEY  D
	. N LEXIEN,LEXLA,LEXTX,LEXSO,LEXF,LEXI,LEXSGI,LEXMX
	. S LEXIEN=$P(LEXORD,"^",2) Q:+LEXIEN'>0
	. S LEXLA=$$LA^ICDEX(80,LEXIEN,LEXICDD)
	. Q:LEXLA'?7N  S LEXLA=$$FMADD^XLFDT(LEXLA,1)
	. S LEXTX=$$UP^XLFSTR($$VLTD^ICDEX(LEXIEN,LEXLA))
	. S LEXSO=$$CODEC^ICDEX(80,LEXIEN)
	. S LEXF=0,LEXMX=$O(LEXSRC("SEG"," "),-1)
	. F LEXSGI=1:1:LEXMX D
	. . N LEXSG,LEXCT Q:$G(LEXSRC("SEG",1))=LEXKEY
	. . S LEXSG=$$UP^XLFSTR($G(LEXSRC("SEG",LEXSGI))) Q:'$L(LEXSG)
	. . S LEXCT=$$RN^LEX10CX5(LEXSG,LEXTX) I LEXCT>0 S LEXF=LEXF+1 Q
	. . S LEXCT=$$TY^LEX10CX5(LEXOR,LEXTX) I LEXCT>0 S LEXF=LEXF+1 Q
	. . I LEXTX[LEXSG S LEXF=LEXF+1
	. ;I $G(LEXX)["WITHOUT" S:LEXTX'["WITHOUT"&(LEXTX["WITH ") LEXF=0
	. I LEXF>0 D
	. . N LEXT,LEXSTA,LEXSI,LEXEI,LEXEX S LEXT=""
	. . S LEXSTA=$$STATCHK^LEXSRC2(LEXSO,LEXICDD,,"10D")
	. . S LEXSI=$P(LEXSTA,"^",2),LEXEI=$P($G(^LEX(757.02,+LEXSI,0)),"^",1)
	. . S LEXEX=$P($G(^LEX(757.01,+LEXEI,0)),"^",1)
	. . S:LEXEI>0&($L(LEXEX)) LEXT=LEXEI_"^"_LEXEX_"^"_LEXSO
	. . I $L(LEXT) D
	. . . S ^TMP("LEXTMP",$J,"FIND2",LEXEI,LEXF)=LEXT
	. . . S ^TMP("LEXTMP",$J,"FIND2","B",LEXF,LEXEI)=""
	Q
FIND2C	;   Find by margin based on single Keyword
	Q:'$L($G(LEXSRC("SEG",1)))  Q:$O(LEXSRC("SEG",1))>1
	N LEXORD S (LEXORD,LEXKEY)=$G(LEXSRC("SEG",1))
	F  S LEXORD=$$OD^ICDEX(80,LEXORD,30) Q:$P(LEXORD,"^",1)'=LEXKEY  D
	. N LEXIEN,LEXLA,LEXTX,LEXSO,LEXF,LEXI,LEXSGI,LEXMX
	. S LEXIEN=$P(LEXORD,"^",2) Q:+LEXIEN'>0
	. S LEXLA=$$LA^ICDEX(80,LEXIEN,LEXICDD)
	. Q:LEXLA'?7N  S LEXLA=$$FMADD^XLFDT(LEXLA,1)
	. S LEXTX=$$UP^XLFSTR($$VLTD^ICDEX(LEXIEN,LEXLA))
	. S LEXSO=$$CODEC^ICDEX(80,LEXIEN) S LEXF=1
	. I LEXF>0 D
	. . N LEXT,LEXSTA,LEXSI,LEXEI,LEXEX S LEXT=""
	. . S LEXSTA=$$STATCHK^LEXSRC2(LEXSO,LEXICDD,,"10D")
	. . S LEXSI=$P(LEXSTA,"^",2),LEXEI=$P($G(^LEX(757.02,+LEXSI,0)),"^",1)
	. . S LEXEX=$P($G(^LEX(757.01,+LEXEI,0)),"^",1)
	. . S:LEXEI>0&($L(LEXEX)) LEXT=LEXEI_"^"_LEXEX_"^"_LEXSO
	. . I $L(LEXT) D
	. . . S ^TMP("LEXTMP",$J,"FIND2",LEXEI,LEXF)=LEXT
	. . . S ^TMP("LEXTMP",$J,"FIND2","B",LEXF,LEXEI)=""
	Q
	;
FIND3(LEXSRC,LEXA)	; Source Array from Lookup
	;
	; Input
	; 
	;     LEXSRC   Local Array Source Code (passed by reference)
	;     LEXA     Local Array Target ICD-10 (passed by reference)
	; 
	; Output       Same as $$FIND1
	; 
	N DIC,DO,LEXCDT,LEXEFF,LEXEX,LEXH,LEXHDR1,LEXHDR2,LEXI,LEXSRCC,LEXSRCS
	N LEXSRCT,LEXIEN,LEXILA,LEXLA,LEXNOM,LEXQUIET,LEXS,LEXSO,LEXSRI,LEXSTA
	N LEXTD,LEXTX,LEXVDT,X,Y S LEXSRCC=$G(LEXSRC("SOURCE","SOE"))
	S LEXSRCS=$G(LEXSRC("SOURCE","SRC")),LEXSRCT=$G(LEXSRC("SOURCE","EXP"))
	K LEXHDR1,LEXHDR2 S (LEXHDR1,LEXHDR2,LEXHDR2(1))="",LEXQUIET=1
	I $G(LEX0FND)'>0 D
	. S:$O(LEXSRC(0))>0 LEXHDR1(1)="Unable to suggest an ICD-10 code.",LEXHDR2=""
	. S:$L(LEXSRCC)&($L(LEXSRCS)) LEXHDR1(1)="Unable to suggest an ICD-10 code, search for an acceptable ICD-10",LEXHDR1(2)="code for "_LEXSRCS_" code "_LEXSRCC
	I $G(LEX0FND)>0 D
	. S:$O(LEXSRC(0))>0 LEXHDR1(1)="No suggestions were selected, select an acceptable ICD-10 code.",LEXHDR2=""
	. S:$L(LEXSRCC)&($L(LEXSRCS)) LEXHDR1(1)="No suggestions were selected, select an acceptable ICD-10 code",LEXHDR1(2)="for "_LEXSRCS_" code "_LEXSRCC
	S:$L(LEXSRCC)&($L(LEXSRCS))&($L(LEXSRCT)) LEXHDR2(1)=LEXSRCT
	D:$L(LEXHDR2(1)) PAR^LEX10CX4(.LEXHDR2,60)
	W:$L($G(LEXHDR1(1))) !!," ",$G(LEXHDR1(1))
	W:$L($G(LEXHDR1(2))) !," ",$G(LEXHDR1(2))
	W:$L($G(LEXHDR2(1))) !!,"   ",$G(LEXHDR2(1))
	W:$L($G(LEXHDR2(2))) !,"   ",$G(LEXHDR2(2))
	W:$L($G(LEXHDR2(3))) !,"   ",$G(LEXHDR2(3))
	S LEXCDT=$$FMADD^XLFDT($$IMPDATE^LEXU("10D"),3)
	S LEXTD=$$DT^XLFDT S:LEXTD>LEXCDT LEXCDT=LEXTD
	S LEXSAB="10D",LEXSRI=$O(^LEX(757.03,"ASAB",LEXSAB,0))
	Q:+LEXSRI'>0!('$D(^LEX(757.03,+LEXSRI,0))) -1
	S LEXNOM=$P($G(^LEX(757.03,+LEXSRI,0)),"^",2) Q:'$L(LEXNOM) -1
	K LEXA S DIC("A")=" Enter "_LEXNOM_" code or text:  "
	S DIC("S")="I $$SO^LEXU(Y,"""_LEXSAB_""",+($G(LEXCDT)))"
	K ^TMP("LEXFND",$J),^TMP("LEXHIT",$J),^TMP("LEXSCH",$J)
	D CONFIG^LEXSET(LEXSAB,LEXSAB,LEXCDT)
	S ^TMP("LEXSCH",$J,"DIS",0)=LEXSAB
	S ^TMP("LEXSCH",$J,"FIL",0)=DIC("S")
	S DIC(0)="AEQMZ",DIC="^LEX(757.01," K X
	D ^DIC Q:+Y'>0 -1 S X="" I +Y>0 D
	. K LEXA N LEXY,LEXIEN,LEXEX,LEXSO S LEXY=Y,Y=-1,LEXIEN=+LEXY
	. S LEXEX=$P($G(^LEX(757.01,+LEXIEN,0)),"^",1) Q:'$L(LEXEX)
	. S LEXSO=$$SO^LEX10CX5(LEXIEN,LEXSAB,LEXCDT) Q:'$L(LEXSO)
	. S LEXA(1)=LEXIEN_"^"_LEXEX_"^"_LEXSO,LEXA(0)=1,Y=$G(LEXY)
	K ^TMP("LEXFND",$J),^TMP("LEXHIT",$J),^TMP("LEXSCH",$J)
	S X="" S:+($G(LEXA(0)))>0 X=+($G(LEXA(0))) K LEXVDT
	Q X
	;
	; Miscellaneous
EC(X,Y)	;   Expression Code for SAB
	N LEXC,LEXE,LEXN,LEXS,LEXSAB,LEXSRC
	S LEXE=+($G(X)) Q:'$D(^LEX(757.01,+LEXE,0)) ""
	Q:'$D(^LEX(757.02,"B",+LEXE)) ""
	S LEXSAB=$G(Y) Q:'$L(LEXSAB) ""
	S LEXSRC=$O(^LEX(757.03,"ASAB",LEXSAB,0))
	I +LEXSRC'>0,LEXSAB?1N.N D
	. S:$D(^LEX(757.03,+LEXSAB,0)) LEXSRC=+LEXSAB
	Q:+LEXSRC'>0 ""  S LEXC="",LEXS=0
	F  S LEXS=$O(^LEX(757.02,"B",LEXE,LEXS)) Q:+LEXS'>0  D
	. Q:$L(LEXC)  N LEXN S LEXN=$G(^LEX(757.02,+LEXS,0))
	. Q:$P(LEXN,"^",3)'=LEXSRC
	. Q:$P(LEXN,"^",5)'=1  S LEXC=$P(LEXN,"^",2)
	S X=LEXC
	Q X
TM(X,Y)	;   Trim Y
	S X=$G(X),Y=$G(Y) S:'$L(Y) Y=" "
	F  Q:$E(X,1)'=Y  S X=$E(X,2,$L(X))
	F  Q:$E(X,$L(X))'=Y  S X=$E(X,1,($L(X)-1))
	Q X