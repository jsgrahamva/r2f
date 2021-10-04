TMGMISC2	;TMG/kst/sacc-COMPLIANT Misc utility library ;10/9/12
	        ;;1.0;TMG-LIB;**1**;7/23/12;Build 8
	;"
	;"TMG MISCELLANEOUS FUNCTIONS
	;"SACC-Compliant version
	;"Kevin Toppenberg MD
	;"GNU General Public License (GPL) applies
	;"7-23-2012
	;"
	;"NOTE: This will contain SACC-compliant versions of code from TMGMISC
	;"      If routine is not found here, the please migrate and update the
	;"      code to be compliant.
	;"
	;"=======================================================================
	;" API -- Public Functions.
	;"=======================================================================
	;"LISTCT(PARRAY) -- Count the number of entries in an array
	;"ZWRITE(NAME) ;-- Replacement for GT.M's ZWRITE
	;"$$DTFORMAT(FMDATE,FORMAT) -- FORMAT fileman dates
	;"
	;"=======================================================================
	;"PRIVATE API FUNCTIONS
	;"=======================================================================
	;"DOTOKEN(FMDATE,TOKEN,OUTPUT,ARRAY)
	;"
	;"=======================================================================
	;"DEPENDENCIES: ^XLFDT
	;"
	;"=======================================================================
	;"=======================================================================
	;"
LISTCT(PARRAY)	;" SAAC complient entry point.
	       ;"SCOPE: PUBLIC
	       ;"Purpose: to count the number of entries in an array
	       ;"Input: PARRAY -- PASS BY NAME.  pointer to (name of) array to test.
	       ;"OUTPUT: the number of entries at highest level
	       ;"      e.g.  ARRAY("TELEPHONE")=1234
	       ;"            ARRAY("CAR")=4764
	       ;"            ARRAY("DOG")=5213
	       ;"            ARRAY("DOG","COLLAR")=5213  <-- not highest level,not counted.
	       ;"        The above array would have a count of 3
	       ;"Results: returns count, or count up to point of any error
	       NEW I
	       NEW RESULT SET RESULT=0
	       DO
	       . NEW $ETRAP
	       . SET $ETRAP="WRITE ""?? Error Trapped ??"",! SET $ECODE="""" QUIT"
	       . SET I=$ORDER(@PARRAY@("")) QUIT:I=""
	       . FOR  SET RESULT=RESULT+1 SET I=$ORDER(@PARRAY@(I)) QUIT:I=""
	       QUIT RESULT
	       ;
ZWRITE(NAME)	;" Replacement for ZWRITE
	       ;"Public Procedure
	       ;"Written by Sam Habiel and posted on Google Group Hardhats on 8/2/2012
	       ;"Input: NAME -- reference to write out.
	       ;"               Pass NAME by name as a closed reference.
	       ;"               lvn and gvn are both supported.
	       ;"Note:  ':' syntax is not supported (yet)
	       ;
	       NEW L SET L=$L(NAME) ;" Name length
	       ;"If last sub is *, remove it and close the ref
	       IF $EXTRACT(NAME,L-2,L)=",*)" SET NAME=$EXTRACT(NAME,1,L-3)_")"
	       ;"Get last subscript upon which we can't loop further
	       NEW ORIGLAST SET ORIGLAST=$QSUBSCRIPT(NAME,$QLENGTH(NAME))
	       ;"Number of subscripts in The original name
	       NEW ORIGQL SET ORIGQL=$QLENGTH(NAME)
	       ;" Write base if it exists
	       IF $DATA(@NAME)#2 WRITE NAME,"=",$$FORMAT(@NAME),!
	       ;"$QUERY through the name.
	       ;"Stop when we are out.
	       ;"  Stop when the last subscript of the original name isn't the same as
	       ;"  the last subscript of the Name.
	       FOR  SET NAME=$QUERY(@NAME) Q:NAME=""  Q:$QSUBSCRIPT(NAME,ORIGQL)'=ORIGLAST  DO
	       . WRITE NAME,"=",$$FORMAT(@NAME),!
	       QUIT
	       ;
FORMAT(V)	;"Format reference
	       ;"Purpose: Add quotes, replace control characters if necessary;
	       ;"Public function
	       ;"Written by Sam Habiel and posted on Google Group Hardhats on 8/2/2012
	       ;"If numeric, nothing to do.
	       ;"If no encoding required, then return as quoted string.
	       ;"Otherwise, return as an expression with $C()'s and strings.
	       ;
	       IF +V=V QUIT V ;" If numeric, just return the value.
	       NEW QT SET QT="""" ;" Quote
	       I $F(V,QT) DO     ;"Check if V contains any quotes
	       . SET P=0          ;"position pointer into V
	       . FOR  SET P=$F(V,QT,P) QUIT:'P  DO  ;"find next "
	       . . SET $E(V,P-1)=QT_QT        ;"double each "
	       . . SET P=P+1                  ;"skip over new "
	       IF $$CCC(V) DO  QUIT V  ;" If control character is present do this and quit
	       . ;"Replace control characters in "V"
	       . SET V=$$RCC(QT_V_QT)
	       . ;"Replace doubled up quotes at start
	       . SET:$EXTRACT(V,1,3)="""""_" $EXTRACT(V,1,3)=""
	       . SET L=$LENGTH(V)
	       . ;"Replace doubled up quotes at end
	       . SET:$EXTRACT(V,L-2,L)="_""""" $EXTRACT(V,L-2,L)=""
	       ;"If no control characters, quit with "V"
	       QUIT QT_V_QT
	       ;
