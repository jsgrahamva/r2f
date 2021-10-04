C0PEWD2	  ; CCDCCR/GPL - ePrescription utilities; 4/24/09 ; 5/8/12 10:22pm
	;;1.0;C0P;;Apr 25, 2012;Build 103
	;Copyright 2009 George Lilly.  Licensed under the terms of the GNU
	;General Public License See attached copy of the License.
	;
	;This program is free software; you can redistribute it and/or modify
	;it under the terms of the GNU General Public License as published by
	;the Free Software Foundation; either version 2 of the License, or
	;(at your option) any later version.
	;
	;This program is distributed in the hope that it will be useful,
	;but WITHOUT ANY WARRANTY; without even the implied warranty of
	;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	;GNU General Public License for more details.
	;
	;You should have received a copy of the GNU General Public License along
	;with this program; if not, write to the Free Software Foundation, Inc.,
	;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
	;
	Q
	; TEST Lines below not intended for End Users. Programmers only.
	; BEWARE ZWRITE SYNTAX. It may not work in other M Implementations.
gpltest3	;  (zduz,zdfn) ; experiment with passing parameters from trigger
	;W "<br><b>SESSIONID:",zduz,"</b><br><hr>"
	W "<b>eRx</b> pullback trigger processing prototype<hr>",!
	I $D(req4) ZWRITE req4
	w "<hr>"
	W "XID=",$G(req4("XID",1)),"<br>"
	W "DFN=",$G(req4("DFN",1)),"<br>"
	w "DUZ=",$G(req4("DUZ",1)),"<hr>"
	s DFN=$G(req4("DFN",1))
	D PSEUDO ; FAKE LOGIN
	D XPAT^C0CCCR(DFN,"MEDALL")
	W "<br>"
	;D XPAT^C0CCCR(DFN)
	W "<a href=""http://hollywood/dev/CCR/PAT_"_DFN_"_CCR_V1_0_0.xml"" target=""CCR"">Display CCR</a>"
	;D RIM2RNF^C0CRIMA("GPL",DFN,"ALERTS")
	;D RNF2HVN^C0CRNF("G1","GPL")
	;D PARY^C0CXPATH("G1",-1)
	F ZG="ALERTS","MEDS","PROCEDURES" D  ;
	. N GPL,G2
	. W "<hr>"
	. W "<b>Current CCR "_ZG_"</b><br>",!
	. D RIM2RNF^C0CRIMA("GPL",DFN,ZG)
	. D RNF2HNV^C0CRNF("G2","GPL")
	. D PARY^C0CXPATH("G2",-1)
	Q
	;
PSEUDO	; FAKE LOGIN SETS SOME LOCAL VARIABLE TO FOOL FILEMAN
	S DILOCKTM=3
	S DISYS=19
	S DT=3100112
	S DTIME=9999
	S DUZ=135
	S DUZ(0)=""
	S DUZ(1)=""
	S DUZ(2)=67
	S DUZ("AG")="E"
	S DUZ("BUF")=1
	S DUZ("LANG")=1
	;S IO="/dev/pts/0"
	;S IO(0)="/dev/pts/0"
	;S IO(1,"/dev/pts/0")=""
	;S IO("ERROR")=""
	;S IO("HOME")="50^/dev/pts/0"
	;S IO("ZIO")="/dev/pts/0"
	;S IOBS="$C(8)"
	;S IOF="!!!!!!!!!!!!!!!!!!!!!!!!,#,$C(27,91,50,74,27,91,72)"
	;S IOM=80
	;S ION="GTM/UNIX TELNET"
	;S IOS=50
	;S IOSL=24
	;S IOST="C-VT100"
	;S IOST(0)=9
	;S IOT="VTRM"
	;S IOXY="W $C(27,91)_((DY+1))_$C(59)_((DX+1))_$C(72)"
	S U="^"
	S X="1;DIC(4.2,"
	S XPARSYS="1;DIC(4.2,"
	S XQXFLG="^^XUP"
	S Y="DEV^VISTA^hollywood^VISTA:hollywood"
	Q
	;
gpltest2(zduz,zdfn)	; experiment with passing parameters from trigger
	W "<br><b>SESSIONID:",zduz,"</b><br><hr>"
	W "HELLO WORLD<hr>",!
	I $D(req4) ZWRITE req4
	w "<hr>"
	W "DFN=",$G(req4("DFN",1)),"<br>"
	w "DUZ=",$G(req4("DUZ",1)),"<hr>"
	;ZWR
	Q
	;
gpltest(GPLV1)	; experiment with sending a CCR to an ewd page
	N ZI
	S ZI=""
	;W "HELLO WORLD!",!
	;Q
	F  S ZI=$O(^GPL(ZI)) Q:ZI=""  W ^GPL(ZI),!
	Q
	;
TESTSSL	;
	s URL="https://preproduction.newcropaccounts.com/InterfaceV7/NewrxFDB.xml"
	D GET1URL(URL) ;
	Q
	;
