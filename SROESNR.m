SROESNR	;BIR/ADM - NURSE INTRAOP REPORT E-SIG UTILITY ; [ 02/20/02  6:57 AM ]
	;;3.0;Surgery;**100,184**;24 Jun 93;Build 35
	;
	;** NOTICE: This routine is part of an implementation of a nationally
	;**         controlled procedure.  Local modifications to this routine
	;**         are prohibited.
	;
	Q
IN	N SRS S SRS=1 D GET
	Q
EX	N SRS S SRS=2 D GET,COMP
	I $D(^TMP("SRNRAD1",$J,SRTN))!$D(^TMP("SRNRAD2",$J,SRTN)) D ^SROESNR2
	Q
GET	K ^TMP("SRNRAD"_SRS,$J,SRTN) D VIEW^SROESNR0,MULT
	Q
MULT	; get data from multiples
	N SRK
	F SRK=130.23,130.28,130.36,130.24,130.065,130.31,130.028,130.16,130.02,130.32,130.01,130.33,130.08,130.04,130.11,130.013,130.18,130.0647,130.0664 D MULT^SROESNR1
	S SRK=130.06 D MULT^SROESNR3
	Q
COMP	; compare before and after view
	N SRFLD,SRCHNG,SRE,SRE1,SRE2,SRS,SRS1,SROTH,SRLN,SRMULT,X
	S SRFLD="" F  S SRFLD=$O(^TMP("SRNRAD1",$J,SRTN,130,SRFLD)) Q:SRFLD=""  S SRCHNG=0 D
	.I $P(SRFLD,"-",2)[";W" D  Q
	..F SRS=1,2 Q:SRCHNG  S SRLN=0,SROTH=$S(SRS=1:2,1:1) F  S SRLN=$O(^TMP("SRNRAD"_SRS,$J,SRTN,130,SRFLD,SRLN)) Q:'SRLN  D  Q:SRCHNG
	...I ^TMP("SRNRAD"_SRS,$J,SRTN,130,SRFLD,SRLN)'=$G(^TMP("SRNRAD"_SROTH,$J,SRTN,130,SRFLD,SRLN)) S SRCHNG=1
	..I 'SRCHNG F SRS=1,2 K ^TMP("SRNRAD"_SRS,$J,SRTN,130,SRFLD)
	.I ^TMP("SRNRAD1",$J,SRTN,130,SRFLD)'=$G(^TMP("SRNRAD2",$J,SRTN,130,SRFLD)) S SRCHNG=1
	.I 'SRCHNG F SRS=1,2 K ^TMP("SRNRAD"_SRS,$J,SRTN,130,SRFLD)
CMULT	; process multiples
	F SRS=1,2 K ^TMP("SRNRMULT"_SRS,$J,SRTN)
	F SRS=1,2 S SRMULT="A" F  S SRMULT=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT)) Q:SRMULT=""  S SROTH=$S(SRS=1:2,1:1) D PASS1
	F SRS=1,2 S SRMULT="A" F  S SRMULT=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT)) Q:SRMULT=""  S SROTH=$S(SRS=1:2,1:1) D PASS2
	F SRS=1,2 S SRMULT="A" F  S SRMULT=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT)) Q:SRMULT=""  S SROTH=$S(SRS=1:2,1:1) D PASS3
	F SRS=1,2 S SRMULT="A" F  S SRMULT=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT)) Q:SRMULT=""  S SROTH=$S(SRS=1:2,1:1) D PASS4
	Q
