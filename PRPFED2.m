PRPFED2	;ALTOONA/CTB  MISCELLANEOUS EDIT OPTIONS ;11/22/96  4:38 PM
V	;;3.0;PATIENT FUNDS;**6,18**;JUNE 1, 1989;Build 9
LONGREG	S DIC(0)="AEQLM",DIC=470,DLAYGO=470 D ^DIC G:Y<0 OUT^PRPFED S DA=+Y,DIE=DIC,DR="[PRPF LONG REGISTRATION]" D ^DIE G LONGREG
	;
SELDATA	S DIC(0)="AEQM",DIC=470 W !! D ^DIC G OUT^PRPFED:Y<0 S DA=$P(Y,U,1),DIE=DIC,DR="[PRPF SELECTED DATA EDIT]" D ^DIE G SELDATA
	;
SHORTREG	S DIC(0)="AEQLM",DIC=470,DLAYGO=470 W !! D ^DIC G:Y<0 OUT^PRPFED S DA=+Y,DIE=DIC,DR="[PRPF SHORT REGISTRATION]" D ^DIE G SHORTREG
	;
ADDRESS	S DIC=470,DIC(0)="AEMN" D ^DIC G:Y<0 OUT^PRPFED S DA=+Y,DIE="^DPT(",DR=".111;.112;.113;.114;.115;.116;.131;.132" D ^DIE G ADDRESS
	;
GUARDIAN	S DIC=2,DIC(0)="AEMN" D ^DIC G:Y<0 OUT^PRPFED S DA=+Y,DIE="^DPT(",DR=".291;.2912;.2914;.2915;.2916;.2917;.2918;.2919;.292;.2922;.2923;.2924;.2925;.2926;.2927;.2928;.2929" D ^DIE G GUARDIAN
	;
INACT	;EDIT ACCOUNT STATUS
	S DIC=470,DIC(0)="AEMNQO" D ^DIC I Y>0 S DA=+Y,DIE=DIC,DR="[PRPF INACTIVE/ACTIVE]" D ^DIE W ! G INACT
	K %,%W,%X,%Y,C,D0,DA,DI,DIYS,DIC,DIE,DQ,DR,I,K,POP,S,X,Y Q