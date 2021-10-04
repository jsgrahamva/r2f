ORZZFACE	;SMT/BP-OIFO Patch Pre Install ; 9/28/2010 11:01
	;;3.0;ORDER ENTRY/RESULTS REPORTING;**338,WVEHR,LOCAL**;Dec 17, 1997;Build 3
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
	; This is a pre install routine for patch OR*3*338
	; IA#2686 - ^XTV(8989.5
	;
EN	;
	N PIEN,ENT,INST,ENTERR,ENTDSP
	S PIEN=$O(^XTV(8989.51,"B","ORWCV1 COVERSHEET LIST",0))
	S ENT="" F  S ENT=$O(^XTV(8989.5,"AC",PIEN,ENT)) Q:ENT']""  D
	. S INST=0 F  S INST=$O(^XTV(8989.5,"AC",PIEN,ENT,INST)) Q:'INST  I (INST<1)!(INST>8) D  Q
	. . S ENTERR($O(ENTERR(""),-1)+1)=$$ERR(ENT)
	I $D(ENTERR)>0 D MAIL(.ENTERR),ABORT
	Q  ;WorldVistA change
ERR(STR)	;
	N OUTPT,FILNM,ENTDSP,INSTDP,ENT,INST
	S INST=$P(STR,";"),ENT=$P(STR,";",2)
	S FILNM=+$P(ENT,"(",2)
	D FILE^DID($S(FILNM:FILNM,1:ENT),"","NAME","OUTPT") S ENTDSP=$G(OUTPT("NAME"))
	S INSTDP=$$GET1^DIQ($S(FILNM:FILNM,1:ENT),INST,.01,"E")
	S:ENTDSP["DOMAIN" ENTDSP="SYSTEM"
	Q ENTDSP_": "_INSTDP
	;
MAIL(ARY)	 ;
	N XMDUZ,XMSUB,XMTEXT,XMY,DIFROM,I,II,MSG
	S XMDUZ="OR*3*338",XMSUB="PARAMETER VALIDATION",XMTEXT="MSG(",XMY(DUZ)="",I=1
	S MSG(I)="Below is a list of entities which have an instance in parameter",I=I+1
	S MSG(I)="ORWCV1 COVERSHEET LIST that does not fall within the valid range of 1-8.",I=I+1
	S MSG(I)="These need to be corrected before install of OR*3*338.",I=I+1
	S MSG(I)="Please See The OR*3*338 Patch description for more information.",I=I+1
	S MSG(I)="",I=I+1
	I $D(ARY) S II="" F  S II=$O(ARY(II)) Q:'II  S MSG(I)=" "_ARY(II),I=I+1
	E  S MSG(I)="No Entities Found"
	D ^XMD
	Q
	;
ABORT	;
	D EN^DDIOL("Installation of OR*3*338 Aborted. Please see mail message for details.")
	S XPDQUIT=1
	Q
	;
