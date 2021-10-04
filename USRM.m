USRM	; SLC/JER - User class membership library ;10/16/1998 11/16/09
	;;1.0;AUTHORIZATION/SUBSCRIPTION;**3,10,33**;Jun 20, 1997;Build 7
UPDATE(ITEM)	; Updates list following edit
	N USRDA,USRDUZ,USRSIGNM,USREFF,USREXP,USRMEM,USRREC,USRCLNM
	S USRDA=$P(ITEM,U,2)
	S USRMEM=$G(^USR(8930.3,+USRDA,0))
	;If membership was removed, restore and quit.
	I USRMEM="" D RESTORE^VALM10(+ITEM) Q
	S USRDUZ=+USRMEM,USRSIGNM=$$SIGNAME^USRLS(+USRDUZ)
	S USRCLNM=$$CLNAME^USRLM(+$P(USRMEM,U,2),1)
	S USREFF=$$DATE^USRLS(+$P(USRMEM,U,3),"MM/DD/YY")
	S USREXP=$$DATE^USRLS(+$P(USRMEM,U,4),"MM/DD/YY")
	S USRREC=$$SETFLD^VALM1(+ITEM,"","NUMBER")
	S USRREC=$$SETFLD^VALM1(USRSIGNM,USRREC,"MEMBER")
	S USRREC=$$SETFLD^VALM1(USREFF,USRREC,"EFFECTIVE")
	S USRREC=$$SETFLD^VALM1(USREXP,USRREC,"EXPIRES")
	S USRREC=$$SETFLD^VALM1(USRCLNM,USRREC,"CLASS")
	S ^TMP("USRMMBR",$J,+ITEM,0)=USRREC
	D RESTORE^VALM10(+ITEM),CNTRL^VALM10(+ITEM,1,VALM("RM"),IOINHI,IOINORM)
	Q
