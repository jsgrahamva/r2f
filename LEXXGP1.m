LEXXGP1	;ISL/KER - Global Post-Install (Repair Expressions) ;12/19/2014
	;;2.0;LEXICON UTILITY;**80,86**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^TMP("LEXASL")      SACC 2.3.2.5.1
	;    ^TMP("LEXASLU")     SACC 2.3.2.5.1
	;    ^TMP("LEXAWRD")     SACC 2.3.2.5.1
	;    ^TMP("LEXAWRDK")    SACC 2.3.2.5.1
	;    ^TMP("LEXAWRDU")    SACC 2.3.2.5.1
	;    ^TMP("LEXSUB")      SACC 2.3.2.5.1
	;    ^TMP("LEXTKN")      SACC 2.3.2.5.1
	;    ^TMP("LEXXGPDAT")   SACC 2.3.2.5.1
	;    ^TMP("LEXXGPMSG")   SACC 2.3.2.5.1
	;    ^TMP("LEXXGPRPT")   SACC 2.3.2.5.1
	;    ^TMP("LEXXGPTIM")   SACC 2.3.2.5.1
	;               
	; External References
	;    HOME^%ZIS           ICR  10086
	;    $$S^%ZTLOAD         ICR  10063
	;    ^%ZTLOAD            ICR  10063
	;    $$FMDIFF^XLFDT      ICR  10103
	;    $$FMTE^XLFDT        ICR  10103
	;    $$NOW^XLFDT         ICR  10103
	;    $$UP^XLFSTR         ICR  10104
	;    MES^XPDUTL          ICR  10141
	;               
	; Local Variables NEWed or KILLed Elsewhere
	; 
	;    LEXMAIL   Set and Killed by the developer, used to 
	;              report the timing of the task and
	;              send to the user by MailMan message
	;     
	;    LEXHOME   Set and Killed by the developer in the
	;              post-install, used to send the timing
	;              message to G.LEXINS@FO-SLCDOMAIN.EXT
	;              (see entry point POST2)
	;              
	;                     FileMan           LEXXGP
	;                 
	;                        Lexicon           Lexicon
	; Re-Index        Time  Available   Time  Available
	; --------------  ----  ---------   ----  ---------
	; Build 'AWRD'    33.5     No       8.5      Yes
	; Replace 'AWRD'   --      --       2.5      No
	; Build 'ASL'      8.5     No       6.5      Yes
	; Replace 'ASL'    --      --       0.5      No
	; Build 'ASUB'    15.5     No      11.5      Yes
	; Replace 'ASUB'   --      --       1.5      No
	; 
	; Lexicon 
	; Unavailable:    57.5              4.5 Minutes
	; 
	Q
EN	; Interactive Entry Point
	D ALL
	Q
POST	; Entry Point from Post-Install
	N LEXMAIL,LEXHOME S LEXMAIL="" D POST3
	Q
POST2	; Entry Point from Post-Install (home)
	N LEXMAIL,LEXHOME S LEXHOME="",LEXMAIL="" D POST3
	Q
POST3	; Called by POST/POST2 starts task
	N Y,ZTRTN,ZTDESC,ZTIO,ZTDTH,ZTSAVE,ZTQUEUED,ZTREQ,LEXTN
	S ZTRTN="ALL^LEXXGP1"
	S (LEXTN,ZTDESC)="Repair indexes in files #757.01/757.21"
	I $D(LEXMAIL) S LEXMAIL=1,ZTSAVE("LEXMAIL")=""
	I $D(LEXHOME) S LEXHOME=1,ZTSAVE("LEXHOME")=""
	S ZTIO="",ZTDTH=$H D ^%ZTLOAD,HOME^%ZIS I $D(LEXLOUD) D
	. S LEXT="  "_$G(LEXTN)_" tasked"
	. S:+($G(ZTSK))>0 LEXT=LEXT_" (#"_+($G(ZTSK))_")"
	. D MES^XPDUTL(LEXT)
	K ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
	Q
