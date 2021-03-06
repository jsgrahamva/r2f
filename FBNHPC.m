FBNHPC	;AISC/GRR-POST COMMITMENTS TO 1358 ;1DEC00
	;;3.5;FEE BASIS;**25,153,162**;JAN 30, 1995;Build 2
	;;Per VA Directive 6402, this routine should not be modified.
	;
	;FB*3.5*153 Save requested site internal to insure obligation found in file
	;           FB7078 for time period selected is from the same station selected
	;           during option process.  This is true for both monthly activity
	;           as well as carry over activity and Insufficient Authorization 
	;           Rate data on file
	;
	;FB*3.5*162 Modify task process to include PRC("site")
	;
	S PRCS("TYPE")="FB",(FBNHCC,FBTOT)=0,PRCS("A")="Select Obligation Number: " K PRCS("X") D EN1^PRCS58 G:Y<0 Q S FBOBN=$P(Y,"^",2),FBSTA=PRC("SST")   ;FB*3.5*153
	;entry point for estimate report FBNHCC=1,(FBSEQ,FBOBN)=""
EN1	I FBNHCC D STA^PRCSUT Q:'$D(PRC("SITE"))  S FBSTA=PRC("SST")     ;FB*3.5*153
	S FBTOT=0,%DT=$S(FBNHCC:"AEPMX",1:"AEPMX"),%DT("A")=$S(FBNHCC:"Calculate ",1:"Post ")_"Commitments for which Month/Year: " D ^%DT G:X="^"!(X="") Q S FBPAYDT=$E(+Y,1,5)_"00",FBMM=$E(+Y,4,5),FBYY=$E(+Y,2,3),X=+Y D DAYS^FBAAUTL1 S FBDAYS=X
	S VAR="FBOBN^FBPAYDT^FBMM^FBYY^FBDAYS^FBNHCC^FBSTA^PRC(""SITE"")",VAL=FBOBN_"^"_FBPAYDT_"^"_FBMM_"^"_FBYY_"^"_FBDAYS_"^"_FBNHCC,PGM="START^FBNHPC" D ZIS^FBAAUTL G:FBPOP END   ;FB*3.5*162
	;
START	K ^TMP($J,"FBNHPC") S (FBPAYEDT,FBENDDT)=$E(FBPAYDT,1,5)_FBDAYS,Q="",$P(Q,"=",80)="=",(FBTOT,FBTOTAL,FBOUT)=0 U IO W:$E(IOST,1,2)["C-" @IOF D HED^FBNHPC1
	N FBCNT S FBCNT=0
	S FBIFN=0,^XTMP("FBPOST",0)=$$CDTC^FBUCUTL(DT,1)_"^"_DT
	F FBDD=FBPAYDT:0 S FBDD=$O(^FB7078("AD",7,FBDD)) Q:FBDD'>0!(FBOUT)  D
	.F  S FBIFN=$O(^FB7078("AD",7,FBDD,FBIFN)) Q:'FBIFN!(FBOUT)  I $D(^FB7078(FBIFN,0)) S FBZ=^(0) I $P(FBZ,U,9)'="DC" S (FBHIFN,FB7078)=FBIFN,FBABD=$P(FBZ,"^",4),IFN=+$P(FBZ,"^",2),DFN=+$P(FBZ,"^",3) D
	..D L(FBIFN,1) I $G(FBLERR) S FBNAME=$$NAME^FBCHREQ2(DFN),FBSSN=$$SSN^FBAAUTL(DFN),Y="Another user is editing 7078." D ERR K FBLERR,Y W ! Q
	..I '$D(^XTMP("FBPOST",FBIFN)) D CHECK^FBNHPC1,L(FBIFN,2)
	G END:FBOUT
	D PRT^FBNHPC1
	I $$WRT() W !!?10,"No funds currently need to be posted.",! G END
Q	W !!,?10,"Total ",$S(FBNHCC:"Estimated: ",1:"Posted: "),$J(FBTOT,10,2),?50,"Total Days: ",$S($D(FBTOTAL):FBTOTAL,1:0),!
	;
END	K FBMM,FBYY,FBDEFP,FBABD,FBPAYDT,FBDAYS,FBIFN,Z1,Z2,FBVCAR,FBCD,FBSEQ,FBOBN,FBNAME,FBSSN,FBPOSDT,FBNHCC,FBTOTAL,FBPAYEDT,FB7078,FBAABDT,FBX1,FBOUT,DFN,FBVEN,FBENDFLG,FBLERR
	K %,%DT,DIC,FBDD,FBERR,FBTOT,IFN,PGM,Q,VAL,VAR,Z,FBEDT,FBENDDT,FBHIFN,FBRIFN,FBTDT,FBTRDYS,FBZ,FB,I,PRCS,Y,PRC,PRCSCPAN,X,X1,^TMP($J,"FBNHPC")
	K FBSTA,FBOBIEN,FBOBNO,PRC23,FBPOP,FBCNT,FBHIN,FBMM
	K ^XTMP("FBPOST") D CLOSE^FBAAUTL Q
	;
WRT()	;determine if write to output
	;return 1 if nothing to post
	Q $S('$G(FBTOT):1,'$G(FBTOTAL):1,1:0)
	;
ERR	W !!,*7,"Unable to Post the following transaction because of the following:",!,Y,!?7,FBNAME,?40,FBSSN I '$G(FBLERR) W ?60,"$"_$FN(FBDEFP,",",2)
	Q
	;
L(FBDA,FBL)	;lock/unlock 7078
	;INPUT:  FBDA = ien (fbifn) of 7078 file
	;        FBL = lock code:  1 to lock, 2 to unlock
	;OUTPUT:  no output variables; fb7078 entry will be locked or unlocked
	N FBLCTR S FBLCTR=0
L1	I $S('+$G(FBDA):1,'+$G(FBL):1,1:0) Q
	I FBL=1 L +^FB7078(FBDA):2 I '$T S FBLCTR=FBLCTR+1 G:FBLCTR<5 L1 S FBLERR=1 Q
	I FBL=2 K ^XTMP("FBPOST",FBDA) L -^FB7078(FBDA)
	Q
