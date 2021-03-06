C0CMAIL	; Communications for MIME Documents and MultiMIME ; 3110420 ; rcr/rcr
V	;;1.2;CCD/CCR GENERATION UTILITIES;;Oct 30, 2012;Build 51
	;Copyright 2011 Chris Richardson, Richardson Computer Research
	; Modified 3110516@1818
	;   rcr@rcresearch.us
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
	;  ------------------
	;Entry Points
	; GETMSG^C0CMAIL(.C0CDATA,.C0CINPUT)
	;  Input:
	;    C0CINPUT = "DUZ;MAILBOX_Name[or IEN for box (comma Separated);MALL
	;                      or "*" for all boxes, default is "IN" if missing]"
	;                $P(C0CINPUT,";",3)=MALL, default=NUL means "New only",
	;                                     "*" for All or 9,999 maximum
	;                    MALL?1.n = that number of the n most recent
	;  Internally:
	;    BNAM = Box Name
	;  Output:
	;    C0CDATA
	;      = (BNAM,"NUMBER") = Number of NEW Emails in Basket
	;        (BNAM,"MSG",C0CIEN,"FROM")=Name
	;        (BNAM,"MSG",C0CIEN,"TO",n)=DUZ, or EMAIL Address
	;        (BNAM,"MSG",C0CIEN,"TO NAME",n)=Names or EMAIL Address
	;        (BNAM,"MSG",C0CIEN,"TITLE")=EMAIL Title
	;        (BNAM,"MSG",C0CIEN[for File 3.9])=Number of Attachments
	;        (BNAM,"MSG",C0CIEN,num,"CONT") = Free Text
	;        (BNAM,"MSG",C0CIEN,num,"LINES") = Number of Lines of Text
	;        (BNAM,"MSG",C0CIEN,num,"SIZE") = Size of the Message in Bytes
	;        (BNAM,"MSG",C0CIEN,num,"TXT",LINE#) = Message Data (No Attachment)
	;   (BNAM,"MSG",C0CIEN,"SEG",NUM) = First Line^Last Line
	;   (BNAM,"MSG",C0CIEN,"SEG",NUM,"CONT",type) = Message Details
	;   (BNAM,"MSG",C0CIEN,"SEG",NUM,LINE#) = Message Data
	; 
	; DO DETAIL^C0CMAIL(.OUTBF,D0) ; For each Email Message and Attachments
	;   Input;
	;     D0     - The IEN for the message in file 3.9, MESSAGE global
	;   Output
	;     OUTBF  - The array of your choice to save the expanded and decoded message.
	; 
GETMSG(C0CDATA,C0CINPUT)	; Common Entry Point for Mailbox Data
	K:'$G(C0CDATA("KEEP")) C0CDATA
	N U
	S U="^"
	D:$G(C0CINPUT)
	. N BF,DUZ,I,INPUT,J,L,LST,MBLST,MALL
	. S INPUT=C0CINPUT
	. S DUZ=+INPUT
	. D:$D(^XMB(3.7,DUZ,0))#2
	. . S MBLST=$P(INPUT,";",2)
	. . S MALL=$P(INPUT,";",3) ; New or All Mail Flag
	. . S:MALL["*" MALL=99999
	. . ; Only one of these can be correct
	. . D
	. . . ;  If nul, make it "IN" only
	. . . I MBLST="" D  QUIT
	. . . . S MBLST("IN")=0,I=0
	. . . . D GATHER(DUZ,"IN",.LST)
	. . . .QUIT
	. . . ;
	. . . ;  If "*", Get all Mailboxes and look for New Messages
	. . . I MBLST["*" D  QUIT
	. . . . N NAM,NUM
	. . . . S NUM=0
	. . . . F  S NUM=$O(^XMB(3.7,DUZ,2,NUM)) Q:'NUM  D
	. . . . . S NAM=$P(^XMB(3.7,DUZ,2,NUM,0),U)
	. . . . . D GATHER(DUZ,NAM,.LST)
	. . . . .QUIT
	. . . .QUIT
	. . . ;
	. . . ;  If comma separated, look for mailboxes with new messages
	. . . I $L(MBLST,",")>1 D  QUIT
	. . . . S NAM=""
	. . . . N T,V
	. . . . F T=1:1:$L(MBLST,",")  S V=$P(MBLST,",",T)  I $L(V) D
	. . . . . I V S NAM=$P($G(^XMB(3.7,DUZ,2,V,0)),U)
	. . . . . S:NAM="" NAM=V
	. . . . . D GATHER(DUZ,NAM,.LST)
	. . . . .QUIT
	. . . .QUIT
	. . . ;
	. . . ;  If only 1 mailbox named, go get it
	. . . I $L(MBLST) D GATHER(DUZ,MBLST,.LST) QUIT
	. . .QUIT
	. . MERGE C0CDATA=LST
	. .QUIT
	.QUIT
	QUIT
	;  ===================
GATHER(DUZ,NAM,LST)	; Gather Data about the Baskets and their mail
	N I,J,K,L
	S (I,K)=0
	S J=$O(^XMB(3.7,DUZ,2,"B",NAM,""))
	F  S I=$O(^XMB(3.7,DUZ,2,J,1,I)) Q:'I  D
	. S L=$P(^XMB(3.7,DUZ,2,J,1,I,0),U,3)
	. D   ; :L
	. . S:L K=K+1,LST(NAM,"MSG",I,"NEW")=""  ; Flag NEW emails
	. . S LST(NAM,"MSG",I)=L
	. . D GETTYP(I)
	. .QUIT
	.QUIT
	S LST(NAM,"NUMBER")=K
	QUIT
	;  ===================
	; D0 is the IEN into the Message Global ^XMB(3.9,D0)
	; The products of these emails are scanned to identify
	;  the number of documents stored in the MIME package.
	;  The protocol runs like this;
	; Line 1 is the --separator
	; Line 2 thru n >Look for Content-[detail type:]Description ; Next CMD
	; Line n+2 thru t-1 where t does NOT have "Content-"
	; Line t   is Next Section Terminator, or Message Terminator, --separator
	; Line t+1 should not exist in the data set if Message Terminator
	; CON = "Content-"
	; FLG = "--"
	; SEP = FLG+7 or more characters  ; Separator
	; END = SEP+FLG
	; SGC = Segment Count
	; Note: separator is a string of specific characters of
	;        indeterminate length  
	; LST() the transfer array
	; LST(NAM,"MSG",C0CIEN,"SEG",SGN)=Starting Line^Ending Line
	; LST(NAM,"MSG",C0CIEN,"SEG",SGN,1:n)=Decoded Message Data
	;
GETTYP(D0)	; Look for the goodies in the Mail
	N I,J,N,BCN,CON,CNT,D1,END,FLG,SEP,SGC,XX,XXNM
	S CON="Content-"
	S FLG="--"
	S SEP=""  ; Start SEP as null, so we can use this to help identify the type
	S (BCN,CNT,D1,END,SGC)=0
	S XX=$G(^XMB(3.9,D0,0))
	S LST(NAM,"MSG",D0,"TITLE")=$P($G(^XMB(3.9,D0,0)),U,1)
	S LST(NAM,"MSG",D0,"CREATED")=$G(^XMB(3.9,D0,.6))
	F I=4,2 S XXNM=$P(XX,U,I)  Q:$L(XXNM)
	S LST(NAM,"MSG",D0,"FROM")=$$NAME(XXNM)
	S LST(NAM,"MSG",D0,"SENT")=$$TIME($P(XX,U,3))
	; Get the folks the email is sent to.
	S D1=0
	F  S D1=$O(^XMB(3.9,D0,1,D1)) Q:'D1  D
	. N T
	. S T=+$G(^XMB(3.9,D0,1,D1,0))
	. S:T T=$P($G(^VA(200,+T,0)),"^")
	. S LST("TO",D1)=T
	. S T=$G(^XMB(3.9,D0,6,D1,0))
	. S:T T=$P($G(^VA(200,+T,0)),"^")
	. S:T="" T="<Unknown>"
	. S LST("TO NAME",D1)=T
	.QUIT
	; Preload first Segment (0) with beginning on Line 1
	;  if not a 64bit
	S LST(NAM,"MSG",D0,"SEG",0)=1
	S D1=.9999,SEP="--"
	F  S D1=$O(^XMB(3.9,D0,2,D1)) Q:'D1  D
	. ; Clear any control characters (cr/lf/ff) off
	. S X=$TR($G(^XMB(3.9,D0,2,D1,0)),$C(10,12,13))
	. ; Enter once to set the SEP to capture the separator
	. I SEP=FLG&($E(X,1,2)=FLG)&($L(X,FLG)=2)&($L($P(X,FLG,2)>5))   D   Q
	. . S SEP=X,END=X_FLG
	. . S (CNT,SGC)=1,BCN=0
	. . S LST(NAM,"MSG",D0,"SEG",SGC)=D1
	. .QUIT
	. ;
	. ; A new separator is set, process original 
	. I X=SEP  D  QUIT
	. . S LST(NAM,"MSG",D0,SGC,"SIZE")=BCN
	. . S LST(NAM,"MSG",D0,"SEG",SGC)=$G(LST(NAM,"MSG",D0,"SEG",SGC))_"^"_(D1-1)
	. . S SGC=SGC+1,BCN=0
	. . S LST(NAM,"MSG",D0,"SEG",SGC)=D1
	. .QUIT
	. ;
	. S BCN=BCN+$L(X)
	. I X[CON D  Q
	. . S J=$P($P(X,";"),CON,2)
	. . S LST(NAM,"MSG",D0,"SEG",SGC,"CONT",CNT,$P(J,":"))=$P(J,":",2)
	. .QUIT
	. ;
	. ; S LST(NAM,"MSG",D0,"SEG",D1)=X
	.QUIT
	QUIT
	;  ===================
NAME(NM)	; Return the name of the Sender
	N NAME
	S NAME="<Unknown Sender>"
	D
	. ; Look first for a value to use with the NEW PERSON file
	. ;
	. I NM=+NM S NAME=$P(^VA(200,NM,0),U,1) Q
	. ;
	. I $L(NM) S NAME=NM                    Q
	. ;
	. ; Else, pull the data from the message and display the foreign source
	. ;   of the message.
	. N T
	. S VAL=$G(^XMB(3.9,D0,.7))
	. S:VAL T=$P(^VA(200,VAL,0),U)
	. I $L($G(T)) S NAME=T                  Q
	. ;
	.QUIT
	QUIT NAME
	;  ===================
TIME(Y)	; The time and date of the sending
	X ^DD("DD")
	QUIT Y
	;  ===================
	;  Segments in Message need to be identified and decoded properly
	; D DETAIL^C0CMAIL(.ARRAY,D0) ;  Call One for each message
	;   ARRAY will have the details of this one call
	;    
	; Inputs;
	;   C0CINPUT    - The IEN of the message to expand
	; Outputs;
	;   C0CDATA     - Carrier for the returned structure of the Message
	;  C0CDATA(D0,"SEG")=number of SEGMENTS
	;  C0CDATA(D0,"SEG",0:n)=SEGMENT n details
	;  C0CDATA(D0,"SEG",0:n,"CONTENT",type)=Content details
	;  C0CDATA(D0,"SEG",0:n,"MSG",D3)=Content details
	;  C0CDATA(D0,"SEG",0:n,"HTML",D3)=Content details
	;
DETAIL(C0CDATA,C0CINPUT)	; Message Detail Delivery
	N LST,D0,D1,U
	S U="^"
	S D0=+$G(C0CINPUT)
	I D0   D    QUIT
	. D GETTYP2(D0)
	. I $D(LST)   M C0CDATA(D0)=LST
	.QUIT
	QUIT
	;  ===================
	;  End note if needed
	; MSK   - Set of characters that do not exist in 64 bit encoding
GETTYP2(D0)	; Try to get the types and MSK for the 
	N I,J,K,N,BCN,BF,CON,CNT,D1,END,FLG,MSK,SEP,SGC,U,XX,ZN,XXNM
	S CON="Content-",U="^"
	S FLG="--"
	S MSK=" !""#$%&'()*,-.:;<>?@[\]^_`{|}~"
	S (BF,SEP)=""  ; Start SEP as null, so we can use this to help identify the type
	S (BCN,CNT,D1,END,SGC)=0
	S XX=$G(^XMB(3.9,D0,0))
	; S K=$P(^XMB(3.9,D0,2,0),U,3)
	S LST("TITLE")=$P($G(^XMB(3.9,D0,0)),U,1)
	S LST("CREATED")=$$TIME($P(XX,U,3))
	F I=4,2 S XXNM=$P(XX,U,I)  Q:$L(XXNM)
	S LST("FROM")=$$NAME(XXNM)
	; Get the folks the email is sent to.
	S D1=0
	F  S D1=$O(^XMB(3.9,D0,1,D1)) Q:'D1  D   Q:D1=""
	. N I,T
	. S T=$P($G(^XMB(3.9,D0,1,D1,0)),U)
	. S:T T=$P($G(^VA(200,T,0)),"^")
	. S LST("TO",+D1)=T
	. S T=$G(^XMB(3.9,D0,6,+D1,0))
	. S:T="" T=$P($G(^VA(200,+T,0)),"^")
	. S:T="" T="<Unknown>"
	. S LST("TO NAME",D1)=T
	.QUIT
	; Get the Header for the message
	S D1=0
	F I=1:1 S D1=$O(^XMB(3.9,D0,2,D1)) Q:D1=""  Q:(D1>.99999)   D
	. S LST("HDR",I)=$G(^XMB(3.9,D0,2,D1,0))
	.QUIT
	; Start walking the different sections
	S D1=.99999,SEP="--"
	F  S D1=$O(^XMB(3.9,D0,2,D1)) Q:'D1  D
	. ; Clear any control characters (cr/lf/ff) off
	. S X=$TR($G(^XMB(3.9,D0,2,D1,0)),$C(10,12,13))
	. ; Enter once to set the SEP to capture the separator
	. I (SEP="--")&($E(X,1,2)=FLG)&($L(X,FLG)=2)  D   Q
	. . S SEP=X,END=X_FLG
	. . S (CNT,SGC)=1,BCN=0
	. . S LST("SEG",SGC)=D1
	. .QUIT
	. ;
	. ; A new SEGMENT separator is set, process original 
	. I X=SEP  D  QUIT
	. . ; Save Current Values
	. . S LST("SEG",SGC,"SIZE")=BCN
	. . ;  Close this Segment and prepare to start a New Segment
	. . S LST("SEG",SGC)=$G(LST("SEG",SGC))_"^"_(D1-1)
	. . ;  Put the result in LST("SEG",SGC,"XML")
	. . I $L(BF) D
	. . . S ZN=1
	. . . N I,T,TBF
	. . . S TBF=BF
	. . . F I=1:1:($L(TBF,"="))  D
	. . . . S BF=$P(TBF,"=",I)_"="
	. . . . I BF'="="  D DECODER
	. . . .QUIT
	. . . S BF=""
	. . .QUIT
	. . S SGC=SGC+1,BCN=0
	. . ; Incriment SGC to start a new Segment
	. . S LST("SEG",SGC)=D1
	. .QUIT
	. ;
	. ; Accumulate the 64 bit encoding
	. I X=$TR(X,MSK)&$L(X) D   Q
	. . S BF=BF_X
	. . S BCN=BCN+$L(X)
	. .QUIT 
	. ;
	. ; Ending Condition, close out the Segment
	. I X=END D  QUIT
	. . S LST("SEG",SGC)=$G(LST("SEG",SGC))_"^"_(D1-1)
	. . I $L(BF) S ZN=1 D DECODER  S BF="" Q
	. .QUIT
	. ;
	. S BCN=BCN+$L(X)
	. ; Split out the Content Info
	. I X[CON D  Q
	. . S J=$P(X,CON,2)
	. . S LST("SEG",SGC,"CONTENT",$P(J,":"))=$P(J,":",2,9)
	. .QUIT
	. ;
	. ; Everything else is Text
	. S LST("SEG",SGC,"TXT",D1)=X
	.QUIT
	QUIT
	;  ===================
	; Break down the Buffer Array so it can be saved.
	;  BF is passed in.
DECODER	; 
	N RCNT,TBF,ZBF,ZI,ZJ,ZK,ZSIZE
	S ZBF=BF
	;  Full Buffer, BF, now check for Encryption and Unpack
	F RCNT=1:1:$L(ZBF,"=")   D
	. N BF
	. S BF=$P(ZBF,"=",RCNT)
	. ;  Unpacking the 64 bit encoding
	. S TBF=$TR($$DECODE^RGUTUU(BF),$C(10,12,13))
	. D:$L(TBF)
	. . N XBF
	. . S BF=BF_"="
	. . D NORMAL(.XBF,.TBF)
	. . M LST("SEG",SGC,"XML",RCNT)=XBF
	. .QUIT
	.QUIT
	QUIT
	;  ===================
	;  OUTXML = OUTBF  = OUT   = OUTPUT ARRAY TO BE BUILT
	;  BF     = INXML = INPUT ARRAY TO PROVIDE INPUT
	;   >D NORMAL^C0CMAIL(.OUT,BF)
NORMAL(OUTXML,INXML)	   ;NORMALIZES AN XML STRING PASSED BY NAME IN INXML
	; INTO AN XML ARRAY RETURNED IN OUTXML, ALSO PASSED BY NAME
	;
	N ZN,OUTBF
	S ZN=1
	S OUTBF(ZN)=$P(INXML,"><",ZN)_">"
	F ZN=ZN+1:1 S OUTBF(ZN)="<"_$P(INXML,"><",ZN) Q:$P(INXML,"><",ZN+1)=""  D  ;
	. S OUTBF(ZN)=OUTBF(ZN)_">"
	.QUIT
	M OUTXML=OUTBF
	QUIT
	;  ===================
	;  vvvvvvvvvvvvvvv  Not Needed  vvvvvvvvvvvvvvvvvvvvvvvvvv
	;  End note if needed
	QUIT
	;  ===================
