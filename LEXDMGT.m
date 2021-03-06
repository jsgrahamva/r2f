LEXDMGT	;ISL/KER - Defaults - Manager/Update ;04/21/2014
	;;2.0;LEXICON UTILITY;**80**;Sep 23, 1996;Build 1
	;               
	; Global Variables
	;    None
	;               
	; External References
	;    $$GET1^DIQ          ICR   2056
	;    FILE^DID            ICR   2052
	;    HOME^%ZIS           ICR  10086
	;    ^%ZTLOAD            ICR  10063
	;               
	; LEXDICS     Filter
	; LEXDICS(0)  Filter name
	; LEXSHOW     Display
	; LEXSHOW(0)  Display name
	; LEXSUB      Vocabulary
	; LEXSUB(0)   Vocabulary name
	; LEXCTX      Shortcut Context
	; LEXCTX(0)   Shortcut Context name
	;
	; LEXAP       Application
	; LEXAPS      Multiple Applications
	; LEXDCUR     Current default value (pre-edit)
	; LEXDNAM     Default name
	; LEXDVAL     Default value
	; LEXFLD      Default field # in 757.201
	; LEXC        Counter
	; LEXS        User Service
	; LEXUSER     DUZ of user to update defaults
	;
	; Needs:
	;
	; LEXAP       Application
	; LEXOVER     Flag - Overwrite user defaults (Y/N)
	; LEXLIM      Limits (parameter for LEXMETH)
	; LEXMETH     Method, singel user, by service or all users
	;              
	Q
UPDATE	; Update user defaults
	Q:'$L($G(LEXAP))  Q:'$L($G(LEXOVER))  Q:'$L($G(LEXMETH))  Q:'$L($G(LEXLIM))
	N ZTSAVE,ZTRTN,ZTDESC,ZTIO,ZTDTH,ZTSK,Y
	S (ZTSAVE("LEXOVER"),ZTSAVE("LEXAP"),ZTSAVE("LEXMETH"),ZTSAVE("LEXLIM"))=""
	S (ZTSAVE("LEXDICS"),ZTSAVE("LEXDICS(0)"),ZTSAVE("LEXSHOW"),ZTSAVE("LEXSHOW(0)"))=""
	S (ZTSAVE("LEXSUB"),ZTSAVE("LEXSUB(0)"),ZTSAVE("LEXCTX"),ZTSAVE("LEXCTX(0)"))=""
	S ZTRTN="UPDT^LEXDMGT",ZTDESC="Up-dating User Defaults"
	S ZTDTH=$H,ZTIO="" D ^%ZTLOAD
	W:$D(ZTSK) !!,"Task has been created to update user defaults"
	W:'$D(ZTSK) !!,"Unable to create a task to update user defaults"
	D HOME^%ZIS Q
UPDT	; TaskManager entry point to Update Defaults (tasked)
	N LEXUSER,LEXDVAL,LEXDNAM,LEXFLD
	S LEXMETH=$P(LEXMETH,U,1) Q:LEXMETH=""
ONE	; Single user
	I LEXMETH="ONE" S LEXUSER=+LEXLIM D  G UPDTQ
	. Q:'$L($$GET1^DIQ(200,+($G(LEXUSER)),.01))  D BYAPPS
MULTI	; Multiple users
	N LEXRT,LEX D FILE^DID(200,,"GLOBAL NAME","LEX")
	S LEXRT=$G(LEX("GLOBAL NAME")) Q:'$L(LEXRT)
	S LEXUSER=+($O(@(LEXRT_"1)"),-1))
	F  S LEXUSER=$O(@(LEXRT_LEXUSER_")")) Q:+LEXUSER=0  D
	. Q:'$L($$GET1^DIQ(200,+($G(LEXUSER)),.01))  D BYAPPS
	G UPDTQ
BYAPPS	; Process defaults by application
	I LEXAP'[";" S LEXAP=+LEXAP D:+LEXAP>0 BYUSR Q
	I LEXAP[";" D  Q
	. N LEXC,LEXAPS S LEXAPS=LEXAP
	. F LEXC=1:1:$L(LEXAPS,";") S LEXAP=$P(LEXAPS,";",LEXC) D BYUSR
	. S LEXAP=LEXAPS
BYUSR	; Process defaults by user
	N LEXS S LEXS=$$GET1^DIQ(200,+($G(LEXUSER)),29,"I") S:LEXS="" LEXS=-1
	D:LEXMETH="ALL"!(LEXMETH="ONE") UPUSR
	D:LEXMETH="SEV"&(+LEXLIM=+LEXS) UPUSR
	I LEXMETH="SAL" D
	. I +($P(LEXLIM,U,1))>0,+($P(LEXLIM,U,1))=+LEXS D
	. . I +($P(LEXLIM,U,2))>0,+($P(LEXLIM,U,2))=+LEXL D UPUSR
	Q
UPUSR	; Update user defaults for user LEXUSER
	N LEXDCUR,LEXDVAL,LEXDNAM,LEXFLD
UPDIC	; Filter LEXDICS
	S LEXFLD=1,LEXDCUR=$G(^LEXT(757.2,LEXAP,200,LEXUSER,LEXFLD))
	S LEXDVAL=$G(LEXDICS),LEXDNAM=$G(LEXDICS(0))
	G:LEXDCUR'=""&('LEXOVER) UPSHOW D:LEXDVAL'="" SAVE
	;
UPSHOW	; Display LEXSHOW
	S LEXFLD=2,LEXDCUR=$G(^LEXT(757.2,LEXAP,200,LEXUSER,LEXFLD))
	S LEXDVAL=$G(LEXSHOW),LEXDNAM=$G(LEXSHOW(0))
	G:LEXDCUR'=""&('LEXOVER) UPSUB D:LEXDVAL'="" SAVE
	;
UPSUB	; Vocabulary LEXSUB
	S LEXFLD=3,LEXDCUR=$G(^LEXT(757.2,LEXAP,200,LEXUSER,LEXFLD))
	S LEXDVAL=$G(LEXSUB),LEXDNAM=$G(LEXSUB(0))
	G:LEXDCUR'=""&('LEXOVER) UPCON D:LEXDVAL'="" SAVE
	;
UPCON	; Shortcut Context LEXCTX
	S LEXFLD=4,LEXDCUR=$G(^LEXT(757.2,LEXAP,200,LEXUSER,LEXFLD))
	S LEXDVAL=$G(LEXCTX),LEXDNAM=$G(LEXCTX(0))
	G:LEXDCUR'=""&('LEXOVER) UPQ D:LEXDVAL'="" SAVE
	;
UPQ	; Quit update
	Q
UPDTQ	; Quit update (tasked)
	S:$D(ZTQUEUED) ZTREQ="@" Q
	Q
CLR	; Clear
	N LEXAP,LEXOVER,LEXLIM,LEXMETH
	Q
SAVE	; Save default - SET^LEXDSV(DUZ,APPLICATION,VALUE,NAME,FIELD)
	I LEXDVAL'["@" D  Q
	. D SET^LEXDSV(LEXUSER,LEXAP,LEXDVAL,LEXDNAM,LEXFLD) Q
	; Kill default - SET^LEXDSV(DUZ,APPLICATION,"@","",FIELD)
	D SET^LEXDSV(LEXUSER,LEXAP,"@","",LEXFLD) Q
