LEXXFI3	;ISL/KER - File Info - Record Count ;04/21/2014
	;;2.0;LEXICON UTILITY;**32,80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^TMP("LEXCNT")      SACC 2.3.2.5.1
	;               
	; External References
	;    None
	;               
	Q
ONE(X)	; Record Count for a File
	N LEXFI K ^TMP("LEXCNT",$J) S LEXFI=+($G(X)) Q:+X'>0  K LEXMD D CNT(LEXFI),DSP^LEXXFI4
	Q
ALL	; Record Count for a File(s)
	N LEXCTR,LEXEX,LEXFI,LEXLINE,LEXRTN,LEXTAG K ^TMP("LEXCNT",$J)
	S LEXFI="",LEXTAG="FILES",LEXRTN="LEXXFI",LEXCTR=0
	F  D  Q:LEXFI=""
	. S LEXCTR=LEXCTR+1,LEXEX="S LEXLINE=$T("_LEXTAG_"+"_LEXCTR_"^"_LEXRTN_")" X LEXEX
	. S LEXFI=$P(LEXLINE,";;",3) I '$L(LEXFI) K LEXMD D DSP^LEXXFI4 Q
	. Q:'$L(LEXFI)  D CNT(LEXFI)
	Q
CNT(X)	; Count Entries for file X
	N DIC,LEX,LEXCFI,LEXCNT,LEXCRT,LEXEXIT,LEXFF,LEXFI,LEXI,LEXIEN
	N LEXIENS,LEXIND,LEXLS,LEXNCT,LEXOF,LEXOND,LEXPCD,LEXPCE,LEXPCI
	N LEXPCO,LEXPCT,LEXREC,LEXSL
	S LEXFF=$G(X) Q:'$L(LEXFF)  Q:+LEXFF'>0
	D DDI^LEXXFI6(LEXFF,.LEX) Q:'$D(LEX("DD",+LEXFF))
	S LEXFI=$$PAR(+LEXFF) Q:+LEXFI'>0  K LEX
	I '$D(LEX("DD",LEXFI)) D DDI^LEXXFI6(LEXFI,.LEX)
	Q:'$D(LEX("DD",+LEXFI))  Q:'$D(LEX("DIC",+LEXFI,0,"GL"))
	Q:$D(^TMP("LEXCNT",$J,"B",+LEXFI))  S ^TMP("LEXCNT",$J,"B",+LEXFI)=""
	S ^TMP("LEXCNT",$J,"CNT")=+($G(^TMP("LEXCNT",$J,"CNT")))+1
	S (LEXEXIT,LEXNCT,LEXIENS,LEXREC,LEXPCO)=0,DIC=$G(LEX("DIC",+LEXFI,0,"GL"))
	Q:'$L(DIC)  S LEXOND=DIC_"0)",LEXCRT=DIC,LEXOF=$P(@LEXOND,"^",4)
	S:$E(DIC,$L(DIC))="(" LEXCRT=$E(DIC,1,($L(DIC)-1))
	S:$E(DIC,$L(DIC))="," LEXCRT=$E(DIC,1,($L(DIC)-1))_")"
	F  S LEXOND=$Q(@LEXOND) Q:LEXOND=""!(LEXOND'[DIC)  D NODE Q:LEXEXIT
	D:+($O(LEXCNT(0)))>0 SAV
	S:+LEXIENS>0 ^TMP("LEXCNT",$J,"IENS",+LEXFI)=(LEXIENS+1)
	I $D(^TMP("LEXCNT","EXIT")) S LEXEXIT=1 K ^TMP("LEXCNT","EXIT")
	Q
NODE	; Count a Node as a Record?
	;   Do not Count Non-Zero Nodes
	Q:$E(LEXOND,($L(LEXOND)-2),$L(LEXOND))'[",0)"
	;   Do not Count Header Nodes
	I DIC'[",",LEXOND[",0)",$L(LEXOND,",")#2>0 Q
	I DIC[",",LEXOND[",0)",$L(LEXOND,",")#2'>0 Q
	S LEXIND=$P(LEXOND,DIC,2),LEXIEN=$P(LEXIND,",0)",1) S:+LEXIEN=LEXIEN LEXIENS=LEXIENS+1
	;   Do not Count Cross-References (Exit Loop)
	I +($P(LEXIND,",",1))'=$P(LEXIND,",",1) S LEXEXIT=1 Q
	;   Quit if no Sub-Script List
	S LEXSL=$P(LEXIND,")",1) I '$L(LEXSL) S LEXEXIT=1 Q
	; Percent Complete
	S (LEXPCT,LEXPCE)="",LEXPCI=LEXPCO I LEXIENS>0,LEXOF>0 D
	. S LEXPCT=(LEXIENS/LEXOF)*100,LEXPCI=+($P(LEXPCT,".",1)),LEXPCD=+($E($P(LEXPCT,".",2),1,2))
	. S:$L(LEXPCD)=1 LEXPCD=LEXPCD_"0" S:$L(LEXPCD)=1 LEXPCD=LEXPCD_"0" S LEXPCE=LEXPCI_"%"
	S LEXPCO=LEXPCI
	;   List Subscripts
	S LEXNCT=LEXNCT+1 K LEXLS D LS(LEXSL,LEXFI) Q:'$D(LEXLS)
	S LEXCFI=$G(LEXLS("FIL")) Q:+LEXCFI'>0  Q:'$D(LEX("DD",+LEXCFI,0))
	S LEXCNT(+LEXCFI)=+($G(LEXCNT(+LEXCFI)))+1,LEXREC=LEXREC+1
	I LEXREC#10000'>0 S:$D(^TMP("LEXCNT","EXIT")) LEXEXIT=1
	Q
LS(X,Y)	; List Subscripts    X = Subscripts Y = File
	N LEXFI,LEXFLD,LEXI,LEXND,LEXNDI,LEXSB,LEXSF,LEXSFI,LEXSFN,LEXSL
	S LEXSL=X Q:'$L(LEXSL)  S LEXFI=+($G(Y)) Q:+LEXFI'>0  Q:'$D(LEX("DIC",+LEXFI,0,"GL"))
	K LEXLS S LEXLS("CNT")=1 F LEXI=1:1 Q:'$L($P(LEXSL,",",LEXI))  D
	. S LEXSB=$P(LEXSL,",",LEXI) I LEXI#2 D
	. . S LEXLS("DA",0)=+($G(LEXLS("DA",0)))+1,LEXLS("DA",+($G(LEXLS("DA",0))))=LEXSB
	. . S:+LEXSB'=LEXSB LEXLS("CNT")=0 S:LEXSB="0" LEXLS("CNT")=0
	. I '(LEXI#2) D
	. . S LEXLS("ND",0)=+($G(LEXLS("ND",0)))+1,LEXLS("ND",+($G(LEXLS("ND",0))))=LEXSB
	S LEXSF=LEXFI,LEXSFN=0,LEXNDI=0 F  S LEXNDI=$O(LEXLS("ND",LEXNDI)) Q:+LEXNDI=0  D
	. S LEXND=$G(LEXLS("ND",LEXNDI)) Q:'$L(LEXND)
	. S LEXND=$TR(LEXND,"""","") I '$L(LEXND) S LEXSF="ERR" Q
	. I '$O(LEX("DD",+LEXSF,"GL",LEXND,0))>0 S LEXSFN=LEXND
	. Q:'$D(LEX("DD",+LEXSF,"GL",LEXND,0))
	. S LEXFLD=$O(LEX("DD",+LEXSF,"GL",LEXND,0,0)) I +LEXFLD'>0 S LEXSF="ERR" Q
	. S LEXSFI=$G(LEX("DD",+LEXSF,+LEXFLD,0))
	. S LEXSFI=+($P(LEXSFI,"^",2)) I +LEXSFI'>0 S LEXSF="ERR" Q
	. S:$D(LEX("DD",+LEXSFI,0)) LEXSF=+LEXSFI
	S LEXLS("FIL")=LEXSF
	S LEXLS("ND")=LEXSFN
	K:LEXSF="ERR" LEXLS("FIL")
	K:+($G(LEXLS("CNT")))'>0 LEXLS
	I $O(LEXLS("ND"," "),-1)>0,$G(LEXLS("ND",$O(LEXLS("ND"," "),-1)))'="0" K LEXLS
	Q
SAV	; Save Counts in ^TMP("LEXCNT",$J)
	N LEXGRND,LEXID,LEXFI,LEXLVL,LEXNAM,LEXPAR,LECTITL,LEXTOT,LEXTYP
	S LEXFI=0 F  S LEXFI=$O(LEXCNT(LEXFI)) Q:+LEXFI=0  D
	. N LEXNAM,LEXTITL,LEXTOT,LEXTYP
	. S LEXNAM=$O(LEX("DD",LEXFI,0,"NM","")) Q:'$L(LEXNAM)
	. S LEXPAR=$$PAR(+LEXFI) Q:+LEXPAR=0  Q:'$D(LEX("DIC",+LEXPAR,0,"GL"))
	. S LEXTOT=+($G(LEXCNT(LEXFI))),LEXGRND=+($G(LEXGRND))+LEXTOT
	. S LEXTYP=$S($D(LEX("DD",+LEXFI))&('$D(LEX("DIC",+LEXFI))):"Sub-File",1:"File")
	. S LEXTITL=LEXTYP_" #"_LEXFI,^TMP("LEXCNT",$J,LEXPAR,0)=LEXGRND
	. S ^TMP("LEXCNT",$J,LEXPAR,LEXFI)=LEXTOT_"^"_LEXNAM_"^"_LEXTITL
	. S LEXID=$$ID(LEXFI),LEXLVL=$$LVL(LEXFI)
	. S:$L(LEXID) ^TMP("LEXCNT",$J,"ORDER",+LEXPAR,(LEXID_";"))=LEXPAR_"^"_LEXFI_"^"_LEXLVL
	. S:'$D(^TMP("LEXCNT",$J,"LVL")) ^TMP("LEXCNT",$J,"LVL")=1
	. S:'$D(^TMP("LEXCNT",$J,"HSF")) ^TMP("LEXCNT",$J,"HSF")=0
	. S:'$D(^TMP("LEXCNT",$J,"SUB")) ^TMP("LEXCNT",$J,"SUB")=0
	. S:+LEXLVL>+($G(^TMP("LEXCNT",$J,"LVL"))) ^TMP("LEXCNT",$J,"LVL")=+LEXLVL
	. S:$L((LEXID_";"),";")>2 ^TMP("LEXCNT",$J,"HSF")=1
	. S:$L((LEXID_";"),";")>2 ^TMP("LEXCNT",$J,"SUB")=+($G(^TMP("LEXCNT",$J,"SUB")))+1
	. S LEXID=$P(LEXID,";",1) S:$L(LEXID) LEXID=LEXID_";~;"
	. S:$L(LEXID) ^TMP("LEXCNT",$J,"ORDER",+LEXPAR,(LEXID_";"))=LEXPAR_"^0^0"
	Q
PAR(X)	; Parent File        X = File/Sub-File Number
	N LEXPAR,LEXSUB S LEXSUB=$G(X)  Q:+LEXSUB'>0 ""
	I '$D(LEX("DD",+LEXSUB)) D DDI^LEXXFI6(+LEXSUB,.LEX)
	Q:'$D(LEX("DD",+LEXSUB,0)) ""  I '$D(LEX("DD",+LEXSUB,0,"UP")) S X=LEXSUB Q X
	S LEXPAR=LEXSUB F  Q:('$D(LEX("DD",+LEXSUB,0,"UP")))  D
	. S (LEXSUB,LEXPAR)=$G(LEX("DD",+LEXSUB,0,"UP"))
	S X=LEXPAR
	Q X
LVL(X)	; Level of File      X = File/Sub-File Number
	N LEXLVL,LEXPAR,LEXSUB S LEXSUB=$G(X)  Q:+LEXSUB'>0 0
	I '$D(LEX("DD",+LEXSUB)) D DDI^LEXXFI6(+LEXSUB,.LEX)
	Q:'$D(LEX("DD",+LEXSUB,0)) 0  Q:'$D(LEX("DD",+LEXSUB,0,"UP")) 1
	S LEXLVL=1,LEXPAR=LEXSUB F  Q:('$D(LEX("DD",+LEXSUB,0,"UP")))  D
	. S (LEXSUB,LEXPAR)=$G(LEX("DD",+LEXSUB,0,"UP")),LEXLVL=LEXLVL+1
	S X=LEXLVL Q X
ID(X)	; Unique Identifier  X = File/Sub-File Number
	N LEXID,LEXPAR,LEXSUB S LEXID="",LEXSUB=$G(X)  Q:+LEXSUB'>0 ""
	I '$D(LEX("DD",+LEXSUB)) D DDI^LEXXFI6(+LEXSUB,.LEX)
	Q:'$D(LEX("DD",+LEXSUB,0)) ""  Q:'$D(LEX("DD",+LEXSUB,0,"UP")) +LEXSUB
	S LEXID=+LEXSUB,LEXPAR=LEXSUB F  Q:('$D(LEX("DD",+LEXSUB,0,"UP")))  D
	. S (LEXSUB,LEXPAR)=$G(LEX("DD",+LEXSUB,0,"UP"))
	. S:$L(LEXSUB) LEXID=LEXSUB_";"_LEXID
	S X=LEXID
	Q X