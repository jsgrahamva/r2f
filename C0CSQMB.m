C0CSQMB	; SQMCCR/ELN  - BATCH PROGRAM ;16/11/2010
	;;1.2;CCD/CCR GENERATION UTILITIES;;Oct 30, 2012;Build 51
	; (C) 2010 ELN
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
EN	;Traverse the DPT global and export CCR xml for each DFN
	;and write to directory set in ^TMP("C0CCCR","ODIR")=
	;
	I '$D(DUZ) Q
	S U="^",DT=$$DT^XLFDT
	D DUZ^XUP(DUZ)
	; Get the output directory and filename prefix from env
	S ^TMP("C0CCCR","ODIR")=$ZTRNLNM("ccrodir")
	S ^TMP("C0CCCR","OFNP")=$ZTRNLNM("ccrofnprefix")
	N ZDFN
	;F ZDFN=0:0 S ZDFN=$O(^DPT(ZDFN)) Q:'ZDFN!((ZDFN="+1,")!(ZDFN>10))  D
	F ZDFN=0:0 S ZDFN=$O(^DPT(ZDFN)) Q:'ZDFN!(ZDFN="+1,")  D
	. ;I ZDFN<350 S ZDFN=349
	. D XPAT^C0CCCR(ZDFN)
	Q
	;
