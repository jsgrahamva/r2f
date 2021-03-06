SRSRQST1	;B'HAM ISC/MAM,ADM - MAKE REQUEST (optional fields); [ 04/26/97  3:23 PM ]
	;;3.0;Surgery;**12,34,37,47,58,67,107,177,184**;24 Jun 93;Build 35
	;
	; Reference to ^TMP("CSLSUR1" supported by DBIA #3498
	;
	D:SRWL REF W @IOF W:$D(SRCC) !,?29,$S(SRSCON=1:"FIRST",1:"SECOND")_" CONCURRENT CASE" W !,?20,"OPERATION REQUEST: PROCEDURE INFORMATION",!!,SRNM_" ("_SRSSN_")",?65,SREQDT,!,SRLINE
	S SROPER=$P(^SRF(SRTN,"OP"),"^") K SROPS,MM,MMM S:$L(SROPER)<55 SROPS(1)=SROPER I $L(SROPER)>54 S SROPER=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
	W !,"Principal Procedure: ",?26,SROPS(1) I $D(SROPS(2)) W !,?26,SROPS(2) I $D(SROPS(3)) W !,?26,SROPS(3)
	I $D(SREQ(27)) W !,"Principal Procedure Code (CPT): "_$P(SREQ(27),"^",2)
	S SRSPEC=$P(^SRF(SRTN,0),"^",4),SRAVG=""
	K DR S DR="" I '$D(SREQ(27)) S DR="27T;"
	S DR=DR_".42T;S SRSCPT=$P(^SRF(SRTN,""OP""),""^"",2) D ^SRSAVG;37T//^S X=SRAVG;60T",DR(2,130.16)=".01T;3T;1.5T",DA=SRTN,DIE=130 D ^DIE K DR,DA G:$D(DTOUT) REQ G:$D(Y) SS
BLOOD	W @IOF W:$D(SRCC) !,?29,$S(SRSCON=1:"FIRST",1:"SECOND")_" CONCURRENT CASE" W !,?20,"OPERATION REQUEST: BLOOD INFORMATION",!!,SRNM_" ("_SRSSN_")",?65,SREQDT,!,SRLINE,!
	D ^SROBLOD G:$D(SRT) REQ G:$D(SRDUOUT) SS
OTH	S SRICDV=$$ICDSTR^SROICD(SRTN) W @IOF W:$D(SRCC) !,?29,$S(SRSCON=1:"FIRST",1:"SECOND")_" CONCURRENT CASE" W !,?20,"OPERATION REQUEST: OTHER INFORMATION",!!,SRNM_" ("_SRSSN_")",?65,SREQDT,!,SRLINE,!
	;JAS - 03/26/14 - PATCH 177 - Changes for ICD-10
	K DR I SRICDV["9" S DR="[SREQUEST]"
	E  S DR="[SREQUEST-ICD10]"
	S DIE=130,DA=SRTN D ^DIE K DR S:$D(DTOUT) SRDUOUT=1 I $D(SRODR) D ^SROCON1
	;End OF 177
	I $D(SRDUOUT) G REQ
SS	S SRICDV=$$ICDSTR^SROICD(SRTN) D RT K DA,DR,DIC,DIE
	S DR=$S($$SPIN^SRTOVRF():"[SRSRES-ENTRY1]",1:"[SRSRES-ENTRY]"),DIE=130,DA=SRTN D EN2^SROVAR K Q3("VIEW")
	S SPD=$$CHKS^SRSCOR(SRTN) D ^SRCUSS
	I SPD'=$$CHKS^SRSCOR(SRTN) S ^TMP("CSLSUR1",$J)=""
	K DR D:$D(SRODR) ^SROCON1 D RISK^SROAUTL3,REQ^SROPCE1 D:'$D(SRCC) REQ
	S SROERR=SRTN K SRTX D ^SROERR0
	Q
LOOP	; break procedure if greater than 54 charcaters
	S SROPS(M)="" F LOOP=1:1 S MM=$P(SROPER," "),MMM=$P(SROPER," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<55  S SROPS(M)=SROPS(M)_MM_" ",SROPER=MMM
	Q
RT	; start RT logging
	I $D(XRTL) S XRTN="SRSRQST1" D T0^%ZOSV
	Q
REF	S REFER="",SREFER=$O(^SRO(133.8,"B",SRSER,0)) I $O(^SRO(133.8,SREFER,1,$P(SRW(SRW),"^",2),1,0)) S REFER=^SRO(133.8,SREFER,1,$P(SRW(SRW),"^",2),1,1,0)
	I REFER'="" S ^SRF(SRTN,18,0)="^130.03A^1^1",^SRF(SRTN,18,1,0)=REFER,^SRF(SRTN,18,"B",$P(REFER,"^"),1)=""
DIK	K DA,DIK S DA(1)=SREFER,DA=$P(SRW(SRW),"^",2),DIK="^SRO(133.8,"_DA(1)_",1," D ^DIK
	Q
REQ	; print request message
	W !!,"A request has been made for "_SRNM_" on "_$E(SRSDATE,4,5)_"/"_$E(SRSDATE,6,7)_"/"_$E(SRSDATE,2,3)_".",!
	Q
