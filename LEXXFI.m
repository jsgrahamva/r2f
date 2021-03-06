LEXXFI	;ISL/KER - File Info ;04/21/2014
	;;2.0;LEXICON UTILITY;**32,46,49,41,59,73,80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^LEXM(0)            N/A
	;    ^TMP("LEX*",$J)     SACC 2.3.2.5.1
	;    ^TMP("LEXCNT")      SACC 2.3.2.5.1
	;    ^TMP("LEXCS")       SACC 2.3.2.5.1
	;    ^TMP("LEXI")        SACC 2.3.2.5.1
	;    ^TMP("LEXINS")      SACC 2.3.2.5.1
	;    ^TMP("LEXKID")      SACC 2.3.2.5.1
	;    ^TMP("LEXMSG")      SACC 2.3.2.5.1
	;               
	; External References
	;    $$DTIME^XUP         ICR   4409
	;    $$DT^XLFDT          ICR  10103
	;    $$FMTE^XLFDT        ICR  10103
	;    $$GET1^DIQ          ICR   2056
	;    $$NOW^XLFDT         ICR  10103
	;    HOME^%ZIS           ICR  10086
	;    ^%ZISC              ICR  10089
	;    ^%ZTLOAD            ICR  10063
	;    ^XMD                ICR  10070
	;               
	; Newed by Post-Install LEX20nnP
	;   LEXBUILD  Build
	;   LEXCRE    Import Global Creation Date
	;   LEXIGHF   Import Global Host File
	;   LEXLREV   Revision
	;   LEXREQP   Required Patches
	;   LEXSHORT  Flag for Summary Install Message
	;
	; Newed by Post-Install LEXXGI
	;   LEXPROC   Protocol Name
	;   LEXRES    Install Results
	;   LEXSTART  Install Start Time
	;   
	; Other
	;   XPDA      Newed by KIDS during Install
	;   LEXCOUNT  Flag Checked $D() and not used
	;
	Q
	; Checksums/Counts
EN	;   For One or More File(s)
	N LEXENV,LEXMET,LEXID
	S LEXENV=$$ENV
	Q:+LEXENV'>0
	S LEXMET=$$MT^LEXXFI7
	I '$L(LEXMET) W !!," Checksum Files (One or All) not Selected" Q
	I $L($T(@(LEXMET_"^LEXXFI")))>0 W ! D @LEXMET
	Q
ONE	;   For ONE file
	K ^TMP("LEXCS",$J),^TMP("LEXCNT",$J),^TMP("LEXI",$J),^TMP("LEXMSG",$J)
	N LEXBEG,LEXELP,LEXEND,LEXFC,LEXFI,LEXLDR,LEXMOD,LEXMUL,LEXNM,LEXTCS
	N LEXTND,LEXTT,LEXTXT
	S LEXBEG=$$TIC^LEXXFI8,LEXMUL=0,LEXMOD=0
	S LEXFI=$$FI^LEXXFI7 I +LEXFI'>0 W !!," Checksum File not Selected" Q
	S LEXLDR=$$LDR^LEXXFI8(LEXFI),LEXMOD=LEXMOD+($$MOD^LEXXFI8(LEXFI))
	S LEXNM=$$FN^LEXXFI8(LEXFI),LEXTT=" "
	W !
	D ONE^LEXXFI2(LEXFI),ONE^LEXXFI3(LEXFI),ONE^LEXXFI5(LEXFI)
	S LEXEND=$$TIC^LEXXFI8,LEXELP=$$ELAP^LEXXFI8(LEXBEG,LEXEND)
	S:LEXELP="" LEXELP="00:00:00"
	I +LEXBEG>0,LEXEND>0,$L(LEXELP) D TIM
	K ^TMP("LEXCS",$J),^TMP("LEXCNT",$J),^TMP("LEXI",$J),^TMP("LEXMSG",$J)
	Q