ALL	; Index all Lookup Indexes
	S:$D(ZTQUEUED) ZTREQ="@"
	K ^TMP("LEXAWRD",$J),^TMP("LEXAWRDU",$J),^TMP("LEXAWRDK",$J),^TMP("LEXASL",$J),^TMP("LEXASLU",$J),^TMP("LEXSUB",$J)
	K ^TMP("LEXXGPTIM",$J) N DIC,DTOUT,DUOUT,LEX,LEX1,LEX2,LEX3,LEX4,LEXB,LEXBD,LEXBEG,LEXBEGD,LEXBEGT,LEXBT,LEXC,LEXCHR
	N LEXCHRS,LEXCMD,LEXCOM,LEXCTL,LEXD,LEXDF,LEXE,LEXEL,LEXELP,LEXELPT,LEXEND,LEXENDD,LEXENDT,LEXET,LEXEX,LEXEXP,LEXF
	N LEXFC,LEXFIR,LEXFUL,LEXHDR,LEXI,LEXID,LEXIDS,LEXIDX,LEXINAM,LEXIT,LEXJ,LEXLAST,LEXLN,LEXLOOK,LEXLOUD,LEXLWRD,LEXM
	N LEXMC,LEXMCEI,LEXMCI,LEXN,LEXNAM,LEXNEW,LEXNM,LEXNOD,LEXO,LEXO1,LEXO2,LEXP,LEXPDT,LEXPRE,LEXRI,LEXRT,LEXRT1,LEXRT2
	N LEXS,LEXSI,LEXSUB,LEXT,LEXTDAT,LEXTEXP,LEXTK,LEXTKC,LEXTKN,LEXTMP,LEXTWRD,LEXTX,LEXTXT,LEXV,LEXX,X,XCNP,XMDUZ
	N XMSCR,XMSUB,XMTEXT,XMY,XMZ,Y S:'$D(LEXQUIT) LEXQUIT="ALL" N LEXTXT,LEXFUL S LEXFUL="" D EXP,SUB^LEXXGP3
	I '$D(ZTQUEUED) D
	. N LEXTXT S LEXTXT=$$FMTT Q:'$L(LEXTXT)  W !," ",LEXTXT
	I $G(LEXQUIT)="ALL" D
	. D:$D(LEXMAIL) XM^LEXXGP3 K LEXQUIT,ZTQUEUED,LEXMAIL,LEXHOME I '$D(LEXTEST) D
	. . K ^TMP("LEXASL",$J),^TMP("LEXASLU",$J),^TMP("LEXAWRD",$J),^TMP("LEXAWRDU",$J),^TMP("LEXAWRDK",$J)
	. . K ^TMP("LEXSUB",$J),^TMP("LEXTKN",$J),^TMP("LEXXGPDAT",$J),^TMP("LEXXGPTIM",$J),^TMP("LEXXGPRPT",$J)
	. . K:'$D(LEXMAIL) ^TMP("LEXXGPMSG",$J) N ZTQUEUED,LEXTEST
	Q
	;
EXP	; Expression file Main Indexes AWRD/ASL
	N LEXBEG,LEXBEGD,LEXBEGT,LEXDF,LEXELP,LEXEND,LEXENDD,LEXENDT
	N LEXTMP,LEXTXT S LEXTXT="Expression Indexes"
	S:'$D(LEXQUIT) LEXQUIT="EXP" K ^TMP("LEXAWRD",$J),^TMP("LEXAWRDU",$J),^TMP("LEXAWRDK",$J)
	K ^TMP("LEXASL",$J),^TMP("LEXASLU",$J) S LEXBEG=$$BEG
	D AWRDB,ASLB^LEXXGP2 H 1 S LEXEND=$$END D SAV^LEXXGP3(LEXBEG,LEXEND,LEXTXT)
	S LEXELP=$$ELP(LEXBEG,LEXEND),LEXBEGD=$$ED(LEXBEG)
	S LEXBEGT=$$ET(LEXBEG),LEXENDT=$$ET(LEXEND),LEXDF=$$DF(LEXBEG)
	S LEXTXT=$G(LEXTXT)_$J(" ",(35-$L($G(LEXTXT))))
	S LEXTXT=LEXTXT_LEXDF_"   "_LEXBEGT_"   "_LEXENDT_"   "_LEXELP
	S LEXTXT=" "_LEXTXT W:'$D(ZTQUEUED) !,LEXTXT
	I $G(LEXQUIT)="EXP" D
	. D:$D(LEXMAIL) XM^LEXXGP3 K LEXQUIT,ZTQUEUED,LEXMAIL,LEXHOME I '$D(LEXTEST) D
	. . K ^TMP("LEXASL",$J),^TMP("LEXASLU",$J),^TMP("LEXAWRD",$J),^TMP("LEXAWRDU",$J),^TMP("LEXAWRDK",$J)
	. . K ^TMP("LEXTKN",$J),^TMP("LEXXGPDAT",$J),^TMP("LEXXGPTIM",$J),^TMP("LEXXGPRPT",$J)
	. . K:'$D(LEXMAIL) ^TMP("LEXXGPMSG",$J) N ZTQUEUED,LEXTEST
	Q
