VWHLUT1	;WVEHR/John McCormack- World VistA HL Table Utilities; 7:32 PM 2 June 2011
	;;1.0;;**250068,WVEHR,LOCAL**;Sep 27, 1994;Build 3
	;;WVEHR-1007;WORLD VISTA;*WVEHR1*;;Build 12
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
CHKDATA	; Call from VWHLUT
	;
	N J,VWDLIM,VWESC,VWLEN,X
	;
	S VWIN=$G(VWIN),VWCH=$G(VWCH)
	S VWOUT=""
	;
	I VWIN=""!(VWCH="") Q
	;
	; Build array of encoding characters to check
	S VWLEN=$L(VWCH)
	S VWDLIM=$S(VWLEN=5:"FSRET",1:"SRET")
	S VWESC=$E(VWCH,VWLEN-1)
	F J=1:1:VWLEN S VWCH($E(VWCH,J))=$E(VWDLIM,J)
	;
	; Check each character and convert if appropiate
	F J=1:1:$L(VWIN) D
	. S X=$E(VWIN,J)
	. I $D(VWCH(X)) S X=$$ENESC^VWHLUT(VWCH(X),VWESC)
	. S VWOUT=VWOUT_X
	;
	Q
	;
	;
CNVFLD	; Call from VWHLUT
	;
	S VWIN=$G(VWIN),VWECH1=$G(VWECH1),VWECH2=$G(VWECH2)
	S VWOUT=""
	;
	I VWIN=""!(VWECH1="")!(VWECH2="") Q
	;
	; Abort if encoding schemes not equal length
	I $L(VWECH1)'=$L(VWECH2) Q
	;
	; If same then return input as output
	I VWECH1=VWECH2 S VWOUT=VWIN Q
	;
	; Determine position of HL7 ESCAPE encoding character
	; 4th position if field separator and encoding characters passed
	; 3rd position if only encoding characters passed
	; Based on length of input encoding character variable
	S VWLEN=$L(VWECH1)
	S VWDLIM=$S(VWLEN=5:"FSRET",1:"SRET")
	S VWESC=$E(VWDLIM,VWLEN-1)
	;
	; Build array to convert source encoding to target encoding
	F J=1:1:$L(VWECH1) S VWECH($E(VWECH1,J))=$E(VWECH2,J)
	;
	; Check each character and convert if appropiate
	; If source conflicts with target encoding character
	;    then convert to escape encoding
	; If match on source encoding character - convert to new encoding
	F J=1:1:$L(VWIN) D
	. S X=$E(VWIN,J)
	. I '$D(VWECH(X)),VWECH2[X S X=$$ENESC^VWHLUT($E(VWDLIM,($F(VWECH2,X)-1)),VWESC)
	. I $D(VWECH(X)) S X=VWECH(X)
	. S VWOUT=VWOUT_X
	;
	Q
	;
	;
UNESC	; Call from VWHLUT
	;
	N J,VWESC,VWDLIM,VWLEN
	;
	; If data does not contain escape encoding then return input string as output
	S VWLEN=$L(VWCH),VWESC=$E(VWCH,VWLEN-1)
	I VWX'[VWESC Q
	;
	; Build array of encoding characters to replace
	S VWDLIM=$S(VWLEN=5:"FSRET",1:"SRET")
	F J=1:1:VWLEN S VWCH(VWESC_$E(VWDLIM,J)_VWESC)=$E(VWCH,J)
	;
	S VWX=$$REPLACE^XLFSTR(VWX,.VWCH)
	;
	Q
	;
	;
UNESCFT	; Call from VWHLUT
	;
	N J,K,VWESC,VWI,VWZ,SAVX,SAVY,Z
	;
	S J=0,VWESC=$E(VWCH,$L(VWCH)-1),(VWI,SAVX,SAVY)=""
	F  S VWI=$O(VWX(VWI)) Q:VWI=""  D
	. S J=J+1
	. I VWX(VWI)'[VWESC,SAVY="" S VWY(J,0)=VWX(VWI) Q
	. F K=1:1:$L(VWX(VWI)) D
	. . S Z=$E(VWX(VWI),K)
	. . I Z=VWESC D  Q
	. . . I SAVY="" S SAVY=Z Q
	. . . S SAVY=SAVY_Z
	. . . I $P(SAVY,VWESC,2)=".br" S VWY(J,0)=$S(SAVX]"":SAVX,1:" "),SAVX="",J=J+1
	. . . I $E(SAVY,2)'="." S SAVX=SAVX_$$UNESC^VWHLUT(SAVY,VWCH)
	. . . S SAVY=""
	. . I SAVY]"" S SAVY=SAVY_Z Q
	. . S SAVX=SAVX_Z
	. S VWY(J,0)=SAVX,SAVX=""
	S VWY=J
	;
	Q