ALL	;   For ALL files
	K ^TMP("LEXCS",$J),^TMP("LEXCNT",$J),^TMP("LEXI",$J),^TMP("LEXMSG",$J)
	K ^TMP("LEXINS",$J),^TMP("LEXKID",$J) S:$D(ZTQUEUED) ZTREQ="@"
	N LEXBEG,LEXELP,LEXEND,LEXFC,LEXMOD,LEXMUL,LEXTCS,LEXTND,LEXID
	S LEXID="LEXKID",LEXBEG=$$TIC^LEXXFI8,LEXMUL=1,(LEXTND,LEXTCS,LEXMOD,LEXFC)=0
	D:'$D(LEXPOST) HDR
	I '$D(LEXSHORT) D ALL^LEXXFI5,ALL^LEXXFI2,ALL^LEXXFI3
	S LEXEND=$$TIC^LEXXFI8 S LEXELP=$$ELAP^LEXXFI8(LEXBEG,LEXEND)
	S:LEXELP="" LEXELP="00:00:00"
	I +LEXBEG>0,LEXEND>0,$L(LEXELP) D TIM
	D:$D(LEXSEND)!($D(LEXPOST)) EN^LEXXII K ^LEXM(0,"PRO") D:$D(ZTQUEUED) MAIL
	I '$D(ZTQUEUED) D
	. N LEXI S LEXI=0 F  S LEXI=$O(^TMP("LEXKID",$J,LEXI)) Q:+LEXI=0  D
	. . W !,$E($G(^TMP("LEXKID",$J,LEXI)),1,79)
	D KILL
	Q
	;
POST	; Entry Point for Post-Install Message
	N LEXPOST S LEXPOST=""
	;
SEND	; Send Message
	N LEXDESC,LEXENV,LEXP,LEXACCT,LEXPRO,LEXPRON,LEXSEND,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK,ZTQUEUED,ZTREQ
	S LEXP=0,LEXENV=$$ENV Q:+LEXENV'>0  S LEXSEND="",LEXPRON="LEXICAL SERVICES UPDATE",LEXPRO=$G(^LEXM(0,"PRO"))
	S:+LEXPRO>0 LEXPRO=$$FMTE^XLFDT(LEXPRO,"1"),LEXP=1
	S LEXACCT=$$U^LEXXFI7 S ZTSAVE("LEXACCT")=""
	S ZTRTN="ALL^LEXXFI",ZTSAVE("LEXSEND")="",ZTSAVE("LEXPOST")=""
	S:$D(LEXCOUNT) ZTSAVE("LEXCOUNT")=""
	I $L($G(LEXPRO)),$L($G(LEXPRON)),+$G(LEXP)>0 S ZTSAVE("LEXPRO")="",ZTSAVE("LEXPRON")=""
	S:$D(LEXPROC)&($O(LEXPROC(0))>0) ZTSAVE("LEXPROC(")=""
	S:$D(LEXLREV) ZTSAVE("LEXLREV")=""
	S:$D(LEXREQP) ZTSAVE("LEXREQP")=""
	S:$L($G(LEXSUBH)) ZTSAVE("LEXSUBH")=""
	S:$D(LEXPTYPE) ZTSAVE("LEXPTYPE")=""
	S:$D(LEXBUILD) ZTSAVE("LEXBUILD")=""
	S:$D(LEXSHORT) ZTSAVE("LEXSHORT")=""
	S:$D(LEXIGHF) ZTSAVE("LEXIGHF")=""
	S:$D(LEXCRE) ZTSAVE("LEXCRE")=""
	S:$D(LEXSTART) ZTSAVE("LEXSTART")=""
	S:$D(LEXID) ZTSAVE("LEXID")=""
	S:$D(LEXRES) ZTSAVE("LEXRES")=""
	S:$D(XPDA) ZTSAVE("XPDA")=""
	S (LEXDESC,ZTDESC)="Post-Install File Counts "
	S:$D(LEXSHORT) (LEXDESC,ZTDESC)="Post-Install Summary"
	S ZTDTH=$H,ZTIO=""
	D ^%ZTLOAD
	W:+($G(ZTSK))>0 !!,"  ",LEXDESC,!,"  Queued Task #",+($G(ZTSK)) W !
	D ^%ZISC
	Q
