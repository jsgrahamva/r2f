HLOCLNT1	;IRMFO-ALB/CJM/RBN - Writing messages, reading acks;10:58 AM  18 May 2015;02/27/2012
	;;1.6;HEALTH LEVEL SEVEN;**126,130,131,134,137,139,146,155,158,WVEHR,LOCAL**;Oct 13, 1995;Build 1
	;Per VHA Directive 2004-038, this routine should not be modified.
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
	;
WRITEMSG(HLCSTATE,HLMSTATE)	;
	;Description:  This function uses the services offered by the transport layer to send a message over an open communication channel.
	;
	;Input:
	;  HLCSTATE (pass by reference, required) Defines the LLP & its state
	;  HLMSTATE (pass by reference, required) The message
	;Output:
	;  Function returns 1 on success, 0 on failure
	;
ZB6	;
	N SEG,QUIT,HDR
	S QUIT=0
	I '$G(HLMSTATE("IEN")) S QUIT=1 G ZB7
	S HDR(1)=HLMSTATE("HDR",1),HDR(2)=HLMSTATE("HDR",2)
	I '$$WRITEHDR^HLOT(.HLCSTATE,.HDR) S QUIT=1 G ZB7
	I HLMSTATE("BATCH") D
	.N LAST S LAST=0
	.S HLMSTATE("BATCH","CURRENT MESSAGE")=0
	.F  Q:'$$NEXTMSG^HLOMSG(.HLMSTATE,.SEG)  D  Q:QUIT
	..S LAST=HLMSTATE("BATCH","CURRENT MESSAGE")
	..I '$$WRITESEG^HLOT(.HLCSTATE,.SEG) S QUIT=1 Q
	..F  Q:'$$HLNEXT^HLOMSG(.HLMSTATE,.SEG)  D  Q:QUIT
	...I '$$WRITESEG^HLOT(.HLCSTATE,.SEG) S QUIT=1 Q
	.K SEG S SEG(1)="BTS"_HLMSTATE("HDR","FIELD SEPARATOR")_LAST
	.S:'$$WRITESEG^HLOT(.HLCSTATE,.SEG) QUIT=1
	E  D
	.F  Q:'$$HLNEXT^HLOMSG(.HLMSTATE,.SEG)  D  Q:QUIT
	..S:'$$WRITESEG^HLOT(.HLCSTATE,.SEG) QUIT=1
	S:'$$ENDMSG^HLOT(.HLCSTATE) QUIT=1
ZB7	;
	Q 'QUIT
	;
READACK(HLCSTATE,HDR,MSA)	;
	;Description:  This function uses the services offered by the transport layer to read an accept ack.
	;
	;Input:
	;  HLCSTATE (pass by reference, required) Defines the communication channel and its state.
	;Output:
	;  Function returns 1 on success, 0 on failure
	;  HDR (pass by reference) the message header:
	;   HDR(1) is components 1-6
	;   HDR(2) is components 7-end
	;  MSA (pass by reference) the MSA segment as an unsubscripted variable
	;
ZB8	;
	N SEG,SUCCESS
	S SUCCESS=0
	K HDR,MSA,MAX,I
	S MAX=HLCSTATE("SYSTEM","MAXSTRING")-40 ;MAX is the maximum that can be safely stored on a node, leaving room for the other fields stored with MSA seg
	G:'$$READHDR^HLOT(.HLCSTATE,.HDR) ZB9
	F  Q:'$$READSEG^HLOT(.HLCSTATE,.SEG)  D
	.I $E($E(SEG(1),1,3)_$E($G(SEG(2)),1,3),1,3)="MSA" D
	..S MSA=""
	..F I=1:1 Q:'$D(SEG(I))  S MSA=MSA_$S((MAX-$L(MSA))<1:"",1:$E(SEG(I),1,MAX))
	I $D(MSA),HLCSTATE("MESSAGE ENDED") D  S SUCCESS=1
	.D SPLITHDR^HLOSRVR1(.HDR)
	.S HLCSTATE("COUNTS","ACKS")=$G(HLCSTATE("COUNTS","ACKS"))+1
ZB9	Q SUCCESS
	;
