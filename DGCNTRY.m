DGCNTRY	;BAJ - REGISTRATION SCREEN 7/CROSS REFERENCE CLEANUP ;7:37 AM  7 Nov 2012
	;;5.3;Registration;**688,WVEHR,LOCAL**;Aug 13, 1993;Build 3;WorldVistA 30-June-08
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
	;
	;
	; This routine is called by a New style MUMPS index named AXCNTRY
	; The purpose of this routine is to clear certain fields when the Country field is changed
	; Values:       X1(#) contains the OLD values
	;                       X2(#) contains the NEW values
	;
	;
EN(FILE,ATYPE,FIELD)	; entry point
	;
	; Code to TRIGGER deletion of field data.
	N DGENDA,DATA,FORGN,ERROR
	Q:X=""
	S DGENDA=DA,ERROR=""
	S FORGN=$$FORGN(.X2) D SETARR(.DATA,FORGN,FILE,ATYPE,FIELD)
	;Begin WorldVistA Change ;06/16/2010 ;NO HOME
	;was;Q $$UPD^DGENDBS(FILE,.DGENDA,.DATA,.ERROR)
	N VW S VW=$$UPD^DGENDBS(FILE,.DGENDA,.DATA,.ERROR)
	Q
	;End WorldVistA Change
	;
SETARR(DATA,FORGN,FILE,ATYPE,FIELD)	;set up data array
	N CNT,CURFILE,CTRYFLD,FDFLG,ADDTYPE,T,FTYPE,CURFTYPE
	; If foreign kill domestic fields and vice versa
	S FTYPE=$S(FORGN:"D",1:"F")
	F CNT=1:1 S T=$P($T(DTABLE+CNT),";;",3) Q:T="QUIT"  D
	. S CURFTYPE=$P(T,";",1),ADDTYPE=$P(T,";",2),CURFILE=$P(T,";",3),CTRYFLD=$P(T,";",4),CURFLD=$P(T,";",5)
	. I CURFTYPE=FTYPE,CURFILE=FILE,ADDTYPE=ATYPE,CTRYFLD=FIELD S DATA(CURFLD)="@"
	Q
FORGN(X2)	; logic to determine if COUNTRY is US or Foreign
	Q $$FORIEN^DGADDUTL(X2(1))
	;
DTABLE	;TABLE of Foreign and Domestic fields: structure -->>;;DESCRIPTION;;(F)OREIGN/(D)OMESTIC;FILE;COUNTRY FIELD;FIELD
	;;PROVINCE;;F;PERM;2;.1173;.1171
	;;POSTAL CODE;;F;PERM;2;.1173;.1172
	;;STATE;;D;PERM;2;.1173;.115
	;;COUNTY;;D;PERM;2;.1173;.1117
	;;ZIP+4;;D;PERM;2;.1173;.1112
	;;PROVINCE;;F;TEMP;2;.1223;.1221
	;;POSTAL CODE;;F;TEMP;2;.1223;.1222
	;;STATE;;D;TEMP;2;.1223;.1215
	;;COUNTY;;D;TEMP;2;.1223;.12111
	;;ZIP+4;;D;TEMP;2;.1223;.12112
	;;PROVINCE;;F;CONF;2;.14116;.14114
	;;POSTAL CODE;;F;CONF;2;.14116;.14115
	;;STATE;;D;CONF;2;.14116;.1415
	;;COUNTY;;D;CONF;2;.14116;.14111
	;;ZIP+4;;D;CONF;2;.14116;.1416
	;;QUIT;;QUIT
