HLOTLNK	;IRMFO-ALB/CJM - APIs for the HL Logical Link file;6:50 PM  20 Mar 2014;02/11/2011
	;;1.6;HEALTH LEVEL SEVEN;**126,130,131,139,146,155,WVEHR,LOCAL**;Oct 13, 1995;Build 3
	;Per VHA Directive 2004-038, this routine should not be modified.
	;
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
SETSHUT(LINKIEN)	;
	;sets the shutdown flag (can not fail - if the link doesn't exist, by definition its shutdown)
	Q:'$G(LINKIEN) 1
	Q:'$D(^HLCS(870,LINKIEN,0)) 1
	S $P(^HLCS(870,LINKIEN,0),"^",16)=1
	Q 1
SETOPEN(LINKIEN)	;
	;clears the shutdown flag, returns 1 on success, 0 on failure
	Q:'$G(LINKIEN) 0
	Q:'$D(^HLCS(870,LINKIEN,0)) 0
	S $P(^HLCS(870,LINKIEN,0),"^",16)=""
	Q 1
	;
IFSHUT(LINKNAME)	;
	;returns 1 if the link was shut down to HLO
	N IEN,LINK,RET
	S RET=0
	S LINK=$P($G(LINKNAME),":")
	;** Start HL*1.6*139 RBN **
	;Q:LINK=""
	Q:LINK="" 1
	;** END HL*1.6*139 RBN **
	S IEN=$O(^HLCS(870,"B",LINK,0))
	Q:'IEN 1
	S:$P($G(^HLCS(870,IEN,0)),"^",16) RET=1
ZB0	Q RET
	;
DOMAIN(LINKIEN)	;
	;Returns the domain associated with this link
	;
	Q:'$G(LINKIEN) ""
	N NODE,DOMAIN
	S DOMAIN=""
	S NODE=$G(^HLCS(870,LINKIEN,0))
	I $P(NODE,"^",7) D
	.S DOMAIN=$P($G(^DIC(4.2,$P(NODE,"^",7),0)),"^")
	.S DOMAIN=$S($L(DOMAIN):"HL7."_DOMAIN,1:"")
	I '$L(DOMAIN) S DOMAIN=$P(NODE,"^",8)
	Q DOMAIN
	;
PORT(LINKIEN)	;
	;Returns the HLO port associated with this link
	;
	Q:'$G(LINKIEN) ""
	N NODE,PORT
	S NODE=$G(^HLCS(870,LINKIEN,400))
	S PORT=$P(NODE,"^",8)
	S:'PORT PORT=$S($P($G(^HLD(779.1,1,0)),"^",3)="P":5001,1:5026)
	Q PORT
	;
PORT2(LINKNAME)	;given the name of the link, returns its HLO port
	N PORT
	Q:'$L(LINKNAME) ""
	S PORT=$$PORT($O(^HLCS(870,"B",LINKNAME,0)))
	Q:'$L(PORT) ""
	Q PORT
	;
STATNUM(LINKIEN)	;
	;Given the ien of the link, this function returns the station #.
	;
	Q:'$G(LINKIEN) ""
	N INST
	S INST=$P($G(^HLCS(870,LINKIEN,0)),"^",2)
	Q:'INST ""
	Q $P($G(^DIC(4,INST,99)),"^")
	;
FINDLINK(STATN)	;
	;Returns the link ien based on the station # =STATN
	;The link found must have a name starting with "VA", as these are
	;reserved for officially released links associated with VHA institutions
	;** EXCEPTION** MPIVA is an official link associated with 200M
	;
	Q:'$L($G(STATN)) 0
	;
	N NAME,IEN
	S (NAME,IEN)=""
	;Begin WorldVistA change
	;was;F  S NAME=$O(^HLCS(870,"AC",STATN,NAME)) Q:NAME=""  I (NAME'="VA-VIE"),($E(NAME,1,2)="VA")!(NAME="MPIVA") S IEN=$O(^HLCS(870,"AC",STATN,NAME,0)) Q
	F  S NAME=$O(^HLCS(870,"AC",STATN,NAME)) Q:NAME=""  I (NAME'="VA-VIE"),(($E(NAME,1,2)="VA")!(NAME="MPIVA"))!$D(HLVWNOVA) S IEN=$O(^HLCS(870,"AC",STATN,NAME,0)) Q
	;End WorldVistA Change
	Q IEN
	;
GETLINK(LINKNAME,LINK)	;
	N IEN
	Q:'$L(LINKNAME) 0
	S IEN=$O(^HLCS(870,"B",LINKNAME,0))
	I IEN Q $$GET(IEN,.LINK)
	I LINKNAME="HLO DEFAULT LISTENER" D  Q 1
	.N NODE
	.S LINK("NAME")=LINKNAME
	.S LINK("IEN")=0
	.S LINK("SHUTDOWN")=""
	.S LINK("LLP")="TCP"
	.S LINK("SERVER")="1^"_"M"
	.S NODE=$G(^HLD(779.1,1,0))
	.S LINK("DOMAIN")=$P(NODE,"^",1)
	.S LINK("PORT")=$S($P(NODE,"^",3)="P":5001,$P(NODE,"^",3)="T":5026,1:"")
	.S LINK("IP")=""
	Q 0
GET(IEN,LINK)	;
	N NODE,PTR
	K LINK
	S NODE=$G(^HLCS(870,IEN,0))
	Q:NODE="" 0
	S LINK("NAME")=$P(NODE,"^")
	S LINK("IEN")=IEN
	S LINK("SHUTDOWN")=+$P(NODE,"^",16)
	I $P(NODE,"^",23)=1 S LINK("SINGLE THREADED")=1
	E  S LINK("SINGLE THREADED")=0
	I $P(NODE,"^",7) D
	.S LINK("DOMAIN")=$P(^DIC(4.2,$P(NODE,"^",7),0),"^")
	.S LINK("DOMAIN")=$S($L(LINK("DOMAIN")):"HL7."_LINK("DOMAIN"),1:"")
	I $G(LINK("DOMAIN"))="" S LINK("DOMAIN")=$P(NODE,"^",8)
	S PTR=$P(NODE,"^",3)
	S LINK("LLP")=$S('PTR:"",1:$P($G(^HLCS(869.1,PTR,0)),"^"))
	S LINK("SERVER")=""
	I LINK("LLP")="TCP" D
	.S LINK("SERVER")=1
	.S NODE=$G(^HLCS(870,IEN,400))
	.S LINK("IP")=$P(NODE,"^")
	.S LINK("PORT")=$P(NODE,"^",8)
	.S:'LINK("PORT") LINK("PORT")=$S($P($G(^HLD(779.1,1,0)),"^",3)="P":5001,1:5026)
	.S:$P(NODE,"^",3)="C" LINK("SERVER")=0
	.I LINK("SERVER") S LINK("SERVER")=LINK("SERVER")_"^"_$P(NODE,"^",3)
	Q 1
	;
SET1(LINK,MDOMAIN)	;
	N DOMAIN
	Q:'$L(MDOMAIN)
	S DOMAIN=$P($G(^DIC(4.2,MDOMAIN,0)),"^")
	S DOMAIN=$S($L(DOMAIN):"HL7."_DOMAIN,1:"")
	I DOMAIN'="" S ^HLCS(870,"AD","TCP",DOMAIN,LINK)=""
	Q
KILL1(LINK,MDOMAIN)	;
	N DOMAIN
	Q:'$L(MDOMAIN)
	S DOMAIN=$P($G(^DIC(4.2,MDOMAIN,0)),"^")
	S DOMAIN=$S($L(DOMAIN):"HL7."_DOMAIN,1:"")
	I DOMAIN'="" K ^HLCS(870,"AD","TCP",DOMAIN,LINK)
	Q
SET2(LINK,DOMAIN)	;
	I DOMAIN'="" S ^HLCS(870,"AD","TCP",DOMAIN,LINK)=""
	Q
KILL2(LINK,DOMAIN)	;
	I DOMAIN'="" K ^HLCS(870,"AD","TCP",DOMAIN,LINK)
	Q
SET3(LINK,DEVICE)	;
	Q:'DEVICE
	S ^HLCS(870,"AD","HLLP",DEVICE,LINK)=""
	Q
KILL3(LINK,DEVICE)	;
	Q:'DEVICE
	S ^HLCS(870,"AD","HLLP",DEVICE,LINK)=""
	Q
LLP(LINKNAME)	;
	;finds the type of LLP for a named link
	N IEN,LLP
	S IEN=$O(^HLCS(870,"B",LINKNAME,0))
	Q:'IEN ""
	S LLP=$P($G(^HLCS(870,IEN,0)),"^",3)
	Q:'LLP ""
	Q $P($G(^HLCS(869.1,LLP,0)),"^")
	;
DEVICE(LINKNAME)	;
	N IEN
	S IEN=$O(^HLCS(870,"B",LINKNAME,0))
	Q:'IEN ""
	Q $P($G(^HLCS(870,IEN,200)),"^")
	;
RTRNLNK(COMP1,COMP2,COMP3)	;
	;based on the sending facility from the original header, this function finds the return link, or "" if not successful
	;Inputs:
	;  COMP1,COMP2,COMP3 - 3 components of the sending facility from the original message
	;
	N LINK,IEN
	S LINK=""
	I $G(COMP3)="DNS",$P($G(COMP2),":")]"" S LINK=$O(^HLCS(870,"AD","TCP",$P(COMP2,":"),""))
	I LINK="",$L($G(COMP1)) S IEN=$$FINDLINK(COMP1) S:IEN LINK=$P($G(^HLCS(870,IEN,0)),"^")
	Q LINK
	;
	;HLLP is not implemented in HLO
	;I LLP="HLLP" N DEVICE S DEVICE=$$DEVICE(FROMLINK) I DEVICE Q $O(^HLCS(870,"AD","TCP",DEVICE,""))
	;Q ""
	;
CHKLINK(LINK)	;
	Q:'$L(LINK) 0
	Q:'$O(^HLCS(870,"B",LINK,0)) 0
	Q 1
ONETHRED(LINKNAME)	;
	;Returns the value of the SINGLE THREADED flag of the HL LOGICAL LINK
	;file.
	;Input:
	;   LINKNAME - the name given to an entry in the HL LOGICAL LINK file.
	;Output:
	;   The function returns 1 if the SINGLE THREADED flag is set to YES,
	;   otherwiste it returns 0.
	N IEN
	S IEN=$O(^HLCS(870,"B",LINKNAME,0))
	Q:'IEN 0
	I $P($G(^HLCS(870,IEN,0)),"^",23)=1 Q 1
	Q 0
	;
STHREADS(LINKNAME,ON)	;
	;This function is used to turn on or off the SINGLE THREADED flag of
	;the HL LOGICAL LINK file.
	;
	;Input:
	;   LINKNAME - (required) the name of an entry in the HL LOGICAL LINK file.
	;   ON - 1 will set the flag.
	;        0,"", or not present will cause the flag to be deleted.
	;        Other values are not accepted and will cause an error to be returned.
	;Output:
	;   function returns -1 if the inputs are invalid.  Otherwise returns
	;            the new value of the SINGLE THREADED flag.
	N IEN
	I $G(ON)'="",$G(ON)'=0,$G(ON)'=1 Q -1
	S IEN=$O(^HLCS(870,"B",LINKNAME,0))
	Q:'IEN -1
	S $P(^HLCS(870,IEN,0),"^",23)=+$G(ON)
	Q +$G(ON)
