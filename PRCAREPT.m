PRCAREPT	;SF-ISC/YJK-AR LIST,REPORT ;8/26/93  8:43 AM
V	;;4.5;Accounts Receivable;**68,63,108,299**;Mar 20, 1995;Build 6
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;MAS,Agent Cashier, 3rd party,RC/DOJ reports.
PRINT	;ask if the report will be queued.
	K PRCAQUE S PRCA("MESS")="Do you wish to queue this report "
QUE	S %=2 W !,PRCA("MESS") D YN^DICN Q:%<0  W " "
	I %=0 W !,"Answer <YES> or <NO>" G QUE
	K IO("Q") S %ZIS("B")="",%ZIS="M",PRCA("DEV")="" S:%=1 %ZIS="MQ",PRCA("DEV")="Q;",IOP="Q"
	;
DIP	S L=0,FLDS=PRCATEMP,BY=PRCASORT,FR=PRCAFT,TO=PRCALAST,DHD=PRCAHDR
	D EN1^DIP K L,FLDS,BY,FR,TO,DHD,DIC,DIS,IOP
	;
KILLV	K ZTSK,PRCAKDT1,PRCAQUE,DQTIME,PRCAKDT2,PRCACT,PRCARCOJ,PRCATEMP,PRCADT1,PRCADT2,PRCABN,PRCABILN,PRCAHDR,PRCAFT,PRCALAST,PRCATEMP,PRCASORT,PRCADMC,PRCANAME,DTOUT,DUOUT,DIR,DIRUT Q
END	D KILLV K PRCA,PRCAIOP Q
	;
REPT	;====================== REPORT SUBROUTINES ==========================
EN2	;report for MAS reconciliation with AR for 3rd Party.
	S PRCA("DATE")="DATE BILL PREPARED" D ASKDT^PRCAQUE G:(PRCADT1="")!(PRCADT2="") END
	S PRCAFT=PRCADT1_",T,100",PRCALAST=PRCADT2_",T,199",PRCAHDR="MAS RECONCILIATION REPORT"
	S DIC="^PRCA(430," S PRCATEMP="[PRCAR MAS REPORT]",PRCASORT="@DATE BILL PREPARED,@CATEGORY:INTERNAL(TYPE),@CURRENT STATUS:STATUS NUMBER" D PRINT,END Q
	;
EN3	;print 3rd party accounts receivable report.
	S PRCAHDR="3RD PARTY ACTIVE REFERRAL REPORT"
	S PRCASORT="DEBTOR;S2,PATIENT,RC/DOJ REFERRAL DATE,@CURRENT STATUS:STATUS NUMBER,@CATEGORY:INTERNAL(TYPE)"
	S PRCAFT=",,,102,T",PRCALAST=",,,102,T"
	S PRCATEMP="[PRCA 3RD REPORT]",DIC="^PRCA(430," D PRINT,END Q
	;
EN4	;Report AR referred to RC
	S PRCA("DATE")="DATE REFERRED TO RC" D ASKDT^PRCAQUE G:(PRCADT1="")!(PRCADT2="") END
	S PRCACT=0,PRCARCOJ="",PRCATEMP="[PRCAD DC DOJ]"
	S PRCASORT="DEBTOR;S1,@RC/DOJ REFERRAL DATE,@RC/DOJ REFERRAL CODE"
	S PRCAFT=","_PRCADT1_",RC",PRCALAST=","_PRCADT2_",RC"
	S PRCAHDR="ACCOUNTS RECEIVABLE REFERRED TO RC"
	K PRCAEN4 S DIC="^PRCA(430," D PRINT,END Q
	;
EN5	;Report AR referred to DOJ
	S PRCA("DATE")="DATE REFERRED TO DOJ" D ASKDT^PRCAQUE G:(PRCADT1="")!(PRCADT2="") END
	S PRCATEMP="[PRCAD DC DOJ]",PRCASORT="DEBTOR;S1,@RC/DOJ REFERRAL DATE,@RC/DOJ REFERRAL CODE"
	S PRCAFT=","_PRCADT1_",DOJ",PRCALAST=","_PRCADT2_",DOJ"
	S PRCAHDR="ACCOUNTS RECEIVABLE REFERRED TO DOJ",DIC="^PRCA(430," D PRINT,END Q
	;