MAIL	; Mail global array in message
	N DIFROM,LEXPRI,LEXADR,LEXI,LEXM,LEXSUB,XCNP,XMDUZ,XMSCR,XMSUB,XMTEXT,XMY,XMZ
	I '$D(LEXSHORT),+$G(^TMP("LEXCS",$J,0))'>0 G MAILQ
	K ^TMP("LEXMSG",$J)
	S LEXSUB="Lexicon/ICD/CPT Installation"
	S:$L($G(LEXBUILD)) LEXSUB=$G(LEXBUILD)_" Installation"
	S LEXPRI=$$ADR^LEXXFI8
	G:'$L(LEXPRI) MAILQ
	S LEXPRI="G.LEXINS@"_LEXPRI
	S LEXADR=$$GET1^DIQ(200,+($G(DUZ)),.01)
	G:'$L(LEXADR) MAILQ
	S U="^",XMSUB="LEX/ICD/CPT File Checksums - "_$$FMTE^XLFDT($$NOW^XLFDT)
	S:$D(LEXCOUNT) XMSUB="LEX/ICD/CPT File Checksums/Counts - "_$$FMTE^XLFDT($$NOW^XLFDT)
	S:$L($G(LEXBUILD)) XMSUB=$G(LEXBUILD)_" File Checksums"
	I $L($G(LEXBUILD)),$D(LEXCOUNT) S XMSUB=$G(LEXBUILD)_" File Checksums/Counts"
	S:$D(LEXPOST) XMSUB=LEXSUB
	S LEXI=0 F  S LEXI=$O(^TMP("LEXKID",$J,LEXI)) Q:+LEXI=0  D
	. S LEXM=+($O(^TMP("LEXMSG",$J," "),-1))+1
	. S ^TMP("LEXMSG",$J,LEXM,0)=$E($G(^TMP("LEXKID",$J,LEXI)),1,79)
	. S ^TMP("LEXMSG",$J,0)=LEXM
	K ^TMP("LEXKID",$J)
	I '$D(LEXSHORT) S LEXI=0 F  S LEXI=$O(^TMP("LEXCS",$J,LEXI)) Q:+LEXI=0  D
	. S LEXM=+($O(^TMP("LEXMSG",$J," "),-1))+1
	. S ^TMP("LEXMSG",$J,LEXM,0)=$E($G(^TMP("LEXCS",$J,LEXI)),1,79)
	. S ^TMP("LEXMSG",$J,0)=LEXM
	K ^TMP("LEXCS",$J) G:'$D(^TMP("LEXMSG",$J)) MAILQ G:+($G(^TMP("LEXMSG",$J,0)))'>0 MAILQ
	S XMY(LEXPRI)="",XMY(LEXADR)="",XMTEXT="^TMP(""LEXMSG"",$J,",XMDUZ=.5 D ^XMD
MAILQ	; Quit Mail
	D KILL K XCNP,XMSCR,XMDUZ,XMY,XMZ,XMSUB,XMY,XMTEXT,XMDUZ
	Q
	;
	; Miscellaneous
