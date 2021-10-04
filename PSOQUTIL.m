PSOQUTIL	;HINES/RMS - MISCELLANEOUS UTILITIES ; 30 Nov 2007  7:59 AM
	;;7.0;OUTPATIENT PHARMACY;**294,282**;DEC 1997;Build 18
	;
LSIG(SIG)	;EXPAND A SIG
	S SGY="" F P=1:1:$L(SIG," ") S X=$P(SIG," ",P) D:X]""  ;
	.;PSO*7*282 Intended Use Check
	.N PSOIN S PSOIN=$O(^PS(51,"B",X,0)) I PSOIN,($P(^PS(51,PSOIN,0),"^",4)<2)&($D(^PS(51,"A",X))) S %=^(X),X=$P(%,"^") I $P(%,"^",2)]"" S Y=$P(SIG,"",P-1),Y=$E(Y,$L(Y)) S:Y>1 X=$P(%,"^",2)
	.S SGY=SGY_X_" "
	Q SGY
WRAPTEXT(TEXT,LIMIT,CSPACES)	;
	;;FUNCTION TO DISPLAY (WRITE) TEXT WRAPPED TO A CERTAIN COLUMN LENGTH
	;;DEFAULT=74 CHARACTERS WITH NO SPACES IN FRONT
	N WORDS,COUNT,LINE,NEXTWORD
	Q:$G(TEXT)']"" ""
	S LIMIT=$G(LIMIT,74)
	S CSPACES=$S($G(CSPACES):CSPACES,1:0)
	S WORDS=$L(TEXT," ")
	W !,$$REPEAT^XLFSTR(" ",CSPACES)
	F COUNT=1:1:WORDS D
	. S NEXTWORD=$P(TEXT," ",COUNT)
	. Q:NEXTWORD=""  ;TO REMOVE LEADING OR DOUBLE SPACES
	. S LINE=$G(LINE)_NEXTWORD_" "
	. I $L($G(LINE))>LIMIT&(COUNT'=WORDS) W !,$$REPEAT^XLFSTR(" ",CSPACES) K LINE
	. W NEXTWORD_" "
	Q 
