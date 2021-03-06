PSJOCDC	;BIR/MV - NEW ORDER CHECKS MISC. ;6 Jun 07 / 3:37 PM
	;;5.0;INPATIENT MEDICATIONS ;**181,260**;16 DEC 97;Build 94
	;
	; Reference to ^PS(55 is supported by DBIA 2191.
	;
DC(PSGP,PSJORD,PSJCLINF)	;DC orders during Duplicate Therapy order checks
	;PSGP - Patient DFN
	;PSJORD - Order #_u/v/p
	;Save local arrays and variables to be restored after DC order(s)
	Q:'$D(PSJORD)
	S PSJDCDTF=1
	D ^PSJOCVAR
	NEW ON S ON=PSJORD
	I $$DSPORD(PSJORD,.PSJCLINF) D DCORD
	D RESTORE^PSJOCVAR
	K PSJDCDTF
	Q
DCORD	;DC order according to order type
	;PSJOCFLG is used in DC^PSJLIACT so the newly DC order during DT will not redisplay.
	NEW PSJOCFLG S PSJOCFLG=1
	I PSJORD["U" D DCUD Q
	; DC pending, active IV and complex orders
	D DC^PSJLIACT
	Q
DSPORD(PSJORD,PSJCLINF)	;Display the order about to DC and check if the user wish to DC to order
	;Returns 1 if continuing with DC the duplicate order.
	;Returns 0 if not to DC.
	; 
	NEW %
	D DSPORD^PSJOC(PSJORD,,.PSJCLINF)
	;DC^PSJOE does the DC prompt
	I PSJORD["U" Q 1
ASKDC	W !!,"Enter DC to discontinue the above order or press <RETURN> to continue:" S %=2 D TST4DC^PSGOEC W:%=2 !,"No action taken!"
	W !
	I %="" D ENDC^PSGOEM W ! G ASKDC
	I %=1 Q 1
	Q 0
DCUD	;DC a U/D order
	;Setup necessary variables needed by DC^PSJOE
	NEW PSGOEEWF,PSGSTAT,DIR,PSJDCFLG
	S PSJDCFLG=1
	S PSGSTAT=$P($G(^PS(55,PSGP,5,+PSJORD,0)),U,9)
	S PSGOEEWF="^PS(55,"_PSGP_",5,"_+PSJORD_","
	D SYSL^PSGSETU
	D DC^PSJOE(PSGP,PSJORD)
	K PSJDCFLG
	Q
