LEXQL3	;ISL/KER - Query - Lookup ICD Code ;04/21/2014
	;;2.0;LEXICON UTILITY;**62,80**;Sep 23, 1996;Build 1
	;               
	;               
	; Global Variables
	;    ^ICD0("BA"          ICR   4486
	;    ^ICD9("BA"          ICR   4485
	;    ^TMP(               SACC 2.3.2.5.1
	;    ^TMP("LEXQL")       SACC 2.3.2.5.1
	;               
	; External References
	;    $$FILE^ICDEX        ICR   5747
	;    $$ICDDX^ICDEX       ICR   5747
	;    $$ICDOP^ICDEX       ICR   5747
	;    $$LEXFI^ICDEX       ICR   5747
	;    $$LKTX^ICDEX        ICR   5747
	;    $$ROOT^ICDEX        ICR   5747
	;    $$DT^XLFDT          ICR  10103
	;    $$UP^XLFSTR         ICR  10104
	;               
ICD(X,Y)	;
	; 
	; Input
	; 
	;   X       User input, Uppercase
	;   Y       ICD Coding System (1, 2, 30, 31)
	; 
	; Output
	; 
	;   TMP Global Array
	;   
	;           ^TMP("LEXQL",$J,"ADDLIST",ID)=LEXIEN_U_Menu Text
	;
	N LEXSUB,LEXRT,LEXFI,LEXINP,LEXVER,LEXCDT,LEXOUT,LEXPIE,LEXENT,LEXINP,LEXSYS,LEXTD
	S LEXINP=$$VI($G(X)) Q:'$L(LEXINP)  S LEXSYS=+($G(Y)) Q:LEXSYS'?1N.N  S LEXTD=$$DT^XLFDT
	S LEXRT=$$ROOT^ICDEX(LEXSYS),LEXFI=$$FILE^ICDEX(LEXRT)
	I +LEXFI'>0 S LEXFI=$$FILE^ICDEX(LEXS),LEXRT=$$ROOT^ICDEX(LEXFI)
	S LEXPIE=$S((LEXSYS=1)!(LEXSYS=30):4,(LEXSYS=2)!(LEXSYS=31):5,1:"") Q:LEXPIE'?1N
	Q:+LEXFI'>0  Q:'$L(LEXRT)  Q:+LEXSYS'>0  S LEXSUB=$TR(LEXRT,"^(","")
	S LEXVER=0,LEXOUT=1,LEXCDT="" Q:'$L(LEXSUB)  K:$L($G(LEXSUB)) ^TMP(LEXSUB,$J)
	K ICDBYCD S X=$$LKTX^ICDEX(LEXINP,LEXRT,,LEXSYS,LEXVER,LEXOUT)
	Q:+X'>0  S LEXENT=0 F  S LEXENT=$O(^TMP(LEXSUB,$J,"SEL",LEXENT)) Q:+LEXENT'>0  D
	. N LEXITEM,LEXIEN,LEXOK,LEXT,LEXD,LEXC,LEXD,LEXN,LEXS,LEXE,LEXDS,LEXTN,LEXTS,LEXSS,LEXDT
	. S LEXITEM=$G(^TMP(LEXSUB,$J,"SEL",LEXENT)),LEXIEN=+LEXITEM,LEXD=$G(LEXVDT) S:LEXD'?7N LEXD=$G(LEXTD)
	. S:LEXPIE=4 LEXT=$$ICDDX^ICDEX(LEXIEN,LEXD,LEXSYS,"I") S:LEXPIE=5 LEXT=$$ICDOP^ICDEX(LEXIEN,LEXD,LEXSYS,"I")
	. S LEXC=$P(LEXT,U,2) Q:'$L(LEXC)  S LEXN=$$UP^XLFSTR($P(LEXT,U,LEXPIE)),LEXS=$P(LEXT,U,10)
	. Q:'$L(LEXC)  Q:'$L(LEXN)  Q:'$L(LEXS)  S:+LEXS'>0 LEXE=$P(LEXT,U,12)
	. S:LEXPIE=4&(+LEXS>0) LEXE=$P(LEXT,U,17) S:LEXPIE=5&(+LEXS>0) LEXE=$P(LEXT,U,13)
	. S LEXTS=$$STY^LEXQL2(LEXC),LEXTN=+LEXTS,LEXTS=$P(LEXTS,U,2) Q:'$L(LEXTS)
	. S LEXSS="" S:+LEXS'>0&($L($G(LEXE))) LEXSS="(Inactive)" S LEXDS=LEXN S:$L(LEXSS)&(LEXDS'[LEXSS) LEXDS=LEXDS_" "_LEXSS
	. S LEXDT=LEXC,LEXDT=LEXDT_$J(" ",(8-$L(LEXDT)))_LEXDS S:$L(LEXTS) LEXDT=LEXDT_" ("_LEXTS_")"
	. S ^TMP("LEXQL",$J,"ADDLIST",(LEXTN_" "_LEXC_" "))=LEXIEN_U_$$FT^LEXQL2(LEXC,LEXN,$TR(LEXSS,"()",""))
	. S ^TMP("LEXQL",$J,"ADDLIST",(LEXTN_" "_LEXC_" "),2)=LEXIEN_U_$$FC^LEXQL2(LEXC,LEXN,$TR(LEXSS,"()",""))
	K ^TMP(LEXSUB,$J) N LEXVDT
	Q
VI(X)	;   Verify Input
	N LEX,LEXIO,LEXIC,LEXUC,LEXUO S LEX=$G(X) Q:'$L(LEX) ""  Q:$L(LEX)'>1 $$UP^XLFSTR(LEX)
	S LEXIC=$G(LEX),LEXIO=$E(LEX,1,($L(LEX)-1))_$C(($A($E(LEX,$L(LEX)))-1))_"~ "
	S LEXUC=$$UP^XLFSTR(LEXIC),LEXUO=$$UP^XLFSTR(LEXIO)
	; 80 ICD-9/10
	I $E($O(^ICD9("BA",LEXIO)),1,$L(LEXIC))=LEXIC Q LEXIC
	I $E($O(^ICD9("BA",LEXUO)),1,$L(LEXUC))=LEXUC Q LEXUC
	; 80.1 ICD-9.10
	I $E($O(^ICD0("BA",LEXIO)),1,$L(LEXIC))=LEXIC Q LEXIC
	I $E($O(^ICD0("BA",LEXUO)),1,$L(LEXUC))=LEXUC Q LEXUC
	Q LEX