CONNECT(LINK,PORT,TIMEOUT,HLCSTATE)	;
ZB1	;sets up HLCSTATE() and opens a client connection
	;Input:
	;  LINK - name of the link to connect to
	;  PORT (optional) port # to connect to, defaults to that specified by the link
	;  TIMEOUT (optional) specifies the open timeout in seconds, defaults to 30
	;Output:
	;   HLCSTATE - array to hold the connection state
	;
	I '$G(HLCSTATE("CONNECTED")) S HLCSTATE("CONNECTED")=0
	I HLCSTATE("CONNECTED") D  G:HLCSTATE("CONNECTED") ZB2
	.I $G(HLCSTATE("LINK","NAME"))]"",($G(HLCSTATE("LINK","NAME"))'=LINK) D CLOSE^HLOT(.HLCSTATE) Q
	.I $G(HLCSTATE("LINK","NAME"))]"",$G(PORT),($G(HLCSTATE("LINK","PORT"))'=PORT) D CLOSE^HLOT(.HLCSTATE) Q
	.I (HLCSTATE("SYSTEM","OS")="CACHE") D  Q
	..U HLCSTATE("DEVICE") S HLCSTATE("CONNECTED")=($ZA\8192#2)
	..I 'HLCSTATE("CONNECTED") D CLOSE^HLOT(.HLCSTATE)
	.;D CLOSE^HLOT(.HLCSTATE)
	K HLCSTATE
	N ARY,NODE
	I '$$GETLINK^HLOTLNK(LINK,.ARY) S HLCSTATE("LINK","NAME")=LINK,HLCSTATE("LINK","PORT")=$G(PORT) D LINKDOWN^HLOCLNT(.HLCSTATE) G ZB2
	M HLCSTATE("LINK")=ARY
ZB24	;
	I HLCSTATE("LINK","SHUTDOWN") S HLCSTATE("CONNECTED")=0 D LINKDOWN^HLOCLNT(.HLCSTATE) G ZB2
	;overlay the port if supplied from the queue
	S:$G(PORT) HLCSTATE("LINK","PORT")=PORT
	;
	; *** Begin HL*1.6*146 - RBN ***
	;S HLCSTATE("READ TIMEOUT")=20
	;get the dynamic value of the client read timeout
	D GETTIME^HLOTCP(.HLCSTATE)
	; *** End HL*1.6*146 - RBN ***
	; ;
	S HLCSTATE("OPEN TIMEOUT")=$S($G(TIMEOUT):TIMEOUT,1:30)
	S HLCSTATE("COUNTS")=0
	S HLCSTATE("READ")="" ;where the reads are stored
	;
	;HLCSTATE("BUFFER",<seg>,<line>) serves as a write buffer so that a lot can be written all at once
	S HLCSTATE("BUFFER","BYTE COUNT")=0 ;count of BYTES in buffer
	S HLCSTATE("BUFFER","SEGMENT COUNT")=0 ;count of segments in buffer
	;
	S HLCSTATE("MESSAGE ENDED")=0 ;end of message flag
	S NODE=^%ZOSF("OS")
	S HLCSTATE("SERVER")=0
	;Begin WorldVistA change
	;SIS/LM - In the following G.TM should be GT.M
	;was;S HLCSTATE("SYSTEM","OS")=$S(NODE["DSM":"DSM",NODE["OpenM":"CACHE",NODE["G.TM":"G.TM",1:"")
	S HLCSTATE("SYSTEM","OS")=$S(NODE["DSM":"DSM",NODE["OpenM":"CACHE",NODE["GT.M":"GT.M",1:"")
	;End WorldVistA change
	I HLCSTATE("SYSTEM","OS")="" D LINKDOWN^HLOCLNT(.HLCSTATE) G ZB2
	D
	.N SYS
	.D SYSPARMS^HLOSITE(.SYS)
	.S HLCSTATE("SYSTEM","BUFFER")=SYS("HL7 BUFFER")
	.S HLCSTATE("SYSTEM","MAXSTRING")=SYS("MAXSTRING")
	.S HLCSTATE("SYSTEM","NORMAL PURGE")=SYS("NORMAL PURGE")
	.S HLCSTATE("SYSTEM","ERROR PURGE")=SYS("ERROR PURGE")
	I HLCSTATE("LINK","LLP")="TCP" D
	.S HLCSTATE("OPEN")="OPEN^HLOTCP"
	E  ;no other LLP implemented
	D OPEN^HLOT(.HLCSTATE)
	;
	;mark the failure time for the link so other processes know not to try for a while
	I 'HLCSTATE("CONNECTED"),'HLCSTATE("LINK","SINGLE THREADED") D LINKDOWN^HLOCLNT(.HLCSTATE)
	I 'HLCSTATE("CONNECTED"),HLCSTATE("LINK","SINGLE THREADED"),'HLCSTATE("LOCK FAILED") D LINKDOWN^HLOCLNT(.HLCSTATE)
ZB2	;
	Q HLCSTATE("CONNECTED")
	;
	;
	;
	;
