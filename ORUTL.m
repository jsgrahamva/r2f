ORUTL	;SLC/DCM,RWF - Order utilities;03/20/2013  13:11
	;;3.0;ORDER ENTRY/RESULTS REPORTING;**95,280,218,LOCAL,WVEHR**;;Build 2
	;
	;Modified from FOIA VISTA,
	;
	; Copyright 2015 WorldVistA.
	;
	; This program is free software: you can redistribute it and/or modify
	; it under the terms of the GNU Affero General Public License as
	; published by the Free Software Foundation, either version 3 of the
	; License, or (at your option) any later version.
	;
	; This program is distributed in the hope that it will be useful,
	; but WITHOUT ANY WARRANTY; without even the implied warranty of
	; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	; GNU Affero General Public License for more details.
	;
	; You should have received a copy of the GNU Affero General Public License
	; along with this program.  If not, see <http://www.gnu.org/licenses/>.
	;
LOC	;;GET PT. LOCATION
	S C(1)=$S($D(ORL(2))#2:$S(ORL(2)[";":$S($D(@("^"_$P(ORL(2),";",2)_+ORL(2)_",0)")):$P(^(0),"^"),1:""),1:""),1:"")
	I 'OR4,ORVP[";DPT(",$D(ORL(2)),ORL(2) Q
	G:$L(C(1)) LOC1 S (CT,C)=0,O=1 I ORVP[";DPT(",$O(^DPT(+ORVP,"DE",0))>0 W !!,"Currently enrolled in the following clinics: ",!
	I  S I=0 F L=0:0 S I=$O(^DPT(+ORVP,"DE",I)) Q:I'>0  I $D(^(I,0)) S Y=^(0) I $P(Y,"^",2)'="I",'$P(Y,"^",3) I $D(^SC(+Y,0)) S X=^(0) D
	. I $D(^SC(+Y,"I")) S ORIA=+^("I"),ORRA=$P(^("I"),"^",2) I $S('ORIA:0,ORIA>DT:0,ORRA'>DT&(ORRA):0,1:1) Q
	. S CT=CT+1 W:(CT#2) !?17 W:'(CT#2) ?47 W $P(X,"^") S C=C+1,C(1)=$P(X,"^") S:C'=1 C=-1
	W !
LOC1	S C=1 W !,"Patient Location: " W:C=1&($L(C(1))) C(1),"//" R X:DTIME G QUIT:'$T,QUIT:C'=1&(X=""),LOC:$L(X)>20!(X'?.ANP),QUIT:X[U
	S DIC("S")="I ""FI""'[$P(^(0),""^"",3),'$P($G(^(""OOS"")),""^"")",DIC=44,DIC(0)=$S(C=1&($L(C(1)))&(X=""):"EMQOZX",1:"EMQZ")
	S:X="" X=C(1) D ^DIC G LOC:X["?" S:Y>0 ORL=+Y_";SC(",ORL(0)=$S($L($P(Y(0),"^",2)):$P(Y(0),"^",2),1:$E($P(Y(0),"^"),1,4))
	K ORIA,ORRA I $D(^SC(+Y,"I")) S ORIA=+^("I"),ORRA=$P(^("I"),U,2)
	I $S('$D(ORIA):0,'ORIA:0,ORIA>DT:0,ORRA'>DT&(ORRA):0,1:1) W $C(7)," This location has been inactivated." K ORL G LOC
	I Y<0 W "  You must select a standard location." G LOC
	K DIC,C,ORIA,ORRA Q
QUIT	S OREND=1 K DIC,C Q
READ	;;Hold screen
	I $D(IOST) Q:$E(IOST)'="C"
	W ! I $D(IOSL),$Y<(IOSL-4) G READ
	W !?5,"Press return to continue  " R X:$S($D(DTIME):DTIME,1:300)
	Q
CHKNAM(X,Y)	;Input transform to not allow certain characters
	;X is the text to be checked, Y are the characters not allowed as sent in by the input transform of the field
	N I,J I '$D(Y) S Y="-;,=^" ;if no special characters sent in, set list to all
	F I=1:1:$L(Y) I X[($E(Y,I)) S J=1
	Q +$G(J)
CHKMNE(X)	;Input transform to not allow use of standard Lmgr Mnemonics
	N Y
	S Y=$$UP^XLFSTR(X) ;check to make sure mnemonic isn't set to lower case of restricted entries.  List Manager is case insensitive
	I Y="ADPL"!(Y="DN")!(Y="Q")!(Y="FS")!(Y="GO")!(Y="?")!(Y="??")!(Y="LS")!(Y="+")!(Y="-")!(Y="PL")!(Y="PS")!(Y="RD")!(Y="SL")!(Y="<")!(Y=">")!(Y="UP")!(Y="PI")!(Y="CWAD")!(Y="TD")!(Y="EX") Q 1
	Q 0
PAD(ORX,ORL)	; Pads string to specified length
	N ORY
	S ORY="",$P(ORY," ",(ORL-$L(ORX))+1)=""
	Q ORY
MAIL(XMTEXT,XMSUB,XMY,SUBSCR)	;SEND AN EMAIL
	;PARAMETERS: XMTEXT => STRING CONTAINING NAME OF ARRAY CONTAINING MESSAGE TEXT (REQUIRED)
	;            XMSUB  => STRING CONTAINING THE SUBJECT OF THE MESSAGE (REQUIRED)
	;            XMY    => REFERENCE TO AN ARRAY CONTAINING THE RECIPIENTS (OPTIONAL)
	;            SUBSCR => STRING CONTAINING THE SUBSCIPT WITHIN ^XTMP WHERE RECIPIENTS ARE STORED (OPTIONAL)
	;RETURN: $$MAIL => STRING CONTAINING XMMG (ERROR STRING)^XMERR (NUMBER OF ERRORS)
	N XMMG,XMDUZ,XMZ,XMERR,DIFROM,ORMSG
	Q:'$D(XMTEXT)!($G(XMSUB)="")
	I $D(XMY)=0 D
	.I $G(SUBSCR)'="",($Q(^XTMP(SUBSCR,0))[SUBSCR) D  Q
	..K ^XTMP(SUBSCR,0)
	..M XMY=^XTMP(SUBSCR)
	..K ^XTMP(SUBSCR)
	.I $D(ZTQUEUED)>0 D
	..S XMY(DUZ)=""
	.E  D
	..S ORMSG(1)=" "
	..S ORMSG(2)="Select the recipient(s) of the report below."
	..D MAILOUT(.ORMSG)
	N DUZ ;FORCE SENDER TO BE POSTMASTER
	D ^XMD ;ICR #10070
	K ORMSG
	I $D(XMMG)>0 D
	.S ORMSG(1)=" "
	.S ORMSG(2)="Unable to email the report:"
	.S ORMSG(3)=XMMG
	.D MAILOUT(.ORMSG)
	Q $G(XMMG)_U_$G(XMERR)
MAILOUT(MESSAGE)	;OUTPUT THE ORMSG ARRAY FROM MAIL LINE TAG
	;IF KIDS IS NOT EXECUTING, OUTPUT THE MESSAGE TO THE SCREEN
	I $G(XPDNM)="" D
	.N LINE S LINE=0 F  S LINE=$O(MESSAGE(LINE)) Q:+$G(LINE)=0  W MESSAGE(LINE),!
	E  D MES^XPDUTL(.MESSAGE)
	Q
WRAP(ORLINE,OROUTPUT)	;WRAP THE TEXT SO THAT IT IS NO MORE THAN IOM (80 OR 132) CHARACTERS WIDE
	;PARAMETERS: ORLINE  =>SINGLE LINE OF TEXT TO WRAP
	;            OROUTPUT=>NAME OF ARRAY THAT WILL STORE THE WRAPPED TEXT IN THE FORMAT:
	;                      OROUTPUT=NUMBER OF LINES OF TEXT RETURNED
	;                      OROUTPUT(N)=LINE N OF TEXT
	N ORRETURN,ORTEMP,ORTEMP1,ORCHR,ORINDENT,ORIOM
	S @OROUTPUT=1+$G(@OROUTPUT),ORIOM=$G(IOM)
	S:ORIOM="" ORIOM=80
	I ORLINE[":",($L($P(ORLINE,":"))<ORIOM) S ORINDENT=$$REPEAT^XLFSTR(" ",$L($P(ORLINE,":"))+2)
	I ORLINE'[":",($E(ORLINE,1)=" ") D
	.F ORCHR=1:1:$L(ORLINE) Q:$E(ORLINE,ORCHR)'=" "
	.S ORINDENT=$$REPEAT^XLFSTR(" ",ORCHR-1)
	I ORLINE'[":",($E(ORLINE,1)'=" ") D
	.N START,END
	.F ORCHR=1:1:$L(ORLINE) Q:+$G(END)  D
	..I '+$G(START),($E(ORLINE,ORCHR)=" "),($E(ORLINE,ORCHR+1)=" ") S START=1
	..I +$G(START),($E(ORLINE,ORCHR)'=" ") S END=1
	.S:+$G(START)>0 ORINDENT=$$REPEAT^XLFSTR(" ",ORCHR-2)
	S ORTEMP=1,ORTEMP(ORTEMP)=ORLINE
	F  Q:$L(ORTEMP(ORTEMP))<(ORIOM+1)  D
	.F ORCHR=ORIOM:-1:1 Q:$E(ORTEMP(ORTEMP),ORCHR)=" "
	.S:ORCHR=1 ORCHR=ORIOM
	.S ORTEMP1=ORTEMP(ORTEMP)
	.S ORTEMP(ORTEMP)=$E(ORTEMP1,1,ORCHR),ORTEMP=ORTEMP+1
	.;BEGIN WorldVistA Change 8/2015 DJW replace * with $L()
	.;was; S ORTEMP(ORTEMP)=$G(ORINDENT)_$E(ORTEMP1,ORCHR+1,*)
	.S ORTEMP(ORTEMP)=$G(ORINDENT)_$E(ORTEMP1,ORCHR+1,$L(ORTEMP1))
	.;END WorldVistA Change 
	S ORTEMP=0 F  S ORTEMP=$O(ORTEMP(ORTEMP)) Q:+ORTEMP=0  D
	.S:ORTEMP>1 @OROUTPUT=@OROUTPUT+1
	.S @OROUTPUT@(@OROUTPUT)=ORTEMP(ORTEMP)
	Q
DEVICE(ZTRTN,ZTDESC,%ZIS,ZTSAVE)	;PROMPT THE USER FOR THE OUTPUT DEVICE
	;PARAMETERS: ZTRTN  => LINE TAG THAT STARTS PRINTING THE REPORT
	;            ZTDESC => TASKMAN TASK DESCRIPTION
	;            %ZIS   => FLAGS TO PASS TO ^%ZIS
	;            ZTSAVE => VARIABLES TO SAVE FOR TASKMAN
	N POP,CBUFFER
	S %ZIS("B")="",CBUFFER=0
	D ^%ZIS
	Q:+$G(POP)
	I $D(IO("Q")) D  Q
	.N ZTSK,ORTEXT
	.S ORTEXT=$P(ZTDESC,"OR ",2)
	.S ZTSAVE("CBUFFER")=""
	.D ^%ZTLOAD,HOME^%ZIS
	.K IO("Q")
	.I +$G(ZTSK)>0 W !,"Successfully queued the "_ORTEXT_" report.",!,"Task Number: "_ZTSK,! H 2
	I '$D(IO("Q")) D 
	.U IO
	.I $E(IOST,1,2)="C-" W @IOF S CBUFFER=3
	.D @ZTRTN,^%ZISC
	Q
HEADER(TITLE,PAGE,HEADER)	;OUTPUT THE REPORT'S HEADER
	;PARAMETERS: TITLE  => THE TITLE OF THE REPORT
	;            PAGE   => (REFERENCE) PAGE NUMBER
	;            HEADER => (REFERENCE) COLUMN NAMES, FORMATTED AS:
	;                      COLUMN(LINE_NUMBER)=TEXT
	;                      NOTE: LINE_NUMBER STARTS AT ONE
	;RETURNS: 0 => USER WANTS TO CONTINUE PRINTING
	;         1 => USER DOES NOT WANT TO CONTINUE PRINTING
	I $D(ZTQUEUED),($$S^%ZTLOAD) D  Q 1
	.S ZTSTOP=$$S^%ZTLOAD("Received stop request"),ZTSTOP=1
	N X,END
	S PAGE=+$G(PAGE)+1
	I PAGE>1 D  Q:$G(END) 1
	.I $E(IOST,1,2)="C-" W !,"Press RETURN to continue or '^' to exit: " R X:DTIME S END='$T!(X="^") Q:$G(END)
	.W @IOF
	N NOW,INDEX
	S NOW=$$UP^XLFSTR($$HTE^XLFDT($H)),NOW=$P(NOW,"@",1)_"  "_$P($P(NOW,"@",2),":",1,2)
	W $$LJ^XLFSTR($E(TITLE,1,46),47," ")_NOW_"   PAGE "_PAGE,!
	S INDEX=0 F  S INDEX=$O(HEADER(INDEX)) Q:'INDEX  W HEADER(INDEX),!
	W $$REPEAT^XLFSTR("-",(IOM-1)),!
	Q 0
FMERROR(ERROR)	;OUTPUT FILEMAN ERROR
	;PARAMETERS: ERROR => (REFERENCE) ARRAY CONTAINING THE FILEMAN ERROR
	N OUT
	W !!,"Unable to generate the report due to the following FileMan error:",!
	W "FILEMAN ERROR #"_ERROR("DIERR",1)_":",!
	N IDX S IDX="" F  S IDX=$O(ERROR("DIERR",1,"TEXT",IDX)) Q:'IDX  D WRAP(ERROR("DIERR",1,"TEXT",IDX),"OUT")
	S IDX=0 F  S IDX=$O(OUT(IDX)) Q:+$G(IDX)=0  W OUT(IDX),!
	Q
DIVPRMPT(DIV)	;PROMPT THE USER FOR WHICH ACTIVE DIVISION(S)
	;PARAMETERS: DIV => REFERENCE TO ARRAY WHICH WILL CONTAIN THE SELECTED DIVISION(S) WHEN THIS FINISHES
	;                   FORMAT: DIV(FILE #4 IEN)=INSTITUTION NAME
	;                           IF THE USER SELECTS ALL DIVISIONS, THEN ONLY THE FOLLOWING IS RETURNED:
	;                           DIV("ALL")="all divisions"
	;RETURNS: -1 USER ENTERED CARET AT PROMPT IF SITE IS MULTIDIVISIONAL
	;          0 INSTITUTION FILE POINTER IS MISSING FOR ALL SELECTED DIVISIONS
	;          1 SUCCESSFUL SELECTION OF DIVISION(S)
	N SELDIV,BADDIV,TIUDI,IDX,DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT,COUNT,DELIMIT
	F  D  Q:+$G(SELDIV)=1!(+$G(SELDIV)=-1)
	.D SELDIV^TIULA
	.S IDX=0 F  S IDX=$O(TIUDI(IDX)) Q:+$G(IDX)=0  D
	..S DIV(TIUDI(IDX))=$P($$SITE^VASITE(,IDX),U,2),COUNT=1+$G(COUNT)
	.I SELDIV=1,('$D(DIV)) S DIV("ALL")="all divisions"
	.I $D(BADDIV) D
	..N TEXT,OUTPUT
	..S DELIMIT=", "
	..F IDX=1:1:$L(BADDIV,",")  D
	...S:IDX=$L(BADDIV,",") DELIMIT=" and "
	...S TEXT=$S($G(TEXT)'="":TEXT_DELIMIT,1:"")_$P(BADDIV,",",IDX)
	..S BADDIV="I'm sorry, but "_TEXT_" "_$S($L(BADDIV,",")=1:"is not a valid division.",$L(BADDIV,",")>1:"are not valid divisions.",1:"you selected an invalid division.")
	..D WRAP^ORUTL(BADDIV,"OUTPUT")
	..W !!
	..F IDX=1:1:OUTPUT W OUTPUT(IDX),!
	..I $D(DIV) D
	...S DIR(0)="Y"_U,DIR("A")="Do you want to continue with the valid division"_$S(COUNT>1:"s",1:"")_" already selected"
	...S DIR("B")="YES"
	...D ^DIR
	...Q:$D(DIRUT)
	...S:Y SELDIV=1
	Q SELDIV
HASDIV(Y,DIV)	;DETERMINE IF THE SPECIFIED USER BELONGS TO A SET OF DIVISIONS RETURNED BY DIVPRMPT^ORUTL
	;PARAMETERS: Y => IEN IN THE NEW PERSON FILE (#200)
	;            DIV => REFERENCE TO ARRAY CONTAINING SELECTED DIVISIONS
	;                   FORMAT: DIV(FILE #4 IEN)=INSTITUTION NAME
	;RETURNS: NAME OF Y'S DIVISION
	;         EMPTY STRING IF Y'S DIVISION IS NOT A SELECTED DIVISION
	N DIVISION S DIVISION=""
	I $D(DIV) D
	.N DIVISIONS,IDX,HASDIV
	.;IA #2533
	.S HASDIV=$$DIV4^XUSER(.DIVISIONS,Y)
	.I HASDIV=0 D
	..N IEN
	..S IEN=$P($$SITE^VASITE(),U,1)
	..S:+IEN=0 IEN=DUZ(2)
	..S DIVISIONS(IEN)=1
	.I $G(DIV("ALL"))="all divisions" D  Q
	..N IEN
	..S IEN=0 F  S IEN=$O(DIVISIONS(IEN)) Q:+$G(IEN)=0  D
	...S:DIVISIONS(IEN) DIVISION=$$GET1^DIQ(4,IEN_",",.01)
	..S:DIVISION="" DIVISION=$$GET1^DIQ(4,$O(DIVISIONS(0))_",",.01)
	.S IDX=0 F  S IDX=$O(DIVISIONS(IDX)) Q:+$G(IDX)=0  D
	..I $D(DIV(IDX)) D
	...I DIVISION'="",(DIVISIONS(IDX)=1) S DIVISION=DIV(IDX)
	...I DIVISION="" S DIVISION=DIV(IDX)
	Q DIVISION
