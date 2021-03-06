ECBEP1B	;BIR/MAM,JPW-Batch Entry by Procedure (cont'd) ;30 Apr 96
	;;2.0; EVENT CAPTURE ;**1,4,5,10,13,17,18,42,47,54,72,76**;8 May 96;Build 6
CHK	; check unit for valid categories
	K ECC,ECCN,ECHOICE,ECEC,ECSTOP
	S (COUNT,EC1)=0
	D CATS^ECHECK1 S ECONE=""
	I '$D(ECC(1)) S ECC=0,ECCN="None",ECONE=0 G P
	I '$D(ECC(2)) S ECC=+ECC(1),ECCN=$P(ECC(1),"^",2),ECONE=1 G P
CATS	; select category
	S X="",CNT=0
LIST	D HDRP^ECBEN2U S JJ=0 W !,"Categories within "_ECDN_": ",!
	S EC1=0
	F  S CNT=$O(ECC(CNT)) Q:'CNT!$D(ECHOICE)  D:($Y+5>IOSL) SELC Q:$D(ECHOICE)  I X="" W !,CNT_".",?5,$P(ECC(CNT),"^",2)
	I '$D(ECSTOP),$D(ECHOICE) S ECONE=2 G P
PICK	W !!,"Select Number:  " R X:DTIME I '$T!("^"[X) S ECOUT=1 Q
	I X="" S ECOUT=2 Q
	I '$D(ECC(X)) W !!,"Select the number corresponding to the category, or ^ to quit.",!!,"Press <RET> to continue  " R X:DTIME S CNT=CNT-5,X="" G LIST
	S ECHOICE=1,ECC=$P(ECC(X),"^"),ECCN=$P(ECC(X),"^",2),ECONE=2
P	;check for valid procedures
	D PROS^ECHECK1
	I '$O(^TMP("ECPRO",$J,0)) D  Q:ECOUT
	.W !!,"Within the ",ECLN," location there are no procedures defined",!
	.W "for the DSS Unit ",ECDN,".  Please select another DSS Unit.",!!
	.W "Press <RET> to continue " R X:DTIME S ECOUT=2 Q
	D HDRP^ECBEN2U
P1	;
	I '$D(^TMP("ECPRO",$J,2)) S CNT=1,ECONE=ECONE_"^1" D SETP W !,"Procedure: " D  G CHKP
	. W $S(ECCPT="":"",1:ECPTCD_" ")_$E(ECPN,1,50)
	. W $S(SYN'["NOT DEFINED":" ["_SYN_"]",1:"")_"  (#"_NATN_")",!
P2	;ask mul proc
	S ECX="",(ECPCNT,CNT,OK)=0,EC1=1 K ECHOICE,ECSTOP
	S DIR("?")="^D PROS^ECBEP1B"
	S ECX=$$GETPRO^ECDSUTIL
	I +$G(ECX)=-1,(COUNT=0) S ECOUT=2 D KILLV^ECDSUTIL Q
	I +$G(ECX)=-1,COUNT G FILE
	I +$G(ECX)=1 D SRCHTM^ECDSUTIL(ECX)
	S ECPCNT=+$G(ECPCNT)
	I ECPCNT=-1!(ECPCNT=-2) D  G P2
	.; Don't display spacebar/return error msg since only 1 procedure
	. D ERRMSG^ECDSUTIL
	. D KILLV^ECDSUTIL
	I ECPCNT>0 D  G CHKP
	. S CNT=ECPCNT
	. D SETP
	. S OK=1,ECONE=ECONE_"^2"
	. D KILLV^ECDSUTIL
	I 'ECPCNT,$D(ECPNAME) S CNT=$$PRLST^ECDSUTIL
	I CNT=-1 D MSG^ECBEN2U,KILLV^ECDSUTIL Q
	I CNT>0 D  G CHKP
	. D SETP
	. S OK=1,ECONE=ECONE_"^2"
	. D KILLV^ECDSUTIL
	Q
	;
PROS	;
	S X="",CNT=0 K ECHOICE
LISTP	D HDRP^ECBEN2U S JJ=1 W !,"Available Procedures within "_ECDN_": ",!
	W ?72,"National",!,?5,"Procedure Name",?40,"Synonym",?72,"Number",!
	S EC1=1
	F   S CNT=$O(^TMP("ECPRO",$J,CNT)) Q:'CNT!$D(ECHOICE)  D:($Y+5>IOSL) SELC Q:$D(ECHOICE)  I X="" W !,CNT_".",?5,$E($P(^TMP("ECPRO",$J,CNT),"^",4),1,30),?38,$E($P(^(CNT),"^",3),1,30),?72,$P(^(CNT),"^",5)
	I X="" D
	.W !!?5,"Select by number, CPT or national code, procedure name, or synonym.",!?5,"Synonym must be preceded by the & character  (example:  &TESTSYN).",!
	.W ?2,"** Modifier(s) can be appended to a CPT code (ex: CPT code-mod1,mod2,mod3) **",!
	Q
	;
CHKP	;
	;Ask CPT procedure modifiers
	I ECCPT'="" D  K ECMODF,ECMODS
	. S ECMODS=$G(ECMODS)
	. S ECMODF=$$ASKMOD^ECUTL(ECCPT,ECMODS,ECDT,.ECMOD,.ECERR)
	I $G(ECERR) S ECOUT=2 K ECERR,ECMOD D KILLV^ECDSUTIL Q
	;
	;- Ask procedure reason
	I $G(ECP)]"" S ECSCR=+$O(^ECJ("AP",+ECL,+ECD,+ECC,ECP,0))
	K ECPRPTR
	I ECSCR>0,($P($G(^ECJ(ECSCR,"PRO")),"^",5)=1),(+$O(^ECL("AD",ECSCR,0))) D
	. S ECPRPTR=0
	. S DIC="^ECL(",DIC(0)="QEAM"
	. S DIC("A")="Procedure Reason: ",DIC("S")="I $P(^(0),U,2)=ECSCR"
	. D ^DIC K DIC
	. I +Y>0 S ECPRPTR=+Y
	K ECSCR W !
	;
	I $G(ECCN)]"" W !,"Category: ",ECCN
	W !,"Procedure: ",$S(ECCPT="":"",1:ECPTCD_" ")_$E(ECPN,1,50)
	W $S(SYN'["NOT DEFINED":" ["_SYN_"]",1:"")_"  (#"_NATN_")"
	;
	;- Display CPT procedure Modifiers
	I ECCPT'="" N MOD S MOD="" F  S MOD=$O(ECMOD(ECCPT,MOD)) Q:MOD=""  D
	. W !?1,"Modifier: ","    - ",MOD," ",$E($P(ECMOD(ECCPT,MOD),U),1,55)
	;- Display procedure reason
	I +$G(ECPRPTR) S ECPRSL=$P($G(^ECL(+ECPRPTR,0)),"^") W !,"Procedure Reason: ",$P($G(^ECR(+ECPRSL,0)),"^")
	D DSP1442^ECPRVMUT(.ECPRVARY)
	W !
	W !!,"Is this information correct ?  YES//  " R ECYN:DTIME I '$T!(ECYN="^") Q
	S ECYN=$E(ECYN) S:ECYN="" ECYN="Y"
	I "YyNn"'[ECYN W !!,"Enter <RET> if the information listed above is correct and should be",!,"entered for the patients selected.  Enter NO to re-enter the information",!,"for this procedure.",!
	I "YyNn"'[ECYN W !!,"Press <RET> to continue  " R X:DTIME G CHKP
	I "Nn"[ECYN,$P(ECONE,"^")<2,$P(ECONE,"^",2)<2 S ECOUT=2 Q
	I "Nn"[ECYN K ECHOICE,ECCN,ECP,ECPN,ECMOD,ECONE,^TMP("ECPRO",$J) G CHK
	;
	;- File procedure reason in local array ECEC (used in ECBEPF)
	S COUNT=COUNT+1,ECEC(COUNT)=ECC_"^"_ECP_"^^^^^^^"_ECCPT_"^"_EC4_"^"_ECID_$S(+$G(ECPRPTR):"^"_ECPRPTR,1:"")
	;- File CPT modifiers in local array ECEC
	I ECCPT'="",$O(ECMOD(ECCPT,""))'="" D
	. M ECEC(COUNT,"MOD")=ECMOD(ECCPT)
FILE	;file proc
	I '$D(ECEC(1)) W !!,"No procedures have been selected for filing.  Please re-enter the ",!,"information for the procedures, or ^ to exit.",!!,"Press <RET> to continue" R X:DTIME S:X="^" ECOUT=1 K ECTEMP,^TMP("ECPRO",$J) G P
	D ^ECBEP2A Q:ECOUT  K ECA,ECCN,ECEC,ECHOICE,ECJLP,ECP,ECPN,ECPT,ECO,ECON,ECV,NATN,NODE,SYN,^TMP("ECPRO",$J),ECDX,ECDXN,ECINP,ECCPT,ECSC,ECIR,ECZEC,ECAO,ECVST,ECPTSTAT,ECMST,ECHNC,ECCV,ECSHAD,ECMOD,ECPTCD G CHK
END	Q
SETP	;set proc
	S ECP=$P(^TMP("ECPRO",$J,CNT),"^"),ECPN=$P(^(CNT),"^",4),SYN=$P(^(CNT),"^",3),NATN=$P(^(CNT),"^",5),VOL=$P(^(CNT),"^",6)
	S ECCPT=$S(ECP["EC":$P($G(^EC(725,+ECP,0)),"^",5),1:+ECP)
	S ECPTCD="" I ECCPT'="" D
	. S ECPTCD=$$CPT^ICPTCOD(ECCPT,ECDT) I +ECPTCD>0 S ECPTCD=$P(ECPTCD,U,2)
	W "  "_$S(ECCPT="":"",1:ECPTCD_" ")_$E(ECPN,1,50)
	W $S(SYN'["NOT DEFINED":" ["_SYN_"]",1:"")_"  (#"_NATN_")",!
	S EC4=$P(^TMP("ECPRO",$J,CNT),"^",2),EC4=$P($G(^ECJ(+EC4,"PRO")),"^",4)
	S EC4N=$S($P($G(^SC(+EC4,0)),"^")]"":$P(^(0),"^"),1:"NO ASSOCIATED CLINIC"),ECID=$P($G(^SC(+EC4,0)),"^",7)
	Q
SELC	; select category
	W !!,$S(EC1:"Press",1:"Select Number, or press")_" <RET> to continue listing "_$S(EC1:"procedures",1:"categories")_" or '^' to stop:  " R X:DTIME I '$T!(X="^") S (ECSTOP,ECHOICE)=1 Q
	I X="" W @IOF,!,$S(EC1:"Available Procedures",1:"Categories")_" within ",ECDN," : ",! Q
	I 'EC1,'$D(ECC(X)) D MSG1^ECBEN2U S ECOUT=2 Q
	I EC1,'$D(^TMP("ECPRO",$J,X)) D MSG1^ECBEN2U S ECOUT=2 Q
	S ECHOICE=1
	I 'EC1 S ECC=$P(ECC(X),"^"),ECCN=$P(ECC(X),"^",2) Q
	Q
