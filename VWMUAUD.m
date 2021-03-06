VWMUAUD	;DJW;Generate Meaningful Use Audit; 10/12/12
	;;1.4;VW WORLDVISTA;**1,WVEHR,LOCAL**;10/8/12;Build 3
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
GEN	;"NOTES: The purpose of this routine is to gather various
	;"       logs into file 250001.1, so that they can be printed,
	;"       sorted, etc, for display.  It does NOT include the 
	;"       RPC logs.  Every time the routine is called, it clears
	;"       out any other information, and re-gathers.
	;"       -When this function runs, it does not, itself, output
	;"        information.  Use Fileman tools on the file to do this.
	;"       -GEN is the only external entry point in this file (per Dave Whitten) 
	S U="^" K DEBUG
	N X,Y,VWBEG,VWEND
	W !,"Generate Meaningful Use Audit"
	K DIR S DIR(0)="D^::ER",DIR("A")="From Date/Time"
	I $D(DEBUG) S Y=3110601.0030
	E  D ^DIR Q:$D(DIROUT)  Q:+Y=-1
	S VWBEG=Y
	K DIR S DIR(0)="D^::ER",DIR("A")="Until Date/Time"
	I $D(DEBUG) S Y=3110605.1530
	E  D ^DIR Q:$D(DIROUT)  Q:+Y=-1
	S VWEND=Y
	W !,"From: " S Y=VWBEG X ^DD("DD") W Y," Thru "
	S Y=VWEND X ^DD("DD") W Y,!
	;
	N FDA
	S FDA=$P($G(^XUSEC(250001.1,0),"AUDIT LOG FOR MU^250001.1"),U,1,2)
	K ^XUSEC(250001.1) S ^XUSEC(250001.1,0)=FDA K FDA
	; look at AUDIT FILE #1.1 of PATIENT
	K VWCNT S VWCNT=0,D=VWBEG-0.00000001
	F  D  Q:$O(^DIA(2,"C",D))=""  Q:$O(^DIA(2,"C",D))>VWEND
	. S D=$O(^DIA(2,"C",D))
	. S I=0 F  S I=$O(^DIA(2,"C",D,I)) Q:I=""  D
	.. S VWCNT=VWCNT+1
	.. I $G(DEBUG) D
	... W "^DIA(2,""C"","""_D_""","""_I_""")",!
	... N IEN S IEN=I N DA,DIC,DR,DIQ,DIA S DIA=2
	... N %,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z
	... S DA=IEN,DIC="^DIA(2,",DR="0",DIQ(0)="CR"
	... D EN1^DIQ
	.. S RESULT=$$CLASSPT(2,I,.VWCNT)
	.. D:RESULT'="" SETMUAUD(VWCNT,RESULT)
	D RPT("AUDIT OF PATIENT")
	;
	W ! S VWCNTPAT=VWCNT
	F I="MODIFIED","CREATED","DELETED","ACCESSED" D
	. S VWCNTPAT(I)=$G(VWCNT(I)),VWCNT(I)=0
	; look at AUDIT LOG FOR RPCS
	S D=VWBEG-0.000000001
	F  D  Q:$O(^XUSEC(8994,D))=""  Q:$O(^XUSEC(8994,D))>VWEND  S VWCNT=VWCNT+1
	. S D=$O(^XUSEC(8994,D))
	. I $G(DEBUG) D
	.. W "^XUSEC(8994,"""_D_""",0)",!
	.. N IEN S IEN=D N D,DA,DIC,DR,DIQ
	.. S DA=IEN,DIC="^XUSEC(8994,",DR="0:~",DIQ(0)="CR"
	.. D EN1^DIQ
	. S RESULT=$$CLASSRPC(8994.81,D,.VWCNT)
	. D:RESULT'="" SETMUAUD(VWCNT,RESULT)
	;
	S VWCNT=VWCNT-VWCNTPAT
	D RPT("AUDIT LOG FOR RPCS")
	W ! S VWCNT=VWCNT+VWCNTPAT
	F I="MODIFIED","CREATED","DELETED","ACCESSED" D
	. S VWCNT(I)=VWCNT(I)+VWCNTPAT(I)
	D RPT("")
	S $P(^XUSEC(250001.1,0),U,3,4)=$O(^XUSEC(250001.1," "),-1)_U_VWCNT
	Q
SETMUAUD(IEN,VAL)	;
	I $G(DEBUG) W RES,!
	S ^XUSEC(250001.1,IEN,0)=VAL
	S ^XUSEC(250001.1,"B",$P(VAL,U),IEN)=""
	S ^XUSEC(250001.1,"C",$P(VAL,U,4),IEN)=""
	I $G(DEBUG) D
	. N DA,DIC,DR,DIQ
	. S DA=IEN,DIC="^XUSEC(250001.1,",DR="0",DIQ(0)="CR"
	. D EN1^DIQ
	Q
RPT(MSG)	;
	W !,VWCNT," Audit records found" W:$G(MSG)'="" " for ",MSG
	N C S C="" F  S C=$O(VWCNT(C)) Q:C=""  D
	. W !,"Count of ",C," records is ",VWCNT(C)
	Q
	;
CLASSRPC(FILE,AUDIEN,COUNT)	;
	I $G(AUDIEN)="" Q ""
	I $D(^XUSEC(8994,AUDIEN,0)) D  Q $$RP("A")
	. S COUNT("ACCESSED")=$G(COUNT("ACCESSED"))+1
	S COUNT("OTHER")=$G(COUNT("OTHER"))+1
	Q $$RP("O")
	;
RP(X)	;
	I '$G(AUDIEN) Q ""
	N DFN S DFN=$G(^XUSEC(8994,AUDIEN,100))
	N WHO S WHO=$P(^XUSEC(8994,AUDIEN,0),U,2)
	;N WHEN S WHEN=$P(AUDIEN,".")_"."_$P($P(AUDIEN,".",2),1,6)
	N WHEN S WHEN=+$J(AUDIEN,1,6)
	N RPCCALL S RPCCALL=$P($G(^XUSEC(8994,AUDIEN,0)),U)
	N AUX S AUX=$P(^XWB(8994,RPCCALL,0),U)
	Q "RPC;"_AUDIEN_U_DFN_U_WHO_U_WHEN_U_X_U_AUX
	;
PT(X)	;
	I '$G(AUDIEN) Q ""
	N DFN S DFN=$P(^DIA(2,AUDIEN,0),U)
	N WHO S WHO=$P(^DIA(2,AUDIEN,0),U,4)
	N WHEN S WHEN=$P(^DIA(2,AUDIEN,0),U,2)
	N OPTION S OPTION=$P($G(^DIA(2,AUDIEN,4.1)),U)
	S OPTION=$P($G(^DIC(19,+OPTION,0),OPTION),U,1)
	N AUX S AUX=OPTION
	Q "FILE"_FILE_";"_AUDIEN_U_DFN_U_WHO_U_WHEN_U_X_U_AUX
	;
CLASSPT(FILE,AUDIEN,COUNT)	;
	I FILE'=2 W !,"not PATIENT" Q
	I AUDIEN="" W !,"Null IEN" Q
	;
	I $D(^DIA(FILE,AUDIEN,2)),$D(^DIA(FILE,AUDIEN,3)) D  Q $$PT("M")
	. S COUNT("MODIFIED")=$G(COUNT("MODIFIED"))+1 Q
	I $D(^DIA(FILE,AUDIEN,2)) D  Q $$PT("D")
	. S COUNT("DELETED")=$G(COUNT("DELETED"))+1 Q
	I $D(^DIA(FILE,AUDIEN,3)) D  Q $$PT("C")
	. S COUNT("CREATED")=$G(COUNT("CREATED"))+1 Q
	S COUNT("ACCESSED")=$G(COUNT("ACCESSED"))+1
	Q $$PT("A")