AWRDB	;   AWRD Word Index Build                         8.5 minutes
	;     Create the AWRD Index in the ^TMP global
	N LEX0P3,LEX0P4,LEXBEG,LEXBEGD,LEXBEGT,LEXCHK,LEXDF,LEXELP,LEXEND,LEXENDT,LEXEX
	N LEXEXP,LEXIDX,LEXMC,LEXMCEI,LEXMCI,LEXND,LEXRI,LEXSI,LEXTKC,LEXTKN,LEXTMP,LEXTXT
	K ^TMP("LEXAWRD",$J),^TMP("LEXAWRDU",$J),^TMP("LEXAWRDK",$J) S:'$D(LEXQUIT) LEXQUIT="AWRDB"
	S LEXBEG=$$BEG,LEXEX=0,LEXTXT="Build 'AWRD' Word Index"
	I +($G(ZTSK))>0 S LEXCHK=$$S^%ZTLOAD((LEXTXT_" in file 757.01"))
	S LEXEX=0 F  S LEXEX=$O(^LEX(757.01,LEXEX)) Q:+LEXEX'>0  D
	. N X,LEXEXP,LEXIDX,LEXMC,LEXMCI,LEXMCEI,LEXRI,LEXSI,LEXTKN,LEXTKC,LEXTMP
	. S LEX0P3=+LEXEX,LEX0P4=+($G(LEX0P4))+1
	. S LEXEXP=$$UP^XLFSTR($G(^LEX(757.01,LEXEX,0))) Q:'$L(LEXEXP)
	. S LEXMCI=$P($G(^LEX(757.01,LEXEX,1)),"^",1) Q:+LEXMCI'>0
	. S LEXMCEI=$P($G(^LEX(757,LEXMCI,0)),"^",1) Q:+LEXMCEI'>0
	. ;       Words (main)
	. K ^TMP("LEXTKN",$J) S LEXIDX="",X=LEXEXP D PTX^LEXTOKN
	. I $D(^TMP("LEXTKN",$J,0)),^TMP("LEXTKN",$J,0)>0 D
	. . S LEXTKN="",LEXTKC=0
	. . F  S LEXTKC=$O(^TMP("LEXTKN",$J,LEXTKC)) Q:+LEXTKC'>0  D
	. . . N LEXND,LEXTKN S LEXTKN=$O(^TMP("LEXTKN",$J,LEXTKC,"")) Q:'$L(LEXTKN)
	. . . I $L($G(LEXTKN)),+($G(LEXMCI))>0,+($G(LEXMCEI))>0,+($G(LEXEX))>0 D
	. . . . N LEXND S LEXND="^LEX(757.01,"_LEXEX_",4,""B"","_$$QQ(LEXTKN)_")" Q:$D(@LEXND)
	. . . . S LEXND="^TMP(""LEXAWRD"","_$J_","_$$QQ(LEXTKN)_","_+LEXMCEI_")" Q:$D(@LEXND)
	. . . . S LEXND="^TMP(""LEXAWRD"","_$J_","_$$QQ(LEXTKN)_","_+LEXMCEI_","_LEXEX_")" S @LEXND=""
	. K ^TMP("LEXTKN",$J)
	. ;       Supplemental Words
	. S LEXSI=0 F  S LEXSI=$O(^LEX(757.01,LEXEX,5,LEXSI)) Q:+LEXSI'>0  D
	. . N LEXND,LEXTKN S LEXTKN=$$UP^XLFSTR($G(^LEX(757.01,LEXEX,5,LEXSI,0))) Q:'$L(LEXTKN)
	. . S LEXND="^LEX(757.01,"_LEXEX_",4,""B"","_$$QQ(LEXTKN)_")" Q:$D(@LEXND)
	. . I $D(LEXUNQ) S LEXND="^TMP(""LEXAWRD"","_$J_","_$$QQ(LEXTKN)_","_+LEXEX_")" Q:$D(@LEXND)
	. . S LEXND="^TMP(""LEXAWRD"","_$J_","_$$QQ(LEXTKN)_","_+LEXEX_","_+LEXMCEI_","_LEXSI_")"
	. . S @LEXND="" N LEXUNQ
	. ;       Linked Words
	. I $D(^LEX(757.05,"AEXP",LEXEX)) D
	. . N LEXRI S LEXRI=0
	. . F  S LEXRI=$O(^LEX(757.05,"AEXP",LEXEX,LEXRI)) Q:+LEXRI=0  D
	. . . N LEXTKN,LEXMC,LEXND S LEXTKN=$$UP^XLFSTR($P(^LEX(757.05,LEXRI,0),U,1)) Q:'$L(LEXTKN)
	. . . S LEXND="^LEX(757.01,"_LEXEX_",4,""B"","_$$QQ(LEXTKN)_")" Q:$D(@LEXND)
	. . . S LEXMC=$P($G(^LEX(757.01,LEXEX,1)),U,1) Q:+LEXMC'>0
	. . . I $D(LEXUNQ) S LEXND="^TMP(""LEXAWRD"","_$J_","_$$QQ(LEXTKN)_","_LEXEX_")" Q:$D(@LEXND)
	. . . S LEXND="^TMP(""LEXAWRD"","_$J_","_$$QQ(LEXTKN)_","_LEXEX_",""LINKED"")"
	. . . S @LEXND="" N LEXUNQ
	K ^TMP("LEXTKN",$J) H 1 S LEXEND=$$END D SAV^LEXXGP3(LEXBEG,LEXEND,LEXTXT)
	S LEXELP=$$ELP(LEXBEG,LEXEND),LEXBEGD=$$ED(LEXBEG)
	S LEXBEGT=$$ET(LEXBEG),LEXENDT=$$ET(LEXEND),LEXDF=$$DF(LEXBEG)
	S LEXTXT=$G(LEXTXT)_$J(" ",(35-$L($G(LEXTXT))))
	S LEXTXT=LEXTXT_LEXDF_"   "_LEXBEGT_"   "_LEXENDT_"   "_LEXELP
	S LEXTXT=" "_LEXTXT W:'$D(ZTQUEUED) !,LEXTXT
	D AWRDR I $G(LEXQUIT)="AWRDB" D
	. D:$D(LEXMAIL) XM^LEXXGP3 I '$D(LEXTEST) D
	. . K ^TMP("LEXAWRD",$J),^TMP("LEXAWRDU",$J),^TMP("LEXAWRDK",$J),^TMP("LEXTKN",$J),^TMP("LEXXGPDAT",$J)
	. . K ^TMP("LEXXGPTIM",$J),^TMP("LEXXGPRPT",$J) N ZTQUEUED,LEXTEST
	Q
