YSSITE	;SLC/DJP,HIOFO/FT - Entry & Edit of Mental Health System Site Specific Files ;9/15/11 10:28 am
	;;5.01;MENTAL HEALTH;**60**;Dec 30, 1994;Build 47
	;
	;No external references
	;
ENREA	; Called from MENU option YS SITE-FILE 615.5
	;FILE 615.5 - S/R REASONS
	N DIC,DIE,DA,DR,DLAYGO,X,Y,YFN
	S DLAYGO=615.5,DIC="^YSR(615.5,",DIC(0)="AEQLM"
	D ^DIC Q:Y'>0
	S (DA,YFN)=+Y,DIE=DIC,DR=.01
	L +^YSR(615.5,DA):DILOCKTM
	I '$T D ERRMSG Q
	D ^DIE
	L -^YSR(615.5,YFN)
	Q
ENCAT	; Called from MENU option YS SITE-FILE 615.6
	;FILE 615.6 - S/R CATEGORY
	N DIC,DIE,DA,DR,DLAYGO,X,Y,YFN
	S DLAYGO=615.6,DIC="^YSR(615.6,",DIC(0)="AEQLM"
	D ^DIC Q:Y'>0
	S (DA,YFN)=+Y,DIE=DIC,DR=.01
	L +^YSR(615.6,YFN):DILOCKTM
	I '$T D ERRMSG Q
	D ^DIE
	L -^YSR(615.6,YFN)
	Q
ENRELC	; Called from MENU option YS SITE-FILE 615.7
	;FILE 615.7 - S/R REL CRITERIA
	N DIC,DIE,DA,DR,DLAYGO,X,Y,YFN
	S DLAYGO=615.7,DIC="^YSR(615.7,",DIC(0)="AEQML"
	D ^DIC Q:Y'>0
	S (YFN,DA)=+Y,DIE=DIC,DR=.01
	L +^YSR(615.7,YFN):DILOCKTM
	I '$T D ERRMSG Q
	D ^DIE
	L -^YSR(615.7,YFN)
	Q
ENALT	; Called from MENU option YS SITE-FILE 615.8
	;FILE 615.8 - S/R ALTERNATIVES
	N DIC,DIE,DA,DR,DLAYGO,X,Y,YFN
	S DLAYGO=615.8,DIC="^YSR(615.8,",DIC(0)="AEQLM"
	D ^DIC Q:Y'>0
	S (DA,YFN)=+Y,DIE=DIC,DR=.01
	L +^YSR(615.8,YFN):DILOCKTM
	I '$T D ERRMSG Q
	D ^DIE
	L -^YSR(615.8,YFN)
	Q
ENCKL	; Called from MENU option YS SITE-FILE 615.9
	N DIC,DIE,DA,DR,DLAYGO,X,Y,YFN
	S DLAYGO=615.9,DIC="^YSR(615.9,",DIC(0)="AEQLM"
	D ^DIC Q:Y'>0
	S (DA,YFN)=+Y,DIE=DIC,DR=.01
	L +^YSR(615.9,YFN):DILOCKTM
	I '$T D ERRMSG Q
	D ^DIE
	L -^YSR(615.9,YFN)
	Q
ERRMSG	;Write error message
	D EN^DDIOL("Can't lock entry now, please try again later.","","!")
	Q