XWBVW	;GFT - PURGE RPC AUDIT;18FEB2011, 10/17/12 (//kt)
	;;8.0;KERNEL;**WVEHR,LOCAL**;Jul 10, 1995;Build 3
	; part of WorldVistA Meaningful Use Auditing
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
TRAP(XWB)	;BRING IN THE XWB ARRAY AT TIME OF CALL
	N DFN,RPCNAME
	S RPCNAME=$G(XWB(2,"RPC"))
	S DFN=$$FINDFN(RPCNAME) ;'RPCNAME' IS NAME OF RPC TO BE FOUND IN FILE 8994.8
	I DFN D LOGRPC(RPCNAME,DFN)
	Q
	;
	;
FINDFN(RPCNAME)	;XWB ARRAY IS ALSO DEFINED WHEN ENTERING HERE
	N XWBVW,X
	I $G(RPCNAME)="" Q ""
	S XWBVW=$O(^XWBVW("B",RPCNAME,0)) I 'XWBVW Q ""
	I '$P($G(^XWBVW(XWBVW,0)),"^",2) Q "" ;WON'T WORK IF LOGGABLE RPC IS NOT ACTIVE
	S X=+$G(^XWBVW(XWBVW,100)) I X Q +$G(XWB(5,"P",X-1)) ;NODE 100 SAYS WHICH PARAMETER IS DFN; PARAMETERS ARE NUMBERED STARTING FROM 0
	S X=+$G(^XWBVW(XWBVW,101)) I X S X=+$G(XWB(5,"P",X-1)) I X S X=$P($G(^OR(100,X,0)),U,2) I X["DPT(" Q +X ;NODE 101 SAYS WHICH PARAMETER IS ORDER
	S X=+$G(^XWBVW(XWBVW,102)) I X S X=+$G(XWB(5,"P",X-1)) I X S X=$P($G(^TIU(8925,X,0)),U,2) Q +X ;NODE 102 SAYS WHICH PARAMETER IS IEN IN 8925  //kt added
	Q ""
	;
	;
LOGRPC(RPC,XWBDFN)	;WorldVistA-GFT/RWF RPC audit   ---  something like XQ12 routine;  //kt mod
	N %,Y,XWBVW
	I '$G(XWBDFN) Q
	I RPC'?1.NP Q:RPC=""  S RPC=$O(^XWB(8994,"B",RPC,0)) Q:'RPC
	S %=$P($H,",",2),%=DT_(%\60#60/100+(%\3600)+(%#60/10000)/100)
	N DEVPTR,IPPTR,CPU
	I $G(XWBVWAUDENV)'="" D
	. N IDX,VNAME S IDX=1
	. F VNAME="DEVPTR","IPPTR","CPU" S @VNAME=$P(XWBVWAUDENV,U,IDX),IDX=IDX+1
	E  D
	. S DEVPTR=$$DEVPT($I,"D")
	. S IPPTR=$$DEVPT($GET(IO("IP")),"I")
	. D GETENV^%ZOSV S CPU=$P(Y,U,2) U XWBNULL ;GETENV^%ZOSV redirects IO, so restore
	       . S XWBVWAUDENV=DEVPTR_"^"_IPPTR_"^"_CPU ;"leave on var table, so next RPC call can be faster.
	L +^XUSEC(8994,0):0
	F XWBVW=%:.00000001 Q:'$D(^XUSEC(8994,XWBVW))
	S ^(XWBVW,0)=RPC_"^"_$G(DUZ)_"^"_DEVPTR_"^"_$J_"^"_IPPTR_"^"_CPU
	L -^XUSEC(8994,0)
	S $P(^(0),U,3,4)=XWBVW_"^"_($P(^XUSEC(8994,0),U,4)+1) ;update header
	S ^XUSEC(8994,XWBVW,100)=XWBDFN
	; --- store params ---
	N PSTR,IDX S (IDX,PSTR)=""
	F  S IDX=$O(XWB(5,"P",IDX)) Q:IDX=""  D
	. I (PSTR'="") S PSTR=PSTR_"|"
	. S PSTR=PSTR_$G(XWB(5,"P",IDX))
	I PSTR'="" S ^XUSEC(8994,XWBVW,101)=PSTR  ;"Note: field is not indexed
	;WorldVistA-GFT/RWF-indices
	S ^XUSEC(8994,"APAT",XWBDFN,XWBVW)=""
	S ^XUSEC(8994,"AD",+$G(DUZ),XWBVW)=""
	Q
	;
	;
DEVPT(DEV,TYPE)	;"Turn $I or IP into pointer from 8994.835 (or "" if not found) ;//kt
	       NEW RESULT SET RESULT=""
	       IF ($GET(DEV)="")!($GET(TYPE)="") GOTO DPDN
	       SET RESULT=+$ORDER(^XWB(8994.835,"B",DEV,""))
	       IF RESULT>0 GOTO DPDN
	       ;"Below is slow, but should be needed only rarely
	       NEW VWFDA,VWIEN,VWMSG
	       SET VWFDA(8994.835,"+1,",.01)=DEV
	       SET VWFDA(8994.835,"+1,",.02)=TYPE
	       DO UPDATE^DIE("","VWFDA","VWIEN","VWMSG") ;"errors ignored
	       SET RESULT=+$GET(VWIEN(1))
	       IF RESULT'>0 SET RESULT=""
DPDN	   QUIT RESULT
	       ;
	       ;
XWBPURGE	;RPC audit purge  --- 'XWBAPURGE' Option    --- stolen from XUAPURGE routine
	N %DT,BDATE,EDATE,ZTIO,ZTRTN,ZTUCI,ZTSAVE,ZTSK
	D BEG G:'$D(EDATE) END
	;S ZTIO="",ZTRTN="PURGE^XWBVW",ZTDESC="Purge Menu Option Audit Entries" F G="BDATE","EDATE" S ZTSAVE(G)=""
	;D ^%ZTLOAD K ZTIO,ZTRTN,ZTDESC,ZTUCI,ZTSAVE
	;Q
PURGE	F REC=BDATE-.000001:0 S REC=$O(^XUSEC(8994,REC)) Q:REC'>0!(REC>EDATE)  S DIK="^XUSEC(8994,",DA=REC D ^DIK K DA
END	Q
	;
BEG	W !!,"You will be asked for a date range to purge, Begin to End"
	S %DT("A")="PURGE BEGIN DATE: ",%DT="AETX" D ^%DT S BDATE=Y G:Y<1 END S %DT(0)=BDATE,%DT("A")="PURGE END DATE: " D ^%DT S EDATE=Y G:Y<1 END
	Q
	;
	;
	;
	;
	;
POPTEMPL(TEMPLATE)	;FROM AN 8994 TEMPLATE INTO 8994.8
	N DIC,DFN,RPC,DFNX,ORD,ORDX
	Q:$P($G(^DIBT(TEMPLATE,0)),U,4)-8994
	F RPC=0:0 S RPC=$O(^DIBT(TEMPLATE,1,RPC)) Q:'RPC  D POPRPC(RPC)
	Q
	;
POPRPC(RPC)	;
	S X=$P(^XWB(8994,RPC,0),U,2,3) I X[U,$T(@X)]"" D
	.S (DFN,DFNX,ORD,ORDX)=0
	.F SEQ=0:0 S SEQ=$O(^XWB(8994,RPC,2,SEQ)) Q:'SEQ  D  Q:DFN
	..I $P(^(SEQ,0),U)["DFN" S DFNX=SEQ,DFN=$P(^(0),U,5) Q
	..;I $P(^(0),U)["ORIFN" S ORDX=SEQ,ORD=$P(^(0),U,5)
	.S:DFN DFNX=DFN Q:'DFNX
	.S DIC=8994.8,DIC(0)="L",DIC("DR")="100///"_DFNX,X=$$GET1^DIQ(8994,RPC,.01) D ^DIC
	Q