HDR	;   Header
	N LEXD,LEXP,LEXN,LEXT,LEXU,LEXA,LEXACT,LEXI,LEXF,LEXMUL S LEXF=0 S LEXACT=$G(LEXACCT),LEXA=""
	S:$L($P(LEXACT,"^",1))&($L($P(LEXACT,"^",1))) LEXA=LEXACT
	S:'$L($G(LEXA)) LEXA=$$U^LEXXFI7 S LEXU=$$P^LEXXFI7,LEXD=$$A^LEXXFI7 D TT^LEXXFI8("","Status")
	S LEXT="" S:$L(LEXD) LEXT="   As of:       "_LEXD
	I $L(LEXD) D:+LEXF'>0 BL^LEXXFI8 D TL^LEXXFI8(LEXT) S LEXF=1
	S LEXT="",LEXI=$S($L($P(LEXA,"^",1)):"[",1:"")_$P(LEXA,"^",1)_$S($L($P(LEXA,"^",2)):"]",1:"")
	I $L($P(LEXA,",",1))>3,$L($P(LEXA,"^",2)) S LEXI="["_$P(LEXA,",",1)_"]"
	S:$L(LEXI)&($L($P(LEXA,"^",2))) LEXI=LEXI_"  "_$P(LEXA,"^",2)
	S LEXT="" S:$L(LEXI) LEXT="   In Account:  "_LEXI
	I $L(LEXT) D:+LEXF'>0 BL^LEXXFI8 D TL^LEXXFI8(LEXT) S LEXF=1
	S LEXN=$P(LEXU,"^",1),LEXP=$P(LEXU,"^",2)
	S LEXT="" S:$L(LEXN) LEXT="   Maint By:    "
	S:$L(LEXN) LEXT=LEXT_LEXN S:$L(LEXP)&($L(LEXN)) LEXT=LEXT_"   "_LEXP
	I $L(LEXT) D:+LEXF'>0 BL^LEXXFI8 D TL^LEXXFI8(LEXT) S LEXF=1
	S LEXT="" S:$L($G(LEXBUILD)) LEXT="   Build:       "_$G(LEXBUILD)
	I $L(LEXT) D:+LEXF'>0 BL^LEXXFI8 D TL^LEXXFI8(LEXT) S LEXF=1
	S LEXT="" I $L($G(LEXPRO))&($L($G(LEXPRON))) D
	. S LEXT="   Protocol:    "_LEXPRON_" invoked "_LEXPRO
	. I $L(LEXT) D:+LEXF'>0 BL^LEXXFI8 D TL^LEXXFI8(LEXT) S LEXF=1
	D BL^LEXXFI8
	Q
TIM	;   Time
	Q:$D(LEXPOST)  Q:+($G(LEXBEG))'>0  Q:+($G(LEXEND))'>0  Q:'$L($G(LEXELP))
	D BL^LEXXFI8,TL^LEXXFI8(("   Started:   "_$TR($$FMTE^XLFDT(LEXBEG),"@"," ")))
	D TL^LEXXFI8(("   Finished:  "_$TR($$FMTE^XLFDT(LEXEND),"@"," ")))
	D TL^LEXXFI8(("   Elapsed:   "_LEXELP)),BL^LEXXFI8
	Q
ENV(X)	;   Environment check
	N LEXNM D HOME^%ZIS S U="^",DT=$$DT^XLFDT
	I +($G(DUZ))'>0 W !!,"    User (DUZ) not defined",! Q 0
	S LEXNM=$$GET1^DIQ(200,+($G(DUZ)),.01)
	I '$L(LEXNM) W !!,"    Invalid User (DUZ) defined",! Q 0
	S DTIME=$$DTIME^XUP(+($G(DUZ)))
	Q 1
CLR	;   Clear ^TMP("LEXCS",$J)
	K ^TMP("LEXCS",$J) N LEXBUILD,LEXCOUNT,LEXCRE,LEXIGHF,LEXLREV
	N LEXPROC,LEXREQP,LEXRES,LEXSHORT,LEXSTART,XPDA
	Q
KILL	;   Kill all ^TMP("LEX**"
	K ^TMP("LEXCNT",$J),^TMP("LEXCS",$J),^TMP("LEXI",$J)
	K ^TMP("LEXINS",$J),^TMP("LEXMSG",$J),^TMP("LEXKID",$J)
	Q
	;;
	;;
FILES	;;
	;;;;757
	;;1;;757.001
	;;1;;757.01
	;;;;757.011
	;;;;757.014
	;;;;757.02
	;;;;757.03
	;;1;;757.04
	;;1;;757.05
	;;1;;757.06
	;;;;757.1
	;;;;757.11
	;;;;757.12
	;;;;757.13
	;;;;757.14
	;;1;;757.2
	;;1;;757.21
	;;;;757.3
	;;;;757.31
	;;1;;757.4
	;;1;;757.41
	;;;;80
	;;;;80.1
	;;;;80.3
	;;;;81
	;;;;81.1
	;;1;;81.2
	;;;;81.3
	;;
	;;
	;;
	Q
