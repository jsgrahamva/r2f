SRSRQST	;BIR/MAM,ADM - MAKE OPERATION REQUESTS ;11/01/01  9:40 AM
	;;3.0;Surgery;**3,58,67,88,103,105,100,144,175,177,182,184**;24 Jun 93;Build 35
MUST	S SRLINE="" F I=1:1:80 S SRLINE=SRLINE_"="
	W @IOF W:$D(SRCC) !,?29,$S(SRSCON=1:"FIRST",1:"SECOND")_" CONCURRENT CASE" W !,?20,"OPERATION REQUEST: REQUIRED INFORMATION",!!,SRNM_" ("_SRSSN_")",?65,SREQDT,!,SRLINE,!
SURG	; surgeon
	K DIR S DIR(0)="130,.14",DIR("A")="Primary Surgeon" D ^DIR K DIR I $D(DTOUT)!(X="^") S SRSOUT=1 G END
	I Y=""!(X["^") W !!,"To make an operation request, a Surgeon MUST be selected.  Enter '^' to exit.",! G SURG
	S SRSDOC=+Y
CASE	K DA,DIC,DD,DO,DINUM,SRTN S X=SRSDPT,DIC="^SRF(",DIC(0)="L",DLAYGO=130 D FILE^DICN K DD,DO,DIC,DLAYGO S SRTN=+Y
	N SRLCK S SRLCK=$$LOCK^SROUTL(SRTN)
	S ^SRF(SRTN,8)=SRSITE("DIV"),^SRF(SRTN,"OP")=""
	D NOW^%DTC S SREQDAY=+$E(%,1,12),SRNOCON=1 K DR,DIE
	S DA=SRTN,DIE=130,DR="36////1;Q;.09////"_SRSDATE_";.14////"_SRSDOC_";1.098////"_+SREQDAY_";1.099////"_DUZ_";Q"_";612////"_SRSDATE_";616////"_SRSDATE_";613////"_SREQDAY D ^DIE K DR
ASURG	; attending surgeon
	K DIR S DIR(0)="130,.164",DIR("A")="Attending Surgeon" D ^DIR K DIR I $D(DTOUT)!(X="^") S SRSOUT=1 G DEL
	I Y=""!(X["^") W !!,"To make an operation request, Attending Surgeon MUST be selected.  Enter '^' to exit.",! G ASURG
	S SRATTND=+Y
SPEC	; surgical specialty
	I SRWL W !,"Surgical Specialty: "_$P(^SRO(137.45,SRSS,0),"^") G OP
	K DIR S DIR(0)="130,.04",DIR("A")="Surgical Specialty" D ^DIR K DIR I $D(DTOUT)!(X="^") S SRSOUT=1 G DEL
	I Y=""!(X["^") W !!,"To make an operation request, a Surgical Specialty MUST be selected.  Enter '^'",!,"to exit.",! G SPEC
	S SRSS=+Y
OP	; principal operative procedure
	I SRWL W !,"Principal Operative Procedure: "_SRSOP G OPD
	K DIR S DIR(0)="130,26",DIR("A")="Principal Operative Procedure" D ^DIR K DIR I $D(DTOUT)!(X="^") S SRSOUT=1 G DEL
	I X["^" W !!,"Principal procedure must not contain an up-arrow (^).",! G OP
	S SRSOP=Y
OPD	; Principal Preoperative Diagnosis
	K DIR S DIR(0)="130,32",DIR("A")="Principal Preoperative Diagnosis" D ^DIR K DIR I $D(DTOUT)!(X="^") S SRSOUT=1 G DEL
	I Y=""!(X["^") W !,"Principal Preoperative Diagnosis MUST be entered",!,"before proceeding with this request. Enter '^' to exit.",! G OPD
	I X[";" W !!,"The Principal Preoperative Diagnosis cannot contain a semicolon (;).",!,"Please re-enter the Diagnosis, using commas in place of the semicolons." G OPD
	S SRSOPD=Y
	W !!,"The information entered into the Principal Preoperative Diagnosis field",!,"has been transferred into the Indications for Operation field.",!,"The Indications for Operation field can be updated later if necessary.",!
	W !!,"Press RETURN to continue  " R X:DTIME
	;
LP	; LATERALITY OF PROCEDURE
	K DIR W ! S DIR(0)="130,638",DIR("A")="Laterality Of Procedure" D ^DIR K DIR I $D(DTOUT)!(X="^") S SRSOUT=1 G DEL
	I Y=""!(X["^") W !!,"To make an operation request, Laterality Of Procedure MUST be entered.   Enter '^' to exit.",! G LP
	S SRLP=Y
PAS	; Planned Admission Status
	K DIR S DIR(0)="130,.013",DIR("A")="Planned Admission Status" D ^DIR K DIR I $D(DTOUT)!(X="^") S SRSOUT=1 G DEL
	I Y=""!(X["^") W !!,"To make an operation request, Planned Admission Status field MUST be entered. Enter '^' to exit.",! G PAS
	S SRPAS=Y
PCPT	; Planned Principal Procedure Code (CPT)
	K DIR S DIR(0)="130,27",DIR("A")="Planned Principal Procedure Code" D ^DIR K DIR I $D(DTOUT)!(X="^") S SRSOUT=1 G DEL
	I Y=""!(X["^") W !!,"To make an operation request, Planned Principal Procedure Code field MUST be entered. Enter '^' to exit.",! G PCPT
	S SRCPT=$P(Y,"^")
	;
UPDATE	S DA=SRTN,DIE=130,DR="26////"_SRSOP_";68////"_SRSOP_";.04////"_SRSS_";.164////"_SRATTND_";32////"_SRSOPD_";638////"_SRLP_";.013////"_SRPAS_";.011////"_SRPAS_";27////"_SRCPT D ^DIE
	I SRWL K DA,DIE,DR S DA=SRTN,DIE=130,DR=".016////"_SRCL(16)_";.017////"_SRCL(17)_";.018////"_SRCL(18)_";.019////"_SRCL(19)_";.0155////"_SRCL(20)_";.022////"_SRCL(21)_";.023////"_SRCL(22) D ^DIE
	D SPIN
	K DR,DA S DR="[SRO-NOCOMP]",DA=SRTN,DIE=130 D ^DIE K DR
	S ^SRF(SRTN,8)=SRSITE("DIV") D ^SROXRET K SRNOCON
OTHER	; other required fields
	S SRFLD=0 F  S SRFLD=$O(^SRO(133,SRSITE,4,SRFLD)) Q:'SRFLD!(SRSOUT)  D OTHDIR Q:SRSOUT
	I SRSOUT G DEL
	S SRSOPD(1)=SRSOPD D WP^DIE(130,SRTN_",",55,"A","SRSOPD")
	I $D(SRCC),SRSCON=2 S DIE=130,DR="35////"_SRSCON(1),DA=SRTN D ^DIE K DR S DR="35////"_SRTN,DA=SRSCON(1),DIE=130 D ^DIE K DR,DA
	D ^SROERR I $D(SRDUOUT) S SRSOUT=1 Q
	I '$D(SRCC) D ^SRSRQST1
	D:$G(SRLCK) UNLOCK^SROUTL(SRTN)
	Q
DEL	I SRSOUT S DA=SRTN,DIK="^SRF(" D ^DIK
END	D:$G(SRLCK) UNLOCK^SROUTL(SRTN)
	I SRSOUT W !!,"No request has been entered.",! S:'$D(SRCC) SRSOUT=0
	Q
CON	; request concurrent case
	D MUST Q:SRSOUT  S SRSCON(SRSCON,"DOC")=$P(^VA(200,SRSDOC,0),"^"),SRSCON(SRSCON,"SS")=$P(^SRO(137.45,SRSS,0),"^"),SRSCON(SRSCON,"OP")=SRSOP,SRSCON(SRSCON)=SRTN K DA
	Q
OTHDIR	; call to reader for site specific required fields
	;JAS - 08/05/14 - SR*3*177 - Modified this section for ICD-10
	K DIR,SREQ,SRY S FLD=$P(^SRO(133,SRSITE,4,SRFLD,0),"^") D FIELD^DID(130,FLD,"","TITLE","SRY") S DIR(0)="130,"_FLD,DIR("A")=SRY("TITLE") D DIRYN I $D(DTOUT)!($G(X)="^") S SRSOUT=1 Q
	I "^32.5^66^253^286^343^344^392^489^"[("^"_FLD_"^") I $G(X)="@"!($G(X)="") S X="^"
	I $G(Y)=""!(X["^") W !!,"It is mandatory that you provide this information before proceeding with this",!,"request.",! D ASK Q:SRSOUT  G OTHDIR
	S SREQ(130,SRTN_",",FLD)=$P(Y,"^") D FILE^DIE("","SREQ","^TMP(""SR"",$J)")
	Q
DIRYN	; call ^DIR if not FILE 80 or ICD-9 FILE 80 (added for SR*3.0*177)
	I "^32.5^66^253^286^343^344^392^489^"[("^"_FLD_"^") D  Q
	. S SRPRMT=DIR("A")_" ",SRDEF=$$GET1^DIQ(130,SRTN,FLD)
	. D ICDSRCH^SROICD
	D ^DIR
	Q 
ASK	K DIR S DIR(0)="Y",DIR("A")="Do you want to continue with this request ",DIR("B")="YES"
	S DIR("?")="Enter RETURN to continue with this request, or 'NO' to discontinue this request." D ^DIR S:'Y SRSOUT=1
	Q
SPIN	; spinal level free-text
	I '$$SPIN^SRTOVRF(SRCPT) Q
	N SL
	K DIR S DIR(0)="130,136",DIR("A")="Spinal Level Comment" D ^DIR K DIR
	S SL=$P(Y,"^") I Y=""!$D(DTOUT)!$D(DUOUT) S SL=""
	S $P(^SRF(SRTN,1.1),"^",4)=SL
	Q
