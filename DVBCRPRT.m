DVBCRPRT	;ALB/GTS-557/THM-REPRINT C&P REPORT ;4:56 AM  23 Nov 2015
	;;2.7;AMIE;**31,42,119,192,WVEHR,LOCAL**;Apr 10, 1995;Build 1
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
	; ** DVBCRPRT is called from DVBCRPON **
	; ** DVBCRPRT is called from DVBAB82 **
PHYS	S PHYS=$S($D(^DVB(396.4,DA,0)):$P(^(0),U,7),1:"")
	Q
STEP2A	;  ** Called from STEP2 only **
	S EXMNM=$S($D(^DVB(396.6,$P(^DVB(396.4,DA,0),U,3),0)):$P(^(0),U,1),1:"Unknown exam"),EXHD="For "_EXMNM_" Exam" D HDR^DVBCRPR1
	W "Examining provider: ",PHYS,!,"Examined on: " S Y=$P(^DVB(396.4,DA,0),U,6) X XDD W Y,! F LINE=1:1:80 W "="
	W !!?2,"Examination results:",!! S EXSTAT=$P(^DVB(396.4,DA,0),U,4) I EXSTAT="X"!(EXSTAT="RX") W !!!!!?25,"This exam was CANCELLED by ",$S(EXSTAT="RX":"the RO.",1:"MAS."),!! Q
	D STEP3
	Q
STEP2	; ** An external entry point and called from GO2 **
	F DA=0:0 S DA=$O(^DVB(396.4,"C",DA(1),DA)) Q:DA=""  D GETRO Q:RO'=DUZ(2)&('$D(^XUSEC("DVBA C SUPERVISOR",DUZ)))  S PG=0 D PHYS,STEP2A I $D(PRINT) D BOT^DVBCRPR1 K PRINT
	D ^DVBCLABR Q
	K DVBAON2
	Q
VBASTEP2	; call from VBACRPON^DVBAB82
	F DA=0:0 S DA=$O(^DVB(396.4,"C",DA(1),DA)) Q:DA=""  D GETRO S PG=0 D PHYS,STEP2A I $D(PRINT) D BOT^DVBCRPR1 K PRINT
	D ^DVBCLABR Q
	K DVBAON2
	Q
STEP3	;  ** Called from STEP2A only **
	K ^UTILITY($J,"W") S DIWL=1,DIWR=80,DIWF="NW" S OLDA=DA,OLDA1=DA(1)
	F LINE=0:0 S LINE=$O(^DVB(396.4,OLDA,"RES",LINE)) Q:LINE=""  S X=^DVB(396.4,OLDA,"RES",LINE,0) D ^DIWP,STEP3A
	D ^DIWW S PRINT=1 S DA=OLDA,DA(1)=OLDA1
	Q
