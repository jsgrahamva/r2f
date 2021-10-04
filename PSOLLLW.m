PSOLLLW	;BIR/EJW - LASER LABELS NEW WARNING LABEL SOURCE ;05/04/2004
	;;7.0;OUTPATIENT PHARMACY;**161,338**;DEC 1997;Build 3
	;
	;External reference to WTEXT^PSSWRNA supported by DBIA 4444
	;
PRINT(T,B)	;
	S BOLD=$G(B)
	I 'BOLD,$G(PSOIO(PSOFONT))]"" X PSOIO(PSOFONT)
	I BOLD,$G(PSOIO(PSOFONT_"B"))]"" X PSOIO(PSOFONT_"B")
	I $G(PSOIO("ST"))]"" X PSOIO("ST")
	W T,!
	I $G(PSOIO("ET"))]"" X PSOIO("ET")
	I BOLD,$G(PSOIO(PSOFONT))]"" X PSOIO(PSOFONT) ;TURN OFF BOLDING
	Q
	;
WARN54	; WARNING LABELS FROM RX CONSULT FILE
	I PSOWARN=" " S PSOY=WWW*115+29+(WWW-1*2) Q  ; PRINT BLANK LABEL(S) TO BOTTOM-JUSTIFY IF LESS THAN 5 WARNING LABELS
	S (LENGTH,OUT)=0,LINE=1,LCNT=3
	S TEXT=$$WTEXT^PSSWRNA(PSOWARN,PSOLAN)
	I TEXT'="" D FORMAT
	Q
	;
NEWWARN	; NEW WARNING LABEL SOURCE
	S (LENGTH,OUT)=0,LINE=1,LCNT=3
	S TEXT=$$WTEXT^PSSWRNA(PSOWARN,PSOLAN)
	I TEXT'="" D FORMAT
	Q
	;
FORMAT	;
	D STRT^PSOLLU1("WRN",TEXT,.L,.XFONT)
	D INCREM
	S PTEXT=""
	F I=1:1 Q:$E(TEXT)'=" "  S TEXT=$E(TEXT,2,255)
	F I=1:1:$L(TEXT," ") D STRT^PSOLLU1("WRN",$P(TEXT," ",I)_" ",.L) D  Q:OUT
	. I LENGTH+L($E(XFONT,2,99))<1.99 S PTEXT=PTEXT_$P(TEXT," ",I)_" ",LENGTH=LENGTH+L($E(XFONT,2,99)) Q
	. S LENGTH=0,I=I-1,PSOFONT=XFONT
	. I LINE=4,$P(TEXT," ",I+1)'="" D
	. . S PTEXT="... See printed Additional Warnings."
	. . S PSOWLBL=$G(PSOWLBL)_$G(PSOWARN)_","
	. D PRINT(PTEXT) S PTEXT="",LINE=LINE+1 I LINE>LCNT S OUT=1 Q
	I 'OUT S PSOFONT=XFONT D PRINT(PTEXT)
	S PSOY=WWW*115+29+(WWW-1*2)
	Q
	;
INCREM	;
	I XFONT="F6" S LCNT=4
	S PSOY=PSOY+$S(XFONT="F12":10,XFONT="F10":8,XFONT="F9":8,1:5),PSOYI=$S(XFONT="F12":40,XFONT="F10":35,XFONT="F9":29,1:29)
	I WWW=1 S PSOY=$S(PSOY>103:PSOY-20,1:PSOY),PSOYI=$S(XFONT="F10":30,XFONT="F6":20,1:PSOYI)
	Q
	;