EN6	;print other transaction for CALM code sheet in the AT section.
	D TSK^PRCAPTR Q
	;
EN8	;RC debt collection report.
	S PRCA("DATE")="DATE RC TRANSACTION CREATED" D ASKDT^PRCAQUE G:(PRCADT1="")!(PRCADT2="") END
	S PRCATEMP="[PRCAS DC]",PRCASORT="+TRANSACTION TYPE;S2,@DATE ENTERED"
	S PRCAHDR="REGIONAL COUNSEL DEBT COLLECTION REPORT FROM "_PRCAKDT1_" TO "_PRCAKDT2
	S DIC="^PRCA(433,",PRCAFT=","_PRCADT1,PRCALAST=","_PRCADT2
	S DIS(1)="I $P($G(^PRCA(433,D0,0)),U,7)=""RC"""
	S DIS(2)="I $P($G(^PRCA(433,D0,0)),U,7)=""DC"""
	S DIS(0)="I $P($G(^PRCA(433,D0,1)),U,2)'=45"
	D PRINT,END Q
	;
EN9	;DOJ debt collection report.
	S PRCA("DATE")="DATE DOJ TRANSACTION CREATED" D ASKDT^PRCAQUE G:(PRCADT1="")!(PRCADT2="") END
	S PRCATEMP="[PRCAS DC]",PRCASORT="+TRANSACTION TYPE;S2,@RC DOJ CODE,@DATE ENTERED"
	S PRCAHDR="DEPARTMENT OF JUSTICE DEBT COLLECTION REPORT FROM "_PRCAKDT1_" TO "_PRCAKDT2
	S DIC="^PRCA(433,",PRCAFT=",DOJ,"_PRCADT1,PRCALAST=",DOJ,"_PRCADT2
	S DIS(0)="I $P($G(^PRCA(433,D0,1)),U,2)'=45"
	D PRINT,END Q
	;
EN10	;print contingent (Worker's Comp & Tort Feasors) 3rd party accounts receivable report.
	S PRCA("DATE")="DATE REFERRED TO RC/DOJ" D ASKDT^PRCAQUE G:(PRCADT1="")!(PRCADT2="") END
	S PRCAHDR="REFERRED TP TORT & WORKER'S COMP AR REPORT"
	S PRCASORT="DEBTOR;S1,@REFERRAL DATE,@CURRENT STATUS:STATUS NUMBER,@CATEGORY:CATEGORY NUMBER"
	S PRCAFT=","_PRCADT1_",102,22",PRCALAST=","_PRCADT2_",102,23"
	S PRCATEMP="[PRCAR CONTINGENT REPORT]",DIC="^PRCA(430," D PRINT,END Q
	;
EN11	;print DMC referred debts
	W !!,"This report should be run on or AFTER the first Wednesday of the month."
	W !,"Make sure your facility has received the monthly offset information from"
	W !,"the DMC to insure the accuracy of this report."
	;
	W !!,?5,"Enter DMC Report to print:"
	W !,?10,"1 - All Patients"
	W !,?10,"2 - Single Patient",!
	;
	S DIR(0)="LO^1:2:0"
	S DIR("A")="Report",DIR("B")="1",DIR("?",1)="Enter '1' to print DMC information for ALL patients.",DIR("?")="Enter '2' to print DMC information about a single patient."
	D ^DIR G:$D(DIRUT) END
	S PRCADMC=+Y
	;
	I PRCADMC=2 S DIC="^RCD(340,",DIC(0)="AEQZ" D ^DIC I Y<0 K PRCADMC,DIC G END
	S PRCANAME=+Y
	I $D(DTOUT)!$D(DUOUT) G END
	S PRCAHDR="REFERRED DMC DEBTS"
	;S PRCASORT="@DATE SENT TO DMC,+@INTERNAL(DEBTOR);S2"
	I PRCADMC=1 S PRCAFT=",",PRCALAST=",",PRCASORT="@DATE SENT TO DMC,+DEBTOR;S2"
	I PRCADMC=2 S PRCAFT=","_PRCANAME,PRCALAST=","_PRCANAME,PRCASORT="@DATE SENT TO DMC,+@INTERNAL(DEBTOR)"
	S PRCATEMP="[RCDMC REFERRED DEBTS]",DIC="^PRCA(430," D PRINT,END Q
	;
