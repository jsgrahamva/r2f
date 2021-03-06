XDRMVFY	;SF-IRMFO/IHS/OHPRD/JCM - VERIFY POTENTIAL DUPLICATES ;09/30/2010
	;;7.3;TOOLKIT;**23,126**;Apr 25, 1995;Build 2
	;;Per VHA Directive 2004-038, this routine should not be modified.
	;;
	; Inserted DITC+4-6 IHS/OHPRD/JCM 3/26/91
START	;
	D DITC
	G:XDRQFLG END
	D VERIFY
	G:XDRQFLG!(XDRMSTAT="") END
	D STATUS
END	D EOJ
	Q
	;
DITC	;
	S DIT(1)=XDRMCD,DIT(2)=XDRMCD2,DFF=XDRFL,IOP=IO(0)
	D EN^DITC K IOP
	I $D(DUOUT)!($D(DTOUT))!($D(DIRUT)) S XDRQFLG=1 K DIRUT,DUOUT,DTOUT
	;*********************************
	;I $G(DUZ("AG"))="I",'XDRQFLG,XDRFL=2 D ^DPTDZCH ;IHS/OHPRD/JCM 3/26/91
	;*********************************
	Q
	;
VERIFY	; Verifies if duplicate or not.
	S XDRMSTAT=""
	S DIR(0)="S^V:VERIFIED DUPLICATE;N:VERIFIED, NOT A DUPLICATE;U:UNABLE TO MAKE DETERMINATION"
	S DIR("A")="Verification status of potential duplicate pair"
	D ^DIR K DIR
	I $D(DUOUT)!($D(DTOUT)) S XDRQFLG=1 G VERIFYX
	S XDRMSTAT=$S(Y="V":"V",Y="N":"N",1:"")
	D:XDRMSTAT="V" VERWARN^XDRRMRG1 ;p126 REM
VERIFYX	Q
	;
STATUS	;
	S DIE="^VA(15,",DA=XDRMPDA,DIE("NO^")=1,DR=".03///"_XDRMSTAT
	S:XDRMSTAT="V" XDRMRG=1,DR=DR_";.04//2"
	D ^DIE K DIE,DR,DA
	Q
	;
EOJ	;
	K DIT,DFF,IOP,XDRMSTAT,DIRUT
	Q
	;********************************************
	; EN entry point added specifically for APMFVFY for MFI
EN	;
	S XDRQFLG=0
	D DITC
	G:XDRQFLG ENX
	D VERIFY
ENX	K DIT,DFF,IOP
	Q
