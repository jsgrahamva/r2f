LEXAL2	;ISL/KER - Look-up List (Array) ;04/21/2014
	;;2.0;LEXICON UTILITY;**80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    ^TMP("LEXFND"       SACC 2.3.2.5.1
	;    ^TMP("LEXHIT"       SACC 2.3.2.5.1
	;    ^TMP("LEXSCH"       SACC 2.3.2.5.1
	;               
	; External References
	;    None
	;               
	;  LEXL        Last on List
	;  LEXT/LEXF  List To/From
	;  LEXA        List position asked for
	;  "HOME"       Position at the begining of List
	;  "END"        Position at the end of List
	;  "PGDN"       Position down the list by #LEXLL
	;  "PGUP"       Position up the list by #LEXLL
	;               
LIST(LEXA)	; Continue to build list
	N LEXC,LEXDSP,LEXF,LEXI,LEXIEN,LEXL,LEXLL,LEXO
	N LEXT
	I '$D(^TMP("LEXSCH",$J))!('$D(^TMP("LEXFND",$J)))!('$D(^TMP("LEXHIT",$J))) D EDA^LEXAR Q
	; Positional
	S LEX=+($G(^TMP("LEXSCH",$J,"NUM",0))) S:LEXA="END" LEXA=+($G(^TMP("LEXSCH",$J,"NUM",0)))
	S:LEXA="HOME" LEXA=1 I LEXA="PGDN" S LEXA=+($P($G(LEX("LIST",0)),"^",1))+(+($G(^TMP("LEXSCH",$J,"LEN",0)))) S:LEXA>LEX LEXA=LEX
	I LEXA="PGUP" S LEXA=+($P($G(LEX("LIST",0)),"^",1))-(+($G(^TMP("LEXSCH",$J,"LEN",0)))) S:LEXA=0 LEXA=1
	; End listing
	I +($G(LEXA))=0 D EDA^LEXAR Q
	; Make List
	N LEXL,LEXC,LEXLL,LEXT,LEXF S LEXL=+($G(^TMP("LEXSCH",$J,"LST",0)))
	S LEXLL=+($G(^TMP("LEXSCH",$J,"LEN",0))) S:LEXLL=0 LEXLL=5
	Q:LEXA>LEX  D HILO Q:+($G(LEXF))>+($G(LEX))  Q:+($G(LEXA))>+($G(LEX))
	D:LEXA>LEXL FWD D:LEXA'>LEXL BKW
	I $D(LEX("LIST")) D LST^LEXAR
	Q
HILO	; List From LEXF - To LEXT
	I +($G(LEXA))=0 S LEXF=1,LEXT=LEXLL Q
	S (LEXA,LEXT)=+($G(LEXA)) Q:LEXT'>0!(LEXT>+($G(LEX)))
	S LEXF=LEXT#LEXLL S:LEXF=0 LEXF=LEXLL S LEXF=LEXF-1,LEXF=LEXT-LEXF,LEXT=LEXF+(LEXLL-1)
	Q
FWD	; Build list Forward (User Response was Null or Jump Forward)
	K LEX N LEXI,LEXIEN,LEXDSP S LEX=+($G(^TMP("LEXSCH",$J,"NUM",0)))
	Q:LEXT'>0!(LEXF>+($G(LEX)))  D:'$D(^TMP("LEXHIT",$J,LEXT)) ADD D:$D(^TMP("LEXHIT",$J,LEXF)) BLD
	Q
ADD	; Add to Hit list
	N LEXC,LEXI,LEXIEN S LEXC=LEXL,LEXI=-9999999999
	F  S LEXI=$O(^TMP("LEXFND",$J,LEXI)) Q:+LEXI=0!(LEXC>LEXT)!(LEXC>LEX)  D  Q:LEXC>LEXT!(LEXC>LEX)  D
	. S LEXIEN=0 F  S LEXIEN=$O(^TMP("LEXFND",$J,LEXI,LEXIEN)) Q:+LEXIEN=0!(LEXC>LEXT)!(LEXC>LEX)  D  Q:LEXC>LEXT!(LEXC>LEX)
	. . S LEXC=LEXC+1 I LEXC'>LEXT D
	. . . S LEXDSP=^TMP("LEXFND",$J,LEXI,LEXIEN),^TMP("LEXHIT",$J,0)=LEXC
	. . . S ^TMP("LEXHIT",$J,LEXC)=LEXIEN_"^"_LEXDSP
	. . . S:+($G(^TMP("LEXSCH",$J,"EXM",0)))=+LEXIEN ^TMP("LEXSCH",$J,"EXM",2)=LEXC_"^"_$G(^LEX(757.01,+LEXIEN,0))
	. . . S:+($G(^TMP("LEXSCH",$J,"EXC",0)))=+LEXIEN ^TMP("LEXSCH",$J,"EXC",2)=LEXC_"^"_$G(^LEX(757.01,+LEXIEN,0))
	. . . K ^TMP("LEXFND",$J,LEXI,LEXIEN) S ^TMP("LEXSCH",$J,"LST",0)=$G(^TMP("LEXSCH",$J,"LST",0))+1
	Q
BLD	; Build LEX("LIST")
	S LEX=+($G(^TMP("LEXSCH",$J,"NUM",0))) S:'$D(^TMP("LEXHIT",$J)) LEX=0
	N LEXC,LEXCTR S LEXCTR=0,LEXC=LEXF-1
	F  S LEXC=$O(^TMP("LEXHIT",$J,LEXC)) Q:+LEXC=0!(+LEXC>LEXT)  D  Q:+LEXC>LEXT
	. S LEXCTR=LEXCTR+1,LEX("LIST",LEXC)=^TMP("LEXHIT",$J,LEXC),LEX("LIST",0)=LEXC_"^"_LEXCTR
	. S LEX("MIN")=1,LEX("MAX")=LEXC,(LEXL,^TMP("LEXSCH",$J,"LST",0))=LEXC
	Q
BKW	; Build list Backwards (User Response was Jump Backwards)
	S LEXLL=+($G(LEXLL)),LEXF=+($G(LEXF)),LEXT=+($G(LEXT)) Q:LEXF=0  Q:LEXT=0  Q:LEXLL=0
	Q:'$D(^TMP("LEXHIT",$J,LEXF))  N LEXCTR,LEXO,LEXC S LEXCTR=0,LEXO=LEXF-1,LEXC=0
	K LEX("LIST") F  S LEXO=$O(^TMP("LEXHIT",$J,LEXO)) Q:+LEXO=0!(LEXC>LEXLL)  D  Q:LEXC>LEXLL
	. S LEXCTR=LEXCTR+1,LEXC=LEXC+1
	. I LEXC'>LEXLL S LEX("LIST",LEXO)=^TMP("LEXHIT",$J,LEXO),LEX("LIST",0)=LEXO_"^"_LEXCTR
	Q
