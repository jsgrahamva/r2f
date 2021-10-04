SROESNR2	;BIR/ADM - NURSE REPORT E-SIG UTILITY ; [ 03/21/01  6:36 AM
	;;3.0;Surgery;**100,127,177**;24 Jun 93;Build 89
	;
	;** NOTICE: This routine is part of an implementation of a nationally
	;**         controlled procedure.  Local modifications to this routine
	;**         are prohibited.
	;
	N SRALN,SRE,SRE1,SRFILE,SRFLD,SRG,SRI,SRJ,SRLN,SRMULT,SRNM,SRNUM,SRPF,SRS,SRTITLE,SRVAL,SRVAL1,SRVAL2,SRX,SRY,X
	S SRI=0,SRG=$NA(^TMP("SRNR",$J,SRTN)) K @SRG
SING	; single fields
	S SRFLD="" F  S SRFLD=$O(^TMP("SRNRAD1",$J,SRTN,130,SRFLD)) Q:SRFLD=""  D
	.S SRTITLE=$P(SRFLD,"-"),X=$P(SRFLD,"-",2),SRFILE=$P(X,","),SRNUM=$P(X,",",2) I SRNUM[";W" D WPS Q
	.S SRVAL1="<NOT ENTERED>",SRY=$G(^TMP("SRNRAD1",$J,SRTN,130,SRFLD)) I SRY'="" D EXT S SRVAL1=SRX
	.S SRVAL2="<DELETED>",SRY=$G(^TMP("SRNRAD2",$J,SRTN,130,SRFLD)) I SRY'="" D EXT S SRVAL2=SRX
	.D LINE(2) S @SRG@(SRI)="The "_SRTITLE_" field was changed" D LINE(1) S @SRG@(SRI)="  from "_SRVAL1 D LINE(1) S @SRG@(SRI)="    to "_SRVAL2
MULT	; multiples
	S SRMULT="" F  S SRMULT=$O(^TMP("SRNRMULT1",$J,SRTN,SRMULT)) Q:SRMULT=""  D
	.D LINE(2) S @SRG@(SRI)="The "_SRMULT_" subfile was changed as follows:"
	.S SRE=0 F  S SRE=$O(^TMP("SRNRMULT1",$J,SRTN,SRMULT,SRE)) Q:'SRE  D
	..S SRE1="",SRJ=2,SRPF=0 F  S SRE1=$O(^TMP("SRNRMULT1",$J,SRTN,SRMULT,SRE,SRE1)) Q:SRE1=""  D  Q:SRE1=""
	...S SRFLD="" F  S SRFLD=$O(^TMP("SRNRMULT1",$J,SRTN,SRMULT,SRE,SRE1,SRFLD)) Q:SRFLD=""  D PROC Q:SRFLD=""
	Q
WPS	; word-processing fields
	D LINE(2) S @SRG@(SRI)="The "_SRTITLE_" field was changed" D LINE(1) S @SRG@(SRI)=" >> from original "_SRTITLE_" text:"
	I '$O(^TMP("SRNRAD1",$J,SRTN,130,SRFLD,0)) S @SRG@(SRI)=@SRG@(SRI)_" <NO TEXT ENTERED>"
	S SRLN=0 F  S SRLN=$O(^TMP("SRNRAD1",$J,SRTN,130,SRFLD,SRLN)) Q:'SRLN  S X=^TMP("SRNRAD1",$J,SRTN,130,SRFLD,SRLN) D LINE(1) S @SRG@(SRI)="    "_X
WPS2	D LINE(1) S @SRG@(SRI)=" >> to updated "_SRTITLE_" text:" I '$O(^TMP("SRNRAD2",$J,SRTN,130,SRFLD,0)) S @SRG@(SRI)=@SRG@(SRI)_" <TEXT DELETED>"
	S SRLN=0 F  S SRLN=$O(^TMP("SRNRAD2",$J,SRTN,130,SRFLD,SRLN)) Q:'SRLN  S X=^TMP("SRNRAD2",$J,SRTN,130,SRFLD,SRLN) D LINE(1) S @SRG@(SRI)="    "_X
	Q
EXT	; get external value
	S SRX=$$EXTERNAL^DILFD(SRFILE,SRNUM,"",SRY)
	I SRFILE=130 D  Q
	.I SRNUM=27,SRX'="" S SRX=$E(SRX,1,5) D CPT Q
	.I SRNUM=66 D DIAG
	I SRFILE=130.16,SRNUM=3,SRX'="" S SRX=$E(SRX,1,5) D CPT Q
	I SRFILE=130.18,SRNUM=3 D DIAG
	Q
DIAG	S SRY=$$ICD^SROICD(SRTN,SRY) S SRX=SRX_"  "_$P(SRY,"^",4) K SRY
	Q
CPT	S X=$$CPT^ICPTCOD(SRX,$P($G(^SRF(SRTN,0)),"^",9)),SRX=SRX_"  "_$P(X,"^",3)
	Q
PROC	S SRTITLE=$P(SRFLD,"-",2),X=$P(SRFLD,"-",3),SRFILE=$P(X,","),SRNUM=$P(X,",",2),SRJ=$P(SRFLD,"-",4) I SRNUM[";W" D WPM Q
	S SRVAL1="",SRY=$G(^TMP("SRNRMULT1",$J,SRTN,SRMULT,SRE,SRE1,SRFLD)) I SRY'="" D EXT S SRVAL1=SRX
	S SRVAL2="",SRY=$G(^TMP("SRNRMULT2",$J,SRTN,SRMULT,SRE,SRE1,SRFLD)) I SRY'="" D EXT S SRVAL2=SRX
	I $P(SRFLD,"-")="01",SRVAL1=""!(SRVAL2="") D FP01 Q
	I 'SRPF,$P(SRNUM,";")=.01,SRVAL1=""!(SRVAL2="") D FP01S Q
	I SRPF D FPX Q
	S:SRVAL1="" SRVAL1="<NOT ENTERED>" S:SRVAL2="" SRVAL2="<DELETED>"
	I SRVAL2=SRVAL1 D:$P(SRFLD,"-")="01" LINE(1) D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ)_"The "_SRTITLE_" entry "_SRVAL1_" was changed:" Q
	D:$P(SRFLD,"-")="01" LINE(1) D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ)_"The "_SRTITLE_" field was changed" D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ)_"  from "_SRVAL1 D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ)_"    to "_SRVAL2
	Q
