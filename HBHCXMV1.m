HBHCXMV1	;LR VAMC(IRMS)/MJT - HBHC, called by ^HBHCXMV, entry points:  START, PCE, PSSN, & EXIT, calls HOSP^HBHCUTL1 ;Aug 2000
	;;1.0;HOSPITAL BASED HOME CARE;**6,15,14,19,24,25**;NOV 01, 1993;Build 45
	;******************************************************************************
	;******************************************************************************
	;                       --- ROUTINE MODIFICATION LOG ---
	;        
	;PKG/PATCH    DATE        DEVELOPER    MODIFICATION
	;-----------  ----------  -----------  ----------------------------------------
	;HBH*1.0*25   APR  2012   K GUPTA      Support for ICD-10 Coding System
	;******************************************************************************
	;******************************************************************************
	;
START	; Initialization
	W !,"Processing Visit/Form 4 Data"
	K ^HBHC(634.5) S ^HBHC(634.5,0)="HBHC PSEUDO SSN ERROR(S)^634.5P^"
	S HBHCFORM=4,$P(HBHCSP1," ",2)="",$P(HBHCSP2," ",3)="",$P(HBHCSP4," ",5)="",$P(HBHCSP5," ",6)="",$P(HBHCSP8," ",9)="",$P(HBHCSP10," ",11)="",$P(HBHCSP64," ",65)="",$P(HBHCZRO4,"0",5)=""
	D HOSP^HBHCUTL1
	K %DT S X="T" D ^%DT S HBHCTDY=Y
	Q
PCE	; Appointment pre-dates Patient Care Encounter (PCE)
	S DIE="^HBHC(632,",DA=HBHCDFN,DR="7///O" D ^DIE
	Q
PSSN	; Patient has pseudo SSN
	K DD,DO S DIC="^HBHC(634.5,",DIC(0)="MN",(X,DINUM)=$P(HBHCINFO,U) D FILE^DICN K DO
	Q
EXIT	; Exit module
	K DA,DIC,DIE,DILOCKTM,DINUM,DR,DTOUT,HBHCAPDT,HBHCCNT,HBHCCNT1,HBHCCPT1,HBHCCPT2,HBHCCPT3,HBHCCPT4,HBHCCPT5,HBHCCPT6,HBHCCPT7,HBHCCPT8,HBHCCPT9,HBHCCP10,HBHCDATE,HBHCDFN,HBHCDX,HBHCDX1,HBHCDX2,HBHCDX3,HBHCDX4,HBHCDX5,HBHCFLAG,HBHCFORM
	K HBHCHOSP,HBHCI,HBHCINFO,HBHCJ,HBHCK,HBHCL,HBHCLNME,HBHCNDX1,HBHCNDX2,HBHCNOD2,HBHCPRV,HBHCREC,HBHCQAI,HBHCSP1,HBHCSP10,HBHCSP2,HBHCSP4,HBHCSP5,HBHCSP8,HBHCSP64,HBHCSSN,HBHCSTDT,HBHCTDY,HBHCTIME,HBHCXMT4,HBHCZRO4,X,Y,%DT
	Q