PASS1	; delete nodes for unchanged fields except for .01 fields
	S SRE=0 F  S SRE=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE)) Q:'SRE  S SRE1="" F  S SRE1=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1)) Q:SRE1=""  D
	.S SRFLD="" F  S SRFLD=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)) Q:SRFLD=""  S SRCHNG=0 D
	..S Y=$P(SRFLD,"-",3) I $P(Y,",",2)=.01 Q
	..I $P(SRFLD,"-",3)[";W" D  Q
	...F SRS1=1,2 Q:SRCHNG  S SRLN=0,SROTH=$S(SRS1=1:2,1:1) F  S SRLN=$O(^TMP("SRNRAD"_SRS1,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN)) Q:'SRLN  D
	....I ^TMP("SRNRAD"_SRS1,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN)'=$G(^TMP("SRNRAD"_SROTH,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN)) S SRCHNG=1
	...I 'SRCHNG F SRS1=1,2 K ^TMP("SRNRAD"_SRS1,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)
	..S SROTH=$S(SRS=1:2,1:1) I ^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)'=$G(^TMP("SRNRAD"_SROTH,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)) S SRCHNG=1
	..I 'SRCHNG F SRS1=1,2 K ^TMP("SRNRAD"_SRS1,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)
	Q
PASS2	; delete .01 nodes of sub-multiples if no changes underneath - before or after
	N SRNXT1,SRNXT2,SRY1,SRY2
	S SRE=0 F  S SRE=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE)) Q:'SRE  S SRE1=0 F  S SRE1=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1)) Q:SRE1=""  D
	.S SRFLD="" F  S SRFLD=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)) Q:SRFLD=""  D
	..I ^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)'=$G(^TMP("SRNRAD"_SROTH,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)) Q
	..S SRNXT1=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD))
	..S SRNXT2=$O(^TMP("SRNRAD"_SROTH,$J,SRTN,SRMULT,SRE,SRE1,SRFLD))
	..I SRNXT1="",SRNXT2="" K ^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD),^TMP("SRNRAD"_SROTH,$J,SRTN,SRMULT,SRE,SRE1,SRFLD) Q
	..S SRY1=$P(SRNXT1,"-",3),SRY2=$P(SRNXT2,"-",3) I $P(SRY1,",",2)=.01,$P(SRY2,",",2)=.01 K ^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD),^TMP("SRNRAD"_SROTH,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)
	Q
PASS3	; delete .01 nodes for top level multiples if no changes underneath
	S SRE=0 F  S SRE=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE)) Q:'SRE  S SRFLD="" F  S SRFLD=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,0,SRFLD)) Q:SRFLD=""  D
	.S Y=$P(SRFLD,"-",3) I $P(Y,",",2)'=.01 Q
	.I ^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,0,SRFLD)'=$G(^TMP("SRNRAD"_SROTH,$J,SRTN,SRMULT,SRE,0,SRFLD)) Q
	.I $O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,0,SRFLD))="",$O(^TMP("SRNRAD"_SROTH,$J,SRTN,SRMULT,SRE,0,SRFLD))="" D
	..I $O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,0))'="",$O(^TMP("SRNRAD"_SROTH,$J,SRTN,SRMULT,SRE,0))'="" Q
	..K ^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,0,SRFLD),^TMP("SRNRAD"_SROTH,$J,SRTN,SRMULT,SRE,0,SRFLD)
	Q
PASS4	; set up list of changed fields for display in addendum
	S SRE="" F  S SRE=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE)) Q:'SRE  S SRE1="" F  S SRE1=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1)) Q:SRE1=""  S SRFLD="" F  S SRFLD=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)) Q:SRFLD=""  D
	.I $P(SRFLD,"-",3)[";W" D  Q
	..S SRLN=0 F  S SRLN=$O(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN)) Q:'SRLN  D
	...S ^TMP("SRNRMULT"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN)=$G(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN))
	...S ^TMP("SRNRMULT"_SROTH,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN)=$G(^TMP("SRNRAD"_SROTH,$J,SRTN,SRMULT,SRE,SRE1,SRFLD,SRLN))
	.S ^TMP("SRNRMULT"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)=$G(^TMP("SRNRAD"_SRS,$J,SRTN,SRMULT,SRE,SRE1,SRFLD))
	.S ^TMP("SRNRMULT"_SROTH,$J,SRTN,SRMULT,SRE,SRE1,SRFLD)=$G(^TMP("SRNRAD"_SROTH,$J,SRTN,SRMULT,SRE,SRE1,SRFLD))
	Q