FP01S	; add or delete subfile entry
	I SRVAL1="" D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ)_"The following "_SRTITLE_" was ADDED:" S SRNM=2
	I SRVAL2="" D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ)_"The following "_SRTITLE_" was DELETED:" S SRNM=1
	S SRPF=1,SRVAL=$S(SRNM=1:SRVAL1,1:SRVAL2) D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ+2)_SRTITLE_": "_SRVAL
	Q
FP01	; add or delete
	I SRVAL1="" D LINE(2) S @SRG@(SRI)=$$SPACE(SRJ)_"The following "_SRTITLE_" was ADDED:" S SRNM=2
	I SRVAL2="" D LINE(2) S @SRG@(SRI)=$$SPACE(SRJ)_"The following "_SRTITLE_" was DELETED:" S SRNM=1
	S SRPF=1,SRVAL=$S(SRNM=1:SRVAL1,1:SRVAL2) D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ+2)_SRTITLE_": "_SRVAL
	Q
FPX	S SRJ=SRJ+2 I SRNUM[";W" D WPM
	S SRVAL="",SRY=$G(^TMP("SRNRMULT"_SRNM,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)) I SRY'="" D EXT S SRVAL=SRX
	D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ)_SRTITLE_": "_SRVAL
	Q
FWPM	; word-processing in multiples in added or deleted entries
	I '$O(^TMP("SRNRAD1",$J,SRTN,SRMULT,SRE,SRE1,SRFLD,0)) S SRS=2
	I '$O(^TMP("SRNRAD2",$J,SRTN,SRMULT,SRE,SRE1,SRFLD,0)) S SRS=1
	D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ)_SRTITLE_":" S SRLN=0
	F  S SRLN=$O(^TMP("SRNRMULT"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN)) Q:'SRLN  S X=^TMP("SRNRMULT"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN) D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ)_X
	Q
WPM	; word-processing in multiples
	I SRPF S SRJ=SRJ+2 D FWPM Q
	D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ)_"The "_SRTITLE_" field was changed" D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ+2)_">> from original "_SRTITLE_" text:"
	I '$O(^TMP("SRNRAD1",$J,SRTN,SRMULT,SRE,SRE1,SRFLD,0)) S @SRG@(SRI)=@SRG@(SRI)_" <NO TEXT ENTERED>" D WPM2 Q
	S SRLN=0 F  S SRLN=$O(^TMP("SRNRMULT1",$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN)) Q:'SRLN  S X=^TMP("SRNRMULT1",$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN) D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ+2)_X
WPM2	D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ+2)_">> to updated "_SRTITLE_" text:" I '$O(^TMP("SRNRAD2",$J,SRTN,SRMULT,SRE,SRE1,SRFLD,0)) S @SRG@(SRI)=@SRG@(SRI)_" <TEXT DELETED>" Q
	S SRLN=0 F  S SRLN=$O(^TMP("SRNRMULT2",$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN)) Q:'SRLN  S X=^TMP("SRNRMULT2",$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN) D LINE(1) S @SRG@(SRI)=$$SPACE(SRJ+2)_X
	Q
SPACE(NUM)	; create spaces
	; pass in position, returns number of needed spaces
	I '$D(@SRG@(SRI)) S @SRG@(SRI)=""
	Q $J("",NUM-$L(@SRG@(SRI)))
	Q
LINE(NUM)	; create carriage returns
	F J=1:1:NUM S SRI=SRI+1,@SRG@(SRI)=""
	Q
