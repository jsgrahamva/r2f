PSOLMPO	;ISC-BHAM/LC - pending orders ;5:26 AM  8 Sep 2015
	;;7.0;OUTPATIENT PHARMACY;**46,225,436,WVEHR,LOCAL**;DEC 1997;Build 1
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
EN	; -- main entry point for PSO LM PENDING ORDER
	;Begin WorldVistA change
	;WAS;S PSOLMC=0 D EN^VALM("PSO LM PENDING ORDER") K PSOLMC
	I $G(PSOAFYN)'="Y" S PSOLMC=0 D EN^VALM("PSO LM PENDING ORDER") K PSOLMC
	I $G(PSOAFYN)="Y" D ACP^PSOORNEW
	;End WorldVistA change
	Q
	;
HDR	; -- header code
	D HDR^PSOLMUTL
	Q
	;
INIT	; -- init variables and list array
	;F LINE=1:1:30 D SET^VALM10(LINE,LINE_"     Line number "_LINE)
	S VALMCNT=IEN,VALM("TITLE")=$S($P(OR0,"^",23):"FL-",1:"")_"Pending OP Orders ("_$S($P(OR0,"^",14)="S":"STAT",$P(OR0,"^",14)="E":"EMERGENCY",1:"ROUTINE")_")"
	D RV^PSONFI
	Q
	;
HELP	; -- help code
	S X="?" D DISP^XQORM1 W !!
	Q
	;
EXIT	; -- exit code
	I $D(^TMP("PSORXDC",$J)) D FULL^VALM1,CLEAN^PSOVER1
	K FLAGLINE D CLEAN^VALM10
	Q
	;
EXPND	; -- expand code
	Q
	;