TEST2	;
	; httpPOST(url,payload,mimeType,html,headerArray,timeout,test,rawResponse,respHeaders,sslHost,sslPort)
	;
	s URL="http://preproduction.newcropaccounts.com/InterfaceV7/Doctor.xml"
	D GET1URL(URL) ;
	s gpl4(2)="<NCScript xmlns=""http://secure.newcropaccounts.com/interfaceV7"""
	s g1="xmlns:NCStandard="
	s g2="""http://secure.newcropaccounts.com/interfaceV7:NCStandard"""
	s gpl4(2)=gpl4(2)_" "_g1_g2
	s gpl4(2)=gpl4(2)_" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">"
	k gpl4(0) ; array size node
	s gpl4(3)="<Account ID=""demo"">"
	s gpl4(40)="<Location ID=""DEMOLOC1"">"
	s gpl4(28)="<LicensedPrescriber ID=""DEMOLP1"">"
	s gpl4(55)="<Patient ID=""DEMOPT1"">"
	W $$OUTPUT^C0CXPATH("gpl4(1)","NewCropV7-DOCTOR.xml","/home/dev/CCR/"),!
	S ok=$$httpPOST^%zewdGTM("https://preproduction.newcropaccounts.com/InterfaceV7/RxEntry.aspx",.gpl4,"Content-Type: text/html",.gpl6,"","",.gpl5,.gpl7)
	ZWRITE gpl6
	q
	;
TEST3	;
	; httpPOST(url,payload,mimeType,html,headerArray,timeout,test,rawResponse,respHeaders,sslHost,sslPort)
	;
	s URL="http://preproduction.newcropaccounts.com/InterfaceV7/Doctor.xml"
	D GET1URL(URL) ;
	N I,J
	S J=$O(gpl(""),-1) ; count of things in gpl
	F I=1:1:J S gpl(I)=$$CLEAN^C0PEWDU(gpl(I))
	K gpl(0)
	S gpl(1)="RxInput="_gpl(1)
	S url="https://preproduction.newcropaccounts.com/InterfaceV7/RxEntry.aspx"
	W $$OUTPUT^C0CXPATH("gpl(1)","NewCropV7-DOCTOR2.xml","/home/dev/CCR/"),!
	; S ok=$$httpPOST^%zewdGTM("https://preproduction.newcropaccounts.com/InterfaceV7/RxEntry.aspx",.gpl,"application/x-www-form-urlencoded",.gpl6,"","",.gpl5,.gpl7)
	S ok=$$httpPOST^%zewdGTM("https://preproduction.newcropaccounts.com/InterfaceV7/ComposeRX.aspx",.gpl,"application/x-www-form-urlencoded",.gpl6,"","",.gpl5,.gpl7)
	ZWRITE gpl6
	q
	;
TEST	;
	;s URL="https://preproduction.newcropaccounts.com/InterfaceV7/NewrxFDB.xml"
	  ; D GET1URL(URL) ;
	;Q
	S URL="http://preproduction.newcropaccounts.com/InterfaceV7/NCScript-RegisterLP.xml"
	D GET1URL(URL)
	S URL="http://preproduction.newcropaccounts.com/InterfaceV7/GenTestRenewalFDB.xml"
	D GET1URL(URL)
	S URL="http://preproduction.newcropaccounts.com/InterfaceV7/NewrxFDB.xml"
	D GET1URL(URL)
	S URL="http://preproduction.newcropaccounts.com/InterfaceV7/NewrxRxNorm.xml"
	D GET1URL(URL)
	S URL="http://preproduction.newcropaccounts.com/InterfaceV7/NewrxExternalDrugOpt1.xml"
	D GET1URL(URL)
	S URL="http://preproduction.newcropaccounts.com/InterfaceV7/NewrxExternalDrugOpt2.xml"
	D GET1URL(URL)
	S URL="http://preproduction.newcropaccounts.com/InterfaceV7/RenewalResponseAccept.xml"
	D GET1URL(URL)
	S URL="http://preproduction.newcropaccounts.com/InterfaceV7/RenewalResponseDeny.xml"
	D GET1URL(URL)
	Q
	;
GET1URL0(URL)	; 
	s ok=$$httpGET^%zewdGTM(URL,.gpl)
	D INDEX^C0CXPATH("gpl","gpl2")
	W !,"S URL=""",URL,"""",!
	S G=""
	F  S G=$O(gpl2(G)) Q:G=""  D  ;
	. W " S VDX(""",G,""")=""",gpl2(G),"""",!
	W !
	Q
	;
GET1URL(URL)	;
	s ok=$$httpGET^%zewdGTM(URL,.gpl)
	W "XML retrieved from Web Service:",!
	ZWRITE gpl
	D INDEX^C0CXPATH("gpl","gpl2",-1,"gplTEMP")
	W "VDX array displayed as a prototype Mumps routine:",!
	W !,"S URL=""",URL,"""",!
	S G=""
	F  S G=$O(gpl2(G)) Q:G=""  D  ;
	. W " S VDX(""",G,""")=""",gpl2(G),"""",!
	W !
	D VDX2XPG^C0CXPATH("gpl3","gpl2")
	W "Conversion of VDX array to XPG format:",!
	ZWRITE gpl3
	W "Conversion of XPG array to XML:",!
	D XPG2XML^C0CXPATH("gpl4","gpl3")
	ZWRITE gpl4
	Q
	;