CCC(S)	;
	       ;"Purpose: Test if S Contains a Control Character or $C(255);
	       ;"Public function
	       ;"Written by Sam Habiel and posted on Google Group Hardhats on 8/2/2012
	       QUIT:S?.E1C.E 1
	       QUIT:$FIND(S,$C(255)) 1
	       QUIT 0
	       ;
RCC(NA)	;
	       ;"Purpose: Replace control chars in NA with '$C( )'. Returns encoded string;
	       ;"Public function
	       QUIT:'$$CCC(NA) NA                              ;"No embedded ctrl chars
	       NEW OUT SET OUT=""                              ;"Holds output name
	       NEW CC SET CC=0                                 ;"Vount ctrl chars in $C(
	       NEW C                                           ;"Temp hold each char
	       FOR I=1:1:$L(NA) SET C=$E(NA,I) DO              ;"For each char C in NA
	       . IF (C'?1C),(C'=C255) DO  SET OUT=OUT_C QUIT   ;"Not a ctrl char
	       . . IF CC SET OUT=OUT_")_""",CC=0               ;"Vlose up $C(... if one is open
	       . IF CC DO
	       . . IF CC=256 SET OUT=OUT_")_$C("_$A(C),CC=0    ;"Max args in one $C(
	       . . ELSE  SET OUT=OUT_","_$A(C)                 ;"Add next ctrl char to $C(
	       . ELSE  SET OUT=OUT_"""_$C("_$A(C)
	       . SET CC=CC+1
	       . QUIT
	       QUIT OUT
	       ;
DTFORMAT(FMDATE,FORMAT,ARRAY)	;
	       ;"SCOPE: PUBLIC
	       ;"Purpose: to allow custom formating of fileman dates in to text equivalents
	       ;"Note: Sometime, compare this function to $$DATE^TIULS ... 
	       ;"Input:   FMDATE -- this is the date to work on, in Fileman Format
	       ;"         FORMAT -- a formating string with codes as follows.
	       ;"                yy -- 2 digit year
	       ;"                yyyy --  4 digit year
	       ;"                m - month number without a leading 0.
	       ;"                mm -- 2 digit month number (01-12)
	       ;"                mmm - abreviated months (Jan,Feb,Mar etc.)
	       ;"                mmmm -- full names of months (January,February,March etc)
	       ;"                d -- the number of the day of the month (1-31) without a leading 0
	       ;"                dd -- 2 digit number of the day of the month
	       ;"                w -- the numeric day of the week (0-6)
	       ;"                ww -- abreviated day of week (Mon,Tue,Wed)
	       ;"                www -- day of week (Monday,Tuesday,Wednesday)
	       ;"                h -- the number of the hour without a leading 0 (1-23) 24-hr clock mode
	       ;"                hh -- 2 digit number of the hour.  24-hr clock mode
	       ;"                H -- the number of the hour without a leading 0 (1-12) 12-hr clock mode
	       ;"                HH -- 2 digit number of the hour.  12-hr clock mode
	       ;"                # -- will display 'am' for hours 1-12 and 'pm' for hours 13-24
	       ;"                M - the number of minutes with out a leading 0
	       ;"                MM -- a 2 digit display of minutes
	       ;"                s - the number of seconds without a leading 0
	       ;"                ss -- a 2 digit display of number of seconds.
	       ;"                allowed punctuation symbols--   ' ' : , / @ .;- (space, colon, comma, forward slash, at symbol,semicolon,period,hyphen)
	       ;"                'text' is included as is, even if it is same as a formatting code
	       ;"                Other unexpected text will be ignored
	       ;"
	       ;"                If a date value of 0 is found for a code, that code is ignored (except for min/sec)
	       ;"
	       ;"                Examples:  with FMDATE=3050215.183000  (i.e. Feb 5, 2005 @ 18:30  0 sec)
	       ;"                "mmmm d,yyyy" --> "February 5,2005"
	       ;"                "mm d,yyyy" --> "Feb 5,2005"
	       ;"                "'Exactly' H:MM # 'on' mm/dd/yy" --> "Exactly 6:30 pm on 02/05/05"
	       ;"                "mm/dd/yyyy" --> "02/05/2005"
	       ;"
	       ;"         ARRAY -- OPTIONAL, if supplied, SHOULD BE PASSED BY REFERENCE
	       ;"              The array will be filled with data as follows:
	       ;"              ARRAY(TOKEN)=value for that token  (ignores codes such as '/',':' ect)
	       ;"OUTPUT: Text of date, as specified by above
	       NEW RESULT SET RESULT=""
	       NEW TOKEN SET TOKEN=""
	       NEW LASTTOKEN SET LASTTOKEN=""
	       NEW CH SET CH=""
	       NEW LASTCH SET LASTCH=""
	       NEW INSTR SET INSTR=0
	       NEW DONE SET DONE=0
	       NEW IDX
	       IF $GET(FORMAT)="" GOTO FDTDONE
	       IF +$GET(FMDATE)=0 GOTO FDTDONE
	       FOR IDX=1:1:$LENGTH(FORMAT) DO  QUIT:DONE
	       . SET LASTCH=CH
	       . SET CH=$EXTRACT(FORMAT,IDX)   ;"get next char of format string.
	       . IF (CH'=LASTCH)&(LASTCH'="")&(INSTR=0) DO DOTOKEN(FMDATE,.TOKEN,.RESULT,.ARRAY)
	       . SET TOKEN=TOKEN_CH
	       . IF CH="'" DO  QUIT
	       . . IF INSTR DO DOTOKEN(FMDATE,.TOKEN,.RESULT)
	       . . SET INSTR='INSTR  ;"toggle In-String mode
	       . IF (IDX=$LENGTH(FORMAT)) DO DOTOKEN(FMDATE,.TOKEN,.RESULT,.ARRAY)
FDTDONE	QUIT RESULT
	       ;
DOTOKEN(FMDATE,TOKEN,OUTPUT,ARRAY)	;
	       ;"SCOPE: PRIVATE
	       ;"Purpose: To take tokens and build output following rules specified by DTFormat
	       ;"Input: FMDATE -- the date to work with
	       ;"          TOKEN -- SHOULD BE PASSED BY REFERENCE.  The code as oulined in DTFormat
	       ;"          OUTPUT -- SHOULD BE PASSED BY REFERENCE. The cumulative output
	       ;"          ARRAY -- OPTIONAL, IF supplied, SHOULD BE PASSED BY REFERENCE
	       ;"              The array will be filled with data as follows:
	       ;"              ARRAY(TOKEN)=value for that token  (ignores codes such as '/')
	       ;"Result: none
	       IF $EXTRACT(TOKEN,1,1)="'" DO  GOTO PTDONE
	       . NEW STR SET STR=$EXTRACT(TOKEN,2,$LENGTH(TOKEN)-1)
	       . SET OUTPUT=OUTPUT_STR
	       IF ($LENGTH(TOKEN)=1)&(" .:/;,-@"[TOKEN) SET OUTPUT=OUTPUT_TOKEN GOTO PTDONE
	       ;
	       IF "yyyy"[TOKEN DO  GOTO PTDONE
	       . NEW YEAR SET YEAR=+$EXTRACT(FMDATE,1,3)
	       . IF YEAR=0 QUIT
	       . IF TOKEN="yy" DO
	       . . SET YEAR=+$EXTRACT(FMDATE,2,3)
	       . . IF YEAR<10 SET YEAR="0"_YEAR
	       . ELSE  DO
	       . . SET YEAR=YEAR+1700
	       . SET OUTPUT=OUTPUT_YEAR
	       . SET ARRAY(TOKEN)=YEAR
	       ;
	       IF "mmmm"[TOKEN DO  GOTO PTDONE
	       . NEW MONTH SET MONTH=+$EXTRACT(FMDATE,4,5)
	       . IF MONTH=0 QUIT
	       . IF TOKEN="mm" DO
	       . . IF MONTH<10 SET MONTH="0"_MONTH
	       . ELSE  IF TOKEN="mmm" DO
	       . . SET MONTH=$PIECE("Jan^Feb^Mar^Apr^May^Jun^Jul^Aug^Sept^Oct^Nov^Dec","^",MONTH)
	       . ELSE  IF TOKEN="mmmm" DO
	       . . SET MONTH=$PIECE("January^February^March^April^May^June^July^August^September^October^November^December","^",MONTH)
	       . SET OUTPUT=OUTPUT_MONTH
	       . SET ARRAY(TOKEN)=MONTH
	       ;
	       IF "dd"[TOKEN DO  GOTO PTDONE
	       . NEW DAY SET DAY=+$EXTRACT(FMDATE,6,7)
	       . IF TOKEN="dd" DO
	       . . IF DAY<10 SET DAY="0"_DAY
	       . SET OUTPUT=OUTPUT_DAY
	       . SET ARRAY(TOKEN)=DAY
	       ;
	       IF "www"[TOKEN DO  GOTO PTDONE
	       . NEW DOW SET DOW=$$DOW^XLFDT(FMDATE,1)
	       . IF (DOW<0)!(DOW>6) QUIT
	       . NEW DOWS SET DOWS=$PIECE("Sun^Mon^Tue^Wed^Thur^Fri^Sat","^",DOW+1)
	       . IF TOKEN="ww" SET DOW=DOWS
	       . IF TOKEN="www" SET DOW=DOWS_"day"
	       . SET OUTPUT=OUTPUT_DOW
	       . SET ARRAY(TOKEN)=DOW
	       ;
	       IF "hh"[TOKEN DO  GOTO PTDONE
	       . NEW HOUR SET HOUR=+$EXTRACT(FMDATE,9,10)
	       . IF HOUR=0 QUIT
	       . IF TOKEN="hh",(HOUR<10) SET HOUR="0"_HOUR
	       . SET OUTPUT=OUTPUT_HOUR
	       . SET ARRAY(TOKEN)=HOUR
	       ;
	       IF "HH"[TOKEN DO  GOTO PTDONE
	       . NEW HOUR SET HOUR=+$EXTRACT(FMDATE,9,10)
	       . IF HOUR=0 QUIT
	       . IF HOUR>12 SET HOUR=HOUR-12
	       . IF TOKEN="HH",(HOUR<10) SET HOUR="0"_HOUR
	       . SET OUTPUT=OUTPUT_HOUR
	       . SET ARRAY(TOKEN)=HOUR
	       ;
	       IF TOKEN="#" DO  GOTO PTDONE
	       . NEW HOUR SET HOUR=+$EXTRACT(FMDATE,9,10)
	       . IF HOUR=0 QUIT
	       . NEW CODE SET CODE=$SELECT(HOUR>12:"pm",1:"am")
	       . SET OUTPUT=OUTPUT_CODE
	       . SET ARRAY(TOKEN)=CODE
	       ;
	       IF "MM"[TOKEN DO  GOTO PTDONE
	       . NEW MIN SET MIN=+$EXTRACT(FMDATE,11,12)
	       . IF TOKEN="MM",(MIN<10) SET MIN="0"_MIN
	       . SET OUTPUT=OUTPUT_MIN
	       . SET ARRAY(TOKEN)=MIN
	       ;
	       IF "ss"[TOKEN DO  GOTO PTDONE
	       . NEW SEC SET SEC=+$EXTRACT(FMDATE,13,14)
	       . IF TOKEN="ss",(SEC<10) SET SEC="0"_SEC
	       . SET OUTPUT=OUTPUT_SEC
	       . SET ARRAY(TOKEN)=SEC
	       ;
PTDONE	 SET TOKEN=""
	       QUIT
	       ;
