PRCS156P	;VMP/RB - FIX XREF 'RB' FOR DUPLCATE ENTRIES #410 ;12/09/10
	;;5.1;IFCAP;**156**;Dec 9, 2010;Build 5
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;;
	Q
FIX410	;
	;1. Post install to delete duplicate entries in x-rec 'RB' caused when
	;   using option [PRCH CONV TEMP].
	;
	Q:$D(^XTMP("PRCS156P"))
BUILD	K ^XTMP("PRCS156P") D NOW^%DTC S RMSTART=%,TT=0
	S ^XTMP("PRCS156P","START COMPILE")=RMSTART
	S ^XTMP("PRCS156P","END COMPILE")="RUNNING"
	S ^XTMP("PRCS156P",0)=$$FMADD^XLFDT(RMSTART,120)_"^"_RMSTART
0	;FIND DUPLICATE ENTRIES IN ^PRC(410,"RB") INDEX
	S REQNO="",IEN=0,U="^",DSH="-"
1	S REQNO=$O(^PRCS(410,"RB",REQNO)) G EXIT:REQNO=""!(REQNO]"@")
2	S IEN=$O(^PRCS(410,"RB",REQNO,IEN)) G 1:IEN=""
	;AUDIT 'RB' X-REF
	S R0=$G(^PRCS(410,IEN,0)) I R0="" S WDS="MISSING 0 NODE" G 3
	S R0REQ=$P(R0,U),QTRDT=$P(R0,U,11) G 2:QTRDT'>0
	S BREQ=QTRDT_DSH_$P(R0REQ,DSH)_DSH_$P(R0REQ,DSH,4)_DSH_$P(R0REQ,DSH,2)_DSH_$P(R0REQ,DSH,5)
	I REQNO=BREQ G 2
	S WDS="DUPLICATE RB"
3	S ^XTMP("PRCS156P",410,REQNO,IEN,0)=R0_";"_WDS,TT=TT+1
	K ^PRCS(410,"RB",REQNO,IEN)
	G 2
EXIT	;
	D NOW^%DTC S RMEND=%
	S ^XTMP("PRCS156P","END COMPILE")=RMEND_U_TT
	W !!,"NUMBER IEN 'RB' MISMATCHES: ",TT
	K RMEND,RMSTART,%,IEN,R0,REQNO,RBXREF,QTRDT,BREQ,DSH,R0REQ,WDS,TT
	Q