AWRDR	;   AWRD Word Index Replace                       2.5 minutes
	N LEX1,LEX2,LEX3,LEXBEG,LEXBEGD,LEXBEGT,LEXCHK,LEXCHR,LEXCHRS,LEXCOM,LEXCTL,LEXDATA
	N LEXDF,LEXELP,LEXEND,LEXENDT,LEXEX,LEXIT,LEXLTKN,LEXMC,LEXND,LEXNOD,LEXSP,LEXTK
	N LEXTK1,LEXTK2,LEXTK3,LEXTK4,LEXTK5,LEXTKN,LEXTTKN,LEXTXT S (LEX1,LEX2,LEX3)=0
	Q:'$D(LEXQUIT)  S LEXBEG=$$BEG,LEXTXT="Replace 'AWRD' Word Index"
	I +($G(ZTSK))>0 S LEXCHK=$$S^%ZTLOAD((LEXTXT_" in file 757.01"))
	K LEXCHRS D CHRS
	K ^TMP("LEXAWRDK",$J),^TMP("LEXAWRDU",$J)
	S LEXIT=0,LEXCHR="" F  S LEXCHR=$O(LEXCHRS(LEXCHR)) Q:'$L(LEXCHR)  D
	. N LEXLTKN,LEXTTKN,LEXTK1,LEXTK2,LEXTK3,LEXTK4,LEXTK5,LEXTK,LEXIT
	. ;     For words beginning with a character
	. S (LEXTK1,LEXTK2,LEXTK3,LEXTK4,LEXTK5)="",LEXIT=0
	. S LEXTK1=$C($A(LEXCHR)-1)_"~",LEXTK2=LEXCHR,LEXTK3=LEXCHR_" "
	. S:LEXCHR?1N LEXTK4=LEXCHR-.00000001 S:LEXCHR="." LEXTK5=.00000001
	. F LEXTK=LEXTK1,LEXTK2,LEXTK3,LEXTK4,LEXTK5 D
	. . Q:'$L(LEXTK)  N LEXIT S LEXIT=0 S (LEXLTKN,LEXTTKN)=LEXTK
	. . F  S LEXLTKN=$O(^LEX(757.01,"AWRD",LEXLTKN)) D  Q:LEXIT>0
	. . . S:'$L(LEXLTKN) LEXIT=1
	. . . S:LEXCHR'?1N&($E(LEXLTKN,1)'=LEXCHR) LEXIT=1
	. . . S:LEXCHR?1N&($E(LEXLTKN,1)'?1N) LEXIT=1
	. . . Q:LEXIT>0
	. . . N LEXND
	. . . ;       Delete words from the ^LEX global
	. . . I $L(LEXLTKN) Q:$D(^TMP("LEXAWRDU",$J,LEXLTKN))
	. . . S:$L(LEXLTKN) ^TMP("LEXAWRDU",$J,LEXLTKN)=""
	. . . N LEXDATA,LEXND
	. . . I $D(LEXFUL) D
	. . . . N LEXNOD,LEXCTL,LEXIT,LEXND S LEXIT=0
	. . . . S LEXNOD="^LEX(757.01,""AWRD"","""_LEXLTKN_""")"
	. . . . S LEXCTL="^LEX(757.01,""AWRD"","""_LEXLTKN_""","
	. . . . F  S LEXNOD=$Q(@LEXNOD) D  Q:LEXIT>0
	. . . . . S:'$L(LEXNOD) LEXIT=1 S:LEXNOD'[LEXCTL LEXIT=1
	. . . . . Q:LEXIT>0  N LEXFUL S LEX2=LEX2+1
	. . . S LEXND="^LEX(757.01,""AWRD"","_$$QQ(LEXLTKN)_")"
	. . . K @LEXND S LEX1=LEX1+1
	. . S LEXIT=0 F  S LEXTTKN=$O(^TMP("LEXAWRD",$J,LEXTTKN)) D  Q:LEXIT>0
	. . . S:'$L(LEXTTKN) LEXIT=1
	. . . S:LEXCHR'?1N&($E(LEXTTKN,1)'=LEXCHR) LEXIT=1
	. . . S:LEXCHR?1N&($E(LEXTTKN,1)'?1N) LEXIT=1
	. . . Q:LEXIT>0
	. . . N LEXND,LEXNOD,LEXCTL,LEXKEY
	. . . S LEXNOD="^TMP(""LEXAWRD"","_$J_","_$$QQ(LEXTTKN)_")"
	. . . S LEXCTL="^TMP(""LEXAWRD"","_$J_","_$$QQ(LEXTTKN)_","
	. . . F  S LEXNOD=$Q(@LEXNOD) Q:'$L(LEXNOD)!(LEXNOD'[LEXCTL)  D
	. . . . ;         Copy Index from ^TMP to ^LEX
	. . . . ;           ^TMP("LEXAWRD",$J,WORD,MCIEN,EXIEN,SPIEN)
	. . . . ;           ^LEX(757.01,"AWRD",WORD,MCIEN,EXIEN,SPIEN)
	. . . . N LEXND,LEXTKN,LEXMC,LEXEX,LEXSP,LEXTND,LEXKEY
	. . . . S LEXTND=$TR(LEXNOD,"""","")
	. . . . S LEXTKN=$P(LEXTND,",",3)
	. . . . S LEXMC=$P(LEXTND,",",4) Q:+LEXMC'>0
	. . . . S LEXEX=$P($P(LEXNOD,",",5),")",1) Q:'$L(LEXEX)
	. . . . S LEXSP=$P($P(LEXTND,",",6),")",1)
	. . . . S LEXND="^LEX(757.01,""AWRD"","_$$QQ(LEXTKN)
	. . . . S LEXND=LEXND_","_LEXMC_","_$$QQ(LEXEX)
	. . . . S:$L(LEXSP) LEXND=LEXND_","_$$QQ(LEXSP)
	. . . . S LEXND=LEXND_")",LEXKEY=$TR(LEXND,"""","")
	. . . . S @LEXND="" S:'$D(^TMP("LEXAWRDK",$J,LEXKEY)) LEX3=LEX3+1
	. . . . S ^TMP("LEXAWRDK",$J,LEXKEY)=""
	. ;         Repeat for all characters
	K:'$D(LEXTEST)!($D(ZTQUEUED)) ^TMP("LEXAWRDK",$J),^TMP("LEXAWRDU",$J)
	H 1 S LEXEND=$$END D SAV^LEXXGP3(LEXBEG,LEXEND,LEXTXT)
	S LEXELP=$$ELP(LEXBEG,LEXEND),LEXBEGD=$$ED(LEXBEG)
	S LEXBEGT=$$ET(LEXBEG),LEXENDT=$$ET(LEXEND),LEXDF=$$DF(LEXBEG)
	S LEXTXT=$G(LEXTXT)_$J(" ",(35-$L($G(LEXTXT))))
	S LEXTXT=LEXTXT_LEXDF_"   "_LEXBEGT_"   "_LEXENDT_"   "_LEXELP
	S LEXTXT=" "_LEXTXT W:'$D(ZTQUEUED) !,LEXTXT
	I LEX1>0,$D(LEXFUL) D
	. S LEXCOM=LEX1_" Word"_$S(LEX1>1:"s",1:"")
	. D SAV^LEXXGP3(LEXBEG,"","",LEXCOM) W:'$D(ZTQUEUED) !,"   ",LEXCOM
	I LEX3>0,$D(LEXFUL) D
	. S LEXCOM=LEX3_" 'AWRD' Index Node"_$S(LEX3>1:"s",1:"")
	. D SAV^LEXXGP3(LEXBEG,"","",LEXCOM) W:'$D(ZTQUEUED) !,"   ",LEXCOM
	Q
	;
	; Miscellaneous
QQ(X)	;   Set Quotes
	N LEXS,LEXT S LEXS=$TR($G(X),"""",""),LEXT=0
	S:$TR(LEXS,".","")'?1N.N LEXT=1 I $TR(LEXS,".","")?1N.N S:$L(+LEXS)'=$L(LEXS) LEXT=1
	S X=LEXS S:LEXT=1 X=""""_LEXS_""""
	Q X
SCT(X)	;   String Count (exact string)
	N LEX,LEXA,LEXE,LEXIT,LEXM,LEXN,LEXO,LEXOUT,LEXP,LEXRT,LEXRT2,LEXS,LEXT,LEXTKN
	S LEXS=$$UP^XLFSTR($G(X)) Q:'$L(LEXS) 0  S LEXRT="" S:$D(^LEX(757.01,"AWRD")) LEXRT="^LEX(757.01,""AWRD"","
	S:$D(^TMP("LEXAWRD",$J)) LEXRT="^TMP(""LEXAWRD"","_$J_"," Q:'$L(LEXRT) 0  S (LEXA,LEXN,LEXT)=0
	S:$L(LEXS)>1 LEXO=$E(LEXS,1,($L(LEXS)-1))_$C(($A($E(LEXS,$L(LEXS)))-1))_"~"
	S:$L(LEXS)=1 LEXO=$C(($A(LEXS)-1))_"~" S LEXIT=0
	F  S LEXO=$O(@(LEXRT_""""_LEXO_""")")) D  Q:LEXIT>0
	. S:'$L(LEXO) LEXIT=1 S:$E(LEXO,1,$L(LEXS))'=LEXS LEXIT=1
	. Q:LEXIT>0  N LEXM S LEXM=0 F  S LEXM=$O(@(LEXRT_""""_LEXO_""","_LEXM_")")) Q:+LEXM'>0  D
	. . N LEXE,LEXRT2 S LEXE=0,LEXRT2=LEXRT_""""_LEXO_""","_LEXM_","
	. . F  S LEXE=$O(@(LEXRT2_LEXE_")")) Q:+LEXE'>0  S LEXT=LEXT+1,LEXA=LEXA+1
	I $TR(LEXS,".","")?1N.N,$L(LEXS,".")'>2  I +LEXS=LEXS D
	. N LEXFC S LEXFC=$E(LEXS,1) S:$E(LEXS,1)?1N LEXO=LEXS-.000000001
	. S:$E(LEXS,1)="." LEXO=.000000001 S LEXIT=0
	. F  S LEXO=$O(@(LEXRT_+LEXO_")")) D  Q:LEXIT>0  Q:'$L(LEXO)
	. . S:LEXFC?1N&($E(LEXO,1)'?1N) LEXIT=1
	. . S:LEXFC?1P&($E(LEXO,1)'?1P) LEXIT=1 Q:LEXIT>0
	. . Q:'$L(LEXO)  Q:$E(LEXO,1,$L(LEXS))'=LEXS  N LEXM S LEXM=0
	. . F  S LEXM=$O(@(LEXRT_+LEXO_","_LEXM_")")) Q:+LEXM'>0  D
	. . . N LEXE,LEXRT2 S LEXE=0,LEXRT2=LEXRT_+LEXO_","_LEXM_","
	. . . F  S LEXE=$O(@(LEXRT2_LEXE_")")) Q:+LEXE'>0  S LEXT=LEXT+1,LEXN=LEXN+1
	S X=LEXT
	Q X
CHRS	;   Get Characters - Sets LEXCHRS
	N LEXCHR,LEXRT,LEXRT1,LEXRT2,LEXTK K LEXCHRS S LEXRT1="^LEX(757.01,""AWRD"","
	S LEXRT2="^TMP(""LEXAWRD"","_$J_"," F LEXRT=LEXRT1,LEXRT2 D
	. N LEXTK S LEXTK="#" F  S LEXTK=$O(@(LEXRT_""""_LEXTK_""")")) Q:'$L(LEXTK)  D
	. . N LEXCHR S LEXCHR=$E($TR(LEXTK," ",""),1) S LEXTK=$E(LEXTK,1)_"~"
	. . S:$L(LEXCHR) LEXCHRS(LEXCHR)=""
	Q
FMTT(X)	;   Format Total
	N LEXI,LEXTXT,LEXTMP,LEXBEG,LEXBEGD,LEXBEGT,LEXEND,LEXENDD,LEXENDT,LEXELP
	S LEXBEG=$G(^TMP("LEXXGPTIM",$J,"BEG")) Q:$P(LEXBEG,".",1)'?7N ""
	S LEXEND=$G(^TMP("LEXXGPTIM",$J,"END")) Q:$P(LEXEND,".",1)'?7N ""
	Q:LEXEND'>LEXBEG ""  S LEXTXT="Total Time to Repair Indexes"
	S LEXELP=$$ELP(LEXBEG,LEXEND),LEXBEGD=$$ED(LEXBEG),LEXBEGT=$$ET(LEXBEG),LEXENDT=$$ET(LEXEND),LEXDF=$$DF(LEXBEG)
	Q:'$L(LEXBEGT) ""  Q:'$L(LEXENDT) ""  Q:'$L(LEXELP) ""
	S X=LEXTXT_$J(" ",(35-$L(LEXTXT)))_LEXBEGD_"   "_LEXBEGT_"   "_LEXENDT_"   "_LEXELP
	Q X
FMT(X,LEXBD,LEXBT,LEXET,LEXEL)	;   Format Line
	N LEXTX S LEXTX=$G(X),LEXBD=$G(LEXBD),LEXBT=$G(LEXBT),LEXET=$G(LEXET),LEXEL=$G(LEXEL)
	Q:'$L(LEXTX)!('$L(LEXBD))!('$L(LEXBT))!('$L(LEXET))!('$L(LEXEL)) ""
	S X=$G(LEXTX)_$J(" ",(35-$L($G(LEXTX))))_LEXBD_"   "_LEXBT_"   "_LEXET_"   "_LEXEL
	Q X
DF(X)	;   Date Display Format
	N LEXO,LEXD,LEXDF,LEXP,LEXC S (X,LEXD)=$P($G(X),".",1) Q:LEXD'?7N "--/--/----"
	S LEXP=$O(^TMP("LEXXGPDAT",$J,(LEXD_".001")),-1) S LEXC=1
	S:$L(LEXP) LEXC=$O(^TMP("LEXXGPDAT",$J,LEXP," "),-1)
	S LEXO=$$ED(LEXD) S:LEXP=LEXD&(LEXC>1) LEXO="  ""    ""  " S X=LEXO
	Q X
ED(X)	;   External Date from Fileman
	N LEX,LEXT,LEXBD S LEX=$G(X) Q:$P(LEX,".",1)'?7N ""
	S LEXT=$$FMTE^XLFDT($G(LEX),"5ZS"),X=$P(LEXT,"@",1)
	Q X
ET(X)	;   External Time from Fileman
	N LEX,LEXT,LEXBD S LEX=$G(X) Q:$P(LEX,".",1)'?7N ""
	S LEXT=$$FMTE^XLFDT($G(LEX),"5ZS"),X=$P(LEXT,"@",2)
	S:'$L(X) X="00:00:00" S:'$L($P(X,":",1)) $P(X,":",1)="00"
	S:'$L($P(X,":",2)) $P(X,":",2)="00" S:'$L($P(X,":",3)) $P(X,":",3)="00"
	Q X
BEG(X)	;   Begin Date/Time
	S X=$$NOW^XLFDT N Y S Y=$G(^TMP("LEXXGPTIM",$J,"BEG"))
	S:'$L(Y) Y=X S:+X<Y Y=X S:$P(Y,".",1)?7N ^TMP("LEXXGPTIM",$J,"BEG")=Y
	Q X
END(X)	;   End Date/Time
	S X=$$NOW^XLFDT N Y S Y=$G(^TMP("LEXXGPTIM",$J,"END"))
	S:'$L(Y) Y=X S:+X>Y Y=X S:$P(Y,".",1)?7N ^TMP("LEXXGPTIM",$J,"END")=Y
	Q X
ELP(X,Y)	;   Elapsed Time
	N LEXBEG,LEXEND,LEXELP S LEXBEG=$G(X),LEXEND=$G(Y)
	Q:$P(LEXBEG,".",1)'?7N "        "
	Q:$P(LEXEND,".",1)'?7N "        "
	S LEXELP=$TR($$FMDIFF^XLFDT(LEXEND,LEXBEG,3)," ","0")
	S X=LEXELP
	Q X
CLR	;   Clear Variables
	K LEXLOUD,LEXTEST,LEXJ,LEXMAIL,LEXHOME,LEXQUIT
	Q
