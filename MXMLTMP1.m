MXMLTMP1	; VEN/GPL - MXMLTMPL spill over;2013-08-13  1:22 PM
	;;2.2;XML PROCESSING UTILITIES;;May 18, 2014;Build 11
	;
INDEX(IZXML,VDX,NOINX,TEMPLATE,REDUX)	; parse XML in IZXML and produce 
	; an XPATH index; REDUX is a string to be removed from each xpath
	; ZEXCEPT: E1 ; XINDEX is making a mistake
	; GPL 7/14/09 OPTIONALLY GENERATE AN XML TEMPLATE IF PASSED BY NAME
	; TEMPLATE IS IDENTICAL TO THE PARSED XML LINE BY LINE
	; EXCEPT THAT DATA VALUES ARE REPLACED WITH @@XPATH@@ FOR THE XPATH OF THE TAG
	; GPL 5/24/09 AND OPTIONALLY PRODUCE THE VDX ARRAY PASSED BY NAME
	; @VDX@("XPATH")=VALUE
	; ex. @IZXML@("XPATH")=FIRSTLINE^LASTLINE
	; WHERE FIRSTLINE AND LASTLINE ARE THE BEGINNING AND ENDING OF THE
	; XML SECTION
	; IZXML IS PASSED BY NAME
	; IF NOINX IS SET TO 1, NO INDEX WILL BE GENERATED, BUT THE VDX WILL BE
	N I,LINE,FIRST,LAST,CUR,TMP,MDX,FOUND,CURVAL,DVDX,LCNT
	N MXMLSTK ; LEAVE OUT FOR DEBUGGING
	I '$D(REDUX) S REDUX=""
	I '$D(NOINX) S NOINX=0 ; IF NOT PASSED, GENERATE AN INDEX
	N ZXML
	I NOINX S ZXML=$NA(^TMP("MXMLINDEX",$J)) K @ZXML  ; TEMP PLACE FOR INDEX TO DISCARD
	E  S ZXML=IZXML ; PLACE FOR INDEX TO KEEP
	I '$D(@IZXML@(0)) D  ; IF COUNT NOT IN NODE 0 COUNT THEM
	. S I="",LCNT=0
	. F  S I=$O(@IZXML@(I)) Q:I=""  S LCNT=LCNT+1
	E  S LCNT=@IZXML@(0) ; LINE COUNT PASSED IN ARRAY
	I LCNT=0  D  Q  ; NO XML PASSED
	. D EN^DDIOL("ERROR IN XML FILE")
	S DVDX=0 ; DEFAULT DO NOT PRODUCE VDX INDEX
	I $D(VDX) S DVDX=1 ; IF NAME PASSED, DO VDX
	S MXMLSTK(0)=0 ; INITIALIZE STACK
	N LKASD ; KILL LOOKASIDE ARRAY
	D MKLASD(.LKASD,IZXML,LCNT) ;MAKE LOOK ASIDE BUFFER FOR MULTIPLES
	F I=1:1:LCNT  D  ; PROCESS THE ENTIRE ARRAY
	. S LINE=@IZXML@(I)
	. I $D(TEMPLATE) D  ;IF TEMPLATE IS REQUESTED
	. . S @TEMPLATE@(I)=$$CLEAN(LINE)
	. ;W LINE,!
	. S FOUND=0  ; INTIALIZED FOUND FLAG
	. I LINE?.E1"<!".E S FOUND=1 ; SKIP OVER COMMENTS
	. I FOUND'=1  D
	. . I (LINE?.E1"<"1.E1"</".E)!(LINE?.E1"<"1.E1"/>".E)  D
	. . . ; THIS IS THE CASE THERE SECTION BEGINS AND ENDS
	. . . ; ON THE SAME LINE
	. . . ; W "FOUND ",LINE,!
	. . . S FOUND=1  ; SET FOUND FLAG
	. . . S CUR=$$XNAME(LINE) ; EXTRACT THE NAME
	. . . S CUR=CUR_$G(LKASD(CUR,I)) ; HANDLE MULTIPLES
	. . . D PUSH("MXMLSTK",CUR) ; ADD TO THE STACK
	. . . D MKMDX("MXMLSTK",.MDX,REDUX) ; GENERATE THE M INDEX
	. . . ; W "MDX=",MDX,!
	. . . I $D(@ZXML@(MDX))  D  ; IN THE INDEX, IS A MULTIPLE
	. . . . ;I '$D(ZDUP(MDX)) S ZDUP(MDX)=2
	. . . . ;E  S ZDUP(MDX)=ZDUP(MDX)+1
	. . . . ;W "DUP:",MDX,!
	. . . . ;I '$D(CURVAL) S CURVAL=""
	. . . . ;I DVDX S @VDX@(MDX_"["_ZDUP(MDX)_"]")=CURVAL
	. . . . S $P(@ZXML@(MDX),"^",2)=I ; UPDATE LAST LINE NUMBER
	. . . I '$D(@ZXML@(MDX))  D  ; NOT IN THE INDEX, NOT A MULTIPLE
	. . . . S @ZXML@(MDX)=I_"^"_I  ; ADD INDEX ENTRY-FIRST AND LAST
	. . . . S CURVAL=$$XVAL(LINE) ; VALUE
	. . . . S $P(@ZXML@(MDX),"^",3)=CURVAL ; THIRD PIECE
	. . . . I DVDX S @VDX@(MDX)=CURVAL ; FILL IN VDX ARRAY IF REQUESTED
	. . . . I $D(TEMPLATE) D  ; IF TEMPLATE IS REQUESTED
	. . . . . S LINE=$$CLEAN(LINE) ; CLEAN OUT CONTROL CHARACTERS
	. . . . . S @TEMPLATE@(I)=$P(LINE,">",1)_">@@"_MDX_"@@</"_$P(LINE,"</",2)
	. . . D POP("MXMLSTK",.TMP) ; REMOVE FROM STACK
	. I FOUND'=1  D  ; THE LINE DOESN'T CONTAIN THE START AND END
	. . I LINE?.E1"</"1.E  D  ; LINE CONTAINS END OF A SECTION
	. . . ; W "FOUND ",LINE,!
	. . . S FOUND=1  ; SET FOUND FLAG
	. . . S CUR=$$XNAME(LINE) ; EXTRACT THE NAME
	. . . D MKMDX("MXMLSTK",.MDX) ; GENERATE THE M INDEX
	. . . S $P(@ZXML@(MDX),"^",2)=I ; UPDATE LAST LINE NUMBER
	. . . D POP("MXMLSTK",.TMP) ; REMOVE FROM STACK
	. . . S TMP=$P(TMP,"[",1) ; REMOVE [X] FROM MULTIPLE
	. . . I TMP'=CUR  D  ; MALFORMED XML, END MUST MATCH START
	. . . . D EN^DDIOL("MALFORMED XML "_CUR_" LINE "_I_LINE)
	. . . . D PARY^MXMLTMPL("MXMLSTK") ; PRINT OUT THE STACK FOR DEBUGING
	. . . . S $EC=",U-MALFORMED-XML,"
	. . . . Q
	. I FOUND'=1  D  ; THE LINE MIGHT CONTAIN A SECTION BEGINNING
	. . I (LINE?.E1"<"1.E)&(LINE'["?>")  D  ; BEGINNING OF A SECTION
	. . . ; W "FOUND ",LINE,!
	. . . S FOUND=1  ; SET FOUND FLAG
	. . . S CUR=$$XNAME(LINE) ; EXTRACT THE NAME
	. . . S CUR=CUR_$G(LKASD(CUR,I)) ; HANDLE MULTIPLES
	. . . D PUSH("MXMLSTK",CUR) ; ADD TO THE STACK
	. . . D MKMDX("MXMLSTK",.MDX) ; GENERATE THE M INDEX
	. . . ; W "MDX=",MDX,!
	. . . I $D(@ZXML@(MDX))  D  ; IN THE INDEX, IS A MULTIPLE
	. . . . S $P(@ZXML@(MDX),"^",2)=I ; UPDATE LAST LINE NUMBER
	. . . . ;B
	. . . I '$D(@ZXML@(MDX))  D  ; NOT IN THE INDEX, NOT A MULTIPLE
	. . . . S @ZXML@(MDX)=I_"^" ; INSERT INTO THE INDEX
	S @ZXML@("INDEXED")=""
	S @ZXML@("//")="1^"_LCNT ; ROOT XPATH
	I NOINX K @ZXML ; DELETE UNWANTED INDEX
	Q
MKLASD(OUTBUF,INARY,LCNT)	; CREATE A LOOKASIDE BUFFER FOR MULTILPLES
	; ZEXCEPT: E1 ; XINDEX is making a mistake
	N ZI,ZN,ZA,ZLINE,ZLINE2,CUR,CUR2
	F ZI=1:1:LCNT-1  D  ; PROCESS THE ENTIRE ARRAY 
	. S ZLINE=@INARY@(ZI)
	. I ZI<LCNT S ZLINE2=@INARY@(ZI+1)
	. I ZLINE?.E1"</"1.E  D  ; NEXT LINE CONTAINS END OF A SECTION
	. . S CUR=$$XNAME(ZLINE) ; EXTRACT THE NAME
	. . I (ZLINE2?.E1"<"1.E)&(ZLINE'["?>")  D  ; BEGINNING OF A SECTION
	. . . S CUR2=$$XNAME(ZLINE2) ; EXTRACT THE NAME 
	. . . I CUR=CUR2 D  ; IF THIS IS A MULTIPLE
	. . . . S OUTBUF(CUR,ZI+1)=""
	;ZWR OUTBUF
	S ZI=""
	F  S ZI=$O(OUTBUF(ZI)) Q:ZI=""  D  ; FOR EACH KIND OF MULTIPLE
	. S ZN=$O(OUTBUF(ZI,"")) ; LINE NUMBER OF SECOND MULTIPLE
	. F  S ZN=$O(@INARY@(ZN),-1) Q:ZN=""  I $E($P(@INARY@(ZN),"<"_ZI,2),1,1)=">" Q  ;
	. S OUTBUF(ZI,ZN)=""
	S ZA=1,ZI="",ZN=""
	F  S ZI=$O(OUTBUF(ZI)) Q:ZI=""  D  ; ADDING THE COUNT FOR THE MULIPLES [x]
	. S ZN="",ZA=1
	. F  S ZN=$O(OUTBUF(ZI,ZN)) Q:ZN=""  D  ;
	. . S OUTBUF(ZI,ZN)="["_ZA_"]"
	. . S ZA=ZA+1
	Q
	;
	;
CLEAN(STR,TR)	; extrinsic function; returns string
	;; Removes all non printable characters from a string.
	;; STR by Value
	;; TR IS OPTIONAL TO IMPROVE PERFORMANCE
	N TR,I
	I '$D(TR) D  ;
	. F I=0:1:31 S TR=$G(TR)_$C(I)
	. S TR=TR_$C(127)
	QUIT $TR(STR,TR)
	;
XNAME(ISTR)	    ; FUNCTION TO EXTRACT A NAME FROM AN XML FRAG
	; ZEXCEPT: E1 ; XINDEX is making a mistake
	;  </NAME> AND <NAME ID=XNAME> WILL RETURN NAME
	; ISTR IS PASSED BY VALUE
	N CUR,TMP
	I ISTR?.E1"<".E  D  ; STRIP OFF LEFT BRACKET
	. S TMP=$P(ISTR,"<",2)
	I TMP?1"/".E  D  ; ALSO STRIP OFF SLASH IF PRESENT IE </NAME>
	. S TMP=$P(TMP,"/",2)
	S CUR=$P(TMP,">",1) ; EXTRACT THE NAME
	; W "CUR= ",CUR,!
	I CUR?.1"_"1.A1" ".E  D  ; CONTAINS A BLANK IE NAME ID=TEST>
	. S CUR=$P(CUR," ",1) ; STRIP OUT BLANK AND AFTER
	; W "CUR2= ",CUR,!
	Q CUR
	;
XVAL(ISTR)	; EXTRACTS THE VALUE FROM A FRAGMENT OF XML
	; <NAME>VALUE</NAME> WILL RETURN VALUE
	N G
	S G=$P(ISTR,">",2) ;STRIP OFF <NAME>
	Q $P(G,"<",1) ; STRIP OFF </NAME> LEAVING VALUE
	;
MKMDX(STK,RTN,INREDUX)	 ; MAKES A MUMPS INDEX FROM THE ARRAY STK
	; RTN IS SET TO //FIRST/SECOND/THIRD FOR THREE ARRAY ELEMENTS
	; REDUX IS A STRING TO REMOVE FROM THE RESULT
	S RTN=""
	N I
	; W "STK= ",STK,!
	I @STK@(0)>0  D  ; IF THE ARRAY IS NOT EMPTY
	. S RTN="//"_@STK@(1) ; FIRST ELEMENT NEEDS NO SEMICOLON
	. I @STK@(0)>1  D  ; SUBSEQUENT ELEMENTS NEED A SEMICOLON
	. . F I=2:1:@STK@(0) S RTN=RTN_"/"_@STK@(I)
	I $G(INREDUX)'="" S RTN=$P(RTN,INREDUX,1)_$P(RTN,INREDUX,2)
	Q
	;
PUSH(STK,VAL)	  ; pushs VAL onto STK and updates STK(0)
	;  VAL IS A STRING AND STK IS PASSED BY NAME
	;
	I '$D(@STK@(0)) S @STK@(0)=0 ; IF THE ARRAY IS EMPTY, INITIALIZE
	S @STK@(0)=@STK@(0)+1 ; INCREMENT ARRAY DEPTH
	S @STK@(@STK@(0))=VAL ; PUT VAL A THE END OF THE ARRAY
	Q
	;
POP(STK,VAL)	   ; POPS THE LAST VALUE OFF THE STK AND RETURNS IT IN VAL
	; VAL AND STK ARE PASSED BY REFERENCE
	;
	I @STK@(0)<1 D  ; IF ARRAY IS EMPTY
	. S VAL=""
	. S @STK@(0)=0
	I @STK@(0)>0  D  ;
	. S VAL=@STK@(@STK@(0))
	. K @STK@(@STK@(0))
	. S @STK@(0)=@STK@(0)-1 ; NEW DEPTH OF THE ARRAY
	Q
	;
PUSHA(ADEST,ASRC)	; PUSH ASRC ONTO ADEST, BOTH PASSED BY NAME
	;
	N ZGI
	F ZGI=1:1:@ASRC@(0) D  ; FOR ALL OF THE SOURCE ARRAY
	. D PUSH(ADEST,@ASRC@(ZGI)) ; PUSH ONE ELEMENT
	Q
	;
TRIM(THEXML)	; TAKES OUT ALL NULL ELEMENTS
	; THEXML IS PASSED BY NAME
	; ZEXCEPT: MXMLDEBUG
	N I,J,TMPXML,DEL,FOUND
	S FOUND=0
	I $G(MXMLDEBUG) D EN^DDIOL("DELETING EMPTY ELEMENTS")
	F I=1:1:(@THEXML@(0)-1) D  ; LOOP THROUGH ENTIRE ARRAY
	. S J=@THEXML@(I)
	. N JM,JP,JPX ; JMINUS AND JPLUS
	. S JM=@THEXML@(I-1) ; LINE BEFORE
	. S JP=@THEXML@(I+1) ; LINE AFTER
	. S JPX=$TR(JP,"/") ; REMOVE THE SLASH
	. I J=JPX D  ; AN EMPTY ELEMENT ON TWO LINES (<tag>\n</tag>)
	. . I $G(MXMLDEBUG) D EN^DDIOL(I_J_JP)
	. . S FOUND=1 ; FOUND SOMETHING TO BE DELETED
	. . S DEL(I)="" ; SET LINE TO DELETE
	. . S DEL(I+1)="" ; SET NEXT LINE TO DELETE
	. I J["><" D  ; AN EMPTY ELEMENT ON ONE LINE (<tag></tag>)
	. . I $G(MXMLDEBUG) D EN^DDIOL(I_J)
	. . S FOUND=1 ; FOUND SOMETHING TO BE DELETED
	. . S DEL(I)="" ; SET THE EMPTY LINE UP TO BE DELETED
	. . I JM=JPX D  ; if surrounding tags only contained us, and we're deleted, remove surrounding tags too.
	. . . I $G(MXMLDEBUG) D EN^DDIOL(I_JM_J_JPX)
	. . . S DEL(I-1)=""
	. . . S DEL(I+1)="" ; SET THE SURROUNDING LINES FOR DEL
	; I J'["><" D PUSH("TMPXML",J)
	I FOUND D  ; NEED TO DELETE THINGS
	. F I=1:1:@THEXML@(0) D  ; COPY ARRAY LEAVING OUT DELELTED LINES
	. . I '$D(DEL(I)) D  ; IF THE LINE IS NOT DELETED
	. . . D PUSH("TMPXML",@THEXML@(I)) ; COPY TO TMPXML ARRAY
	. D CP^MXMLTMPL("TMPXML",THEXML) ; REPLACE THE XML WITH THE COPY
	Q:$Q FOUND Q
	;
