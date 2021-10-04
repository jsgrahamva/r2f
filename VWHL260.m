VWHL260	;WVEHR/John McCormack- World VistA HL Table Utilities; 7:32 PM 25 Nov 2012
	;;WVEHR-1007;WORLD VISTA;**WVEHR,LOCAL**;;Build 3
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
	;
	Q
	;
	;
PRE	; Pre-intall for file #260 DD.
	;
	D DDEL
	Q
	;
	;
DDEL	;
	; Delete DD for file #260
	;
	I $G(XPDENV),$$VFILE^DILFD(260) D
	. N DIU
	. D BMES^XPDUTL($$CJ^XLFSTR("*** Deleting Data Dictionary VW HL7 TABLES File (#260) ***",80))
	. S DIU="^VWLEX(260,",DIU(0)="DS" D EN^DIU2
	. D BMES^XPDUTL($$CJ^XLFSTR("*** Data Dictionary VW HL7 TABLES File (#260) ***",80))
	. D BMES^XPDUTL($$CJ^XLFSTR("*** will be installed by this KIDS installation***",80))
	;
	Q
