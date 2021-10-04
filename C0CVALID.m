C0CVALID	; C0C/OHUM/RUT - PROCESSING FOR DATE LIMITS, NOTES ; 22/12/2011
	;;1.2;CCD/CCR GENERATION UTILITIES;;Oct 30, 2012;Build 51;Build 2
	; (C) RUT 2011.
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
	S ^TMP("C0CCCR","LABLIMIT")="",^TMP("C0CCCR","VITLIMIT")="",^TMP("C0CCCR","MEDLIMIT")="",^TMP("C0CCCR","TIULIMIT")=""
	S %DT="AEX",%DT("A")="LAB Report From: ",%DT("B")="T-36500" D ^%DT S ^TMP("C0CCCR","LABLIMIT")=Y
	S %DT="AEX",%DT("A")="VITAL Report From: ",%DT("B")="T-36500" D ^%DT S ^TMP("C0CCCR","VITLIMIT")=Y
	S %DT="AEX",%DT("A")="MEDICATION Report From: ",%DT("B")="T-36500" D ^%DT S ^TMP("C0CCCR","MEDLIMIT")=Y
	;S ^TMP("C0CCCR","RALIMIT")="",%DT="AEX",%DT("A")="RADIOLOGY Report From: ",%DT("B")="T-36500" D ^%DT S ^TMP("C0CCCR","RALIMIT")=Y
	W !,"Do you want to include Notes: YES/NO? //NO" D YN^DICN I %=1 S %DT="AEX",%DT("A")="NOTE Report From: ",%DT("B")="T-36500" D ^%DT S ^TMP("C0CCCR","TIULIMIT")=Y
	Q
HTOF(FLAGS)	;Changing DATE in FILMAN's FORMAT
	N HORLOGDATECUR,COVDATE,HORLOGDATE,FDATE
	S HORLOGDATECUR=$P($H,",",1)
	S COVDATE=$P(FLAGS,"-",2)
	S HORLOGDATE=HORLOGDATECUR-COVDATE
	S (FDATE)=$$H2F^XLFDT(HORLOGDATE)
	K HORLOGDATECUR,COVDATE,HORLOGDATE
	Q FDATE
