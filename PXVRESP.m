PXVRESP	;BIR/ADM - VIMM DEFAULT RESPONSE FILE UTILITIES ;04/11/2016
	;;1.0;PCE PATIENT CARE ENCOUNTER;**215**;Aug 12, 1996;Build 10
	;
	Q
DEF	; edit immunization default responses file
	N PXVDIV,PXVHD1,PXVHDR,PXVN,PXVNAME,PXVNUM,PXVOUT
	S PXVOUT=0,(DIDEL,DLAYGO)=920.05
	S PXVHD1="Enter/Edit Immunization Default Responses"
	W @IOF,!,?10,PXVHD1,!
	K DIC S DIC="^PXV(920.05,",DIC(0)="AEMLZ",DIC("A")="Select Facility: " D ^DIC
	K DIC I $D(DTOUT)!$D(DUOUT)!(X="") S PXVOUT=1 D END Q
	S PXVDIV=+Y,PXVN=+Y(0),PXVNAME=Y(0,0),PXVNUM=$$GET1^DIQ(4,PXVN,99),PXVHDR="Facility: "_PXVNAME_"  ("_PXVNUM_")"
	W @IOF,!,?10,PXVHD1,!!,PXVHDR,!
	S DA=PXVDIV,DIE=920.05,DR="1",DR(2,920.051)=".01;1302;1303;1312;1313;81101;" D ^DIE I $D(Y) D END Q
END	K DA,DIE,DIC,DIDEL,DLAYGO,DR,DTOUT,DUOUT,X,Y
	Q
	;
INST(PXVIS)	; returns facility ien in file #920.05 related to this immunization
	; PXVIS - ien of visit in file #9000010
	N PXVINST,PXVFAC,PXVHL,PXVN,PXVPRNT,PXVSTN
	S PXVFAC="",PXVN=$O(^PXV(920.05,0)) I 'PXVN Q PXVFAC
	I $G(PXVIS) D
	.S PXVHL=$P($G(^AUPNVSIT(PXVIS,0)),"^",22) I 'PXVHL Q
	.S PXVINST=$P(^SC(PXVHL,0),"^",4) I 'PXVINST Q
	.S PXVFAC=$O(^PXV(920.05,"B",PXVINST,0))
	.I 'PXVFAC D
	..S PXVSTN=$$STA^XUAF4(PXVINST) Q:PXVSTN=""
	..S PXVPRNT=$P($$PRNT^XUAF4(PXVSTN),"^")
	..S PXVFAC=$O(^PXV(920.05,"B",PXVPRNT,0))
	I 'PXVFAC,+$G(DUZ(2)) D
	.S PXVINST=$G(DUZ(2))
	.S PXVFAC=$O(^PXV(920.05,"B",PXVINST,0))
	.I 'PXVFAC D
	..S PXVSTN=$$STA^XUAF4(PXVINST) Q:PXVSTN=""
	..S PXVPRNT=$P($$PRNT^XUAF4(PXVSTN),"^")
	..S PXVFAC=$O(^PXV(920.05,"B",PXVPRNT,0))
	Q PXVFAC