STEP3A	;  ** Called from STEP3 only **
	I +$G(DVBGUI) D
	.I $Y>(IOSL-9) D HDR^DVBCRPR1
	I '+$G(DVBGUI) D
	.;Begin WorldVistA change
	.;WAS;I $Y>(IOSL-9) D UP^DVBCRPR1,NEXT,HDR^DVBCRPR1 W:$O(^DVB(396.4,OLDA,"RES",LINE))]""&&('+$G(DVBGUI)) !!,"Exam Results Continued",!!
	.I $Y>(IOSL-9) D UP^DVBCRPR1,NEXT,HDR^DVBCRPR1 I $O(^DVB(396.4,OLDA,"RES",LINE))]"",('+$G(DVBGUI)) W !!,"Exam Results Continued",!!
	.;End WorldVistA change
	Q
GO	;  ** An external entry point called from DVBCRPON **
	U IO K ^TMP($J),DVBAON2 D HDA^DVBCRPR1 S (XCNT,XPRINT)=0
	I '$D(^XUSEC("DVBA C SUPERVISOR",DUZ)) D
	.F DA(1)=0:0 S DA(1)=$O(^DVB(396.3,"AF","C",DUZ(2),DA(1))) Q:DA(1)=""  DO
	..I $D(^DVB(396.3,DA(1),0)) D GO1
	..I '$D(^DVB(396.3,DA(1),0)) D BADXRF^DVBCPRNT
	I $D(^XUSEC("DVBA C SUPERVISOR",DUZ)) D
	.F LOC=0:0 S LOC=$O(^DVB(396.3,"AF","C",LOC)) Q:LOC=""  D
	..F DA(1)=0:0 S DA(1)=$O(^DVB(396.3,"AF","C",LOC,DA(1))) Q:DA(1)=""  DO
	...I $D(^DVB(396.3,DA(1),0)) D GO1
	...I '$D(^DVB(396.3,DA(1),0)) D BADXRF^DVBCPRNT
	I XPRINT=0 K XPRINT,XPG,XXLN W !!!!!?25,"Nothing to print",!! H 2 G KILL^DVBCUTIL
	I XCNT>0,XPRINT=1 W !!,"Total requests to be printed: ",XCNT,!
	K XCNT,XXLN,XPG,XPRINT D SETLAB^DVBCPRNT S (XCN,PNAM)=""
	F DVBCN=0:0 S XCN=$O(^TMP($J,XCN)) Q:XCN=""  F JJ=0:0 S PNAM=$O(^TMP($J,XCN,PNAM)) Q:PNAM=""  D GO2
	G EXIT
VBAGO	;  ** An external entry point called from DVBCRPON **
	U IO K ^TMP($J),DVBAON2 D HDA^DVBCRPR1 S (XCNT,XPRINT)=0
	D
	.S DVBADUZ(2)=$P(^DVB(396.3,DA(1),0),U,2)
	.F DA(1)=0:0 S DA(1)=$O(^DVB(396.3,"AF","C",DVBADUZ(2),DA(1))) Q:DA(1)=""  DO
	..I $D(^DVB(396.3,DA(1),0)) D GO1
	..I '$D(^DVB(396.3,DA(1),0)) D BADXRF^DVBCPRNT
	I XPRINT=0 K XPRINT,XPG,XXLN W !!!!!?25,"Nothing to print",!! H 2 G KILL^DVBCUTIL
	I XCNT>0,XPRINT=1 W !!,"Total requests to be printed: ",XCNT,!
	K XCNT,XXLN,XPG,XPRINT D SETLAB^DVBCPRNT S (XCN,PNAM)=""
	F DVBCN=0:0 S XCN=$O(^TMP($J,XCN)) Q:XCN=""  F JJ=0:0 S PNAM=$O(^TMP($J,XCN,PNAM)) Q:PNAM=""  D GO2
	G EXIT
GO2	F DA(1)=0:0 K PRINT S DA(1)=$O(^TMP($J,XCN,PNAM,DA(1))) Q:DA(1)=""  S PRTDATE=$P(^DVB(396.3,DA(1),0),U,16) I PRTDATE[RUNDATE S DA=DA(1) D VARS^DVBCUTIL
	Q:(LOC'=RO)&('$D(^XUSEC("DVBA C SUPERVISOR",DUZ)))&('$D(AUTO))  D STEP2
	Q
GO1	S DFN=$P(^DVB(396.3,DA(1),0),U,1),PRTDATE=$P(^(0),U,16),PNAM=$P(^DPT(DFN,0),U,1),SSN=$P(^(0),U,9),CNUM=$S($D(^DPT(DFN,.31)):$P(^(.31),U,3),1:"Missing")
	I RTYPE="D" Q:PRTDATE'[RUNDATE!(RUNDATE']"")
	S XCN=$E(CNUM,$L(CNUM)-1,$L(CNUM)),XCN=+XCN
	I PNAM]"" S ^TMP($J,XCN,PNAM,DA(1))="",XPRINT=1,XCNT=XCNT+1
	D SSNSHRT^DVBCUTIL
	W $E(PNAM,1,25),?28,DVBCSSNO,?43,CNUM,?55 S Y=$P(^DVB(396.3,DA(1),0),U,2) X XDD W Y,! D:$Y>(IOSL-16) HDA^DVBCRPR1
	K PNAM,XCN,CNUM,DVBCSSNO
	Q
	;
EXIT	K XDD,AUTO,DVBADUZ(2) S LKILL=1 G KILL^DVBCUTIL ; ** GOTO will quit from this RTN
	;
NEXT	I '$D(DVBGUI) W !,"Continued on next page",!,"VA Form 2507"
	Q
	;
GETRO	S RO=$P(^DVB(396.3,DA(1),0),U,3)
	Q