COUNTSG	; COUNT LINES NEEDED FOR BOTTLE LABEL SIG FOR CALCULATED FONT
	N CNT,SUBS
	S CNT=0
	K ^TMP($J,"PSOSIG",RX)
	S PSOX=OPSOX,LENGTH=0,PTEXT="",SIGF=0,XFONT=$E(PSOFONT,2,99)
	N DP,TEXTP,TEXTL,MORE
	F DR=SIGF("DR"):1 Q:$G(SGY(DR))=""  S TEXT=SGY(DR) D  Q:SIGF
	. F I=1:1 Q:$E(TEXT,I)'=" "  S TEXT=$E(TEXT,2,255)
	. S DP=$S(TEXT[" ":" ",TEXT[",":",",1:" ")
	. F I=SIGF("T"):1:$L(TEXT,DP) D  Q:SIGF
	.. S TEXTP=$P(TEXT,DP,I) Q:TEXTP=""  I $D(SIGF("J")) S TEXTP=$E(TEXTP,SIGF("J"),255) K SIGF("J")
	.. D STRT^PSOLLU1("SIG",TEXTP_" ",.L) I L(XFONT)>3.3 D
	... S MORE=0
	... F J=$L(TEXTP):-1:1 S TEXTL=PTEXT_$E(TEXTP,1,J) D STRT^PSOLLU1("SIG",TEXTL_" ",.L) D  Q:SIGF!MORE
	.... Q:L(XFONT)>3.3
	.... S CNT=CNT+1,^TMP($J,"PSOSIG",RX,CNT)=TEXTL,TEXT=$E(TEXT,J+1,999),PTEXT=""
	.... D STRT^PSOLLU1("SIG",TEXT_DP,.L) S TEXTP=TEXT,J=$L(TEXTP) I L(XFONT)<3.3 S MORE=1,LENGTH=0
	.. I LENGTH+L(XFONT)<3.3 S PTEXT=PTEXT_TEXTP_" ",LENGTH=LENGTH+L(XFONT) Q
	.. S LENGTH=0,I=I-1
	.. S CNT=CNT+1,^TMP($J,"PSOSIG",RX,CNT)=PTEXT S PTEXT=""
	. I 'SIGF S SIGF("T")=1
	I PTEXT]"" S CNT=CNT+1,^TMP($J,"PSOSIG",RX,CNT)=PTEXT
	K NSGY
	; FOR LONG SIGS THE SMALLEST FONT WILL BE USED. USING THAT FONT, 9 LINES OF THE SIG WILL FIT ON EACH BOTTLE LABEL. ON THE LAST 'CONTINUED' LABEL A MAXIMUM OF 4 LINES OF THE SIG CAN PRINT (WITHIN LINES 5-8 OF THE LABEL).
	; IF THERE ARE LESS THAN 4 LINES ON THE LAST 'CONTINUED' LABEL, THE REMAINDER OF THE SIG WILL PRINT BOTTOM-JUSTIFIED WITHIN LINES 5-8 OF THE CONTINUATION LABEL.
	N I,J,MODCNT
	F I=1:1:CNT S J=$S(I#9:(I\9)+1,1:I\9) D
	.S SUBS=$S(J=1:I,1:I-((J-1)*9))
	.S NSGY(J,SUBS)=^TMP($J,"PSOSIG",RX,I)
	S MODCNT=CNT#9 I MODCNT=0!(MODCNT>4) S NSGY($G(J)+1,0)=" " ; FORCE LAST CONTINUED LABEL
	Q
	;
COUNTSGF	; COUNT LINES NEEDED FOR PHARMACY FILL CARD SIG FOR CALCULATED FONT
	N CNT
	S CNT=0
	K ^TMP($J,"PSOSIGF",RX)
	S LENGTH=0,PTEXT="",PFF=0,XFONT=$E(PSOFONT,2,99)
	N DP,TEXTP,TEXTL,MORE
	F DR=PFF("DR"):1 Q:$G(PGY(DR))=""  S TEXT=PGY(DR) D  Q:PFF
	. F I=1:1 Q:$E(TEXT,I)'=" "  S TEXT=$E(TEXT,2,255)
	. S DP=$S(TEXT[" ":" ",TEXT[",":",",1:" ")
	. F I=PFF("T"):1:$L(TEXT,DP) D  Q:PFF
	.. S TEXTP=$P(TEXT,DP,I) Q:TEXTP=""  I $D(PFF("J")) S TEXTP=$E(TEXTP,PFF("J"),255) K PFF("J")
	.. D STRT^PSOLLU1("SIG",TEXTP_" ",.L) I L(XFONT)>3.3 D
	... S MORE=0
	... F J=$L(TEXTP):-1:1 S TEXTL=PTEXT_$E(TEXTP,1,J) D STRT^PSOLLU1("SIG",TEXTL_" ",.L) D  Q:PFF!MORE
	.... Q:L(XFONT)>3.3
	.... S CNT=CNT+1,^TMP($J,"PSOSIGF",RX,CNT)=TEXTL,TEXT=$E(TEXT,J+1,999),PTEXT=""
	.... D STRT^PSOLLU1("SIG",TEXT_DP,.L) S TEXTP=TEXT,J=$L(TEXTP) I L(XFONT)<3.3 S MORE=1,LENGTH=0
	.. I LENGTH+L(XFONT)<3.3 S PTEXT=PTEXT_TEXTP_" ",LENGTH=LENGTH+L(XFONT) Q
	.. S LENGTH=0,I=I-1
	.. S CNT=CNT+1,^TMP($J,"PSOSIGF",RX,CNT)=PTEXT S PTEXT=""
	. I 'PFF S PFF("T")=1
	I PTEXT]"" S CNT=CNT+1,^TMP($J,"PSOSIGF",RX,CNT)=PTEXT
	K NPGY
	; 11 LINES OF THE SIG WILL FIT ON EACH PHARMACY FILL CARD LABEL. ON THE LAST 'CONTINUED' LABEL A MAXIMUM OF 4 LINES OF THE SIG CAN PRINT
	N I,J,MODCNT
	F I=1:1:CNT S J=$S(I#11:(I\11)+1,1:I\11) D
	.S SUBS=$S(J=1:I,1:I-((J-1)*11))
	.S NPGY(J,SUBS)=^TMP($J,"PSOSIGF",RX,I)
	S MODCNT=CNT#11 I MODCNT=0!(MODCNT>4) S NPGY($G(J)+1,0)=" " ; FORCE LAST CONTINUED LABEL
	Q
	;
