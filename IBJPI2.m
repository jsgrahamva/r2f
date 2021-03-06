IBJPI2	;DAOU/BHS - eIV SITE PARAMETERS SCREEN ACTIONS ;26-JUN-2002
	;;2.0;INTEGRATED BILLING;**184,271,316,416,438**;21-MAR-94;Build 52
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;
	; eIV - electronic Insurance Verification Interface
	;
	; Only call from tag
	Q
	;
MP	; Most Popular Payer processing
	Q
	; Set error trap to ensure that lock is released
	N $ES,$ET
	S $ET="D ER^IBJPI2"
	; Check lock
	L +^IBCNE("MP"):1 I '$T W !!,"The Most Popular Payers List is being edited by another user, please retry later." D PAUSE^VALM1 G MPX
	; Call ListMan screen
	D EN^IBJPI3
	L -^IBCNE("MP")  ; Unlock
	;
MPX	; MP exit pt
	D INIT^IBJPI S VALMBCK="R"
	Q
	;
IIVEDIT(IBJDR)	; -- IBJP IIV EDIT ACTIONS (GP,PW):  Edit eIV Site Parameters
	; IBJDR - 0 (General Parameters section)
	;         1 (Patients Without Insurance section) - NO LONGER A VALID PARAMETER AFTER IB*2*416
	N DA,DR,DIE,DIC,X,Y
	;
	D FULL^VALM1
	W @IOF,!,$S(IBJDR=0:"General",1:"Unknown")_" Parameters",!
	; Build string of fields to edit or input template based on IBJDR
	I IBJDR'="" S DR=$P($T(@IBJDR),";;",2,999)
	I DR'="" S DIE="^IBE(350.9,",DA=1 D ^DIE K DA,DR,DIE,DIC,X,Y
	;
	D INIT^IBJPI S VALMBCK="R"
	Q
	;
0	;;[IBCNE GENERAL PARAMETER EDIT]
	;
	;
ER	; Unlock most popular payer and return to log error
	L -^IBCNE("MP")
	D ^%ZTER
	D UNWIND^%ZTER
	Q
	;
