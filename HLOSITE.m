HLOSITE	;ALB/CJM/OAK/PIJ-HL7 - API for getting site parameters ;11:05 AM  18 May 2015
	;;1.6;HEALTH LEVEL SEVEN;**126,138,147,153,158,WVEHR,LOCAL**;Oct 13, 1995;Build 1
	;Per VHA Directive 2004-038, this routine should not be modified.
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
SYSPARMS(SYSTEM)	;Gets system parameters from file 779.1
	;Input: none
	;Output:  SYSTEM array (pass by reference)
	;
	N NODE,LINK,PURGE
	S NODE=$G(^HLD(779.1,1,0))
	S SYSTEM("DOMAIN")=$P(NODE,"^")
	S SYSTEM("STATION")=$P(NODE,"^",2)
	S SYSTEM("PROCESSING ID")=$P(NODE,"^",3)
	S SYSTEM("MAXSTRING")=$P(NODE,"^",4)
	I ('SYSTEM("MAXSTRING"))!(SYSTEM("MAXSTRING")<256) D
	.N OS S OS=^%ZOSF("OS")
	.S SYSTEM("MAXSTRING")=$S(OS["OpenM":512,OS["DSM":512,1:256)
	S SYSTEM("HL7 BUFFER")=$P(NODE,"^",5)
	S:'SYSTEM("HL7 BUFFER") SYSTEM("HL7 BUFFER")=15000
	S SYSTEM("USER BUFFER")=$P(NODE,"^",6)
	S:'SYSTEM("USER BUFFER") SYSTEM("USER BUFFER")=5000
	S SYSTEM("NORMAL PURGE")=$P(NODE,"^",7)
	I 'SYSTEM("NORMAL PURGE") S SYSTEM("NORMAL PURGE")=3
	S SYSTEM("ERROR PURGE")=$P(NODE,"^",8)
	I 'SYSTEM("ERROR PURGE") S SYSTEM("ERROR PURGE")=7
	S LINK=$P(NODE,"^",10)
	S:LINK SYSTEM("PORT")=$$PORT^HLOTLNK(LINK)
	S:'$G(SYSTEM("PORT")) SYSTEM("PORT")=$S(SYSTEM("PROCESSING ID")="P":5001,1:5026)
	S SYSTEM("NODE")=$P(NODE,"^",13)
	I SYSTEM("NODE") S SYSTEM("NODE")=$P($G(^%ZIS(14.7,SYSTEM("NODE"),0)),"^")
	Q
SYSPURGE(PURGE)	;returns system purge parameters
	;Output:  PURGE (pass by reference)
	;
	N NODE
	S NODE=$G(^HLD(779.1,1,0))
	S PURGE("NORMAL")=$P(NODE,"^",7)
	I 'PURGE("NORMAL") S PURGE("NORMAL")=3
	S PURGE("ERROR")=$P(NODE,"^",8)
	I 'PURGE("ERROR") S PURGE("ERROR")=7
	Q
	;
GETNODE()	;
	N NODE
	S NODE=$P($G(^HLD(779.1,1,0)),"^",13)
	Q:NODE $P($G(^%ZIS(14.7,NODE,0)),"^")
	Q ""
	;
INC(VARIABLE,AMOUNT)	;
	;Increments VARIABLE by AMOUNT, using $I if available, otherwise by locking.
	;
	N OS
	;if HLCSTATE has been defined, then we have already checked the OS, so use it.
	I $D(HLCSTATE("SYSTEM","OS")) D
	.S OS=HLCSTATE("SYSTEM","OS")
	E  D
	.S OS=^%ZOSF("OS")
	I '$G(AMOUNT) S AMOUNT=1
	I (OS["OpenM")!(OS["DSM")!(OS["CACHE") Q $I(@VARIABLE,AMOUNT)
	L +VARIABLE:100
	;Begin WorldVistA change
	;SIS/LM - Modify next for virgin environment
	;was;S @VARIABLE=@VARIABLE+AMOUNT
	S @VARIABLE=$G(@VARIABLE)+AMOUNT
	;End WorldVistA change
	L -VARIABLE
	Q @VARIABLE
	;
COUNT778()	;
	;This function returns the # of records in file 778.
	N COUNT,IEN
	S (COUNT,IEN)=0
	F  S IEN=$O(^HLB(IEN)) Q:'IEN  S COUNT=COUNT+1
	Q COUNT
COUNT777()	;
	;This function returns the # of records in file 777.
	N COUNT,IEN
	S (COUNT,IEN)=0
	F  S IEN=$O(^HLA(IEN)) Q:'IEN  S COUNT=COUNT+1
	Q COUNT
	;
UPDCNTS(WORK)	;update the record counts for file 777,778
	N COUNT
	S COUNT=$$COUNT777^HLOSITE
	S $P(^HLA(0),"^",4)=COUNT
	S ^HLTMP("FILE 777 RECORD COUNT")=COUNT_"^"_$$NOW^XLFDT
	S COUNT=$$COUNT778^HLOSITE
	S $P(^HLB(0),"^",4)=COUNT
	S ^HLTMP("FILE 778 RECORD COUNT")=COUNT_"^"_$$NOW^XLFDT
	Q
	;;HL*1.6*138 start PIJ 10/26/2007
RCNT(ST)	;This section sets or reads the recount flag.
	;; When ST="S" Flag is set
	;; When ST="U" Flag is unset
	I $G(ST)="S" S $P(^HLD(779.1,1,0),"^",11)=1
	I $G(ST)="U" S $P(^HLD(779.1,1,0),"^",11)=0
	;Begin WorldVistA change
	;SIS/LM - RCNT is called by DO command in HLOPROC1 and as an extrinsic in HLOSITE
	;       - Make next conditional on $QUIT
	;was;Q $P($G(^HLD(779.1,1,0)),"^",11)
	I $Q Q $P($G(^HLD(779.1,1,0)),"^",11)
	Q
	;End WorldVistA change
	;;HL*1.6*138 end
OLDPURGE()	;returns the retention time in days for unsent messages
	N TIME
	S TIME=$P($G(^HLD(779.1,1,0)),"^",12)
	Q $S(TIME:TIME,1:45)
